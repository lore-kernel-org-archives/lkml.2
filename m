Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab1ALVVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 16:21:22 -0500
Received: from mail.perches.com ([173.55.12.10]:3103 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab1ALVVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:21:21 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 1/3] vmwgfx: Remove unnecessary memset(,0,)
Date: Wed, 12 Jan 2011 13:21:17 -0800
Message-Id: <6f6d4a7a705949a3464471f364f77215f1e796f3.1294867098.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc'd memory doesn't need a memset to 0.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 10ca97e..ed18932 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -248,7 +248,6 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 		DRM_ERROR("Failed allocating a device private struct.\n");
 		return -ENOMEM;
 	}
-	memset(dev_priv, 0, sizeof(*dev_priv));
 
 	dev_priv->dev = dev;
 	dev_priv->vmw_chipset = chipset;
-- 
1.7.3.3.398.g0b0cd.dirty

