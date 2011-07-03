Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1GCHZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 03:25:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22053 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1GCHZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 03:25:34 -0400
Date: Sun, 3 Jul 2011 09:16:13 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Thomas Hellstrom <thomas@tungstengraphics.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH] gma500: fix compiler warnings and format string
Message-ID: <alpine.LNX.2.00.1107030914100.16316@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1261404430-1309677374=:16316"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1261404430-1309677374=:16316
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

This patch fixes these compiler warnings:

  CC      drivers/staging/gma500/psb_gtt.o
drivers/staging/gma500/psb_gtt.c: In function ¡psb_gtt_insert¢:
drivers/staging/gma500/psb_gtt.c:81:33: warning: unused variable ¡dev_priv¢ [-Wunused-variable]
drivers/staging/gma500/psb_gtt.c: In function ¡psb_gtt_pin¢:
drivers/staging/gma500/psb_gtt.c:237:2: warning: ¡ret¢ may be used uninitialized in this function [-Wuninitialized]

It also fixes up the format string used in DRM_DEBUG() in
drivers/staging/gma500/psb_gtt.c:psb_gtt_init() - the string required
two arguments but only one was supplied.

While reading through the file I also deleted what trailing whitespace
I encountered.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/gma500/psb_gtt.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 74c5a65..398df80 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -52,7 +52,7 @@ static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
  *	psb_gtt_entry		-	find the GART entries for a gtt_range
  *	@dev: our DRM device
  *	@r: our GTT range
- * 
+ *
  *	Given a gtt_range object return the GART offset of the page table
  *	entries for this gtt_range
  */
@@ -78,7 +78,6 @@ u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
  */
 static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 {
-        struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 *gtt_slot, pte;
 	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
 	struct page **pages;
@@ -104,7 +103,7 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 	}
 	/* Make sure all the entries are set before we return */
 	ioread32(gtt_slot - 1);
-	
+
 	return 0;
 }
 
@@ -215,7 +214,7 @@ static void psb_gtt_detach_pages(struct gtt_range *gt)
  */
 int psb_gtt_pin(struct gtt_range *gt)
 {
-	int ret;
+	int ret = 0;
 	struct drm_device *dev = gt->gem.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
@@ -264,7 +263,7 @@ void psb_gtt_unpin(struct gtt_range *gt)
 	}
 	mutex_unlock(&dev_priv->gtt_mutex);
 }
-	
+
 /*
  *	GTT resource allocator - allocate and manage GTT address space
  */
@@ -291,7 +290,7 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	struct resource *r = dev_priv->gtt_mem;
 	int ret;
 	unsigned long start, end;
-	
+
 	if (backed) {
 	        /* The start of the GTT is the stolen pages */
 	        start = r->start;
@@ -490,7 +489,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 		goto out_err;
 	}
 
-	DRM_DEBUG("%s: vram kernel virtual address %p\n", dev_priv->vram_addr);
+	DRM_DEBUG("vram kernel virtual address: %p\n", dev_priv->vram_addr);
 
 	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
 		(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1261404430-1309677374=:16316--
