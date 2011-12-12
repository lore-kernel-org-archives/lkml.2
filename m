Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1LLFU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:20:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1LLFUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:25 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 06/29] Staging: comedi: fix printk issue in pcmuio.c
Date: Mon, 12 Dec 2011 10:49:18 +0530
Message-Id: <1323667181-17252-6-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmuio.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Converted printks to dev_functions.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmuio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 0c5b06d..41f843b 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -295,15 +295,15 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	irq[0] = it->options[1];
 	irq[1] = it->options[2];
 
-	printk("comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
-	       iobase);
+	dev_dbg(dev->hw_dev, "comedi%d: %s: io: %lx attached\n", dev->minor,
+		driver.driver_name, iobase);
 
 	dev->iobase = iobase;
 
 	if (!iobase || !request_region(iobase,
 				       thisboard->num_asics * ASIC_IOSIZE,
 				       driver.driver_name)) {
-		printk("I/O port conflict\n");
+		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 
@@ -318,7 +318,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmuio_private)) < 0) {
-		printk("cannot allocate private data structure\n");
+		dev_warn(dev->hw_dev, "cannot allocate private data structure\n");
 		return -ENOMEM;
 	}
 
@@ -337,7 +337,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmuio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk("cannot allocate subdevice private data structures\n");
+		dev_warn(dev->hw_dev, "cannot allocate subdevice private data structures\n");
 		return -ENOMEM;
 	}
 	/*
@@ -348,7 +348,7 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * 96-channel version of the board.
 	 */
 	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk("cannot allocate subdevice data structures\n");
+		dev_dbg(dev->hw_dev, "cannot allocate subdevice data structures\n");
 		return -ENOMEM;
 	}
 
-- 
1.7.0.4

