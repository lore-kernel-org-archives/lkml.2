Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab1ISOS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:18:57 -0400
Received: from smtp-out-050.synserver.de ([212.40.185.50]:1102 "HELO
	smtp-out-045.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750737Ab1ISOS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:18:56 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 26777
From: Lars-Peter Clausen <lars@metafoo.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] mfd: jz4740-adc: Fix generic irq chip ack function name.
Date: Mon, 19 Sep 2011 16:17:55 +0200
Message-Id: <1316441875-2161-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 659fb32d1b6("genirq: replace irq_gc_ack() with {set,clr}_bit
variants"), irq_gc_ack was renamed to irq_gc_ack_set_bit. The jz4740-adc
driver still uses the old name which results in a compile error.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
Samuel, it would be good if this fix could make it into 3.1
---
 drivers/mfd/jz4740-adc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 21131c7..563654c 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -273,7 +273,7 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 	ct->regs.ack = JZ_REG_ADC_STATUS;
 	ct->chip.irq_mask = irq_gc_mask_set_bit;
 	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
-	ct->chip.irq_ack = irq_gc_ack;
+	ct->chip.irq_ack = irq_gc_ack_set_bit;
 
 	irq_setup_generic_chip(gc, IRQ_MSK(5), 0, 0, IRQ_NOPROBE | IRQ_LEVEL);
 
-- 
1.7.2.5

