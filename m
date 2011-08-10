Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1HJMRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:17:44 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:38328 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1HJMRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:17:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>
Subject: [PATCH 09/19] mach-davinci: break out GPIO driver specifics
Date: Wed, 10 Aug 2011 14:17:27 +0200
Message-ID: <1312978647-18372-1-git-send-email-linus.walleij@stericsson.com>
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

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-davinci/da830.c                     |    1 +
 arch/arm/mach-davinci/da850.c                     |    1 +
 arch/arm/mach-davinci/dm355.c                     |    2 +-
 arch/arm/mach-davinci/dm365.c                     |    3 +-
 arch/arm/mach-davinci/dm644x.c                    |    2 +-
 arch/arm/mach-davinci/dm646x.c                    |    2 +-
 arch/arm/mach-davinci/include/mach/gpio-davinci.h |   91 +++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/gpio.h         |   76 +-----------------
 arch/arm/mach-davinci/tnetv107x.c                 |    1 +
 9 files changed, 100 insertions(+), 79 deletions(-)
 create mode 100644 arch/arm/mach-davinci/include/mach/gpio-davinci.h

diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index 358ed0d..a6bf5dc 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -20,6 +20,7 @@
 #include <mach/common.h>
 #include <mach/time.h>
 #include <mach/da8xx.h>
+#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 71a4aa2..4aae015 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -28,6 +28,7 @@
 #include <mach/da8xx.h>
 #include <mach/cpufreq.h>
 #include <mach/pm.h>
+#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index a3a94e9..c143f43 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -13,7 +13,6 @@
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <linux/gpio.h>
 
 #include <linux/spi/spi.h>
 
@@ -30,6 +29,7 @@
 #include <mach/common.h>
 #include <mach/asp.h>
 #include <mach/spi.h>
+#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 4604e72..679e168 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -17,7 +17,6 @@
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <linux/gpio.h>
 #include <linux/spi/spi.h>
 
 #include <asm/mach/map.h>
@@ -34,7 +33,7 @@
 #include <mach/asp.h>
 #include <mach/keyscan.h>
 #include <mach/spi.h>
-
+#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 4c82c27..9a27466 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -12,7 +12,6 @@
 #include <linux/clk.h>
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
-#include <linux/gpio.h>
 
 #include <asm/mach/map.h>
 
@@ -26,6 +25,7 @@
 #include <mach/serial.h>
 #include <mach/common.h>
 #include <mach/asp.h>
+#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 1802e71..03e5f49 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -13,7 +13,6 @@
 #include <linux/clk.h>
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
-#include <linux/gpio.h>
 
 #include <asm/mach/map.h>
 
@@ -27,6 +26,7 @@
 #include <mach/serial.h>
 #include <mach/common.h>
 #include <mach/asp.h>
+#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
diff --git a/arch/arm/mach-davinci/include/mach/gpio-davinci.h b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
new file mode 100644
index 0000000..1fdd1fd
--- /dev/null
+++ b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
@@ -0,0 +1,91 @@
+/*
+ * TI DaVinci GPIO Support
+ *
+ * Copyright (c) 2006 David Brownell
+ * Copyright (c) 2007, MontaVista Software, Inc. <source@mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef	__DAVINCI_DAVINCI_GPIO_H
+#define	__DAVINCI_DAVINCI_GPIO_H
+
+#include <linux/io.h>
+#include <linux/spinlock.h>
+
+#include <asm-generic/gpio.h>
+
+#include <mach/irqs.h>
+#include <mach/common.h>
+
+#define DAVINCI_GPIO_BASE 0x01C67000
+
+enum davinci_gpio_type {
+	GPIO_TYPE_DAVINCI = 0,
+	GPIO_TYPE_TNETV107X,
+};
+
+/*
+ * basic gpio routines
+ *
+ * board-specific init should be done by arch/.../.../board-XXX.c (maybe
+ * initializing banks together) rather than boot loaders; kexec() won't
+ * go through boot loaders.
+ *
+ * the gpio clock will be turned on when gpios are used, and you may also
+ * need to pay attention to PINMUX registers to be sure those pins are
+ * used as gpios, not with other peripherals.
+ *
+ * On-chip GPIOs are numbered 0..(DAVINCI_N_GPIO-1).  For documentation,
+ * and maybe for later updates, code may write GPIO(N).  These may be
+ * all 1.8V signals, all 3.3V ones, or a mix of the two.  A given chip
+ * may not support all the GPIOs in that range.
+ *
+ * GPIOs can also be on external chips, numbered after the ones built-in
+ * to the DaVinci chip.  For now, they won't be usable as IRQ sources.
+ */
+#define	GPIO(X)		(X)		/* 0 <= X <= (DAVINCI_N_GPIO - 1) */
+
+/* Convert GPIO signal to GPIO pin number */
+#define GPIO_TO_PIN(bank, gpio)	(16 * (bank) + (gpio))
+
+struct davinci_gpio_controller {
+	struct gpio_chip	chip;
+	int			irq_base;
+	spinlock_t		lock;
+	void __iomem		*regs;
+	void __iomem		*set_data;
+	void __iomem		*clr_data;
+	void __iomem		*in_data;
+};
+
+/* The __gpio_to_controller() and __gpio_mask() functions inline to constants
+ * with constant parameters; or in outlined code they execute at runtime.
+ *
+ * You'd access the controller directly when reading or writing more than
+ * one gpio value at a time, and to support wired logic where the value
+ * being driven by the cpu need not match the value read back.
+ *
+ * These are NOT part of the cross-platform GPIO interface
+ */
+static inline struct davinci_gpio_controller *
+__gpio_to_controller(unsigned gpio)
+{
+	struct davinci_gpio_controller *ctlrs = davinci_soc_info.gpio_ctlrs;
+	int index = gpio / 32;
+
+	if (!ctlrs || index >= davinci_soc_info.gpio_ctlrs_num)
+		return NULL;
+
+	return ctlrs + index;
+}
+
+static inline u32 __gpio_mask(unsigned gpio)
+{
+	return 1 << (gpio % 32);
+}
+
+#endif	/* __DAVINCI_DAVINCI_GPIO_H */
diff --git a/arch/arm/mach-davinci/include/mach/gpio.h b/arch/arm/mach-davinci/include/mach/gpio.h
index 14e7bb20..fbaae47 100644
--- a/arch/arm/mach-davinci/include/mach/gpio.h
+++ b/arch/arm/mach-davinci/include/mach/gpio.h
@@ -13,82 +13,10 @@
 #ifndef	__DAVINCI_GPIO_H
 #define	__DAVINCI_GPIO_H
 
-#include <linux/io.h>
-#include <linux/spinlock.h>
-
 #include <asm-generic/gpio.h>
 
-#include <mach/irqs.h>
-#include <mach/common.h>
-
-#define __ARM_GPIOLIB_COMPLEX
-
-#define DAVINCI_GPIO_BASE 0x01C67000
-
-enum davinci_gpio_type {
-	GPIO_TYPE_DAVINCI = 0,
-	GPIO_TYPE_TNETV107X,
-};
-
-/*
- * basic gpio routines
- *
- * board-specific init should be done by arch/.../.../board-XXX.c (maybe
- * initializing banks together) rather than boot loaders; kexec() won't
- * go through boot loaders.
- *
- * the gpio clock will be turned on when gpios are used, and you may also
- * need to pay attention to PINMUX registers to be sure those pins are
- * used as gpios, not with other peripherals.
- *
- * On-chip GPIOs are numbered 0..(DAVINCI_N_GPIO-1).  For documentation,
- * and maybe for later updates, code may write GPIO(N).  These may be
- * all 1.8V signals, all 3.3V ones, or a mix of the two.  A given chip
- * may not support all the GPIOs in that range.
- *
- * GPIOs can also be on external chips, numbered after the ones built-in
- * to the DaVinci chip.  For now, they won't be usable as IRQ sources.
- */
-#define	GPIO(X)		(X)		/* 0 <= X <= (DAVINCI_N_GPIO - 1) */
-
-/* Convert GPIO signal to GPIO pin number */
-#define GPIO_TO_PIN(bank, gpio)	(16 * (bank) + (gpio))
-
-struct davinci_gpio_controller {
-	struct gpio_chip	chip;
-	int			irq_base;
-	spinlock_t		lock;
-	void __iomem		*regs;
-	void __iomem		*set_data;
-	void __iomem		*clr_data;
-	void __iomem		*in_data;
-};
-
-/* The __gpio_to_controller() and __gpio_mask() functions inline to constants
- * with constant parameters; or in outlined code they execute at runtime.
- *
- * You'd access the controller directly when reading or writing more than
- * one gpio value at a time, and to support wired logic where the value
- * being driven by the cpu need not match the value read back.
- *
- * These are NOT part of the cross-platform GPIO interface
- */
-static inline struct davinci_gpio_controller *
-__gpio_to_controller(unsigned gpio)
-{
-	struct davinci_gpio_controller *ctlrs = davinci_soc_info.gpio_ctlrs;
-	int index = gpio / 32;
-
-	if (!ctlrs || index >= davinci_soc_info.gpio_ctlrs_num)
-		return NULL;
-
-	return ctlrs + index;
-}
-
-static inline u32 __gpio_mask(unsigned gpio)
-{
-	return 1 << (gpio % 32);
-}
+/* The inline versions use the static inlines in the driver header */
+#include "gpio-davinci.h"
 
 /*
  * The get/set/clear functions will inline when called with constant
diff --git a/arch/arm/mach-davinci/tnetv107x.c b/arch/arm/mach-davinci/tnetv107x.c
index c92641a..409bb86 100644
--- a/arch/arm/mach-davinci/tnetv107x.c
+++ b/arch/arm/mach-davinci/tnetv107x.c
@@ -30,6 +30,7 @@
 #include <mach/irqs.h>
 #include <mach/hardware.h>
 #include <mach/tnetv107x.h>
+#include <mach/gpio-davinci.h>
 
 #include "clock.h"
 #include "mux.h"
-- 
1.7.3.2

