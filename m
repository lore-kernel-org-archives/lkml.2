Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab2INKzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:55:00 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:56287 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946Ab2INKy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:54:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>, <arm@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] ARM: ux500: 8500: use hsit_a_2 group for HSI
Date: Fri, 14 Sep 2012 12:54:35 +0200
Message-ID: <1347620075-18022-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

Due to specific constraint, pin HSIT_ACWAKE0_a is
not driven by HSI block but as a GPIO.

Cc: arm@kernel.org
Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ARM SoC maintainers - I'll take this fixup through the pinctrl
tree if you don't mind.
---
 arch/arm/mach-ux500/board-mop500-pins.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 32fd992..f0affc3 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -410,7 +410,7 @@ static struct pinctrl_map __initdata u9500_pinmap[] = {
 	DB8500_PIN_HOG("GPIO144_B13", gpio_in_pu),
 	/* HSI */
 	DB8500_MUX_HOG("hsir_a_1", "hsi"),
-	DB8500_MUX_HOG("hsit_a_1", "hsi"),
+	DB8500_MUX_HOG("hsit_a_2", "hsi"),
 	DB8500_PIN_HOG("GPIO219_AG10", in_pd), /* RX FLA0 */
 	DB8500_PIN_HOG("GPIO220_AH10", in_pd), /* RX DAT0 */
 	DB8500_PIN_HOG("GPIO221_AJ11", out_lo), /* RX RDY0 */
@@ -418,7 +418,7 @@ static struct pinctrl_map __initdata u9500_pinmap[] = {
 	DB8500_PIN_HOG("GPIO223_AH9", out_lo), /* TX DAT0 */
 	DB8500_PIN_HOG("GPIO224_AG9", in_pd), /* TX RDY0 */
 	DB8500_PIN_HOG("GPIO225_AG8", in_pd), /* CAWAKE0 */
-	DB8500_PIN_HOG("GPIO226_AF8", out_hi), /* ACWAKE0 */
+	DB8500_PIN_HOG("GPIO226_AF8", gpio_out_hi), /* ACWAKE0 */
 };
 
 static struct pinctrl_map __initdata u8500_pinmap[] = {
-- 
1.7.11.3

