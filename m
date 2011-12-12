Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab1LLFUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:20:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1LLFUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:19 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 05/29] Staging: comedi: fix printk issue in dt3000.c
Date: Mon, 12 Dec 2011 10:49:17 +0530
Message-Id: <1323667181-17252-5-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt3000.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Converted printks to dev_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 2542458..b5a63ee 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -669,21 +669,21 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		tscandiv = dt3k_ns_to_timer(100, &cmd->scan_begin_arg,
 					    cmd->flags & TRIG_ROUND_MASK);
 		writew((tscandiv >> 16), devpriv->io_addr + DPR_Params(3));
-		printk("param[3]=0x%04x\n", tscandiv >> 16);
+		dev_dbg(dev->hw_dev, "param[3]=0x%04x\n", tscandiv >> 16);
 		writew((tscandiv & 0xffff), devpriv->io_addr + DPR_Params(4));
-		printk("param[4]=0x%04x\n", tscandiv & 0xffff);
+		dev_dbg(dev->hw_dev, "param[4]=0x%04x\n", tscandiv & 0xffff);
 	} else {
 		/* not supported */
 	}
 
 	mode = DT3000_AD_RETRIG_INTERNAL | 0 | 0;
 	writew(mode, devpriv->io_addr + DPR_Params(5));
-	printk("param[5]=0x%04x\n", mode);
+	dev_dbg(dev->hw_dev, "param[5]=0x%04x\n", mode);
 	writew(aref == AREF_DIFF, devpriv->io_addr + DPR_Params(6));
-	printk("param[6]=0x%04x\n", aref == AREF_DIFF);
+	dev_dbg(dev->hw_dev, "param[6]=0x%04x\n", aref == AREF_DIFF);
 
 	writew(AI_FIFO_DEPTH / 2, devpriv->io_addr + DPR_Params(7));
-	printk("param[7]=0x%04x\n", AI_FIFO_DEPTH / 2);
+	dev_dbg(dev->hw_dev, "param[7]=0x%04x\n", AI_FIFO_DEPTH / 2);
 
 	writew(SUBS_AI, devpriv->io_addr + DPR_SubSys);
 	ret = dt3k_send_cmd(dev, CMD_CONFIG);
-- 
1.7.0.4

