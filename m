Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2JANiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:38:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2JANiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:38:04 -0400
X-Authority-Analysis: v=2.0 cv=WKj9rwQR c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LOY5so0FgDIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=qVE7D8RSIxcA:10 a=d02Qd9UPtPDmJoHnSaEA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=r0gCxOt0-Oj3OErTTwMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121001133801.534934513@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 01 Oct 2012 09:30:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 2/4] localmodconfig: Rework find_config in streamline_config.pl
References: <20121001133055.594443758@goodmis.org>
Content-Disposition: inline; filename=0002-localmodconfig-Rework-find_config-in-streamline_conf.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Bill Pemberton <wfp5p@virginia.edu>

Change find_config function to read_config.  It now finds the config,
reads the config into an array, and returns the array.  This makes it
a little cleaner and changes the open to use perl's 3 option open.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index e3687f9..62d64ce 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -100,7 +100,7 @@ my @searchconfigs =3D (
 	},
 );
=20
-sub find_config {
+sub read_config {
     foreach my $conf (@searchconfigs) {
 	my $file =3D $conf->{"file"};
=20
@@ -115,17 +115,15 @@ sub find_config {
=20
 	print STDERR "using config: '$file'\n";
=20
-	open(CIN, "$exec $file |") || die "Failed to run $exec $file";
-	return;
+	open(my $infile, '-|', "$exec $file") || die "Failed to run $exec $file";
+	my @x =3D <$infile>;
+	close $infile;
+	return @x;
     }
     die "No config file found";
 }
=20
-find_config;
-
-# Read in the entire config file into config_file
-my @config_file =3D <CIN>;
-close CIN;
+my @config_file =3D read_config;
=20
 # Parse options
 my $localmodconfig =3D 0;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQaZy5AAoJEOdOSU1xswtMqHoH+gJaEYdK/8/jBjFPnyFEPCjO
c6vfUiXtDPwFYweIYtgZIAuDA/uKauO0n4iohzqCLDTOKbf4i/eaCe1TfDw2Lp+u
5u039wv/S/DijWgX2szzREwoYLoNecdTTW07Bzy5GrYgWVxKCac4Y4qFmYXGw6YS
MML0+3Jbtyz3liQ2s206oRJKS5G6I/u22aohaecrCVUnXGApo2IT4ik1qUGn76Qx
7IKvTzMMkWm70OMStGDRMdyIaTMQgy1t++8K9dlzUu+SEDAhnt45uQGboZKhXhAa
md4HlurL6rvFarROivlRmMTkgAy3n/zO6R9OzUxdz/kug9rmZw2Rw2weAtqQdJY=
=IyDR
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
