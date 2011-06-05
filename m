Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1FEPvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 11:51:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47460 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab1FEPvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 11:51:32 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v4 3/3] gpio/mxs: Remove the use of gpio-mxs.h
Date: Sun,  5 Jun 2011 23:59:05 +0800
Message-Id: <1307289545-6993-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307289545-6993-1-git-send-email-shawn.guo@linaro.org>
References: <1307289545-6993-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch moves "struct mxs_gpio_port" into gpio-mxs.c, as it needs
not to be public at all.  And then the header
arch/arm/mach-mxs/include/mach/gpio-mxs.h can be deleted.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/mach-mxs/include/mach/gpio-mxs.h |   34 -----------------------------
 drivers/gpio/gpio-mxs.c                   |   10 +++++++-
 2 files changed, 9 insertions(+), 35 deletions(-)
 delete mode 100644 arch/arm/mach-mxs/include/mach/gpio-mxs.h

diff --git a/arch/arm/mach-mxs/include/mach/gpio-mxs.h b/arch/arm/mach-mxs/include/mach/gpio-mxs.h
deleted file mode 100644
index 005bb06..0000000
--- a/arch/arm/mach-mxs/include/mach/gpio-mxs.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Copyright 2007 Freescale Semiconductor, Inc. All Rights Reserved.
- * Copyright 2008 Juergen Beisert, kernel@pengutronix.de
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
- * MA  02110-1301, USA.
- */
-
-#ifndef __MXS_GPIO_H__
-#define __MXS_GPIO_H__
-
-struct mxs_gpio_port {
-	void __iomem *base;
-	int id;
-	int irq;
-	int irq_high;
-	int virtual_irq_start;
-	struct gpio_chip chip;
-};
-
-int mxs_gpio_init(struct mxs_gpio_port*, int);
-
-#endif /* __MXS_GPIO_H__ */
diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index 6fd9f01..a287614 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -28,7 +28,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <mach/mxs.h>
-#include <mach/gpio-mxs.h>
 
 #define MXS_SET		0x4
 #define MXS_CLR		0x8
@@ -49,6 +48,15 @@
 #define GPIO_INT_LEV_MASK	(1 << 0)
 #define GPIO_INT_POL_MASK	(1 << 1)
 
+struct mxs_gpio_port {
+	void __iomem *base;
+	int id;
+	int irq;
+	int irq_high;
+	int virtual_irq_start;
+	struct gpio_chip chip;
+};
+
 /* Note: This driver assumes 32 GPIOs are handled in one register */
 
 static void clear_gpio_irqstatus(struct mxs_gpio_port *port, u32 index)
-- 
1.7.4.1

