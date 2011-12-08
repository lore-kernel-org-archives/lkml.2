Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1LHMz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:55:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1LHMzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:55:22 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 29/30] Staging: comedi: fix printk issue in cb_pcidas64.c
Date: Thu,  8 Dec 2011 18:22:24 +0530
Message-Id: <1323348745-31477-29-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas64.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Added KERN_facility levels for printk.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 42d72b0..6a2a5ea 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -2067,7 +2067,8 @@ static int ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		DEBUG_PRINT(" looped %i times waiting for data\n", i);
 		if (i == timeout) {
 			comedi_error(dev, " analog input read insn timed out");
-			printk(" status 0x%x\n", bits);
+			printk
+			    ("status 0x%x\n", bits);
 			return -ETIME;
 		}
 		if (board(dev)->layout == LAYOUT_4020)
@@ -2093,7 +2094,7 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 	else
 		num_calibration_sources = 8;
 	if (source >= num_calibration_sources) {
-		printk("invalid calibration source: %i\n", source);
+		printk(KERN_ERR "invalid calibration source: %i\n", source);
 		return -EINVAL;
 	}
 
@@ -2924,7 +2925,7 @@ static void pio_drain_ai_fifo_16(struct comedi_device *dev)
 		}
 
 		if (num_samples < 0) {
-			printk(" cb_pcidas64: bug! num_samples < 0\n");
+			printk(KERN_ERR "cb_pcidas64: bug! num_samples < 0\n");
 			break;
 		}
 
-- 
1.7.0.4

