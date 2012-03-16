Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161117Ab2CPNi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:38:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37245 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760597Ab2CPNiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:38:21 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>
Subject: [PATCH 1/2] input: keypad: move platform_data to <linux/platform_data>
Date: Fri, 16 Mar 2012 19:09:18 +0530
Message-ID: <1331905159-11255-2-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1331905159-11255-1-git-send-email-sourav.poddar@ti.com>
References: <1331905159-11255-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

This patch allows us to drop the OMAP depencendy
from the OMAP4 keypad driver.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c            |    1 +
 arch/arm/mach-omap2/devices.c                  |    1 +
 arch/arm/plat-omap/include/plat/omap4-keypad.h |    9 ---------
 drivers/input/keyboard/Kconfig                 |    1 -
 drivers/input/keyboard/omap4-keypad.c          |    2 +-
 include/linux/platform_data/omap4-keypad.h     |   13 +++++++++++++
 6 files changed, 16 insertions(+), 11 deletions(-)
 create mode 100644 include/linux/platform_data/omap4-keypad.h

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 4e90715..d16902c 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -25,6 +25,7 @@
 #include <linux/regulator/fixed.h>
 #include <linux/leds.h>
 #include <linux/leds_pwm.h>
+#include <linux/platform_data/omap4-keypad.h>
 
 #include <mach/hardware.h>
 #include <asm/hardware/gic.h>
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 283d11e..58e1d20 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/platform_data/omap4-keypad.h>
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/plat-omap/include/plat/omap4-keypad.h b/arch/arm/plat-omap/include/plat/omap4-keypad.h
index 9fe6c87..8ad0a37 100644
--- a/arch/arm/plat-omap/include/plat/omap4-keypad.h
+++ b/arch/arm/plat-omap/include/plat/omap4-keypad.h
@@ -1,15 +1,6 @@
 #ifndef ARCH_ARM_PLAT_OMAP4_KEYPAD_H
 #define ARCH_ARM_PLAT_OMAP4_KEYPAD_H
 
-#include <linux/input/matrix_keypad.h>
-
-struct omap4_keypad_platform_data {
-	const struct matrix_keymap_data *keymap_data;
-
-	u8 rows;
-	u8 cols;
-};
-
 extern int omap4_keyboard_init(struct omap4_keypad_platform_data *,
 				struct omap_board_data *);
 #endif
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index cdc385b..1379daa 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -512,7 +512,6 @@ config KEYBOARD_OMAP
 
 config KEYBOARD_OMAP4
 	tristate "TI OMAP4 keypad support"
-	depends on ARCH_OMAP4
 	help
 	  Say Y here if you want to use the OMAP4 keypad.
 
diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index d5c5d77..e809ac0 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -31,7 +31,7 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 
-#include <plat/omap4-keypad.h>
+#include <linux/platform_data/omap4-keypad.h>
 
 /* OMAP4 registers */
 #define OMAP4_KBD_REVISION		0x00
diff --git a/include/linux/platform_data/omap4-keypad.h b/include/linux/platform_data/omap4-keypad.h
new file mode 100644
index 0000000..4eef5fb
--- /dev/null
+++ b/include/linux/platform_data/omap4-keypad.h
@@ -0,0 +1,13 @@
+#ifndef __LINUX_INPUT_OMAP4_KEYPAD_H
+#define __LINUX_INPUT_OMAP4_KEYPAD_H
+
+#include <linux/input/matrix_keypad.h>
+
+struct omap4_keypad_platform_data {
+	const struct matrix_keymap_data *keymap_data;
+
+	u8 rows;
+	u8 cols;
+};
+
+#endif /* __LINUX_INPUT_OMAP4_KEYPAD_H */
-- 
1.7.1

