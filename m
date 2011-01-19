Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1ASITh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:19:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1ASITf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:19:35 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>, charu@ti.com,
        sshtylyov@mvista.com
Subject: [PATCHv4 1/4] OMAP3: Devkit8000: Change lcd power pin
Date: Wed, 19 Jan 2011 09:19:23 +0100
Message-Id: <1295425166-25540-2-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295425166-25540-1-git-send-email-weber@corscience.de>
References: <1295425166-25540-1-git-send-email-weber@corscience.de>
X-Provags-ID: V02:K0:Zv2CNPKFp9jT5+euPJessg2V4My8xl5kw+rlK7xh36J
 OF6km1ZtUrqy40SnnEu5RsabI/HB/7cb+63FzDDQVSbqg+oAdC
 lzQs47ybk0JloBr9KzLdfZd6g+umN+ca4sGcSra9eNY3HpLNV8
 zdi7eXM6rMN+7AcZN8bz6TCifnoN1H5CtGhK3yOCAlVe/iQ5Ni
 tOvVCvpNJQhvv94dhXlMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a wrongly used lcd enable pin.

The Devkit8000 uses twl4030_ledA configured as output gpio only for the
lcd enable line. twl4030_gpio.1 is used through the generic gpio functions
while ledA is used via low level twl4030 calls.

Remove the low level calls and use the generic gpio functions for
initialization and use of ledA.

This also fixes a bug where the lcd would not power down when blanking.

Fix indentation issue. The comment line uses 8 whitespace.
This is replaced with one tabulator.

Reported-by: Daniel Morsing <daniel.morsing@gmail.com>
Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 451e7ff..719f4e5 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -114,9 +114,6 @@ static struct omap2_hsmmc_info mmc[] = {
 
 static int devkit8000_panel_enable_lcd(struct omap_dss_device *dssdev)
 {
-	twl_i2c_write_u8(TWL4030_MODULE_GPIO, 0x80, REG_GPIODATADIR1);
-	twl_i2c_write_u8(TWL4030_MODULE_LED, 0x0, 0x0);
-
 	if (gpio_is_valid(dssdev->reset_gpio))
 		gpio_set_value_cansleep(dssdev->reset_gpio, 1);
 	return 0;
@@ -245,8 +242,8 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
 	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
 	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
 
-        /* gpio + 1 is "LCD_PWREN" (out, active high) */
-	devkit8000_lcd_device.reset_gpio = gpio + 1;
+	/* TWL4030_GPIO_MAX + 0 is "LCD_PWREN" (out, active high) */
+	devkit8000_lcd_device.reset_gpio = gpio + TWL4030_GPIO_MAX + 0;
 	gpio_request(devkit8000_lcd_device.reset_gpio, "LCD_PWREN");
 	/* Disable until needed */
 	gpio_direction_output(devkit8000_lcd_device.reset_gpio, 0);
-- 
1.7.4.rc2

