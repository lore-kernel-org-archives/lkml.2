Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab1KHLRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:17:07 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37254 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab1KHLQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:16:54 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 15/20] Staging: comedi: fix printk issue in das800.c
Date: Tue,  8 Nov 2011 16:45:25 +0530
Message-Id: <1320750930-9764-15-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das800.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_version.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das800.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 96d41ad..ade55f1 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -466,42 +466,43 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long irq_flags;
 	int board;
 
-	printk("comedi%d: das800: io 0x%lx", dev->minor, iobase);
+	dev_info(dev->hw_dev, "comedi%d: das800: io 0x%lx\n", dev->minor,
+		 iobase);
 	if (irq)
-		printk(", irq %u", irq);
-	printk("\n");
+		dev_dbg(dev->hw_dev, "irq %u\n", irq);
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct das800_private)) < 0)
 		return -ENOMEM;
 
 	if (iobase == 0) {
-		printk("io base address required for das800\n");
+		dev_err(dev->hw_dev, "io base address required for das800\n");
 		return -EINVAL;
 	}
 
 	/* check if io addresses are available */
 	if (!request_region(iobase, DAS800_SIZE, "das800")) {
-		printk("I/O port conflict\n");
+		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
 
 	board = das800_probe(dev);
 	if (board < 0) {
-		printk("unable to determine board type\n");
+		dev_dbg(dev->hw_dev, "unable to determine board type\n");
 		return -ENODEV;
 	}
 	dev->board_ptr = das800_boards + board;
 
 	/* grab our IRQ */
 	if (irq == 1 || irq > 7) {
-		printk("irq out of range\n");
+		dev_err(dev->hw_dev, "irq out of range\n");
 		return -EINVAL;
 	}
 	if (irq) {
 		if (request_irq(irq, das800_interrupt, 0, "das800", dev)) {
-			printk("unable to allocate irq %u\n", irq);
+			dev_err(dev->hw_dev, "unable to allocate irq %u\n",
+				irq);
 			return -EINVAL;
 		}
 	}
@@ -557,7 +558,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int das800_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das800: remove\n", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: das800: remove\n", dev->minor);
 
 	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase)
-- 
1.7.0.4

