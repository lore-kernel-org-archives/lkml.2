Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1LHMyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:54:23 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64358 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab1LHMyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:16 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 17/30] Staging: comedi: fix printk issue in dt3000.c
Date: Thu,  8 Dec 2011 18:22:12 +0530
Message-Id: <1323348745-31477-17-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt3000.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to pr_<levels>.
Removed if DEBUG.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 9926c77..0aa538d 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -845,7 +845,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int bus, slot;
 	int ret = 0;
 
-	printk("dt3000:");
+	pr_debug("dt3000:\n");
 	bus = it->options[0];
 	slot = it->options[1];
 
@@ -857,7 +857,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 	if (ret == 0) {
-		printk(" no DT board found\n");
+		pr_err("no DT board found\n");
 		return -ENODEV;
 	}
 
@@ -865,7 +865,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (request_irq(devpriv->pci_dev->irq, dt3k_interrupt, IRQF_SHARED,
 			"dt3000", dev)) {
-		printk(" unable to allocate IRQ %u\n", devpriv->pci_dev->irq);
+		pr_err("unable to allocate IRQ %u\n", devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
@@ -995,10 +995,8 @@ static int setup_pci(struct comedi_device *dev)
 	devpriv->io_addr = ioremap(devpriv->phys_addr, DT3000_SIZE);
 	if (!devpriv->io_addr)
 		return -ENOMEM;
-#if DEBUG
-	printk("0x%08llx mapped to %p, ",
-	       (unsigned long long)devpriv->phys_addr, devpriv->io_addr);
-#endif
+	pr_debug("0x%08llx mapped to %p\n",
+		 (unsigned long long)devpriv->phys_addr, devpriv->io_addr);
 
 	return 0;
 }
-- 
1.7.0.4

