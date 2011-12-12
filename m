Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab1LLFUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:20:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1LLFUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:09 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 03/29] Staging: comedi: fix printk issue in dt3000.c
Date: Mon, 12 Dec 2011 10:49:15 +0530
Message-Id: <1323667181-17252-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt3000.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 8347bac..57361d1 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -849,7 +849,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int bus, slot;
 	int ret = 0;
 
-	printk("dt3000:");
+	dev_dbg(dev->hw_dev, "dt3000:\n");
 	bus = it->options[0];
 	slot = it->options[1];
 
@@ -861,7 +861,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 	if (ret == 0) {
-		printk(" no DT board found\n");
+		dev_warn(dev->hw_dev, "no DT board found\n");
 		return -ENODEV;
 	}
 
@@ -869,7 +869,8 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (request_irq(devpriv->pci_dev->irq, dt3k_interrupt, IRQF_SHARED,
 			"dt3000", dev)) {
-		printk(" unable to allocate IRQ %u\n", devpriv->pci_dev->irq);
+		dev_err(dev->hw_dev, "unable to allocate IRQ %u\n",
+			devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
-- 
1.7.0.4

