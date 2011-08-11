Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab1HKKDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:03:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34720 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab1HKKDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:03:10 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/2] Staging: comedi: fix printk() issue in das800.c
Date: Thu, 11 Aug 2011 15:47:44 +0530
Message-Id: <1313057864-5642-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi:fix printk warning issue in das800.c>
References: <[PATCH]Staging: comedi:fix printk warning issue in das800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das800.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das800.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 96d41ad..feda1be 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -466,42 +466,42 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long irq_flags;
 	int board;
 
-	printk("comedi%d: das800: io 0x%lx", dev->minor, iobase);
+	pr_info("comedi%d: das800: io 0x%lx", dev->minor, iobase);
 	if (irq)
-		printk(", irq %u", irq);
-	printk("\n");
+		pr_cont(", irq %u", irq);
+	pr_cont("\n");
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct das800_private)) < 0)
 		return -ENOMEM;
 
 	if (iobase == 0) {
-		printk("io base address required for das800\n");
+		pr_cont("io base address required for das800\n");
 		return -EINVAL;
 	}
 
 	/* check if io addresses are available */
 	if (!request_region(iobase, DAS800_SIZE, "das800")) {
-		printk("I/O port conflict\n");
+		pr_cont("I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
 
 	board = das800_probe(dev);
 	if (board < 0) {
-		printk("unable to determine board type\n");
+		pr_cont("unable to determine board type\n");
 		return -ENODEV;
 	}
 	dev->board_ptr = das800_boards + board;
 
 	/* grab our IRQ */
 	if (irq == 1 || irq > 7) {
-		printk("irq out of range\n");
+		pr_cont("irq out of range\n");
 		return -EINVAL;
 	}
 	if (irq) {
 		if (request_irq(irq, das800_interrupt, 0, "das800", dev)) {
-			printk("unable to allocate irq %u\n", irq);
+			pr_cont("unable to allocate irq %u\n", irq);
 			return -EINVAL;
 		}
 	}
@@ -557,7 +557,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int das800_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das800: remove\n", dev->minor);
+	pr_info("comedi%d: das800: remove\n", dev->minor);
 
 	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase)
-- 
1.6.5.2

