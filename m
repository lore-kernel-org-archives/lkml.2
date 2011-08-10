Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1HJKcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:32:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57212 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1HJKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:32:20 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/2] Staging: comedi: fix printk() issue in das1800.c
Date: Wed, 10 Aug 2011 16:02:04 +0530
Message-Id: <1312972324-3851-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: comedi:fix printk() issue in das1800.c>
References: <[PATCH]Staging: comedi:fix printk() issue in das1800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das1800.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das1800.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index a6df30b..c4fcd17 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -631,8 +631,8 @@ static int das1800_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct das1800_private)) < 0)
 		return -ENOMEM;
 
-	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_das1800.driver_name,
-	       iobase);
+	printk(KERN_WARNING "comedi%d: %s: io 0x%lx",
+			dev->minor, driver_das1800.driver_name, iobase);
 	if (irq) {
 		printk(", irq %u", irq);
 		if (dma0) {
@@ -644,22 +644,22 @@ static int das1800_attach(struct comedi_device *dev,
 	printk("\n");
 
 	if (iobase == 0) {
-		printk(" io base address required\n");
+		printk(KERN_CONT " io base address required\n");
 		return -EINVAL;
 	}
 
 	/* check if io addresses are available */
 	if (!request_region(iobase, DAS1800_SIZE, driver_das1800.driver_name)) {
-		printk
-		    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
-		     iobase, iobase + DAS1800_SIZE - 1);
+		printk(KERN_CONT " I/O port conflict:"
+				" failed to allocate ports 0x%lx to 0x%lx\n",
+				iobase, iobase + DAS1800_SIZE - 1);
 		return -EIO;
 	}
 	dev->iobase = iobase;
 
 	board = das1800_probe(dev);
 	if (board < 0) {
-		printk(" unable to determine board type\n");
+		printk(KERN_CONT " unable to determine board type\n");
 		return -ENODEV;
 	}
 
@@ -671,9 +671,9 @@ static int das1800_attach(struct comedi_device *dev,
 		iobase2 = iobase + IOBASE2;
 		if (!request_region(iobase2, DAS1800_SIZE,
 				    driver_das1800.driver_name)) {
-			printk
-			    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
-			     iobase2, iobase2 + DAS1800_SIZE - 1);
+			printk(KERN_CONT " I/O port conflict:"
+					" failed to allocate ports 0x%lx to 0x%lx\n",
+					iobase2, iobase2 + DAS1800_SIZE - 1);
 			return -EIO;
 		}
 		devpriv->iobase2 = iobase2;
@@ -683,7 +683,7 @@ static int das1800_attach(struct comedi_device *dev,
 	if (irq) {
 		if (request_irq(irq, das1800_interrupt, 0,
 				driver_das1800.driver_name, dev)) {
-			printk(" unable to allocate irq %u\n", irq);
+			printk(KERN_CONT " unable to allocate irq %u\n", irq);
 			return -EINVAL;
 		}
 	}
@@ -712,7 +712,7 @@ static int das1800_attach(struct comedi_device *dev,
 		devpriv->irq_dma_bits |= 0x38;
 		break;
 	default:
-		printk(" irq out of range\n");
+		printk(KERN_CONT " irq out of range\n");
 		return -EINVAL;
 		break;
 	}
-- 
1.6.5.2

