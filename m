Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab2AEDwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:52:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab2AEDsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:25 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=tOdWUv4ceDUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=hK5JIkN55_lAUV3QKq4A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=24XVVbvsU-2TY3Y9XnwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034824.252334199@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 11/20] ktest: Evaluate $KERNEL_VERSION in both install and post install
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0011-ktest-Evaluate-KERNEL_VERSION-in-both-install-and-po.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The install process may also need to know what the kernel version
is, to add it to the name. Evaluate it for both install and
post install.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 5d82c27..59738aa 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1434,12 +1434,19 @@ sub monitor {
     return 1;
 }
=20
+sub eval_kernel_version {
+    my ($option) =3D @_;
+
+    $option =3D~ s/\$KERNEL_VERSION/$version/g;
+
+    return $option;
+}
+
 sub do_post_install {
=20
     return if (!defined($post_install));
=20
-    my $cp_post_install =3D $post_install;
-    $cp_post_install =3D~ s/\$KERNEL_VERSION/$version/g;
+    my $cp_post_install =3D eval_kernel_version $post_install;
     run_command "$cp_post_install" or
 	dodie "Failed to run post install";
 }
@@ -1448,7 +1455,9 @@ sub install {
=20
     return if ($no_install);
=20
-    run_scp "$outputdir/$build_target", "$target_image" or
+    my $cp_target =3D eval_kernel_version $target_image;
+
+    run_scp "$outputdir/$build_target", "$cp_target" or
 	dodie "failed to copy image";
=20
     my $install_mods =3D 0;
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2IAAoJEIy3vGnGbaoA6AYQAKwgITdocEylYuI8plWm2czN
/uPxwDr424waNSfUUdAcjMW/gr3PqO3VBPKb1ubQHSScZ650daYpI/WPli3sJFJ7
/Hy7XtGvbvAoO7RHVGJRjfoIj0J8Pw67+9MR9gLTcMhwYC5E+DmCzhUKuST1Ai5M
rgTufoTNGdGc2yrOp+KqCC/tWzP6YsVi8Im097AT3JV4K8eEFSPZlQ/YNPqHoDS4
pnA7nHPXcjxuJX5JtI7K8zPYHsAqro60Q1adeW4ZirruYwVpBSOp39m9jYEhVm+r
O2Ng9rHL7oJ+S7mDrH3gmqQhQZ9/X4WcoHLnKkRJtbvHdcxUTCl6mS9veeTXus6D
/fwpaT/e/s5ysF7MijwpDn4xY2fR0fIlG2RMQyn4YhrsCI1fN2c0XlNTzNA2KzQa
5gmhRAAO4h8fWqyl1pbngextIc75uZfQX+FtPiJo/UPV0eqsArDqqGmlZZOqN7B8
cpWPevLauRJ6hgLaVNyQeYa4Y0uPq5JG189iOzHyVl0WAQ/9mIa+IM6reG4HYZoX
v7b7Fb4D59PQjA2fqXeMeFlch2dPMeB0RIM9F3wNYPbdx5RA8wi2WN/3px/EBQOy
+NP/h74w1nLJdcXZtW7qR2UcWd9tm2MDCrTAXN/GkxvcV97xpOZo/TD5vC5kHr3m
ZtiYkYUfIlK/uKHVHd8s
=Df3N
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
