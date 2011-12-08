Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab1LHMyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:54:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64358 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1LHMyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:38 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 21/30] Staging: comedi: fix printk issue in jr3_pci.c
Date: Thu,  8 Dec 2011 18:22:16 +0530
Message-Id: <1323348745-31477-21-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the jr3_pci.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Added KERN_facility levels for printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/jr3_pci.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 8273fb9..b1af4fb 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -771,13 +771,13 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	int opt_bus, opt_slot, i;
 	struct jr3_pci_dev_private *devpriv;
 
-	printk("comedi%d: jr3_pci\n", dev->minor);
+	printk(KERN_INFO "comedi%d: jr3_pci: attached\n", dev->minor);
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 
 	if (sizeof(struct jr3_channel) != 0xc00) {
-		printk("sizeof(struct jr3_channel) = %x [expected %x]\n",
+		printk(KERN_ERR "sizeof(struct jr3_channel) = %x [expected %x]\n",
 		       (unsigned)sizeof(struct jr3_channel), 0xc00);
 		return -EINVAL;
 	}
@@ -832,7 +832,7 @@ static int jr3_pci_attach(struct comedi_device *dev,
 		}
 	}
 	if (!card) {
-		printk(" no jr3_pci found\n");
+		printk(KERN_ERR "no jr3_pci found\n");
 		return -EIO;
 	} else {
 		devpriv->pci_dev = card;
@@ -867,7 +867,7 @@ static int jr3_pci_attach(struct comedi_device *dev,
 
 			p = dev->subdevices[i].private;
 			p->channel = &devpriv->iobase->channel[i].data;
-			printk("p->channel %p %p (%tx)\n",
+			printk(KERN_DEBUG "p->channel %p %p (%tx)\n",
 			       p->channel, devpriv->iobase,
 			       ((char *)(p->channel) -
 				(char *)(devpriv->iobase)));
@@ -908,7 +908,7 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	devpriv->iobase->channel[0].reset = 0;
 
 	result = comedi_load_firmware(dev, "jr3pci.idm", jr3_download_firmware);
-	printk("Firmare load %d\n", result);
+	printk(KERN_DEBUG "Firmare load %d\n", result);
 
 	if (result < 0)
 		goto out;
@@ -926,7 +926,7 @@ static int jr3_pci_attach(struct comedi_device *dev,
  */
 	msleep_interruptible(25);
 	for (i = 0; i < 0x18; i++) {
-		printk("%c",
+		printk(KERN_DEBUG "%c",
 		       get_u16(&devpriv->iobase->channel[0].
 			       data.copyright[i]) >> 8);
 	}
@@ -955,7 +955,7 @@ static int jr3_pci_detach(struct comedi_device *dev)
 	int i;
 	struct jr3_pci_dev_private *devpriv = dev->private;
 
-	printk("comedi%d: jr3_pci: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: jr3_pci: remove\n", dev->minor);
 	if (devpriv) {
 		del_timer_sync(&devpriv->timer);
 
-- 
1.7.0.4

