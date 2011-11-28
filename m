Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1K1GVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 01:21:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44487 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1K1GVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 01:21:44 -0500
Message-ID: <1322461296.4954.4.camel@phoenix>
Subject: [PATCH] drm/exynos: convert drivers/gpu/drm/exynos/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Date: Mon, 28 Nov 2011 14:21:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/gpu/drm/exynos/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c  |   17 +----------------
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   13 +------------
 2 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index 83810cb..812ad95 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -220,22 +220,7 @@ static struct platform_driver exynos_drm_platform_driver = {
 	},
 };
 
-static int __init exynos_drm_init(void)
-{
-	DRM_DEBUG_DRIVER("%s\n", __FILE__);
-
-	return platform_driver_register(&exynos_drm_platform_driver);
-}
-
-static void __exit exynos_drm_exit(void)
-{
-	DRM_DEBUG_DRIVER("%s\n", __FILE__);
-
-	platform_driver_unregister(&exynos_drm_platform_driver);
-}
-
-module_init(exynos_drm_init);
-module_exit(exynos_drm_exit);
+module_platform_driver(exynos_drm_platform_driver);
 
 MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 4659c88..0d6e955 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -792,18 +792,7 @@ static struct platform_driver fimd_driver = {
 	},
 };
 
-static int __init fimd_init(void)
-{
-	return platform_driver_register(&fimd_driver);
-}
-
-static void __exit fimd_exit(void)
-{
-	platform_driver_unregister(&fimd_driver);
-}
-
-module_init(fimd_init);
-module_exit(fimd_exit);
+module_platform_driver(fimd_driver);
 
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
 MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
-- 
1.7.5.4



