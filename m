Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2G3T1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:27:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2G3T1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:27:00 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=3Y74iyPq4QwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=usbJgE80zwQabxn4eEMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=hYst2_qJTcDCv4vj9WAA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120730192658.341658022@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 30 Jul 2012 15:23:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 10/10] ktest: Allow perl regex expressions in conditional statements
References: <20120730192314.144253843@goodmis.org>
Content-Disposition: inline; filename=0010-ktest-Allow-perl-regex-expressions-in-conditional-st.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add '=3D~' and '!~' to the list of allowed conditionals for DEFAULT and
TEST_START section if statements.

ie.

 TEST_START IF TEST =3D~ .*test$

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index a022fb7..52b7959 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -623,6 +623,10 @@ sub process_compare {
 	return $lval eq $rval;
     } elsif ($cmp eq "!=3D") {
 	return $lval ne $rval;
+    } elsif ($cmp eq "=3D~") {
+	return $lval =3D~ m/$rval/;
+    } elsif ($cmp eq "!~") {
+	return $lval !~ m/$rval/;
     }
=20
     my $statement =3D "$lval $cmp $rval";
@@ -678,7 +682,7 @@ sub process_expression {
 	}
     }
=20
-    if ($val =3D~ /(.*)(=3D=3D|\!=3D|>=3D|<=3D|>|<)(.*)/) {
+    if ($val =3D~ /(.*)(=3D=3D|\!=3D|>=3D|<=3D|>|<|=3D~|\!~)(.*)/) {
 	my $ret =3D process_compare($1, $2, $3);
 	if ($ret < 0) {
 	    die "$name: $.: Unable to process comparison\n";
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQFuACAAoJEIy3vGnGbaoAi58P/R+QZz7gbRxvnAvqucIGwCRR
+k+f4ltoILivZ/NAVhAY5FnEpi1Jr3Qf+3Fje0sCH9r608njhQDCmZ9PnN3iIfZt
NEeB/x1WOiiadTt4f8KQ+xhmvdbXtSxQ2LilHRrhKjJwHHU/MO7vAxQBki+sNF8W
OoH9TY9DoyinB2jfzEeSHFy/BN76jZ76WF/dGpTg0RCuMbmu9UJhQMeT9L39A9H1
VH3FzadNQ/Pd2Ad5w4x790y8sYHE4UuIclRjXDbf6sdj8n1qt6oQNHddL0kEPP9e
zp6WGpkSzBItA+yourS4dlErCXreHVFX1FTUczNqirWIbpsE/Eq88tgd3+sVh0XN
5fxo8igJ9BqhPLOZeNcnQ8LybVjQrjMheQRB1jSLyNR/+qoBkJrJ7R4aXu4wgptU
EtFJlGFQYCZp3oTao+K03zILhsqlywY+ERZCmLgwrCv3F1mfQdY5EFmxO48s5wOF
Vy/H9AZDtECG6elc77cYnc9D4saO+ZqcdBROas6ryatKqKYVRW0FSmYZ8e3QiIUN
/QVh/f5MQdvNWxxHs9WII66lVDPGa/zkX6JHHPE+nsh1UwL7OsNHT+NLSQa0QT9d
DBYsAKcLDsXzMw0oVjTUX/pu0n9jycmFblK+JGvqLluk8Zb4wi6D2s95BTCdbw+q
Ldltt72PiccoHM/4YJaY
=cBFd
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
