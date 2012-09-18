Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab2IRL12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:27:28 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:37294 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757323Ab2IRL11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:27:27 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <arm@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] ARM: ux500: tidy up pin sleep modes
Date: Tue, 18 Sep 2012 13:26:38 +0200
Message-ID: <1347967598-24691-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This named the sleep mode pin configurations as *slpm* rather
than *sleep* to correspond better with the settings from the
datasheet. It also defines an optional sleep mode for the SPI
controller SPI2.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Arnd, Olof: again a patch I'd like to take through the pinctrl
tree for simplicity.
---
 arch/arm/mach-ux500/board-mop500-pins.c | 48 ++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 32fd992..3a314b0 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -32,14 +32,14 @@ static enum custom_pin_cfg_t pinsfor;
 BIAS(pd, PIN_PULL_DOWN);
 BIAS(slpm_gpio_nopull, PIN_SLPM_GPIO|PIN_SLPM_INPUT_NOPULL);
 BIAS(in_nopull, PIN_INPUT_NOPULL);
-BIAS(in_nopull_sleep_nowkup, PIN_INPUT_NOPULL|PIN_SLPM_WAKEUP_DISABLE);
+BIAS(in_nopull_slpm_nowkup, PIN_INPUT_NOPULL|PIN_SLPM_WAKEUP_DISABLE);
 BIAS(in_pu, PIN_INPUT_PULLUP);
 BIAS(in_pd, PIN_INPUT_PULLDOWN);
 BIAS(in_pd_slpm_in_pu, PIN_INPUT_PULLDOWN|PIN_SLPM_INPUT_PULLUP);
 BIAS(in_pu_slpm_out_lo, PIN_INPUT_PULLUP|PIN_SLPM_OUTPUT_LOW);
 BIAS(out_hi, PIN_OUTPUT_HIGH);
 BIAS(out_lo, PIN_OUTPUT_LOW);
-BIAS(out_lo_sleep_nowkup, PIN_OUTPUT_LOW|PIN_SLPM_WAKEUP_DISABLE);
+BIAS(out_lo_slpm_nowkup, PIN_OUTPUT_LOW|PIN_SLPM_WAKEUP_DISABLE);
 /* These also force them into GPIO mode */
 BIAS(gpio_in_pu, PIN_INPUT_PULLUP|PIN_GPIOMODE_ENABLED);
 BIAS(gpio_in_pd, PIN_INPUT_PULLDOWN|PIN_GPIOMODE_ENABLED);
@@ -48,11 +48,13 @@ BIAS(gpio_in_pd_slpm_gpio_nopull, PIN_INPUT_PULLDOWN|PIN_GPIOMODE_ENABLED|PIN_SL
 BIAS(gpio_out_hi, PIN_OUTPUT_HIGH|PIN_GPIOMODE_ENABLED);
 BIAS(gpio_out_lo, PIN_OUTPUT_LOW|PIN_GPIOMODE_ENABLED);
 /* Sleep modes */
-BIAS(sleep_in_wkup_pdis, PIN_SLPM_DIR_INPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
-BIAS(sleep_in_nopull_wkup, PIN_INPUT_NOPULL|PIN_SLPM_WAKEUP_ENABLE);
-BIAS(sleep_out_hi_wkup_pdis, PIN_SLPM_OUTPUT_HIGH|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
-BIAS(sleep_out_lo_wkup, PIN_OUTPUT_LOW|PIN_SLPM_WAKEUP_ENABLE);
-BIAS(sleep_out_wkup_pdis, PIN_SLPM_DIR_OUTPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(slpm_in_wkup_pdis, PIN_SLEEPMODE_ENABLED|PIN_SLPM_DIR_INPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(slpm_in_nopull_wkup, PIN_SLEEPMODE_ENABLED|PIN_SLPM_DIR_INPUT|PIN_SLPM_PULL_NONE|PIN_SLPM_WAKEUP_ENABLE);
+BIAS(slpm_wkup_pdis, PIN_SLEEPMODE_ENABLED|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(slpm_out_hi_wkup_pdis, PIN_SLEEPMODE_ENABLED|PIN_SLPM_OUTPUT_HIGH|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(slpm_out_wkup_pdis, PIN_SLEEPMODE_ENABLED|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(slpm_out_lo_wkup, PIN_SLEEPMODE_ENABLED|PIN_SLPM_OUTPUT_LOW|PIN_SLPM_WAKEUP_ENABLE);
+BIAS(slpm_out_lo_wkup_pdis, PIN_SLEEPMODE_ENABLED|PIN_SLPM_OUTPUT_LOW|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
 
 /* We use these to define hog settings that are always done on boot */
 #define DB8500_MUX_HOG(group,func) \
@@ -65,6 +67,9 @@ BIAS(sleep_out_wkup_pdis, PIN_SLPM_DIR_OUTPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PD
 	PIN_MAP_MUX_GROUP_DEFAULT(dev, "pinctrl-db8500", group, func)
 #define DB8500_PIN(pin,conf,dev) \
 	PIN_MAP_CONFIGS_PIN_DEFAULT(dev, "pinctrl-db8500", pin, conf)
+#define DB8500_PIN_SLEEP(pin, conf, dev) \
+	PIN_MAP_CONFIGS_PIN(dev, PINCTRL_STATE_SLEEP, "pinctrl-db8500",	\
+			    pin, conf)
 
 #define DB8500_PIN_SLEEP(pin,conf,dev) \
 	PIN_MAP_CONFIGS_PIN(dev, PINCTRL_STATE_SLEEP, "pinctrl-db8500",	\
@@ -134,22 +139,22 @@ static struct pinctrl_map __initdata mop500_family_pinmap[] = {
 	DB8500_PIN("GPIO2_AH4", in_pu, "uart0"), /* RXD */
 	DB8500_PIN("GPIO3_AH3", out_hi, "uart0"), /* TXD */
 	/* UART0 sleep state */
-	DB8500_PIN_SLEEP("GPIO0_AJ5", sleep_in_wkup_pdis, "uart0"),
-	DB8500_PIN_SLEEP("GPIO1_AJ3", sleep_out_hi_wkup_pdis, "uart0"),
-	DB8500_PIN_SLEEP("GPIO2_AH4", sleep_in_wkup_pdis, "uart0"),
-	DB8500_PIN_SLEEP("GPIO3_AH3", sleep_out_wkup_pdis, "uart0"),
+	DB8500_PIN_SLEEP("GPIO0_AJ5", slpm_in_wkup_pdis, "uart0"),
+	DB8500_PIN_SLEEP("GPIO1_AJ3", slpm_out_hi_wkup_pdis, "uart0"),
+	DB8500_PIN_SLEEP("GPIO2_AH4", slpm_in_wkup_pdis, "uart0"),
+	DB8500_PIN_SLEEP("GPIO3_AH3", slpm_out_wkup_pdis, "uart0"),
 	/* MSP1 for ALSA codec */
 	DB8500_MUX("msp1txrx_a_1", "msp1", "ux500-msp-i2s.1"),
 	DB8500_MUX("msp1_a_1", "msp1", "ux500-msp-i2s.1"),
-	DB8500_PIN("GPIO33_AF2", out_lo_sleep_nowkup, "ux500-msp-i2s.1"),
-	DB8500_PIN("GPIO34_AE1", in_nopull_sleep_nowkup, "ux500-msp-i2s.1"),
-	DB8500_PIN("GPIO35_AE2", in_nopull_sleep_nowkup, "ux500-msp-i2s.1"),
-	DB8500_PIN("GPIO36_AG2", in_nopull_sleep_nowkup, "ux500-msp-i2s.1"),
+	DB8500_PIN("GPIO33_AF2", out_lo_slpm_nowkup, "ux500-msp-i2s.1"),
+	DB8500_PIN("GPIO34_AE1", in_nopull_slpm_nowkup, "ux500-msp-i2s.1"),
+	DB8500_PIN("GPIO35_AE2", in_nopull_slpm_nowkup, "ux500-msp-i2s.1"),
+	DB8500_PIN("GPIO36_AG2", in_nopull_slpm_nowkup, "ux500-msp-i2s.1"),
 	/* MSP1 sleep state */
-	DB8500_PIN_SLEEP("GPIO33_AF2", sleep_out_lo_wkup, "ux500-msp-i2s.1"),
-	DB8500_PIN_SLEEP("GPIO34_AE1", sleep_in_nopull_wkup, "ux500-msp-i2s.1"),
-	DB8500_PIN_SLEEP("GPIO35_AE2", sleep_in_nopull_wkup, "ux500-msp-i2s.1"),
-	DB8500_PIN_SLEEP("GPIO36_AG2", sleep_in_nopull_wkup, "ux500-msp-i2s.1"),
+	DB8500_PIN_SLEEP("GPIO33_AF2", slpm_out_lo_wkup, "ux500-msp-i2s.1"),
+	DB8500_PIN_SLEEP("GPIO34_AE1", slpm_in_nopull_wkup, "ux500-msp-i2s.1"),
+	DB8500_PIN_SLEEP("GPIO35_AE2", slpm_in_nopull_wkup, "ux500-msp-i2s.1"),
+	DB8500_PIN_SLEEP("GPIO36_AG2", slpm_in_nopull_wkup, "ux500-msp-i2s.1"),
 	/* Mux in LCD data lines 8 thru 11 and LCDA CLK for MCDE TVOUT */
 	DB8500_MUX("lcd_d8_d11_a_1", "lcd", "mcde-tvout"),
 	DB8500_MUX("lcdaclk_b_1", "lcda", "mcde-tvout"),
@@ -224,6 +229,11 @@ static struct pinctrl_map __initdata mop500_family_pinmap[] = {
 	DB8500_PIN("GPIO218_AH11", in_pd, "spi2"), /* RXD */
 	DB8500_PIN("GPIO215_AH13", out_lo, "spi2"), /* TXD */
 	DB8500_PIN("GPIO217_AH12", out_lo, "spi2"), /* CLK */
+	/* SPI2 sleep state */
+	DB8500_PIN_SLEEP("GPIO216_AG12", slpm_in_wkup_pdis, "spi2"), /* FRM */
+	DB8500_PIN_SLEEP("GPIO218_AH11", slpm_in_wkup_pdis, "spi2"), /* RXD */
+	DB8500_PIN_SLEEP("GPIO215_AH13", slpm_out_lo_wkup_pdis, "spi2"), /* TXD */
+	DB8500_PIN_SLEEP("GPIO217_AH12", slpm_wkup_pdis, "spi2"), /* CLK */
 };
 
 /*
-- 
1.7.11.3

