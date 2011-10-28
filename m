Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab1J1LUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:20:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab1J1LUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:44 -0400
X-Authority-Analysis: v=1.1 cv=rFxaVhpzdNKRsWyFDFmDbYx/QEtlW7L1Gw9MiLxO4aw= c=1 sm=0 a=vhdKIqpQuCYA:10 a=O1FFLdgQwGQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=OrbI_frlK3wbCyOQL1YA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=4j68a7HfGXGSqey9GFYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112041.822580621@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 19/21] ktest: Add another monitor flush before installing kernel
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0019-ktest-Add-another-monitor-flush-before-installing-ke.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

On some tests that do multiple boots (patchcheck, bisect, etc), the build
of the next kernel to run may finish before the stable kernel has finished
booting. Then the install of the new kernel will fail when it tries to conn=
ect
as the machine has not finished the boot process.

Do one more monitor flush to make sure the machine is up and running before
trying to connect to it again.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index d60c496..652446d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1391,6 +1391,11 @@ sub get_version {
 }
=20
 sub start_monitor_and_boot {
+    # Make sure the stable kernel has finished booting
+    start_monitor;
+    wait_for_monitor 5;
+    end_monitor;
+
     get_grub_index;
     get_version;
     install;
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqpAKAAoJEIy3vGnGbaoAu1IP/0qNINvqiTTwLPGB+t/Ih5VK
778dlJFfgLVqmSB8ULMZUrayg9E+AkicUwHg9VmEJ/LlEeD0pVwWgjldNG6A4OKs
ivWb4iKp4ES2cH4JUBvXMnb+MfxvknoF1mZLMG9VVyX7U+PDQB8cNN7NBmF1ObcL
G9jqWeLkK+VbdkVZyhfCwe33zJY5i0bKVWhNhO621vHxgacB4b2Oh9cRJ6tYCMOI
69lFQYIkNnqExj1wNv8VhJonlFMQ+7KfJ9h6erPuOQC5iZJgN5wVyngoJaoHX+dQ
mDdOILuA6cpyPplSjjsHzc2zXJB7AAVORi84zQJnxJ+jAdW2CeokXhqKcwbaWJnh
dLBO6yFVhRao3i2AySXNpS6Z3cELZW/Cd/57Xdsp10gcDtBe2/XD+JOMDpTjjxzL
9zqzVji47qqfuacZbWFKpCSmwR4JbadTU5y28nCvLDBSyBk9u+es44fuYB7BIB4A
cz5943/N4+Hjc/OBG6zeF0GlsfoPbOMRNZbL357RHYr9RPXK/DZoY/7wj3kqiCJA
+PP4WZmkD8eamR/Lnh1Kfnusjlw7yY6BO1AZV51P2ez+DfaUEdRPLGl4Byem9i4c
CYTzjBRt0O4qHCJlK215lnmldJnV6O+l+AwhhODFYGyaZKM3Mk0BnmEZ+oPabeSf
RsX/4D39Nrmjdw4hVsme
=Q3QP
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
