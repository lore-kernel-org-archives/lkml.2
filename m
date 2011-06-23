Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab1FWMMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:12:55 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:33050 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757947Ab1FWMMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:12:53 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] gpio/nomadik: move the Nomadik GPIO header
Date: Thu, 23 Jun 2011 14:12:04 +0200
Message-ID: <1308831124-10445-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This takes the Nomadik GPIO header out of the plat-nomadik
directory and pushes it down into <gpio/nomadik> where it belongs.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-nomadik/board-nhk8815.c     |    1 +
 arch/arm/mach-nomadik/cpu-8815.c          |    1 +
 arch/arm/mach-nomadik/i2c-8815nhk.c       |    2 +-
 arch/arm/mach-nomadik/include/mach/gpio.h |    8 ++-
 arch/arm/mach-ux500/board-mop500-pins.c   |    2 +-
 arch/arm/mach-ux500/board-mop500-sdi.c    |    1 +
 arch/arm/mach-ux500/board-u5500-sdi.c     |    2 +-
 arch/arm/mach-ux500/cpu-db5500.c          |    3 +-
 arch/arm/mach-ux500/cpu-db8500.c          |    5 +-
 arch/arm/mach-ux500/devices-common.c      |    3 +-
 arch/arm/mach-ux500/include/mach/gpio.h   |    8 ++-
 arch/arm/plat-nomadik/include/plat/gpio.h |   96 -----------------------------
 drivers/gpio/gpio-nomadik.c               |    2 +-
 include/linux/gpio/nomadik.h              |   84 +++++++++++++++++++++++++
 14 files changed, 111 insertions(+), 107 deletions(-)
 delete mode 100644 arch/arm/plat-nomadik/include/plat/gpio.h
 create mode 100644 include/linux/gpio/nomadik.h

diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index 1399303..de7a1c1 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -16,6 +16,7 @@
 #include <linux/amba/bus.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/onenand.h>
diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index ac58e3b..671bdee 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -22,6 +22,7 @@
 #include <linux/amba/bus.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-nomadik/i2c-8815nhk.c b/arch/arm/mach-nomadik/i2c-8815nhk.c
index abfe25a..a6c7dc4 100644
--- a/arch/arm/mach-nomadik/i2c-8815nhk.c
+++ b/arch/arm/mach-nomadik/i2c-8815nhk.c
@@ -3,7 +3,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/i2c-gpio.h>
-#include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 #include <linux/platform_device.h>
 
 /*
diff --git a/arch/arm/mach-nomadik/include/mach/gpio.h b/arch/arm/mach-nomadik/include/mach/gpio.h
index 7a81a04..2bbfa36 100644
--- a/arch/arm/mach-nomadik/include/mach/gpio.h
+++ b/arch/arm/mach-nomadik/include/mach/gpio.h
@@ -1,6 +1,12 @@
 #ifndef __ASM_ARCH_GPIO_H
 #define __ASM_ARCH_GPIO_H
 
-#include <plat/gpio.h>
+#include <asm-generic/gpio.h>
+
+/* Invoke gpiolibs gpio_chip abstraction */
+#define gpio_get_value  __gpio_get_value
+#define gpio_set_value  __gpio_set_value
+#define gpio_cansleep   __gpio_cansleep
+#define gpio_to_irq     __gpio_to_irq
 
 #endif /* __ASM_ARCH_GPIO_H */
diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index fd4cf1c..9af4a4f 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -6,7 +6,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 
 #include <asm/mach-types.h>
 #include <plat/pincfg.h>
diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 7c6cb4f..d2c114c 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -7,6 +7,7 @@
 
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/mmci.h>
 #include <linux/mmc/host.h>
diff --git a/arch/arm/mach-ux500/board-u5500-sdi.c b/arch/arm/mach-ux500/board-u5500-sdi.c
index 739fb4c..16e87eb 100644
--- a/arch/arm/mach-ux500/board-u5500-sdi.c
+++ b/arch/arm/mach-ux500/board-u5500-sdi.c
@@ -7,7 +7,7 @@
 
 #include <linux/amba/mmci.h>
 #include <linux/mmc/host.h>
-#include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 
 #include <plat/pincfg.h>
 #include <mach/db5500-regs.h>
diff --git a/arch/arm/mach-ux500/cpu-db5500.c b/arch/arm/mach-ux500/cpu-db5500.c
index c01bc19..c51da69 100644
--- a/arch/arm/mach-ux500/cpu-db5500.c
+++ b/arch/arm/mach-ux500/cpu-db5500.c
@@ -9,12 +9,11 @@
 #include <linux/amba/bus.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/gpio/nomadik.h>
 
 #include <asm/mach/map.h>
 #include <asm/pmu.h>
 
-#include <plat/gpio.h>
-
 #include <mach/hardware.h>
 #include <mach/devices.h>
 #include <mach/setup.h>
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 4598b06..07562e8 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -14,7 +14,7 @@
 #include <linux/amba/bus.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/gpio.h>
+#include <linux/gpio/nomadik.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
@@ -162,6 +162,9 @@ static void __init db8500_add_gpios(void)
 	if (cpu_is_u8500v2())
 		pdata.supports_sleepmode = true;
 
+	if (cpu_is_u8500v2())
+		pdata.supports_sleepmode = true;
+
 	dbx500_add_gpios(ARRAY_AND_SIZE(db8500_gpio_base),
 			 IRQ_DB8500_GPIO0, &pdata);
 }
diff --git a/arch/arm/mach-ux500/devices-common.c b/arch/arm/mach-ux500/devices-common.c
index 13a4ce0..7418552 100644
--- a/arch/arm/mach-ux500/devices-common.c
+++ b/arch/arm/mach-ux500/devices-common.c
@@ -12,8 +12,7 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/amba/bus.h>
-
-#include <plat/gpio.h>
+#include <linux/gpio/nomadik.h>
 
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-ux500/include/mach/gpio.h b/arch/arm/mach-ux500/include/mach/gpio.h
index 3c4cd31..cde655c 100644
--- a/arch/arm/mach-ux500/include/mach/gpio.h
+++ b/arch/arm/mach-ux500/include/mach/gpio.h
@@ -7,6 +7,12 @@
  */
 #define ARCH_NR_GPIOS	350
 
-#include <plat/gpio.h>
+#include <asm-generic/gpio.h>
+
+/* Invoke gpiolibs gpio_chip abstraction */
+#define gpio_get_value  __gpio_get_value
+#define gpio_set_value  __gpio_set_value
+#define gpio_cansleep   __gpio_cansleep
+#define gpio_to_irq     __gpio_to_irq
 
 #endif /* __ASM_ARCH_GPIO_H */
diff --git a/arch/arm/plat-nomadik/include/plat/gpio.h b/arch/arm/plat-nomadik/include/plat/gpio.h
deleted file mode 100644
index d5d7e65..0000000
--- a/arch/arm/plat-nomadik/include/plat/gpio.h
+++ /dev/null
@@ -1,96 +0,0 @@
-/*
- * Structures and registers for GPIO access in the Nomadik SoC
- *
- * Copyright (C) 2008 STMicroelectronics
- *     Author: Prafulla WADASKAR <prafulla.wadaskar@st.com>
- * Copyright (C) 2009 Alessandro Rubini <rubini@unipv.it>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ASM_PLAT_GPIO_H
-#define __ASM_PLAT_GPIO_H
-
-#include <asm-generic/gpio.h>
-
-/*
- * These currently cause a function call to happen, they may be optimized
- * if needed by adding cpu-specific defines to identify blocks
- * (see mach-pxa/include/mach/gpio.h as an example using GPLR etc)
- */
-#define gpio_get_value  __gpio_get_value
-#define gpio_set_value  __gpio_set_value
-#define gpio_cansleep   __gpio_cansleep
-#define gpio_to_irq     __gpio_to_irq
-
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
-#endif /* __ASM_PLAT_GPIO_H */
diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index 2c212c7..efc7560 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -23,9 +23,9 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/slab.h>
+#include <linux/gpio/nomadik.h>
 
 #include <asm/mach/irq.h>
-
 #include <plat/pincfg.h>
 #include <mach/hardware.h>
 #include <mach/gpio.h>
diff --git a/include/linux/gpio/nomadik.h b/include/linux/gpio/nomadik.h
new file mode 100644
index 0000000..0cfe96e
--- /dev/null
+++ b/include/linux/gpio/nomadik.h
@@ -0,0 +1,84 @@
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
+#ifndef __GPIO_NOMADIK_H
+#define __GPIO_NOMADIK_H
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
+#endif
-- 
1.7.3.2

