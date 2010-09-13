Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0IMDwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:52:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35778 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab0IMDwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:52:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kzNa3Ne3lSL6lgVCQokRtdkEeSD+Q8sKikqyTed8BAkcag7z+tyDB3MGSyBT8yOGKO
         VxX2xABGrZRyMFU+/pJ49BjyX/CYJqr65Yn7TfHjH7puu+jMVEAnBOYbZYkb+eWmSeB1
         kBSb25cHrh21gDUEX7+Nteb8nb4nBflJu+SnI=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: eric.y.miao@gmail.com, marek.vasut@gmail.com, haojian.zhuang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        markb@marvell.com
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 3/3] ARM: pxa168/teton bga: add board support for i2c and rtc-ds1337
Date: Sun, 12 Sep 2010 23:51:36 -0400
Message-Id: <1284349896-14545-4-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284349896-14545-1-git-send-email-mark.brown314@gmail.com>
References: <1284349896-14545-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defined I2C/ALARM pin definitions
DS1337 RTC alarm support is tied to RTC_INT_GPIO

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-mmp/teton_bga.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
index 2966117..d631bbc 100644
--- a/arch/arm/mach-mmp/teton_bga.c
+++ b/arch/arm/mach-mmp/teton_bga.c
@@ -18,6 +18,7 @@
 #include <linux/gpio.h>
 #include <linux/input.h>
 #include <plat/pxa27x_keypad.h>
+#include <linux/i2c.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -38,6 +39,13 @@ static unsigned long teton_bga_pin_config[] __initdata = {
 	GPIO110_KP_MKIN0,
 	GPIO111_KP_MKOUT7,
 	GPIO112_KP_MKOUT6,
+
+	/* I2C Bus */
+	GPIO105_CI2C_SDA,
+	GPIO106_CI2C_SCL,
+
+	/* RTC */
+	GPIO78_GPIO,
 };
 
 static unsigned int teton_bga_matrix_key_map[] = {
@@ -55,6 +63,13 @@ static struct pxa27x_keypad_platform_data teton_bga_keypad_info __initdata = {
 	.debounce_interval      = 30,
 };
 
+static struct i2c_board_info teton_bga_i2c_info[] __initdata = {
+	{
+		I2C_BOARD_INFO("ds1337", 0x68),
+		.irq = gpio_to_irq(RTC_INT_GPIO)
+	},
+};
+
 static void __init teton_bga_init(void)
 {
 	mfp_config(ARRAY_AND_SIZE(teton_bga_pin_config));
@@ -62,6 +77,7 @@ static void __init teton_bga_init(void)
 	/* on-chip devices */
 	pxa168_add_uart(1);
 	pxa168_add_keypad(&teton_bga_keypad_info);
+	pxa168_add_twsi(0, NULL, ARRAY_AND_SIZE(teton_bga_i2c_info));
 }
 
 MACHINE_START(TETON_BGA, "PXA168-based Teton BGA Development Platform")
-- 
1.7.0.4

