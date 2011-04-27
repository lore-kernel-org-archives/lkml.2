Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1D0NUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:20:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54113 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab1D0NUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:20:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MV2RSoL7BRO5/oNt20YdDC016Zd1MrgKvcXhO/SAYGqo2eemorus+YOsIBJ2y2n0Ia
         0sr/KzOcva09KkQi/v7+oCGbcYrURNOIjz9WqHjO0clOkttjsuz5U+rnaCYmheAGPBP7
         /K56qTnoSwRaNrFXX0BniRud2UroFurk+9GTE=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH v3 7/7] m68knommu: use generic find_next_bit_le()
Date: Wed, 27 Apr 2011 22:20:11 +0900
Message-Id: <1303910411-15793-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303910411-15793-1-git-send-email-akinobu.mita@gmail.com>
References: <1303910411-15793-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of find_next_bit_le() on m68knommu is
identical with the generic implementation of find_next_bit_le().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/bitops_no.h |   46 +-----------------------------------
 1 files changed, 2 insertions(+), 44 deletions(-)

diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
index cd229fb..c4250ae 100644
--- a/arch/m68k/include/asm/bitops_no.h
+++ b/arch/m68k/include/asm/bitops_no.h
@@ -337,50 +337,8 @@ found_middle:
 }
 #define find_next_zero_bit_le find_next_zero_bit_le
 
-static inline unsigned long find_next_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
-{
-	const unsigned long *p = addr;
-	unsigned long result = offset & ~(BITS_PER_LONG - 1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	p += offset / BITS_PER_LONG;
-	size -= result;
-	offset &= (BITS_PER_LONG - 1UL);
-	if (offset) {
-		tmp = __swab32(*(p++));
-		tmp &= (~0UL << offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-
-	while (size & ~(BITS_PER_LONG - 1)) {
-		tmp = *(p++);
-		if (tmp)
-			goto found_middle_swap;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = __swab32(*p);
-found_first:
-	tmp &= (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size; /* Nope. */
-found_middle:
-	return result + __ffs(tmp);
-
-found_middle_swap:
-	return result + __ffs(__swab32(tmp));
-}
-#define find_next_bit_le find_next_bit_le
+extern unsigned long find_next_bit_le(const void *addr,
+		unsigned long size, unsigned long offset);
 
 #endif /* __KERNEL__ */
 
-- 
1.7.4.4

