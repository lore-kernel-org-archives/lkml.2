Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1LXPJy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 10:09:54 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:34942 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab1LXPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 10:09:25 -0500
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH v3 3/5] mfd: Add S5M series configuration
Date: Fri, 23 Dec 2011 17:28:10 +0900
Message-Id: <1324628892-12170-4-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1324628892-12170-1-git-send-email-sbkim73@samsung.com>
References: <1324628892-12170-1-git-send-email-sbkim73@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Samsung S5M series configuration.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/Kconfig  |   32 ++++++++++++++++++++++++++++++++
 drivers/mfd/Makefile |    1 +
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 017f6db..050e961 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -371,6 +371,38 @@ config MFD_MAX8998
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
 
+config MFD_MAX8698
+	bool "Maxim Semiconductor MAX8698 PMIC Support"
+	depends on I2C=y
+	select MFD_CORE
+	help
+	  Say yes here to support for Maxim Semiconductor MAX8698. This is
+	  a Power Management IC. This driver provies common support for
+	  accessing the device, additional drivers must be enabled in order
+	  to use the functionality of the device.
+
+config MFD_MAX77686
+	bool "Maxim Semiconductor MAX77686 PMIC Support"
+	depends on I2C=y && GENERIC_HARDIRQS
+	select MFD_CORE
+	help
+	  Say yes here to support for Maxim Semiconductor MAX77686.
+	  This is a Power Management IC with RTC on chip.
+	  This driver provides common support for accessing the device;
+	  additional drivers must be enabled in order to use the functionality
+	  of the device.
+
+config MFD_S5M_CORE
+	bool "SAMSUNG S5M Series Support"
+	depends on I2C=y && GENERIC_HARDIRQS
+	select MFD_CORE
+	select REGMAP_I2C
+	help
+	 Support for the Samsung Electronics S5M MFD series.
+	 This driver provies common support for accessing the device,
+	 additional drivers must be enabled in order to use the functionality
+	 of the device
+
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index ef0ae7f..4e6ca4e 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -104,3 +104,4 @@ obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
 obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
+obj-$(CONFIG_MFD_S5M_CORE)	+= s5m-core.o s5m-irq.o
-- 
1.7.1

