Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2KZImn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:42:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36086 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2KZIml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:42:41 -0500
Date: Mon, 26 Nov 2012 19:42:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Bo Shen <voice.shen@atmel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: linux-next: manual merge of the char-misc tree with the sound-asoc
 tree
Message-Id: <20121126194229.feef81574cac8e860cf68df9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_19_42_29_+1100_V/gP0SIr4PK3kDVn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_19_42_29_+1100_V/gP0SIr4PK3kDVn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/misc/atmel-ssc.c between commit 5c86ac695c7e ("ASoC: atmel-ssc:
use module_platform_driver macro") from the sound-asoc tree and commit
2d6bed9ca93e ("drivers/misc: remove use of __devexit_p") from the
char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/misc/atmel-ssc.c
index d07a9ed,c58f9ab..0000000
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@@ -186,10 -125,19 +186,10 @@@ static int ssc_probe(struct platform_de
  	dev_info(&pdev->dev, "Atmel SSC device at 0x%p (irq %d)\n",
  			ssc->regs, ssc->irq);
 =20
 -	goto out;
 -
 -out_unmap:
 -	iounmap(ssc->regs);
 -out_clk:
 -	clk_put(ssc->clk);
 -out_free:
 -	kfree(ssc);
 -out:
 -	return retval;
 +	return 0;
  }
 =20
- static int __devexit ssc_remove(struct platform_device *pdev)
+ static int ssc_remove(struct platform_device *pdev)
  {
  	struct ssc_device *ssc =3D platform_get_drvdata(pdev);
 =20
@@@ -204,13 -155,21 +204,13 @@@ static struct platform_driver ssc_drive
  	.driver		=3D {
  		.name		=3D "ssc",
  		.owner		=3D THIS_MODULE,
 +		.of_match_table	=3D of_match_ptr(atmel_ssc_dt_ids),
  	},
 +	.id_table	=3D atmel_ssc_devtypes,
 +	.probe		=3D ssc_probe,
- 	.remove		=3D __devexit_p(ssc_remove),
++	.remove		=3D ssc_remove,
  };
 -
 -static int __init ssc_init(void)
 -{
 -	return platform_driver_probe(&ssc_driver, ssc_probe);
 -}
 -module_init(ssc_init);
 -
 -static void __exit ssc_exit(void)
 -{
 -	platform_driver_unregister(&ssc_driver);
 -}
 -module_exit(ssc_exit);
 +module_platform_driver(ssc_driver);
 =20
  MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
  MODULE_DESCRIPTION("SSC driver for Atmel AVR32 and AT91");

--Signature=_Mon__26_Nov_2012_19_42_29_+1100_V/gP0SIr4PK3kDVn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsyt1AAoJEECxmPOUX5FEKIoP/REE4zBqAV/hrWx8M1QNw/SI
Qdn5w/ZeWbfAkx1+CNysbQqmXj/VZDIxW4OZWPjLYMfKwuCuojKzdYoUPcnJASh3
tvp10w7OOlO2GlllR9QlJcZ2Tmkn7xhiY2YUbBc3hfJLNcpWEXYh9OTjaBaC1v8C
BrfnS7D0JfZxindULwRNaKjG9KqL9DxjGMA/FvQ24ndp2r6+Jr3BGeP2loBqxNgE
CHTUSJ+2eKVLPWI7zVAVDU4zWZ3coy57XZDNEPkfp56k0IXWA0hL6ChIuXu+L/V+
7bZaFp3RT7R4xMJkqVj8f1aT0EiJw57WWJkQm25Y+ONQkzREnTKvvEwRcWo2d/ms
FXmbVsIYnDUfDG7L2b7x4wTFOrrppMaq2NDkzlRw2BaveyZum3oooJc8S15n2fOS
ajo/XM7Lj0tjEl1ZRndKQGKP685CmHlxhX8WF19Kf3BxRrJXGbU/vxnOWJdztVen
4YYbprCIP3kVjr8OmFl16i4Wp0drWIrXA+vsOMVUJJ+LBLbkEvWGPjrEeMNWFdRQ
88gGDWmMh8PfMWw09os8VV7aWo92qtbgEoX/eetclfL/tEktgGQeosA3Fdbc8vDE
2q3zfv/OUDktwxAH13W4GPWx1zUIeRLe4tbeLzEHNNQBRP0s4r4e4j9pT/x4U/jT
uieQdTJZPLOnBLd8DHvN
=PNa+
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_19_42_29_+1100_V/gP0SIr4PK3kDVn--
