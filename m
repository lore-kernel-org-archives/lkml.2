Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1HLGC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:02:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50184 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1HLGCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:02:25 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix printk issue in
Date: Fri, 12 Aug 2011 11:32:07 +0530
Message-Id: <1313128927-4151-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging; comedi: fix PRINTK issue in das08_cs.c>
References: <[PATCH]Staging; comedi: fix PRINTK issue in das08_cs.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das08_cs.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das08_cs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 6d91d30..08bd366 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -79,21 +79,21 @@ static int das08_cs_attach(struct comedi_device *dev,
 	if (ret < 0)
 		return ret;
 
-	printk("comedi%d: das08_cs: ", dev->minor);
+	pr_err("comedi%d: das08_cs: ", dev->minor);
 	/*  deal with a pci board */
 
 	if (thisboard->bustype == pcmcia) {
 		if (link == NULL) {
-			printk(" no pcmcia cards found\n");
+			pr_cont(" no pcmcia cards found\n");
 			return -EIO;
 		}
 		iobase = link->resource[0]->start;
 	} else {
-		printk(" bug! board does not have PCMCIA bustype\n");
+		pr_cont(" bug! board does not have PCMCIA bustype\n");
 		return -EINVAL;
 	}
 
-	printk("\n");
+	pr_cont("\n");
 
 	return das08_common_attach(dev, iobase);
 }
-- 
1.6.5.2

