Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0DDOpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:45:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:56613 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702Ab0DDOot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:44:49 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH -mm 3/5] powerpc: use asm-generic/scatterlist.h
Date: Sun,  4 Apr 2010 23:25:51 +0900
Message-Id: <1270391153-17519-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 04 Apr 2010 23:44:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/Kconfig                   |    3 +++
 arch/powerpc/include/asm/scatterlist.h |   29 +----------------------------
 2 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 669a1b1..0133cf9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -659,6 +659,9 @@ config ZONE_DMA
 config NEED_DMA_MAP_STATE
 	def_bool (PPC64 || NOT_COHERENT_CACHE)
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	depends on PPC64 || POWER4 || 6xx && !CPM2
diff --git a/arch/powerpc/include/asm/scatterlist.h b/arch/powerpc/include/asm/scatterlist.h
index 912bf59..4ae35da 100644
--- a/arch/powerpc/include/asm/scatterlist.h
+++ b/arch/powerpc/include/asm/scatterlist.h
@@ -9,38 +9,11 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifdef __KERNEL__
-#include <linux/types.h>
 #include <asm/dma.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	unsigned long page_link;
-	unsigned int offset;
-	unsigned int length;
-
-	/* For TCE or SWIOTLB support */
-	dma_addr_t dma_address;
-	u32 dma_length;
-};
-
-/*
- * These macros should be used after a dma_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->dma_length)
+#include <asm-generic/scatterlist.h>
 
 #ifdef __powerpc64__
 #define ISA_DMA_THRESHOLD	(~0UL)
 #endif
 
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_SCATTERLIST_H */
-- 
1.7.0

