Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1LLFWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:22:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab1LLFWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:22:08 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 27/29] Staging: comedi: fix printk issue in das1800.c
Date: Mon, 12 Dec 2011 10:49:39 +0530
Message-Id: <1323667181-17252-27-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das1800.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printk to dev_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 3ca751c..99ada5a 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -573,9 +573,9 @@ static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 			devpriv->dma_bits |= DMA_CH7_CH5;
 			break;
 		default:
-			printk(" only supports dma channels 5 through 7\n"
-			       " Dual dma only allows the following combinations:\n"
-			       " dma 5,6 / 6,7 / or 7,5\n");
+			dev_err(dev->hw_dev, " only supports dma channels 5 through 7\n"
+				" Dual dma only allows the following combinations:\n"
+				" dma 5,6 / 6,7 / or 7,5\n");
 			return -EINVAL;
 			break;
 		}
@@ -645,7 +645,7 @@ static int das1800_attach(struct comedi_device *dev,
 	printk(KERN_CONT "\n");
 
 	if (iobase == 0) {
-		printk(" io base address required\n");
+		dev_err(dev->hw_dev, "io base address required\n");
 		return -EINVAL;
 	}
 
@@ -815,8 +815,8 @@ static int das1800_detach(struct comedi_device *dev)
 		kfree(devpriv->ai_buf1);
 	}
 
-	printk("comedi%d: %s: remove\n", dev->minor,
-	       driver_das1800.driver_name);
+	dev_dbg(dev->hw_dev, "comedi%d: %s: remove\n", dev->minor,
+		driver_das1800.driver_name);
 
 	return 0;
 };
-- 
1.7.0.4

