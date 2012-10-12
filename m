Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2JLDI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:08:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38534 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2JLDI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:08:56 -0400
Date: Fri, 12 Oct 2012 14:08:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikolaus Voss <n.voss@weinmann.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: linux-next: manual merge of the pinctrl tree with Linus' tree
Message-Id: <20121012140852.fad715123dc77f1d5c644825@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_14_08_52_+1100_=FV/ODks.bhBnHsy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_14_08_52_+1100_=FV/ODks.bhBnHsy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in arch/arm/mac=
h-at91/at91sam9x5.c between commits af2a5f09fb6d ("Replace clk_lookup.con_i=
d with clk_lookup.dev_id entries for twi clk") and f7d19b906556 ("ARM: at91=
: add clocks for I2C DT entries") from Linus' tree and commit 5c70cd3c7c69 =
("arm: at91: dt: at91sam9 add pinctrl support") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/at91sam9x5.c
index e503538,79b5c52..0000000
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@@ -231,13 -231,10 +231,13 @@@ static struct clk_lookup periph_clocks_
  	CLKDEV_CON_DEV_ID("t0_clk", "f800c000.timer", &tcb0_clk),
  	CLKDEV_CON_DEV_ID("dma_clk", "ffffec00.dma-controller", &dma0_clk),
  	CLKDEV_CON_DEV_ID("dma_clk", "ffffee00.dma-controller", &dma1_clk),
 +	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
 +	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
 +	CLKDEV_CON_DEV_ID(NULL, "f8018000.i2c", &twi2_clk),
- 	CLKDEV_CON_ID("pioA", &pioAB_clk),
- 	CLKDEV_CON_ID("pioB", &pioAB_clk),
- 	CLKDEV_CON_ID("pioC", &pioCD_clk),
- 	CLKDEV_CON_ID("pioD", &pioCD_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioAB_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioAB_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCD_clk),
+ 	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioCD_clk),
  	/* additional fake clock for macb_hclk */
  	CLKDEV_CON_DEV_ID("hclk", "f802c000.ethernet", &macb0_clk),
  	CLKDEV_CON_DEV_ID("hclk", "f8030000.ethernet", &macb1_clk),

--Signature=_Fri__12_Oct_2012_14_08_52_+1100_=FV/ODks.bhBnHsy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd4nEAAoJEECxmPOUX5FEc/wP+wXp3CIu7a1I8BaTA8VjLjyi
Aahtea2VqEBn3H+Gnu5KE6m9cw/GawWzwWEr4tfH6IoypGf8LQsv1TenHz65ogq/
6qUeu8ZSfOfCQJgOPAFWpGqnlX+CCDts0IE/uWHjFc5kRyqGt43eKFoMvvcLs8FD
zWM+DRdnL4IbhrmyI0UquryHvbeAiI8UsA2+8cuq8RcDZjO5qz0PZTmLfpNMPnH8
N1iJafQsKbSo5ETTnYaqmrA5LXHsvj77pXxMTqHT4SGh+R6ENjI0KsbJfJaRQCSW
sOF0e/GblDYdIU8noKccDPDfVenBO2gtcFMTc/korzhLPaF2DhkVOpU9jqpbVqus
bSNYCYTAFDkN3VTgVzXwkqG+KXBOgi5Jd7ZCRuR3fX/XvfzhnikZ7j46sfgcRMyl
QJdxJaVJfo1T9XcQYU5rR+pLVNUBolncqYRK6VlVd3zpixn4VT+xiZdhCDkj7sYw
UNFLcSksMJKfjpMKs78TgGCz8wgP3BTThXdqpoN3fPerVGgMti7ZEYm3fv9E+fhY
yPvJgOx2AsG8+6bkadeFR/wfyI6cEvuwOKHl9yITFOOeyqa2K/C9LQpL+DwiZ0ZQ
RFjzILohzd3UCaKK1mo5wkTJZmPrnILevtBAtsxqniCfiTn9DiOHVbCJri+VfU56
Gd59T4mZFmSddfYdgOfT
=2kkZ
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_14_08_52_+1100_=FV/ODks.bhBnHsy--
