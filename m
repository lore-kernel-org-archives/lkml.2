Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1KUKhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:37:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1KUKhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:37:48 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 6/8] Staging: comedi: fix printk issue in ni_pcimio.c
Date: Mon, 21 Nov 2011 16:07:04 +0530
Message-Id: <1321871826-13581-6-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_pcimio.c file that fixes up a printk
warning found by the checkpatch.pl tool.
Converted printks to dev_<level> and pr_<level>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_pcimio.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 99f762d..0b99d96 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1684,7 +1684,7 @@ static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int ret;
 
-	printk("comedi%d: ni_pcimio:", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: ni_pcimio:\n", dev->minor);
 
 	ret = ni_alloc_private(dev);
 	if (ret < 0)
@@ -1694,7 +1694,7 @@ static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	printk(" %s", boardtype.name);
+	dev_dbg(dev->hw_dev, "%s\n", boardtype.name);
 	dev->board_name = boardtype.name;
 
 	if (boardtype.reg_type & ni_reg_m_series_mask) {
@@ -1711,7 +1711,7 @@ static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	ret = mite_setup(devpriv->mite);
 	if (ret < 0) {
-		printk(" error setting up mite\n");
+		pr_warn("error setting up mite\n");
 		return ret;
 	}
 	comedi_set_hw_dev(dev, &devpriv->mite->pcidev->dev);
@@ -1739,13 +1739,13 @@ static int pcimio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->irq = mite_irq(devpriv->mite);
 
 	if (dev->irq == 0) {
-		printk(" unknown irq (bad)\n");
+		pr_warn("unknown irq (bad)\n");
 	} else {
-		printk(" ( irq = %u )", dev->irq);
+		pr_debug("( irq = %u )\n", dev->irq);
 		ret = request_irq(dev->irq, ni_E_interrupt, NI_E_IRQ_FLAGS,
 				  DRV_NAME, dev);
 		if (ret < 0) {
-			printk(" irq not available\n");
+			pr_warn("irq not available\n");
 			dev->irq = 0;
 		}
 	}
@@ -1786,7 +1786,7 @@ static int pcimio_find_device(struct comedi_device *dev, int bus, int slot)
 			}
 		}
 	}
-	printk("no device found\n");
+	pr_warn("no device found\n");
 	mite_list_devices();
 	return -EIO;
 }
-- 
1.7.0.4

