Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1JKIZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:25:32 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37974 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1JKIZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:25:30 -0400
Date: Tue, 11 Oct 2011 19:25:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IkhlaWtvIFN0w7xibmVyIg==?= <heiko@sntech.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20111011192515.1f69837816e4cebd1e097385@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_19_25_15_+1100_y8NEAoe15B1/aD3."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_19_25_15_+1100_y8NEAoe15B1/aD3.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/regulator/gpio-regulator.c: In function 'gpio_regulator_probe':
drivers/regulator/gpio-regulator.c:209:24: error: 'THIS_MODULE' undeclared =
(first use in this function)
drivers/regulator/gpio-regulator.c:209:24: note: each undeclared identifier=
 is reported only once for each function it appears in
drivers/regulator/gpio-regulator.c: At top level:
drivers/regulator/gpio-regulator.c:338:13: error: 'THIS_MODULE' undeclared =
here (not in a function)
drivers/regulator/gpio-regulator.c:354:15: error: expected declaration spec=
ifiers or '...' before string constant
drivers/regulator/gpio-regulator.c:355:20: error: expected declaration spec=
ifiers or '...' before string constant
drivers/regulator/gpio-regulator.c:356:16: error: expected declaration spec=
ifiers or '...' before string constant
drivers/regulator/gpio-regulator.c:357:14: error: expected declaration spec=
ifiers or '...' before string constant

Caused by commit 3f0292ae8bb1 ("regulator: Add driver for gpio-controlled
regulators") from the regulator tree interacting with the module.h split
up.

I have applied the following patch for today.  Mark, Liam, this should be
applied to the regulator tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 11 Oct 2011 19:22:29 +1100
Subject: [PATCH] regulator: using module related services requires module.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/regulator/gpio-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-re=
gulator.c
index abf32ad..24d4477 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -31,6 +31,7 @@
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/module.h>
=20
 struct gpio_regulator_data {
 	struct regulator_desc desc;
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Oct_2011_19_25_15_+1100_y8NEAoe15B1/aD3.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk/1rAAoJEECxmPOUX5FErFYP/Rt8p6sw9BflovSMgcPLDfHg
vu5oU1cxxrkUgCBNlH721Jp/H6BSAtCHtuuvWSEZystQViXySsDcJaFgBbj6hs0K
wpdQ2cKJjYQtBPt0M1FX9fwN0kvwRPnRKiAPq3pcFVrJoieHGpWVFBysK/ua/96Y
o0Wuk4wwn5wMk8pSNqlm6PrJPSENzSy/y2xXrjhz8y8uvNA9zzyI8vbTGuED/ssO
a3gHbGbiN8iUXKgkNhZEYOxweull28yvgW1YMzQypwvMIrukeZVsOqMxyqxtZX6B
G8L7DsSN91Dsyb52mmP58gfpi9WS+Acx1WXXLg0qdiUnTEmiIommHrWAKBBIxK2Q
t1CykjZnPO07LSTZpqSHp9c7dpLUqWi44Uyw3akLTK0ptXlX+8sXVoc0oDfO3Olj
5ahkSYmUUmBGmMYaCnrUUlE2VqUSWCqf8p5eNUga6YAh2IzTMiu4A+VzAWQDr/t5
tR+nn1lTW4dAByLQ19PFdTCfTaduAMpS+co+TmE64sjf1qDDMHHLt0zcARa6JyGe
x34xsYjRqsA1idOe6UUyrK5YqRd41OWInpLcgz0d0I4VC2aUHcT3r1qEm0h+6naj
Ywl1MFh1q1/8VtCHcPe+PBWW1ABkgUSTBuBzjWovT3DkYF4rArO1WHzcmKfyHvmS
McPH8VKQg5jsKDp7vJ8E
=3gvy
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_19_25_15_+1100_y8NEAoe15B1/aD3.--
