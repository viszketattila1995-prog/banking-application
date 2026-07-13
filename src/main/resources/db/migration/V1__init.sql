-- =========================================================
-- V1__init.sql
-- Kezdeti séma: users, user_roles, customers
-- =========================================================


-- ---------------------------------------------------------
-- users
-- Belépéshez szükséges adatok. Minden belépő ember itt van:
-- ügyfél és admin egyaránt.
-- ---------------------------------------------------------
CREATE TABLE users (
                       id          BIGSERIAL       PRIMARY KEY,
                       email       VARCHAR(255)    NOT NULL UNIQUE,
                       password    VARCHAR(255)    NOT NULL,
                       status      VARCHAR(20)     NOT NULL,
                       created_at  TIMESTAMPTZ     NOT NULL
);


-- ---------------------------------------------------------
-- user_roles
-- Egy user több szerepkört is kaphat -> több sor ugyanarra
-- a user_id-ra. Ezt generálja az @ElementCollection.
--
-- Nincs saját id oszlop: a szerepkör nem önálló entitás,
-- csak egy érték, ami a userhez tartozik.
-- ---------------------------------------------------------
CREATE TABLE user_roles (
                            user_id     BIGINT          NOT NULL,
                            role        VARCHAR(20)     NOT NULL,

                            CONSTRAINT pk_user_roles
                                PRIMARY KEY (user_id, role),

                            CONSTRAINT fk_user_roles_user
                                FOREIGN KEY (user_id)
                                    REFERENCES users (id)
                                    ON DELETE CASCADE
);


-- ---------------------------------------------------------
-- customers
-- Ügyféladatok. Csak azoknak a usereknek van sora itt,
-- akik ügyfelek is. Az adminnak nincs.
--
-- user_id: az idegen kulcs. NOT NULL, mert minden customer
-- tartozik egy userhez. UNIQUE, mert egy userhez legfeljebb
-- egy customer tartozhat (= one-to-one).
-- ---------------------------------------------------------
CREATE TABLE customers (
                           id                      BIGSERIAL       PRIMARY KEY,
                           user_id                 BIGINT          NOT NULL UNIQUE,
                           first_name              VARCHAR(100)    NOT NULL,
                           last_name               VARCHAR(100)    NOT NULL,
                           birth_date              DATE            NOT NULL,
                           birth_place             VARCHAR(150)    NOT NULL,
                           mother_name             VARCHAR(200)    NOT NULL,
                           identity_card_number    VARCHAR(50)     NOT NULL UNIQUE,
                           tax_number              VARCHAR(50)     NOT NULL UNIQUE,
                           address                 VARCHAR(255)    NOT NULL,
                           phone_number            VARCHAR(30)     NOT NULL,

                           CONSTRAINT fk_customers_user
                               FOREIGN KEY (user_id)
                                   REFERENCES users (id)
);


-- ---------------------------------------------------------
-- Indexek
-- Az email-t minden bejelentkezésnél keresed. A UNIQUE
-- megszorítás automatikusan létrehoz egy indexet, tehát
-- külön index nem kell rá.
-- ---------------------------------------------------------