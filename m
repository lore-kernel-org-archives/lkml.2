Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289Ab2EIXz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:55:28 -0400
Received: from hm1315-12.locaweb.com.br ([201.76.49.66]:55526 "EHLO
	hm1315-12.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2EIXz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:55:26 -0400
X-Greylist: delayed 1056 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2012 19:55:26 EDT
From: Thiago Rafael Becker <trbecker@trbecker.org>
To: akpm@linux-foundation.org, djwong@us.ibm.com,
        kernel-janitors@vger.kernel.org
Cc: Thiago Rafael Becker <trbecker@trbecker.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] crc32.c: cleanup unused variables warning
Date: Wed,  9 May 2012 20:35:37 -0300
Message-Id: <1336606537-11538-1-git-send-email-trbecker@trbecker.org>
X-Mailer: git-send-email 1.7.10.1
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=Krv6LxqN c=1 sm=1 a=+R6bPGFZ0javQqA2PyUBzw==:17
	a=cNWNz6z3UZsA:10 a=la6TjtyCKkkA:10 a=yrWXaES42gIA:10 a=VwQbUJbxAAAA:8
	a=e_HWqny2AAAA:8 a=_DHIfHyD8sjdcGZx_Y4A:9 a=SgU0occmWSkn1s1lBvUA:7
	a=C4R2vJAwBmoA:10 a=zWQKXumA2evbgYzgbGTjVw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variables t4, t5, t6 and t7 are only used when CRC_LE_BITS != 32. This cleans
the following compilation warnings:

lib/crc32.c: In function 'crc32_body':
lib/crc32.c:77:55: warning: unused variable 't7'
lib/crc32.c:77:41: warning: unused variable 't6'
lib/crc32.c:77:27: warning: unused variable 't5'
lib/crc32.c:77:13: warning: unused variable 't4'

CC: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Rafael Becker <trbecker@trbecker.org>

---
 lib/crc32.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/crc32.c b/lib/crc32.c
index b0d278f..61774b8 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -74,7 +74,9 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 	size_t i;
 # endif
 	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];
+# if CRC_LE_BITS != 32
 	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
+# endif
 	u32 q;
 
 	/* Align it */
-- 
1.7.10.1

