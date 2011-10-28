Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1J1LZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:25:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1J1LUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:14 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=2GDa8DH84V8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=4dAlurdvmO30cC4ZkwwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zyS8MfbCpph-PDHl:21 a=_veP3YZVSgfpaEr3:21 a=vTlA_8Iz2gt9H8KnMOEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112011.737924685@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 05/21] ktest: Fail when grub menu not found
References: <20111028111558.173726794@goodmis.org>
Content-Disposition: inline; filename=0005-ktest-Fail-when-grub-menu-not-found.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Currently if the grub menu that is supplied is not found, it will
just boot into the last grub menu in menu.lst. Fail instead of
confusing the user why their kernel is not booting.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index debc689..ca6ff99 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -862,9 +862,12 @@ sub get_grub_index {
     open(IN, "$ssh_grub |")
 	or die "unable to get menu.lst";
=20
+    my $found =3D 0;
+
     while (<IN>) {
 	if (/^\s*title\s+$grub_menu\s*$/) {
 	    $grub_number++;
+	    $found =3D 1;
 	    last;
 	} elsif (/^\s*title\s/) {
 	    $grub_number++;
@@ -873,7 +876,7 @@ sub get_grub_index {
     close(IN);
=20
     die "Could not find '$grub_menu' in /boot/grub/menu on $machine"
-	if ($grub_number < 0);
+	if (!$found);
     doprint "$grub_number\n";
 }
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqo/rAAoJEIy3vGnGbaoAbc8P/3LAmRPyWkHEr9t3Ww1PT6Ux
/5a0YOYbdiTZRQGyG3EzgwQ9LoYebnTuhJU+dJQin5kfFN38MrbjdzP1K9TbC71h
ExJ+iGT5JK/+UUHz+N0X+uk1ynuRAQfjzazDyMVld2ZktNX5omHS+5VYn2LnQX4T
IAsVlf6bKPoUYLunWTrpqq2rgxEVMxr3q2WBYm0jtZ9ViuS1LP4wqAatju0o72tT
p/WukNpTUnzQw6Ee8uxBb8fREagVue+ja/Gyss72ehpRlPCZx9J25A7TQgwutZ8a
Q35rgtvmNwNE/R5I6Xq6aFQiCB4AIv9H4/12YTxGkD8Zh7rvCQ3XMtSol/pL4ffW
oIrjzfTin3ezkdptOSVwRUBDAiIukkm5gwAb1k2icbsHSK3Rq5MtHk3BrP+Rb2yM
6LRtGnLovWKTysqoU9WM2nARBLGHl/OeetVztCPNqlLvT1Cr0ytYb4lKEVDL4Z0P
7+DdOpp4YlzyOdE43/EJ2WHQZUBdc/EuJU87qWPtlGoS1L+HSglxbdvfHrBP7zF3
lr+5UeTNJG5lQsuszfIJj6J50p5unwaalQGYB/RbPPfxmCAZJMuFOOOwKBln7jFu
ytbiJpGx+K4vfcMuTeYV537Be7xgMhss1AG/iebMcci9ilPpDsG7b9dnPD9MSsdj
TSU9R3AZ0buI1EUpygRy
=TlLY
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
