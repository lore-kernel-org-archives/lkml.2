Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2HIJgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:36:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16984 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab2HIJgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:36:50 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-f2-502384b02b82
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com, t.stanislaws@samsung.com,
        kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
        sumit.semwal@linaro.org, inki.dae@samsung.com, daniel.vetter@ffwll.ch,
        rob@ti.com, pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        dan.j.williams@intel.com
Subject: [PATCH v2 2/2] drm: set owner field to for all DMABUF exporters
Date: Thu, 09 Aug 2012 11:36:22 +0200
Message-id: <1344504982-30415-3-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
References: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jAd0NLcoBBjd3Wltc3jWHzaJnw1ZW
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDI6ts9jKXghWbFy4SmWBsYFYl2MnBwSAiYSa3/NZYGw
	xSQu3FvP1sXIxSEksIhRYlfLZBYIp4tJYv2r98wgVWxAHceWfGYEsUUEHCRO350FFmcWmMMs
	8XJLIIgtLOAhsXnyRbCpLAKqEh2HlzKB2LxA8RVnvrNBbJOXeHq/D8zmFPCUWLz6NdgcIaCa
	W31XmCYw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEez9Z9I7GFc1WBxiFOBgVOLh
	vbFFKUCINbGsuDL3EKMEB7OSCO+tcuUAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwm3l/9hQTS
	E0tSs1NTC1KLYLJMHJxSDYzZAZ8P/34QbDbvh59vQkb2k7sHin5ZBy5I0Niz1UusV/Mz/yx3
	9v9zOTcIJ2RKZsY5Hsix3rxayOFvq6m9j1rzqW3s83zyP0dxVRS9vcdxyysjZu9W9iecV1/W
	7sj7e1hl4pU5pZxC9+cks12qkvDU6dDg+sG17NOPPdeagps2/1312n7J4XdKLMUZiYZazEXF
	iQAb8Za1+gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets owner field in DMABUF operations for all DMABUF exporters in
DRM subsystem.  This prevents an exporting module from being unloaded while
exported DMABUF descriptor is in use.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
 drivers/gpu/drm/nouveau/nouveau_prime.c    |    1 +
 drivers/gpu/drm/radeon/radeon_prime.c      |    1 +
 drivers/staging/omapdrm/omap_gem_dmabuf.c  |    1 +
 5 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
index 613bf8a..cf3bc6d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -164,6 +164,7 @@ static void exynos_gem_dmabuf_kunmap(struct dma_buf *dma_buf,
 }
 
 static struct dma_buf_ops exynos_dmabuf_ops = {
+	.owner			= THIS_MODULE,
 	.map_dma_buf		= exynos_gem_map_dma_buf,
 	.unmap_dma_buf		= exynos_gem_unmap_dma_buf,
 	.kmap			= exynos_gem_dmabuf_kmap,
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index aa308e1..07ff03b 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -152,6 +152,7 @@ static int i915_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struct *
 }
 
 static const struct dma_buf_ops i915_dmabuf_ops =  {
+	.owner = THIS_MODULE,
 	.map_dma_buf = i915_gem_map_dma_buf,
 	.unmap_dma_buf = i915_gem_unmap_dma_buf,
 	.release = i915_gem_dmabuf_release,
diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
index a25cf2c..8605033 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -127,6 +127,7 @@ static void nouveau_gem_prime_vunmap(struct dma_buf *dma_buf, void *vaddr)
 }
 
 static const struct dma_buf_ops nouveau_dmabuf_ops =  {
+	.owner = THIS_MODULE,
 	.map_dma_buf = nouveau_gem_map_dma_buf,
 	.unmap_dma_buf = nouveau_gem_unmap_dma_buf,
 	.release = nouveau_gem_dmabuf_release,
diff --git a/drivers/gpu/drm/radeon/radeon_prime.c b/drivers/gpu/drm/radeon/radeon_prime.c
index 6bef46a..4061fd3 100644
--- a/drivers/gpu/drm/radeon/radeon_prime.c
+++ b/drivers/gpu/drm/radeon/radeon_prime.c
@@ -127,6 +127,7 @@ static void radeon_gem_prime_vunmap(struct dma_buf *dma_buf, void *vaddr)
 	mutex_unlock(&dev->struct_mutex);
 }
 const static struct dma_buf_ops radeon_dmabuf_ops =  {
+	.owner = THIS_MODULE,
 	.map_dma_buf = radeon_gem_map_dma_buf,
 	.unmap_dma_buf = radeon_gem_unmap_dma_buf,
 	.release = radeon_gem_dmabuf_release,
diff --git a/drivers/staging/omapdrm/omap_gem_dmabuf.c b/drivers/staging/omapdrm/omap_gem_dmabuf.c
index 42728e0..6a4dd67 100644
--- a/drivers/staging/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/staging/omapdrm/omap_gem_dmabuf.c
@@ -179,6 +179,7 @@ out_unlock:
 }
 
 struct dma_buf_ops omap_dmabuf_ops = {
+		.owner = THIS_MODULE,
 		.map_dma_buf = omap_gem_map_dma_buf,
 		.unmap_dma_buf = omap_gem_unmap_dma_buf,
 		.release = omap_gem_dmabuf_release,
-- 
1.7.9.5

