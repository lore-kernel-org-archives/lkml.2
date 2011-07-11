Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1GKGwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 02:52:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46205 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab1GKGwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 02:52:16 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 7/7] Staging: comedi: fix  printk() issue in pcl818.c
Date: Mon, 11 Jul 2011 12:34:53 +0530
Message-Id: <1310367893-24048-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 6/6]Staging: comedi: fix printk() warning issue in pcl818.c>
References: <[PATCH 6/6]Staging: comedi: fix printk() warning issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 86b30c3..ae097b3 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -921,7 +921,7 @@ static void pcl818_ai_mode13dma_int(int mode, struct comedi_device *dev,
 	unsigned int flags;
 	unsigned int bytes;
 
-	printk("mode13dma_int, mode: %d\n", mode);
+	printk(KERN_INFO "mode13dma_int, mode: %d\n", mode);
 	disable_dma(devpriv->dma);	/*  disable dma */
 	bytes = devpriv->hwdmasize[0];
 	if (!devpriv->neverending_ai) {
@@ -1004,7 +1004,7 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 	int divisor1 = 0, divisor2 = 0;
 	unsigned int seglen;
 
-	printk("pcl818_ai_cmd_mode()\n");
+	printk(KERN_INFO "pcl818_ai_cmd_mode()\n");
 	if ((!dev->irq) && (!devpriv->dma_rtc)) {
 		comedi_error(dev, "IRQ not defined!");
 		return -EINVAL;
@@ -1104,7 +1104,7 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 		break;
 	}
 #endif
-	printk("pcl818_ai_cmd_mode() end\n");
+	printk(KERN_INFO "pcl818_ai_cmd_mode() end\n");
 	return 0;
 }
 
-- 
1.6.5.2

