CREATE TABLE Role_list
(
    role_id   SERIAL      NOT NULL PRIMARY KEY,
    role_name varchar(20) NOT NULL
);

CREATE TABLE Application_user
(
    user_id  SERIAL      NOT NULL PRIMARY KEY,
    login    varchar(20) NOT NULL UNIQUE,
    password varchar(20) NOT NULL,
    role     varchar(20) NOT NULL,
    role_id  int         NOT NULL
);

CREATE TABLE Patient
(
    patient_id                  SERIAL      NOT NULL PRIMARY KEY,
    firstname                   varchar(30) NOT NULL,
    midname                     varchar(30) NOT NULL,
    lastname                    varchar(30) NOT NULL,
    date_of_birth               date        NOT NULL,
    passport_data               varchar(10) UNIQUE,
    email                       varchar(40) NOT NULL,
    phone_number                varchar(15) NOT NULL,
    child_birth_cert_data       varchar(20) UNIQUE,
    international_passport_data varchar(20) UNIQUE,
    user_id                     INT         NOT NULL
);

CREATE TABLE Doctor
(
    doctor_id      SERIAL      NOT NULL PRIMARY KEY,
    firstname      varchar(30) NOT NULL,
    midname        varchar(30) NOT NULL,
    lastname       varchar(30) NOT NULL,
    date_of_birth  date        NOT NULL,
    passport_data  varchar(10) UNIQUE,
    email          varchar(40) NOT NULL,
    phone_number   varchar(15) NOT NULL,
    specialization varchar(40) NOT NULL,
    user_id        int         NOT NULL
);

CREATE TABLE Cabinet
(
    cabinet_number varchar(10) NOT NULL PRIMARY KEY UNIQUE,
    cabinet_name   varchar(30) NOT NULL
);

CREATE TABLE Total_writeoff_list
(
    total_writeoff_list_id SERIAL NOT NULL PRIMARY KEY,
    writeoff_ammount       int,
    total_price            int,
    object_id              int    NOT NULL
);
CREATE TABLE Visit
(
    visit_id               SERIAL      NOT NULL PRIMARY KEY,
    date_of_visit          date        NOT NULL,
    patient_id             INT         NOT NULL,
    total_writeoff_list_id INT,
    cabinet_number         varchar(10) NOT NULL,
    doctor_id              INT         NOT NULL
);

CREATE TABLE Service
(
    service_id       SERIAL      NOT NULL PRIMARY KEY,
    service_name     varchar(20) NOT NULL,
    service_price    int         NOT NULL,
    writeoff_list_id int         NOT NULL
);

CREATE TABLE Writeoff_list
(
    writeoff_list_id SERIAL NOT NULL PRIMARY KEY,
    writeoff_amount  int,
    object_id        int    NOT NULL,
    service_id       int    not null
);
CREATE TABLE Service_visit
(
    ServiceVisit_id SERIAL NOT NULL PRIMARY KEY,
    service_id      int    NOT NULL,
    visit_id        int    NOT NULL
);

CREATE TABLE Medical_object
(
    object_id              SERIAL NOT NULL PRIMARY KEY,
    date_of_object_release date   NOT NULL,
    shelf_life             date   NOT NULL,
    price                  int    NOT NULL,
    ammount                int    NOT NULL,
    series                 varchar(40),
    object_name_id         INT    NOT NULL,
    supply_id              INT    NOT NULL
);

CREATE TABLE Object_name
(
    object_name_id SERIAL      NOT NULL PRIMARY KEY,
    type           varchar(10) NOT NULL,
    object_name    varchar(40) NOT NULL
);

CREATE TABLE Suppliers
(
    suppliers_id   SERIAL      NOT NULL PRIMARY KEY,
    suppliers_name varchar(50) NOT NULL,
    INN            varchar(10) NOT NULL UNIQUE,
    OGRN           varchar(13) NOT NULL UNIQUE,
    URL            varchar
);

CREATE TABLE Supply
(
    supply_id      SERIAL NOT NULL PRIMARY KEY,
    suppliers_id   INT    NOT NULL,
    date_of_supply date   NOT NULL,
    supply_list_id int    NOT NULL
);

CREATE TABLE Supply_list
(
    supply_list_id         SERIAL NOT NULL PRIMARY KEY,
    object_name_id         INT    NOT NULL,
    series                 varchar(40),
    date_of_device_release date   NOT NULL,
    shelf_life             date   NOT NULL,
    price                  int    NOT NULL,
    ammount                int    NOT NULL
);
ALTER TABLE Application_user
    ADD CONSTRAINT fk_role_id FOREIGN KEY (role_id) REFERENCES Role_list (role_id);
ALTER TABLE Patient
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES Application_user (user_id);
ALTER TABLE Doctor
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES Application_user (user_id);
ALTER TABLE Total_writeoff_list
    ADD CONSTRAINT fk_object_id FOREIGN KEY (object_id) REFERENCES Medical_object (object_id);
ALTER TABLE Total_writeoff_list
    ADD CONSTRAINT check_total_price CHECK ( total_price >= 0 );
ALTER TABLE Total_writeoff_list
    ADD CONSTRAINT check_amount CHECK ( writeoff_ammount >= 0);
ALTER TABLE Service
    ADD CONSTRAINT check_service_price CHECK ( service_price >= 0 );
ALTER TABLE Visit
    ADD CONSTRAINT fk_total_writeoff_list_id FOREIGN KEY (total_writeoff_list_id) REFERENCES Total_writeoff_list (total_writeoff_list_id);
ALTER TABLE Visit
    ADD CONSTRAINT fk_patient_id FOREIGN KEY (patient_id) REFERENCES Patient (patient_id);
ALTER TABLE Visit
    ADD CONSTRAINT fk_cabinet_number FOREIGN KEY (cabinet_number) REFERENCES Cabinet (cabinet_number);
ALTER TABLE Visit
    ADD CONSTRAINT fk_doctor_id FOREIGN KEY (doctor_id) REFERENCES Doctor (doctor_id);
ALTER TABLE Writeoff_list
    ADD CONSTRAINT fk_service_id FOREIGN KEY (service_id) REFERENCES Service (service_id);
ALTER TABLE Writeoff_list
    ADD CONSTRAINT fk_object_id FOREIGN KEY (object_id) REFERENCES Medical_object (object_id);
ALTER TABLE Service_visit
    ADD CONSTRAINT fk_service_id FOREIGN KEY (service_id) REFERENCES Service (service_id);
ALTER TABLE Service_visit
    ADD CONSTRAINT fk_visit_id FOREIGN KEY (visit_id) REFERENCES Visit (visit_id);
ALTER TABLE Medical_object
    ADD CONSTRAINT fk_object_id FOREIGN KEY (object_name_id) REFERENCES Object_name (object_name_id);
ALTER TABLE Medical_object
    ADD CONSTRAINT fk_supply_id FOREIGN KEY (supply_id) REFERENCES supply (supply_id);
ALTER TABLE Medical_object
    ADD CONSTRAINT check_price CHECK ( price >= 0 );
ALTER TABLE Medical_object
    ADD CONSTRAINT check_amount CHECK ( ammount >= 0 );
ALTER TABLE Supply
    ADD CONSTRAINT fk_suppliers_id FOREIGN KEY (suppliers_id) REFERENCES Suppliers (suppliers_id);
ALTER TABLE Supply
    ADD CONSTRAINT fk_supply_list_id FOREIGN KEY (supply_list_id) REFERENCES Supply_list (supply_list_id);
ALTER TABLE Supply_list
    ADD CONSTRAINT fk_object_name_id FOREIGN KEY (object_name_id) REFERENCES Object_name (object_name_id);
ALTER TABLE Supply_list
    ADD CONSTRAINT check_price CHECK ( price >= 0 );
ALTER TABLE Supply_list
    ADD CONSTRAINT check_ammount CHECK ( ammount >= 0 );