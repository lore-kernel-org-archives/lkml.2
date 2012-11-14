Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2KNKd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:33:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52360 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2KNKd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:33:27 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 10/16] staging/omapdrm: Fix spacing coding style in omap_gem.c
Date: Wed, 14 Nov 2012 19:33:17 +0900
Message-Id: <1352889197-15168-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
References: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_gem.c |   38 ++++++++++++++----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_gem.c b/drivers/staging/omapdrm/omap_gem.c
index 94c04a5..e615871 100644
--- a/drivers/staging/omapdrm/omap_gem.c
+++ b/drivers/staging/omapdrm/omap_gem.c
@@ -521,9 +521,8 @@ int omap_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	/* if a shmem backed object, make sure we have pages attached now */
 	ret = get_pages(obj, &pages);
-	if (ret) {
+	if (ret)
 		goto fail;
-	}
 
 	/* where should we do corresponding put_pages().. we are mapping
 	 * the original page, rather than thru a GART, so we can't rely
@@ -1146,9 +1145,8 @@ int omap_gem_op_sync(struct drm_gem_object *obj, enum omap_gem_op op)
 		struct omap_gem_sync_waiter *waiter =
 				kzalloc(sizeof(*waiter), GFP_KERNEL);
 
-		if (!waiter) {
+		if (!waiter)
 			return -ENOMEM;
-		}
 
 		waiter->omap_obj = omap_obj;
 		waiter->op = op;
@@ -1177,9 +1175,8 @@ int omap_gem_op_sync(struct drm_gem_object *obj, enum omap_gem_op op)
 		}
 		spin_unlock(&sync_lock);
 
-		if (waiter) {
+		if (waiter)
 			kfree(waiter);
-		}
 	}
 	return ret;
 }
@@ -1201,9 +1198,8 @@ int omap_gem_op_async(struct drm_gem_object *obj, enum omap_gem_op op,
 		struct omap_gem_sync_waiter *waiter =
 				kzalloc(sizeof(*waiter), GFP_ATOMIC);
 
-		if (!waiter) {
+		if (!waiter)
 			return -ENOMEM;
-		}
 
 		waiter->omap_obj = omap_obj;
 		waiter->op = op;
@@ -1285,9 +1281,8 @@ void omap_gem_free_object(struct drm_gem_object *obj)
 
 	list_del(&omap_obj->mm_list);
 
-	if (obj->map_list.map) {
+	if (obj->map_list.map)
 		drm_gem_free_mmap_offset(obj);
-	}
 
 	/* this means the object is still pinned.. which really should
 	 * not happen.  I think..
@@ -1296,9 +1291,9 @@ void omap_gem_free_object(struct drm_gem_object *obj)
 
 	/* don't free externally allocated backing memory */
 	if (!(omap_obj->flags & OMAP_BO_EXT_MEM)) {
-		if (omap_obj->pages) {
+		if (omap_obj->pages)
 			omap_gem_detach_pages(obj);
-		}
+
 		if (!is_shmem(obj)) {
 			dma_free_writecombine(dev->dev, obj->size,
 					omap_obj->vaddr, omap_obj->paddr);
@@ -1308,9 +1303,8 @@ void omap_gem_free_object(struct drm_gem_object *obj)
 	}
 
 	/* don't free externally allocated syncobj */
-	if (!(omap_obj->flags & OMAP_BO_EXT_SYNC)) {
+	if (!(omap_obj->flags & OMAP_BO_EXT_SYNC))
 		kfree(omap_obj->sync);
-	}
 
 	drm_gem_object_release(obj);
 
@@ -1395,9 +1389,9 @@ struct drm_gem_object *omap_gem_new(struct drm_device *dev,
 		 */
 		omap_obj->vaddr =  dma_alloc_writecombine(dev->dev, size,
 				&omap_obj->paddr, GFP_KERNEL);
-		if (omap_obj->vaddr) {
+		if (omap_obj->vaddr)
 			flags |= OMAP_BO_DMA;
-		}
+
 	}
 
 	omap_obj->flags = flags;
@@ -1407,22 +1401,20 @@ struct drm_gem_object *omap_gem_new(struct drm_device *dev,
 		omap_obj->height = gsize.tiled.height;
 	}
 
-	if (flags & (OMAP_BO_DMA|OMAP_BO_EXT_MEM)) {
+	if (flags & (OMAP_BO_DMA|OMAP_BO_EXT_MEM))
 		ret = drm_gem_private_object_init(dev, obj, size);
-	} else {
+	else
 		ret = drm_gem_object_init(dev, obj, size);
-	}
 
-	if (ret) {
+	if (ret)
 		goto fail;
-	}
 
 	return obj;
 
 fail:
-	if (obj) {
+	if (obj)
 		omap_gem_free_object(obj);
-	}
+
 	return NULL;
 }
 
-- 
1.7.9.5

