Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1HJMRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:17:25 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:39515 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1HJMRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:17:23 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        zeal <zealcook@gmail.com>, Daniel Silverstone <dsilvers@simtec.co.uk>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 05/19] mach-ks8695: break out GPIO driver specifics
Date: Wed, 10 Aug 2011 14:16:57 +0200
Message-ID: <1312978617-18235-1-git-send-email-linus.walleij@stericsson.com>
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

Cc: zeal <zealcook@gmail.com>
Cc: Daniel Silverstone <dsilvers@simtec.co.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ks8695/board-acs5k.c              |    1 +
 arch/arm/mach-ks8695/board-dsm320.c             |    1 +
 arch/arm/mach-ks8695/board-micrel.c             |    1 +
 arch/arm/mach-ks8695/include/mach/gpio-ks8695.h |   39 +++++++++++++++++++++++
 arch/arm/mach-ks8695/include/mach/gpio.h        |   27 ----------------
 drivers/gpio/gpio-ks8695.c                      |    1 +
 6 files changed, 43 insertions(+), 27 deletions(-)
 create mode 100644 arch/arm/mach-ks8695/include/mach/gpio-ks8695.h

diff --git a/arch/arm/mach-ks8695/board-acs5k.c b/arch/arm/mach-ks8695/board-acs5k.c
index dee45cb..3d7d114 100644
--- a/arch/arm/mach-ks8695/board-acs5k.c
+++ b/arch/arm/mach-ks8695/board-acs5k.c
@@ -34,6 +34,7 @@
 #include <asm/mach/irq.h>
 
 #include <mach/devices.h>
+#include <mach/gpio-ks8695.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-ks8695/board-dsm320.c b/arch/arm/mach-ks8695/board-dsm320.c
index e3ccf1a..c3c867a 100644
--- a/arch/arm/mach-ks8695/board-dsm320.c
+++ b/arch/arm/mach-ks8695/board-dsm320.c
@@ -29,6 +29,7 @@
 #include <asm/mach/irq.h>
 
 #include <mach/devices.h>
+#include <mach/gpio-ks8695.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-ks8695/board-micrel.c b/arch/arm/mach-ks8695/board-micrel.c
index e887778..9b9c47c 100644
--- a/arch/arm/mach-ks8695/board-micrel.c
+++ b/arch/arm/mach-ks8695/board-micrel.c
@@ -18,6 +18,7 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
+#include <mach/gpio-ks8695.h>
 #include <mach/devices.h>
 
 #include "generic.h"
diff --git a/arch/arm/mach-ks8695/include/mach/gpio-ks8695.h b/arch/arm/mach-ks8695/include/mach/gpio-ks8695.h
new file mode 100644
index 0000000..6eb034d
--- /dev/null
+++ b/arch/arm/mach-ks8695/include/mach/gpio-ks8695.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2006 Andrew Victor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_KS8659_GPIO_H
+#define __MACH_KS8659_GPIO_H
+
+#include <linux/kernel.h>
+
+#define KS8695_GPIO_0		0
+#define KS8695_GPIO_1		1
+#define KS8695_GPIO_2		2
+#define KS8695_GPIO_3		3
+#define KS8695_GPIO_4		4
+#define KS8695_GPIO_5		5
+#define KS8695_GPIO_6		6
+#define KS8695_GPIO_7		7
+#define KS8695_GPIO_8		8
+#define KS8695_GPIO_9		9
+#define KS8695_GPIO_10		10
+#define KS8695_GPIO_11		11
+#define KS8695_GPIO_12		12
+#define KS8695_GPIO_13		13
+#define KS8695_GPIO_14		14
+#define KS8695_GPIO_15		15
+
+/*
+ * Configure GPIO pin as external interrupt source.
+ */
+extern int ks8695_gpio_interrupt(unsigned int pin, unsigned int type);
+
+/* Register the GPIOs */
+extern void ks8695_register_gpios(void);
+
+#endif /* __MACH_KS8659_GPIO_H */
diff --git a/arch/arm/mach-ks8695/include/mach/gpio.h b/arch/arm/mach-ks8695/include/mach/gpio.h
index 994267b..f5fda36 100644
--- a/arch/arm/mach-ks8695/include/mach/gpio.h
+++ b/arch/arm/mach-ks8695/include/mach/gpio.h
@@ -11,36 +11,9 @@
 #ifndef __ASM_ARCH_GPIO_H_
 #define __ASM_ARCH_GPIO_H_
 
-#include <linux/kernel.h>
-
-#define KS8695_GPIO_0		0
-#define KS8695_GPIO_1		1
-#define KS8695_GPIO_2		2
-#define KS8695_GPIO_3		3
-#define KS8695_GPIO_4		4
-#define KS8695_GPIO_5		5
-#define KS8695_GPIO_6		6
-#define KS8695_GPIO_7		7
-#define KS8695_GPIO_8		8
-#define KS8695_GPIO_9		9
-#define KS8695_GPIO_10		10
-#define KS8695_GPIO_11		11
-#define KS8695_GPIO_12		12
-#define KS8695_GPIO_13		13
-#define KS8695_GPIO_14		14
-#define KS8695_GPIO_15		15
-
-/*
- * Configure GPIO pin as external interrupt source.
- */
-extern int ks8695_gpio_interrupt(unsigned int pin, unsigned int type);
-
 /*
  * Map IRQ number to GPIO line.
  */
 extern int irq_to_gpio(unsigned int irq);
 
-/* Register the GPIOs */
-extern void ks8695_register_gpios(void);
-
 #endif
diff --git a/drivers/gpio/gpio-ks8695.c b/drivers/gpio/gpio-ks8695.c
index b3fdfe1..a3ac66e 100644
--- a/drivers/gpio/gpio-ks8695.c
+++ b/drivers/gpio/gpio-ks8695.c
@@ -31,6 +31,7 @@
 #include <asm/mach/irq.h>
 
 #include <mach/regs-gpio.h>
+#include <mach/gpio-ks8695.h>
 
 /*
  * Configure a GPIO line for either GPIO function, or its internal
-- 
1.7.3.2

