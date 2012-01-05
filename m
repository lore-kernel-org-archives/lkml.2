Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab2AEDsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab2AEDs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:28 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=XzcNEAAJ7PQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Ibh-hCqT0oyRuCwo3fgA:9 a=zwsQMZJuWsYH7pUmChQA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=djfynCOdoG-tbyNurd8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034826.461254829@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 18/20] ktest: Fix compare script to test if options are not documented
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0018-ktest-Fix-compare-script-to-test-if-options-are-not-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The compare script compare-ktest-sample.pl checks for options
that are defined in ktest.pl and not documented in samples.conf,
as well as samples in samples.conf that are not used in ktest.pl.

With the switch to the hash format to initialize the ktest variables
the compare script needs to be updated to handle the change.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/compare-ktest-sample.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/compare-ktest-sample.pl b/tools/testing/kt=
est/compare-ktest-sample.pl
index 9a571e7..a373a5b 100755
--- a/tools/testing/ktest/compare-ktest-sample.pl
+++ b/tools/testing/ktest/compare-ktest-sample.pl
@@ -2,7 +2,9 @@
=20
 open (IN,"ktest.pl");
 while (<IN>) {
+    # hashes are now used
     if (/\$opt\{"?([A-Z].*?)(\[.*\])?"?\}/ ||
+	/^\s*"?([A-Z].*?)"?\s*=3D>\s*/ ||
 	/set_test_option\("(.*?)"/) {
 	$opt{$1} =3D 1;
     }
@@ -11,7 +13,7 @@ close IN;
=20
 open (IN, "sample.conf");
 while (<IN>) {
-    if (/^\s*#?\s*(\S+)\s*=3D/) {
+    if (/^\s*#?\s*([A-Z]\S*)\s*=3D/) {
 	$samp{$1} =3D 1;
     }
 }
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2KAAoJEIy3vGnGbaoAWYYP+QFC+xummYB4GQqC/t5s+Lq9
6XXU+/eepEOwvGLxwOVYTGTc/ouEpYyGMl78zaQQSWReFWCVYPFyvp3vv2LVQDWj
MB/xpNlXoUsrDPAxOuHIMzW/U9DeuvinmwQ9IOWVSdoHLPi3UKQibVoOef5Dft3y
hIM3RblKRhmHaU6FaMa5gTlDHA5STaAbNuDzSZypxlTz/geMLaPPffEmFurIo/nh
/KPacq/45szglTn39HeXsfGE32Pb4lKi0g81wmbdzWkdnrC9Zh6OwqkBx0FcG8Af
GHBYsmubyehMuR7cAvel726b/AsmaZ4hA7O7cjazlnaLoit3HPcV+HN83zRM6OBX
PGNN6vC4AozujBL3zyXPvntbmVGAyzyL0g3Oc1dUKgJKrcYndPIpIezxkQUymViL
z0EOQW+56NlkJOlWt7bpGe4qF0Q4YAvvF6/KkNoZ6kCv4YyKHZLJ64WElj3qyMD3
0W37rgjKXYXNyXhnSaCfCX5yzRe4+Ggv9mpnyZztv/XWKJ/EHMADaVf39pL9rWb+
fxqB2yR8MpBAYZc7QzqYg0fg0b/Y6FVws10TYNWxj72ACoJOF7pwIobtFRqcVOhs
cdfXIAmW6AdVZl/K0iQT2AjHC0t7J6zxMWwfCpOvrHu53YG92xCw448OuF7erBAI
lGka+81ywRlZVoFEQl+r
=FSmG
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
