Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab0IXBDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 21:03:38 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:8606 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0IXBDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 21:03:37 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Wu Zhangjin <wuzhangjin@gmail.com>, David VomLehn <dvomlehn@cisco.com>
Subject: [PATCH] MIPS: Remove plat_map_dma_mem_page().
Date: Thu, 23 Sep 2010 18:03:21 -0700
Message-Id: <1285290201-4226-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-6-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-6-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 24 Sep 2010 01:03:36.0958 (UTC) FILETIME=[516511E0:01CB5B84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is now unused.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: David VomLehn <dvomlehn@cisco.com>
---

This is a small addition to the rest of the patch set.  It could be
rolled into [PATCH 5/9] MIPS: Convert DMA to use dma-mapping-common.h

 arch/mips/include/asm/mach-generic/dma-coherence.h |    6 ------
 arch/mips/include/asm/mach-ip27/dma-coherence.h    |    7 -------
 arch/mips/include/asm/mach-ip32/dma-coherence.h    |   12 ------------
 arch/mips/include/asm/mach-jazz/dma-coherence.h    |    5 -----
 .../mips/include/asm/mach-loongson/dma-coherence.h |    6 ------
 arch/mips/include/asm/mach-powertv/dma-coherence.h |    6 ------
 6 files changed, 0 insertions(+), 42 deletions(-)

diff --git a/arch/mips/include/asm/mach-generic/dma-coherence.h b/arch/mips/include/asm/mach-generic/dma-coherence.h
index 8da9807..8259966 100644
--- a/arch/mips/include/asm/mach-generic/dma-coherence.h
+++ b/arch/mips/include/asm/mach-generic/dma-coherence.h
@@ -17,12 +17,6 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	return virt_to_phys(addr);
 }
 
-static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
-	struct page *page)
-{
-	return page_to_phys(page);
-}
-
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-ip27/dma-coherence.h b/arch/mips/include/asm/mach-ip27/dma-coherence.h
index d3d0401..e35bfbc 100644
--- a/arch/mips/include/asm/mach-ip27/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip27/dma-coherence.h
@@ -26,13 +26,6 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	return pa;
 }
 
-static dma_addr_t plat_map_dma_mem_page(struct device *dev, struct page *page)
-{
-	dma_addr_t pa = dev_to_baddr(dev, page_to_phys(page));
-
-	return pa;
-}
-
 static unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-ip32/dma-coherence.h b/arch/mips/include/asm/mach-ip32/dma-coherence.h
index 3785595..7dd1907 100644
--- a/arch/mips/include/asm/mach-ip32/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip32/dma-coherence.h
@@ -37,18 +37,6 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	return pa;
 }
 
-static dma_addr_t plat_map_dma_mem_page(struct device *dev, struct page *page)
-{
-	dma_addr_t pa;
-
-	pa = page_to_phys(page) & RAM_OFFSET_MASK;
-
-	if (dev == NULL)
-		pa += CRIME_HI_MEM_BASE;
-
-	return pa;
-}
-
 /* This is almost certainly wrong but it's what dma-ip32.c used to use  */
 static unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
diff --git a/arch/mips/include/asm/mach-jazz/dma-coherence.h b/arch/mips/include/asm/mach-jazz/dma-coherence.h
index f93aee5..e0d340b 100644
--- a/arch/mips/include/asm/mach-jazz/dma-coherence.h
+++ b/arch/mips/include/asm/mach-jazz/dma-coherence.h
@@ -17,11 +17,6 @@ static dma_addr_t plat_map_dma_mem(struct device *dev, void *addr, size_t size)
 	return vdma_alloc(virt_to_phys(addr), size);
 }
 
-static dma_addr_t plat_map_dma_mem_page(struct device *dev, struct page *page)
-{
-	return vdma_alloc(page_to_phys(page), PAGE_SIZE);
-}
-
 static unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-loongson/dma-coherence.h b/arch/mips/include/asm/mach-loongson/dma-coherence.h
index 981c75f..8daeaee 100644
--- a/arch/mips/include/asm/mach-loongson/dma-coherence.h
+++ b/arch/mips/include/asm/mach-loongson/dma-coherence.h
@@ -19,12 +19,6 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	return virt_to_phys(addr) | 0x80000000;
 }
 
-static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
-					       struct page *page)
-{
-	return page_to_phys(page) | 0x80000000;
-}
-
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-powertv/dma-coherence.h b/arch/mips/include/asm/mach-powertv/dma-coherence.h
index f76029c..647de8c 100644
--- a/arch/mips/include/asm/mach-powertv/dma-coherence.h
+++ b/arch/mips/include/asm/mach-powertv/dma-coherence.h
@@ -70,12 +70,6 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 		return phys_to_dma(virt_to_phys(addr));
 }
 
-static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
-	struct page *page)
-{
-	return phys_to_dma(page_to_phys(page));
-}
-
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
-- 
1.7.2.2

