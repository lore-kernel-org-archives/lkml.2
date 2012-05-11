Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab2EKKlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:41:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35076 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab2EKKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:41:40 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 15/25] Staging: comedi: fix printk issue in unioxx5.c
Date: Fri, 11 May 2012 16:08:03 +0530
Message-Id: <1336732693-7408-16-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the unioxx5.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<level> functions.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/unioxx5.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index f45824f..8cba339 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -154,13 +154,12 @@ static int unioxx5_attach(struct comedi_device *dev,
 
 	/* unioxx5 can has from two to four subdevices */
 	if (n_subd < 2) {
-		printk(KERN_ERR
-		       "your card must has at least 2 'g01' subdevices\n");
+		dev_err(dev->hw_dev, "your card must has at least 2 'g01' subdevices\n");
 		return -1;
 	}
 
 	if (alloc_subdevices(dev, n_subd) < 0) {
-		printk(KERN_ERR "out of memory\n");
+		dev_err(dev->hw_dev, "out of memory\n");
 		return -ENOMEM;
 	}
 
@@ -171,7 +170,7 @@ static int unioxx5_attach(struct comedi_device *dev,
 			return -1;
 	}
 
-	printk(KERN_INFO "attached\n");
+	dev_info(dev->hw_dev, "attached\n");
 	return 0;
 }
 
@@ -231,17 +230,15 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 	type = usp->usp_module_type[channel / 2];
 
 	if (type != MODULE_DIGITAL) {
-		printk(KERN_ERR
-		       "comedi%d: channel configuration accessible only for digital modules\n",
-		       dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: channel configuration accessible only for digital modules\n",
+			dev->minor);
 		return -1;
 	}
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		printk(KERN_ERR
-		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
-		       dev->minor, channel);
+		dev_err(dev->hw_dev, "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+			dev->minor, channel);
 		return -1;
 	}
 
@@ -256,7 +253,7 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 		flags |= mask;
 		break;
 	default:
-		printk(KERN_ERR "comedi%d: unknown flag\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: unknown flag\n", dev->minor);
 		return -1;
 	}
 
-- 
1.7.0.4

