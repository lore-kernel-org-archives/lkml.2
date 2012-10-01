Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab2JANiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:38:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2JANiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:38:03 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=cG6_r1KTM4IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SrUqOPt9ww8A:10 a=8XrrAr_XN4XPYPjqWS8A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=DYJrQAcRvWyk5ZEUVSwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121001133801.334470924@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 01 Oct 2012 09:30:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 1/4] localmodconfig: Set default value for ksource in
 streamline_config.pl
References: <20121001133055.594443758@goodmis.org>
Content-Disposition: inline; filename=0001-localmodconfig-Set-default-value-for-ksource-in-stre.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Bill Pemberton <wfp5p@virginia.edu>

Running streamline_config.pl as it's shown it in the comment header,
you will get a warning about $ksource being uninitialized.  This is
because $ksource is set to ARGV[0], but the examples don't require any
arguments.  Fix by setting ksource to . if no ARGV[0] is given.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index 2fbbbc1..e3687f9 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -135,7 +135,7 @@ GetOptions("localmodconfig" =3D> \$localmodconfig,
 	   "localyesconfig" =3D> \$localyesconfig);
=20
 # Get the build source and top level Kconfig file (passed in)
-my $ksource =3D $ARGV[0];
+my $ksource =3D ($ARGV[0] ? $ARGV[0] : '.');
 my $kconfig =3D $ARGV[1];
 my $lsmod_file =3D $ENV{'LSMOD'};
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQaZy5AAoJEOdOSU1xswtM29QIAJKEWVKK8ZkbmwRQJ4HOyFMy
JlOMbolwKUqkJh0LxH7lJ5fqzgUe7vl0UNV69fy97id2jTZYDPGV41uFqWvfystF
3XZ5AzkXD4J5fhL7EXSUvaNy5ky7kAq8g6kZXKTqCnIg43qasahH98Vau0sytW7D
vZJ74eCQ0BaGjkMxK2At+lGEZZrd0OozYOABDVVOdw0W4DDi69DXruq1ayEuCdPR
q+6qRkNdzSTtCN79l6Sc79AGfQA6pbmsomUFiLgSKWCH6xcoD9Ci5nu3To9zgcwU
fddUzHKG75h91rI/tUc6Mo5nIu/ZQ2Nzdi1MiJeqniI4omFNV/S+clgc/e3euU8=
=ur89
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
