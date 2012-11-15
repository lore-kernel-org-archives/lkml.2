Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2KOHGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:06:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49755 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KOHGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:06:17 -0500
Date: Thu, 15 Nov 2012 18:06:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the final tree (powercp
 tree related)
Message-Id: <20121115180607.4a545ad6b6b6c8e3481a11e9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Nov_2012_18_06_07_+1100_bED_ctZyjn/GYaQo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Nov_2012_18_06_07_+1100_bED_ctZyjn/GYaQo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

lib/pSeries-reconfig-notifier-error-inject.c:4:34: fatal error: asm/pSeries=
_reconfig.h: No such file or directory

Caused by commit f459d63e1689 ("powerpc+of: Remove the pSeries_reconfig.h
file") and even if the file existed, things were removed by commit
1cf3d8b3d24c ("powerpc+of: Add of node/property notification chain for
adds and removes") that would cause
lib/pSeries-reconfig-notifier-error-inject.c to fail to build.  I have
marked it as broken for now using this patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 15 Nov 2012 18:02:13 +1100
Subject: [PATCH] lib: disable PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT

It has been fundamentally broken by other changes.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 41faf0b..ad84944 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1195,6 +1195,7 @@ config MEMORY_NOTIFIER_ERROR_INJECT
 config PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT
 	tristate "pSeries reconfig notifier error injection module"
 	depends on PPC_PSERIES && NOTIFIER_ERROR_INJECTION
+	depends on BROKEN
 	help
 	  This option provides the ability to inject artifical errors to
 	  pSeries reconfig notifier chain callbacks.  It is controlled
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Nov_2012_18_06_07_+1100_bED_ctZyjn/GYaQo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQpJRgAAoJEECxmPOUX5FEt7oP/1z937rTqKf+Rd266D5b2vS0
VHMMsIJqsiyZ5gO3/7/eGFvpMbfx9R1HF3xE5YJwisD2UDBFLL3Vb8xG487oSKD9
mXKA1Br5KsBuAkQcfzTTw2XqraHyDmQXNqUa2tRUQacH1N4BWBP96eQVWrN9nnKe
UIX0uwuP8Cja28a4eacIqVDLtz2qlybkJq0D8dIPBoaZR8qABH8PCYUjGNa4pBiv
YoqIy6szHz4F/N1ciYEWmzHbLbt+4n8XT/Gx1PaNIQM6+6aX6nE7xvIOmzRptOtW
bE3fOZ6N3vIWVJjMn3nYLQ2DeiLI1/pi5k1y+k1HWsABUpinqvQQ6+IybExjHmUZ
GlCpJNWRDHcWAG6Z749TOAvc/DYrkSssNxbetB2EFmtPOMg5FzYUF3fNkhpqHkV8
qSLzmhzXhzNKhMcDu1dkbMDubwPQj8+mWJPBRG9WBf0PbzxwvFsi5+2VIXwMLNCf
Bw9x547pG3gHqK7dMvpngXrudQKBa3rjAdnfOubgUBzYmsBSLzbbpnnB0yza01eI
kinTgsSElh4w0xw/vEhklLjosp9qO7j/mvSGDpx9HVfqUrpRI50Wp4NiBg8temUU
poWQjnw7kY2FlOItT77NOawfL1pmpRnuR/SOvu/aR0vfCDtbADEeo3ZrigemQqoa
FSw5p94Q4Sr+QHl6CgKW
=ozRK
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Nov_2012_18_06_07_+1100_bED_ctZyjn/GYaQo--
