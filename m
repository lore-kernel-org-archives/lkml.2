Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab2EVMHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:07:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2EVMGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:06:33 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=_rl69MnQMSsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=AKVeho1twCSwqVxSH8oA:9 a=p9p9aN1otFN3m6o7DGoA:7 a=QEXdDO2ut3YA:10 a=Gq9PjJF5URkA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=MQJHA3lZQe0F0YpSihAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120522120631.811336462@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 22 May 2012 08:05:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 7/8] ktest: Add the snowball.conf example config
References: <20120522120531.460108326@goodmis.org>
Content-Disposition: inline; filename=0007-ktest-Add-the-snowball.conf-example-config.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

I used the snowball.conf in a live demo that demonstrated how to use
ktest.pl with a snowball ARM board. I've been asked to included that
config in the ktest repository.

Here it is.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/examples/snowball.conf |   53 ++++++++++++++++++++++++=
++++
 1 file changed, 53 insertions(+)
 create mode 100644 tools/testing/ktest/examples/snowball.conf

diff --git a/tools/testing/ktest/examples/snowball.conf b/tools/testing/kte=
st/examples/snowball.conf
new file mode 100644
index 0000000..a82a3c5
--- /dev/null
+++ b/tools/testing/ktest/examples/snowball.conf
@@ -0,0 +1,53 @@
+# This example was used to boot the snowball ARM board.
+# See http://people.redhat.com/srostedt/ktest-embedded-2012/
+
+# PWD is a ktest.pl variable that will result in the process working
+# directory that ktest.pl is executed in.
+
+# THIS_DIR is automatically assigned the PWD of the path that generated
+# the config file. It is best to use this variable when assigning other
+# directory paths within this directory. This allows you to easily
+# move the test cases to other locations or to other machines.
+#
+THIS_DIR :=3D /home/rostedt/work/demo/ktest-embed
+LOG_FILE =3D ${OUTPUT_DIR}/snowball.log
+CLEAR_LOG =3D 1
+MAKE_CMD =3D PATH=3D/usr/local/gcc-4.5.2-nolibc/arm-unknown-linux-gnueabi/=
bin:$PATH CROSS_COMPILE=3Darm-unknown-linux-gnueabi- make ARCH=3Darm
+ADD_CONFIG =3D ${THIS_DIR}/addconfig
+
+SCP_TO_TARGET =3D echo "don't do scp"
+
+TFTPBOOT :=3D /var/lib/tftpboot
+TFTPDEF :=3D ${TFTPBOOT}/snowball-default
+TFTPTEST :=3D ${OUTPUT_DIR}/${BUILD_TARGET}
+
+SWITCH_TO_GOOD =3D cp ${TFTPDEF} ${TARGET_IMAGE}
+SWITCH_TO_TEST =3D cp ${TFTPTEST} ${TARGET_IMAGE}
+
+# Define each test with TEST_START
+# The config options below it will override the defaults
+TEST_START SKIP
+TEST_TYPE =3D boot
+BUILD_TYPE =3D u8500_defconfig
+BUILD_NOCLEAN =3D 1
+
+TEST_START
+TEST_TYPE =3D make_min_config
+OUTPUT_MIN_CONFIG =3D ${THIS_DIR}/config.newmin
+START_MIN_CONFIG =3D ${THIS_DIR}/config.orig
+IGNORE_CONFIG =3D ${THIS_DIR}/config.ignore
+BUILD_NOCLEAN =3D 1
+
+
+DEFAULTS
+LOCALVERSION =3D -test
+POWER_CYCLE =3D echo use the thumb luke; read a
+CONSOLE =3D cat ${THIS_DIR}/snowball-cat
+REBOOT_TYPE =3D script
+SSH_USER =3D root
+BUILD_OPTIONS =3D -j8 uImage
+BUILD_DIR =3D ${THIS_DIR}/linux.git
+OUTPUT_DIR =3D ${THIS_DIR}/snowball-build
+MACHINE =3D snowball
+TARGET_IMAGE =3D /var/lib/tftpboot/snowball-image
+BUILD_TARGET =3D arch/arm/boot/uImage
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu4FHAAoJEIy3vGnGbaoAbaYQALcqDlRebGcTCx2GPJdbZnAC
xjh4MWqlU7aDfEP1PAdiKP2pDIcPKJTAoaLSNSjIno9gODBeQPLpFer86LzY5k3y
qBmjgquRbwuyunsT5uyNhzOgBtjxlgw581lyzrNimL6dio4JUnJzDk0sJQRBZpZa
HhVw3eQbkB4gEXAqRdGlqyG4iOtM637eBrC5DMPwUFvlHs7SaVew4IX9xWoHewuZ
00uFbWe9wpzsSB/Nj+UtTbazMVT0Is1KwmkhuYS8yHG0AOZ0UzO0whH4FeTZGpmJ
Mdt5ug4QzcY4KiUZcVo2gArm6SgXwjiZY/l5B5o/GedPm+T49mIPYBK2bKgNricz
GracHSZmSWwxVvNR4+fYs3+Cnd2YGFNyYKf6GXWq9qu1wwoqsDcmx5EhtmyAtsU/
Ntdol90wHwqidfNwczoZH4MqgY86TPjfPS8bn1Zg/gvxtYkQliT+FYxD+iNNAsxr
vQCX0tlx4fRy8Xtbe3O/HA9AGsWi8HbdUNsRax+uYuhfBiSmWMFbhI52VKIJwJjh
YnD4ckyG8WL3qJGz9oL7sA3Q22tQlDGB/v//VYgiPmu10538jNo+ZpICZXXBUEtL
mLIF+O42PNEw/G3sDpo0Ysa1sLcvZbrMha+29GQryzPNgeybmu9TA28yN83vu0Sd
1ChQVTNLJoYULNCzJjyD
=rImY
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
