Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1IUJe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:34:26 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:37829 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1IUJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:34:12 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Jiri Slaby <jirislaby@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 36/57] drivers:misc:irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:37 +0800
Message-Id: <1316597339-29861-37-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
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
index fe8616a..c0688b03 100644
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
1.7.4.1

