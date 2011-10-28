Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1J1LUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:20:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab1J1LUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:11 -0400
X-Authority-Analysis: v=1.1 cv=rFxaVhpzdNKRsWyFDFmDbYx/QEtlW7L1Gw9MiLxO4aw= c=1 sm=0 a=vhdKIqpQuCYA:10 a=tx18HxMg0xYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=tBK0P5f4ygHASKwTdwwA:9 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=FRQeGYiN8P_uL2zQ26kA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112007.145665068@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH 03/21] ktest: Only need to save .config when doing mrproper
References: <20111028111558.173726794@goodmis.org>
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

iQIcBAABAgAGBQJOqo/nAAoJEIy3vGnGbaoATakP/iX9RtOpio21WU6Jy1Yf0dhN
1dOlzPgTzxElIzpiHhDMi6LCswFZnJQ9G5Ptvi+PFkOIOx/0WMFn/NW8zxbQ9nkj
vURSJXRkZcMdpU4ixv2AoJ3rToa1b6nRyb9gz9C9ZsKobPpP2bqX64wpLezLKYal
2HsEj8VKQ1+YAl4qEXFu+jppgcuogPwuPAB2rr2jk8j0lV7vJizH/lmLpoh7UO25
saLQNxs3NaULOUnmfRnjGr7mwpvpoQ1pHBx1eQHInlJieryzRKaDCnWgqWCaBYLm
1iMNP5YzOusmS68y53ms0UqCEjkUstAoPIgEwRFI4MGJTmQthCAVMFJIGKV/2ZSK
QYbFKgA3mJ4Jt/DHAMtfnh6eTG19tqJ/yhfIqi/rTuPN/GpYuKjC5YwGK1oMaBOG
S4ihsMyyLkek4REOq919sY2wYVUNvGRgrnEF/3cKJtMxijhJ8ARhXfnMTMi1P397
C1Y1t2wKdpbtvKIcCINHTJlqkxLAyc5yvLK6QHJRVco4DTTh3GZL0s94VF4qQxO/
CNxa2ABS96n3KRwN7P2ADUwjG/D5aar/S4oNi08b7jNMWXbe3ha06ZBDKeRKGSDT
PaWIKh2jEf31ISH1cKOAjSMmEPpYZp5rLViB59WcLgWbMODF6RBmmzNuRKPwn3yV
oHpcEpz70wiDZuU/gTnu
=21LF
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
