Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935398Ab0HFFZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:25:05 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49947 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933728Ab0HFFPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:33 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 06/43] memblock/arm: Use memblock_region_is_memory() for omap fb
Date: Fri,  6 Aug 2010 15:14:47 +1000
Message-Id: <1281071724-28740-7-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the deprecated memblock_find()

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/arm/plat-omap/fb.c    |    6 +-----
 drivers/video/omap2/vram.c |    8 ++------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm/plat-omap/fb.c b/arch/arm/plat-omap/fb.c
index 05bf228..441af2b 100644
--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -173,11 +173,7 @@ static int check_fbmem_region(int region_idx, struct omapfb_mem_region *rg,
 
 static int valid_sdram(unsigned long addr, unsigned long size)
 {
-	struct memblock_region res;
-
-	res.base = addr;
-	res.size = size;
-	return !memblock_find(&res) && res.base == addr && res.size == size;
+	return memblock_region_is_memory(addr, size);
 }
 
 static int reserve_sdram(unsigned long addr, unsigned long size)
diff --git a/drivers/video/omap2/vram.c b/drivers/video/omap2/vram.c
index 0f2532b..34514a8 100644
--- a/drivers/video/omap2/vram.c
+++ b/drivers/video/omap2/vram.c
@@ -554,12 +554,8 @@ void __init omap_vram_reserve_sdram_memblock(void)
 	size = PAGE_ALIGN(size);
 
 	if (paddr) {
-		struct memblock_region res;
-
-		res.base = paddr;
-		res.size = size;
-		if ((paddr & ~PAGE_MASK) || memblock_find(&res) ||
-		    res.base != paddr || res.size != size) {
+		if ((paddr & ~PAGE_MASK) ||
+		    !memblock_region_is_memory(paddr, size)) {
 			pr_err("Illegal SDRAM region for VRAM\n");
 			return;
 		}
-- 
1.7.0.4

