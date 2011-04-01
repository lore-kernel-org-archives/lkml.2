Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab1DASFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:05:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37993 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755258Ab1DASF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:05:29 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 8/9] gma500: Set the TWOD base
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:42:47 +0100
Message-ID: <20110401174227.18112.78991.stgit@localhost.localdomain>
In-Reply-To: <20110401173554.18112.67483.stgit@localhost.localdomain>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2D accel still doesn't work but now it doesn't crash either

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |    5 +++--
 drivers/staging/gma500/psb_gtt.c |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 8978ed6..05c31b9 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -494,8 +494,9 @@ static int psb_do_init(struct drm_device *dev)
 							PSB_CR_BIF_CTRL);
 	psb_spank(dev_priv);
 
-	printk(KERN_INFO "TWOD base %08lX\n", (u32) pg->mmu_gatt_start);
-      	PSB_WSGX32(pg->mmu_gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
+	/* mmu_gatt ?? */
+	printk(KERN_INFO "TWOD base %08lX\n", (u32) pg->gatt_start);
+      	PSB_WSGX32(pg->gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
 
 	return 0;
 out_err:
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index c1283e8..093d7df 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -117,9 +117,9 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 		pg->gatt_start, pg->gatt_pages/256);
 	printk(KERN_INFO"GTTADR(region 3) start: 0x%08x (can map %dM RAM), and actual RAM base 0x%08x.\n",
 		pg->gtt_start, gtt_pages * 4, pg->gtt_phys_start);
-	printk(KERN_INFO "Stole memory information\n");
-	printk(KERN_INFO "      base in RAM: 0x%x\n", pg->stolen_base);
-	printk(KERN_INFO "      size: %luK, calculated by (GTT RAM base) - (Stolen base), seems wrong\n",
+	printk(KERN_INFO "Stolen memory information\n");
+	printk(KERN_INFO "       base in RAM: 0x%x\n", pg->stolen_base);
+	printk(KERN_INFO "       size: %luK, calculated by (GTT RAM base) - (Stolen base), seems wrong\n",
 		vram_stolen_size/1024);
 	dvmt_mode = (pg->gmch_ctrl >> 4) & 0x7;
 	printk(KERN_INFO "      the correct size should be: %dM(dvmt mode=%d)\n",

