Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2EVMHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:07:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24925 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2EVMGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:06:33 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=h1hxA0XZ_oIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=jb7vWrWlTaw2inX9P_oA:9 a=D6giC2qzlhNRLoyFfI4A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=n8G06In40gb5DIYgeyEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120522120631.472085513@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 22 May 2012 08:05:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6/8] ktest: Add an example config that does cross compiling of several
 archs
References: <20120522120531.460108326@goodmis.org>
Content-Disposition: inline; filename=0006-ktest-Add-an-example-config-that-does-cross-compilin.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add the config that I use to test several archs. I downloaded several
cross compilers from:

 http://kernel.org/pub/tools/crosstool/files/bin/x86_64/

and this config is an example to crosscompile several archs to make sure
that your changes do not break archs that you are not working on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/examples/crosstests.conf |  260 ++++++++++++++++++++++=
++++
 1 file changed, 260 insertions(+)
 create mode 100644 tools/testing/ktest/examples/crosstests.conf

diff --git a/tools/testing/ktest/examples/crosstests.conf b/tools/testing/k=
test/examples/crosstests.conf
new file mode 100644
index 0000000..4673660
--- /dev/null
+++ b/tools/testing/ktest/examples/crosstests.conf
@@ -0,0 +1,260 @@
+#
+# Example config for cross compiling
+#
+# In this config, it is expected that the tool chains from:
+#
+#   http://kernel.org/pub/tools/crosstool/files/bin/x86_64/
+#
+# running on a x86_64 system have been downloaded and installed into:
+#
+#   /usr/local/
+#
+# such that the compiler binaries are something like:
+#
+#   /usr/local/gcc-4.5.2-nolibc/mips-linux/bin/mips-linux-gcc
+#
+# Some of the archs will use gcc-4.5.1 instead of gcc-4.5.2
+# this config uses variables to differentiate them.
+#=20
+# Comments describe some of the options, but full descriptions of
+# options are described in the samples.conf file.
+
+# ${PWD} is defined by ktest.pl to be the directory that the user
+# was in when they executed ktest.pl. It may be better to hardcode the
+# path name here. THIS_DIR is the variable used through out the config file
+# in case you want to change it.
+
+THIS_DIR :=3D ${PWD}
+
+# Update the BUILD_DIR option to the location of your git repo you want to=
 test.
+BUILD_DIR =3D ${THIS_DIR}/linux.git
+
+# The build will go into this directory. It will be created when you run t=
he test.
+OUTPUT_DIR =3D ${THIS_DIR}/cross-compile
+
+# The build will be compiled with -j8
+BUILD_OPTIONS =3D -j8
+
+# The test will not stop when it hits a failure.
+DIE_ON_FAILURE =3D 0
+
+# If you want to have ktest.pl store the failure somewhere, uncomment this=
 option
+# and change the directory where ktest should store the failures.
+#STORE_FAILURES =3D ${THIS_DIR}/failures
+
+# The log file is stored in the OUTPUT_DIR called cross.log
+# If you enable this, you need to create the OUTPUT_DIR. It wont be create=
d for you.
+LOG_FILE =3D ${OUTPUT_DIR}/cross.log
+
+# The log file will be cleared each time you run ktest.
+CLEAR_LOG =3D 1
+
+# As some archs do not build with the defconfig, they have been marked
+# to be ignored. If you want to test them anyway, change DO_FAILED to 1.
+# If a test that has been marked as DO_FAILED passes, then you should chan=
ge
+# that test to be DO_DEFAULT
+
+DO_FAILED :=3D 0
+DO_DEFAULT :=3D 1
+
+# By setting both DO_FAILED and DO_DEFAULT to zero, you can pick a single
+# arch that you want to test. (uncomment RUN and chose your arch)
+#RUN :=3D m32r
+
+# At the bottom of the config file exists a bisect test. You can update th=
at
+# test and set DO_FAILED and DO_DEFAULT to zero, and uncomment this variab=
le
+# to run the bisect on the arch.
+#RUN :=3D bisect
+
+# By default all tests will be running gcc 4.5.2. Some tests are using 4.5=
.1
+# and they select that in the test.
+# Note: GCC_VER is declared as on option and not a variable ('=3D' instead=
 of ':=3D')
+# This is important. A variable is used only in the config file and if it =
is set
+# it stays that way for the rest of the config file until it is change aga=
in.
+# Here we want GCC_VER to remain persistent and change for each test, as i=
t is used in
+# the MAKE_CMD. By using '=3D' instead of ':=3D' we achieve our goal.
+
+GCC_VER =3D 4.5.2
+MAKE_CMD =3D PATH=3D/usr/local/gcc-${GCC_VER}-nolibc/${CROSS}/bin:$PATH CR=
OSS_COMPILE=3D${CROSS}- make ARCH=3D${ARCH}
+
+# all tests are only doing builds.
+TEST_TYPE =3D build
+
+# If you want to add configs on top of the defconfig, you can add those co=
nfigs into
+# the add-config file and uncomment this option. This is useful if you wan=
t to test
+# all cross compiles with PREEMPT set, or TRACING on, etc.
+#ADD_CONFIG =3D ${THIS_DIR}/add-config
+
+# All tests are using defconfig
+BUILD_TYPE =3D defconfig
+
+# The test names will have the arch and cross compiler used. This will be =
shown in
+# the results.
+TEST_NAME =3D ${ARCH} ${CROSS}
+
+# alpha
+TEST_START IF ${RUN} =3D=3D alpha || ${DO_DEFAULT}
+# Notice that CROSS and ARCH are also options and not variables (again '=
=3D' instead
+# of ':=3D'). This is because TEST_NAME and MAKE_CMD wil use them for each=
 test.
+# Only options are available during runs. Variables are only present in pa=
rsing the
+# config file.
+CROSS =3D alpha-linux
+ARCH =3D alpha
+
+# arm
+TEST_START IF ${RUN} =3D=3D arm || ${DO_DEFAULT}
+CROSS =3D arm-unknown-linux-gnueabi
+ARCH =3D arm
+
+# black fin
+TEST_START IF ${RUN} =3D=3D bfin || ${DO_DEFAULT}
+CROSS =3D bfin-uclinux
+ARCH =3D blackfin
+BUILD_OPTIONS =3D -j8 vmlinux
+
+# cris - FAILS?
+TEST_START IF ${RUN} =3D=3D cris || ${RUN} =3D=3D cris64 || ${DO_FAILED}
+CROSS =3D cris-linux
+ARCH =3D cris
+
+# cris32 - not right arch?
+TEST_START IF ${RUN} =3D=3D cris || ${RUN} =3D=3D cris32 || ${DO_FAILED}
+CROSS =3D crisv32-linux
+ARCH =3D cris
+
+# ia64
+TEST_START IF ${RUN} =3D=3D ia64 || ${DO_DEFAULT}
+CROSS =3D ia64-linux
+ARCH =3D ia64
+
+# frv
+TEST_START IF ${RUN} =3D=3D frv || ${DO_FAILED}
+CROSS =3D frv-linux
+ARCH =3D frv
+GCC_VER =3D 4.5.1
+
+# h8300 - failed make defconfig??
+TEST_START IF ${RUN} =3D=3D h8300 || ${DO_FAILED}
+CROSS =3D h8300-elf
+ARCH =3D h8300
+GCC_VER =3D 4.5.1
+
+# m68k fails with error?
+TEST_START IF ${RUN} =3D=3D m68k || ${DO_DEFAULT}
+CROSS =3D m68k-linux
+ARCH =3D m68k
+
+# mips64
+TEST_START IF ${RUN} =3D=3D mips || ${RUN} =3D=3D mips64 || ${DO_DEFAULT}
+CROSS =3D mips64-linux
+ARCH =3D mips
+
+# mips32
+TEST_START IF ${RUN} =3D=3D mips || ${RUN} =3D=3D mips32 || ${DO_DEFAULT}
+CROSS =3D mips-linux
+ARCH =3D mips
+
+# m32r
+TEST_START IF ${RUN} =3D=3D m32r || ${DO_FAILED}
+CROSS =3D m32r-linux
+ARCH =3D m32r
+GCC_VER =3D 4.5.1
+BUILD_OPTIONS =3D -j8 vmlinux
+
+# parisc64 failed?
+TEST_START IF ${RUN} =3D=3D hppa || ${RUN} =3D=3D hppa64 || ${DO_FAILED}
+CROSS =3D hppa64-linux
+ARCH =3D parisc
+
+# parisc
+TEST_START IF ${RUN} =3D=3D hppa || ${RUN} =3D=3D hppa32 || ${DO_FAILED}
+CROSS =3D hppa-linux
+ARCH =3D parisc
+
+# ppc
+TEST_START IF ${RUN} =3D=3D ppc || ${RUN} =3D=3D ppc32 || ${DO_DEFAULT}
+CROSS =3D powerpc-linux
+ARCH =3D powerpc
+
+# ppc64
+TEST_START IF ${RUN} =3D=3D ppc || ${RUN} =3D=3D ppc64 || ${DO_DEFAULT}
+CROSS =3D powerpc64-linux
+ARCH =3D powerpc
+
+# s390
+TEST_START IF ${RUN} =3D=3D s390 || ${DO_DEFAULT}
+CROSS =3D s390x-linux
+ARCH =3D s390
+
+# sh
+TEST_START IF ${RUN} =3D=3D sh || ${DO_DEFAULT}
+CROSS =3D sh4-linux
+ARCH =3D sh
+
+# sparc64
+TEST_START IF ${RUN} =3D=3D sparc || ${RUN} =3D=3D sparc64 || ${DO_DEFAULT}
+CROSS =3D sparc64-linux
+ARCH =3D sparc64
+
+# sparc
+TEST_START IF ${RUN} =3D=3D sparc || ${RUN} =3D=3D sparc32 || ${DO_DEFAULT}
+CROSS =3D sparc-linux
+ARCH =3D sparc
+
+# xtensa failed
+TEST_START IF ${RUN} =3D=3D xtensa || ${DO_FAILED}
+CROSS =3D xtensa-linux
+ARCH =3D xtensa
+
+# UML
+TEST_START IF ${RUN} =3D=3D uml || ${DO_DEFAULT}
+MAKE_CMD =3D make ARCH=3Dum SUBARCH=3Dx86_64
+ARCH =3D uml
+CROSS =3D
+
+TEST_START IF ${RUN} =3D=3D x86 || ${RUN} =3D=3D i386 || ${DO_DEFAULT}
+MAKE_CMD =3D make ARCH=3Di386
+ARCH =3D i386
+CROSS =3D=20
+
+TEST_START IF ${RUN} =3D=3D x86 || ${RUN} =3D=3D x86_64 || ${DO_DEFAULT}
+MAKE_CMD =3D make ARCH=3Dx86_64
+ARCH =3D x86_64
+CROSS =3D=20
+
+#################################
+
+# This is a bisect if needed. You need to give it a MIN_CONFIG that
+# will be the config file it uses. Basically, just copy the created defcon=
fig
+# for the arch someplace and point MIN_CONFIG to it.
+TEST_START IF ${RUN} =3D=3D bisect
+MIN_CONFIG =3D ${THIS_DIR}/min-config
+CROSS =3D s390x-linux
+ARCH =3D s390
+TEST_TYPE =3D bisect
+BISECT_TYPE =3D build
+BISECT_GOOD =3D v3.1
+BISECT_BAD =3D v3.2
+CHECKOUT =3D v3.2
+
+#################################
+
+# These defaults are needed to keep ktest.pl from complaining. They are
+# ignored because the test does not go pass the build. No install or
+# booting of the target images.
+
+DEFAULTS
+MACHINE =3D crosstest
+SSH_USER =3D root
+BUILD_TARGET =3D cross
+TARGET_IMAGE =3D image
+POWER_CYCLE =3D cycle
+CONSOLE =3D console
+LOCALVERSION =3D version
+GRUB_MENU =3D grub
+
+REBOOT_ON_ERROR =3D 0
+POWEROFF_ON_ERROR =3D 0
+POWEROFF_ON_SUCCESS =3D 0
+REBOOT_ON_SUCCESS =3D 0
+
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu4FHAAoJEIy3vGnGbaoAWzoQAJg0rQmQbRkEXigx98t5URm0
ehxdHhyjcTyECEgSFRSe534RVxaTv1n5S9CoCxIzMgvV8foYDy4ke42T79ulY0h1
+GH389ZXhxLKnH1kto5WiSzf5kDoLJH3REx4MuIw/XtwjEUkVBY+ySXVwqi/ZHKL
HKaZXnFtrVQe/mVp8TdFOzlNsezX7NqzXv+XqGye6KUV5JzZJyHuAtbFNuxQCWds
meD1poVw4cCisL1rj7YJa4GyJl5R8DbejDMgVvid+6ZjPr6oz8keP0K63ereGJCC
bB5M7btOnhcCrQtkgX74SEaI0fFOWfMQGUuzHJ6IhoiH7z3MR9FiqcbAh9AiuXPp
ryhbgyhtjKoAe8EKij7SU6b/262cKLdiFymzO4oo9Pd46m2LGCtmn441eAP1amZm
lZFZHTOtMwCCmQifonuXffJ7BOCIqYV+ERS1IcKR7WyCO6kwiYDJDobrj/mL15Es
bytgw5G/epcPMKNSGsMgRlrCjq2HNiugnsX1pTFX0Lj9XVH/6BuVYNxbcgHrxXkS
xpZx3eTQb506jo/Fw5uKv7/N0nWz3JPHxlJEO50/Z6nn0lLJyaXUUzUzfB6eY06M
lG45CQJ/fXHaaqTBGTwScHaIqUvwNtsqGJEZLCm8S8FtMSVUXcRqmhv0yu9LvoT6
Y/MaM6/ptFYifteTSTpl
=qER3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
