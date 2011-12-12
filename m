Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1LLFV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1LLFVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:53 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 24/29] Staging: comedi: fix printk issue in cb_pcidas64.c
Date: Mon, 12 Dec 2011 10:49:36 +0530
Message-Id: <1323667181-17252-24-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas64.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<levels> and Removed unnecessary
printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index b68c587..c9e8c47 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1881,8 +1881,6 @@ static int detach(struct comedi_device *dev)
 {
 	unsigned int i;
 
-	printk("comedi%d: cb_pcidas: remove\n", dev->minor);
-
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (priv(dev)) {
@@ -2092,7 +2090,8 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 	else
 		num_calibration_sources = 8;
 	if (source >= num_calibration_sources) {
-		printk("invalid calibration source: %i\n", source);
+		dev_dbg(dev->hw_dev, "invalid calibration source: %i\n",
+			source);
 		return -EINVAL;
 	}
 
@@ -2923,7 +2922,7 @@ static void pio_drain_ai_fifo_16(struct comedi_device *dev)
 		}
 
 		if (num_samples < 0) {
-			printk(" cb_pcidas64: bug! num_samples < 0\n");
+			dev_err(dev->hw_dev, "cb_pcidas64: bug! num_samples < 0\n");
 			break;
 		}
 
-- 
1.7.0.4

