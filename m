Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab1IBHaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:30:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56937 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab1IBHaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:30:20 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Subject: [PATCH 2/2] Staging: comedi: fix line over 80 character issue in s626.c
Date: Fri,  2 Sep 2011 13:00:07 +0530
Message-Id: <1314948607-3508-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 2/2]Staging: comedi:fix warning issue in s626.c>
References: <[PATCH 2/2]Staging: comedi:fix warning issue in s626.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the s626.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/s626.c |   48 ++++++++++++++++++++++----------
 1 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index c1e9c51..5b88cb4 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1007,9 +1007,11 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		 */
 		devpriv->ChargeEnabled = 0;
 
-		/* Init image of watchdog timer interval in WRMISC2.  This image
+		/*
+		 * Init image of watchdog timer interval in WRMISC2.  This image
 		 * maintains the value of the control bits of MISC2 are
-		 * continuously reset to zero as long as the WD timer is disabled.
+		 * continuously reset to zero as long as the WD timer is
+		 * disabled.
 		 */
 		devpriv->WDInterval = 0;
 
@@ -1022,10 +1024,12 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		/*  Init counters. */
 		CountersInit(dev);
 
-		/* Without modifying the state of the Battery Backup enab, disable
-		 * the watchdog timer, set DIO channels 0-5 to operate in the
-		 * standard DIO (vs. counter overflow) mode, disable the battery
-		 * charger, and reset the watchdog interval selector to zero.
+		/*
+		 * Without modifying the state of the Battery Backup enab,
+		 * disable the watchdog timer, set DIO channels 0-5 to operate
+		 * in the standard DIO (vs. counter overflow) mode, disable the
+		 * battery charger, and reset the watchdog interval selector to
+		 * zero.
 		 */
 		WriteMISC2(dev, (uint16_t) (DEBIread(dev,
 						     LP_RDMISC2) &
@@ -1106,16 +1110,19 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 		s = dev->subdevices;
 		cmd = &(s->async->cmd);
 
-		/* Init ptr to DMA buffer that holds new ADC data.  We skip the
-		 * first uint16_t in the buffer because it contains junk data from
-		 * the final ADC of the previous poll list scan.
+		/*
+		 * Init ptr to DMA buffer that holds new ADC data.  We skip the
+		 * first uint16_t in the buffer because it contains junk data
+		 * from the final ADC of the previous poll list scan.
 		 */
 		readaddr = (int32_t *) devpriv->ANABuf.LogicalBase + 1;
 
 		/*  get the data and hand it over to comedi */
 		for (i = 0; i < (s->async->cmd.chanlist_len); i++) {
-			/*  Convert ADC data to 16-bit integer values and copy to application */
-			/*  buffer. */
+			/*
+			 * Convert ADC data to 16-bit integer values and copy to
+			 * application buffer.
+			 */
 			tempdata = s626_ai_reg_to_uint((int)*readaddr);
 			readaddr++;
 
@@ -1224,7 +1231,10 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->scan_begin_arg);
 
-						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
+						/*
+						 * Trigger ADC scan loop start
+						 * by setting RPS Signal 0.
+						 */
 						MC_ENABLE(P_MC2, MC2_ADC_RPS);
 
 						DEBUG
@@ -1266,7 +1276,10 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->convert_arg);
 
-						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
+						/*
+						 * Trigger ADC scan loop start
+						 * by setting RPS Signal 0.
+						 */
 						MC_ENABLE(P_MC2, MC2_ADC_RPS);
 
 						DEBUG
@@ -1369,7 +1382,10 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 				DEBUG
 				    ("s626_irq_handler: scan timer trigger!!!\n");
 
-				/*  Trigger ADC scan loop start by setting RPS Signal 0. */
+				/*
+				 * Trigger ADC scan loop start
+				 * by setting RPS Signal 0.
+				 */
 				MC_ENABLE(P_MC2, MC2_ADC_RPS);
 			}
 
@@ -1401,7 +1417,9 @@ static int s626_detach(struct comedi_device *dev)
 		if (devpriv->base_addr) {
 			/* interrupt mask */
 			WR7146(P_IER, 0);	/*  Disable master interrupt. */
-			WR7146(P_ISR, IRQ_GPIO3 | IRQ_RPS1);	/*  Clear board's IRQ status flag. */
+
+			/* Clear board's IRQ status flag. */
+			WR7146(P_ISR, IRQ_GPIO3 | IRQ_RPS1);
 
 			/*  Disable the watchdog timer and battery charger. */
 			WriteMISC2(dev, 0);
-- 
1.6.5.2

