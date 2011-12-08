Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1LHMzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:55:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1LHMy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:59 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 25/30] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Thu,  8 Dec 2011 18:22:20 +0530
Message-Id: <1323348745-31477-25-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Removed ifdef CB_PCIDAS_DEBUG.
Included KERN_facility levels for printk.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 7433646..f9cb51f 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -772,10 +772,8 @@ static int cb_pcidas_detach(struct comedi_device *dev)
 			/*  disable and clear interrupts on amcc s5933 */
 			outl(INTCSR_INBOX_INTR_STATUS,
 			     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-#ifdef CB_PCIDAS_DEBUG
-			printk("detaching, incsr is 0x%x\n",
+			printk(KERN_DEBUG "detaching, incsr is 0x%x\n",
 			       inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR));
-#endif
 		}
 	}
 	if (dev->irq)
@@ -855,7 +853,7 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 	unsigned int source = data[1];
 
 	if (source >= num_calibration_sources) {
-		printk("invalid calibration source: %i\n", source);
+		printk(KERN_ERR "invalid calibration source: %i\n", source);
 		return -EINVAL;
 	}
 
@@ -1274,11 +1272,7 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	else
 		bits |= PACER_INT;
 	outw(bits, devpriv->control_status + ADCMUX_CONT);
-
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to adcmux control\n", bits);
-#endif
-
+	printk(KERN_DEBUG "comedi: sent 0x%x to adcmux control\n", bits);
 	/*  load counters */
 	if (cmd->convert_src == TRIG_TIMER)
 		cb_pcidas_load_counters(dev, &cmd->convert_arg,
-- 
1.7.0.4

