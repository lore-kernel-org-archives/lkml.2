Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033Ab2LGMu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 07:50:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964900Ab2LGMuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 07:50:25 -0500
MIME-Version: 1.0
Date: Fri, 7 Dec 2012 07:50:23 -0500
Message-ID: <CAPgLHd-65GoO=4D++ir2tq5hv=PtgYzEk4AB6_tyi-SRtsENYg@mail.gmail.com>
Subject: [PATCH -next] drm/exynos/iommu: fix return value check in drm_create_iommu_mapping()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: inki.dae@samsung.com, jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, function arm_iommu_create_mapping() returns
ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/exynos/exynos_drm_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_iommu.c b/drivers/gpu/drm/exynos/exynos_drm_iommu.c
index 09db198..3b3d3a6 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_iommu.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_iommu.c
@@ -56,7 +56,7 @@ int drm_create_iommu_mapping(struct drm_device *drm_dev)
 	mapping = arm_iommu_create_mapping(&platform_bus_type, priv->da_start,
 						priv->da_space_size,
 						priv->da_space_order);
-	if (!mapping)
+	if (IS_ERR(mapping))
 		return -ENOMEM;
 
 	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),


