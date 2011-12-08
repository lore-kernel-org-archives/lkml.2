Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1LHM5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:57:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1LHMyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:11 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 16/30] Staging: comedi: fix printk issue in dt3000.c
Date: Thu,  8 Dec 2011 18:22:11 +0530
Message-Id: <1323348745-31477-16-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt3000.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to pr_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index c656fe4..9926c77 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -637,7 +637,7 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	int ret;
 	unsigned int mode;
 
-	printk("dt3k_ai_cmd:\n");
+	pr_debug("dt3k_ai_cmd:\n");
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		chan = CR_CHAN(cmd->chanlist[i]);
 		range = CR_RANGE(cmd->chanlist[i]);
@@ -648,15 +648,15 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	aref = CR_AREF(cmd->chanlist[0]);
 
 	writew(cmd->scan_end_arg, devpriv->io_addr + DPR_Params(0));
-	printk("param[0]=0x%04x\n", cmd->scan_end_arg);
+	pr_debug("param[0]=0x%04x\n", cmd->scan_end_arg);
 
 	if (cmd->convert_src == TRIG_TIMER) {
 		divider = dt3k_ns_to_timer(50, &cmd->convert_arg,
 					   cmd->flags & TRIG_ROUND_MASK);
 		writew((divider >> 16), devpriv->io_addr + DPR_Params(1));
-		printk("param[1]=0x%04x\n", divider >> 16);
+		pr_debug("param[1]=0x%04x\n", divider >> 16);
 		writew((divider & 0xffff), devpriv->io_addr + DPR_Params(2));
-		printk("param[2]=0x%04x\n", divider & 0xffff);
+		pr_debug("param[2]=0x%04x\n", divider & 0xffff);
 	} else {
 		/* not supported */
 	}
@@ -665,21 +665,21 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		tscandiv = dt3k_ns_to_timer(100, &cmd->scan_begin_arg,
 					    cmd->flags & TRIG_ROUND_MASK);
 		writew((tscandiv >> 16), devpriv->io_addr + DPR_Params(3));
-		printk("param[3]=0x%04x\n", tscandiv >> 16);
+		pr_debug("param[3]=0x%04x\n", tscandiv >> 16);
 		writew((tscandiv & 0xffff), devpriv->io_addr + DPR_Params(4));
-		printk("param[4]=0x%04x\n", tscandiv & 0xffff);
+		pr_debug("param[4]=0x%04x\n", tscandiv & 0xffff);
 	} else {
 		/* not supported */
 	}
 
 	mode = DT3000_AD_RETRIG_INTERNAL | 0 | 0;
 	writew(mode, devpriv->io_addr + DPR_Params(5));
-	printk("param[5]=0x%04x\n", mode);
+	pr_debug("param[5]=0x%04x\n", mode);
 	writew(aref == AREF_DIFF, devpriv->io_addr + DPR_Params(6));
-	printk("param[6]=0x%04x\n", aref == AREF_DIFF);
+	pr_debug("param[6]=0x%04x\n", aref == AREF_DIFF);
 
 	writew(AI_FIFO_DEPTH / 2, devpriv->io_addr + DPR_Params(7));
-	printk("param[7]=0x%04x\n", AI_FIFO_DEPTH / 2);
+	pr_debug("param[7]=0x%04x\n", AI_FIFO_DEPTH / 2);
 
 	writew(SUBS_AI, devpriv->io_addr + DPR_SubSys);
 	ret = dt3k_send_cmd(dev, CMD_CONFIG);
-- 
1.7.0.4

