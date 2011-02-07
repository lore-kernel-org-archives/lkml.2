Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1BGBwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 20:52:09 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1077 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754208Ab1BGBuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 20:50:37 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23313
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 03/09] ARM: s3c2440: gta02: Add button support
Date: Mon,  7 Feb 2011 02:51:55 +0100
Message-Id: <1297043521-21903-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297043521-21903-1-git-send-email-lars@metafoo.de>
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the two buttons found on the gta02 device, which are
connectd to gpio pins, using the gpio-keys driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/arm/mach-s3c2440/mach-gta02.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index e83062b..6629998 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -58,6 +58,9 @@
 #include <linux/mfd/pcf50633/pmic.h>
 #include <linux/mfd/pcf50633/backlight.h>
 
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
@@ -489,6 +492,36 @@ static struct s3c2410_hcd_info gta02_usb_info __initdata = {
 	},
 };
 
+/* Buttons */
+static struct gpio_keys_button gta02_buttons[] = {
+	{
+		.gpio = GTA02_GPIO_AUX_KEY,
+		.code = KEY_PHONE,
+		.desc = "Aux",
+		.type = EV_KEY,
+		.debounce_interval = 100,
+	},
+	{
+		.gpio = GTA02_GPIO_HOLD_KEY,
+		.code = KEY_PAUSE,
+		.desc = "Hold",
+		.type = EV_KEY,
+		.debounce_interval = 100,
+	},
+};
+
+static struct gpio_keys_platform_data gta02_buttons_pdata = {
+	.buttons = gta02_buttons,
+	.nbuttons = ARRAY_SIZE(gta02_buttons),
+};
+
+static struct platform_device gta02_buttons_device = {
+	.name = "gpio-keys",
+	.id = -1,
+	.dev = {
+		.platform_data = &gta02_buttons_pdata,
+	},
+};
 
 static void __init gta02_map_io(void)
 {
@@ -511,6 +544,7 @@ static struct platform_device *gta02_devices[] __initdata = {
 	&s3c_device_iis,
 	&samsung_asoc_dma,
 	&s3c_device_i2c0,
+	&gta02_buttons_device,
 };
 
 /* These guys DO need to be children of PMU. */
-- 
1.7.2.3

