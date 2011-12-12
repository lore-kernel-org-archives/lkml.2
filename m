Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1LLFVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1LLFVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:39 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 21/29] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Mon, 12 Dec 2011 10:49:33 +0530
Message-Id: <1323667181-17252-21-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_dbg()..

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 7433646..757c96a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -773,8 +773,8 @@ static int cb_pcidas_detach(struct comedi_device *dev)
 			outl(INTCSR_INBOX_INTR_STATUS,
 			     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
 #ifdef CB_PCIDAS_DEBUG
-			printk("detaching, incsr is 0x%x\n",
-			       inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR));
+			dev_dbg(dev->hw_dev, "detaching, incsr is 0x%x\n",
+				inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR));
 #endif
 		}
 	}
@@ -1276,7 +1276,7 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	outw(bits, devpriv->control_status + ADCMUX_CONT);
 
 #ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to adcmux control\n", bits);
+	dev_dbg(dev->hw_dev, "comedi: sent 0x%x to adcmux control\n", bits);
 #endif
 
 	/*  load counters */
@@ -1303,7 +1303,8 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 		devpriv->adc_fifo_bits |= INT_FHF;	/* interrupt fifo half full */
 	}
 #ifdef CB_PCIDAS_DEBUG
-	printk("comedi: adc_fifo_bits are 0x%x\n", devpriv->adc_fifo_bits);
+	dev_dbg(dev->hw_dev, "comedi: adc_fifo_bits are 0x%x\n",
+		devpriv->adc_fifo_bits);
 #endif
 	/*  enable (and clear) interrupts */
 	outw(devpriv->adc_fifo_bits | EOAI | INT | LADFUL,
@@ -1329,7 +1330,7 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 		bits |= BURSTE;
 	outw(bits, devpriv->control_status + TRIG_CONTSTAT);
 #ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to trig control\n", bits);
+	dev_dbg(dev->hw_dev, "comedi: sent 0x%x to trig control\n", bits);
 #endif
 
 	return 0;
-- 
1.7.0.4

