Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1JQQ7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:59:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1JQQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:48 -0400
X-Authority-Analysis: v=1.1 cv=UpSRffbr9y8V5xg6O7MBcDNOk5f8u00m038obrfOR4U= c=1 sm=0 a=vhdKIqpQuCYA:10 a=cduR4O7mHtkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1_ydI7Sl2YjKxvQt_dMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=aNWANMpNj92KJJjyDagA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165947.145747873@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:04:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/17][RFC] ktest: Add TEST_TYPE install option
References: <20111017160455.498567257@goodmis.org>
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

iQIcBAABAgAGBQJOnF8DAAoJEIy3vGnGbaoAPgQP/Aifa4E1H5PRgAKhbw40Z7bI
Dj3bkG2pY+EQsA/37gqnHNK20XjacUYCytZuAaTvw/aRgH06qNMTaNJSQ/pA2Gbi
ud3UjQRVzOYyVpAKf7edMlmAvF53lMvNl3cp1BjuIBiJPO82HQ2FqyDjWTXPa/gx
VmAkQSDKF2MzQ//eKeCkUxJ1VSZiqkzdyRrZ31yofTZ1EY6QLVzvzMcyM2bRuR/Z
tDLj2aQkpUMkIB/Bx1wGmW3XjWDORlzKdp55ln8dcN8A/YoiN7ALeZIWujSACGxI
NqUg+nGQcfa4i1JaMFmVwGXihdFzui2YOqHzOF0Hu/rOfxgCnpnh0Ul2y/lYDEtZ
shXh5d7Y4uD0Jr3/nUFTdk55D9JhtFQRe6Y7LQ/MBksHDdwk0kHUTmENsV1EgHS5
wMuHwyEi33gJ2lPUDvGxOE/oage703sRuq/Q0qCdvK72QwblzrW01nLlhejPDYHn
NW51o2cbngWdGqUt+/qdnGku9RTSpLsRKNRerEzAc2zGEcewslt/OBAR16EE0mWH
VPENv8rK7nyJLZEUfPJc1NeRlG2g/ncnxr0lY9VTUeIMDkEcYq9iJyU/75IS27ub
Zx3HcFoY38KU3rld8GxvNGykpsgyCi30OEa0/V0noxJ35CORgPS8o9ch+EKWnoQd
+JX4cx7cXcMkAlqvCRP2
=5zdk
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
