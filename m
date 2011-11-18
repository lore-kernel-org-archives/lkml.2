Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1KRNC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:02:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38561 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab1KRNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:02:54 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 22/25] Staging: comedi: fix printk issue in das16m1.c
Date: Fri, 18 Nov 2011 18:32:18 +0530
Message-Id: <1321621341-10284-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321621341-10284-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321621341-10284-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das16m1.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to comedi_<level.
Removed an unnecessary printk statment.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das16m1.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index b8de374..5376e71 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -667,25 +667,20 @@ static int das16m1_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 
-	printk("comedi%d: das16m1:", dev->minor);
-
 	ret = alloc_private(dev, sizeof(struct das16m1_private_struct));
 	if (ret < 0)
 		return ret;
 
 	dev->board_name = thisboard->name;
 
-	printk(" io 0x%lx-0x%lx 0x%lx-0x%lx",
-	       iobase, iobase + DAS16M1_SIZE,
-	       iobase + DAS16M1_82C55, iobase + DAS16M1_82C55 + DAS16M1_SIZE2);
 	if (!request_region(iobase, DAS16M1_SIZE, driver_das16m1.driver_name)) {
-		printk(" I/O port conflict\n");
+		comedi_error(dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	if (!request_region(iobase + DAS16M1_82C55, DAS16M1_SIZE2,
 			    driver_das16m1.driver_name)) {
 		release_region(iobase, DAS16M1_SIZE);
-		printk(" I/O port conflict\n");
+		comedi_error(dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -696,17 +691,17 @@ static int das16m1_attach(struct comedi_device *dev,
 	if (das16m1_irq_bits(irq) >= 0) {
 		ret = request_irq(irq, das16m1_interrupt, 0,
 				  driver_das16m1.driver_name, dev);
-		if (ret < 0) {
-			printk(", irq unavailable\n");
+		if (ret < 0)
 			return ret;
-		}
 		dev->irq = irq;
-		printk(", irq %u\n", irq);
+		printk
+		    ("irq %u\n", irq);
 	} else if (irq == 0) {
-		printk(", no irq\n");
+		printk
+		    (", no irq\n");
 	} else {
-		printk(", invalid irq\n"
-		       " valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
+		comedi_error(dev, "invalid irq\n"
+			     " valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
 		return -EINVAL;
 	}
 
@@ -770,7 +765,6 @@ static int das16m1_attach(struct comedi_device *dev,
 
 static int das16m1_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das16m1: remove\n", dev->minor);
 
 /* das16m1_reset(dev); */
 
-- 
1.7.0.4

