Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2IMGle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:41:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42595 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2IMGlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:41:32 -0400
Date: Thu, 13 Sep 2012 16:41:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the i2c-embedded
 tree
Message-Id: <20120913164120.cde08ac1517e641386b147d8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_16_41_20_+1000_VMrHnCLIEgtYeVlB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_16_41_20_+1000_VMrHnCLIEgtYeVlB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/i2c/busses/i2c-omap.c between commit d9ebd04d3476 ("i2c: omap:
switch to devm_* API") from the i2c-embedded tree and commit 07baca6f8fc2
("i2c/i2c-omap: add a const qualifier") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/i2c/busses/i2c-omap.c
index c78431a,a0e49f6..0000000
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@@ -1051,11 -943,12 +1051,12 @@@ omap_i2c_probe(struct platform_device *
  {
  	struct omap_i2c_dev	*dev;
  	struct i2c_adapter	*adap;
 -	struct resource		*mem, *irq, *ioarea;
 +	struct resource		*mem;
- 	struct omap_i2c_bus_platform_data *pdata =3D pdev->dev.platform_data;
+ 	const struct omap_i2c_bus_platform_data *pdata =3D
+ 		pdev->dev.platform_data;
  	struct device_node	*node =3D pdev->dev.of_node;
  	const struct of_device_id *match;
 -	irq_handler_t isr;
 +	int irq;
  	int r;
 =20
  	/* NOTE: driver uses the static register mapping */

--Signature=_Thu__13_Sep_2012_16_41_20_+1000_VMrHnCLIEgtYeVlB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUYAQAAoJEECxmPOUX5FEo8oQAJg6Ps4H7J80Hs1xQBZrsqcf
xM6JpyIwoMHMMo1I7xog2feqUZE7T6xZ726lKLkbQi6VEvmeSJavSQKCiBme3MWY
hccPPzs1kQyciFXbgpJCdSlc+5xZ+LnYqa0Uk+MQeCzwe4TqoB3qOIWsXKZO5SfN
PwydmtM0oek+XXCFABE79kSngDCht1R5IhspzpODPSdKScXaT5kGHGxy+9wgAmX9
aO9ciIihf4GqzsI2QvgDHEjHJLCWKXOIRgIOdfM2Ew++gXF8zIWG2mx3KzKO3JEn
Ic+cp35KfyZ69BFL1XDLp4W7BuUOfcY03AShiefKAyJUkGsA3Cbp+5vY7syiV5tT
Sq6naVmhyOu4M5ikjVIzAuH/QyCqxolzmJdur/Ixri6Nom4ZgikUKEhdjOtiJBPj
Xiv4FMEH+OoF/MwltnH4kupn+c2cVcxP4YXTyzyj89pqBIwbjkFW2UMzT5UJtAHo
20wAmyV+8cMEkrz7R45exZDten92uarokVBsgTz0uSIbYtF9ibqUZLb3P/t+sOPf
6Og4s99jQ7SG+UtrxvQJORmtybQRxzbt1wYpLacVnWLAsbprCU5a8TPsPHjuRUTS
OIrKCHFZRcXmoqQHzeM04RwN24KMaLNaRuieF18mzFLXqMjTv9VI1g9VsCPtUFSR
qoLxRrmda/JuvLYLhpJ1
=7ZGf
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_16_41_20_+1000_VMrHnCLIEgtYeVlB--
