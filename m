Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1F1WEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:04:49 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35044 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1F1WEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:04:42 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/29] gma500: Fix uninitialized variable and style issues
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:04:18 +0100
Message-ID: <20110628220402.898.83786.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Bartke <andre.bartke@googlemail.com>

The return variable of psb_gtt_pin() may be used
uninitialized. Also fixed some coding style issues.

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
[Reapplied by hand due to other changes]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_gtt.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)


diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 6a24246..5a296e1 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -58,7 +58,7 @@ static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
  */
 u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
 {
-        struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long offset;
 
 	offset = r->resource.start - dev_priv->gtt_mem->start;
@@ -124,7 +124,7 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 	WARN_ON(r->stolen);
 
 	gtt_slot = psb_gtt_entry(dev, r);
-	pte = psb_gtt_mask_pte(page_to_pfn(dev_priv->scratch_page), 0);;
+	pte = psb_gtt_mask_pte(page_to_pfn(dev_priv->scratch_page), 0);
 
 	for (i = 0; i < r->npage; i++)
 		iowrite32(pte, gtt_slot++);
@@ -213,7 +213,7 @@ static void psb_gtt_detach_pages(struct gtt_range *gt)
  */
 int psb_gtt_pin(struct gtt_range *gt)
 {
-	int ret;
+	int ret = 0;
 	struct drm_device *dev = gt->gem.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
@@ -289,33 +289,33 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	struct resource *r = dev_priv->gtt_mem;
 	int ret;
 	unsigned long start, end;
-	
+
 	if (backed) {
-	        /* The start of the GTT is the stolen pages */
-	        start = r->start;
-	        end = r->start + dev_priv->pg->stolen_size - 1;
+		/* The start of the GTT is the stolen pages */
+		start = r->start;
+		end = r->start + dev_priv->pg->stolen_size - 1;
         } else {
-                /* The rest we will use for GEM backed objects */
-                start = r->start + dev_priv->pg->stolen_size;
-                end = r->end;
+        	/* The rest we will use for GEM backed objects */
+        	start = r->start + dev_priv->pg->stolen_size;
+        	end = r->end;
         }
 
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
@@ -419,7 +419,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 
 	dev_priv->pg = pg = psb_gtt_alloc(dev);
 	if (pg == NULL)
-	        return -ENOMEM;
+		return -ENOMEM;
 
 	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &dev_priv->gmch_ctrl);
 	pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,

