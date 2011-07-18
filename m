Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1GRJbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:31:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60527 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1GRJbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:31:32 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 30/30 v2] Staging: comedi: fix printk() issue in das16m1.c
Date: Mon, 18 Jul 2011 15:14:20 +0530
Message-Id: <1310982260-957-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix printk() issue in das16m1.c>
References: <[PATCH]Staging: comedi: fix printk() issue in das16m1.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das16m1.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---

 After understanding code I have changed  8 printk statement in int das16m1_attach function. 

 drivers/staging/comedi/drivers/das16m1.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index efc6132..d737ed2 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -680,17 +680,19 @@ static int das16m1_attach(struct comedi_device *dev,
 
 	dev->board_name = thisboard->name;
 
-	printk(" io 0x%lx-0x%lx 0x%lx-0x%lx",
+	printk(KERN_INFO " requesing the I/O region from 0x%lx-0x%lx 0x%lx-0x%lx",
 	       iobase, iobase + DAS16M1_SIZE,
 	       iobase + DAS16M1_82C55, iobase + DAS16M1_82C55 + DAS16M1_SIZE2);
 	if (!request_region(iobase, DAS16M1_SIZE, driver_das16m1.driver_name)) {
-		printk(" I/O port conflict\n");
-		return -EIO;
+		printk(KERN_INFO "the IO REGION is busy, quitting\n");
+		return -EBUSY;
 	}
 	if (!request_region(iobase + DAS16M1_82C55, DAS16M1_SIZE2,
 			    driver_das16m1.driver_name)) {
 		release_region(iobase, DAS16M1_SIZE);
- 		printk(" I/O port conflict\n");
+		printk(KERN_INFO " releasing  the I/O port region\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -702,15 +704,15 @@ static int das16m1_attach(struct comedi_device *dev,
 		ret = request_irq(irq, das16m1_interrupt, 0,
 				  driver_das16m1.driver_name, dev);
 		if (ret < 0) {
-			printk(", irq unavailable\n");
+			printk(KERN_INFO ", irq unavailable\n");
 			return ret;
 		}
 		dev->irq = irq;
-		printk(", irq %u\n", irq);
+		printk(KERN_INFO ", irq %u\n", irq);
 	} else if (irq == 0) {
-		printk(", no irq\n");
+		printk(KERN_INFO ", no irq\n");
 	} else {
-		printk(", invalid irq\n"
+		printk(KERN_ERR ", invalid irq\n"
 		       " valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
 		return -EINVAL;
 	}
-- 
1.6.5.2

