Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0DDOo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:44:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:56610 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab0DDOoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:44:38 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>
Subject: [PATCH -mm 5/5] alpha: use asm-generic/scatterlist.h
Date: Sun,  4 Apr 2010 23:25:53 +0900
Message-Id: <1270391153-17519-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 04 Apr 2010 23:44:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/Kconfig                   |    3 +++
 arch/alpha/include/asm/scatterlist.h |   21 +++------------------
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index d1a1d83..ffc8253 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -58,6 +58,9 @@ config ZONE_DMA
 config NEED_DMA_MAP_STATE
        def_bool y
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	default y
diff --git a/arch/alpha/include/asm/scatterlist.h b/arch/alpha/include/asm/scatterlist.h
index 440747c..85a0ef2 100644
--- a/arch/alpha/include/asm/scatterlist.h
+++ b/arch/alpha/include/asm/scatterlist.h
@@ -1,25 +1,10 @@
 #ifndef _ALPHA_SCATTERLIST_H
 #define _ALPHA_SCATTERLIST_H
 
-#include <asm/page.h>
-#include <asm/types.h>
-  
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	unsigned long page_link;
-	unsigned int offset;
-
-	unsigned int length;
-
-	dma_addr_t dma_address;
-	__u32 dma_length;
-};
+#define ISA_DMA_THRESHOLD (~0UL)
 
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->dma_length)
+#include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (~0UL)
+#undef ARCH_HAS_SG_CHAIN
 
 #endif /* !(_ALPHA_SCATTERLIST_H) */
-- 
1.7.0

