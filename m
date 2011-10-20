Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1JTGUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:20:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53561 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1JTGUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:20:40 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 08/24]  Staging: comedi: fix printk issue in das800.c
Date: Thu, 20 Oct 2011 11:48:54 +0530
Message-Id: <1319091550-2558-8-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das800.c file that fixes up a printk found by
the checkpatch.pl tool.
Converted printks to pr_<level>.
Removed unnecessary uses of printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das800.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 96d41ad..a589698 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -466,42 +466,40 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long irq_flags;
 	int board;
 
-	printk("comedi%d: das800: io 0x%lx", dev->minor, iobase);
 	if (irq)
-		printk(", irq %u", irq);
-	printk("\n");
+		pr_debug("irq %u\n", irq);
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct das800_private)) < 0)
 		return -ENOMEM;
 
 	if (iobase == 0) {
-		printk("io base address required for das800\n");
+		pr_err("io base address required for das800\n");
 		return -EINVAL;
 	}
 
 	/* check if io addresses are available */
 	if (!request_region(iobase, DAS800_SIZE, "das800")) {
-		printk("I/O port conflict\n");
+		pr_err("I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
 
 	board = das800_probe(dev);
 	if (board < 0) {
-		printk("unable to determine board type\n");
+		pr_err("unable to determine board type\n");
 		return -ENODEV;
 	}
 	dev->board_ptr = das800_boards + board;
 
 	/* grab our IRQ */
 	if (irq == 1 || irq > 7) {
-		printk("irq out of range\n");
+		pr_err("irq out of range\n");
 		return -EINVAL;
 	}
 	if (irq) {
 		if (request_irq(irq, das800_interrupt, 0, "das800", dev)) {
-			printk("unable to allocate irq %u\n", irq);
+			pr_err("unable to allocate irq %u\n", irq);
 			return -EINVAL;
 		}
 	}
@@ -557,7 +555,6 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int das800_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das800: remove\n", dev->minor);
 
 	/* only free stuff if it has been allocated by _attach */
 	if (dev->iobase)
-- 
1.7.6.4

