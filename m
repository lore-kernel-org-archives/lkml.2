Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2AEDu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:50:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2AEDs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:27 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=DORMkN_iJMoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=taykJ6Z7e8FN82nOYiUA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=grPy5k4eAr-chNMA:21 a=Jd7hyYFukoDyrqi3:21 a=qIYj9Wx2vn7_DHVbAoIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034825.504239431@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 15/20] ktest: Change initialization of defaults hash to perl format
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0015-ktest-Change-initialization-of-defaults-hash-to-perl.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Initializing each default value by specifying the hash name is
ugly. This is one of the rare cases that the "perl way" is actually
much cleaner and easier to read.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   71 +++++++++++++++++++++-----------------=
---
 1 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index ff21e92..85c5d94 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -18,46 +18,47 @@ $| =3D 1;
 my %opt;
 my %repeat_tests;
 my %repeats;
-my %default;
=20
 #default opts
-$default{"NUM_TESTS"}		=3D 1;
-$default{"TEST_TYPE"}		=3D "build";
-$default{"BUILD_TYPE"}		=3D "randconfig";
-$default{"MAKE_CMD"}		=3D "make";
-$default{"TIMEOUT"}		=3D 120;
-$default{"TMP_DIR"}		=3D "/tmp/ktest/\${MACHINE}";
-$default{"SLEEP_TIME"}		=3D 60;	# sleep time between tests
-$default{"BUILD_NOCLEAN"}	=3D 0;
-$default{"REBOOT_ON_ERROR"}	=3D 0;
-$default{"POWEROFF_ON_ERROR"}	=3D 0;
-$default{"REBOOT_ON_SUCCESS"}	=3D 1;
-$default{"POWEROFF_ON_SUCCESS"}	=3D 0;
-$default{"BUILD_OPTIONS"}	=3D "";
-$default{"BISECT_SLEEP_TIME"}	=3D 60;   # sleep time between bisects
-$default{"PATCHCHECK_SLEEP_TIME"} =3D 60; # sleep time between patch checks
-$default{"CLEAR_LOG"}		=3D 0;
-$default{"BISECT_MANUAL"}	=3D 0;
-$default{"BISECT_SKIP"}		=3D 1;
-$default{"SUCCESS_LINE"}	=3D "login:";
-$default{"DETECT_TRIPLE_FAULT"} =3D 1;
-$default{"NO_INSTALL"}		=3D 0;
-$default{"BOOTED_TIMEOUT"}	=3D 1;
-$default{"DIE_ON_FAILURE"}	=3D 1;
-$default{"SSH_EXEC"}		=3D "ssh \$SSH_USER\@\$MACHINE \$SSH_COMMAND";
-$default{"SCP_TO_TARGET"}	=3D "scp \$SRC_FILE \$SSH_USER\@\$MACHINE:\$DST_=
FILE";
-$default{"REBOOT"}		=3D "ssh \$SSH_USER\@\$MACHINE reboot";
-$default{"STOP_AFTER_SUCCESS"}	=3D 10;
-$default{"STOP_AFTER_FAILURE"}	=3D 60;
-$default{"STOP_TEST_AFTER"}	=3D 600;
+my %default =3D (
+    "NUM_TESTS"			=3D> 1,
+    "TEST_TYPE"			=3D> "build",
+    "BUILD_TYPE"		=3D> "randconfig",
+    "MAKE_CMD"			=3D> "make",
+    "TIMEOUT"			=3D> 120,
+    "TMP_DIR"			=3D> "/tmp/ktest/\${MACHINE}",
+    "SLEEP_TIME"		=3D> 60,	# sleep time between tests
+    "BUILD_NOCLEAN"		=3D> 0,
+    "REBOOT_ON_ERROR"		=3D> 0,
+    "POWEROFF_ON_ERROR"		=3D> 0,
+    "REBOOT_ON_SUCCESS"		=3D> 1,
+    "POWEROFF_ON_SUCCESS"	=3D> 0,
+    "BUILD_OPTIONS"		=3D> "",
+    "BISECT_SLEEP_TIME"		=3D> 60,   # sleep time between bisects
+    "PATCHCHECK_SLEEP_TIME"	=3D> 60, # sleep time between patch checks
+    "CLEAR_LOG"			=3D> 0,
+    "BISECT_MANUAL"		=3D> 0,
+    "BISECT_SKIP"		=3D> 1,
+    "SUCCESS_LINE"		=3D> "login:",
+    "DETECT_TRIPLE_FAULT"	=3D> 1,
+    "NO_INSTALL"		=3D> 0,
+    "BOOTED_TIMEOUT"		=3D> 1,
+    "DIE_ON_FAILURE"		=3D> 1,
+    "SSH_EXEC"			=3D> "ssh \$SSH_USER\@\$MACHINE \$SSH_COMMAND",
+    "SCP_TO_TARGET"		=3D> "scp \$SRC_FILE \$SSH_USER\@\$MACHINE:\$DST_FILE=
",
+    "REBOOT"			=3D> "ssh \$SSH_USER\@\$MACHINE reboot",
+    "STOP_AFTER_SUCCESS"	=3D> 10,
+    "STOP_AFTER_FAILURE"	=3D> 60,
+    "STOP_TEST_AFTER"		=3D> 600,
=20
 # required, and we will ask users if they don't have them but we keep the =
default
 # value something that is common.
-$default{"REBOOT_TYPE"}		=3D "grub";
-$default{"LOCALVERSION"}	=3D "-test";
-$default{"SSH_USER"}		=3D "root";
-$default{"BUILD_TARGET"} 	=3D "arch/x86/boot/bzImage";
-$default{"TARGET_IMAGE"}	=3D "/boot/vmlinuz-test";
+    "REBOOT_TYPE"		=3D> "grub",
+    "LOCALVERSION"		=3D> "-test",
+    "SSH_USER"			=3D> "root",
+    "BUILD_TARGET"	 	=3D> "arch/x86/boot/bzImage",
+    "TARGET_IMAGE"		=3D> "/boot/vmlinuz-test",
+);
=20
 my $ktest_config;
 my $version;
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2JAAoJEIy3vGnGbaoADFIP/1T2jXdP7TVkxyuW2vuV+SuU
EQjPiAr16UyZUxy8V86hJva6IXwOsoKgQlSJOJ9hBggxFZzNL4JCpNQtPKiNFZiC
ELWUTlqMFFqX6MJl4NBlmCnBUdEljRegcxsvGebR0F82peqaOCPrSbn4ocR0MJrL
4fAFibr8TgaNU8PMzQO9Zuv9NaU9CETX/KEc0FzLhP4HBiFRL0eeUG4wI+skcv8y
NTK0fLr2Juay1/bA+avRq6Rloeu5vZOREXIdL82wzz5U5bMJkZi2ypMgzNrIlIuz
4NTc6cm3wnUECbPoNiYb2rl7MRxe4fIa1LuY4gzilzIxEWwqphR1zgJRbQ2nyNnS
14+lZiuOaMnR3r53N+/jfU0hNViUISYgbN/32DuaSaiEl2f7l3AC7ZKgcQTGs4mZ
zuuNJnI4tzaU1tqqjivs2ZEOdYYoCz4tWcPwjoGQfpnbv6Z410ApMhtJGfIgk6zC
uHDiQpSSQcmPGI30NcdNvRC3ERADxjMrBhjzUhejNlRXESG4Zh7wtFJ6uBWcY2tE
O6hTtQ0nhnE1xO8MxQVQmxbyUnzIsB9KQMEQsWlDUnRkqqgLgsiWXlMzUcTkDIr8
VuUpv2zvqRFojebLt8oo10xP4pJmFzU/pRge9COvh2clzo2RaOBrrwRlWZgUcare
JTyO35Txp+c1EVIqejzN
=WP1h
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
