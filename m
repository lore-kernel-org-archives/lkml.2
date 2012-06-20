Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2FTCuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:50:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30364 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab2FTCuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:50:05 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=htdQP7KTs1wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=5abIMfYh5AcOCafACo8A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=7_HWw0TtqvLtuyp49fEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120620025004.191014401@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Jun 2012 22:06:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: John David Yost <johnyost@ptd.net>
Subject: [PATCH 1/4] localmodconfig: Comments and cleanup for streamline_config.pl
References: <20120620020608.911616775@goodmis.org>
Content-Disposition: inline; filename=0001-localmodconfig-Comments-and-cleanup-for-streamline_c.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Added some more comments and cleaned up part of the the code to use
a named variable instead of one of the special $1 perl variables.

No functional changes.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index bccf07dd..5c1ce87 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -186,6 +186,7 @@ sub read_kconfig {
 	    $state =3D "NEW";
 	    $config =3D $2;
=20
+	    # Add depends for 'if' nesting
 	    for (my $i =3D 0; $i < $iflevel; $i++) {
 		if ($i) {
 		    $depends{$config} .=3D " " . $ifdeps[$i];
@@ -204,10 +205,11 @@ sub read_kconfig {
=20
 	# Get the configs that select this config
 	} elsif ($state ne "NONE" && /^\s*select\s+(\S+)/) {
-	    if (defined($selects{$1})) {
-		$selects{$1} .=3D " " . $config;
+	    my $conf =3D $1;
+	    if (defined($selects{$conf})) {
+		$selects{$conf} .=3D " " . $config;
 	    } else {
-		$selects{$1} =3D $config;
+		$selects{$conf} =3D $config;
 	    }
=20
 	# configs without prompts must be selected
@@ -250,6 +252,7 @@ if ($kconfig) {
     read_kconfig($kconfig);
 }
=20
+# Makefiles can use variables to define their dependencies
 sub convert_vars {
     my ($line, %vars) =3D @_;
=20
@@ -293,6 +296,7 @@ foreach my $makefile (@makefiles) {
=20
 	my $objs;
=20
+	# Convert variables in a line (could define configs)
 	$_ =3D convert_vars($_, %make_vars);
=20
 	# collect objects after obj-$(CONFIG_FOO_BAR)
@@ -373,7 +377,8 @@ while (<LIN>) {
 close (LIN);
=20
 # add to the configs hash all configs that are needed to enable
-# a loaded module.
+# a loaded module. This is a direct obj-${CONFIG_FOO} +=3D bar.o
+# where we know we need bar.o so we add FOO to the list.
 my %configs;
 foreach my $module (keys(%modules)) {
     if (defined($objects{$module})) {
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP4TpcAAoJEIy3vGnGbaoAHdYP/iMBDdX+/o2oNtIWYZ3PijTK
mUnVBAR8VO7kAFalV2wO0L5t7ynRl2eCk57apthKEuHDXmo5zUzGCMqwf2XszGhE
A+UKCm2GOlcfpcATCp2icnmEQ1O3hpvRjmZeXl1rbCPJ1CjzfMJ3hfIqK5i6jflz
DWSdAlkHLsBUWUGZGrNvdIrNlUl+/O6mbDcHZcur784aciIhJOmojGTTaG0WFUGU
djfV7OukqLE/ttH/+O92pbtoQ05nAnHUYqMKOd9zJUR9LH4vdTPayQYVOZxAH2YM
GcGDPuWzsmvf7Qt3BuynHHTfLWnMakSTh3vOGyFz0XomCi0V5MsMI7klI7rkrcHg
wnKGlAxn7FpqDOpEfdAnyVGFwZAqq5+cXiElfRzNdQdYLs5XAE/vumlaGWcwS5K2
RuvUg8g2sot8E4tc86azIjHoVF2STSVw2qj9CDr9iPxuKcET/LkbZuKuQyZsxrE/
qRe5sXJSE1DqegxSWolm6EqioLuhWlqsUwIpoBBPO+wlmbHBFLXupWbk/vqKZY+U
wkWuRZgZAQ3VPG/sUMBdbFPpWzSbUsN5B2m6+kJdFTZKHM++RHQjuq2Hor/0RPWQ
0AFNknjZGL0lu55z/v9PmUOea11+4qfr+fJ1UEuVaeVW53jH1SSYn0OkCkJ70OaP
hM1ZVTCI3sIrIAzSNXd9
=Rmxg
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
