Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1J1LUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:20:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36678 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab1J1LUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:06 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ziIHA_QwkPoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1_ydI7Sl2YjKxvQt_dMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=HTnhjFr0Yai4aNeI-DYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112001.686431154@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:15:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/21] ktest: Add TEST_TYPE install option
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Add-TEST_TYPE-install-option.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

In testing one of my boxes, I found that I only wanted to build and
install the kernel. I wanted to manually reboot the box and test it.
Adding a TEST_TYPE option "install" allows this to happen.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |    7 +++++++
 tools/testing/ktest/sample.conf |    7 ++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 8d02ccb..e087cb4 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2929,6 +2929,13 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 	build $build_type or next;
     }
=20
+    if ($test_type eq "install") {
+	get_version;
+	install;
+	success $i;
+	next;
+    }
+
     if ($test_type ne "build") {
 	my $failed =3D 0;
 	start_monitor_and_boot or $failed =3D 1;
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index b8bcd14..eadca3e 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -253,9 +253,10 @@
=20
 # The default test type (default test)
 # The test types may be:
-#   build - only build the kernel, do nothing else
-#   boot - build and boot the kernel
-#   test - build, boot and if TEST is set, run the test script
+#   build   - only build the kernel, do nothing else
+#   install - build and install, but do nothing else (does not reboot)
+#   boot    - build, install, and boot the kernel
+#   test    - build, boot and if TEST is set, run the test script
 #          (If TEST is not set, it defaults back to boot)
 #   bisect - Perform a bisect on the kernel (see BISECT_TYPE below)
 #   patchcheck - Do a test on a series of commits in git (see PATCHCHECK b=
elow)
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqo/hAAoJEIy3vGnGbaoAFRAP/1LN5+iMQzL+F5DGVimLJUXz
7/IBcZuugJDlPW7pZTBPWP2yIxxTs6RiMHSLumi3M9wxvFnqkm0p9WobHjs0oIea
FIXAkXPQ3K6p2eVkW8MVXHI5Rgy+PEexW/UlzWfOew9BUSUmlh1UjW/kSpGsjTX7
9kYGAC8eAi4c3gwlU7IP/TfQqmygMe3gVWRzWwRZZ1tFJKEJgdoHk5Nq1a6YH85C
KboNwNjXKpuiWRUFOQFGvrF7nVlSB7JILmrT3i1leJ7JhBN3Kbp/KdqYuZDRENnM
+L2/r56O4WNyegUH0X18MdDwVLMxmjSrII8b/ZGFTP06YIuSAHwd1MNaPIHfuHEz
Ry5exQjNGqxQsznqReT93FPpiUpJmjaiHQXu/3ist+e9sWVPp76rzF9GM5yyTtpJ
dllExrq8yP1tFxxtrdgvp1sxm4LKDHtwoBanjm9Y3bqHrsg79K+Eyefx6TkArsfA
FW/01wDK7aXfjgB08X3qbbmPql/mJJZX3yi+QUO+XA+f2BNNVfFG4th/YNcgXdcn
ZR89CfN3Nu3FYGh2+POtpW9NkcXrLPAWAMTGToMoTj6Vc7aGC4cdn58WwkRIbPw0
LE93Lfg5lEze50EuDYCvkSfejF+W7U10ft2f1UEmE4edq+p93FNcbyv55wJE7Enx
I36lbEDVNCLQ3yZviiqh
=Euhc
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
