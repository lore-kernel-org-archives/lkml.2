Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab1J2N0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 09:26:10 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37849 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692Ab1J2N0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 09:26:04 -0400
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 4/7] Staging: comedi: fix printk issue in cb_das16_cs.c
Date: Sat, 29 Oct 2011 18:55:26 +0530
Message-Id: <1319894729-1744-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319894729-1744-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319894729-1744-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_das16_cs.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Converted printks to dev_printk.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index e171c56..9beb34c 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -150,7 +150,7 @@ static const struct das16cs_board *das16cs_probe(struct comedi_device *dev,
 			return das16cs_boards + i;
 	}
 
-	printk("unknown board!\n");
+	dev_dbg(dev->hw_dev, "unknown board!\n");
 
 	return NULL;
 }
@@ -163,20 +163,19 @@ static int das16cs_attach(struct comedi_device *dev,
 	int ret;
 	int i;
 
-	printk("comedi%d: cb_das16_cs: ", dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: cb_das16_cs: attached\n", dev->minor);
 
 	link = cur_dev;		/* XXX hack */
 	if (!link)
 		return -EIO;
 
 	dev->iobase = link->resource[0]->start;
-	printk("I/O base=0x%04lx ", dev->iobase);
+	dev_dbg(dev->hw_dev, "I/O base=0x%04lx\n", dev->iobase);
 
-	printk("fingerprint:\n");
+	dev_dbg(dev->hw_dev, "fingerprint:\n");
 	for (i = 0; i < 48; i += 2)
-		printk("%04x ", inw(dev->iobase + i));
+		dev_dbg(dev->hw_dev, "%04x\n", inw(dev->iobase + i));
 
-	printk("\n");
 
 	ret = request_irq(link->irq, das16cs_interrupt,
 			  IRQF_SHARED, "cb_das16_cs", dev);
@@ -185,7 +184,7 @@ static int das16cs_attach(struct comedi_device *dev,
 
 	dev->irq = link->irq;
 
-	printk("irq=%u ", dev->irq);
+	dev_dbg(dev->hw_dev, "irq=%u\n", dev->irq);
 
 	dev->board_ptr = das16cs_probe(dev, link);
 	if (!dev->board_ptr)
@@ -252,14 +251,13 @@ static int das16cs_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	printk("attached\n");
 
 	return 1;
 }
 
 static int das16cs_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das16cs: remove\n", dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: das16cs: remove\n", dev->minor);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
@@ -312,7 +310,7 @@ static int das16cs_ai_rinsn(struct comedi_device *dev,
 				break;
 		}
 		if (to == TIMEOUT) {
-			printk("cb_das16_cs: ai timeout\n");
+			dev_dbg(dev->hw_dev, "cb_das16_cs: ai timeout\n");
 			return -ETIME;
 		}
 		data[i] = (unsigned short)inw(dev->iobase + 0);
-- 
1.7.0.4

