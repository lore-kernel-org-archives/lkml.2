Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2GCJX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:23:29 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:42170 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150Ab2GCJX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:23:28 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] pinctrl/nomadik: add hsit_a_2 pin group
Date: Tue, 3 Jul 2012 11:23:10 +0200
Message-ID: <1341307390-28861-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

On 8500 and 9540, all HSI pins are driven by HSI block except
HSIT_ACWAKE0_a which is driven as GPIO due to specific
constraints. A new group hsit_a_2 is created which exclude
HSIT_ACWAKE0_a pin.

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index 9e7f379..42c4b77 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -471,6 +471,8 @@ static const unsigned hsir_a_1_pins[] = { DB8500_PIN_AG10, DB8500_PIN_AH10,
 	DB8500_PIN_AJ11 };
 static const unsigned hsit_a_1_pins[] = { DB8500_PIN_AJ9, DB8500_PIN_AH9,
 	DB8500_PIN_AG9, DB8500_PIN_AG8, DB8500_PIN_AF8 };
+static const unsigned hsit_a_2_pins[] = { DB8500_PIN_AJ9, DB8500_PIN_AH9,
+	DB8500_PIN_AG9, DB8500_PIN_AG8 };
 static const unsigned clkout_a_1_pins[] = { DB8500_PIN_AH7, DB8500_PIN_AJ6 };
 static const unsigned clkout_a_2_pins[] = { DB8500_PIN_AG7, DB8500_PIN_AF7 };
 static const unsigned usb_a_1_pins[] = { DB8500_PIN_AF28, DB8500_PIN_AE29,
@@ -635,6 +637,7 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(mc1_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(hsir_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(hsit_a_1, NMK_GPIO_ALT_A),
+	DB8500_PIN_GROUP(hsit_a_2, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(clkout_a_1, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(clkout_a_2, NMK_GPIO_ALT_A),
 	DB8500_PIN_GROUP(usb_a_1, NMK_GPIO_ALT_A),
@@ -758,7 +761,7 @@ DB8500_FUNC_GROUPS(ipgpio, "ipgpio0_a_1", "ipgpio1_a_1", "ipgpio7_b_1",
 DB8500_FUNC_GROUPS(msp2, "msp2sck_a_1", "msp2_a_1");
 DB8500_FUNC_GROUPS(mc4, "mc4_a_1", "mc4rstn_c_1");
 DB8500_FUNC_GROUPS(mc1, "mc1_a_1", "mc1dir_a_1");
-DB8500_FUNC_GROUPS(hsi, "hsir1_a_1", "hsit1_a_1");
+DB8500_FUNC_GROUPS(hsi, "hsir1_a_1", "hsit1_a_1", "hsit_a_2");
 DB8500_FUNC_GROUPS(clkout, "clkout_a_1", "clkout_a_2", "clkout_c_1");
 DB8500_FUNC_GROUPS(usb, "usb_a_1");
 DB8500_FUNC_GROUPS(trig, "trig_b_1");
-- 
1.7.9.2

