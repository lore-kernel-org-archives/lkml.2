Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1LLFVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1LLFVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:20 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 17/29] Staging: comedi: fix printk issue in das1800.c
Date: Mon, 12 Dec 2011 10:49:29 +0530
Message-Id: <1323667181-17252-17-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das1800.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index a6df30b..e89db9a 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -580,15 +580,16 @@ static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 			break;
 		}
 		if (request_dma(dma0, driver_das1800.driver_name)) {
-			printk(" failed to allocate dma channel %i\n", dma0);
+			dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
+				dma0);
 			return -EINVAL;
 		}
 		devpriv->dma0 = dma0;
 		devpriv->dma_current = dma0;
 		if (dma1) {
 			if (request_dma(dma1, driver_das1800.driver_name)) {
-				printk(" failed to allocate dma channel %i\n",
-				       dma1);
+				dev_err(dev->hw_dev, "failed to allocate dma channel %i\n",
+					dma1);
 				return -EINVAL;
 			}
 			devpriv->dma1 = dma1;
-- 
1.7.0.4

