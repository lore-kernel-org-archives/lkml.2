Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1LHMyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:54:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1LHMyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:49 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 23/30] Staging: comedi: fix brace coding style issue in ni_at_a2150.c
Date: Thu,  8 Dec 2011 18:22:18 +0530
Message-Id: <1323348745-31477-23-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_at_a2150.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Converted printks to pr_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |   27 +++++++++++++------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index f5f21c6..90c8015 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -347,30 +347,30 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	static const int timeout = 2000;
 	int i;
 
-	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_a2150.driver_name,
-	       iobase);
+	pr_debug("comedi%d: %s: io 0x%lx\n", dev->minor,
+		 driver_a2150.driver_name, iobase);
 	if (irq)
-		printk(", irq %u", irq);
+		pr_debug("irq %u\n", irq);
 	else
-		printk(", no irq");
+		pr_debug("no irq\n");
 
 	if (dma)
-		printk(", dma %u", dma);
+		pr_debug("dma %u\n", dma);
 	else
-		printk(", no dma");
+		pr_debug("no dma\n");
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct a2150_private)) < 0)
 		return -ENOMEM;
 
 	if (iobase == 0) {
-		printk(" io base address required\n");
+		pr_err("io base address required\n");
 		return -EINVAL;
 	}
 
 	/* check if io addresses are available */
 	if (!request_region(iobase, A2150_SIZE, driver_a2150.driver_name)) {
-		printk(" I/O port conflict\n");
+		pr_err("I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -379,12 +379,12 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (irq) {
 		/*  check that irq is supported */
 		if (irq < 3 || irq == 8 || irq == 13 || irq > 15) {
-			printk(" invalid irq line %u\n", irq);
+			pr_err("invalid irq line %u\n", irq);
 			return -EINVAL;
 		}
 		if (request_irq(irq, a2150_interrupt, 0,
 				driver_a2150.driver_name, dev)) {
-			printk("unable to allocate irq %u\n", irq);
+			pr_err("unable to allocate irq %u\n", irq);
 			return -EINVAL;
 		}
 		devpriv->irq_dma_bits |= IRQ_LVL_BITS(irq);
@@ -393,11 +393,11 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  initialize dma */
 	if (dma) {
 		if (dma == 4 || dma > 7) {
-			printk(" invalid dma channel %u\n", dma);
+			pr_err("invalid dma channel %u\n", dma);
 			return -EINVAL;
 		}
 		if (request_dma(dma, driver_a2150.driver_name)) {
-			printk(" failed to allocate dma channel %u\n", dma);
+			pr_err("failed to allocate dma channel %u\n", dma);
 			return -EINVAL;
 		}
 		devpriv->dma = dma;
@@ -464,7 +464,8 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int a2150_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: %s: remove\n", dev->minor, driver_a2150.driver_name);
+	pr_debug("comedi%d: %s: remove\n", dev->minor,
+		 driver_a2150.driver_name);
 
 	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase) {
-- 
1.7.0.4

