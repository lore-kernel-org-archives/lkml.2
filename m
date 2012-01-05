Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab2AEDwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:52:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab2AEDsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:22 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=F8g2gIQcKOkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=7gtaUGwnQgEKRpuiaOoA:9 a=QEXdDO2ut3YA:10 a=ByEePuvHlDcA:10 a=jeBq3FmKZ4MA:10 a=WFg9pqlBOAKzbftaldcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034820.992955417@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:47:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 01/20] ktest: Check parent options for iterated tests
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Check-parent-options-for-iterated-tests.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Rabin Vincent <rabin@rab.in>

Let's say we have "OUTPUT_DIR =3D build/${TEST_NAME}", and we're iterating
a test.  In the second iteration of a test, the TEST_NAME of the test
we're repeating is not used.  Instead, ${TEST_NAME} appears literally:

   touch /home/rabin/kernel/test/build/${TEST_NAME}/.config ... SUCCESS

Fix this by making __eval_option() check the parent test options
for a repeated test.

Link: http://lkml.kernel.org/r/1321616131-21352-2-git-send-email-rabin@rab.=
in

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

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
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2FAAoJEIy3vGnGbaoAHRYP/ioBCPSi8tmbQIbQd93uhhiQ
7m8FI9rlZedF2ezWZsNT3FfNkjb+hOe6xKqpP6Cp0iWzWydDhL1OywuLMZqxhA3n
sAv5RfC88pTNVURQuuOXW8G119z1rdo7ZZxNkDUKcw/s+kg9yjC6uGYYykDVvJ/Z
GLMpIe28uZylH5/DC7wZhpVS/7CubIhP8ZAv4HP4ILE0sE7RwkV8rmYOLTCe+A4m
Ove6rs323tMeWm/8pK26oaRQMf0Hekj3uUyXpjWAFOgZruF7nwRohcfUJRBKH7KN
Sd+Sq+xwzDZ5zzFPGKclikUHk6RecLV+WjIT6dl4VGRINzG7MYxkDSL9gGVFSwEl
PDce3493B5fJ+fJZEeJMEMaMvVvG80miBsagRseWVdWc9WPbhZucExiqz3Chwq2e
JbuqnFNyQstiyb5bmzRtxV5Y9NXJJHjcubbXAi4+5mHGP0gnw6+0X5PyG0UdxTwZ
/Cp/dNqYEZlBfmYquvRQP4NIvS+TSs2+6PP1bWN6jPFwJb/moYgzyCQIRkZHarNH
PpCIFZuEfDDv+Xi0tfkOkrNmZ0cJC0jgnjB2B/qMnLd36UkGoZVyG8DgFe5LyI12
jtIRFF8K1eP8XuHhndTIoYXLUbenLBQ7bPion7e2bLFNoekLoafs+9qwO68fOMPb
w1jHXjEHWdoecBFrdFsN
=V2FF
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
