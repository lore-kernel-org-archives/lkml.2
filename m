Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2DYC3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:29:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab2DYC3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:29:34 -0400
Date: Wed, 25 Apr 2012 12:29:24 +1000
From: NeilBrown <neilb@suse.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] twl-regulator: Allow CONFIG_TWL4030_ALLOW_UNSUPPORTED to be
 requested.
Message-ID: <20120425122924.0f08f5dc@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_C.UcRW6FdAucBGAndvgBeo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_C.UcRW6FdAucBGAndvgBeo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


twl-regulator.c changes behaviour slightly depending on
  CONFIG_TWL4030_ALLOW_UNSUPPORTED
However that config option is not currently listed in any Kconfig
file.
So add the option to allow it to be chosen.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 36db5a4..1d24cac 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -338,6 +338,15 @@ config REGULATOR_TWL4030
 	  This driver supports the voltage regulators provided by
 	  this family of companion chips.
=20
+config TWL4030_ALLOW_UNSUPPORTED
+	bool "Allow unsupported voltages on TI TWL4030/TWL5030/TWL6030/TPS659x0 P=
MIC"
+	depends on REGULATOR_TWL4030
+	help
+	  TWL4030 regulator can (possibly) supply voltages that are not
+	  explicitly supported by TI.  Set this option to allow those
+	  voltages to be requested.
+	  If unsure, say 'N'
+
 config REGULATOR_WM831X
 	tristate "Wolfson Microelectronics WM831x PMIC regulators"
 	depends on MFD_WM831X

--Sig_/_C.UcRW6FdAucBGAndvgBeo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5dhhDnsnt1WYoG5AQLu0hAAhIz8wBg0beM73G4ok7qwkjsNU9Rv7hnG
fuwoQP26XSv6/WUrsth1O7aR9k7g2PBKEF7Z+82N3KOi8IbxhYO7TeOkyPCw9Atk
+jkuTbL8Nn9KcZ8ObZIejjVxDfpc5REvi6Byrq2EW5jC3ktki3ejrp4ZrVoznfwC
0E9ELLEOrnkkQFXeRhMC0Y17bcgXeamYactlt4a5uyXK+fB43QRQqS7S0az4h9fG
pv54PubZ/rE1QU6ozK9ESsny53kgq3xRGr7Jy48UzQHxGu5v2nDabWQ7jUu2Xp/V
5bmoKez+mHVayr+UOxurcLT2O9LXyLxtqAXpmhxx4qUkeAKCBAf2StVR1OAdMlNj
b0SERGhZY+Xs3bp2mgsmYr34Z6JJJmjf9Z9Lsp552xr3K4e8dSCwuhJ9+DQdXjlk
c/whp/Xd9QCf1mWXGr5O02uEw7UZJKMMRy+OzTFBTgmp5nhGj8e2TKeKW3KDxOsi
+cYFPI80O4BUh6AUB1MrsdOl5VncZWDQjtxkQEjD8sbWVyhazpHmQyLj6YFDtmtL
fUt2NhJZouCiaKn6FmMe+5nFfI/nlfSZLwdDbuDeLXIh6dIrUTcoQ+gW7BK2SnCV
G+cATfS3abuprV8Dzkl70+wTQIxUZwHP60wzp7qkuR99hzObip0vvyc/sjfqpX5l
0py8/Bk8Bh4=
=kVU5
-----END PGP SIGNATURE-----

--Sig_/_C.UcRW6FdAucBGAndvgBeo--
