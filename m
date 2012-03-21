Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab2CUQCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:02:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2CUQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:02:45 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=6p1wlam6MEgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=a4Up_bV9lMQbB9Z2PaYA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=seppqubovqppIN9ibccA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120321160243.535810293@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 21 Mar 2012 12:01:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/5] ktest: Add warning when bugs are ignored
References: <20120321160125.496052559@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Add-warning-when-bugs-are-ignored.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When IGNORE_ERRORS is set, ktest will not fail a test if a backtrace
is detected. But this can be an issue if the user added it in the
config but forgot to remove it. They may be left wondering why their
test did not fail, or even worse, why their bisect gave the wrong
commit.

Add a warning in the output if IGNORE_WARNINGS is set, and ktest detects
a kernel error.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 2b63190..0a5f6cb 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1460,6 +1460,7 @@ sub get_sha1 {
 sub monitor {
     my $booted =3D 0;
     my $bug =3D 0;
+    my $bug_ignored =3D 0;
     my $skip_call_trace =3D 0;
     my $loops;
=20
@@ -1531,9 +1532,13 @@ sub monitor {
 	}
=20
 	if ($full_line =3D~ /call trace:/i) {
-	    if (!$ignore_errors && !$bug && !$skip_call_trace) {
-		$bug =3D 1;
-		$failure_start =3D time;
+	    if (!$bug && !$skip_call_trace) {
+		if ($ignore_errors) {
+		    $bug_ignored =3D 1;
+		} else {
+		    $bug =3D 1;
+		    $failure_start =3D time;
+		}
 	    }
 	}
=20
@@ -1595,6 +1600,10 @@ sub monitor {
 	fail "failed - never got a boot prompt." and return 0;
     }
=20
+    if ($bug_ignored) {
+	doprint "WARNING: Call Trace detected but ignored due to IGNORE_ERRORS=3D=
1\n";
+    }
+
     return 1;
 }
=20
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPafujAAoJEIy3vGnGbaoANHMQAKFupt6Fxb64m1BtmOnWugat
DIjW0LiHFRr87dXkHTu9WIBjinxyA1thiocfiCloddo+4ESxJwIR3mvk9gk5gl02
ymdC333WR30PMvAoXKY9RBJ+NBMvdghlwzYBbmnAfsRWIBJm6f1KfXHFTYI2xaaw
a9LXGZ1EeZBSGf3zXAl1kPovQKoHcLPASynu5kuplEG2kHEOyaxDrIJVXI3f0HDZ
JpYj3vtTyzF0COhw+e0z//w5HzRmLGK7rjJwLi8dNLFVJOpGWgyqcq2ipadEKDbc
23Vefp8t3L0jgm3z+KfStvQKUCnXYlqWaupYewZAYMmogtP8epAYOPoKc270Z8Hm
J5HbhRneNRof4+u9/EIFfwathO8ZlzzF56VzdXPw2dC6XoZ6LJAC6EcFIjd9r9Xg
EKfae0BDbAUoTJ7mT32j0QPdV7pZUAj8w+HJnM/enUUYNyFo4ORH/X9nvhxd+Qgc
VOerOMUq2uMGSdc8wQI3EV+VpYfq03ebpRbgbVMv833Ynks2WAYISSyCR4WnRKAf
3+kTUxpXGQ/q5Qons7gPJKYR2BAsgwCsv0BjTEZ5xJBSTOO5Xg/KgPBwTuNSHl3g
YY4g4OAKd7Thj80bm1Rv5RYq92Nkei3hXd91ZO2teds5VO4zJXP8TJSRwVVRc+F9
oIzLieQ9GhMoUxjOkiVS
=xQBy
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
