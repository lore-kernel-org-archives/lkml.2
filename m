Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789Ab2JLDbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:31:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32833 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2JLDbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:31:08 -0400
Date: Fri, 12 Oct 2012 14:30:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: linux-next: manual merge of the pinctrl tree with Linus' tree
Message-Id: <20121012143059.ed0399ec2598c495e175f876@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_14_30_59_+1100_5E/bAY9xEmFiKArQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_14_30_59_+1100_5E/bAY9xEmFiKArQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
drivers/mtd/nand/atmel_nand.c between commit 28446acb1f82 ("mtd: atmel
nand: fix gpio missing request") from Linus' tree and commit 08695153170c
("MTD: atmel nand: fix gpio missing request") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/nand/atmel_nand.c
index 9144557,f48587b..0000000
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@@ -1414,12 -585,19 +1416,20 @@@ static int __init atmel_nand_probe(stru
  	nand_chip->IO_ADDR_W =3D host->io_base;
  	nand_chip->cmd_ctrl =3D atmel_nand_cmd_ctrl;
 =20
+ 	pinctrl =3D devm_pinctrl_get_select_default(&pdev->dev);
+ 	if (IS_ERR(pinctrl)) {
+ 		dev_err(host->dev, "Failed to request pinctrl\n");
+ 		res =3D PTR_ERR(pinctrl);
+ 		goto err_ecc_ioremap;
+ 	}
+=20
  	if (gpio_is_valid(host->board.rdy_pin)) {
- 		res =3D gpio_request(host->board.rdy_pin, "nand_rdy");
+ 		res =3D devm_gpio_request(&pdev->dev,
+ 				host->board.rdy_pin, "nand_rdy");
  		if (res < 0) {
  			dev_err(&pdev->dev,
 -				"can't request rdy gpio %d\n", host->board.rdy_pin);
 +				"can't request rdy gpio %d\n",
 +				host->board.rdy_pin);
  			goto err_ecc_ioremap;
  		}
 =20
@@@ -1435,11 -612,11 +1444,12 @@@
  	}
 =20
  	if (gpio_is_valid(host->board.enable_pin)) {
- 		res =3D gpio_request(host->board.enable_pin, "nand_enable");
+ 		res =3D devm_gpio_request(&pdev->dev,
+ 				host->board.enable_pin, "nand_enable");
  		if (res < 0) {
  			dev_err(&pdev->dev,
 -				"can't request enable gpio %d\n", host->board.enable_pin);
 +				"can't request enable gpio %d\n",
 +				host->board.enable_pin);
  			goto err_ecc_ioremap;
  		}
 =20
@@@ -1465,11 -664,11 +1475,12 @@@
  	atmel_nand_enable(host);
 =20
  	if (gpio_is_valid(host->board.det_pin)) {
- 		res =3D gpio_request(host->board.det_pin, "nand_det");
+ 		res =3D devm_gpio_request(&pdev->dev,
+ 				host->board.det_pin, "nand_det");
  		if (res < 0) {
  			dev_err(&pdev->dev,
 -				"can't request det gpio %d\n", host->board.det_pin);
 +				"can't request det gpio %d\n",
 +				host->board.det_pin);
  			goto err_no_card;
  		}
 =20

--Signature=_Fri__12_Oct_2012_14_30_59_+1100_5E/bAY9xEmFiKArQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd47zAAoJEECxmPOUX5FEfJAP/i6gB1/y8Jj1kcZcp7RGEiE1
4vnR0PjYNY11kbDJXF0zLha7A7V12EPbzZ0qMfHAmSaWc9J/mkskAkmsgv4WigXJ
CB5CcFPhzXiXN9Fz617NTbbp/YMSy5e9MickR0L4zDtA9PL1nTnqnqgevawnpQel
3xC3yyo3FcFV3IopnOfnkjKLIkT29bIXfgWTllEyyEncP4uXGAc8Qg/ByWO9FGHp
uEzDzma/ONgbXlb88ZPb6OxuZdDIAuU35fdM6j7nDdiapyOfox56oGMZPsAAxYQS
Qs9xe+dL76TwBYD0S/uK6We16+8ryPtatLICByDeysRUnuvmT0b1p9dypc7Zflpb
/wZ7MMtrW/CHIflhLmYhKUuhqjNkvmrmrD2t5UzeFes/NxS3SQEPvwzZMGIsAyN1
vMaFdolCmm85bsq9gsuHzEz3pcg04ulFD5irRfVr/KmO0gbC46ei5/VNFoDQ6StJ
4ceMker+LQ1IwSUBrGd9W7ISLZwUZxIAwYu76sJH3i4liQzKTOZM+1pgiVUwxPg2
DGHW9VpRQR9nu24GHAnighK8K39TRkGWGhLIBlb4KC6LtxJ4C22WZsdhMOBFHold
nUzgmx0ZchfFolmhF95biA99inbwqxXTWK+ft5vOS2WcSoKZEctfzk204kc8ZW3l
41sncSh++qJRHstl6rHE
=S1SM
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_14_30_59_+1100_5E/bAY9xEmFiKArQ--
