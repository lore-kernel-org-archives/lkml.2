Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab2EKKlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:41:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab2EKKlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:41:03 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 11/25] Staging: comedi: fix printk issue in s626.c
Date: Fri, 11 May 2012 16:07:59 +0530
Message-Id: <1336732693-7408-12-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the s626.c file that fixes up a printk found
by the checkpatch.pl tool.

Used dev_<level> functions instead of printks wherver possible.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/s626.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index a0b7c71..aef9a3d 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -590,13 +590,13 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->pdev = pdev;
 
 	if (pdev == NULL) {
-		printk(KERN_ERR "s626_attach: Board not present!!!\n");
+		dev_err(dev->hw_dev, "Board not present!!!\n");
 		return -ENODEV;
 	}
 
 	result = comedi_pci_enable(pdev, "s626");
 	if (result < 0) {
-		printk(KERN_ERR "s626_attach: comedi_pci_enable fails\n");
+		dev_err(dev->hw_dev, "comedi_pci_enable fails\n");
 		return -ENODEV;
 	}
 	devpriv->got_regions = 1;
@@ -605,7 +605,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->base_addr = ioremap(resourceStart, SIZEOF_ADDRESS_SPACE);
 	if (devpriv->base_addr == NULL) {
-		printk(KERN_ERR "s626_attach: IOREMAP failed\n");
+		dev_err(dev->hw_dev, "IOREMAP failed\n");
 		return -ENODEV;
 	}
 
@@ -626,7 +626,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		    pci_alloc_consistent(devpriv->pdev, DMABUF_SIZE, &appdma);
 
 		if (devpriv->ANABuf.LogicalBase == NULL) {
-			printk(KERN_ERR "s626_attach: DMA Memory mapping error\n");
+			dev_err(dev->hw_dev, "DMA Memory mapping error\n");
 			return -ENOMEM;
 		}
 
@@ -643,7 +643,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		    pci_alloc_consistent(devpriv->pdev, DMABUF_SIZE, &appdma);
 
 		if (devpriv->RPSBuf.LogicalBase == NULL) {
-			printk(KERN_ERR "s626_attach: DMA Memory mapping error\n");
+			dev_err(dev->hw_dev, "DMA Memory mapping error\n");
 			return -ENOMEM;
 		}
 
@@ -669,13 +669,13 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* set up interrupt handler */
 	if (dev->irq == 0) {
-		printk(KERN_ERR " unknown irq (bad)\n");
+		dev_err(dev->hw_dev, "unknown irq (bad)\n");
 	} else {
 		ret = request_irq(dev->irq, s626_irq_handler, IRQF_SHARED,
 				  "s626", dev);
 
 		if (ret < 0) {
-			printk(KERN_ERR " irq not available\n");
+			dev_err(dev->hw_dev, "irq not available\n");
 			dev->irq = 0;
 		}
 	}
-- 
1.7.0.4

