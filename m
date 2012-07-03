Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2GCJXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:23:34 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:55558 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191Ab2GCJXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:23:30 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3] pinctrl/nomadik: add pin group smcs1 and smps0
Date: Tue, 3 Jul 2012 11:23:04 +0200
Message-ID: <1341307384-28825-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

Add smcs1_b_1_pins as DB8500_PIN_B14 can be SM_CS1 in alt B
Add smps0_c_1_pins as DB8500_PIN_E8 can be SM_PS0 in alt C

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index 4f2a82c..9e7f379 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -509,9 +509,11 @@ static const unsigned sm_b_1_pins[] = { DB8500_PIN_C6, DB8500_PIN_B3,
 	DB8500_PIN_D9, DB8500_PIN_A5, DB8500_PIN_B4, DB8500_PIN_C8,
 	DB8500_PIN_A12, DB8500_PIN_C10, DB8500_PIN_B10, DB8500_PIN_B9,
 	DB8500_PIN_A9, DB8500_PIN_C7, DB8500_PIN_A7, DB8500_PIN_C5,
-	DB8500_PIN_C9, DB8500_PIN_B14 };
-/* This chip select pin can be "ps0" in alt B so have it separately */
+	DB8500_PIN_C9 };
+/* This chip select pin can be "ps0" in alt C so have it separately */
 static const unsigned smcs0_b_1_pins[] = { DB8500_PIN_E8 };
+/* This chip select pin can be "ps1" in alt C so have it separately */
+static const unsigned smcs1_b_1_pins[] = { DB8500_PIN_B14 };
 static const unsigned ipgpio7_b_1_pins[] = { DB8500_PIN_B11 };
 static const unsigned ipgpio2_b_1_pins[] = { DB8500_PIN_C12 };
 static const unsigned ipgpio3_b_1_pins[] = { DB8500_PIN_C11 };
@@ -573,6 +575,7 @@ static const unsigned mc2rstn_c_1_pins[] = { DB8500_PIN_C8 };
 static const unsigned kp_c_1_pins[] = { DB8500_PIN_C9, DB8500_PIN_B11,
 	DB8500_PIN_C12, DB8500_PIN_C11, DB8500_PIN_D17, DB8500_PIN_D16,
 	DB8500_PIN_C23, DB8500_PIN_D23 };
+static const unsigned smps0_c_1_pins[] = { DB8500_PIN_E8 };
 static const unsigned smps1_c_1_pins[] = { DB8500_PIN_B14 };
 static const unsigned u2rxtx_c_3_pins[] = { DB8500_PIN_B17, DB8500_PIN_C16 };
 static const unsigned stmape_c_2_pins[] = { DB8500_PIN_C19, DB8500_PIN_C17,
@@ -654,6 +657,7 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(kp_b_1, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(sm_b_1, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(smcs0_b_1, NMK_GPIO_ALT_B),
+	DB8500_PIN_GROUP(smcs1_b_1, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(ipgpio7_b_1, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(ipgpio2_b_1, NMK_GPIO_ALT_B),
 	DB8500_PIN_GROUP(ipgpio3_b_1, NMK_GPIO_ALT_B),
@@ -694,6 +698,7 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(mc5_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(mc2rstn_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(kp_c_1, NMK_GPIO_ALT_C),
+	DB8500_PIN_GROUP(smps0_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(smps1_c_1, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(u2rxtx_c_3, NMK_GPIO_ALT_C),
 	DB8500_PIN_GROUP(stmape_c_2, NMK_GPIO_ALT_C),
@@ -769,7 +774,8 @@ DB8500_FUNC_GROUPS(uartmod, "uartmodtx_b_1", "uartmodrx_b_1", "uartmodrx_b_2",
 DB8500_FUNC_GROUPS(stmmod, "stmmod_b_1", "stmmod_c_1");
 DB8500_FUNC_GROUPS(spi3, "spi3_b_1");
 /* Select between CS0 on alt B or PS1 on alt C */
-DB8500_FUNC_GROUPS(sm, "sm_b_1", "smcs0_b_1", "smcleale_c_1", "smps1_c_1");
+DB8500_FUNC_GROUPS(sm, "sm_b_1", "smcs0_b_1", "smcs1_b_1", "smcleale_c_1",
+		   "smps0_c_1", "smps1_c_1");
 DB8500_FUNC_GROUPS(lcda, "lcdaclk_b_1", "lcda_b_1");
 DB8500_FUNC_GROUPS(ddrtrig, "ddrtrig_b_1");
 DB8500_FUNC_GROUPS(pwl, "pwl_b_1", "pwl_b_2", "pwl_b_3", "pwl_b_4");
-- 
1.7.9.2

