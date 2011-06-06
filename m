Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1FFVwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:52:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16134 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab1FFVvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:51:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6369"; a="95967504"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 8/8] gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers
Date: Mon,  6 Jun 2011 14:51:15 -0700
Message-Id: <1307397075-11733-9-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
 <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate the driver for the v7-based MSM chips into drivers/gpio.  The
driver is unchanged, only moved.

Signed-off-by: David Brown <davidb@codeaurora.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 arch/arm/mach-msm/Kconfig                          |    1 +
 arch/arm/mach-msm/Makefile                         |    6 ------
 drivers/gpio/Kconfig                               |    8 ++++++++
 drivers/gpio/Makefile                              |    1 +
 .../gpio-v2.c => drivers/gpio/gpio-msm-v2.c        |    4 ++--
 5 files changed, 12 insertions(+), 8 deletions(-)
 rename arch/arm/mach-msm/gpio-v2.c => drivers/gpio/gpio-msm-v2.c (99%)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index cc7c0b2..f5cce3f 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -47,6 +47,7 @@ config ARCH_MSM8X60
 	select ARM_GIC
 	select CPU_V7
 	select MSM_V2_TLMM
+	select GPIO_MSM_V2
 	select MSM_GPIOMUX
 	select MSM_SCM if SMP
 
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index c0709af..7a227d1 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -29,9 +29,3 @@ obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
-ifdef CONFIG_MSM_V2_TLMM
-ifndef CONFIG_ARCH_MSM8960
-# TODO: TLMM Mapping issues need to be resolved
-obj-y	+= gpio-v2.o
-endif
-endif
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 00a02bb..f21e141 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -101,6 +101,14 @@ config GPIO_MSM_V1
 	  Qualcomm MSM chips.  Most of the pins on the MSM can be
 	  selected for GPIO, and are controlled by this driver.
 
+config GPIO_MSM_V2
+	tristate "Qualcomm MSM GPIO v2"
+	depends on GPIOLIB && ARCH_MSM
+	help
+	  Say yes here to support the GPIO interface on ARM v7 based
+	  Qualcomm MSM chips.  Most of the pins on the MSM can be
+	  selected for GPIO, and are controlled by this driver.
+
 config GPIO_PLAT_SAMSUNG
 	bool "Samsung SoCs GPIO library support"
 	default y if SAMSUNG_GPIOLIB_4BIT
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 72d4e50..3efbb99 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_MSM_V1)	+= gpio-msm-v1.o
+obj-$(CONFIG_GPIO_MSM_V2)	+= gpio-msm-v2.o
 obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
 obj-$(CONFIG_ARCH_OMAP)         += gpio-omap.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
diff --git a/arch/arm/mach-msm/gpio-v2.c b/drivers/gpio/gpio-msm-v2.c
similarity index 99%
rename from arch/arm/mach-msm/gpio-v2.c
rename to drivers/gpio/gpio-msm-v2.c
index cc9c4fd..5cb1227 100644
--- a/arch/arm/mach-msm/gpio-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -30,8 +30,8 @@
 
 #include <asm/mach/irq.h>
 
+#include <mach/msm_gpiomux.h>
 #include <mach/msm_iomap.h>
-#include "gpiomux.h"
 
 /* Bits of interest in the GPIO_IN_OUT register.
  */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

