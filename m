Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1IVJDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:03:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43591 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab1IVJD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:03:26 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 25/55] ata: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:58:52 +0800
Message-Id: <1316681962-8217-26-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/ata/pata_mpc52xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 2fcac51..3e17463 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -780,7 +780,7 @@ mpc52xx_ata_probe(struct platform_device *op)
 	}
 
 	task_irq = bcom_get_task_irq(dmatsk);
-	ret = request_irq(task_irq, &mpc52xx_ata_task_irq, IRQF_DISABLED,
+	ret = request_irq(task_irq, &mpc52xx_ata_task_irq, 0,
 				"ATA task", priv);
 	if (ret) {
 		dev_err(&op->dev, "error requesting DMA IRQ\n");
-- 
1.7.4.1

