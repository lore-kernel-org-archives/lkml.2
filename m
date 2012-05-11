Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230Ab2EKKmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:42:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab2EKKmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:42:37 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 21/25] Staging: comedi: fix printk issue in pcmmio.c.
Date: Fri, 11 May 2012 16:08:09 +0530
Message-Id: <1336732693-7408-22-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmmio.c that fixes up printk warning
found by the checkpatch.pl tool.

Used dev_<level> function instead of printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmmio.c |   34 ++++++++++++++++--------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 9ee1da5..498527a 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -1021,15 +1021,16 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	iobase = it->options[0];
 	irq[0] = it->options[1];
 
-	printk(KERN_INFO "comedi%d: %s: io: %lx attaching...\n", dev->minor,
-			dev->driver->driver_name, iobase);
+	dev_info(dev->hw_dev, "comedi%d: %s: io: %lx attaching...\n",
+		 dev->minor, dev->driver->driver_name, iobase);
 
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
 				       thisboard->total_iosize,
 				       dev->driver->driver_name)) {
-		printk(KERN_ERR "comedi%d: I/O port conflict\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: I/O port conflict\n",
+			dev->minor);
 		return -EIO;
 	}
 
@@ -1044,8 +1045,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmmio_private)) < 0) {
-		printk(KERN_ERR "comedi%d: cannot allocate private data structure\n",
-				dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: cannot allocate private data structure\n",
+			dev->minor);
 		return -ENOMEM;
 	}
 
@@ -1068,8 +1069,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmmio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk(KERN_ERR "comedi%d: cannot allocate subdevice private data structures\n",
-				dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: cannot allocate subdevice private data structures\n",
+			dev->minor);
 		return -ENOMEM;
 	}
 	/*
@@ -1079,8 +1080,8 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
 	 */
 	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk(KERN_ERR "comedi%d: cannot allocate subdevice data structures\n",
-				dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: cannot allocate subdevice data structures\n",
+			dev->minor);
 		return -ENOMEM;
 	}
 
@@ -1210,15 +1211,16 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				 */
 
 	if (irq[0]) {
-		printk(KERN_DEBUG "comedi%d: irq: %u\n", dev->minor, irq[0]);
+		dev_dbg(dev->hw_dev, "comedi%d: irq: %u\n", dev->minor, irq[0]);
 		if (thisboard->dio_num_asics == 2 && irq[1])
-			printk(KERN_DEBUG "comedi%d: second ASIC irq: %u\n",
-					dev->minor, irq[1]);
+			dev_dbg(dev->hw_dev, "comedi%d: second ASIC irq: %u\n",
+				dev->minor, irq[1]);
 	} else {
-		printk(KERN_INFO "comedi%d: (IRQ mode disabled)\n", dev->minor);
+		dev_info(dev->hw_dev, "comedi%d: (IRQ mode disabled)\n",
+			 dev->minor);
 	}
 
-	printk(KERN_INFO "comedi%d: attached\n", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: attached\n", dev->minor);
 
 	return 1;
 }
@@ -1227,8 +1229,8 @@ static int pcmmio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk(KERN_INFO "comedi%d: %s: remove\n", dev->minor,
-		dev->driver->driver_name);
+	dev_info(dev->hw_dev, "comedi%d: %s: remove\n", dev->minor,
+		 dev->driver->driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, thisboard->total_iosize);
 
-- 
1.7.0.4

