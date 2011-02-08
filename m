Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1BHCma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:42:30 -0500
Received: from smtp-out-214.synserver.de ([212.40.185.214]:1067 "EHLO
	smtp-out-214.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab1BHCm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:42:29 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 12918
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] MIPS: JZ4740: qi_lb60: Add gpio-charger device
Date: Tue,  8 Feb 2011 03:43:53 +0100
Message-Id: <1297133034-17586-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the gpio-charger device which reports whether device is currently
charging or not.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/board-qi_lb60.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index 3e33264..e3f21ba 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -23,6 +23,7 @@
 #include <linux/spi/spi_gpio.h>
 #include <linux/power_supply.h>
 #include <linux/power/jz4740-battery.h>
+#include <linux/power/gpio-charger.h>
 
 #include <asm/mach-jz4740/jz4740_fb.h>
 #include <asm/mach-jz4740/jz4740_mmc.h>
@@ -395,6 +396,28 @@ static struct platform_device qi_lb60_pwm_beeper = {
 	},
 };
 
+/* charger */
+static char *qi_lb60_batteries[] = {
+	"battery",
+};
+
+static struct gpio_charger_platform_data qi_lb60_charger_pdata = {
+	.name = "usb",
+	.type = POWER_SUPPLY_TYPE_USB,
+	.gpio = JZ_GPIO_PORTD(28),
+	.gpio_active_low = 1,
+	.supplied_to = qi_lb60_batteries,
+	.num_supplicants = ARRAY_SIZE(qi_lb60_batteries),
+};
+
+static struct platform_device qi_lb60_charger_device = {
+	.name = "gpio-charger",
+	.dev = {
+		.platform_data = &qi_lb60_charger_pdata,
+	},
+};
+
+
 static struct platform_device *jz_platform_devices[] __initdata = {
 	&jz4740_udc_device,
 	&jz4740_mmc_device,
@@ -409,6 +432,7 @@ static struct platform_device *jz_platform_devices[] __initdata = {
 	&jz4740_adc_device,
 	&qi_lb60_gpio_keys,
 	&qi_lb60_pwm_beeper,
+	&qi_lb60_charger_device,
 };
 
 static void __init board_gpio_setup(void)
-- 
1.7.2.3

