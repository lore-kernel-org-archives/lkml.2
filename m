Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1JQRDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:03:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63567 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1JQQ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:50 -0400
X-Authority-Analysis: v=1.1 cv=cRnbtTsVO6wWDdOYuq0VmyuiiLG/FStMSb4CWlTvuS0= c=1 sm=0 a=vhdKIqpQuCYA:10 a=KFlfcQ-h8I0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=tBK0P5f4ygHASKwTdwwA:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=8plKKhdptUjbFQeVPcsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165948.232318339@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:04:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 03/17][RFC] ktest: Only need to save .config when doing mrproper
References: <20111017160455.498567257@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Only-need-to-save-.config-when-doing-mrproper.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Andrew Jones <drjones@redhat.com>

Only save the .config file if we're doing mrproper

Signed-off-by: Andrew Jones <drjones@redhat.com>
Link: http://lkml.kernel.org/r/1313155932-20092-3-git-send-email-drjones@re=
dhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 253e9a2..20b0e73 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1272,15 +1272,15 @@ sub build {
 	# allow for empty configs
 	run_command "touch $output_config";
=20
-	run_command "mv $output_config $outputdir/config_temp" or
-	    dodie "moving .config";
+	if (!$noclean) {
+	    run_command "mv $output_config $outputdir/config_temp" or
+		dodie "moving .config";
=20
-	if (!$noclean && !run_command "$make mrproper") {
-	    dodie "make mrproper";
-	}
+	    run_command "$make mrproper" or dodie "make mrproper";
=20
-	run_command "mv $outputdir/config_temp $output_config" or
-	    dodie "moving config_temp";
+	    run_command "mv $outputdir/config_temp $output_config" or
+		dodie "moving config_temp";
+	}
=20
     } elsif (!$noclean) {
 	unlink "$output_config";
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnF8EAAoJEIy3vGnGbaoAn+kQAORu8zMuRQW8f2l6+d7ItUVj
RWHT8wy/wNPxDwOXWuKmtXuzihnNQU1XG0w4Dq2cbswWmozq4lVWVzMOjEoiqpzG
fIv4HEy2HwTWJ4xZHgmUO26HJXtr7B1DI9HxtBsd1U86m8CHpiDGV8jk4osTIiiZ
4RVs5aAb6c4UOy+2qT60pVq7xY8Ai6gqhhIaGyBvwChcCKrEt+VxT+xzpJdwI8Lv
XVpbDZLt0grTW8P6Q9nL5lgCztudqWgfc1KbV6k0mDFUbFc3uXHKSh8LeTtwhijz
15LD7c8z+UFK9u75jjujE32ZnezVc9c4PUOvhcUbecqpB+T/IgoAOVXMVQfE5SDf
YzRmcCQXcLYxkn3NQVHcjD1PpRHY/zn4AVMYYzrooZ5y0jqfZwAQp6y1zZjnAZOs
MoB/ecqOEd27am/zhFbElD02dIYl/HbclzHc1l8L8uRHDo4rLg2T17YtzSgBEMpO
6nG6xcGDMbtBcQ3IACOZFatWGBpH2lfyOuHgif2oWfKmR+JrsjUSYBcbb4694JmE
y0mdkk1qyOdKr8Sy826US2SjpqBfskiJeALbaXmTlK0nYT0UwO5NGpAqal+bRvmp
dnXbLLBDGIapcwhuW/kEHmulg5vu0yfUH2A79IlS5Dxqkyck3YPQtn9KF2FbtVsL
cbJerUE0YQZSOl2nebJJ
=LDq1
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
