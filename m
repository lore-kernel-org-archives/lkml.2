Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2D3R1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:27:24 -0400
Received: from d1.icnet.pl ([212.160.220.21]:43765 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372Ab2D3R1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:27:22 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 3.4-rc4] ARM: OMAP1: Amstrad Delta: Fix wrong IRQ base in FIQ handler
Date: Mon, 30 Apr 2012 19:26:09 +0200
Message-Id: <1335806769-23711-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 384ebe1c2849160d040df3e68634ec506f13d9ff, "gpio/omap: Add DT
support to GPIO driver", introduced dynamic IRQ numbering of OMAP GPIO
interrupts, breaking all IH_GPIO_BASE based IRQ number calculations.
This issue was corrected in the OMAP GPIO driver and the related header
file with commit 25db711df3258d125dc1209800317e5c0ef3c870, "gpio/omap:
Fix IRQ handling for SPARSE_IRQ".

However, the Amstrad Delta FIQ handler, which replaces the gpio-omap
driver in serving GPIO interrupts on this board, still uses that
outdated method. Fix it.

Created and tested against linux-3.4-rc4.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/ams-delta-fiq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/ams-delta-fiq.c b/arch/arm/mach-omap1/ams-delta-fiq.c
index fcce7ff..cfd98b1 100644
--- a/arch/arm/mach-omap1/ams-delta-fiq.c
+++ b/arch/arm/mach-omap1/ams-delta-fiq.c
@@ -48,7 +48,7 @@ static irqreturn_t deferred_fiq(int irq, void *dev_id)
 	struct irq_chip *irq_chip = NULL;
 	int gpio, irq_num, fiq_count;
 
-	irq_desc = irq_to_desc(IH_GPIO_BASE);
+	irq_desc = irq_to_desc(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
 	if (irq_desc)
 		irq_chip = irq_desc->irq_data.chip;
 
-- 
1.7.3.4

