Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2AEDwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:52:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab2AEDsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:23 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=DxFoSLxjsKEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Qvg6_H1qJCzj3uJL60wA:9 a=QEXdDO2ut3YA:10 a=ByEePuvHlDcA:10 a=jeBq3FmKZ4MA:10 a=cg_oJoINW8wxdtk3:21 a=zze8ylNvN_aZw4qr:21 a=pQStKcII-U8djQD8eOQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034821.304685595@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:47:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 02/20] ktest: Save test output
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Save-test-output.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Rabin Vincent <rabin@rab.in>

The test output may contain useful information; save it along with the
already-saved buildlog, dmesg, and .config.

Link: http://lkml.kernel.org/r/1321616131-21352-1-git-send-email-rabin@rab.=
in

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 8b4c253..e93c21c 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -103,6 +103,7 @@ my $in_patchcheck =3D 0;
 my $run_test;
 my $redirect;
 my $buildlog;
+my $testlog;
 my $dmesg;
 my $monitor_fp;
 my $monitor_pid;
@@ -1021,17 +1022,19 @@ sub fail {
 	    mkpath($faildir) or
 		die "can't create $faildir";
 	}
-	if (-f "$output_config") {
-	    cp "$output_config", "$faildir/config" or
-		die "failed to copy .config";
-	}
-	if (-f $buildlog) {
-	    cp $buildlog, "$faildir/buildlog" or
-		die "failed to move $buildlog";
-	}
-	if (-f $dmesg) {
-	    cp $dmesg, "$faildir/dmesg" or
-		die "failed to move $dmesg";
+
+	my %files =3D (
+		"config" =3D> $output_config,
+		"buildlog" =3D> $buildlog,
+		"dmesg" =3D> $dmesg,
+		"testlog" =3D> $testlog,
+	);
+
+	while (my ($name, $source) =3D each(%files)) {
+		if (-f "$source") {
+			cp "$source", "$faildir/$name" or
+				die "failed to copy $source";
+		}
 	}
=20
 	doprint "*** Saved info to $faildir ***\n";
@@ -1669,7 +1672,10 @@ sub child_run_test {
     $poweroff_on_error =3D 0;
     $die_on_failure =3D 1;
=20
+    $redirect =3D "$testlog";
     run_command $run_test or $failed =3D 1;
+    undef $redirect;
+
     exit $failed;
 }
=20
@@ -3169,6 +3175,7 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     $target =3D "$ssh_user\@$machine";
=20
     $buildlog =3D "$tmpdir/buildlog-$machine";
+    $testlog =3D "$tmpdir/testlog-$machine";
     $dmesg =3D "$tmpdir/dmesg-$machine";
     $make =3D "$makecmd O=3D$outputdir";
     $output_config =3D "$outputdir/.config";
@@ -3205,6 +3212,7 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
=20
     unlink $dmesg;
     unlink $buildlog;
+    unlink $testlog;
=20
     if (defined($addconfig)) {
 	my $min =3D $minconfig;
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2FAAoJEIy3vGnGbaoAzq0QAJ7mRjpnt305FaNW3oinyDvE
oNY0o3D8xaBJ90dEe4Z/4KcR9gYKZDtLhNikv1oY2Pt0FxnqrfDsSJIK80lHTdas
WmuBoI1fbdcZmEO7VNwBClqHbZdSC9+HJ5LnsUWYEhOrZFVUupFZJ3+DLRjwasDD
4lhTPVgDCsK7ZmjsuCbFgVXcbxeoVL39mfz8JAFmo7E4hSAiy6DZa0fDFCzY3ZLQ
uYl/noSL6AxcprlkC33RUuuQvbrKut0sbYyhb541IyfNKwZKNpIwiVUmKnxarzXB
Sylq0joWLocH8yeIvSEDpF37muY2v2X8T51q7BUo+EdfO8CTfJfeFPbyqiIVVlsA
WowGfhKAHLdRUX/5pVapnUTydRYogVz70xKmENTMBkTi3dDRARbuz6yxCu+dRuPx
9+9wp0LmX1F6aha9pgYxu+povJ9yrJqRMk6I4ddl8lR1QADHSKBlmej9G3xrhVG+
QQ7EFrWz6dgh46u4VAU2czA/+B3D8NZ6zAtI3AsEjzlPBqvZvCX93o4a7MPVvsyn
iSMrxrQmtqj1jqtvTsDxiYI8utd2/SEh3ZGz4apem0jspEXkfwkyAUq70CWBRMf7
USkBzLugWH9aU7nCU3iWPx3AT1+AAH8BgGYGxt72xdU3NyrbcSzdSInHa2RV3TP/
jUola0ej9MKWmweXu3Qt
=bIEb
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
