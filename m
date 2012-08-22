Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2HVIpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:45:42 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:43096 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab2HVIoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:44:30 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Etienne Carriere <etienne.carriere@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/7] mfd/ab8500: MASK_ON_SUSPEND
Date: Wed, 22 Aug 2012 10:43:56 +0200
Message-ID: <1345625036-5643-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Etienne Carriere <etienne.carriere@stericsson.com>

ux500 machines performs pins (GPIO) reconfiguration when entering
in the suspended mode. This reconfiguration aims at reaching an ultra
low power HW configuration.

Due to this HW reconfiguration, some HW devices can change of HW state
and have their output signals at level that could generate IRQs.

If the non-wakeup IRQs are disabled but not yet masked (delayed interrupt
disable feature from the generic irq layer), effective interrupts reach
the system only because the system attempt to enter the suspended mode.

To prevent such IRQs to trig, all irq chips embedded in ux500 platform
should enable their IRQCHIP_MASK_ON_SUSPEND flag.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Etienne Carriere <etienne.carriere@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 626b4ec..b25a0b0 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -386,6 +386,7 @@ static struct irq_chip ab8500_irq_chip = {
 	.irq_mask		= ab8500_irq_mask,
 	.irq_disable		= ab8500_irq_mask,
 	.irq_unmask		= ab8500_irq_unmask,
+	.flags			= IRQCHIP_MASK_ON_SUSPEND,
 };
 
 static int ab8500_handle_hierarchical_line(struct ab8500 *ab8500,
-- 
1.7.11.3

