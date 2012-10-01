Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2JANiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:38:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2JANiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:38:03 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=tDif-i4-nSgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gUEAqscXWtEA:10 a=h88eUkG4OvXP9ZKX2RgA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=DmHTv01UhvI8HfUPOeAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121001133801.953971128@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 01 Oct 2012 09:30:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 4/4] localmodconfig: Use my variable for loop in streamline_config.pl
References: <20121001133055.594443758@goodmis.org>
Content-Disposition: inline; filename=0004-localmodconfig-Use-my-variable-for-loop-in-streamlin.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Bill Pemberton <wfp5p@virginia.edu>

perlcritic complains about $kconfig being reused in the foreach loop
at the end of read_kconfig.  Change it to a my variable.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index 22b66ca..39b6314 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -252,7 +252,7 @@ sub read_kconfig {
     close($kinfile);
=20
     # read in any configs that were found.
-    foreach $kconfig (@kconfigs) {
+    foreach my $kconfig (@kconfigs) {
 	if (!defined($read_kconfigs{$kconfig})) {
 	    $read_kconfigs{$kconfig} =3D 1;
 	    read_kconfig($kconfig);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQaZy6AAoJEOdOSU1xswtM7AMIAKzD2fvSBqUZ1cYWJFuVSF8K
20p5qRGMpvHW5vKDkxdrLTRJ8WaOgsUyYjfX74nnuYjUYUOFdpnx0mE6o0xCzPtt
PHjSEP1GcWJVK7sgJcFynT5in6oxvZr/aIlhbfEFCIWdbz4Nd/c0VlZ6bkQQFTh4
PUU5ZCPHOkP6DjXl3xtmhOqmfsUs5apppHNCsEaexRQagAi8DBYyMiJibiwFkl/o
dKfXHTadU3eCXfJofa0k4QNlqRY6BoRY1OiEXKGyIafiDcmdLhjo+AZqZb0jE0fZ
qPzSFxracjAkifikSxSwplkG0KqcZsQ7oLIJ7ePM0CCnj2W9e3YvV1MB86rbpz4=
=99T6
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
