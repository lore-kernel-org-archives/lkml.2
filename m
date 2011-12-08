Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1LHMxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:53:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1LHMxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:53:34 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 09/30] Staging: comedi: fix printk issue in pcmuio.c
Date: Thu,  8 Dec 2011 18:22:04 +0530
Message-Id: <1323348745-31477-9-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmuio.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Added KERN_facility levels for printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmuio.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 0c5b06d..1de663e 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -295,15 +295,15 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	irq[0] = it->options[1];
 	irq[1] = it->options[2];
 
-	printk("comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
-	       iobase);
+	printk(KERN_INFO "comedi%d: %s: io: %lx attached\n", dev->minor,
+ 	       driver.driver_name, iobase);
 
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
 				       thisboard->num_asics * ASIC_IOSIZE,
 				       driver.driver_name)) {
-		printk("I/O port conflict\n");
+		printk(KERN_ERR "I/O port conflict\n");
 		return -EIO;
 	}
 
@@ -318,7 +318,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmuio_private)) < 0) {
-		printk("cannot allocate private data structure\n");
+		printk(KERN_WARNING "cannot allocate private data structure\n");
 		return -ENOMEM;
 	}
 
@@ -337,7 +337,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmuio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk("cannot allocate subdevice private data structures\n");
+		printk(KERN_WARNING "cannot allocate subdevice private data structures\n");
 		return -ENOMEM;
 	}
 	/*
@@ -348,7 +348,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * 96-channel version of the board.
 	 */
 	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk("cannot allocate subdevice data structures\n");
+		printk(KERN_WARNING "cannot allocate subdevice data structures\n");
 		return -ENOMEM;
 	}
 
@@ -436,15 +436,13 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				   irqs.. */
 
 	if (irq[0]) {
-		printk("irq: %u ", irq[0]);
+		printk(KERN_DEBUG "irq: %u\n", irq[0]);
 		if (irq[1] && thisboard->num_asics == 2)
-			printk("second ASIC irq: %u ", irq[1]);
+			printk(KERN_DEBUG "second ASIC irq: %u\n", irq[1]);
 	} else {
-		printk("(IRQ mode disabled) ");
+		printk(KERN_DEBUG "(IRQ mode disabled)\n");
 	}
 
-	printk("attached\n");
-
 	return 1;
 }
 
@@ -460,7 +458,8 @@ static int pcmuio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk("comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor,
+	       driver.driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
 
-- 
1.7.0.4

