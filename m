Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0IPCyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 22:54:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44025 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab0IPCyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 22:54:54 -0400
Date: Thu, 16 Sep 2010 12:54:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gary King <gking@nvidia.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20100916125447.08698025.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_12_54_47_+1000_F3Yw+7I8PVteBaEE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_12_54_47_+1000_F3Yw+7I8PVteBaEE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/built-in.o: In function `__tps6586x_read':
tps6586x.c:(.text+0xe4151): undefined reference to `i2c_smbus_read_byte_dat=
a'
drivers/built-in.o: In function `__tps6586x_write':
tps6586x.c:(.text+0xe4345): undefined reference to `i2c_smbus_write_byte_da=
ta'
drivers/built-in.o: In function `tps6586x_reads':
(.text+0xe4762): undefined reference to `i2c_smbus_read_i2c_block_data'
drivers/built-in.o: In function `tps6586x_writes':
(.text+0xe4894): undefined reference to `i2c_smbus_write_i2c_block_data'
drivers/built-in.o: In function `tps6586x_init':
tps6586x.c:(.init.text+0xc511): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `tps6586x_i2c_probe':
tps6586x.c:(.devinit.text+0x4ae6): undefined reference to `i2c_smbus_read_b=
yte_data'
drivers/built-in.o: In function `tps6586x_exit':
tps6586x.c:(.exit.text+0x574): undefined reference to `i2c_del_driver'

Caused by commit 2d0a9a6d922712267ef62a5e8b38ed2b37cf45cc ("mfd: Add
basic tps6586x interrupt support").  Presumably a missing dependency.

I have used the mfd tree from next-20100915 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_12_54_47_+1000_F3Yw+7I8PVteBaEE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkYb3AAoJEDMEi1NhKgbsN3oH/AyrGavm4a1WJIRGM2ddlyjs
e56TF3x3o8fb4mJaC2ZHWWQcJpRZvse1LwytC/eMbtnBoWPKYevZ/Pxb4VFvFv7R
mw6A1UXlfmJjdv7EvUs8b1RpchkF2Jwmn6HrRtex/IeepmKPffLZdoKOCrxU967B
uCfXlj+DVZXfS1m57U9e3NryRml+Q/Je2JF4eL3zF6GYpPEoZq1t3nvqdeWlkyTx
5IIRzuVPygI9hF7TTgQ6BNWImTr3wXqirRDDVBsQMUuI5vyfLN4rOL8tHO2DVFJQ
ZuFKiVt93k7IC+dl322bJg1wwoPpWSXd9zYq706T7u7+6GA1+i68fnqFgIir3tM=
=bLLT
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_12_54_47_+1000_F3Yw+7I8PVteBaEE--
