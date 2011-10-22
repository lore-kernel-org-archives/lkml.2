Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1JVKMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:12:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32913 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab1JVKMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:12:40 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 33/49] drivers:misc:irq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:45 +0800
Message-Id: <1319277421-9203-34-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
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
---
 drivers/misc/arm-charlcd.c |    2 +-
 drivers/misc/phantom.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/arm-charlcd.c b/drivers/misc/arm-charlcd.c
index fe8616a..c0688b0 100644
--- a/drivers/misc/arm-charlcd.c
+++ b/drivers/misc/arm-charlcd.c
@@ -297,7 +297,7 @@ static int __init charlcd_probe(struct platform_device *pdev)
 	lcd->irq = platform_get_irq(pdev, 0);
 	/* If no IRQ is supplied, we'll survive without it */
 	if (lcd->irq >= 0) {
-		if (request_irq(lcd->irq, charlcd_interrupt, IRQF_DISABLED,
+		if (request_irq(lcd->irq, charlcd_interrupt, 0,
 				DRIVERNAME, lcd)) {
 			ret = -EIO;
 			goto out_no_irq;
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 21b28fc..7f7c521 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -395,7 +395,7 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
 	iowrite32(0, pht->caddr + PHN_IRQCTL);
 	ioread32(pht->caddr + PHN_IRQCTL); /* PCI posting */
 	retval = request_irq(pdev->irq, phantom_isr,
-			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
+			IRQF_SHARED, "phantom", pht);
 	if (retval) {
 		dev_err(&pdev->dev, "can't establish ISR\n");
 		goto err_unmo;
-- 
1.7.1

