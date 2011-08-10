Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1HJKd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:33:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57379 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1HJKdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:33:55 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fix printk() issue in das1800.c
Date: Wed, 10 Aug 2011 16:03:42 +0530
Message-Id: <1312972422-3906-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: comedi:fix printk() issue in das1800.c>
References: <[PATCH]Staging: comedi:fix printk() issue in das1800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das1800.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das1800.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index c4fcd17..b6052a8 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -573,22 +573,23 @@ static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 			devpriv->dma_bits |= DMA_CH7_CH5;
 			break;
 		default:
-			printk(" only supports dma channels 5 through 7\n"
-			       " Dual dma only allows the following combinations:\n"
-			       " dma 5,6 / 6,7 / or 7,5\n");
+			printk(KERN_WARNING " only supports dma channels 5 through 7\n"
+					" Dual dma only allows the following combinations:\n"
+					" dma 5,6 / 6,7 / or 7,5\n");
 			return -EINVAL;
 			break;
 		}
 		if (request_dma(dma0, driver_das1800.driver_name)) {
-			printk(" failed to allocate dma channel %i\n", dma0);
+			printk(KERN_WARNING " failed to allocate dma channel %i\n",
+					dma0);
 			return -EINVAL;
 		}
 		devpriv->dma0 = dma0;
 		devpriv->dma_current = dma0;
 		if (dma1) {
 			if (request_dma(dma1, driver_das1800.driver_name)) {
-				printk(" failed to allocate dma channel %i\n",
-				       dma1);
+				printk(KERN_WARNING " failed to allocate dma channel %i\n",
+						dma1);
 				return -EINVAL;
 			}
 			devpriv->dma1 = dma1;
-- 
1.6.5.2

