Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab1KRQgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:36:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38597 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab1KRQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:36:39 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=a3paKzzjGroA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=wlPmwRsKSctrVcVrf2YA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=y29Y46CVE9pD68E95scA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [PATCH][GIT PULL] ktest: Check parent options for iterated tests
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rabin Vincent <rabin@rab.in>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/Q9CpxPJ0O5hkadsjgEm"
Date: Fri, 18 Nov 2011 11:36:36 -0500
Message-ID: <1321634196.3533.55.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/Q9CpxPJ0O5hkadsjgEm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

This patch includes a bug fix for ktest. And also proves that ktest has
at least 3 users!=20

Please pull the latest for-linus tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
for-linus

Head SHA1: f9dfb65b055c56678afa03e13e942761459ea53d


Rabin Vincent (1):
      ktest: Check parent options for iterated tests

----
 tools/testing/ktest/ktest.pl |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
---------------------------
commit f9dfb65b055c56678afa03e13e942761459ea53d
Author: Rabin Vincent <rabin@rab.in>
Date:   Fri Nov 18 17:05:30 2011 +0530

    ktest: Check parent options for iterated tests
   =20
    Let's say we have "OUTPUT_DIR =3D build/${TEST_NAME}", and we're iterat=
ing
    a test.  In the second iteration of a test, the TEST_NAME of the test
    we're repeating is not used.  Instead, ${TEST_NAME} appears literally:
   =20
       touch /home/rabin/kernel/test/build/${TEST_NAME}/.config ... SUCCESS
   =20
    Fix this by making __eval_option() check the parent test options
    for a repeated test.
   =20
    Link: http://lkml.kernel.org/r/1321616131-21352-2-git-send-email-rabin@=
rab.in
   =20
    Signed-off-by: Rabin Vincent <rabin@rab.in>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 30e2bef..8b4c253 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -747,6 +747,18 @@ sub __eval_option {
     # Add space to evaluate the character before $
     $option =3D " $option";
     my $retval =3D "";
+    my $repeated =3D 0;
+    my $parent =3D 0;
+
+    foreach my $test (keys %repeat_tests) {
+	if ($i >=3D $test &&
+	    $i < $test + $repeat_tests{$test}) {
+
+	    $repeated =3D 1;
+	    $parent =3D $test;
+	    last;
+	}
+    }
=20
     while ($option =3D~ /(.*?[^\\])\$\{(.*?)\}(.*)/) {
 	my $start =3D $1;
@@ -760,10 +772,14 @@ sub __eval_option {
 	# otherwise see if the default OPT (without [$i]) exists.
=20
 	my $o =3D "$var\[$i\]";
+	my $parento =3D "$var\[$parent\]";
=20
 	if (defined($opt{$o})) {
 	    $o =3D $opt{$o};
 	    $retval =3D "$retval$o";
+	} elsif ($repeated && defined($opt{$parento})) {
+	    $o =3D $opt{$parento};
+	    $retval =3D "$retval$o";
 	} elsif (defined($opt{$var})) {
 	    $o =3D $opt{$var};
 	    $retval =3D "$retval$o";



--=-/Q9CpxPJ0O5hkadsjgEm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOxomIAAoJEIy3vGnGbaoAZvcP/RoaDmlU2AqoIWomtULNesHg
9K6m9AdKFc2dTU3z5q3d5YmBxZ2qjEjijL5lvfOY9Icke3R22D6kXVvTyMnNal1o
h9pQDoywed1cC/832ta34LhHYIdOpdwemLxuQ8BzHNv5G+/xbItCpawwhB5K8JJi
HagDBcTmODNgygM/Hs6uMU4xKw0msY8p6VnXrSFK3OIVxx2KWvBwZqUAZBiJcXQi
UF/w8SFPHWEWr3mkt5qiMAkMPyP42WESvkWgW/PJjcrVQXy+3j24728HT1q6Jbfa
lRGsJ9+XOukf7S+1LfagS+zK0N4N8qsgu8R0qs/IMNYwYuTneUKVt0arb1lZCaMI
6xwCRBfjxUwr2YWnYhBCjzrH2Jm8eg2dr0GnCOP1TjfkdmJ9YFlbpyZeGGqwJVm1
1sPDkmDtvTPexZo6tyYiXORUkp2gcoeYEV+VWxN+8IeW6wZctdeltSAeibFhQDKC
Y2Jsaqss5fYBGF6g6nLxZGwQajgtk4TKrZpiGoHsnER8rYXpmdbHsxG/XRpZrX2J
cndgG0VBxlM8+Vx5vLiAxferVLRoYoVvVoLUxRWFwLopVuKyMBHHSFzvpru3dENc
yzWcVI0VOoJc73MIpMEP4Fz3GGXRB+DWbRKNDnMgC1rvhc0C40c1I0d/e7spD2A2
CevufU3PTwiBZpLrtJ/5
=n4am
-----END PGP SIGNATURE-----

--=-/Q9CpxPJ0O5hkadsjgEm--

