Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0GLUuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1727 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab0GLUug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:36 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 07/36] drivers/gpu: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:49:59 -0700
Message-Id: <80efc328f035c08ddf22e57a51d75d5e452c944a.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/radeon/radeon_ttm.c      |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c     |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index e9918d8..6bacaa1 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -631,7 +631,7 @@ int radeon_mmap(struct file *filp, struct vm_area_struct *vma)
 		return drm_mmap(filp, vma);
 	}
 
-	file_priv = (struct drm_file *)filp->private_data;
+	file_priv = filp->private_data;
 	rdev = file_priv->minor->dev->dev_private;
 	if (rdev == NULL) {
 		return -EINVAL;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
index e6a1eb7..dc043c3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
@@ -542,7 +542,7 @@ int vmw_fifo_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct drm_file *file_priv;
 	struct vmw_private *dev_priv;
 
-	file_priv = (struct drm_file *)filp->private_data;
+	file_priv = filp->private_data;
 	dev_priv = vmw_priv(file_priv->minor->dev);
 
 	if (vma->vm_pgoff != (dev_priv->mmio_start >> PAGE_SHIFT) ||
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
index e3df4ad..730951b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
@@ -39,7 +39,7 @@ int vmw_mmap(struct file *filp, struct vm_area_struct *vma)
 		return drm_mmap(filp, vma);
 	}
 
-	file_priv = (struct drm_file *)filp->private_data;
+	file_priv = filp->private_data;
 	dev_priv = vmw_priv(file_priv->minor->dev);
 	return ttm_bo_mmap(filp, vma, &dev_priv->bdev);
 }
-- 
1.7.1.337.g6068.dirty

