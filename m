Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1HJMRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:17:52 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:46963 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab1HJMRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:17:50 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH 10/19] mach-ep93xx: break out GPIO driver specifics
Date: Wed, 10 Aug 2011 14:17:35 +0200
Message-ID: <1312978655-18405-1-git-send-email-linus.walleij@stericsson.com>
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

Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ep93xx/core.c                     |    1 +
 arch/arm/mach-ep93xx/edb93xx.c                  |    1 +
 arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h |  100 +++++++++++++++++++++++
 arch/arm/mach-ep93xx/include/mach/gpio.h        |   97 ++---------------------
 arch/arm/mach-ep93xx/simone.c                   |    2 +-
 arch/arm/mach-ep93xx/snappercl15.c              |    2 +-
 6 files changed, 110 insertions(+), 93 deletions(-)
 create mode 100644 arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h

diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index c60f081..94c78bc 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -38,6 +38,7 @@
 #include <mach/fb.h>
 #include <mach/ep93xx_keypad.h>
 #include <mach/ep93xx_spi.h>
+#include <mach/gpio-ep93xx.h>
 
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/mach-ep93xx/edb93xx.c b/arch/arm/mach-ep93xx/edb93xx.c
index 9969bb1..3f320c6 100644
--- a/arch/arm/mach-ep93xx/edb93xx.c
+++ b/arch/arm/mach-ep93xx/edb93xx.c
@@ -37,6 +37,7 @@
 #include <mach/hardware.h>
 #include <mach/fb.h>
 #include <mach/ep93xx_spi.h>
+#include <mach/gpio-ep93xx.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h b/arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h
new file mode 100644
index 0000000..8aff2ea
--- /dev/null
+++ b/arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h
@@ -0,0 +1,100 @@
+/* Include file for the EP93XX GPIO controller machine specifics */
+
+#ifndef __GPIO_EP93XX_H
+#define __GPIO_EP93XX_H
+
+/* GPIO port A.  */
+#define EP93XX_GPIO_LINE_A(x)		((x) + 0)
+#define EP93XX_GPIO_LINE_EGPIO0		EP93XX_GPIO_LINE_A(0)
+#define EP93XX_GPIO_LINE_EGPIO1		EP93XX_GPIO_LINE_A(1)
+#define EP93XX_GPIO_LINE_EGPIO2		EP93XX_GPIO_LINE_A(2)
+#define EP93XX_GPIO_LINE_EGPIO3		EP93XX_GPIO_LINE_A(3)
+#define EP93XX_GPIO_LINE_EGPIO4		EP93XX_GPIO_LINE_A(4)
+#define EP93XX_GPIO_LINE_EGPIO5		EP93XX_GPIO_LINE_A(5)
+#define EP93XX_GPIO_LINE_EGPIO6		EP93XX_GPIO_LINE_A(6)
+#define EP93XX_GPIO_LINE_EGPIO7		EP93XX_GPIO_LINE_A(7)
+
+/* GPIO port B.  */
+#define EP93XX_GPIO_LINE_B(x)		((x) + 8)
+#define EP93XX_GPIO_LINE_EGPIO8		EP93XX_GPIO_LINE_B(0)
+#define EP93XX_GPIO_LINE_EGPIO9		EP93XX_GPIO_LINE_B(1)
+#define EP93XX_GPIO_LINE_EGPIO10	EP93XX_GPIO_LINE_B(2)
+#define EP93XX_GPIO_LINE_EGPIO11	EP93XX_GPIO_LINE_B(3)
+#define EP93XX_GPIO_LINE_EGPIO12	EP93XX_GPIO_LINE_B(4)
+#define EP93XX_GPIO_LINE_EGPIO13	EP93XX_GPIO_LINE_B(5)
+#define EP93XX_GPIO_LINE_EGPIO14	EP93XX_GPIO_LINE_B(6)
+#define EP93XX_GPIO_LINE_EGPIO15	EP93XX_GPIO_LINE_B(7)
+
+/* GPIO port C.  */
+#define EP93XX_GPIO_LINE_C(x)		((x) + 40)
+#define EP93XX_GPIO_LINE_ROW0		EP93XX_GPIO_LINE_C(0)
+#define EP93XX_GPIO_LINE_ROW1		EP93XX_GPIO_LINE_C(1)
+#define EP93XX_GPIO_LINE_ROW2		EP93XX_GPIO_LINE_C(2)
+#define EP93XX_GPIO_LINE_ROW3		EP93XX_GPIO_LINE_C(3)
+#define EP93XX_GPIO_LINE_ROW4		EP93XX_GPIO_LINE_C(4)
+#define EP93XX_GPIO_LINE_ROW5		EP93XX_GPIO_LINE_C(5)
+#define EP93XX_GPIO_LINE_ROW6		EP93XX_GPIO_LINE_C(6)
+#define EP93XX_GPIO_LINE_ROW7		EP93XX_GPIO_LINE_C(7)
+
+/* GPIO port D.  */
+#define EP93XX_GPIO_LINE_D(x)		((x) + 24)
+#define EP93XX_GPIO_LINE_COL0		EP93XX_GPIO_LINE_D(0)
+#define EP93XX_GPIO_LINE_COL1		EP93XX_GPIO_LINE_D(1)
+#define EP93XX_GPIO_LINE_COL2		EP93XX_GPIO_LINE_D(2)
+#define EP93XX_GPIO_LINE_COL3		EP93XX_GPIO_LINE_D(3)
+#define EP93XX_GPIO_LINE_COL4		EP93XX_GPIO_LINE_D(4)
+#define EP93XX_GPIO_LINE_COL5		EP93XX_GPIO_LINE_D(5)
+#define EP93XX_GPIO_LINE_COL6		EP93XX_GPIO_LINE_D(6)
+#define EP93XX_GPIO_LINE_COL7		EP93XX_GPIO_LINE_D(7)
+
+/* GPIO port E.  */
+#define EP93XX_GPIO_LINE_E(x)		((x) + 32)
+#define EP93XX_GPIO_LINE_GRLED		EP93XX_GPIO_LINE_E(0)
+#define EP93XX_GPIO_LINE_RDLED		EP93XX_GPIO_LINE_E(1)
+#define EP93XX_GPIO_LINE_DIORn		EP93XX_GPIO_LINE_E(2)
+#define EP93XX_GPIO_LINE_IDECS1n	EP93XX_GPIO_LINE_E(3)
+#define EP93XX_GPIO_LINE_IDECS2n	EP93XX_GPIO_LINE_E(4)
+#define EP93XX_GPIO_LINE_IDEDA0		EP93XX_GPIO_LINE_E(5)
+#define EP93XX_GPIO_LINE_IDEDA1		EP93XX_GPIO_LINE_E(6)
+#define EP93XX_GPIO_LINE_IDEDA2		EP93XX_GPIO_LINE_E(7)
+
+/* GPIO port F.  */
+#define EP93XX_GPIO_LINE_F(x)		((x) + 16)
+#define EP93XX_GPIO_LINE_WP		EP93XX_GPIO_LINE_F(0)
+#define EP93XX_GPIO_LINE_MCCD1		EP93XX_GPIO_LINE_F(1)
+#define EP93XX_GPIO_LINE_MCCD2		EP93XX_GPIO_LINE_F(2)
+#define EP93XX_GPIO_LINE_MCBVD1		EP93XX_GPIO_LINE_F(3)
+#define EP93XX_GPIO_LINE_MCBVD2		EP93XX_GPIO_LINE_F(4)
+#define EP93XX_GPIO_LINE_VS1		EP93XX_GPIO_LINE_F(5)
+#define EP93XX_GPIO_LINE_READY		EP93XX_GPIO_LINE_F(6)
+#define EP93XX_GPIO_LINE_VS2		EP93XX_GPIO_LINE_F(7)
+
+/* GPIO port G.  */
+#define EP93XX_GPIO_LINE_G(x)		((x) + 48)
+#define EP93XX_GPIO_LINE_EECLK		EP93XX_GPIO_LINE_G(0)
+#define EP93XX_GPIO_LINE_EEDAT		EP93XX_GPIO_LINE_G(1)
+#define EP93XX_GPIO_LINE_SLA0		EP93XX_GPIO_LINE_G(2)
+#define EP93XX_GPIO_LINE_SLA1		EP93XX_GPIO_LINE_G(3)
+#define EP93XX_GPIO_LINE_DD12		EP93XX_GPIO_LINE_G(4)
+#define EP93XX_GPIO_LINE_DD13		EP93XX_GPIO_LINE_G(5)
+#define EP93XX_GPIO_LINE_DD14		EP93XX_GPIO_LINE_G(6)
+#define EP93XX_GPIO_LINE_DD15		EP93XX_GPIO_LINE_G(7)
+
+/* GPIO port H.  */
+#define EP93XX_GPIO_LINE_H(x)		((x) + 56)
+#define EP93XX_GPIO_LINE_DD0		EP93XX_GPIO_LINE_H(0)
+#define EP93XX_GPIO_LINE_DD1		EP93XX_GPIO_LINE_H(1)
+#define EP93XX_GPIO_LINE_DD2		EP93XX_GPIO_LINE_H(2)
+#define EP93XX_GPIO_LINE_DD3		EP93XX_GPIO_LINE_H(3)
+#define EP93XX_GPIO_LINE_DD4		EP93XX_GPIO_LINE_H(4)
+#define EP93XX_GPIO_LINE_DD5		EP93XX_GPIO_LINE_H(5)
+#define EP93XX_GPIO_LINE_DD6		EP93XX_GPIO_LINE_H(6)
+#define EP93XX_GPIO_LINE_DD7		EP93XX_GPIO_LINE_H(7)
+
+/* maximum value for gpio line identifiers */
+#define EP93XX_GPIO_LINE_MAX		EP93XX_GPIO_LINE_H(7)
+
+/* maximum value for irq capable line identifiers */
+#define EP93XX_GPIO_LINE_MAX_IRQ	EP93XX_GPIO_LINE_F(7)
+
+#endif /* __GPIO_EP93XX_H */
diff --git a/arch/arm/mach-ep93xx/include/mach/gpio.h b/arch/arm/mach-ep93xx/include/mach/gpio.h
index 071f676..acfc113 100644
--- a/arch/arm/mach-ep93xx/include/mach/gpio.h
+++ b/arch/arm/mach-ep93xx/include/mach/gpio.h
@@ -5,99 +5,14 @@
 #ifndef __ASM_ARCH_GPIO_H
 #define __ASM_ARCH_GPIO_H
 
-/* GPIO port A.  */
-#define EP93XX_GPIO_LINE_A(x)		((x) + 0)
-#define EP93XX_GPIO_LINE_EGPIO0		EP93XX_GPIO_LINE_A(0)
-#define EP93XX_GPIO_LINE_EGPIO1		EP93XX_GPIO_LINE_A(1)
-#define EP93XX_GPIO_LINE_EGPIO2		EP93XX_GPIO_LINE_A(2)
-#define EP93XX_GPIO_LINE_EGPIO3		EP93XX_GPIO_LINE_A(3)
-#define EP93XX_GPIO_LINE_EGPIO4		EP93XX_GPIO_LINE_A(4)
-#define EP93XX_GPIO_LINE_EGPIO5		EP93XX_GPIO_LINE_A(5)
-#define EP93XX_GPIO_LINE_EGPIO6		EP93XX_GPIO_LINE_A(6)
-#define EP93XX_GPIO_LINE_EGPIO7		EP93XX_GPIO_LINE_A(7)
+/* new generic GPIO API - see Documentation/gpio.txt */
 
-/* GPIO port B.  */
-#define EP93XX_GPIO_LINE_B(x)		((x) + 8)
-#define EP93XX_GPIO_LINE_EGPIO8		EP93XX_GPIO_LINE_B(0)
-#define EP93XX_GPIO_LINE_EGPIO9		EP93XX_GPIO_LINE_B(1)
-#define EP93XX_GPIO_LINE_EGPIO10	EP93XX_GPIO_LINE_B(2)
-#define EP93XX_GPIO_LINE_EGPIO11	EP93XX_GPIO_LINE_B(3)
-#define EP93XX_GPIO_LINE_EGPIO12	EP93XX_GPIO_LINE_B(4)
-#define EP93XX_GPIO_LINE_EGPIO13	EP93XX_GPIO_LINE_B(5)
-#define EP93XX_GPIO_LINE_EGPIO14	EP93XX_GPIO_LINE_B(6)
-#define EP93XX_GPIO_LINE_EGPIO15	EP93XX_GPIO_LINE_B(7)
+#include <asm-generic/gpio.h>
+#include "gpio-ep93xx.h"
 
-/* GPIO port C.  */
-#define EP93XX_GPIO_LINE_C(x)		((x) + 40)
-#define EP93XX_GPIO_LINE_ROW0		EP93XX_GPIO_LINE_C(0)
-#define EP93XX_GPIO_LINE_ROW1		EP93XX_GPIO_LINE_C(1)
-#define EP93XX_GPIO_LINE_ROW2		EP93XX_GPIO_LINE_C(2)
-#define EP93XX_GPIO_LINE_ROW3		EP93XX_GPIO_LINE_C(3)
-#define EP93XX_GPIO_LINE_ROW4		EP93XX_GPIO_LINE_C(4)
-#define EP93XX_GPIO_LINE_ROW5		EP93XX_GPIO_LINE_C(5)
-#define EP93XX_GPIO_LINE_ROW6		EP93XX_GPIO_LINE_C(6)
-#define EP93XX_GPIO_LINE_ROW7		EP93XX_GPIO_LINE_C(7)
-
-/* GPIO port D.  */
-#define EP93XX_GPIO_LINE_D(x)		((x) + 24)
-#define EP93XX_GPIO_LINE_COL0		EP93XX_GPIO_LINE_D(0)
-#define EP93XX_GPIO_LINE_COL1		EP93XX_GPIO_LINE_D(1)
-#define EP93XX_GPIO_LINE_COL2		EP93XX_GPIO_LINE_D(2)
-#define EP93XX_GPIO_LINE_COL3		EP93XX_GPIO_LINE_D(3)
-#define EP93XX_GPIO_LINE_COL4		EP93XX_GPIO_LINE_D(4)
-#define EP93XX_GPIO_LINE_COL5		EP93XX_GPIO_LINE_D(5)
-#define EP93XX_GPIO_LINE_COL6		EP93XX_GPIO_LINE_D(6)
-#define EP93XX_GPIO_LINE_COL7		EP93XX_GPIO_LINE_D(7)
-
-/* GPIO port E.  */
-#define EP93XX_GPIO_LINE_E(x)		((x) + 32)
-#define EP93XX_GPIO_LINE_GRLED		EP93XX_GPIO_LINE_E(0)
-#define EP93XX_GPIO_LINE_RDLED		EP93XX_GPIO_LINE_E(1)
-#define EP93XX_GPIO_LINE_DIORn		EP93XX_GPIO_LINE_E(2)
-#define EP93XX_GPIO_LINE_IDECS1n	EP93XX_GPIO_LINE_E(3)
-#define EP93XX_GPIO_LINE_IDECS2n	EP93XX_GPIO_LINE_E(4)
-#define EP93XX_GPIO_LINE_IDEDA0		EP93XX_GPIO_LINE_E(5)
-#define EP93XX_GPIO_LINE_IDEDA1		EP93XX_GPIO_LINE_E(6)
-#define EP93XX_GPIO_LINE_IDEDA2		EP93XX_GPIO_LINE_E(7)
-
-/* GPIO port F.  */
-#define EP93XX_GPIO_LINE_F(x)		((x) + 16)
-#define EP93XX_GPIO_LINE_WP		EP93XX_GPIO_LINE_F(0)
-#define EP93XX_GPIO_LINE_MCCD1		EP93XX_GPIO_LINE_F(1)
-#define EP93XX_GPIO_LINE_MCCD2		EP93XX_GPIO_LINE_F(2)
-#define EP93XX_GPIO_LINE_MCBVD1		EP93XX_GPIO_LINE_F(3)
-#define EP93XX_GPIO_LINE_MCBVD2		EP93XX_GPIO_LINE_F(4)
-#define EP93XX_GPIO_LINE_VS1		EP93XX_GPIO_LINE_F(5)
-#define EP93XX_GPIO_LINE_READY		EP93XX_GPIO_LINE_F(6)
-#define EP93XX_GPIO_LINE_VS2		EP93XX_GPIO_LINE_F(7)
-
-/* GPIO port G.  */
-#define EP93XX_GPIO_LINE_G(x)		((x) + 48)
-#define EP93XX_GPIO_LINE_EECLK		EP93XX_GPIO_LINE_G(0)
-#define EP93XX_GPIO_LINE_EEDAT		EP93XX_GPIO_LINE_G(1)
-#define EP93XX_GPIO_LINE_SLA0		EP93XX_GPIO_LINE_G(2)
-#define EP93XX_GPIO_LINE_SLA1		EP93XX_GPIO_LINE_G(3)
-#define EP93XX_GPIO_LINE_DD12		EP93XX_GPIO_LINE_G(4)
-#define EP93XX_GPIO_LINE_DD13		EP93XX_GPIO_LINE_G(5)
-#define EP93XX_GPIO_LINE_DD14		EP93XX_GPIO_LINE_G(6)
-#define EP93XX_GPIO_LINE_DD15		EP93XX_GPIO_LINE_G(7)
-
-/* GPIO port H.  */
-#define EP93XX_GPIO_LINE_H(x)		((x) + 56)
-#define EP93XX_GPIO_LINE_DD0		EP93XX_GPIO_LINE_H(0)
-#define EP93XX_GPIO_LINE_DD1		EP93XX_GPIO_LINE_H(1)
-#define EP93XX_GPIO_LINE_DD2		EP93XX_GPIO_LINE_H(2)
-#define EP93XX_GPIO_LINE_DD3		EP93XX_GPIO_LINE_H(3)
-#define EP93XX_GPIO_LINE_DD4		EP93XX_GPIO_LINE_H(4)
-#define EP93XX_GPIO_LINE_DD5		EP93XX_GPIO_LINE_H(5)
-#define EP93XX_GPIO_LINE_DD6		EP93XX_GPIO_LINE_H(6)
-#define EP93XX_GPIO_LINE_DD7		EP93XX_GPIO_LINE_H(7)
-
-/* maximum value for gpio line identifiers */
-#define EP93XX_GPIO_LINE_MAX		EP93XX_GPIO_LINE_H(7)
-
-/* maximum value for irq capable line identifiers */
-#define EP93XX_GPIO_LINE_MAX_IRQ	EP93XX_GPIO_LINE_F(7)
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
 
 /*
  * Map GPIO A0..A7  (0..7)  to irq 64..71,
diff --git a/arch/arm/mach-ep93xx/simone.c b/arch/arm/mach-ep93xx/simone.c
index 8392e95..1a472ff 100644
--- a/arch/arm/mach-ep93xx/simone.c
+++ b/arch/arm/mach-ep93xx/simone.c
@@ -18,12 +18,12 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c-gpio.h>
 
 #include <mach/hardware.h>
 #include <mach/fb.h>
+#include <mach/gpio-ep93xx.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-ep93xx/snappercl15.c b/arch/arm/mach-ep93xx/snappercl15.c
index 2e9c614..4f4b0b2 100644
--- a/arch/arm/mach-ep93xx/snappercl15.c
+++ b/arch/arm/mach-ep93xx/snappercl15.c
@@ -20,7 +20,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
-#include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c-gpio.h>
 #include <linux/fb.h>
@@ -30,6 +29,7 @@
 
 #include <mach/hardware.h>
 #include <mach/fb.h>
+#include <mach/gpio-ep93xx.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-- 
1.7.3.2

