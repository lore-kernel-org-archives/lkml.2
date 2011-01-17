Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1AQOMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:12:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1AQOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:12:26 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>
Subject: [PATCHv2 1/2] OMAP3: Devkit8000: Change lcd power pin
Date: Mon, 17 Jan 2011 15:11:58 +0100
Message-Id: <1295273519-6189-2-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295273519-6189-1-git-send-email-weber@corscience.de>
References: <1295273519-6189-1-git-send-email-weber@corscience.de>
X-Provags-ID: V02:K0:IbfSe2p99Im6CrNiTgaGJki5Sn7fqWNtQcZSetyaVK/
 ABN9C5bGlKhJPnP3/dOAzrMWEp4WoZkK5LPuPNBdKIvlPukWMX
 y+0rIzetJz3XbfFCbTTNwFvoQ6nWaZLJ+LWhvRcg8axvy9zRHm
 V/KEVNAXPrb59B3q34PdBCjcGZ6zEAqUJHYXC9qRSdhVc12BUu
 SEYQKwLeq4c9RMb2o4iPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset_gpio pin for lcd is connected with TWL4030 LedA.
TWL4030 GPIO.1 has a not connected resistor.

Fix indention issue. The comment line uses 8 whitespaces. 
Replaced with one tabulator.

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

