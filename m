Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1H2OOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:14:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58119 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1H2OOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:14:08 -0400
From: Ravishankarkm <ravi.shankar@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankarkm <ravi.shankar@greenturtles.in>
Subject: [PATCH 1/3] Staging: comedi: fix printk issue in das1800.c
Date: Mon, 29 Aug 2011 19:43:46 +0530
Message-Id: <1314627226-14196-1-git-send-email-ravi.shankar@greenturtles.in>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi:fix printk warning issue in das1800.c>
References: <[PATCH]Staging: comedi:fix printk warning issue in das1800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankarkm <ravi.shankar@greenturtles.in>

This is a patch to the das1800.c file that fixes up a pritnk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankarkm <ravi.shankar@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |   41 +++++++++++++++--------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index a6df30b..222232c 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -631,37 +631,36 @@ static int das1800_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct das1800_private)) < 0)
 		return -ENOMEM;
 
-	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_das1800.driver_name,
-	       iobase);
+	pr_info("comedi%d: %s: io 0x%lx", dev->minor, driver_das1800.driver_name,
+			iobase);
 	if (irq) {
-		printk(", irq %u", irq);
+		pr_cont(", irq %u", irq);
 		if (dma0) {
-			printk(", dma %u", dma0);
+			pr_cont(", dma %u", dma0);
 			if (dma1)
-				printk(" and %u", dma1);
+				pr_cont(" and %u", dma1);
 		}
 	}
-	printk("\n");
+	pr_cont("\n");
 
 	if (iobase == 0) {
-		printk(" io base address required\n");
+		pr_warn("comedi%d: %s: io base address required\n",
+				dev->minor, driver_das1800.driver_name);
 		return -EINVAL;
 	}
 
 	/* check if io addresses are available */
 	if (!request_region(iobase, DAS1800_SIZE, driver_das1800.driver_name)) {
-		printk
-		    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
-		     iobase, iobase + DAS1800_SIZE - 1);
+		pr_err("comedi%d: I/O port conflict:failed to allocate ports "
+				"0x%lx to 0x%lx\n", dev->minor, iobase,
+				iobase + DAS1800_SIZE - 1);
 		return -EIO;
 	}
 	dev->iobase = iobase;
 
 	board = das1800_probe(dev);
-	if (board < 0) {
-		printk(" unable to determine board type\n");
+	if (board < 0)
 		return -ENODEV;
-	}
 
 	dev->board_ptr = das1800_boards + board;
 	dev->board_name = thisboard->name;
@@ -671,9 +670,9 @@ static int das1800_attach(struct comedi_device *dev,
 		iobase2 = iobase + IOBASE2;
 		if (!request_region(iobase2, DAS1800_SIZE,
 				    driver_das1800.driver_name)) {
-			printk
-			    (" I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
-			     iobase2, iobase2 + DAS1800_SIZE - 1);
+			pr_err("comedi%d: I/O port conflict:failed to allocate ports "
+					"0x%lx to 0x%lx\n", dev->minor,	iobase2,
+					iobase2 + DAS1800_SIZE - 1);
 			return -EIO;
 		}
 		devpriv->iobase2 = iobase2;
@@ -683,7 +682,8 @@ static int das1800_attach(struct comedi_device *dev,
 	if (irq) {
 		if (request_irq(irq, das1800_interrupt, 0,
 				driver_das1800.driver_name, dev)) {
-			printk(" unable to allocate irq %u\n", irq);
+			pr_warn("comedi%d: %s: unable to allocate irq %u\n",
+					dev->minor, driver_das1800.driver_name, irq);
 			return -EINVAL;
 		}
 	}
@@ -712,7 +712,8 @@ static int das1800_attach(struct comedi_device *dev,
 		devpriv->irq_dma_bits |= 0x38;
 		break;
 	default:
-		printk(" irq out of range\n");
+		pr_warn("comedi%d: %s: irq out of range\n",
+				dev->minor, driver_das1800.driver_name);
 		return -EINVAL;
 		break;
 	}
@@ -813,8 +814,8 @@ static int das1800_detach(struct comedi_device *dev)
 		kfree(devpriv->ai_buf1);
 	}
 
-	printk("comedi%d: %s: remove\n", dev->minor,
-	       driver_das1800.driver_name);
+	pr_info("comedi%d: %s: remove\n", dev->minor,
+			driver_das1800.driver_name);
 
 	return 0;
 };
-- 
1.7.6

