Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1LLFVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1LLFVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:44 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 22/29] Staging: comedi: fix printk issue in cb_pcidas.c
Date: Mon, 12 Dec 2011 10:49:34 +0530
Message-Id: <1323667181-17252-22-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<levels>..

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 757c96a..7e4ffcf 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -855,7 +855,8 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 	unsigned int source = data[1];
 
 	if (source >= num_calibration_sources) {
-		printk("invalid calibration source: %i\n", source);
+		dev_err(dev->hw_dev, "invalid calibration source: %i\n",
+			source);
 		return -EINVAL;
 	}
 
@@ -1547,7 +1548,8 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->adc_fifo_bits |= DAEMIE | DAHFIE;
 #ifdef CB_PCIDAS_DEBUG
-	printk("comedi: adc_fifo_bits are 0x%x\n", devpriv->adc_fifo_bits);
+	dev_dbg(dev->hw_dev, "comedi: adc_fifo_bits are 0x%x\n",
+		devpriv->adc_fifo_bits);
 #endif
 	/*  enable and clear interrupts */
 	outw(devpriv->adc_fifo_bits | DAEMI | DAHFI,
@@ -1557,7 +1559,8 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 	devpriv->ao_control_bits |= DAC_START | DACEN | DAC_EMPTY;
 	outw(devpriv->ao_control_bits, devpriv->control_status + DAC_CSR);
 #ifdef CB_PCIDAS_DEBUG
-	printk("comedi: sent 0x%x to dac control\n", devpriv->ao_control_bits);
+	dev_dbg(dev->hw_dev, "comedi: sent 0x%x to dac control\n",
+		devpriv->ao_control_bits);
 #endif
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 
@@ -1585,8 +1588,9 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 
 	s5933_status = inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR);
 #ifdef CB_PCIDAS_DEBUG
-	printk("intcsr 0x%x\n", s5933_status);
-	printk("mbef 0x%x\n", inl(devpriv->s5933_config + AMCC_OP_REG_MBEF));
+	dev_dbg(dev->hw_dev, "intcsr 0x%x\n", s5933_status);
+	dev_dbg(dev->hw_dev, "mbef 0x%x\n",
+		inl(devpriv->s5933_config + AMCC_OP_REG_MBEF));
 #endif
 
 	if ((INTCSR_INTR_ASSERTED & s5933_status) == 0)
-- 
1.7.0.4

