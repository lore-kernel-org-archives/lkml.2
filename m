Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab2HVIq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:46:56 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:42116 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756963Ab2HVIpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:45:52 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Etienne Carriere <etienne.carriere@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/7] pinctrl/nomdik: MASK_ON_SUSPEND
Date: Wed, 22 Aug 2012 10:44:16 +0200
Message-ID: <1345625056-5749-1-git-send-email-linus.walleij@stericsson.com>
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

Signed-off-by: Etienne Carriere <etienne.carriere@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index ec6ac50..41f1a3d 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -819,6 +819,7 @@ static struct irq_chip nmk_gpio_irq_chip = {
 	.irq_set_wake	= nmk_gpio_irq_set_wake,
 	.irq_startup	= nmk_gpio_irq_startup,
 	.irq_shutdown	= nmk_gpio_irq_shutdown,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND,
 };
 
 static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
-- 
1.7.11.3

