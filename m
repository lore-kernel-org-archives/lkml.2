Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1HJMSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:18:35 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:43107 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab1HJMSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:18:32 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Barry Song <bs14@csr.com>
Subject: [PATCH 13/19] mach-lpc32xx: break out GPIO driver specifics
Date: Wed, 10 Aug 2011 14:18:00 +0200
Message-ID: <1312978680-18506-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The <mach/gpio.h> file is included from upper directories
and deal with generic GPIO and gpiolib stuff. Break out the
platform and driver specific defines and functions into its own
header file.

Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Barry Song <bs14@csr.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-lpc32xx/include/mach/gpio-lpc32xx.h |   50 ++++++++++++++++++++
 arch/arm/mach-lpc32xx/include/mach/gpio.h         |   52 ---------------------
 arch/arm/mach-lpc32xx/phy3250.c                   |    1 +
 drivers/gpio/gpio-lpc32xx.c                       |    1 +
 4 files changed, 52 insertions(+), 52 deletions(-)
 create mode 100644 arch/arm/mach-lpc32xx/include/mach/gpio-lpc32xx.h

diff --git a/arch/arm/mach-lpc32xx/include/mach/gpio-lpc32xx.h b/arch/arm/mach-lpc32xx/include/mach/gpio-lpc32xx.h
new file mode 100644
index 0000000..1816e22
--- /dev/null
+++ b/arch/arm/mach-lpc32xx/include/mach/gpio-lpc32xx.h
@@ -0,0 +1,50 @@
+/*
+ * Author: Kevin Wells <kevin.wells@nxp.com>
+ *
+ * Copyright (C) 2010 NXP Semiconductors
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_GPIO_LPC32XX_H
+#define __MACH_GPIO_LPC32XX_H
+
+/*
+ * Note!
+ * Muxed GP pins need to be setup to the GP state in the board level
+ * code prior to using this driver.
+ * GPI pins : 28xP3 group
+ * GPO pins : 24xP3 group
+ * GPIO pins: 8xP0 group, 24xP1 group, 13xP2 group, 6xP3 group
+ */
+
+#define LPC32XX_GPIO_P0_MAX 8
+#define LPC32XX_GPIO_P1_MAX 24
+#define LPC32XX_GPIO_P2_MAX 13
+#define LPC32XX_GPIO_P3_MAX 6
+#define LPC32XX_GPI_P3_MAX 28
+#define LPC32XX_GPO_P3_MAX 24
+
+#define LPC32XX_GPIO_P0_GRP 0
+#define LPC32XX_GPIO_P1_GRP (LPC32XX_GPIO_P0_GRP + LPC32XX_GPIO_P0_MAX)
+#define LPC32XX_GPIO_P2_GRP (LPC32XX_GPIO_P1_GRP + LPC32XX_GPIO_P1_MAX)
+#define LPC32XX_GPIO_P3_GRP (LPC32XX_GPIO_P2_GRP + LPC32XX_GPIO_P2_MAX)
+#define LPC32XX_GPI_P3_GRP (LPC32XX_GPIO_P3_GRP + LPC32XX_GPIO_P3_MAX)
+#define LPC32XX_GPO_P3_GRP (LPC32XX_GPI_P3_GRP + LPC32XX_GPI_P3_MAX)
+
+/*
+ * A specific GPIO can be selected with this macro
+ * ie, GPIO_05 can be selected with LPC32XX_GPIO(LPC32XX_GPIO_P3_GRP, 5)
+ * See the LPC32x0 User's guide for GPIO group numbers
+ */
+#define LPC32XX_GPIO(x, y) ((x) + (y))
+
+#endif /* __MACH_GPIO_LPC32XX_H */
diff --git a/arch/arm/mach-lpc32xx/include/mach/gpio.h b/arch/arm/mach-lpc32xx/include/mach/gpio.h
index 66d31f6..e69de29 100644
--- a/arch/arm/mach-lpc32xx/include/mach/gpio.h
+++ b/arch/arm/mach-lpc32xx/include/mach/gpio.h
@@ -1,52 +0,0 @@
-/*
- * arch/arm/mach-lpc32xx/include/mach/gpio.h
- *
- * Author: Kevin Wells <kevin.wells@nxp.com>
- *
- * Copyright (C) 2010 NXP Semiconductors
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __ASM_ARCH_GPIO_H
-#define __ASM_ARCH_GPIO_H
-
-/*
- * Note!
- * Muxed GP pins need to be setup to the GP state in the board level
- * code prior to using this driver.
- * GPI pins : 28xP3 group
- * GPO pins : 24xP3 group
- * GPIO pins: 8xP0 group, 24xP1 group, 13xP2 group, 6xP3 group
- */
-
-#define LPC32XX_GPIO_P0_MAX 8
-#define LPC32XX_GPIO_P1_MAX 24
-#define LPC32XX_GPIO_P2_MAX 13
-#define LPC32XX_GPIO_P3_MAX 6
-#define LPC32XX_GPI_P3_MAX 28
-#define LPC32XX_GPO_P3_MAX 24
-
-#define LPC32XX_GPIO_P0_GRP 0
-#define LPC32XX_GPIO_P1_GRP (LPC32XX_GPIO_P0_GRP + LPC32XX_GPIO_P0_MAX)
-#define LPC32XX_GPIO_P2_GRP (LPC32XX_GPIO_P1_GRP + LPC32XX_GPIO_P1_MAX)
-#define LPC32XX_GPIO_P3_GRP (LPC32XX_GPIO_P2_GRP + LPC32XX_GPIO_P2_MAX)
-#define LPC32XX_GPI_P3_GRP (LPC32XX_GPIO_P3_GRP + LPC32XX_GPIO_P3_MAX)
-#define LPC32XX_GPO_P3_GRP (LPC32XX_GPI_P3_GRP + LPC32XX_GPI_P3_MAX)
-
-/*
- * A specific GPIO can be selected with this macro
- * ie, GPIO_05 can be selected with LPC32XX_GPIO(LPC32XX_GPIO_P3_GRP, 5)
- * See the LPC32x0 User's guide for GPIO group numbers
- */
-#define LPC32XX_GPIO(x, y) ((x) + (y))
-
-#endif
diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index 7993b09..c3a22fd 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -37,6 +37,7 @@
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
+#include <mach/gpio-lpc32xx.h>
 #include "common.h"
 
 /*
diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index b4e9d35..5b69480 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -24,6 +24,7 @@
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
+#include <mach/gpio-lpc32xx.h>
 
 #define LPC32XX_GPIO_P3_INP_STATE		_GPREG(0x000)
 #define LPC32XX_GPIO_P3_OUTP_SET		_GPREG(0x004)
-- 
1.7.3.2

