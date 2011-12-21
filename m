Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1LUAUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:20:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50464 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786Ab1LUAUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:20:43 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] gpio: Add decode of WM8994 GPIO configuration
Date: Wed, 21 Dec 2011 00:20:17 +0000
Message-Id: <1324426817-2196-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324426817-2196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1324426817-2196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the human reader.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-wm8994.c |   79 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-wm8994.c b/drivers/gpio/gpio-wm8994.c
index 96198f3..92ea535 100644
--- a/drivers/gpio/gpio-wm8994.c
+++ b/drivers/gpio/gpio-wm8994.c
@@ -117,6 +117,60 @@ static int wm8994_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 
 
 #ifdef CONFIG_DEBUG_FS
+static const char *wm8994_gpio_fn(u16 fn)
+{
+	switch (fn) {
+	case WM8994_GP_FN_PIN_SPECIFIC:
+		return "pin-specific";
+	case WM8994_GP_FN_GPIO:
+		return "GPIO";
+	case WM8994_GP_FN_SDOUT:
+		return "SDOUT";
+	case WM8994_GP_FN_IRQ:
+		return "IRQ";
+	case WM8994_GP_FN_TEMPERATURE:
+		return "Temperature";
+	case WM8994_GP_FN_MICBIAS1_DET:
+		return "MICBIAS1 detect";
+	case WM8994_GP_FN_MICBIAS1_SHORT:
+		return "MICBIAS1 short";
+	case WM8994_GP_FN_MICBIAS2_DET:
+		return "MICBIAS2 detect";
+	case WM8994_GP_FN_MICBIAS2_SHORT:
+		return "MICBIAS2 short";
+	case WM8994_GP_FN_FLL1_LOCK:
+		return "FLL1 lock";
+	case WM8994_GP_FN_FLL2_LOCK:
+		return "FLL2 lock";
+	case WM8994_GP_FN_SRC1_LOCK:
+		return "SRC1 lock";
+	case WM8994_GP_FN_SRC2_LOCK:
+		return "SRC2 lock";
+	case WM8994_GP_FN_DRC1_ACT:
+		return "DRC1 activity";
+	case WM8994_GP_FN_DRC2_ACT:
+		return "DRC2 activity";
+	case WM8994_GP_FN_DRC3_ACT:
+		return "DRC3 activity";
+	case WM8994_GP_FN_WSEQ_STATUS:
+		return "Write sequencer";
+	case WM8994_GP_FN_FIFO_ERROR:
+		return "FIFO error";
+	case WM8994_GP_FN_OPCLK:
+		return "OPCLK";
+	case WM8994_GP_FN_THW:
+		return "Thermal warning";
+	case WM8994_GP_FN_DCS_DONE:
+		return "DC servo";
+	case WM8994_GP_FN_FLL1_OUT:
+		return "FLL1 output";
+	case WM8994_GP_FN_FLL2_OUT:
+		return "FLL1 output";
+	default:
+		return "Unknown";
+	}
+}
+
 static void wm8994_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	struct wm8994_gpio *wm8994_gpio = to_wm8994_gpio(chip);
@@ -148,8 +202,29 @@ static void wm8994_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			continue;
 		}
 
-		/* No decode yet; note that GPIO2 is special */
-		seq_printf(s, "(%x)\n", reg);
+		if (reg & WM8994_GPN_DIR)
+			seq_printf(s, "in ");
+		else
+			seq_printf(s, "out ");
+
+		if (reg & WM8994_GPN_PU)
+			seq_printf(s, "pull up ");
+
+		if (reg & WM8994_GPN_PD)
+			seq_printf(s, "pull down ");
+
+		if (reg & WM8994_GPN_POL)
+			seq_printf(s, "inverted ");
+		else
+			seq_printf(s, "noninverted ");
+
+		if (reg & WM8994_GPN_OP_CFG)
+			seq_printf(s, "open drain ");
+		else
+			seq_printf(s, "CMOS ");
+
+		seq_printf(s, "%s (%x)\n",
+			   wm8994_gpio_fn(reg & WM8994_GPN_FN_MASK), reg);
 	}
 }
 #else
-- 
1.7.7.3

