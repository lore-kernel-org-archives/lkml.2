Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab0DEXz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:55:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:47048 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab0DEXzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:55:07 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH -mm 12/12] parisc: use asm-generic/scatterlist.h
Date: Tue,  6 Apr 2010 08:52:47 +0900
Message-Id: <1270511567-18567-13-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parisc uses iova and iova_length in scatterlist structure instead of
dma_address and dma_length. However, the accessor are used so we can
convert parisc to use asm-generic/scatterlist.h easily.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
---
 arch/parisc/Kconfig                   |    3 +++
 arch/parisc/include/asm/scatterlist.h |   20 ++------------------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index f467a9d..907417d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -94,6 +94,9 @@ config STACKTRACE_SUPPORT
 config NEED_DMA_MAP_STATE
 	def_bool y
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config ISA_DMA_API
 	bool
 
diff --git a/arch/parisc/include/asm/scatterlist.h b/arch/parisc/include/asm/scatterlist.h
index 62269b3..2c3b79b 100644
--- a/arch/parisc/include/asm/scatterlist.h
+++ b/arch/parisc/include/asm/scatterlist.h
@@ -3,25 +3,9 @@
 
 #include <asm/page.h>
 #include <asm/types.h>
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
-	/* an IOVA can be 64-bits on some PA-Risc platforms. */
-	dma_addr_t iova;	/* I/O Virtual Address */
-	__u32      iova_length; /* bytes mapped */
-};
-
-#define sg_virt_addr(sg) ((unsigned long)sg_virt(sg))
-#define sg_dma_address(sg) ((sg)->iova)
-#define sg_dma_len(sg)     ((sg)->iova_length)
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD (~0UL)
+#define sg_virt_addr(sg) ((unsigned long)sg_virt(sg))
 
 #endif /* _ASM_PARISC_SCATTERLIST_H */
-- 
1.7.0

