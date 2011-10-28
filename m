Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab1J1LVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:21:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65409 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab1J1LUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:51 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=BYujQHxTHdQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Z0ukSC0mcjItqR7u4fsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=QKh9aaWWkKfLffkDa2MA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112048.183798290@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 21/21] ktest: Evaluate variables entered on the command line
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0021-ktest-Evaluate-variables-entered-on-the-command-line.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When ktest.pl is called without any arguments, or if the config
file does not exist, ktest.pl will ask the user for some information.
Some of these questions are code paths. Allowing the user to type
${PWD} for the current directory greatly simplifies these entries.

Add variable processing to the entered values.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 9d9ee32..30e2bef 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -250,6 +250,7 @@ sub read_yn {
=20
 sub get_ktest_config {
     my ($config) =3D @_;
+    my $ans;
=20
     return if (defined($opt{$config}));
=20
@@ -263,16 +264,17 @@ sub get_ktest_config {
 	if (defined($default{$config})) {
 	    print "\[$default{$config}\] ";
 	}
-	$entered_configs{$config} =3D <STDIN>;
-	$entered_configs{$config} =3D~ s/^\s*(.*\S)\s*$/$1/;
-	if ($entered_configs{$config} =3D~ /^\s*$/) {
+	$ans =3D <STDIN>;
+	$ans =3D~ s/^\s*(.*\S)\s*$/$1/;
+	if ($ans =3D~ /^\s*$/) {
 	    if ($default{$config}) {
-		$entered_configs{$config} =3D $default{$config};
+		$ans =3D $default{$config};
 	    } else {
 		print "Your answer can not be blank\n";
 		next;
 	    }
 	}
+	$entered_configs{$config} =3D process_variables($ans);
 	last;
     }
 }
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqpAQAAoJEIy3vGnGbaoAQFYP/jGWh3KzprJOVMYCqFDMnwIW
WQyOwnsvaMvdUv+KioT7GZuX6BdkS0o/120UE9E3tHnENQgxGk/U/P+sfPoDc/Ik
xMB5+qHXXmRtRf9yUnqjSNVFO7SLvzMeoNKTzEKRwjRg6wGDGRcNhrxjlz/2FlwQ
kfwedQ1EfrdvWeMg6jkX4N5tKCW98po8xkACAFPYKNdn4PIC82bH+815IzrDZM/q
scRNvHfl2i1WMZ2szI5StTs0zWYyqk3cLY32UhpQNO8U85Kgmw1Wgv2SVINu5jkJ
lx858i0LyyKD6ls5B1+ed7Qv85JOJVC2ZhCTy0Z8j15UMkvJztScsqUCP5R3uxYk
HBLvnNXekAbwZbkpTFdlnG+jaYtIPUAoVskOc40WbrhIb0aNVNJMqEWgTQKLGDv5
ICIXwwaJsr4l+GbofvJf414QyWCThRkHUKzbP6h/FhRLZDaMO0Qy1EVU8ixppPCA
VKdb4q6qHucBZ+etqr1ZKceV8vDvL0jfG/q3hcqtfMhD1nxvidwe11gDUb/IKC1/
oAlJ3368N53f/orA1y0D/oIoqOXXu+FMDvBQARIG8hisIjjFioWatet/jXyZFOqy
WoX+URwo66BZBotrQhSc6F6zV+9yBDqGuKlm/sOZrXeLSDlBw1KMhCgwR94DyHve
rikG4yd7r5tdByGZMi0H
=Q1z5
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
