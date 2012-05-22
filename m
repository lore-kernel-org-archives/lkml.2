Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2EVMHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:07:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2EVMGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:06:33 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=KP1sSWEGIIgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=qvgnN2efntMtMRT51B8A:9 a=rDbG9QKRT5wRbhZpLloA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=MVIDub7pGqn0emRRx04A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120522120631.162077952@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 22 May 2012 08:05:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/8] ktest: Add kvm.conf example config
References: <20120522120531.460108326@goodmis.org>
Content-Disposition: inline; filename=0005-ktest-Add-kvm.conf-example-config.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add an example config that explains how to use ktest with a virtual
guest as the target.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/examples/kvm.conf |   88 +++++++++++++++++++++++++++++=
++++
 1 file changed, 88 insertions(+)
 create mode 100644 tools/testing/ktest/examples/kvm.conf

diff --git a/tools/testing/ktest/examples/kvm.conf b/tools/testing/ktest/ex=
amples/kvm.conf
new file mode 100644
index 0000000..831c7c5
--- /dev/null
+++ b/tools/testing/ktest/examples/kvm.conf
@@ -0,0 +1,88 @@
+#
+# This config is an example usage of ktest.pl with a kvm guest
+#
+# The guest is called 'Guest' and this would be something that
+# could be run on the host to test a virtual machine target.
+
+MACHINE =3D Guest
+
+
+# Use virsh to read the serial console of the guest
+CONSOLE =3D  virsh console ${MACHINE}
+
+#*************************************#
+# This part is the same as test.conf  #
+#*************************************#
+
+# The include files will set up the type of test to run. Just set TEST to
+# which test you want to run.
+#
+# TESTS =3D patchcheck, randconfig, boot, test, config-bisect, bisect, min=
-config
+#
+# See the include/*.conf files that define these tests
+#
+TEST :=3D patchcheck
+
+# Some tests may have more than one test to run. Define MULTI :=3D 1 to run
+# the extra tests.
+MULTI :=3D 0
+
+# In case you want to differentiate which type of system you are testing
+BITS :=3D 64
+
+# REBOOT =3D none, error, fail, empty
+#  See include/defaults.conf
+REBOOT :=3D empty
+
+
+# The defaults file will set up various settings that can be used by all
+# machine configs.
+INCLUDE include/defaults.conf
+
+
+#*************************************#
+# Now we are different from test.conf #
+#*************************************#
+
+
+# The example here assumes that Guest is running a Fedora release
+# that uses dracut for its initfs. The POST_INSTALL will be executed
+# after the install of the kernel and modules are complete.
+#
+POST_INSTALL =3D ${SSH} /sbin/dracut -f /boot/initramfs-test.img $KERNEL_V=
ERSION
+
+# Guests sometimes get stuck on reboot. We wait 3 seconds after running
+# the reboot command and then  do a full power-cycle of the guest.
+# This forces the guest to restart.
+#
+POWERCYCLE_AFTER_REBOOT =3D 3
+
+# We do the same after the halt command, but this time we wait 20 seconds.
+POWEROFF_AFTER_HALT =3D 20
+
+
+# As the defaults.conf file has a POWER_CYCLE option already defined,
+# and options can not be defined in the same section more than once
+# (all DEFAULTS sections are considered the same). We use the
+# DEFAULTS OVERRIDE to tell ktest.pl to ignore the previous defined
+# options, for the options set in the OVERRIDE section.
+#
+DEFAULTS OVERRIDE
+
+# Instead of using the default POWER_CYCLE option defined in
+# defaults.conf, we use virsh to cycle it. To do so, we destroy
+# the guest, wait 5 seconds, and then start it up again.
+# Crude, but effective.
+#
+POWER_CYCLE =3D virsh destroy ${MACHINE}; sleep 5; virsh start ${MACHINE}
+
+
+DEFAULTS
+
+# The following files each handle a different test case.
+# Having them included allows you to set up more than one machine and share
+# the same tests.
+INCLUDE include/patchcheck.conf
+INCLUDE include/tests.conf
+INCLUDE include/bisect.conf
+INCLUDE include/min-config.conf
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu4FHAAoJEIy3vGnGbaoAIMAQAIYxgRjteS6WoOQAd2yr7Mqp
ieaxBi8lrPGlXT/xYcyfD/KdbVn83rWXHbdkTBV0F7MWLOevgKGVey5mKoNlMGEc
LQD4HR8pSUL0sm3fiC4hEvyYV3MCI6LmpW2wWV6FsgcQUqTlIQZnlBnzdfYi2uhf
kBUy70t4aF6t6vFHZEWHgkx6dIVuz/b85j9xL/12zy2WRbjwFp34t76uP5KBMgAL
1mQgaK1K62drSNDVgcwWz2pdreg3NJeYep3zvJEwb46BpSB3VlGDFoWEQ9c8RUMZ
lGgqsMfAiC7ZKoTiP+LsiQOVTdZg0EJGT7+tmcTW0iyDhxw5Or59rrovEOyi3HGb
KvIl7cZWdUoSAF1PkZ/RC1qMTmzV6OW4tcyR8RnNzpCscWJhJiiHW4605JAD5lLS
1NhyRDe1EJ8Zo+uMLe2eG3WXz+RR+zsBrUpzNOfxy9lwQXza0F0QQmoLnCI/Z4Jg
xkaDLVPS4Vcb/EpVq88LsGB0k+jkV2LgyNBmWR5vHkvakIwCBStrcbNi2mEWE2G+
blCtAXLeR2RrmWdtKoqEjqX931SJj1m0ixJDVOT0tghXr21R0opgZ+gAo6prUD9n
RNjVTKEzDuj+QiF1i5Qci191UxicAEiyyLeJXGDynemlqNz3c+EpTv53DvWysUl1
vmU72M1DJvKJcAmqdvXD
=0aeH
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
