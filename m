Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab2AEDsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab2AEDsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:25 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=4r0GJzeLjmgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=pXQ4q6nVzZ7UDJbVaE4A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Q2AwslvU58g9QMBEE_gA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034823.626278577@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 09/20] ktest: When creating a new config, ask for BUILD_OPTIONS
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0009-ktest-When-creating-a-new-config-ask-for-BUILD_OPTIO.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When creating a new config, ask for the BUILD_OPTIONS variable
that lets users add things like -j20 to the make.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 7159e10..2b547d6 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -140,6 +140,9 @@ my $successes =3D 0;
 # which would require more options.
 my $buildonly =3D 1;
=20
+# set when creating a new config
+my $newconfig =3D 0;
+
 my %entered_configs;
 my %config_help;
 my %variable;
@@ -179,6 +182,11 @@ $config_help{"BUILD_TARGET"} =3D << "EOF"
  (relative to OUTPUT_DIR)
 EOF
     ;
+$config_help{"BUILD_OPTIONS"} =3D << "EOF"
+ Options to add to \"make\" when building.
+ i.e.  -j20
+EOF
+    ;
 $config_help{"TARGET_IMAGE"} =3D << "EOF"
  The place to put your image on the test machine.
 EOF
@@ -306,7 +314,7 @@ sub get_ktest_config {
=20
     for (;;) {
 	print "$config =3D ";
-	if (defined($default{$config})) {
+	if (defined($default{$config}) && length($default{$config})) {
 	    print "\[$default{$config}\] ";
 	}
 	$ans =3D <STDIN>;
@@ -329,6 +337,10 @@ sub get_ktest_configs {
     get_ktest_config("BUILD_DIR");
     get_ktest_config("OUTPUT_DIR");
=20
+    if ($newconfig) {
+	get_ktest_config("BUILD_OPTIONS");
+    }
+
     # options required for other than just building a kernel
     if (!$buildonly) {
 	get_ktest_config("SSH_USER");
@@ -3094,6 +3106,7 @@ if ($#ARGV =3D=3D 0) {
 }
=20
 if (! -f $ktest_config) {
+    $newconfig =3D 1;
     get_test_case;
     open(OUT, ">$ktest_config") or die "Can not create $ktest_config";
     print OUT << "EOF"
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2HAAoJEIy3vGnGbaoAPa4P/isb0mwsuegSYG6k9S+f64K5
GleZrhHN2qldymO9K+tDSeZYHscnvuyaV7Knzk+EjGqpQ0E9LmST5afeEeGlkAe2
1CeC1SsdclMNWaByENcxhJDQKhyumA4qzp6hhcU3klOogZ9GAfyCk7lgeMSzyEUR
S6iPifz+Y6DweCDWyJvjpI+z5fmuYN+3U3ayMnhRMZdsgG5CeeWo4Z6HyGFiTXPX
37pjRHHJ3Isxj3EzhzYlE4bX5BBT/CX0wZB1OKruc3i2CioVe9Le8NyPTyoy0mEW
rYqM/Gd/mda7WFNhI8heCy1HZ1FLdw89EDxSVQn90LQQd0JDeENgQILKDhNRU0BV
OWJ8OiVSyRHUh92NBHbkuDCafuMXb8WYSdQaPNGenHyX9vs/7YtazK7Kk03+5B6X
pjoKM15+DUJ1SeDOI0ITOZL+svsfLVRGSGsU6dVBCz8T+06JtMFOQmT4kwqIAUj9
+tHDc6k4Gg6/lxwXROxAb1RLzlan69YhYqPDzlKLuWw9Ezh+3L6asq3JvnByfg/5
V7Z+U5fAczjRzoHKRCLUgAiVMup9KjqPe7y2F6jx15BDUupklOMUZOl285Vbn3G8
cQ8QDtyJrTVwj1T1cVjSRdueywVKjX1cUCbnqoz2zJVWhTu6E2eY70D0ix4LIxEW
VMTq17hEu0G+P25H7q6A
=XxUO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
