Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab2H0HHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:07:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47046 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2H0HHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:07:44 -0400
MIME-Version: 1.0
Date: Mon, 27 Aug 2012 15:07:43 +0800
Message-ID: <CAPgLHd_GxZkf5JygjJ2i-6A=JP_jUSJpXM_5PWk3T=OzWs8D1g@mail.gmail.com>
Subject: [PATCH] vmwgfx: remove useless set memory to zero use memset()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The memory return by kzalloc() or kmem_cache_zalloc() has already
be set to zero, so remove useless memset(0).

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 1 -
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 4d9edea..3e47f75 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -437,7 +437,6 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 		DRM_ERROR("Failed allocating a device private struct.\n");
 		return -ENOMEM;
 	}
-	memset(dev_priv, 0, sizeof(*dev_priv));
 
 	pci_set_master(dev->pdev);
 

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index c50724b..5474394 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -483,7 +483,6 @@ static int do_surface_dirty_sou(struct vmw_private *dev_priv,
 	}
 
 	/* only need to do this once */
-	memset(cmd, 0, fifo_size);
 	cmd->header.id = cpu_to_le32(SVGA_3D_CMD_BLIT_SURFACE_TO_SCREEN);
 	cmd->header.size = cpu_to_le32(fifo_size - sizeof(cmd->header));
 


