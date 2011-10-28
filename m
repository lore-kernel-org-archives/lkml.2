Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1J1LWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:22:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1J1LUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:34 -0400
X-Authority-Analysis: v=1.1 cv=rFxaVhpzdNKRsWyFDFmDbYx/QEtlW7L1Gw9MiLxO4aw= c=1 sm=0 a=vhdKIqpQuCYA:10 a=i_TvSU8IsywA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=0slnyGKvdMgyuT5Kp-wA:9 a=VBQ40wU664IUMDWz9xwA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=FTOzMgJJJFNpqJUHZeoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112030.817512818@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 14/21] ktest: Add DEFINED keyword for IF statements
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0014-ktest-Add-DEFINED-keyword-for-IF-statements.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Have IF statements process if a config variable or option has been
defined or not. Can use NOT DEFINED in the case for telling if
a variable or option has not been defined.

DEFAULTS IF NOT DEFINED SSH_USER
SSH_USER =3D root

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   17 ++++++++++++++++-
 tools/testing/ktest/sample.conf |   17 +++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 7bce412..76a5964 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -396,6 +396,13 @@ sub process_compare {
     return $ret;
 }
=20
+sub value_defined {
+    my ($val) =3D @_;
+
+    return defined($variable{$2}) ||
+	defined($opt{$2});
+}
+
 sub process_if {
     my ($name, $value) =3D @_;
=20
@@ -409,13 +416,21 @@ sub process_if {
 	return $ret;
     }
=20
+    if ($val =3D~ /^\s*(NOT\s*)?DEFINED\s+(\S+)\s*$/) {
+	if (defined $1) {
+	    return !value_defined($2);
+	} else {
+	    return value_defined($2);
+	}
+    }
+
     if ($val =3D~ /^\s*0\s*$/) {
 	return 0;
     } elsif ($val =3D~ /^\s*\d+\s*$/) {
 	return 1;
     }
=20
-    die ("$name: $.: Undefined variable $val in if statement\n");
+    die ("$name: $.: Undefined content $val in if statement\n");
     return 1;
 }
=20
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 0fd3ca3..7b49f07 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -137,6 +137,23 @@
 # ELSE
 # BUILD_TYPE =3D useconfig:${CONFIG_DIR}/config-64
 #
+# The DEFINED keyword can be used by the IF statements too.
+# It returns true if the given config variable or option has been defined
+# or false otherwise.
+#
+#=20
+# DEFAULTS IF DEFINED USE_CC
+# CC :=3D ${USE_CC}
+# ELSE
+# CC :=3D gcc
+#
+#
+# As well as NOT DEFINED.
+#
+# DEFAULTS IF NOT DEFINED MAKE_CMD
+# MAKE_CMD :=3D make ARCH=3Dx86
+#
+#
 #
 # INCLUDE file
 #
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqo//AAoJEIy3vGnGbaoAbogP/iylFF/jEPIov+4wnFGCo2DX
CDwXk6KBuySUgi4ky2GNOn+BrfohK9RFrEHDbC5hXZv2W8xw3ZbGM3gfHZzu72lC
FsO9gTA/Nn+MzPKgjmrTeq7en5cbZVchhOjqzHAO9vVoBMBoR/MiTerXAgQgkj7e
kn1QshPUgpQ/vshv9CMcRPseeLxngQ8j4kf4wvaw8QjVeI+wqcjzm+Q9qtsxg/P8
7DAnimc9Jvn+cR5IeixW52pg6zLELpL3TfN29aOCFS/Kl/ufvpPYAJvi0e7Hfovg
esJ/EyseI5uVAVVnJfJYar1nG/3CH7m7Cp61dtgOUORb2+G+W66GjpSEanF1dsFr
tPAY1JYGbQDJOUaN1qPVVSQskakzcKowXS6ZLYeAfSWm7p6qH6pxlmzxxe3//UvQ
j20VEsIUHXPevbBPdCBbiDwXinsfgDphHbcIgkoGsgEeNIpAjxWVf7WcrRp3DzGZ
Lhw580rwTs5nikZj+B3oLaqpg7xgJ2GfRGp7QFCoAcOSMpGy70MA4nlZBEbvswm0
3uaTILjQ7DLbRUFYiQYJ/omXyJeiMQ1Y8Akgrlyi62Jzo0hFKPpDLgQrNbDptxa2
1kMywo4ywcv3YWCynSVIAp18YizkBq+VMS/MU2a8isSupYBBG6YxbKKuRI7BHRc+
P0JSerOZqMY97+kb+1NN
=ce9S
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
