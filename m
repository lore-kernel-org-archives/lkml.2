Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422870Ab2KNOT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:19:56 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:37683 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422661Ab2KNOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:19:54 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinctrl/nomadik: db8540: split clkout group
Date: Wed, 14 Nov 2012 15:19:13 +0100
Message-ID: <1352902753-12961-1-git-send-email-linus.walleij@stericsson.com>
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
 drivers/pinctrl/pinctrl-nomadik-db8540.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8540.c b/drivers/pinctrl/pinctrl-nomadik-db8540.c
index bce0583..bb6a4016 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8540.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8540.c
@@ -460,8 +460,10 @@ static const unsigned hsit_a_1_pins[] = { DB8540_PIN_B11, DB8540_PIN_B10,
 	DB8540_PIN_E10, DB8540_PIN_B12, DB8540_PIN_D10 };
 static const unsigned hsit_a_2_pins[] = { DB8540_PIN_B11, DB8540_PIN_B10,
 	DB8540_PIN_E10, DB8540_PIN_B12 };
-static const unsigned clkout_a_1_pins[] = { DB8540_PIN_D11, DB8540_PIN_AJ6 };
-static const unsigned clkout_a_2_pins[] = { DB8540_PIN_B13, DB8540_PIN_C12 };
+static const unsigned clkout1_a_1_pins[] = { DB8540_PIN_D11 };
+static const unsigned clkout1_a_2_pins[] = { DB8540_PIN_B13 };
+static const unsigned clkout2_a_1_pins[] = { DB8540_PIN_AJ6 };
+static const unsigned clkout2_a_2_pins[] = { DB8540_PIN_C12 };
 static const unsigned msp4_a_1_pins[] = { DB8540_PIN_B14, DB8540_PIN_E11 };
 static const unsigned usb_a_1_pins[] = { DB8540_PIN_D12, DB8540_PIN_D15,
 	DB8540_PIN_C13, DB8540_PIN_C14, DB8540_PIN_C18, DB8540_PIN_C16,
@@ -698,8 +700,10 @@ static const struct nmk_pingroup nmk_db8540_groups[] = {
 	DB8540_PIN_GROUP(hsir_a_1, NMK_GPIO_ALT_A),
 	DB8540_PIN_GROUP(hsit_a_1, NMK_GPIO_ALT_A),
 	DB8540_PIN_GROUP(hsit_a_2, NMK_GPIO_ALT_A),
-	DB8540_PIN_GROUP(clkout_a_1, NMK_GPIO_ALT_A),
-	DB8540_PIN_GROUP(clkout_a_2, NMK_GPIO_ALT_A),
+	DB8540_PIN_GROUP(clkout1_a_1, NMK_GPIO_ALT_A),
+	DB8540_PIN_GROUP(clkout1_a_2, NMK_GPIO_ALT_A),
+	DB8540_PIN_GROUP(clkout2_a_1, NMK_GPIO_ALT_A),
+	DB8540_PIN_GROUP(clkout2_a_2, NMK_GPIO_ALT_A),
 	DB8540_PIN_GROUP(msp4_a_1, NMK_GPIO_ALT_A),
 	DB8540_PIN_GROUP(usb_a_1, NMK_GPIO_ALT_A),
 	/* Altfunction B column */
@@ -831,7 +835,8 @@ static const struct nmk_pingroup nmk_db8540_groups[] = {
 static const char * const a##_groups[] = { b };
 
 DB8540_FUNC_GROUPS(apetrig, "apetrig_b_1");
-DB8540_FUNC_GROUPS(clkout, "clkoutreq_a_1", "clkout_a_1", "clkout_a_2");
+DB8540_FUNC_GROUPS(clkout, "clkoutreq_a_1", "clkout1_a_1", "clkout1_a_2",
+		"clkout2_a_1", "clkout2_a_2");
 DB8540_FUNC_GROUPS(ddrtrig, "ddrtrig_b_1");
 DB8540_FUNC_GROUPS(hsi, "hsir_a_1", "hsit_a_1", "hsit_a_2");
 DB8540_FUNC_GROUPS(hwobs, "hwobs_oc4_1");
-- 
1.7.11.3

