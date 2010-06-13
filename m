Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab0FMAPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 20:15:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62539 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0FMAPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 20:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QZMIQNTATVsApvaqinv3qyQz6ZOrughEaYDBAJF5p17Ag987NjElAO4yHeW6N4g7/S
         FLodD18WoNyATFTMHk+gXLorKKeDWbw7BuctyOVOWQw68puFTQ/fEoKc049/fgoOwII/
         XVrL++ABBkKnY6uXm7HwRXP2FRW6SUSM9MvSg=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, abbotti@mev.co.uk
Cc: wfp5p@virginia.edu, devel@driver.osuosl.org, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: comedi: drivers: Fix coding style issues in pcl711.c
Date: Sat, 12 Jun 2010 19:15:22 -0500
Message-Id: <1276388122-8227-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcl711.c file that fixes up printk()
warning issues.


Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/comedi/drivers/pcl711.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index a499f70..d129ca7 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -270,7 +270,7 @@ static int pcl711_ai_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 				goto ok;
 			udelay(1);
 		}
-		printk("comedi%d: pcl711: A/D timeout\n", dev->minor);
+		printk(KERN_ERR "comedi%d: pcl711: A/D timeout\n", dev->minor);
 		return -ETIME;
 
 ok:
@@ -505,7 +505,7 @@ static int pcl711_do_insn_bits(struct comedi_device *dev,
 /*  Free any resources that we have claimed  */
 static int pcl711_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: pcl711: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: pcl711: remove\n", dev->minor);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
@@ -527,7 +527,7 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* claim our I/O space */
 
 	iobase = it->options[0];
-	printk("comedi%d: pcl711: 0x%04lx ", dev->minor, iobase);
+	printk(KERN_INFO "comedi%d: pcl711: 0x%04lx ", dev->minor, iobase);
 	if (!request_region(iobase, PCL711_SIZE, "pcl711")) {
 		printk("I/O port conflict\n");
 		return -EIO;
@@ -542,15 +542,15 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* grab our IRQ */
 	irq = it->options[1];
 	if (irq > this_board->maxirq) {
-		printk("irq out of range\n");
+		printk(KERN_ERR "irq out of range\n");
 		return -EINVAL;
 	}
 	if (irq) {
 		if (request_irq(irq, pcl711_interrupt, 0, "pcl711", dev)) {
-			printk("unable to allocate irq %u\n", irq);
+			printk(KERN_ERR "unable to allocate irq %u\n", irq);
 			return -EINVAL;
 		} else {
-			printk("( irq = %u )\n", irq);
+			printk(KERN_INFO "( irq = %u )\n", irq);
 		}
 	}
 	dev->irq = irq;
@@ -624,7 +624,7 @@ static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	outb(0, dev->iobase + PCL711_DA1_LO);
 	outb(0, dev->iobase + PCL711_DA1_HI);
 
-	printk("\n");
+	printk(KERN_INFO "\n");
 
 	return 0;
 }
-- 
1.5.4.3

