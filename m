Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab1GWGI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 02:08:29 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43887 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1GWGIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 02:08:24 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/1 v3] Staging: comedi: fix printk issue in das16m1.c
Date: Sat, 23 Jul 2011 11:51:41 +0530
Message-Id: <1311402101-14157-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: Comedi: fix printk issue in das16m1.c>
References: <[PATCH]Staging: Comedi: fix printk issue in das16m1.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das16m1.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
Converted printk to pr_<level>

 drivers/staging/comedi/drivers/das16m1.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index a5ce3b2..1046433 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -668,7 +668,7 @@ static int das16m1_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 
-	printk("comedi%d: das16m1:", dev->minor);
+	pr_info("comedi%d: das16m1:", dev->minor);
 
 	ret = alloc_private(dev, sizeof(struct das16m1_private_struct));
 	if (ret < 0)
@@ -676,17 +676,17 @@ static int das16m1_attach(struct comedi_device *dev,
 
 	dev->board_name = thisboard->name;
 
-	printk(" io 0x%lx-0x%lx 0x%lx-0x%lx",
+	pr_cont(" io 0x%lx-0x%lx 0x%lx-0x%lx",
 	       iobase, iobase + DAS16M1_SIZE,
 	       iobase + DAS16M1_82C55, iobase + DAS16M1_82C55 + DAS16M1_SIZE2);
 	if (!request_region(iobase, DAS16M1_SIZE, driver_das16m1.driver_name)) {
-		printk(" I/O port conflict\n");
+		pr_err(" I/O port conflict\n");
 		return -EIO;
 	}
 	if (!request_region(iobase + DAS16M1_82C55, DAS16M1_SIZE2,
 			    driver_das16m1.driver_name)) {
 		release_region(iobase, DAS16M1_SIZE);
-		printk(" I/O port conflict\n");
+		pr_err(" I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -698,16 +698,16 @@ static int das16m1_attach(struct comedi_device *dev,
 		ret = request_irq(irq, das16m1_interrupt, 0,
 				  driver_das16m1.driver_name, dev);
 		if (ret < 0) {
-			printk(", irq unavailable\n");
+			pr_err(", irq unavailable\n");
 			return ret;
 		}
 		dev->irq = irq;
-		printk(", irq %u\n", irq);
+		pr_debug(", irq %u\n", irq);
 	} else if (irq == 0) {
-		printk(", no irq\n");
+		pr_debug(", no irq\n");
 	} else {
-		printk(", invalid irq\n"
-		       " valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
+		pr_err(", invalid irq\n"
+				" valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
 		return -EINVAL;
 	}
 
@@ -771,7 +771,7 @@ static int das16m1_attach(struct comedi_device *dev,
 
 static int das16m1_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das16m1: remove\n", dev->minor);
+	pr_info("comedi%d: das16m1: remove\n", dev->minor);
 
 /* das16m1_reset(dev); */
 
-- 
1.6.5.2

