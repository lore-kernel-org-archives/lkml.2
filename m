Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab2IRKKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:10:19 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:52414 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab2IRKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:10:17 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <arm@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] ARM: ux500: fix spi2 pin group
Date: Tue, 18 Sep 2012 12:09:46 +0200
Message-ID: <1347962986-12280-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

GPIO216_AG12 is configured as a gpio for SPI2, so select
the spi2_oc1_2 pin group instead of spi2_oc1_1

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Olof, Arnd:

Again I'd prefer to take this through the pinctrl tree if it's
OK with you. We are deploying pinctrl internally and ironing out
bugs as we test more and more use cases.
---
 arch/arm/mach-ux500/board-mop500-pins.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index f0affc3..a96b945 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -219,7 +219,7 @@ static struct pinctrl_map __initdata mop500_family_pinmap[] = {
 	DB8500_MUX("usb_a_1", "usb", "musb-ux500.0"),
 	DB8500_PIN("GPIO257_AE29", out_hi, "musb-ux500.0"), /* STP */
 	/* Mux in SPI2 pins on the "other C1" altfunction */
-	DB8500_MUX("spi2_oc1_1", "spi2", "spi2"),
+	DB8500_MUX("spi2_oc1_2", "spi2", "spi2"),
 	DB8500_PIN("GPIO216_AG12", gpio_out_hi, "spi2"), /* FRM */
 	DB8500_PIN("GPIO218_AH11", in_pd, "spi2"), /* RXD */
 	DB8500_PIN("GPIO215_AH13", out_lo, "spi2"), /* TXD */
-- 
1.7.11.3

