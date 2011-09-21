Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1IUTdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:33:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35329 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1IUTdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:33:50 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/3] arm/tegra: Replace <mach/gpio.h> with <mach/gpio-tegra.h>
Date: Wed, 21 Sep 2011 13:33:39 -0600
Message-Id: <1316633620-13184-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
References: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will eventually allow <mach/gpio.h> to be deleted. This mirrors
LinusW's recent equivalent work on various other ARM platforms.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/board-harmony.h           |    2 +
 arch/arm/mach-tegra/board-paz00.h             |    2 +
 arch/arm/mach-tegra/board-seaboard.h          |    2 +
 arch/arm/mach-tegra/board-trimslice.h         |    2 +
 arch/arm/mach-tegra/include/mach/gpio-tegra.h |   39 +++++++++++++++++++++++++
 arch/arm/mach-tegra/include/mach/gpio.h       |   39 -------------------------
 arch/arm/mach-tegra/usb_phy.c                 |    1 +
 drivers/gpio/gpio-tegra.c                     |    1 +
 drivers/mmc/host/sdhci-tegra.c                |    2 +
 9 files changed, 51 insertions(+), 39 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/gpio-tegra.h

diff --git a/arch/arm/mach-tegra/board-harmony.h b/arch/arm/mach-tegra/board-harmony.h
index 280d203..139d96c 100644
--- a/arch/arm/mach-tegra/board-harmony.h
+++ b/arch/arm/mach-tegra/board-harmony.h
@@ -17,6 +17,8 @@
 #ifndef _MACH_TEGRA_BOARD_HARMONY_H
 #define _MACH_TEGRA_BOARD_HARMONY_H
 
+#include <mach/gpio-tegra.h>
+
 #define HARMONY_GPIO_TPS6586X(_x_)	(TEGRA_NR_GPIOS + (_x_))
 #define HARMONY_GPIO_WM8903(_x_)	(HARMONY_GPIO_TPS6586X(4) + (_x_))
 
diff --git a/arch/arm/mach-tegra/board-paz00.h b/arch/arm/mach-tegra/board-paz00.h
index 86057c3..2dc1899 100644
--- a/arch/arm/mach-tegra/board-paz00.h
+++ b/arch/arm/mach-tegra/board-paz00.h
@@ -17,6 +17,8 @@
 #ifndef _MACH_TEGRA_BOARD_PAZ00_H
 #define _MACH_TEGRA_BOARD_PAZ00_H
 
+#include <mach/gpio-tegra.h>
+
 /* SDCARD */
 #define TEGRA_GPIO_SD1_CD	TEGRA_GPIO_PV5
 #define TEGRA_GPIO_SD1_WP	TEGRA_GPIO_PH1
diff --git a/arch/arm/mach-tegra/board-seaboard.h b/arch/arm/mach-tegra/board-seaboard.h
index d06c334..4c45d4c 100644
--- a/arch/arm/mach-tegra/board-seaboard.h
+++ b/arch/arm/mach-tegra/board-seaboard.h
@@ -17,6 +17,8 @@
 #ifndef _MACH_TEGRA_BOARD_SEABOARD_H
 #define _MACH_TEGRA_BOARD_SEABOARD_H
 
+#include <mach/gpio-tegra.h>
+
 #define SEABOARD_GPIO_TPS6586X(_x_)	(TEGRA_NR_GPIOS + (_x_))
 #define SEABOARD_GPIO_WM8903(_x_)	(SEABOARD_GPIO_TPS6586X(4) + (_x_))
 
diff --git a/arch/arm/mach-tegra/board-trimslice.h b/arch/arm/mach-tegra/board-trimslice.h
index 7a7dee8..50f128d 100644
--- a/arch/arm/mach-tegra/board-trimslice.h
+++ b/arch/arm/mach-tegra/board-trimslice.h
@@ -17,6 +17,8 @@
 #ifndef _MACH_TEGRA_BOARD_TRIMSLICE_H
 #define _MACH_TEGRA_BOARD_TRIMSLICE_H
 
+#include <mach/gpio-tegra.h>
+
 #define TRIMSLICE_GPIO_SD4_CD	TEGRA_GPIO_PP1	/* mmc4 cd */
 #define TRIMSLICE_GPIO_SD4_WP	TEGRA_GPIO_PP2	/* mmc4 wp */
 
diff --git a/arch/arm/mach-tegra/include/mach/gpio-tegra.h b/arch/arm/mach-tegra/include/mach/gpio-tegra.h
new file mode 100644
index 0000000..87d37fd
--- /dev/null
+++ b/arch/arm/mach-tegra/include/mach/gpio-tegra.h
@@ -0,0 +1,39 @@
+/*
+ * arch/arm/mach-tegra/include/mach/gpio.h
+ *
+ * Copyright (C) 2010 Google, Inc.
+ *
+ * Author:
+ *	Erik Gilling <konkers@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __MACH_TEGRA_GPIO_TEGRA_H
+#define __MACH_TEGRA_GPIO_TEGRA_H
+
+#include <linux/types.h>
+#include <mach/irqs.h>
+
+#define TEGRA_NR_GPIOS		INT_GPIO_NR
+
+#define TEGRA_GPIO_TO_IRQ(gpio) (INT_GPIO_BASE + (gpio))
+
+struct tegra_gpio_table {
+	int	gpio;	/* GPIO number */
+	bool	enable;	/* Enable for GPIO at init? */
+};
+
+void tegra_gpio_config(struct tegra_gpio_table *table, int num);
+void tegra_gpio_enable(int gpio);
+void tegra_gpio_disable(int gpio);
+
+#endif
diff --git a/arch/arm/mach-tegra/include/mach/gpio.h b/arch/arm/mach-tegra/include/mach/gpio.h
index 7910d26..e69de29 100644
--- a/arch/arm/mach-tegra/include/mach/gpio.h
+++ b/arch/arm/mach-tegra/include/mach/gpio.h
@@ -1,39 +0,0 @@
-/*
- * arch/arm/mach-tegra/include/mach/gpio.h
- *
- * Copyright (C) 2010 Google, Inc.
- *
- * Author:
- *	Erik Gilling <konkers@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __MACH_TEGRA_GPIO_H
-#define __MACH_TEGRA_GPIO_H
-
-#include <linux/types.h>
-#include <mach/irqs.h>
-
-#define TEGRA_NR_GPIOS		INT_GPIO_NR
-
-#define TEGRA_GPIO_TO_IRQ(gpio) (INT_GPIO_BASE + (gpio))
-
-struct tegra_gpio_table {
-	int	gpio;	/* GPIO number */
-	bool	enable;	/* Enable for GPIO at init? */
-};
-
-void tegra_gpio_config(struct tegra_gpio_table *table, int num);
-void tegra_gpio_enable(int gpio);
-void tegra_gpio_disable(int gpio);
-
-#endif
diff --git a/arch/arm/mach-tegra/usb_phy.c b/arch/arm/mach-tegra/usb_phy.c
index 88081bb..37576a7 100644
--- a/arch/arm/mach-tegra/usb_phy.c
+++ b/arch/arm/mach-tegra/usb_phy.c
@@ -28,6 +28,7 @@
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
 #include <asm/mach-types.h>
+#include <mach/gpio-tegra.h>
 #include <mach/usb_phy.h>
 #include <mach/iomap.h>
 
diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index df64536..6b65207 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -27,6 +27,7 @@
 
 #include <asm/mach/irq.h>
 
+#include <mach/gpio-tegra.h>
 #include <mach/iomap.h>
 #include <mach/suspend.h>
 
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 67176af..067a4cd 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -25,6 +25,8 @@
 #include <linux/module.h>
 
 #include <asm/gpio.h>
+
+#include <mach/gpio-tegra.h>
 #include <mach/sdhci.h>
 
 #include "sdhci-pltfm.h"
-- 
1.7.0.4

