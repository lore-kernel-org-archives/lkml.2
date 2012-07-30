Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2G3T1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:27:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27328 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2G3T06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:26:58 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=V8SbSbR2AHgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=Obi-mNDOg3rBxBohc4wA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=SWJIPaPHWe1SGVZi8ycA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120730192657.759757700@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 30 Jul 2012 15:23:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 08/10] ktest: Reset saved min (force) configs for each test
References: <20120730192314.144253843@goodmis.org>
Content-Disposition: inline; filename=0008-ktest-Reset-saved-min-force-configs-for-each-test.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The min configs are saved in a perl hash called force_configs, and this
hash is used to add configs to the .config file. But it was not being
reset between tests and a min config from a previous test would affect
the min config of the next test causing undesirable results.

Reset the force_config hash at the start of each test.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index c8a42d5..c444c4f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -3634,6 +3634,8 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
=20
     $iteration =3D $i;
=20
+    undef %force_config;
+
     my $makecmd =3D set_test_option("MAKE_CMD", $i);
=20
     # Load all the options into their mapped variable names
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQFuABAAoJEIy3vGnGbaoA7/kQAIzbPocojzxyVcmGiK79BEKM
W49ZcGNPaabM8MhHVqYPQOU6SeaYe1CVjp9hJTebT9zFq6nnCp7MbiYjamlsexfU
x7lWx4Aok/CbgnXziBKv/PD7VSYcU5WUAL2Wn5VMOPdC99xi/d5O5QV9vuC9tieW
KQTeMInpPDqU12hrr3Lr6A4aSFLqnSR9p4OsnOyA+IwC3C+xfm+D8S28LY0lqEML
23U6altYpUTZe0zylcnl939fdBFRW6O3uNsmYaptxx6tZjtns5DCx/oXDtNQmv2N
uxEhw/g2g5wj6OIVOF5pGvY5dIUDjeadv34ga0JPzcnfuxj2PDo5IaGZPhdFbuiM
XaqaD1CKz61FckTKs6T35l3zty9WLj6vShFG8TomTdn85ZJZTouMDF4h4Y10TVFg
lq0T99i7QEdqt5/kFlDTQHbW0GaoSzVykwqj0qCBYzz38kqVZDROmIVTqCD5KDGm
kNgMKynUqds0WjofM1sGZiYOASFsJplSINsbSLbJZuzxzds+tOPyZWuXfbdG0Enh
kaZnrryP2+/ETKWBJDul6jM35i8HRAkhbrckTuu8IRsSpcbTx/ZrY+UJH7k+7ztr
JGpOadKujZqm7f1rSB27+efWtaVnpEMFi0+oQaPBxsW2u8DBPduSBy5iumWt9Hi6
Y05/QOtxntCo03LYdj7d
=iJK3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
