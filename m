Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2HVIpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:45:49 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:39765 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325Ab2HVIoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:44:24 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Etienne Carriere <etienne.carriere@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/7] mfd/db8500-prcmu: MASK_ON_SUSPEND
Date: Wed, 22 Aug 2012 10:44:09 +0200
Message-ID: <1345625049-5714-1-git-send-email-linus.walleij@stericsson.com>
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
 drivers/mfd/db8500-prcmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 7040a00..25d2e9d 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2615,6 +2615,7 @@ static struct irq_chip prcmu_irq_chip = {
 	.irq_ack	= noop,
 	.irq_mask	= prcmu_irq_mask,
 	.irq_unmask	= prcmu_irq_unmask,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND,
 };
 
 static char *fw_project_name(u8 project)
-- 
1.7.11.3

