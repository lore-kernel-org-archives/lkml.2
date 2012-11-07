Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2KGEsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 23:48:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52362 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KGEsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 23:48:46 -0500
Date: Wed, 7 Nov 2012 15:48:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shiraz Hashim <shiraz.hashim@st.com>
Subject: linux-next: build failure after merge of the final tree (pinctrl
 tree related)
Message-Id: <20121107154837.05c74508452d69930b624280@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Nov_2012_15_48_37_+1100_aiEVqCqcJl.x+1zc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Nov_2012_15_48_37_+1100_aiEVqCqcJl.x+1zc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

In file included from include/linux/gpio.h:48:0,
                 from include/linux/of_gpio.h:20,
                 from arch/powerpc/sysdev/ppc4xx_gpio.c:29:
include/asm-generic/gpio.h:74:10: error: 'struct gpio_chip' declared inside=
 parameter list [-Werror]
include/asm-generic/gpio.h:74:10: error: its scope is only this definition =
or declaration, which is probably not what you want [-Werror]
include/asm-generic/gpio.h: In function 'gpiochip_add_pin_range':
include/asm-generic/gpio.h:76:1: error: no return statement in function ret=
urning non-void [-Werror=3Dreturn-type]
include/asm-generic/gpio.h: At top level:
include/asm-generic/gpio.h:79:35: error: 'struct gpio_chip' declared inside=
 parameter list [-Werror]

Caused by commit e8321df59155 ("gpiolib: iron out include ladder
mistakes") (and some earlier ones) from the pinctrl tree.

I added this patch for today (there may be a better return value from
gpiochip_add_pin_range):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 7 Nov 2012 15:42:44 +1100
Subject: [PATCH] gpiolib: fix non CONFIG_GPIOLIB functions

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/asm-generic/gpio.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 54e02e6..f9acd78 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -69,10 +69,13 @@ void gpiochip_remove_pin_ranges(struct gpio_chip *chip);
=20
 #else
=20
+struct gpio_chip;
+
 static inline int
 gpiochip_add_pin_range(struct gpio_chip *chip, const char *pinctl_name,
 		       unsigned int pin_base, unsigned int npins)
 {
+	return 0;
 }
=20
 static inline void
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__7_Nov_2012_15_48_37_+1100_aiEVqCqcJl.x+1zc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQmeglAAoJEECxmPOUX5FErF8QAIMzkVVraLKcrEsUVsLpSDr2
iICTgXxn5kr2vAnIRwIocpx1Yx75gdeBy49jSJZGbBQrYNL05NITVYEsIR7r++Jk
rQpQVn0tKb4NHMsTbyzxgZYZGutZgUqfBcr1A70qIQ31F/IjBFgawAxUSpGLHSPe
Ddh1Egg3gtKrl58ukfT29ANV0nPOA9B8mNNK36GnouRHH5Xi/4KoobCQxcjt2L0N
ddNeML2GV1FmimSPAydcwU01xWP7T3YobiRReWXOKOcGfampJYYK57J/TaqvzjhK
qLsaPq9ot4o+exXDSFyQ8v6BbbZg2IhhKKR8yz4Ymrr1SWox7Xw2lYyoGB7CyLZ8
WV60IpDmDH3Fw+xsiBo1EUGIqHEzacWg55WmP3xBSdyDEEdtoqb890qjPI7s++Ym
lmEdI+0UzJoj1Xh/oCInwF5F4ib7yxII6S3aQ/xRkxPwlP7InMiv7Gw7I5vTkpws
5tl1W0zMsF7tY7SBIxqfy6IH84wT5wSJTc5XKnQicjaPM0dvCNfWKjLiJ7lR80Pi
wtwkpwjLjLCQAFT/GlwEVIx1R21QAAM5Mvc3mk1gq9o9j8xZUUBbNMT/BfhTrQ4b
Y6wxujq5hYEtHmj0ri91n2qJXcWxXbzhrlskXe6FfSS5/YWFh1ubLHV0B9mB/4sJ
elc66vszvySp5pXs+qIR
=2FUv
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Nov_2012_15_48_37_+1100_aiEVqCqcJl.x+1zc--
