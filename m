Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0DDOpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:45:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:56609 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab0DDOoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:44:38 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH -mm 4/5] arm: use asm-generic/scatterlist.h
Date: Sun,  4 Apr 2010 23:25:52 +0900
Message-Id: <1270391153-17519-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270391153-17519-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 04 Apr 2010 23:44:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/asm/scatterlist.h |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/arm/include/asm/scatterlist.h b/arch/arm/include/asm/scatterlist.h
index ca0a37d..bcda59f 100644
--- a/arch/arm/include/asm/scatterlist.h
+++ b/arch/arm/include/asm/scatterlist.h
@@ -4,24 +4,8 @@
 #include <asm/memory.h>
 #include <asm/types.h>
 
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;		/* buffer offset		 */
-	dma_addr_t	dma_address;	/* dma address			 */
-	unsigned int	length;		/* length			 */
-};
+#include <asm-generic/scatterlist.h>
 
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)      ((sg)->dma_address)
-#define sg_dma_len(sg)          ((sg)->length)
+#undef ARCH_HAS_SG_CHAIN
 
 #endif /* _ASMARM_SCATTERLIST_H */
-- 
1.7.0

