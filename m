Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1HJMQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:16:45 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:46519 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875Ab1HJMQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:16:42 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Alessandro Rubini <rubini@unipv.it>
Subject: [PATCH 01/19] plat-nomadik: break out GPIO driver specifics
Date: Wed, 10 Aug 2011 14:16:23 +0200
Message-ID: <1312978583-18102-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The <[plat|mach]/gpio.h> file is included from upper directories
and deal with generic GPIO and gpiolib stuff. Break out the
platform and driver specific defines and functions into its own
header file.

Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Alessandro Rubini <rubini@unipv.it>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-nomadik/board-nhk8815.c             |    1 +
 arch/arm/mach-nomadik/cpu-8815.c                  |    2 +-
 arch/arm/mach-nomadik/i2c-8815nhk.c               |    2 +-
 arch/arm/mach-ux500/board-mop500-pins.c           |    2 +-
 arch/arm/mach-ux500/board-mop500.c                |    1 +
 arch/arm/mach-ux500/board-u5500-sdi.c             |    2 +-
 arch/arm/mach-ux500/board-u5500.c                 |    2 +-
 arch/arm/mach-ux500/cpu-db5500.c                  |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c                  |    2 +-
 arch/arm/mach-ux500/devices-common.c              |    2 +-
 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h |   85 +++++++++++++++++++++
 arch/arm/plat-nomadik/include/plat/gpio.h         |   69 -----------------
 drivers/gpio/gpio-nomadik.c                       |    1 +
 13 files changed, 96 insertions(+), 77 deletions(-)
 create mode 100644 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h

diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index 1399303..97d7186 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -27,6 +27,7 @@
 #include <asm/mach/irq.h>
 #include <asm/mach/flash.h>
 
+#include <plat/gpio-nomadik.h>
 #include <plat/mtu.h>
 
 #include <mach/setup.h>
diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index ac58e3b..dc67717 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -21,8 +21,8 @@
 #include <linux/device.h>
 #include <linux/amba/bus.h>
 #include <linux/platform_device.h>
-#include <linux/gpio.h>
 
+#include <plat/gpio-nomadik.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-nomadik/i2c-8815nhk.c b/arch/arm/mach-nomadik/i2c-8815nhk.c
index abfe25a..0fc2f6f 100644
--- a/arch/arm/mach-nomadik/i2c-8815nhk.c
+++ b/arch/arm/mach-nomadik/i2c-8815nhk.c
@@ -3,8 +3,8 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/i2c-gpio.h>
-#include <linux/gpio.h>
 #include <linux/platform_device.h>
+#include <plat/gpio-nomadik.h>
 
 /*
  * There are two busses in the 8815NHK.
diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index f26fd76..15b23e4 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -6,10 +6,10 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/gpio.h>
 
 #include <asm/mach-types.h>
 #include <plat/pincfg.h>
+#include <plat/gpio-nomadik.h>
 #include <mach/hardware.h>
 
 #include "pins-db8500.h"
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index cd54aba..537ab63 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -37,6 +37,7 @@
 #include <plat/i2c.h>
 #include <plat/ste_dma40.h>
 #include <plat/pincfg.h>
+#include <plat/gpio-nomadik.h>
 
 #include <mach/hardware.h>
 #include <mach/setup.h>
diff --git a/arch/arm/mach-ux500/board-u5500-sdi.c b/arch/arm/mach-ux500/board-u5500-sdi.c
index 739fb4c..63c3f80 100644
--- a/arch/arm/mach-ux500/board-u5500-sdi.c
+++ b/arch/arm/mach-ux500/board-u5500-sdi.c
@@ -7,9 +7,9 @@
 
 #include <linux/amba/mmci.h>
 #include <linux/mmc/host.h>
-#include <linux/gpio.h>
 
 #include <plat/pincfg.h>
+#include <plat/gpio-nomadik.h>
 #include <mach/db5500-regs.h>
 #include <plat/ste_dma40.h>
 
diff --git a/arch/arm/mach-ux500/board-u5500.c b/arch/arm/mach-ux500/board-u5500.c
index e58f0f5..2d9e191 100644
--- a/arch/arm/mach-ux500/board-u5500.c
+++ b/arch/arm/mach-ux500/board-u5500.c
@@ -8,7 +8,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/amba/bus.h>
-#include <linux/gpio.h>
 #include <linux/irq.h>
 #include <linux/i2c.h>
 
@@ -17,6 +16,7 @@
 
 #include <plat/pincfg.h>
 #include <plat/i2c.h>
+#include <plat/gpio-nomadik.h>
 
 #include <mach/hardware.h>
 #include <mach/devices.h>
diff --git a/arch/arm/mach-ux500/cpu-db5500.c b/arch/arm/mach-ux500/cpu-db5500.c
index 22705d2..9de1af0 100644
--- a/arch/arm/mach-ux500/cpu-db5500.c
+++ b/arch/arm/mach-ux500/cpu-db5500.c
@@ -13,7 +13,7 @@
 #include <asm/mach/map.h>
 #include <asm/pmu.h>
 
-#include <plat/gpio.h>
+#include <plat/gpio-nomadik.h>
 
 #include <mach/hardware.h>
 #include <mach/devices.h>
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 4598b06..13e8890 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -14,12 +14,12 @@
 #include <linux/amba/bus.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
 #include <asm/mach/map.h>
 #include <asm/pmu.h>
+#include <plat/gpio-nomadik.h>
 #include <mach/hardware.h>
 #include <mach/setup.h>
 #include <mach/devices.h>
diff --git a/arch/arm/mach-ux500/devices-common.c b/arch/arm/mach-ux500/devices-common.c
index 13a4ce0..c563e54 100644
--- a/arch/arm/mach-ux500/devices-common.c
+++ b/arch/arm/mach-ux500/devices-common.c
@@ -13,7 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/amba/bus.h>
 
-#include <plat/gpio.h>
+#include <plat/gpio-nomadik.h>
 
 #include <mach/hardware.h>
 
diff --git a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
new file mode 100644
index 0000000..3ba4d8f
--- /dev/null
+++ b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
@@ -0,0 +1,85 @@
+/*
+ * Structures and registers for GPIO access in the Nomadik SoC
+ *
+ * Copyright (C) 2008 STMicroelectronics
+ *     Author: Prafulla WADASKAR <prafulla.wadaskar@st.com>
+ * Copyright (C) 2009 Alessandro Rubini <rubini@unipv.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PLAT_NOMADIK_GPIO
+#define __PLAT_NOMADIK_GPIO
+
+/*
+ * "nmk_gpio" and "NMK_GPIO" stand for "Nomadik GPIO", leaving
+ * the "gpio" namespace for generic and cross-machine functions
+ */
+
+/* Register in the logic block */
+#define NMK_GPIO_DAT	0x00
+#define NMK_GPIO_DATS	0x04
+#define NMK_GPIO_DATC	0x08
+#define NMK_GPIO_PDIS	0x0c
+#define NMK_GPIO_DIR	0x10
+#define NMK_GPIO_DIRS	0x14
+#define NMK_GPIO_DIRC	0x18
+#define NMK_GPIO_SLPC	0x1c
+#define NMK_GPIO_AFSLA	0x20
+#define NMK_GPIO_AFSLB	0x24
+
+#define NMK_GPIO_RIMSC	0x40
+#define NMK_GPIO_FIMSC	0x44
+#define NMK_GPIO_IS	0x48
+#define NMK_GPIO_IC	0x4c
+#define NMK_GPIO_RWIMSC	0x50
+#define NMK_GPIO_FWIMSC	0x54
+#define NMK_GPIO_WKS	0x58
+
+/* Alternate functions: function C is set in hw by setting both A and B */
+#define NMK_GPIO_ALT_GPIO	0
+#define NMK_GPIO_ALT_A	1
+#define NMK_GPIO_ALT_B	2
+#define NMK_GPIO_ALT_C	(NMK_GPIO_ALT_A | NMK_GPIO_ALT_B)
+
+/* Pull up/down values */
+enum nmk_gpio_pull {
+	NMK_GPIO_PULL_NONE,
+	NMK_GPIO_PULL_UP,
+	NMK_GPIO_PULL_DOWN,
+};
+
+/* Sleep mode */
+enum nmk_gpio_slpm {
+	NMK_GPIO_SLPM_INPUT,
+	NMK_GPIO_SLPM_WAKEUP_ENABLE = NMK_GPIO_SLPM_INPUT,
+	NMK_GPIO_SLPM_NOCHANGE,
+	NMK_GPIO_SLPM_WAKEUP_DISABLE = NMK_GPIO_SLPM_NOCHANGE,
+};
+
+extern int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode);
+extern int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull);
+extern int nmk_gpio_set_mode(int gpio, int gpio_mode);
+extern int nmk_gpio_get_mode(int gpio);
+
+extern void nmk_gpio_wakeups_suspend(void);
+extern void nmk_gpio_wakeups_resume(void);
+
+extern void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up);
+
+/*
+ * Platform data to register a block: only the initial gpio/irq number.
+ */
+struct nmk_gpio_platform_data {
+	char *name;
+	int first_gpio;
+	int first_irq;
+	int num_gpio;
+	u32 (*get_secondary_status)(unsigned int bank);
+	void (*set_ioforce)(bool enable);
+	bool supports_sleepmode;
+};
+
+#endif /* __PLAT_NOMADIK_GPIO */
diff --git a/arch/arm/plat-nomadik/include/plat/gpio.h b/arch/arm/plat-nomadik/include/plat/gpio.h
index b894a53..78c0c0f 100644
--- a/arch/arm/plat-nomadik/include/plat/gpio.h
+++ b/arch/arm/plat-nomadik/include/plat/gpio.h
@@ -14,73 +14,4 @@
 
 #include <linux/kernel.h>
 
-/*
- * "nmk_gpio" and "NMK_GPIO" stand for "Nomadik GPIO", leaving
- * the "gpio" namespace for generic and cross-machine functions
- */
-
-/* Register in the logic block */
-#define NMK_GPIO_DAT	0x00
-#define NMK_GPIO_DATS	0x04
-#define NMK_GPIO_DATC	0x08
-#define NMK_GPIO_PDIS	0x0c
-#define NMK_GPIO_DIR	0x10
-#define NMK_GPIO_DIRS	0x14
-#define NMK_GPIO_DIRC	0x18
-#define NMK_GPIO_SLPC	0x1c
-#define NMK_GPIO_AFSLA	0x20
-#define NMK_GPIO_AFSLB	0x24
-
-#define NMK_GPIO_RIMSC	0x40
-#define NMK_GPIO_FIMSC	0x44
-#define NMK_GPIO_IS	0x48
-#define NMK_GPIO_IC	0x4c
-#define NMK_GPIO_RWIMSC	0x50
-#define NMK_GPIO_FWIMSC	0x54
-#define NMK_GPIO_WKS	0x58
-
-/* Alternate functions: function C is set in hw by setting both A and B */
-#define NMK_GPIO_ALT_GPIO	0
-#define NMK_GPIO_ALT_A	1
-#define NMK_GPIO_ALT_B	2
-#define NMK_GPIO_ALT_C	(NMK_GPIO_ALT_A | NMK_GPIO_ALT_B)
-
-/* Pull up/down values */
-enum nmk_gpio_pull {
-	NMK_GPIO_PULL_NONE,
-	NMK_GPIO_PULL_UP,
-	NMK_GPIO_PULL_DOWN,
-};
-
-/* Sleep mode */
-enum nmk_gpio_slpm {
-	NMK_GPIO_SLPM_INPUT,
-	NMK_GPIO_SLPM_WAKEUP_ENABLE = NMK_GPIO_SLPM_INPUT,
-	NMK_GPIO_SLPM_NOCHANGE,
-	NMK_GPIO_SLPM_WAKEUP_DISABLE = NMK_GPIO_SLPM_NOCHANGE,
-};
-
-extern int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode);
-extern int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull);
-extern int nmk_gpio_set_mode(int gpio, int gpio_mode);
-extern int nmk_gpio_get_mode(int gpio);
-
-extern void nmk_gpio_wakeups_suspend(void);
-extern void nmk_gpio_wakeups_resume(void);
-
-extern void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up);
-
-/*
- * Platform data to register a block: only the initial gpio/irq number.
- */
-struct nmk_gpio_platform_data {
-	char *name;
-	int first_gpio;
-	int first_irq;
-	int num_gpio;
-	u32 (*get_secondary_status)(unsigned int bank);
-	void (*set_ioforce)(bool enable);
-	bool supports_sleepmode;
-};
-
 #endif /* __ASM_PLAT_GPIO_H */
diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index f7f0406..740caed 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -27,6 +27,7 @@
 #include <asm/mach/irq.h>
 
 #include <plat/pincfg.h>
+#include <plat/gpio-nomadik.h>
 #include <mach/hardware.h>
 #include <asm/gpio.h>
 
-- 
1.7.3.2

