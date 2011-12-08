Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1LHMxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:53:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1LHMxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:53:51 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 12/30] Staging: comedi: fix printk issue in contec_pci_dio.c
Date: Thu,  8 Dec 2011 18:22:07 +0530
Message-Id: <1323348745-31477-12-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the contec_pci_dio.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Added KERN_facility levels to printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index db73638..64f5f49 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -105,7 +105,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: contec: ", dev->minor);
+	printk(KERN_DEBUG "comedi%d: contec: attached\n", dev->minor);
 
 	dev->board_name = thisboard->name;
 
@@ -132,7 +132,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				return -EIO;
 			}
 			dev->iobase = pci_resource_start(pcidev, 0);
-			printk(" base addr %lx ", dev->iobase);
+			printk(KERN_DEBUG "base addr %lx ", dev->iobase);
 
 			dev->board_ptr = contec_boards + 0;
 
@@ -153,20 +153,18 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->range_table = &range_digital;
 			s->insn_bits = contec_do_insn_bits;
 
-			printk("attached\n");
-
 			return 1;
 		}
 	}
 
-	printk("card not present!\n");
+	printk(KERN_ERR "card not present!\n");
 
 	return -EIO;
 }
 
 static int contec_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: contec: remove\n", dev->minor);
+	printk(KERN_DEBUG "comedi%d: contec: remove\n", dev->minor);
 
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
-- 
1.7.0.4

