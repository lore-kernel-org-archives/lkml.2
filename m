Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1LHMzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:55:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64358 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab1LHMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:55:04 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 26/30] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Thu,  8 Dec 2011 18:22:21 +0530
Message-Id: <1323348745-31477-26-git-send-email-ravishankar.km@greenturtles.in>
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
 drivers/staging/comedi/drivers/cb_pcidas.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index f9cb51f..80c981d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1296,9 +1296,8 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	} else {
 		devpriv->adc_fifo_bits |= INT_FHF;	/* interrupt fifo half full */
 	}
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: adc_fifo_bits are 0x%x\n", devpriv->adc_fifo_bits);
-#endif
+	printk(KERN_DEBUG "comedi: adc_fifo_bits are 0x%x\n",
+	       devpriv->adc_fifo_bits);
 	/*  enable (and clear) interrupts */
 	outw(devpriv->adc_fifo_bits | EOAI | INT | LADFUL,
 	     devpriv->control_status + INT_ADCFIFO);
@@ -1322,9 +1321,7 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	if (cmd->convert_src == TRIG_NOW && cmd->chanlist_len > 1)
 		bits |= BURSTE;
 	outw(bits, devpriv->control_status + TRIG_CONTSTAT);
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to trig control\n", bits);
-#endif
+	printk(KERN_DEBUG "comedi: sent 0x%x to trig control\n", bits);
 
 	return 0;
 }
@@ -1539,9 +1536,8 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	/*  enable dac half-full and empty interrupts */
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->adc_fifo_bits |= DAEMIE | DAHFIE;
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: adc_fifo_bits are 0x%x\n", devpriv->adc_fifo_bits);
-#endif
+	printk(KERN_DEBUG "comedi: adc_fifo_bits are 0x%x\n",
+	       devpriv->adc_fifo_bits);
 	/*  enable and clear interrupts */
 	outw(devpriv->adc_fifo_bits | DAEMI | DAHFI,
 	     devpriv->control_status + INT_ADCFIFO);
@@ -1549,9 +1545,8 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	/*  start dac */
 	devpriv->ao_control_bits |= DAC_START | DACEN | DAC_EMPTY;
 	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
-#ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to dac control\n", devpriv->ao_control_bits);
-#endif
+	printk(KERN_DEBUG "comedi: sent 0x%x to dac control\n",
+	       devpriv->ao_control_bits);
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 
 	async->inttrig = NULL;
-- 
1.7.0.4

