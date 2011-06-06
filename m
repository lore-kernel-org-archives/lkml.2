Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab1FFVwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:52:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16140 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972Ab1FFVvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:51:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6369"; a="95967503"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 7/8] gpio_msm: Move Qualcomm v6 MSM driver into drivers
Date: Mon,  6 Jun 2011 14:51:14 -0700
Message-Id: <1307397075-11733-8-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
 <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate the driver for the v6-based MSM chips into drivers/gpio.  The
driver is unchanged, only moved.

Signed-off-by: David Brown <davidb@codeaurora.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 arch/arm/mach-msm/Kconfig                          |    3 +++
 arch/arm/mach-msm/Makefile                         |    2 --
 drivers/gpio/Kconfig                               |    8 ++++++++
 drivers/gpio/Makefile                              |    1 +
 .../mach-msm/gpio.c => drivers/gpio/gpio-msm-v1.c  |    5 ++---
 5 files changed, 14 insertions(+), 5 deletions(-)
 rename arch/arm/mach-msm/gpio.c => drivers/gpio/gpio-msm-v1.c (99%)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 1516896..cc7c0b2 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -11,6 +11,7 @@ config ARCH_MSM7X00A
 	select MSM_SMD
 	select MSM_SMD_PKG3
 	select CPU_V6
+	select GPIO_MSM_V1
 	select MSM_PROC_COMM
 	select HAS_MSM_DEBUG_UART_PHYS
 
@@ -22,6 +23,7 @@ config ARCH_MSM7X30
 	select MSM_VIC
 	select CPU_V7
 	select MSM_GPIOMUX
+	select GPIO_MSM_V1
 	select MSM_PROC_COMM
 	select HAS_MSM_DEBUG_UART_PHYS
 
@@ -33,6 +35,7 @@ config ARCH_QSD8X50
 	select MSM_VIC
 	select CPU_V7
 	select MSM_GPIOMUX
+	select GPIO_MSM_V1
 	select MSM_PROC_COMM
 	select HAS_MSM_DEBUG_UART_PHYS
 
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 9519fd2..c0709af 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -34,6 +34,4 @@ ifndef CONFIG_ARCH_MSM8960
 # TODO: TLMM Mapping issues need to be resolved
 obj-y	+= gpio-v2.o
 endif
-else
-obj-y	+= gpio.o
 endif
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4a7f631..00a02bb 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -93,6 +93,14 @@ config GPIO_EXYNOS4
 	help
 	  Say yes here to support Samsung Exynos4 series SoCs GPIO library
 
+config GPIO_MSM_V1
+	tristate "Qualcomm MSM GPIO v1"
+	depends on GPIOLIB && ARCH_MSM
+	help
+	  Say yes here to support the GPIO interface on ARM v6 based
+	  Qualcomm MSM chips.  Most of the pins on the MSM can be
+	  selected for GPIO, and are controlled by this driver.
+
 config GPIO_PLAT_SAMSUNG
 	bool "Samsung SoCs GPIO library support"
 	default y if SAMSUNG_GPIOLIB_4BIT
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index b605f8e..72d4e50 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
 obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
+obj-$(CONFIG_GPIO_MSM_V1)	+= gpio-msm-v1.o
 obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
 obj-$(CONFIG_ARCH_OMAP)         += gpio-omap.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
diff --git a/arch/arm/mach-msm/gpio.c b/drivers/gpio/gpio-msm-v1.c
similarity index 99%
rename from arch/arm/mach-msm/gpio.c
rename to drivers/gpio/gpio-msm-v1.c
index 3bbf50e..52a4d42 100644
--- a/arch/arm/mach-msm/gpio.c
+++ b/drivers/gpio/gpio-msm-v1.c
@@ -1,7 +1,6 @@
-/* linux/arch/arm/mach-msm/gpio.c
- *
+/*
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

