Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1LLFVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1LLFVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:30 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 19/29] Staging: comedi: fix printk issue in das1800.c
Date: Mon, 12 Dec 2011 10:49:31 +0530
Message-Id: <1323667181-17252-19-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das1800.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Coverted printks to dev_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index e89db9a..1ea9789 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -660,7 +660,7 @@ static int das1800_attach(struct comedi_device *dev,
 
 	board = das1800_probe(dev);
 	if (board < 0) {
-		printk(" unable to determine board type\n");
+		dev_err(dev->hw_dev, "unable to determine board type\n");
 		return -ENODEV;
 	}
 
@@ -684,7 +684,8 @@ static int das1800_attach(struct comedi_device *dev,
 	if (irq) {
 		if (request_irq(irq, das1800_interrupt, 0,
 				driver_das1800.driver_name, dev)) {
-			printk(" unable to allocate irq %u\n", irq);
+			dev_dbg(dev->hw_dev, "unable to allocate irq %u\n",
+				irq);
 			return -EINVAL;
 		}
 	}
@@ -713,7 +714,7 @@ static int das1800_attach(struct comedi_device *dev,
 		devpriv->irq_dma_bits |= 0x38;
 		break;
 	default:
-		printk(" irq out of range\n");
+		dev_err(dev->hw_dev, "irq out of range\n");
 		return -EINVAL;
 		break;
 	}
-- 
1.7.0.4

