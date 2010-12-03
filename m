Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0LCPhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:37:20 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:47694 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697Ab0LCPhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:37:13 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 17/20] mach-ux500: add TC35893 keypad platform data
Date: Fri, 3 Dec 2010 20:35:50 +0530
Message-ID: <1291388753-14662-18-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-keypads.c |   63 ++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-keypads.c b/arch/arm/mach-ux500/board-mop500-keypads.c
index 4acc4f1..663f0c3 100644
--- a/arch/arm/mach-ux500/board-mop500-keypads.c
+++ b/arch/arm/mach-ux500/board-mop500-keypads.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/stmpe.h>
+#include <linux/mfd/tc3589x.h>
 #include <linux/input/matrix_keypad.h>
 
 #include <plat/pincfg.h>
@@ -157,10 +158,72 @@ static struct i2c_board_info __initdata mop500_i2c0_devices_stuib[] = {
 	},
 };
 
+/*
+ * TC35893
+ */
+
+static const unsigned int nuib_keymap[] = {
+	KEY(3, 1, KEY_END),
+	KEY(4, 1, KEY_POWER),
+	KEY(6, 4, KEY_VOLUMEDOWN),
+	KEY(4, 2, KEY_EMAIL),
+	KEY(3, 3, KEY_RIGHT),
+	KEY(2, 5, KEY_BACKSPACE),
+
+	KEY(6, 7, KEY_MENU),
+	KEY(5, 0, KEY_ENTER),
+	KEY(4, 3, KEY_0),
+	KEY(3, 4, KEY_DOT),
+	KEY(5, 2, KEY_UP),
+	KEY(3, 5, KEY_DOWN),
+
+	KEY(4, 5, KEY_SEND),
+	KEY(0, 5, KEY_BACK),
+	KEY(6, 2, KEY_VOLUMEUP),
+	KEY(1, 3, KEY_SPACE),
+	KEY(7, 6, KEY_LEFT),
+	KEY(5, 5, KEY_SEARCH),
+};
+
+static struct matrix_keymap_data nuib_keymap_data = {
+	.keymap         = nuib_keymap,
+	.keymap_size    = ARRAY_SIZE(nuib_keymap),
+};
+
+static struct tc3589x_keypad_platform_data tc35893_data = {
+	.krow = TC_KPD_ROWS,
+	.kcol = TC_KPD_COLUMNS,
+	.debounce_period = TC_KPD_DEBOUNCE_PERIOD,
+	.settle_time = TC_KPD_SETTLE_TIME,
+	.irqtype = IRQF_TRIGGER_FALLING,
+	.enable_wakeup = true,
+	.keymap_data    = &nuib_keymap_data,
+	.no_autorepeat  = true,
+};
+
+static struct tc3589x_platform_data tc3589x_keypad_data = {
+	.block = TC3589x_BLOCK_KEYPAD,
+	.keypad = &tc35893_data,
+	.irq_base = MOP500_EGPIO_IRQ_BASE,
+};
+
+static struct i2c_board_info __initdata mop500_i2c0_devices_nuib[] = {
+	{
+		I2C_BOARD_INFO("tc3589x", 0x44),
+		.platform_data = &tc3589x_keypad_data,
+		.irq = NOMADIK_GPIO_TO_IRQ(218),
+		.flags = I2C_CLIENT_WAKE,
+	},
+};
+
 void mop500_keypad_init(void)
 {
 	db8500_add_ske_keypad(&ske_keypad_board);
 
 	i2c_register_board_info(0, mop500_i2c0_devices_stuib,
 			ARRAY_SIZE(mop500_i2c0_devices_stuib));
+
+	i2c_register_board_info(0, mop500_i2c0_devices_nuib,
+			ARRAY_SIZE(mop500_i2c0_devices_nuib));
+
 }
-- 
1.7.2.dirty

