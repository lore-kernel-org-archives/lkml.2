Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab1HPGlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:41:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44686 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1HPGls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:41:48 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        root <root@localhost.localdomain>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix printk warning issue cb_das16_cs.c
Date: Tue, 16 Aug 2011 02:41:22 -0400
Message-Id: <1313476882-6350-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi:fix printk issue in cb_das16_cs.c>
References: <[PATCH]Staging: comedi:fix printk issue in cb_das16_cs.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@localhost.localdomain>

This is a patch to the cb_das16_cs.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 8a1b8a7..0b1ef93 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -99,7 +99,7 @@ static struct comedi_driver driver_das16cs = {
 	.detach = das16cs_detach,
 };
 
-static struct pcmcia_device *cur_dev = NULL;
+static struct pcmcia_device *cur_dev;
 
 static const struct comedi_lrange das16cs_ai_range = { 4, {
 							   RANGE(-10, 10),
@@ -150,7 +150,7 @@ static const struct das16cs_board *das16cs_probe(struct comedi_device *dev,
 			return das16cs_boards + i;
 	}
 
-	printk("unknown board!\n");
+	printk(KERN_WARNING "unknown board!\n");
 
 	return NULL;
 }
@@ -163,20 +163,20 @@ static int das16cs_attach(struct comedi_device *dev,
 	int ret;
 	int i;
 
-	printk("comedi%d: cb_das16_cs: ", dev->minor);
+	printk(KERN_INFO "comedi%d: cb_das16_cs: ", dev->minor);
 
 	link = cur_dev;		/* XXX hack */
 	if (!link)
 		return -EIO;
 
 	dev->iobase = link->resource[0]->start;
-	printk("I/O base=0x%04lx ", dev->iobase);
+	printk(KERN_CONT "I/O base=0x%04lx ", dev->iobase);
 
-	printk("fingerprint:\n");
+	printk(KERN_CONT "fingerprint:\n");
 	for (i = 0; i < 48; i += 2)
-		printk("%04x ", inw(dev->iobase + i));
+		printk(KERN_CONT "%04x ", inw(dev->iobase + i));
 
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	ret = request_irq(link->irq, das16cs_interrupt,
 			  IRQF_SHARED, "cb_das16_cs", dev);
@@ -185,7 +185,7 @@ static int das16cs_attach(struct comedi_device *dev,
 
 	dev->irq = link->irq;
 
-	printk("irq=%u ", dev->irq);
+	printk(KERN_CONT "irq=%u ", dev->irq);
 
 	dev->board_ptr = das16cs_probe(dev, link);
 	if (!dev->board_ptr)
@@ -252,14 +252,14 @@ static int das16cs_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	printk("attached\n");
+	printk(KERN_CONT "attached\n");
 
 	return 1;
 }
 
 static int das16cs_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das16cs: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: das16cs: remove\n", dev->minor);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-- 
1.7.6

