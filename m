Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689Ab1FAUh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:37:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46217 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab1FAUhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tT6y63kUpiLInvs0VarKiclnfNedIMJtNhyJ+6ku0pEKgOjEdr8lN4i76UembLQ/hw
         YFmxrOW2M9YQcMoVPQYFEC2iOEdGhZvq0frOzEjOfYKOnmptQDju/JHDUpSArMwGIO8Q
         4V0yqJJzyADJ3YIRvoR5pAQMyu2Cc81UiiwYc=
From: Andre Bartke <andre.bartke@googlemail.com>
To: gregkh@suse.de
Cc: alan@linux.intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] staging/gma500: Fix uninitialized variable and style issues
Date: Wed,  1 Jun 2011 22:34:55 +0200
Message-Id: <1306960495-9844-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return variable of psb_gtt_pin() may be used
uninitialized. Also fixed some coding style issues.

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 drivers/staging/gma500/psb_gtt.c |   48 +++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 74c5a65..bc92d1f 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -52,13 +52,13 @@ static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
  *	psb_gtt_entry		-	find the GART entries for a gtt_range
  *	@dev: our DRM device
  *	@r: our GTT range
- * 
+ *
  *	Given a gtt_range object return the GART offset of the page table
  *	entries for this gtt_range
  */
 u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
 {
-        struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long offset;
 
 	offset = r->resource.start - dev_priv->gtt_mem->start;
@@ -78,7 +78,7 @@ u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
  */
 static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 {
-        struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 *gtt_slot, pte;
 	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
 	struct page **pages;
@@ -104,7 +104,7 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 	}
 	/* Make sure all the entries are set before we return */
 	ioread32(gtt_slot - 1);
-	
+
 	return 0;
 }
 
@@ -127,7 +127,7 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 	WARN_ON(r->stolen);
 
 	gtt_slot = psb_gtt_entry(dev, r);
-	pte = psb_gtt_mask_pte(page_to_pfn(dev_priv->scratch_page), 0);;
+	pte = psb_gtt_mask_pte(page_to_pfn(dev_priv->scratch_page), 0);
 
 	for (i = 0; i < numpages; i++)
 		iowrite32(pte, gtt_slot++);
@@ -215,7 +215,7 @@ static void psb_gtt_detach_pages(struct gtt_range *gt)
  */
 int psb_gtt_pin(struct gtt_range *gt)
 {
-	int ret;
+	int ret = 0;
 	struct drm_device *dev = gt->gem.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
@@ -264,7 +264,7 @@ void psb_gtt_unpin(struct gtt_range *gt)
 	}
 	mutex_unlock(&dev_priv->gtt_mutex);
 }
-	
+
 /*
  *	GTT resource allocator - allocate and manage GTT address space
  */
@@ -291,33 +291,33 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	struct resource *r = dev_priv->gtt_mem;
 	int ret;
 	unsigned long start, end;
-	
+
 	if (backed) {
-	        /* The start of the GTT is the stolen pages */
-	        start = r->start;
-	        end = r->start + dev_priv->pg->stolen_size - 1;
-        } else {
-                /* The rest we will use for GEM backed objects */
-                start = r->start + dev_priv->pg->stolen_size;
-                end = r->end;
-        }
+		/* The start of the GTT is the stolen pages */
+		start = r->start;
+		end = r->start + dev_priv->pg->stolen_size - 1;
+	} else {
+		/* The rest we will use for GEM backed objects */
+		start = r->start + dev_priv->pg->stolen_size;
+		end = r->end;
+	}
 
 	gt = kzalloc(sizeof(struct gtt_range), GFP_KERNEL);
 	if (gt == NULL)
 		return NULL;
-        gt->resource.name = name;
-        gt->stolen = backed;
-        gt->in_gart = backed;
-        /* Ensure this is set for non GEM objects */
-        gt->gem.dev = dev;
+	gt->resource.name = name;
+	gt->stolen = backed;
+	gt->in_gart = backed;
+	/* Ensure this is set for non GEM objects */
+	gt->gem.dev = dev;
 	kref_init(&gt->kref);
 
 	ret = allocate_resource(dev_priv->gtt_mem, &gt->resource,
 				len, start, end, PAGE_SIZE, NULL, NULL);
 	if (ret == 0) {
-	        gt->offset = gt->resource.start - r->start;
+		gt->offset = gt->resource.start - r->start;
 		return gt;
-        }
+	}
 	kfree(gt);
 	return NULL;
 }
@@ -421,7 +421,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 
 	dev_priv->pg = pg = psb_gtt_alloc(dev);
 	if (pg == NULL)
-	        return -ENOMEM;
+		return -ENOMEM;
 
 	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &dev_priv->gmch_ctrl);
 	pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
-- 
1.7.5.2

