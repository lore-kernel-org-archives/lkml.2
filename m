Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1FCWpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:45:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65212 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab1FCWog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:44:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6366"; a="95490393"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v2 7/7] gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers
Date: Fri,  3 Jun 2011 15:44:19 -0700
Message-Id: <1307141059-22431-8-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307141059-22431-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
 <1307141059-22431-1-git-send-email-davidb@codeaurora.org>
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
 .../mach-msm/gpio-v2.c => drivers/gpio/msm_v2.c    |    2 +-
 5 files changed, 11 insertions(+), 7 deletions(-)
 rename arch/arm/mach-msm/gpio-v2.c => drivers/gpio/msm_v2.c (99%)

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
index c19ecd6a..e415661 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -172,6 +172,14 @@ config GPIO_MSM_V1
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
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX7300
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 2a7c24c..d85cb9e 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
 obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
 obj-$(CONFIG_GPIO_MSM_V1)	+= msm_v1.o
+obj-$(CONFIG_GPIO_MSM_V2)	+= msm_v2.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
 obj-$(CONFIG_GPIO_TPS65910)	+= tps65910-gpio.o
diff --git a/arch/arm/mach-msm/gpio-v2.c b/drivers/gpio/msm_v2.c
similarity index 99%
rename from arch/arm/mach-msm/gpio-v2.c
rename to drivers/gpio/msm_v2.c
index cc9c4fd..822a449 100644
--- a/arch/arm/mach-msm/gpio-v2.c
+++ b/drivers/gpio/msm_v2.c
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

