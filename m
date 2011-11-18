Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab1KRNDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:03:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38561 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab1KRNC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:02:59 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 23/25] Staging: comedi: fix printk issue in pcl818.c
Date: Fri, 18 Nov 2011 18:32:19 +0530
Message-Id: <1321621341-10284-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321621341-10284-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321621341-10284-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcl818.c file that fixes up a printk
warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcl818.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 4e134e9..c207b25 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1745,22 +1745,23 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* claim our I/O space */
 	iobase = it->options[0];
-	printk("comedi%d: pcl818:  board=%s, ioport=0x%03lx",
-	       dev->minor, this_board->name, iobase);
+	printk
+	    ("comedi%d: pcl818:  board=%s, ioport=0x%03lx",
+	     dev->minor, this_board->name, iobase);
 	devpriv->io_range = this_board->io_range;
 	if ((this_board->fifo) && (it->options[2] == -1)) {	/*  we've board with FIFO and we want to use FIFO */
 		devpriv->io_range = PCLx1xFIFO_RANGE;
 		devpriv->usefifo = 1;
 	}
 	if (!request_region(iobase, devpriv->io_range, "pcl818")) {
-		printk("I/O port conflict\n");
+		comedi_error(dev, "I/O port conflict\n");
 		return -EIO;
 	}
 
 	dev->iobase = iobase;
 
 	if (pcl818_check(iobase)) {
-		printk(", I can't detect board. FAIL!\n");
+		comedi_error(dev, "I can't detect board. FAIL!\n");
 		return -EIO;
 	}
 
@@ -1784,7 +1785,7 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 					     irq);
 					irq = 0;	/* Can't use IRQ */
 				} else {
-					printk(", irq=%u", irq);
+					printk(KERN_DEBUG "irq=%u", irq);
 				}
 			}
 		}
@@ -1815,7 +1816,7 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				 "pcl818 DMA (RTC)", dev)) {
 			devpriv->dma_rtc = 1;
 			devpriv->rtc_irq = RTC_IRQ;
-			printk(", dma_irq=%u", devpriv->rtc_irq);
+			printk(KERN_DEBUG "dma_irq=%u", devpriv->rtc_irq);
 		} else {
 			RTC_lock--;
 			if (RTC_lock == 0) {
-- 
1.7.0.4

