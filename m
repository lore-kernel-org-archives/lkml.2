Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1JQQ75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:59:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab1JQQ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:54 -0400
X-Authority-Analysis: v=1.1 cv=UpSRffbr9y8V5xg6O7MBcDNOk5f8u00m038obrfOR4U= c=1 sm=0 a=vhdKIqpQuCYA:10 a=lUDviX6bF28A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=0slnyGKvdMgyuT5Kp-wA:9 a=VBQ40wU664IUMDWz9xwA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXFwqY4a_d1CbH8MFvwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165953.474825888@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:05:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 14/17][RFC] ktest: Add DEFINED keyword for IF statements
References: <20111017160455.498567257@goodmis.org>
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

iQIcBAABAgAGBQJOnF8JAAoJEIy3vGnGbaoAu5sQAKYfnl6o0dnK2bPQW1e6em+d
cXmfg1PVHDC2sy0jC3CUACFrK6cqmIeZVxTXPplYzrwLdAxvJmeOhHQh22NtxELG
zFXX3a7KSVECq2hCk5d5zMxrHi0IVpyCNjX12wJqeMr9UUJV/n5d3iD8cEFHhYzN
FsmMSbJXrnXJfCn9KHsacpL75hkdvsQMaRwoikUpuawjHfKgA/Hsl+6NdAfgRXIS
zG7dvaxY4To1xUpPbST6oS0KWeCaqO/UJu7RYkivTzVVKK0yAAxJt4zBPbMGaBym
dU3P3+OHRPAWHRu3ZvuBqLDJfuLA2yv3XRVv8GfJBnKuhC2qvB2spdqeCj7KcZQA
Xi5HVmYaxg+MMjHdyseFO2ODqjMrpnQy6KIW2SmiQjwwHwmecUXSknPjVTqPyuJe
YirMYMOTZ28vrHIYE5VZRmms+OnXK04BvE1GUOIxybBsJIx/HwgtrhtVNYvsrLrt
GHF2TXtOVGoZccyr+1soOHfZYvaCeE5Cz1MQ7DbHFPOEMumylpbL1JLopx0M9s8W
U1NxTzX+k3hIluqu/4JSF4fttY3e++OxYvQXWv1BxCXL27oi7UYldpA+WG1zLYdN
v5RCTzLFzOksqpEdtiED/ZT95xaoBez5ZfZftqlh4WJvxw62iBgQ6yiUSnTNkHpv
/8Py3YiWdMZg3W0gwBkJ
=L89i
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
