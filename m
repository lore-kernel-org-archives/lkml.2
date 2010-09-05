Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0IEBxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 21:53:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1314 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab0IEBxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 21:53:05 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] drivers/gpu/drm: Remove unnecessary casts of private_data
Date: Sat,  4 Sep 2010 18:52:42 -0700
Message-Id: <41dc995dbe142151c89cff07db0f34277af9446e.1283650107.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <cover.1283650107.git.joe@perches.com>
References: <cover.1283650107.git.joe@perches.com>
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
index 84c53e4..a823d8f 100644
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
index 8312328..1e8eedd 100644
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
1.7.2.19.g9a302

