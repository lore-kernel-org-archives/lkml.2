Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2K2Dun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:50:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50779 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2K2Dul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:50:41 -0500
Date: Thu, 29 Nov 2012 14:50:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the driver-core tree with the mfd tree
Message-Id: <20121129145039.dc5c58ab8990d7ffe35d3291@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_14_50_39_+1100_aLem9T0CtKHE+06+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_14_50_39_+1100_aLem9T0CtKHE+06+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/mfd/da9052-core.c between commit 8bad1abd6303 ("mfd: da9052:
Introduce da9052-irq.c") from the mfd tree and commit a9e9ce4c4167 ("mfd:
remove use of __devinitdata") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/da9052-core.c
index 2153f9bb,689b747..0000000
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@@ -427,7 -447,75 +427,7 @@@ int da9052_adc_read_temp(struct da9052=20
  }
  EXPORT_SYMBOL_GPL(da9052_adc_read_temp);
 =20
- static struct mfd_cell __devinitdata da9052_subdev_info[] =3D {
 -static struct resource da9052_rtc_resource =3D {
 -	.name =3D "ALM",
 -	.start =3D DA9052_IRQ_ALARM,
 -	.end   =3D DA9052_IRQ_ALARM,
 -	.flags =3D IORESOURCE_IRQ,
 -};
 -
 -static struct resource da9052_onkey_resource =3D {
 -	.name =3D "ONKEY",
 -	.start =3D DA9052_IRQ_NONKEY,
 -	.end   =3D DA9052_IRQ_NONKEY,
 -	.flags =3D IORESOURCE_IRQ,
 -};
 -
 -static struct resource da9052_bat_resources[] =3D {
 -	{
 -		.name =3D "BATT TEMP",
 -		.start =3D DA9052_IRQ_TBAT,
 -		.end   =3D DA9052_IRQ_TBAT,
 -		.flags =3D IORESOURCE_IRQ,
 -	},
 -	{
 -		.name =3D "DCIN DET",
 -		.start =3D DA9052_IRQ_DCIN,
 -		.end   =3D DA9052_IRQ_DCIN,
 -		.flags =3D IORESOURCE_IRQ,
 -	},
 -	{
 -		.name =3D "DCIN REM",
 -		.start =3D DA9052_IRQ_DCINREM,
 -		.end   =3D DA9052_IRQ_DCINREM,
 -		.flags =3D IORESOURCE_IRQ,
 -	},
 -	{
 -		.name =3D "VBUS DET",
 -		.start =3D DA9052_IRQ_VBUS,
 -		.end   =3D DA9052_IRQ_VBUS,
 -		.flags =3D IORESOURCE_IRQ,
 -	},
 -	{
 -		.name =3D "VBUS REM",
 -		.start =3D DA9052_IRQ_VBUSREM,
 -		.end   =3D DA9052_IRQ_VBUSREM,
 -		.flags =3D IORESOURCE_IRQ,
 -	},
 -	{
 -		.name =3D "CHG END",
 -		.start =3D DA9052_IRQ_CHGEND,
 -		.end   =3D DA9052_IRQ_CHGEND,
 -		.flags =3D IORESOURCE_IRQ,
 -	},
 -};
 -
 -static struct resource da9052_tsi_resources[] =3D {
 -	{
 -		.name =3D "PENDWN",
 -		.start =3D DA9052_IRQ_PENDOWN,
 -		.end   =3D DA9052_IRQ_PENDOWN,
 -		.flags =3D IORESOURCE_IRQ,
 -	},
 -	{
 -		.name =3D "TSIRDY",
 -		.start =3D DA9052_IRQ_TSIREADY,
 -		.end   =3D DA9052_IRQ_TSIREADY,
 -		.flags =3D IORESOURCE_IRQ,
 -	},
 -};
 -
+ static struct mfd_cell da9052_subdev_info[] =3D {
  	{
  		.name =3D "da9052-regulator",
  		.id =3D 1,

--Signature=_Thu__29_Nov_2012_14_50_39_+1100_aLem9T0CtKHE+06+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQttuPAAoJEECxmPOUX5FEkJIQAIWyF7JYVoCw51eUvctJkufH
S+G6T8O+QzxRjyDzfjYDsC8D2WrND6Ad8qNGMW2rIfA0FGwrDa5Cvy0XkXLjr9WS
3TDMbYkrc94tNvqYRf7EU9ODosGLZn/UMVoBmjaQolGbCSDoVUCBDlKOor1/PMYJ
eEJjR6oiTXIDTx4xmQEQo8QGhJdT/sxw/MLJMrf1rVtyTkbU00BxIocOjxq2MHps
e/pZrHV7jSIzu9FKLi/YEfb3n/XcG9j7pk4Y/ggOODeWFBvZuqgKPKs6SUIbKaQW
gEhLU5pXKCngGHeerK9xmN34cR5B0g2gqAuU49P5QCy7qx9kvEphbuSly7Q+g03x
Hnh1pgTtFyVhVVCKi4r19iBq5mEX96bLZk8cQXNNcTO9ELgyBbVBi9VO8DbXxrkl
t/o7RmepR8aUT3ky7mZ+M4uZy3VZ6fnCD1xZC2glfcwSCgoEV32y3vj6cBeJukO0
ds1jkIlEj4SGy7eyM/uoVkdTUI7ff+J3IRFntnvXzgb3yWneHHNhvtLhDIzacYkt
hKGBNMFEtwJ21cT95HCb2PUm0cpn5//etrOjahUlmmLMx/jBtvBbD+yo4SREgYFU
KdjnOTXXkspIgzJvDX3ehzU86wXqULlloTSsX/sO7VVa8OeG/u5/8/dZAMNfYQX4
j42gIDvZA/ok57wP5Lh6
=vZgD
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_14_50_39_+1100_aLem9T0CtKHE+06+--
