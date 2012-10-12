Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2JLDBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:01:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35050 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2JLDBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:01:17 -0400
Date: Fri, 12 Oct 2012 14:01:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the pinctrl tree with Linus' tree
Message-Id: <20121012140113.f210f9c091ff0c31f6b5849e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_14_01_13_+1100_J6=r+SQFVEYtKJ2T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_14_01_13_+1100_J6=r+SQFVEYtKJ2T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
arch/arm/mach-at91/at91sam9263.c between commit f7d19b906556 ("ARM: at91:
add clocks for I2C DT entries") from Linus' tree and commit 5c70cd3c7c69
("arm: at91: dt: at91sam9 add pinctrl support") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/at91sam9263.c
index 6a01d03,2edf813..0000000
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@@ -211,7 -210,11 +211,12 @@@ static struct clk_lookup periph_clocks_
  	CLKDEV_CON_DEV_ID("hclk", "a00000.ohci", &ohci_clk),
  	CLKDEV_CON_DEV_ID("spi_clk", "fffa4000.spi", &spi0_clk),
  	CLKDEV_CON_DEV_ID("spi_clk", "fffa8000.spi", &spi1_clk),
 +	CLKDEV_CON_DEV_ID(NULL, "fff88000.i2c", &twi_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff200.gpio", &pioA_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioB_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioCDE_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCDE_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioCDE_clk),
  };
 =20
  static struct clk_lookup usart_clocks_lookups[] =3D {

--Signature=_Fri__12_Oct_2012_14_01_13_+1100_J6=r+SQFVEYtKJ2T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd4f5AAoJEECxmPOUX5FEFhAQAIzgD1PRzd16nBg6SFyf9oN0
RoN0OIkl0swh/SxaPYp0Q5tatGExbG7UxKPcF9FPJOwB0rkd0/NKqdTO84pNXtkO
8oVRkz3jzffEz3bZRz4/Nz8MzHzxf2RR4fzWkhgttxnq1Uy1ZseMoRFjzQAxStDF
B3JH6ZIODY0n1Jga0cFaUaS/MO0X8oFjTEeyYbgWc6hkqZFOP9gqG1rDL3Xbjcif
GI2BpvJ3LT3d6pCN2zG1Hvx0ZEOHkTZZBEzJJWs0bHnJjWJzeRfVKPfhCcgXK6z8
gKCGdGklEZd5nhrhAA2aG8CYoXQfihDBWwicpNDOYq/D3m6IkbXr9yXUKJ8TWAYn
AVctncjYmFNBZ7pGuOasX590Rw8bb2/uSmcu4EG51gwH/KAVPhpksno4hKcs+4tH
+XPsGnk2PBdo32A2PODcSBsEy+4viX9ZgVG4jmlvO0cBx/KLZnlyGSUH4mbmouzN
e6B241xhI4qpg+TqGQO/Hdn0uVcAA39IvT/Em3knE/ybJQLOyh33PeQk6e08EHt/
Vn4E3VCMWgh0rq2pGHfoeVPJ9d2755B7e4Ad6qyHPGzZuo02Rv+X9DygtqbECeMX
CFaq4ObRWpH9D3kNnG3DECXFa4b8pUBEP89tuINp9ImRKj5qccSkGl0vKc9bh+wZ
HLrLwsbZOoMy+/6AddKF
=fkhU
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_14_01_13_+1100_J6=r+SQFVEYtKJ2T--
