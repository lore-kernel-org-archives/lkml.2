Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab1FQHjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 03:39:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37824 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1FQHja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 03:39:30 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH] Drivers: gpu: drm: drm_memory: fixed coding style issue
Date: Fri, 17 Jun 2011 19:38:56 +1200
Message-Id: <1308296336-28871-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues flagged by checkpatch.pl.

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 drivers/gpu/drm/drm_memory.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/drm_memory.c b/drivers/gpu/drm/drm_memory.c
index c9b8050..516c86a 100644
--- a/drivers/gpu/drm/drm_memory.c
+++ b/drivers/gpu/drm/drm_memory.c
@@ -57,7 +57,7 @@ int drm_mem_info(char *buf, char **start, off_t offset,
 
 #if __OS_HAS_AGP
 static void *agp_remap(unsigned long offset, unsigned long size,
-		       struct drm_device * dev)
+		       struct drm_device *dev)
 {
 	unsigned long i, num_pages =
 	    PAGE_ALIGN(size) / PAGE_SIZE;
@@ -81,16 +81,18 @@ static void *agp_remap(unsigned long offset, unsigned long size,
 		return NULL;
 
 	/*
-	 * OK, we're mapping AGP space on a chipset/platform on which memory accesses by
-	 * the CPU do not get remapped by the GART.  We fix this by using the kernel's
-	 * page-table instead (that's probably faster anyhow...).
+	 * OK, we're mapping AGP space on a chipset/platform on which
+	 * memory accesses by the CPU do not get remapped by the GART.
+	 * We fix this by using the kernel's page-table instead
+	 * (that's probably faster anyhow...).
 	 */
 	/* note: use vmalloc() because num_pages could be large... */
 	page_map = vmalloc(num_pages * sizeof(struct page *));
 	if (!page_map)
 		return NULL;
 
-	phys_page_map = (agpmem->memory->pages + (offset - agpmem->bound) / PAGE_SIZE);
+	phys_page_map = (agpmem->memory->pages + (offset - agpmem->bound)
+		/ PAGE_SIZE);
 	for (i = 0; i < num_pages; ++i)
 		page_map[i] = phys_page_map[i];
 	addr = vmap(page_map, num_pages, VM_IOREMAP, PAGE_AGP);
@@ -100,20 +102,20 @@ static void *agp_remap(unsigned long offset, unsigned long size,
 }
 
 /** Wrapper around agp_free_memory() */
-void drm_free_agp(DRM_AGP_MEM * handle, int pages)
+void drm_free_agp(DRM_AGP_MEM *handle, int pages)
 {
 	agp_free_memory(handle);
 }
 EXPORT_SYMBOL(drm_free_agp);
 
 /** Wrapper around agp_bind_memory() */
-int drm_bind_agp(DRM_AGP_MEM * handle, unsigned int start)
+int drm_bind_agp(DRM_AGP_MEM *handle, unsigned int start)
 {
 	return agp_bind_memory(handle, start);
 }
 
 /** Wrapper around agp_unbind_memory() */
-int drm_unbind_agp(DRM_AGP_MEM * handle)
+int drm_unbind_agp(DRM_AGP_MEM *handle)
 {
 	return agp_unbind_memory(handle);
 }
@@ -121,7 +123,7 @@ EXPORT_SYMBOL(drm_unbind_agp);
 
 #else  /*  __OS_HAS_AGP  */
 static inline void *agp_remap(unsigned long offset, unsigned long size,
-			      struct drm_device * dev)
+			      struct drm_device *dev)
 {
 	return NULL;
 }
-- 
1.7.4.1

