Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab2KNOTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:19:35 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:44195 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932723Ab2KNOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:19:34 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] pinctrl/nomadik: db8500: split clkout group
Date: Wed, 14 Nov 2012 15:19:06 +0100
Message-ID: <1352902746-12925-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

The clkout group is split into groups clkout1 and clkout2
which allows pins cklkout1 and clkout2 to be muxed
separately.

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index 6de52e7..7d88ae3 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -475,8 +475,10 @@ static const unsigned hsit_a_1_pins[] = { DB8500_PIN_AJ9, DB8500_PIN_AH9,
 	DB8500_PIN_AG9, DB8500_PIN_AG8, DB8500_PIN_AF8 };
 static const unsigned hsit_a_2_pins[] = { DB8500_PIN_AJ9, DB8500_PIN_AH9,
 	DB8500_PIN_AG9, DB8500_PIN_AG8 };
-static const unsigned clkout_a_1_pins[] = { DB8500_PIN_AH7, DB8500_PIN_AJ6 };
-static const unsigned clkout_a_2_pins[] = { DB8500_PIN_AG7, DB8500_PIN_AF7 };
+static const unsigned clkout1_a_1_pins[] = { DB8500_PIN_AH7 };
+static const unsigned clkout1_a_2_pins[] = { DB8500_PIN_AG7 };
+static const unsigned clkout2_a_1_pins[] = { DB8500_PIN_AJ6 };
+static const unsigned clkout2_a_2_pins[] = { DB8500_PIN_AF7 };
 static const unsigned usb_a_1_pins[] = { DB8500_PIN_AF28, DB8500_PIN_AE29,
 	DB8500_PIN_AD29, DB8500_PIN_AC29, DB8500_PIN_AD28, DB8500_PIN_AD26,
 	DB8500_PIN_AE26, DB8500_PIN_AG29, DB8500_PIN_AE27, DB8500_PIN_AD27,
@@ -592,7 +594,8 @@ static const unsigned stmmod_c_1_pins[] = { DB8500_PIN_C20, DB8500_PIN_B21,
 	DB8500_PIN_C21, DB8500_PIN_A22, DB8500_PIN_B24 };
 static const unsigned usbsim_c_1_pins[] = { DB8500_PIN_D22 };
 static const unsigned mc4rstn_c_1_pins[] = { DB8500_PIN_AF25 };
-static const unsigned clkout_c_1_pins[] = { DB8500_PIN_AH13, DB8500_PIN_AH12 };
+static const unsigned clkout1_c_1_pins[] = { DB8500_PIN_AH13 };
+static const unsigned clkout2_c_1_pins[] = { DB8500_PIN_AH12 };
 static const unsigned i2c3_c_1_pins[] = { DB8500_PIN_AG12, DB8500_PIN_AH11 };
 static const unsigned spi0_c_1_pins[] = { DB8500_PIN_AH10, DB8500_PIN_AH9,
 					  DB8500_PIN_AG9, DB8500_PIN_AG8 };
@@ -700,8 +703,10 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(hsir_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(hsit_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(hsit_a_2, NMK_GPIO_ALT_A),
-	DB8500_PIN_GROUP(clkout_a_1, NMK_GPIO_ALT_A),
-	DB8500_PIN_GROUP(clkout_a_2, NMK_GPIO_ALT_A),
+	DB8500_PIN_GROUP(clkout1_a_1, NMK_GPIO_ALT_A),
+	DB8500_PIN_GROUP(clkout1_a_2, NMK_GPIO_ALT_A),
+	DB8500_PIN_GROUP(clkout2_a_1, NMK_GPIO_ALT_A),
+	DB8500_PIN_GROUP(clkout2_a_2, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(usb_a_1, NMK_GPIO_ALT_A),
 	/* Altfunction B column */
 	DB8500_PIN_GROUP(trig_b_1, NMK_GPIO_ALT_B),
@@ -773,7 +778,8 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(stmmod_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(usbsim_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(mc4rstn_c_1, NMK_GPIO_ALT_C),
-	DB8500_PIN_GROUP(clkout_c_1, NMK_GPIO_ALT_C),
+	DB8500_PIN_GROUP(clkout1_c_1, NMK_GPIO_ALT_C),
+	DB8500_PIN_GROUP(clkout2_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(i2c3_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(spi0_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(usbsim_c_2, NMK_GPIO_ALT_C),
@@ -851,7 +857,8 @@ DB8500_FUNC_GROUPS(msp2, "msp2sck_a_1", "msp2_a_1");
 DB8500_FUNC_GROUPS(mc4, "mc4_a_1", "mc4rstn_c_1");
 DB8500_FUNC_GROUPS(mc1, "mc1_a_1", "mc1_a_2", "mc1dir_a_1");
 DB8500_FUNC_GROUPS(hsi, "hsir_a_1", "hsit_a_1", "hsit_a_2");
-DB8500_FUNC_GROUPS(clkout, "clkout_a_1", "clkout_a_2", "clkout_c_1");
+DB8500_FUNC_GROUPS(clkout, "clkout1_a_1", "clkout1_a_2", "clkout1_c_1",
+		"clkout2_a_1", "clkout2_a_2", "clkout2_c_1");
 DB8500_FUNC_GROUPS(usb, "usb_a_1");
 DB8500_FUNC_GROUPS(trig, "trig_b_1");
 DB8500_FUNC_GROUPS(i2c4, "i2c4_b_1");
-- 
1.7.11.3

