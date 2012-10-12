Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2JLDEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:04:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60776 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2JLDES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:04:18 -0400
Date: Fri, 12 Oct 2012 14:04:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the pinctrl tree with the  tree
Message-Id: <20121012140416.066516d7811e2b63e3a140a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_14_04_16_+1100_luh+g2UN08vaR64H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_14_04_16_+1100_luh+g2UN08vaR64H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
arch/arm/mach-at91/at91sam9n12.c between commit f7d19b906556 ("ARM: at91:
add clocks for I2C DT entries") from the  tree and commit 5c70cd3c7c69
("arm: at91: dt: at91sam9 add pinctrl support") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/at91sam9n12.c
index 732d3d3,a4676a5..0000000
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@@ -169,12 -169,10 +169,12 @@@ static struct clk_lookup periph_clocks_
  	CLKDEV_CON_DEV_ID("t0_clk", "f8008000.timer", &tcb_clk),
  	CLKDEV_CON_DEV_ID("t0_clk", "f800c000.timer", &tcb_clk),
  	CLKDEV_CON_DEV_ID("dma_clk", "ffffec00.dma-controller", &dma_clk),
 +	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
 +	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
- 	CLKDEV_CON_ID("pioA", &pioAB_clk),
- 	CLKDEV_CON_ID("pioB", &pioAB_clk),
- 	CLKDEV_CON_ID("pioC", &pioCD_clk),
- 	CLKDEV_CON_ID("pioD", &pioCD_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioAB_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioAB_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCD_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioCD_clk),
  	/* additional fake clock for macb_hclk */
  	CLKDEV_CON_DEV_ID("hclk", "500000.ohci", &uhp_clk),
  	CLKDEV_CON_DEV_ID("ohci_clk", "500000.ohci", &uhp_clk),

--Signature=_Fri__12_Oct_2012_14_04_16_+1100_luh+g2UN08vaR64H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd4iwAAoJEECxmPOUX5FEKMAP+wcavKQlDjWPqciSdViM2NJ6
Xl54HvxbVXhkB0CbaH8mHUjLvaxCKB8o1cxsjESX8txhtd4L2S8sGU6ViXkCPYfN
3FTfH2VJQByzuUsYMATeFPcKieY0ZhWuZuCDD/eHqUYmmbPQsP2woIHCr41g9P29
F2lj41qHtaioJlB83hxIj602nmG9JkJex6zPzGcLzfnQ63x8K9TcDvmJ5etTydLI
p3plGKmFzPVi85pUaLLuxM1Jthqi/ZJ1VsIdjQ9QGjuHr3aGTi+l5GL0uDixBDOR
1rKqlRDXpNFdq5VuJhly3Hfx/OVWSazBOhIs5wTc1HQWfvm8LOucloiQtTV6t0wa
Fq8EkVslsOzNLvOK8UAORIQw71p23qHeiBp0HHIOBq96RAiIYLhL/mSb6zzOdoPK
QVWir1d95UqRU3Ra2R3MyMhFFyRmQl0JadZet2LUfOiVpReuce7W6JashCt1C428
IVEnrdB3WgNDVfOqRb1dFtaP1IUSmKhQ+slhnYwZjg7DG7S1P0BnTSzvDPT2hB9a
2TcgwBqt51f/rgXeFMaF2oYajy4WAPtkPswUr6NszyucrBasO7LHPHXmpqXbd0gw
VAfCYBc+QR/qhU4MamOEyhs6mv14DEqjk09kMIpokulVibJWkBEpaDi97tGAzuSi
7145J9/b/tzfFA/YY52u
=rdO4
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_14_04_16_+1100_luh+g2UN08vaR64H--
