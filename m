Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2LLWQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:16:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25576 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab2LLWPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:15:46 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=SZGaZbGaXGsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PJNT0BCdeK0A:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=v0JXewxUpQ2rs_XOlaoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=0AN1HMM1l_kitGY1MbwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212221544.350555692@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 12 Dec 2012 17:14:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Adam Lee <adam8157@gmail.com>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 4/5] ktest: Fix breakage from change of oldnoconfig to olddefconfig
References: <20121212221437.245229327@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Fix-breakage-from-change-of-oldnoconfig-to-old.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Commit fb16d891 "kconfig: replace 'oldnoconfig' with 'olddefconfig', and
keep the old name", changed ktest's default config update from
oldnoconfig to olddefconfig without adding oldnoconfig as a backup.
The make oldnoconfig works much better than its backup of:
   yes '' | make oldconfig

But due to this change, and the fact that ktest is used to build lots of
older kernels (and for bisects), it forgoes the oldnoconfig completely.

Cc: Adam Lee <adam8157@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 067337b..6b1e0c5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1966,10 +1966,14 @@ sub make_oldconfig {
=20
     if (!run_command "$make olddefconfig") {
 	# Perhaps olddefconfig doesn't exist in this version of the kernel
-	# try a yes '' | oldconfig
-	doprint "olddefconfig failed, trying yes '' | make oldconfig\n";
-	run_command "yes '' | $make oldconfig" or
-	    dodie "failed make config oldconfig";
+	# try oldnoconfig
+	doprint "olddefconfig failed, trying make oldnoconfig\n";
+	if (!run_command "$make oldnoconfig") {
+	    doprint "oldnoconfig failed, trying yes '' | make oldconfig\n";
+	    # try a yes '' | oldconfig
+	    run_command "yes '' | $make oldconfig" or
+		dodie "failed make config oldconfig";
+	}
     }
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQyQIQAAoJEOdOSU1xswtM2vsIAJMa5Ctjm4CIUDkuKXQFKdxk
iQXfx0/Z6uBVXLHNpLKpnDhU/gvAyy/Yt0d5P4WAC/srjQJ2oef9RzYoXA7IzgSi
jbUB4HQwICPTYUdgYuBK7vujWKDthSaffkOkeJTkyYwnmRn/ExDkznKD5JAxaaTz
pAg+RF8QJ7x1uDLrziLRINokq8BBn2qAOzLK1wSxsE2W75wus0bNG8Gu8PC5kWtG
e8ReBuPWoTV2Tl0QGDpk+jhM7DoJGPKDYgbGGucZMdwFPgRhCNfAAMXt/qKDfPBF
zcjWy1gTxCVIVUi4XvY0Xd7D3AEIDZPfAaI0SMF4XIgoTLLXkoTt+GJk7cyIp98=
=DmC+
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
