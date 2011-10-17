Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1JQRDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:03:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab1JQQ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:50 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Ws5zU07_arkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=4dAlurdvmO30cC4ZkwwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zyS8MfbCpph-PDHl:21 a=_veP3YZVSgfpaEr3:21 a=-LKZ_cnhif9hIudubUQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165949.155637682@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:05:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 05/17][RFC] ktest: Fail when grub menu not found
References: <20111017160455.498567257@goodmis.org>
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

iQIcBAABAgAGBQJOnF8FAAoJEIy3vGnGbaoAuUcP/iNg2RufzbFLfMtgUWnjE8T3
yFC8M0rqhg/hVuMWjR2tBOovwCh8yQLGcPHAfz5NcmZBdzpEYjjcFbRY0x2Rbdks
spEQLQBOZjUQRjeFOU3jveHeaZu8hX7EI6yEk4oCszbcRa/OoU3B/G0B+Uph8GbH
qi6h2uMRavrQmn9MuPSgqFJPuLTm4YHp+3jkscAzGVpPdWFBQSiT9vUioeDwujUI
wvK+D+YxPX4yJUZD9PjSy6sIlCY5KAtBMZnouBamW9kYjl3NacmWrzDG/VE9BRMo
ydcGuWk07c8N65FfTBXr6cbwV+9qE0OR5a1VKcVEG7APv8DObdW2bLBsdNS4U8Ob
n1p8Yodvj1jqcNa47jOt7xyUO63+SzZHEeIrsJVVPYYrKgRl6yPzTdzbU4BRbMea
UlTRnxKLEkeVqgxdos/LENy0yxKRCTqXksSQfDCdw5Pi829tBI9OkrJNG9Z0yJVy
iEHc5FXn9z1hHhTkIEovCUs3VYhXK7VYtP+yPej6bnCmYRY8K4v2qdgfqrDD8tIX
z0reJFqheL+GF8EDFYBeC9eiZqzlz/NVeYiZwTQqAxmKVKlA197HlagwXPdIf0E6
KVTg1COBUrU9IM07rwZsEHzLcjOWh3ZW49akcqylCAtceGvS5mVdv20d6NHjuQbq
OvJZwbQV3UVhMK9O/Fkm
=ZcEP
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
