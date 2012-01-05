Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2AEDsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab2AEDs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:27 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=DbyoUh96eBcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=BA84mXf1-fkc0wLRZxoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Pyp0xIk9zl8k8AFJZRUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034824.555046443@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 12/20] ktest: Evaluate options before processing them
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0012-ktest-Evaluate-options-before-processing-them.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

All options can take variables "${var}". Before doing any processing
or decision making on the content of an option, evaluate it incase
there are variables that may change the outcome.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 59738aa..04a7bb5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -416,10 +416,12 @@ sub process_variables {
 sub set_value {
     my ($lvalue, $rvalue, $override, $overrides, $name) =3D @_;
=20
-    if ($buildonly && $lvalue =3D~ /^TEST_TYPE(\[.*\])?$/ && $rvalue ne "b=
uild") {
+    my $prvalue =3D process_variables($rvalue);
+
+    if ($buildonly && $lvalue =3D~ /^TEST_TYPE(\[.*\])?$/ && $prvalue ne "=
build") {
 	# Note if a test is something other than build, then we
 	# will need other manditory options.
-	if ($rvalue ne "install") {
+	if ($prvalue ne "install") {
 	    $buildonly =3D 0;
 	} else {
 	    # install still limits some manditory options.
@@ -435,13 +437,12 @@ sub set_value {
 	    }
 	    die "$name: $.: Option $lvalue defined more than once!\n$extra";
 	}
-	${$overrides}{$lvalue} =3D $rvalue;
+	${$overrides}{$lvalue} =3D $prvalue;
     }
     if ($rvalue =3D~ /^\s*$/) {
 	delete $opt{$lvalue};
     } else {
-	$rvalue =3D process_variables($rvalue);
-	$opt{$lvalue} =3D $rvalue;
+	$opt{$lvalue} =3D $prvalue;
     }
 }
=20
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2IAAoJEIy3vGnGbaoArUAQANGk+vwey6QpRBA/kjl3iDIj
q5K9ekkWF2TGaDoVu5IK39DEIbIV2Tusl9HN3GOJZz9wXTbinPY0GMUgsTZbcJsj
p+DhtXz/KQVaI/quKiuBbdTyvLmPVZGIc9dMXeUVO3YbBxNLee5iQnYELmBPb3jo
l23qPIuNaXJJCBAhqO8i+RYB+ZQpJvpuYqUo/NOJ2jkLjmkPSCCzGi5alUFOwtXq
jjZ2Y0Nf0rTGWweega74Dw05LzB//W7uzk7LVDTiNP8KvRaNAHIc+GxGoDGnWUGG
Fn171HQP7k7Cv3afrc6JyKO0BubNT5ChySY0zWOU89URl63O6DOOZi6XIcegyG8V
PN2RQZticovZCf/1qQQT46TO8wknMg3eRM6AmSLNvQ3dYPVoKD3U2miiY2WuO109
100FJ7TfNKnzyW90WhLv3CvAYkrcqTqJt7OA9/pPomcW/xnYim9TH/82Y0pG2oZ8
ETk6c9svmkN5oEpgxNiNW7plRJmrPLXdKNpfuFQloxSTEzacdTPQRN9JxEVERm/G
ml8FCgPFw9G1MzU3eLcarsLBZjUObcBcLYtGdW2RsmivhIgtsvuxBc8s00d1lc0V
6Tw0bdMvSmSs6LiIFHz+ESizH/nHDuzbQSTW3anMCRWkdEGUNFavSS2jtlFsJl00
yEnWr60h3Lr20pjiIKi/
=Inec
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
