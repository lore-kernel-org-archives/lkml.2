Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1GINIj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 09:08:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37027 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1GINIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 09:08:37 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix warning: line over 80 character  issue in s626.c
Date: Sat,  9 Jul 2011 18:50:49 +0530
Message-Id: <1310217649-22537-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/1]Staging: comedi: fix warning: line over 80 character issue in s626.c>
References: <[PATCH 1/1]Staging: comedi: fix warning: line over 80 character issue in s626.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the s626.c file that fixes up a  warning:line over 80 character  found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/s626.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 23fc64b..290d4d8 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -149,7 +149,8 @@ struct s626_private {
 	uint16_t CounterIntEnabs;
 	/* Counter interrupt enable  mask for MISC2 register. */
 	uint8_t AdcItems;	/* Number of items in ADC poll  list. */
-	struct bufferDMA RPSBuf;	/* DMA buffer used to hold ADC (RPS1) program. */
+	/* DMA buffer used to hold ADC (RPS1) program. */
+	struct bufferDMA RPSBuf;
 	struct bufferDMA ANABuf;
 	/* DMA buffer used to receive ADC data and hold DAC data. */
 	uint32_t *pDacWBuf;
@@ -158,7 +159,8 @@ struct s626_private {
 	uint8_t TrimSetpoint[12];	/* Images of TrimDAC setpoints */
 	uint16_t ChargeEnabled;	/* Image of MISC2 Battery */
 	/* Charge Enabled (0 or WRMISC2_CHARGE_ENABLE). */
-	uint16_t WDInterval;	/* Image of MISC2 watchdog interval control bits. */
+	/* Image of MISC2 watchdog interval control bits. */
+	uint16_t WDInterval;
 	uint32_t I2CAdrs;
 	/* I2C device address for onboard EEPROM (board rev dependent). */
 	/*   short         I2Cards; */
@@ -330,8 +332,10 @@ static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
 /*  COUNTER OBJECT ------------------------------------------------ */
 struct enc_private {
 	/*  Pointers to functions that differ for A and B counters: */
-	uint16_t(*GetEnable) (struct comedi_device *dev, struct enc_private *);	/* Return clock enable. */
-	uint16_t(*GetIntSrc) (struct comedi_device *dev, struct enc_private *);	/* Return interrupt source. */
+	/* Return clock enable. */
+	uint16_t(*GetEnable) (struct comedi_device *dev, struct enc_private *);
+	/* Return interrupt source. */
+	uint16_t(*GetIntSrc) (struct comedi_device *dev, struct enc_private *);
 	uint16_t(*GetLoadTrig) (struct comedi_device *dev, struct enc_private *);	/* Return preload trigger source. */
 	uint16_t(*GetMode) (struct comedi_device *dev, struct enc_private *);	/* Return standardized operating mode. */
 	void (*PulseIndex) (struct comedi_device *dev, struct enc_private *);	/* Generate soft index strobe. */
-- 
1.6.5.2

