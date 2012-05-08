Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2EHHWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:22:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49271 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab2EHHWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:22:08 -0400
Date: Tue, 8 May 2012 17:21:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: linux-next: manual merge of the arm-soc tree with the crypto tree
Message-Id: <20120508172153.b05c9d198b1b81c652a2bde6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_May_2012_17_21_53_+1000_7DySGX1emu+wNhQB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_May_2012_17_21_53_+1000_7DySGX1emu+wNhQB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/char/hw_random/Kconfig between commit 028fdd87b79a ("hwrng:
Kconfig - modify default state for atmel-rng driver") from the crypto
tree and commit 1234f4bada54 ("hwrng: Kconfig: remove dependency for
atmel-rng driver") from the arm-soc tree.

Juts context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/hw_random/Kconfig
index 8cd64f1,b2402eb..0000000
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@@ -62,8 -62,8 +62,8 @@@ config HW_RANDOM_AM
 =20
  config HW_RANDOM_ATMEL
  	tristate "Atmel Random Number Generator support"
- 	depends on HW_RANDOM && ARCH_AT91SAM9G45
+ 	depends on HW_RANDOM && HAVE_CLK
 -	default HW_RANDOM
 +	default (HW_RANDOM && ARCH_AT91)
  	---help---
  	  This driver provides kernel-side support for the Random Number
  	  Generator hardware found on Atmel AT91 devices.

--Signature=_Tue__8_May_2012_17_21_53_+1000_7DySGX1emu+wNhQB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPqMmRAAoJEECxmPOUX5FEV9gP/i6M+xBBcZdOGGmAiecBmr+2
HBPiE1H/hCfXlFy2WAntYxSX/a4dfjmGqjgeRM74ql9Yxzkb2JWX47aguVE2n+Gn
8My79zme+vR3T5asxSsr4ozehEpQJWvz2obPpusCpYccU16v5E5/WMlEHLGKWjiz
aYKKJm5nIC5t8eflmoqIMnLuAYU7jT2XSokikqw1cpQr09BOlFmsN0HP8MCgl7Yq
YGeSOYkS4bm8WES3vPayerDR6EyWqwlBxk27t8rWpMPCXV5BtBYCubqy4gfr56x1
rwWt7UMMroJNfHDvk3Tp75hP6G6xk2HauUZ0yX24bbdUW9FSUsFAyJL+3OYAF9Xz
y7LYzeWS43w2DsLgRvVH21TZ9JU+yw/y6ybjMJR1gTNmUg/kCXjp3tEUSpG+Gj4R
VOlEplTBq/MlLpth6jthxJTs6cEhxbQN8Hb2Qu/7JvWEBPVQvymQ84gTmQsNfBvj
jIZRt6o/Ctn5bkGeWSzoF/s6b9pmwwSGwkP7apx/WTZZ9r5Y3cqEUJl4cdnqI7k+
modljGoef73S6xNMtVVVCGS7jQlT3yhQo0Vx2h5dDpg1LDG5is34hj2MFahAl10z
Tp/FcMvy5MoPTGZXvjZykohQwCMUKw41g3vpfDGlQBCBx74PJ8hlG8z8yN+kPi0t
Yrmv6lh54fFSehib3p7S
=HNA4
-----END PGP SIGNATURE-----

--Signature=_Tue__8_May_2012_17_21_53_+1000_7DySGX1emu+wNhQB--
