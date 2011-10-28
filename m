Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab1J1LVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:21:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab1J1LUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:42 -0400
X-Authority-Analysis: v=1.1 cv=PzmnriOiyqYdyw8suerSEFMr8oy2Ua58JL+Rk7iuDKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=_yIrmJfqTWsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1vQ5UDERc_oSrQRcXZIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=cBfdzjnkhRqhu6b7:21 a=PBoCb51Gb1b2VesB:21 a=LX7tltgAW8UAPuFoK0cA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112039.777710641@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 18/21] ktest: Do not opencode reboot in grub setting
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0018-ktest-Do-not-opencode-reboot-in-grub-setting.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When setting the next kernel to boot to with grub, do not opencode
the reboot operation.  The normal reboot operation can be modified by
config options (namely POWERCYCLE_AFTER_REBOOT). This needs to affect
all reboots. Remove the opencoded reboot to make sure that any changes
to the reboot code also affect all reboots.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 1bda07f..d60c496 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1150,7 +1150,8 @@ sub wait_for_input
=20
 sub reboot_to {
     if ($reboot_type eq "grub") {
-	run_ssh "'(echo \"savedefault --default=3D$grub_number --once\" | grub --=
batch && reboot)'";
+	run_ssh "'(echo \"savedefault --default=3D$grub_number --once\" | grub --=
batch)'";
+	reboot;
 	return;
     }
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqpAHAAoJEIy3vGnGbaoAYKcP/05C7tPVSBjVsZPhmI7WHzBv
Mer0VptJhPys8Xxuw3eN9/FASq/d34La3pwWBhyxY2kusrNZADnrctxczv8jwJIP
wsUfKfRMdE06rGc9icWgtJURfSAMmKYhTq2J2x3bReIebzmxiq4UwGubCa2dhRya
Pcl65vMc2nD/2UBaBrOxCCcoUJSXUUPi4pWLB+iKT3yprg6lh7I6r17siR9X9da+
y8fpzj7Nqg3MDM+0DKWdnVnPKBpi7lgYpCYdOsulYCBQ4HNl3DF8ihPEI1FC03gc
Uwhqot2nsEgXre9mi8iv8OSUa71NZfFC1z0KLyKW3WZX8gvmVZ8ASqUwrz+nDh9A
CDsHDdlAA9tNAQbgM0RaTRkO4Gki1e7OX9E9o1TZz68RHomUiGQdjGvUWcMfhENk
N0wd0ex0xkbRWXYNgEXCWKoYePo621pvAN94S5cYA9pSS4Iy+78hlq1OVjDwLU2x
aCAx0Qaq7RxnxBkLnCXZqU9Q4eCWF6nUgkzxwOaPCwbB+DNHKPXFUpie0oa6mAQj
iV7Wyt0zDL31BrGuTpPBpKoGe6ajzQOwiSZDNgM9bLxnTTFB0sUdAQ1Nlo8R8Jlb
ck0raaYsVBG8cJeYQSo80l8CxhHHpXaE2V4Uy4Ah7aH1XolVU5vcF033Dis7I/n0
CdmZUyE3wQiHZ2kwZvz8
=91p9
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
