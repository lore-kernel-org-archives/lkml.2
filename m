Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab2EVMIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:08:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24925 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab2EVMGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:06:32 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=MpCu-rTJig8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=8AVqNC0GFvT5Sjuqx0EA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=HUOipzEY1cVu3W7PyOcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120522120630.558090845@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 22 May 2012 08:05:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/8] ktest: Add USE_OUTPUT_MIN_CONFIG to avoid prompt on make_min_config
References: <20120522120531.460108326@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Add-USE_OUTPUT_MIN_CONFIG-to-avoid-prompt-on-m.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If the file that OUTPUT_MIN_CONFIG exists then ktest.pl will prompt the
user and ask them if the OUTPUT_MIN_CONFIG should be used as the
starting point for make_min_config instead of MIN_CONFIG.

This is usually the case, and to allow the user to do so, which is
helpful if the user is creating different min configs based on tests,
and they know one is a superset of another test, they can set
USE_OUTPUT_MIN_CONFIG to one, which will prevent kest.pl from prompting
to use the OUTPUT_MIN_CONFIG and it will just use it.

If USE_OUTPUT_MIN_CONIFG is set to zero, then ktest.pl will continue to
use MIN_CONFIG instead.

The default is that USE_OUTPUT_MIN_CONFIG is undefined.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   11 ++++++++++-
 tools/testing/ktest/sample.conf |    6 ++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index b6de819..292b13a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -109,6 +109,7 @@ my $start_minconfig;
 my $start_minconfig_defined;
 my $output_minconfig;
 my $minconfig_type;
+my $use_output_minconfig;
 my $ignore_config;
 my $ignore_errors;
 my $addconfig;
@@ -209,6 +210,7 @@ my %option_map =3D (
     "OUTPUT_MIN_CONFIG"		=3D> \$output_minconfig,
     "START_MIN_CONFIG"		=3D> \$start_minconfig,
     "MIN_CONFIG_TYPE"		=3D> \$minconfig_type,
+    "USE_OUTPUT_MIN_CONFIG"	=3D> \$use_output_minconfig,
     "IGNORE_CONFIG"		=3D> \$ignore_config,
     "TEST"			=3D> \$run_test,
     "ADD_CONFIG"		=3D> \$addconfig,
@@ -3146,8 +3148,15 @@ sub make_min_config {
     # that instead.
     if (-f $output_minconfig && !$start_minconfig_defined) {
 	print "$output_minconfig exists\n";
-	if (read_yn " Use it as minconfig?") {
+	if (!defined($use_output_minconfig)) {
+	    if (read_yn " Use it as minconfig?") {
+		$start_minconfig =3D $output_minconfig;
+	    }
+	} elsif ($use_output_minconfig > 0) {
+	    doprint "Using $output_minconfig as MIN_CONFIG\n";
 	    $start_minconfig =3D $output_minconfig;
+	} else {
+	    doprint "Set to still use MIN_CONFIG as starting point\n";
 	}
     }
=20
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 1c1b7dc..0e8191b 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -1113,6 +1113,12 @@
 #   config that is generated allows network activity (ssh).
 #   (optional)
 #
+#  USE_OUTPUT_MIN_CONFIG set this to 1 if you do not want to be prompted
+#   about using the OUTPUT_MIN_CONFIG as the MIN_CONFIG as the starting
+#   point. Set it to 0 if you want to always just use the given MIN_CONFIG.
+#   If it is not defined, it will prompt you to pick which config
+#   to start with (MIN_CONFIG or OUTPUT_MIN_CONFIG).
+#
 # Example:
 #
 #  TEST_TYPE =3D make_min_config
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu4FGAAoJEIy3vGnGbaoArKcQAM+g62B2yjgFtlu39zWslZ2R
RJ9f9YawycOm15K4nRyTUVx5QDs/139XLmN8/W+Dy3H09CGljq6U6Cf1znXR7VXx
uy3+ty1GI+zP029+y452Z/fvxA3YO9zaflrYn6E4eF3oL8xHbVljBBS118zkK6PQ
iuuWSvMp/BKDfYbXrGBd8LSu/sLr/lPmx9FWWI83ODUzrFGfdR588vM0Y8jmL2aM
B9Jb3abFFGPAgyVWrPaS8+ri+tCnHG8XzRuEaxSnKjBb3kZnN/HpA0Q5LwD/ShPH
uYEJDZw6UupX23fBCpvf9Nel4CjtNQRgfpugee0Hysv7Zxlr6URsgG5Q2DEkAST8
TOvggxb5FbLVIDC6uLe0DSXH3ExBnXqiQHGBWeP4OffdAiQRm520B98buPVMz7ck
8BRZFfO//7WJ3t4HYHV57JermE1Fr7xH++zHs9Vpv9u+XgBwiTYrtKQrGmnKDfOc
tzdJvp2cySxPGMwJkrj7G3d7t2WKUNnyrDKK9UOgXi9BRHgl2vraMU3TkOppsMaR
w9ZZ/4+aosIv3RBhnTe8zFLouXJ6VYznWV1MXv0UcXFcZzWYHYtqy34FYMwsDd1G
7JItKj3t3/ZgV4opDMi1dptBv//VwOCniuPLYu00+5xqanHFCUbMZub+7K0osi+f
bbs+EIoINOceTxXyR758
=em0Z
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
