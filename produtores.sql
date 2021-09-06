create table metodo_pagamento(
	cod_metodo int,
	nome varchar(20) not null,
	primary key(cod_metodo),
	unique(nome)
);

create table contato (
	cod_contato int,
	tipo bit not null, -- físico/jurídico
	nome varchar(50) not null,
	sobrenome varchar(50),
	email varchar(40),
	cpf varchar(16),
	cnpj varchar(20),
	primary key(cod_contato),
	unique(cpf),
	unique(cnpj),
	unique(email)
);

create table telefone_contato(
	cod_telefone int,
	cod_contato int,
	telefone varchar(14) not null, -- (xx)xxxxx-xxxx
	primary key(cod_telefone),
	foreign key(cod_contato) references contato
);

create table especie(
	cod_especie int, 
	nome_especie varchar(20) not null,
	primary key(cod_especie),
	unique(nome_especie)
);

create table plantacao (
	cod_plantacao int,
	area numeric(9, 2),
	rua varchar(25),
	numero int,
	bairro varchar(25) not null,
	cidade varchar(30) not null,
	complemento varchar(30),
	primary key (cod_plantacao)
);

create table movimentacao(
	cod_movimentacao int,
	cod_contato int,
	cod_metodo int,
	valor numeric(9, 2) not null,
	data_movimentacao date not null,
	tipo bit not null, 
	primary key(cod_movimentacao),
	foreign key(cod_contato) references contato,
	foreign key(cod_metodo) references metodo_pagamento
);

create table produto (
	cod_produto int,
	descricao varchar(40) not null,
	tipo int not null, -- 0:animal, 1:safra, 2: outros
	cod_movimentacao int,
	primary key(cod_produto),
	foreign key(cod_movimentacao) references movimentacao,
	check(tipo >= 0),
	check(tipo <=2)
);

create table animal(
	cod_produto int,
	chip varchar(10),
	cod_especie int,
	primary key(cod_produto),
	foreign key(cod_produto) references produto,
	foreign key(cod_especie) references especie,
	unique(chip)
);

create table safra(
	cod_produto int,
	ano date not null,
	cultura varchar(30) not null,
	toneladas numeric(6, 2),
	primary key(cod_produto),
	foreign key(cod_produto) references produto,
	check(toneladas > 0)
);
	
create table gera_safra(
	cod_produto int,
	cod_plantacao int,
	primary key(cod_produto, cod_plantacao),
	foreign key(cod_produto) references safra,
	foreign key(cod_plantacao) references plantacao
);

-- inserts usados para teste
insert into metodo_pagamento values (1, 'Cartao de debito')
insert into metodo_pagamento values (2, 'Cartao de credito')
insert into contato values (1, '0', 'José', 'Pereira', 'josepereira@exemplo.com', '123.123.123-12', null)
insert into contato values (2, '1', 'Coop. Agricultores', null, 'ccopag@exemplo.com', null, '12.123.123')
insert into telefone_contato values (1, 1, '(14)11111-1111')
insert into telefone_contato values (2, 1, '(14)22222-2222')
insert into telefone_contato values (3, 1, '(11)11111-1111')
insert into telefone_contato values (4, 2, '(13)11111-1111')
insert into plantacao values (1, 12.4, null, null, 'Santa Rita', 'Fartura', null)
insert into plantacao values (2, 24.7, null, null, 'Vila Velha', 'Timburi', null)
insert into movimentacao values (1, 1, 1, 2300, '2021-08-30', '0')
insert into produto values (1, 'Pacote de sementes', 2, 1)
insert into movimentacao values (2, 2, 1, 32.30, '2021-09-03', '1')
insert into produto values (2, 'Saco de quirera', 2, 2)
insert into produto values (3, 'Angola Branca', 0, null)
insert into especie values (1, 'Aves')
insert into especie values (2, 'Bovino')
insert into animal values (3, 'ABC123', 1)
insert into produto values (4, 'Safra de café', 1, null)
insert into safra values (4, '2021-01-01', 'café', 0.2)
insert into gera_safra values (4, 2)
select * from produto, animal where cod_produto(produto)=cod_produto(animal) and tipo=0
select * from produto, safra where cod_produto(produto)=cod_produto(safra) and tipo=1
select descricao, cultura, toneladas, bairro from safra, gera_safra, plantacao, produto
	where cod_produto(gera_safra)=cod_produto(safra) 
		and cod_plantacao(gera_safra)=cod_plantacao(plantacao)
		and cod_produto(safra)=cod_produto(produto)
-- dois produtos comprados em 1 movimentacao
select * from movimentacao
select descricao, valor, data_movimentacao, tipo(movimentacao), cod_movimentacao(movimentacao)
	from produto, movimentacao
	where cod_movimentacao(movimentacao)=cod_movimentacao(produto)
	and tipo(movimentacao)='1'
insert into movimentacao values (3, 2, 1, 32405.30, '2021-09-01', '1')
insert into produto values (5, 'Trator', 2, 3)
insert into produto values (6, 'Carreta', 2, 3)
