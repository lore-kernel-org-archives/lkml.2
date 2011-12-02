Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1LBNQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:16:49 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:46811 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311Ab1LBNQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 08:16:48 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH] mfd/abx500: unify abx500 headers in mfd/abx500
Date: Fri, 2 Dec 2011 14:16:33 +0100
Message-ID: <1322831793-25602-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This moves all the header files related to the abx500 family into
a common include directory below mfd. From now on we place any
subchip header in that directory. Headers previously in e.g.
<linux/mfd/ab8500/gpio.h> get prefixed and are now e.g.
<linux/mfd/abx500/ab8500-gpio.h>. The top-level abstract interface
remains in <linux/mfd/abx500.h>.

Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c                 |    4 ++--
 arch/arm/mach-ux500/board-u5500.c                  |    2 +-
 .../mach-ux500/include/mach/irqs-board-mop500.h    |    2 +-
 drivers/input/misc/ab8500-ponkey.c                 |    2 +-
 drivers/mfd/ab5500-core.c                          |    2 +-
 drivers/mfd/ab5500-debugfs.c                       |    2 +-
 drivers/mfd/ab8500-core.c                          |    2 +-
 drivers/mfd/ab8500-debugfs.c                       |    2 +-
 drivers/mfd/ab8500-gpadc.c                         |    4 ++--
 drivers/mfd/ab8500-i2c.c                           |    2 +-
 drivers/mfd/ab8500-sysctrl.c                       |    4 ++--
 drivers/misc/ab8500-pwm.c                          |    2 +-
 drivers/regulator/ab8500.c                         |    2 +-
 drivers/rtc/rtc-ab8500.c                           |    2 +-
 drivers/usb/otg/ab8500-usb.c                       |    2 +-
 include/linux/mfd/{ab5500 => abx500}/ab5500.h      |    0
 .../mfd/{ab8500/gpadc.h => abx500/ab8500-gpadc.h}  |    0
 .../mfd/{ab8500/gpio.h => abx500/ab8500-gpio.h}    |    0
 .../{ab8500/sysctrl.h => abx500/ab8500-sysctrl.h}  |    0
 include/linux/mfd/{ => abx500}/ab8500.h            |    0
 20 files changed, 18 insertions(+), 18 deletions(-)
 rename include/linux/mfd/{ab5500 => abx500}/ab5500.h (100%)
 rename include/linux/mfd/{ab8500/gpadc.h => abx500/ab8500-gpadc.h} (100%)
 rename include/linux/mfd/{ab8500/gpio.h => abx500/ab8500-gpio.h} (100%)
 rename include/linux/mfd/{ab8500/sysctrl.h => abx500/ab8500-sysctrl.h} (100%)
 rename include/linux/mfd/{ => abx500}/ab8500.h (100%)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index bdd7b80..80cef36 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -19,11 +19,11 @@
 #include <linux/amba/pl022.h>
 #include <linux/amba/serial.h>
 #include <linux/spi/spi.h>
-#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
 #include <linux/mfd/tc3589x.h>
 #include <linux/mfd/tps6105x.h>
-#include <linux/mfd/ab8500/gpio.h>
+#include <linux/mfd/abx500/ab8500-gpio.h>
 #include <linux/leds-lp5521.h>
 #include <linux/input.h>
 #include <linux/smsc911x.h>
diff --git a/arch/arm/mach-ux500/board-u5500.c b/arch/arm/mach-ux500/board-u5500.c
index 82025ba..4ecb07a 100644
--- a/arch/arm/mach-ux500/board-u5500.c
+++ b/arch/arm/mach-ux500/board-u5500.c
@@ -10,7 +10,7 @@
 #include <linux/amba/bus.h>
 #include <linux/irq.h>
 #include <linux/i2c.h>
-#include <linux/mfd/ab5500/ab5500.h>
+#include <linux/mfd/abx500/ab5500.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
index 4796990..d2d4131 100644
--- a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
+++ b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
@@ -9,7 +9,7 @@
 #define __MACH_IRQS_BOARD_MOP500_H
 
 /* Number of AB8500 irqs is taken from header file */
-#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500.h>
 
 #define MOP500_AB8500_IRQ_BASE		IRQ_BOARD_START
 #define MOP500_AB8500_IRQ_END		(MOP500_AB8500_IRQ_BASE \
diff --git a/drivers/input/misc/ab8500-ponkey.c b/drivers/input/misc/ab8500-ponkey.c
index 3d3288a..3f199e1 100644
--- a/drivers/input/misc/ab8500-ponkey.c
+++ b/drivers/input/misc/ab8500-ponkey.c
@@ -12,7 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
-#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/slab.h>
 
 /**
diff --git a/drivers/mfd/ab5500-core.c b/drivers/mfd/ab5500-core.c
index ec10629..bd56a76 100644
--- a/drivers/mfd/ab5500-core.c
+++ b/drivers/mfd/ab5500-core.c
@@ -22,8 +22,8 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/random.h>
-#include <linux/mfd/ab5500/ab5500.h>
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab5500.h>
 #include <linux/list.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
diff --git a/drivers/mfd/ab5500-debugfs.c b/drivers/mfd/ab5500-debugfs.c
index 43c0ebb..72ea4c0 100644
--- a/drivers/mfd/ab5500-debugfs.c
+++ b/drivers/mfd/ab5500-debugfs.c
@@ -7,8 +7,8 @@
 #include <linux/export.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-#include <linux/mfd/ab5500/ab5500.h>
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab5500.h>
 #include <linux/uaccess.h>
 
 #include "ab5500-core.h"
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 1e91738..f626d2f 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -17,7 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/ab8500.h>
 
 /*
diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index dedb7f6..9a0211a 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -13,7 +13,7 @@
 #include <linux/platform_device.h>
 
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500.h>
 
 static u32 debug_bank;
 static u32 debug_address;
diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index e985d17..c39fc71 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -18,9 +18,9 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/list.h>
-#include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500/gpadc.h>
+#include <linux/mfd/abx500/ab8500.h>
+#include <linux/mfd/abx500/ab8500-gpadc.h>
 
 /*
  * GPADC register offsets
diff --git a/drivers/mfd/ab8500-i2c.c b/drivers/mfd/ab8500-i2c.c
index 9be541c..087fecd 100644
--- a/drivers/mfd/ab8500-i2c.c
+++ b/drivers/mfd/ab8500-i2c.c
@@ -10,7 +10,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/db8500-prcmu.h>
 
 static int ab8500_i2c_write(struct ab8500 *ab8500, u16 addr, u8 data)
diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index f20feef..c28d4eb 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -7,9 +7,9 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500/sysctrl.h>
+#include <linux/mfd/abx500/ab8500.h>
+#include <linux/mfd/abx500/ab8500-sysctrl.h>
 
 static struct device *sysctrl_dev;
 
diff --git a/drivers/misc/ab8500-pwm.c b/drivers/misc/ab8500-pwm.c
index 2208a9d..d7a9aa1 100644
--- a/drivers/misc/ab8500-pwm.c
+++ b/drivers/misc/ab8500-pwm.c
@@ -8,8 +8,8 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/pwm.h>
-#include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/module.h>
 
 /*
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 6e1ae69..80d0823 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -16,8 +16,8 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index e346705..db16ce2 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -15,7 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/delay.h>
 
 #define AB8500_RTC_SOFF_STAT_REG	0x00
diff --git a/drivers/usb/otg/ab8500-usb.c b/drivers/usb/otg/ab8500-usb.c
index 07ccea9..74fe6e6 100644
--- a/drivers/usb/otg/ab8500-usb.c
+++ b/drivers/usb/otg/ab8500-usb.c
@@ -30,7 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500/ab8500.h>
 
 #define AB8500_MAIN_WD_CTRL_REG 0x01
 #define AB8500_USB_LINE_STAT_REG 0x80
diff --git a/include/linux/mfd/ab5500/ab5500.h b/include/linux/mfd/abx500/ab5500.h
similarity index 100%
rename from include/linux/mfd/ab5500/ab5500.h
rename to include/linux/mfd/abx500/ab5500.h
diff --git a/include/linux/mfd/ab8500/gpadc.h b/include/linux/mfd/abx500/ab8500-gpadc.h
similarity index 100%
rename from include/linux/mfd/ab8500/gpadc.h
rename to include/linux/mfd/abx500/ab8500-gpadc.h
diff --git a/include/linux/mfd/ab8500/gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
similarity index 100%
rename from include/linux/mfd/ab8500/gpio.h
rename to include/linux/mfd/abx500/ab8500-gpio.h
diff --git a/include/linux/mfd/ab8500/sysctrl.h b/include/linux/mfd/abx500/ab8500-sysctrl.h
similarity index 100%
rename from include/linux/mfd/ab8500/sysctrl.h
rename to include/linux/mfd/abx500/ab8500-sysctrl.h
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/abx500/ab8500.h
similarity index 100%
rename from include/linux/mfd/ab8500.h
rename to include/linux/mfd/abx500/ab8500.h
-- 
1.7.3.2

