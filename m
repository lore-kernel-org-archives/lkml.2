Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2LLWQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:16:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2LLWPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:15:45 -0500
X-Authority-Analysis: v=2.0 cv=JuRzXbEC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=-CbeLFIuCKwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=8a7TYWOn7pMA:10 a=20KFwNOVAAAA:8 a=6-f2wfQwsbGeSnjWECMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=JUzP_uosFy7w5DL7A-0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212221543.994078910@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 12 Dec 2012 17:14:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/5] ktest: Sync before reboot
References: <20121212221437.245229327@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Sync-before-reboot.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Before rebooting the target, run the sync command, as it seems that
either Grub2 or systemd gets screwed up if you update to reboot a kernel
once and do a reboot without doing a sync.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 63245a5..f4b8f96 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1147,6 +1147,9 @@ sub wait_for_monitor;
 sub reboot {
     my ($time) =3D @_;
=20
+    # Make sure everything has been written to disk
+    run_ssh("sync");
+
     if (defined($time)) {
 	start_monitor;
 	# flush out current monitor
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQyQIQAAoJEOdOSU1xswtMdHkH/RVSL39Q9Z0phLwGwtRUXyIX
e75T2co5u+HH5iPq0yTobpCvVXf3qb0baWjPKsERceNnxlqdH4/B7sLcIfYiK+1w
MFZJY8QWZ1GfNXqj+zT/wTPDLA3uI8tYo1spzy5rqbD5LCxzsne7NGgySF5EltzN
D8ae5cYYM3dH+fH9qpC5Pqo0Buim/TG3nUSHnyfDZpyYHWqjPFhSLWyqT7ttPAA7
VzXIH3RHYGEW7TKrZyH82fluFILUNz53C98fgeSeZwhyV97CHzkHmu8X3ti2RcZp
ruiW4uySb1kdyInIQE+0BC939G5jfKxsx5PFYiE3hdSNeodOfAzRIzG0GA75juk=
=mycR
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
