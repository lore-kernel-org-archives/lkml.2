Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab0JaWeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 18:34:03 -0400
Received: from mail.perches.com ([173.55.12.10]:3900 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab0JaWeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 18:34:00 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 1/4] drivers/gpu/drm/vmwgfx: Fix k.alloc switched arguments
Date: Sun, 31 Oct 2010 15:33:53 -0700
Message-Id: <1bb253bedd9345e3457ce699f9fbc6f65844738f.1288555098.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288555098.git.joe@perches.com>
References: <cover.1288555098.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c     |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
index a01c47d..29113c9 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
@@ -557,7 +557,7 @@ int vmw_kms_init_legacy_display_system(struct vmw_private *dev_priv)
 		return -EINVAL;
 	}
 
-	dev_priv->ldu_priv = kmalloc(GFP_KERNEL, sizeof(*dev_priv->ldu_priv));
+	dev_priv->ldu_priv = kmalloc(sizeof(*dev_priv->ldu_priv), GFP_KERNEL);
 
 	if (!dev_priv->ldu_priv)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
index df2036e..f1a52f9 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -585,7 +585,7 @@ int vmw_overlay_init(struct vmw_private *dev_priv)
 		return -ENOSYS;
 	}
 
-	overlay = kmalloc(GFP_KERNEL, sizeof(*overlay));
+	overlay = kmalloc(sizeof(*overlay), GFP_KERNEL);
 	if (!overlay)
 		return -ENOMEM;
 
-- 
1.7.3.1.g432b3.dirty

