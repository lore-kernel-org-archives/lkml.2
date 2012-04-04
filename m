Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2DDGEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 02:04:48 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49792 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2DDGEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 02:04:47 -0400
From: jhbird.choi@gmail.com
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] ARM: EXYNOS: Remove unused code related to samsung power domain
Date: Wed,  4 Apr 2012 02:04:40 -0400
Message-Id: <1333519480-1813-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

Generic I/O Domain will be used to control power domain instead of
samsung power domain. So remove unused code related to samsung
power domain.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/mach-exynos/mach-nuri.c           |    1 -
 arch/arm/mach-exynos/mach-origen.c         |    1 -
 arch/arm/mach-exynos/mach-smdkv310.c       |    1 -
 arch/arm/mach-exynos/mach-universal_c210.c |    1 -
 arch/arm/plat-samsung/Kconfig              |    8 ---
 arch/arm/plat-samsung/Makefile             |    4 -
 arch/arm/plat-samsung/include/plat/pd.h    |   30 ---------
 arch/arm/plat-samsung/pd.c                 |   95 ----------------------------
 8 files changed, 0 insertions(+), 141 deletions(-)
 delete mode 100644 arch/arm/plat-samsung/include/plat/pd.h
 delete mode 100644 arch/arm/plat-samsung/pd.c

diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index b3982c8..b33ef08 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -48,7 +48,6 @@
 #include <plat/gpio-cfg.h>
 #include <plat/iic.h>
 #include <plat/mfc.h>
-#include <plat/pd.h>
 #include <plat/fimc-core.h>
 #include <plat/camport.h>
 #include <plat/mipi_csis.h>
diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index 878d4c9..a734e93 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -38,7 +38,6 @@
 #include <plat/clock.h>
 #include <plat/gpio-cfg.h>
 #include <plat/backlight.h>
-#include <plat/pd.h>
 #include <plat/fb.h>
 #include <plat/mfc.h>
 
diff --git a/arch/arm/mach-exynos/mach-smdkv310.c b/arch/arm/mach-exynos/mach-smdkv310.c
index 83b91fa..e3597f0 100644
--- a/arch/arm/mach-exynos/mach-smdkv310.c
+++ b/arch/arm/mach-exynos/mach-smdkv310.c
@@ -34,7 +34,6 @@
 #include <plat/keypad.h>
 #include <plat/sdhci.h>
 #include <plat/iic.h>
-#include <plat/pd.h>
 #include <plat/gpio-cfg.h>
 #include <plat/backlight.h>
 #include <plat/mfc.h>
diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index 6bb9dbd..427dc33 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -36,7 +36,6 @@
 #include <plat/fb.h>
 #include <plat/mfc.h>
 #include <plat/sdhci.h>
-#include <plat/pd.h>
 #include <plat/regs-fb-v4.h>
 #include <plat/fimc-core.h>
 #include <plat/camport.h>
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 71553f4..986f2ef 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -350,14 +350,6 @@ config SAMSUNG_WAKEMASK
 	  and above. This code allows a set of interrupt to wakeup-mask
 	  mappings. See <plat/wakeup-mask.h>
 
-comment "Power Domain"
-
-config SAMSUNG_PD
-	bool "Samsung Power Domain"
-	depends on PM_RUNTIME
-	help
-	  Say Y here if you want to control Power Domain by Runtime PM.
-
 config DEBUG_S3C_UART
 	depends on PLAT_SAMSUNG
 	int
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index 6012366..403ae65 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -47,10 +47,6 @@ obj-$(CONFIG_SAMSUNG_PM_CHECK)	+= pm-check.o
 
 obj-$(CONFIG_SAMSUNG_WAKEMASK)	+= wakeup-mask.o
 
-# PD support
-
-obj-$(CONFIG_SAMSUNG_PD)	+= pd.o
-
 # PWM support
 
 obj-$(CONFIG_HAVE_PWM)		+= pwm.o
diff --git a/arch/arm/plat-samsung/include/plat/pd.h b/arch/arm/plat-samsung/include/plat/pd.h
deleted file mode 100644
index abb4bc3..0000000
--- a/arch/arm/plat-samsung/include/plat/pd.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/* linux/arch/arm/plat-samsung/include/plat/pd.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_PLAT_SAMSUNG_PD_H
-#define __ASM_PLAT_SAMSUNG_PD_H __FILE__
-
-struct samsung_pd_info {
-	int (*enable)(struct device *dev);
-	int (*disable)(struct device *dev);
-	void __iomem *base;
-};
-
-enum exynos4_pd_block {
-	PD_MFC,
-	PD_G3D,
-	PD_LCD0,
-	PD_LCD1,
-	PD_TV,
-	PD_CAM,
-	PD_GPS
-};
-
-#endif /* __ASM_PLAT_SAMSUNG_PD_H */
diff --git a/arch/arm/plat-samsung/pd.c b/arch/arm/plat-samsung/pd.c
deleted file mode 100644
index 312b510..0000000
--- a/arch/arm/plat-samsung/pd.c
+++ /dev/null
@@ -1,95 +0,0 @@
-/* linux/arch/arm/plat-samsung/pd.c
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * Samsung Power domain support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#include <linux/init.h>
-#include <linux/export.h>
-#include <linux/platform_device.h>
-#include <linux/err.h>
-#include <linux/pm_runtime.h>
-
-#include <plat/pd.h>
-
-static int samsung_pd_probe(struct platform_device *pdev)
-{
-	struct samsung_pd_info *pdata = pdev->dev.platform_data;
-	struct device *dev = &pdev->dev;
-
-	if (!pdata) {
-		dev_err(dev, "no device data specified\n");
-		return -ENOENT;
-	}
-
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
-	dev_info(dev, "power domain registered\n");
-	return 0;
-}
-
-static int __devexit samsung_pd_remove(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-
-	pm_runtime_disable(dev);
-	return 0;
-}
-
-static int samsung_pd_runtime_suspend(struct device *dev)
-{
-	struct samsung_pd_info *pdata = dev->platform_data;
-	int ret = 0;
-
-	if (pdata->disable)
-		ret = pdata->disable(dev);
-
-	dev_dbg(dev, "suspended\n");
-	return ret;
-}
-
-static int samsung_pd_runtime_resume(struct device *dev)
-{
-	struct samsung_pd_info *pdata = dev->platform_data;
-	int ret = 0;
-
-	if (pdata->enable)
-		ret = pdata->enable(dev);
-
-	dev_dbg(dev, "resumed\n");
-	return ret;
-}
-
-static const struct dev_pm_ops samsung_pd_pm_ops = {
-	.runtime_suspend	= samsung_pd_runtime_suspend,
-	.runtime_resume		= samsung_pd_runtime_resume,
-};
-
-static struct platform_driver samsung_pd_driver = {
-	.driver		= {
-		.name		= "samsung-pd",
-		.owner		= THIS_MODULE,
-		.pm		= &samsung_pd_pm_ops,
-	},
-	.probe		= samsung_pd_probe,
-	.remove		= __devexit_p(samsung_pd_remove),
-};
-
-static int __init samsung_pd_init(void)
-{
-	int ret;
-
-	ret = platform_driver_register(&samsung_pd_driver);
-	if (ret)
-		printk(KERN_ERR "%s: failed to add PD driver\n", __func__);
-
-	return ret;
-}
-arch_initcall(samsung_pd_init);
-- 
1.7.0.4

