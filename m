Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2JEIZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:25:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46233 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab2JEIZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:25:01 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 25/28] leds-lp5521/5523: use new lp55xx common header
Thread-Topic: [PATCH 25/28] leds-lp5521/5523: use new lp55xx common header
Thread-Index: Ac2i0uAcAQpjTibvSeqUOvR2XCZMdg==
Date: Fri, 5 Oct 2012 08:24:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417685E@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The LP55xx common driver provides a new header, leds-lp55xx.h.
 This driver enables removing duplicate code for both drivers and
 making coherent driver structure.
 LP5521 and LP5523/55231 platform data were merged into one common file.
 Therefore, the LP5521/5523 platform code need to be fixed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    8 +--
 arch/arm/mach-ux500/board-mop500.c           |   14 ++---
 include/linux/leds-lp5521.h                  |   73 --------------------------
 include/linux/leds-lp5523.h                  |   49 -----------------
 4 files changed, 11 insertions(+), 133 deletions(-)
 delete mode 100644 include/linux/leds-lp5521.h
 delete mode 100644 include/linux/leds-lp5523.h

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index ed85fb8..9303225 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -42,7 +42,7 @@
 #include <sound/tpa6130a2-plat.h>
 #include <media/radio-si4713.h>
 #include <media/si4713.h>
-#include <linux/leds-lp5523.h>
+#include <linux/platform_data/leds-lp55xx.h>
 
 #include <../drivers/staging/iio/light/tsl2563.h>
 #include <linux/lis3lv02d.h>
@@ -159,7 +159,7 @@ static struct tsl2563_platform_data rx51_tsl2563_platform_data = {
 #endif
 
 #if defined(CONFIG_LEDS_LP5523) || defined(CONFIG_LEDS_LP5523_MODULE)
-static struct lp5523_led_config rx51_lp5523_led_config[] = {
+static struct lp55xx_led_config rx51_lp5523_led_config[] = {
 	{
 		.chan_nr	= 0,
 		.led_current	= 50,
@@ -206,10 +206,10 @@ static void rx51_lp5523_enable(bool state)
 	gpio_set_value(RX51_LP5523_CHIP_EN_GPIO, !!state);
 }
 
-static struct lp5523_platform_data rx51_lp5523_platform_data = {
+static struct lp55xx_platform_data rx51_lp5523_platform_data = {
 	.led_config		= rx51_lp5523_led_config,
 	.num_channels		= ARRAY_SIZE(rx51_lp5523_led_config),
-	.clock_mode		= LP5523_CLOCK_AUTO,
+	.clock_mode		= LP55XX_CLOCK_AUTO,
 	.setup_resources	= rx51_lp5523_setup,
 	.release_resources	= rx51_lp5523_release,
 	.enable			= rx51_lp5523_enable,
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 416d436..8fb4adf 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -28,7 +28,7 @@
 #include <linux/mfd/tps6105x.h>
 #include <linux/mfd/abx500/ab8500-gpio.h>
 #include <linux/mfd/abx500/ab8500-codec.h>
-#include <linux/leds-lp5521.h>
+#include <linux/platform_data/leds-lp55xx.h>
 #include <linux/input.h>
 #include <linux/smsc911x.h>
 #include <linux/gpio_keys.h>
@@ -262,7 +262,7 @@ static struct tc3589x_platform_data mop500_tc35892_data = {
 	.irq_base	= MOP500_EGPIO_IRQ_BASE,
 };
 
-static struct lp5521_led_config lp5521_pri_led[] = {
+static struct lp55xx_led_config lp5521_pri_led[] = {
        [0] = {
 	       .chan_nr = 0,
 	       .led_current = 0x2f,
@@ -280,14 +280,14 @@ static struct lp5521_led_config lp5521_pri_led[] = {
        },
 };
 
-static struct lp5521_platform_data __initdata lp5521_pri_data = {
+static struct lp55xx_platform_data __initdata lp5521_pri_data = {
        .label = "lp5521_pri",
        .led_config     = &lp5521_pri_led[0],
        .num_channels   = 3,
-       .clock_mode     = LP5521_CLOCK_EXT,
+       .clock_mode     = LP55XX_CLOCK_EXT,
 };
 
-static struct lp5521_led_config lp5521_sec_led[] = {
+static struct lp55xx_led_config lp5521_sec_led[] = {
        [0] = {
 	       .chan_nr = 0,
 	       .led_current = 0x2f,
@@ -305,11 +305,11 @@ static struct lp5521_led_config lp5521_sec_led[] = {
        },
 };
 
-static struct lp5521_platform_data __initdata lp5521_sec_data = {
+static struct lp55xx_platform_data __initdata lp5521_sec_data = {
        .label = "lp5521_sec",
        .led_config     = &lp5521_sec_led[0],
        .num_channels   = 3,
-       .clock_mode     = LP5521_CLOCK_EXT,
+       .clock_mode     = LP55XX_CLOCK_EXT,
 };
 
 static struct i2c_board_info __initdata mop500_i2c0_devices[] = {
diff --git a/include/linux/leds-lp5521.h b/include/linux/leds-lp5521.h
deleted file mode 100644
index 3f071ec..0000000
--- a/include/linux/leds-lp5521.h
+++ /dev/null
@@ -1,73 +0,0 @@
-/*
- * LP5521 LED chip driver.
- *
- * Copyright (C) 2010 Nokia Corporation
- *
- * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#ifndef __LINUX_LP5521_H
-#define __LINUX_LP5521_H
-
-/* See Documentation/leds/leds-lp5521.txt */
-
-struct lp5521_led_config {
-	char		*name;
-	u8		chan_nr;
-	u8		led_current; /* mA x10, 0 if led is not connected */
-	u8		max_current;
-};
-
-struct lp5521_led_pattern {
-	u8 *r;
-	u8 *g;
-	u8 *b;
-	u8 size_r;
-	u8 size_g;
-	u8 size_b;
-};
-
-#define LP5521_CLOCK_AUTO	0
-#define LP5521_CLOCK_INT	1
-#define LP5521_CLOCK_EXT	2
-
-/* Bits in CONFIG register */
-#define LP5521_PWM_HF			0x40	/* PWM: 0 = 256Hz, 1 = 558Hz */
-#define LP5521_PWRSAVE_EN		0x20	/* 1 = Power save mode */
-#define LP5521_CP_MODE_OFF		0	/* Charge pump (CP) off */
-#define LP5521_CP_MODE_BYPASS		8	/* CP forced to bypass mode */
-#define LP5521_CP_MODE_1X5		0x10	/* CP forced to 1.5x mode */
-#define LP5521_CP_MODE_AUTO		0x18	/* Automatic mode selection */
-#define LP5521_R_TO_BATT		4	/* R out: 0 = CP, 1 = Vbat */
-#define LP5521_CLK_SRC_EXT		0	/* Ext-clk source (CLK_32K) */
-#define LP5521_CLK_INT			1	/* Internal clock */
-#define LP5521_CLK_AUTO			2	/* Automatic clock selection */
-
-struct lp5521_platform_data {
-	struct lp5521_led_config *led_config;
-	u8	num_channels;
-	u8	clock_mode;
-	int	(*setup_resources)(void);
-	void	(*release_resources)(void);
-	void	(*enable)(bool state);
-	const char *label;
-	u8	update_config;
-	struct lp5521_led_pattern *patterns;
-	int num_patterns;
-};
-
-#endif /* __LINUX_LP5521_H */
diff --git a/include/linux/leds-lp5523.h b/include/linux/leds-lp5523.h
deleted file mode 100644
index 727877f..0000000
--- a/include/linux/leds-lp5523.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- * LP5523 LED Driver
- *
- * Copyright (C) 2010 Nokia Corporation
- *
- * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#ifndef __LINUX_LP5523_H
-#define __LINUX_LP5523_H
-
-/* See Documentation/leds/leds-lp5523.txt */
-
-struct lp5523_led_config {
-	const char	*name;
-	u8		chan_nr;
-	u8		led_current; /* mA x10, 0 if led is not connected */
-	u8		max_current;
-};
-
-#define LP5523_CLOCK_AUTO	0
-#define LP5523_CLOCK_INT	1
-#define LP5523_CLOCK_EXT	2
-
-struct lp5523_platform_data {
-	struct lp5523_led_config *led_config;
-	u8	num_channels;
-	u8	clock_mode;
-	int	(*setup_resources)(void);
-	void	(*release_resources)(void);
-	void	(*enable)(bool state);
-	const	char *label;
-};
-
-#endif /* __LINUX_LP5523_H */
-- 
1.7.9.5


Best Regards,
Milo


