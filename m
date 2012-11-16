Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab2KPJzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:55:46 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:38982 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2KPJzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:55:44 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH] drm/nouveau: fix init with agpgart-uninorth
Date: Fri, 16 Nov 2012 11:54:33 +0200
Message-Id: <1353059674-17349-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check that the AGP aperture can be mapped. This follows a similar change
done for Radeon (commit 365048ff, drm/radeon: AGP memory is only I/O if
the aperture can be mapped by the CPU.).

The patch fixes the following error seen on G5 iMac:

	nouveau E[     DRM] failed to create kernel channel, -12

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 35ac57f..5f0e7ef 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1279,7 +1279,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem)
 		if (drm->agp.stat == ENABLED) {
 			mem->bus.offset = mem->start << PAGE_SHIFT;
 			mem->bus.base = drm->agp.base;
-			mem->bus.is_iomem = true;
+			mem->bus.is_iomem = !dev->agp->cant_use_aperture;
 		}
 #endif
 		break;
-- 
1.7.10.4

