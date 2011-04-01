Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab1DASD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:03:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37967 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756016Ab1DASDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:03:54 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 2/9] gma500: kill some more #if 0 bits
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:41:12 +0100
Message-ID: <20110401174109.18112.61979.stgit@localhost.localdomain>
In-Reply-To: <20110401173554.18112.67483.stgit@localhost.localdomain>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_mmu.c |   61 --------------------------------------
 1 files changed, 0 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/gma500/psb_mmu.c b/drivers/staging/gma500/psb_mmu.c
index edd0d49..c904d73 100644
--- a/drivers/staging/gma500/psb_mmu.c
+++ b/drivers/staging/gma500/psb_mmu.c
@@ -444,67 +444,6 @@ static inline void psb_mmu_invalidate_pte(struct psb_mmu_pt *pt,
 	pt->v[psb_mmu_pt_index(addr)] = pt->pd->invalid_pte;
 }
 
-#if 0
-static uint32_t psb_mmu_check_pte_locked(struct psb_mmu_pd *pd,
-					 uint32_t mmu_offset)
-{
-	uint32_t *v;
-	uint32_t pfn;
-
-	v = kmap_atomic(pd->p, KM_USER0);
-	if (!v) {
-		printk(KERN_INFO "Could not kmap pde page.\n");
-		return 0;
-	}
-	pfn = v[psb_mmu_pd_index(mmu_offset)];
-	/*      printk(KERN_INFO "pde is 0x%08x\n",pfn); */
-	kunmap_atomic(v, KM_USER0);
-	if (((pfn & 0x0F) != PSB_PTE_VALID)) {
-		printk(KERN_INFO "Strange pde at 0x%08x: 0x%08x.\n",
-		       mmu_offset, pfn);
-	}
-	v = ioremap(pfn & 0xFFFFF000, 4096);
-	if (!v) {
-		printk(KERN_INFO "Could not kmap pte page.\n");
-		return 0;
-	}
-	pfn = v[psb_mmu_pt_index(mmu_offset)];
-	/* printk(KERN_INFO "pte is 0x%08x\n",pfn); */
-	iounmap(v);
-	if (((pfn & 0x0F) != PSB_PTE_VALID)) {
-		printk(KERN_INFO "Strange pte at 0x%08x: 0x%08x.\n",
-		       mmu_offset, pfn);
-	}
-	return pfn >> PAGE_SHIFT;
-}
-
-static void psb_mmu_check_mirrored_gtt(struct psb_mmu_pd *pd,
-				       uint32_t mmu_offset,
-				       uint32_t gtt_pages)
-{
-	uint32_t start;
-	uint32_t next;
-
-	printk(KERN_INFO "Checking mirrored gtt 0x%08x %d\n",
-	       mmu_offset, gtt_pages);
-	down_read(&pd->driver->sem);
-	start = psb_mmu_check_pte_locked(pd, mmu_offset);
-	mmu_offset += PAGE_SIZE;
-	gtt_pages -= 1;
-	while (gtt_pages--) {
-		next = psb_mmu_check_pte_locked(pd, mmu_offset);
-		if (next != start + 1) {
-			printk(KERN_INFO
-			       "Ptes out of order: 0x%08x, 0x%08x.\n",
-			       start, next);
-		}
-		start = next;
-		mmu_offset += PAGE_SIZE;
-	}
-	up_read(&pd->driver->sem);
-}
-
-#endif
 
 void psb_mmu_mirror_gtt(struct psb_mmu_pd *pd,
 			uint32_t mmu_offset, uint32_t gtt_start,

