Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1LLFUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:20:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1LLFUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:14 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 04/29] Staging: comedi: fix printk issue in dt3000.c
Date: Mon, 12 Dec 2011 10:49:16 +0530
Message-Id: <1323667181-17252-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt3000.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Converted printks to dev_functions.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 57361d1..2542458 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -641,7 +641,7 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	int ret;
 	unsigned int mode;
 
-	printk("dt3k_ai_cmd:\n");
+	dev_dbg(dev->hw_dev, "dt3k_ai_cmd:\n");
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		chan = CR_CHAN(cmd->chanlist[i]);
 		range = CR_RANGE(cmd->chanlist[i]);
@@ -652,15 +652,15 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	aref = CR_AREF(cmd->chanlist[0]);
 
 	writew(cmd->scan_end_arg, devpriv->io_addr + DPR_Params(0));
-	printk("param[0]=0x%04x\n", cmd->scan_end_arg);
+	dev_dbg(dev->hw_dev, "param[0]=0x%04x\n", cmd->scan_end_arg);
 
 	if (cmd->convert_src == TRIG_TIMER) {
 		divider = dt3k_ns_to_timer(50, &cmd->convert_arg,
 					   cmd->flags & TRIG_ROUND_MASK);
 		writew((divider >> 16), devpriv->io_addr + DPR_Params(1));
-		printk("param[1]=0x%04x\n", divider >> 16);
+		dev_dbg(dev->hw_dev, "param[1]=0x%04x\n", divider >> 16);
 		writew((divider & 0xffff), devpriv->io_addr + DPR_Params(2));
-		printk("param[2]=0x%04x\n", divider & 0xffff);
+		dev_dbg(dev->hw_dev, "param[2]=0x%04x\n", divider & 0xffff);
 	} else {
 		/* not supported */
 	}
-- 
1.7.0.4

