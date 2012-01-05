Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2AEDvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:51:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab2AEDs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:26 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=G_KXoexwFB0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=QIw1zoSjksk70hDLe4YA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=X9Q3iD4FXkIu9lhQMjoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034823.920360460@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 10/20] ktest: Only ask options needed for install
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0010-ktest-Only-ask-options-needed-for-install.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If all the tests are only for build or install, do not ask
for options not needed to do the install, if the options do
not exist.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 2b547d6..5d82c27 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -136,7 +136,7 @@ my $localversion;
 my $iteration =3D 0;
 my $successes =3D 0;
=20
-# set when a test is something other that just building
+# set when a test is something other that just building or install
 # which would require more options.
 my $buildonly =3D 1;
=20
@@ -343,11 +343,15 @@ sub get_ktest_configs {
=20
     # options required for other than just building a kernel
     if (!$buildonly) {
+	get_ktest_config("POWER_CYCLE");
+	get_ktest_config("CONSOLE");
+    }
+
+    # options required for install and more
+    if ($buildonly !=3D 1) {
 	get_ktest_config("SSH_USER");
 	get_ktest_config("BUILD_TARGET");
 	get_ktest_config("TARGET_IMAGE");
-	get_ktest_config("POWER_CYCLE");
-	get_ktest_config("CONSOLE");
     }
=20
     get_ktest_config("LOCALVERSION");
@@ -412,10 +416,15 @@ sub process_variables {
 sub set_value {
     my ($lvalue, $rvalue, $override, $overrides, $name) =3D @_;
=20
-    if ($lvalue =3D~ /^TEST_TYPE(\[.*\])?$/ && $rvalue ne "build") {
+    if ($buildonly && $lvalue =3D~ /^TEST_TYPE(\[.*\])?$/ && $rvalue ne "b=
uild") {
 	# Note if a test is something other than build, then we
 	# will need other manditory options.
-	$buildonly =3D 0;
+	if ($rvalue ne "install") {
+	    $buildonly =3D 0;
+	} else {
+	    # install still limits some manditory options.
+	    $buildonly =3D 2;
+	}
     }
=20
     if (defined($opt{$lvalue})) {
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2IAAoJEIy3vGnGbaoAm48P/0RRGSlbnb6y9DygcHChXH6M
SOB+XstOPYemJtnSbleGZGcAj/HtQ2YQOMKTaEqWi8rfmjAodNwFrNkWocg7Rm7Y
O6gWc8otDXskGOD172OXTrTuDH5I0sqKD8HPmWpvY06S8B00uHmhUNS466R2lr/A
or+mNmJvHzpqAiLbBTlrsEKACcQvHQMK65P7odUIU6HPb9UT2Ye8zS/nyWniJFL6
s1ca0wdPT01C59wu10aFzMjks4U4EDTArha45K1g7Uo05ImOxRBvmOnz/2mkAnHD
/7umOUtupFHn1thxOmvngxc53NK8BvpXP/28hjqxNVP/tI59Tl6mfNfkkIVMQoML
S1lE0NeY5NChPdI2mEJEEwsTjo3zFIgi1h1L4L/3OxHtKQRlhGJWjSxxUiBs+QMH
aK1D+IrGTGrwz90/QQZ3raYXHcsSujbTLVqBptqN+UpB0eYfeGkhNNUdukCLmaFv
73Y/I/Sryre0LGjCX52LC9f/Q2g6yA2laI8wEh/UF7l7MHdHKCDixKwfCXrjeqQH
3BZUZJj+Ab5mEf5PwhFnTZ7k5PUrV94C46PmWAwk5gBUt+W4QwgCm3VpJjLlccKA
ODyrT8I0vOcjcNrRg+y/nFg/JdA6YqojH/XV7mHq/dV1y1RmQw8ofj4OlQLqyY6K
h1o15UDcijQSJjh1TZPF
=B8No
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
