Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1IBH2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:28:30 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59754 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab1IBH22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:28:28 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Subject: [PATCH 1/2] Staging: comedi: fix line over 80 character issue in s626.c
Date: Fri,  2 Sep 2011 12:58:07 +0530
Message-Id: <1314948487-3475-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 1/2]Staging: comedi: fix line over 80 character issue in s626.c>
References: <[PATCH 1/2]Staging: comedi: fix line over 80 character issue in s626.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the s626.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/s626.c |   89 +++++++++++++++++++++-----------
 1 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 23fc64b..c1e9c51 100644
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
@@ -266,7 +267,11 @@ module_exit(driver_s626_cleanup_module);
 static int s626_ai_insn_config(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data);
-/* static int s626_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
+/*
+ * static int s626_ai_rinsn(struct comedi_device *dev,
+ * struct comedi_subdevice *s, struct comedi_insn *insn,
+ * unsigned int *data);
+ */
 static int s626_ai_insn_read(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data);
@@ -304,7 +309,10 @@ static int s626_ai_inttrig(struct comedi_device *dev,
 			   struct comedi_subdevice *s, unsigned int trignum);
 static irqreturn_t s626_irq_handler(int irq, void *d);
 static unsigned int s626_ai_reg_to_uint(int data);
-/* static unsigned int s626_uint_to_reg(struct comedi_subdevice *s, int data); */
+/*
+ * static unsigned int s626_uint_to_reg(struct comedi_subdevice *s,
+ * int data);
+ */
 
 /* end ioctl routines */
 
@@ -370,7 +378,10 @@ static uint16_t GetEnable_A(struct comedi_device *dev, struct enc_private *k);
 static uint16_t GetEnable_B(struct comedi_device *dev, struct enc_private *k);
 static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
 			   uint16_t value);
-/* static uint16_t GetLatchSource(struct comedi_device *dev, struct enc_private *k ); */
+/*
+ * static uint16_t GetLatchSource(struct comedi_device *dev,
+ * struct enc_private *k );
+ */
 static void SetLoadTrig_A(struct comedi_device *dev, struct enc_private *k,
 			  uint16_t Trig);
 static void SetLoadTrig_B(struct comedi_device *dev, struct enc_private *k,
@@ -405,8 +416,13 @@ static void CountersInit(struct comedi_device *dev);
 #define OVERMASK(C)		(1 << (((C) > 2) ? ((C) * 2 + 5) : ((C) * 2 + 10)))
 #define EVBITS(C)		{ 0, OVERMASK(C), INDXMASK(C), OVERMASK(C) | INDXMASK(C) }
 
-/*  Translation table to map IntSrc into equivalent RDMISC2 event flag  bits. */
-/* static const uint16_t EventBits[][4] = { EVBITS(0), EVBITS(1), EVBITS(2), EVBITS(3), EVBITS(4), EVBITS(5) }; */
+/*
+ * Translation table to map IntSrc into equivalent RDMISC2 event flag  bits.
+ */
+/*
+ * static const uint16_t EventBits[][4] = { EVBITS(0), EVBITS(1), EVBITS(2),
+ * EVBITS(3), EVBITS(4), EVBITS(5) };
+ */
 
 /* struct enc_private; */
 static struct enc_private enc_private_data[] = {
@@ -776,8 +792,10 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		      DEBI_CFG_INTEL | DEBI_CFG_TOQ | DEBI_CFG_INCQ |
 		      DEBI_CFG_16Q);
 
-		/* DEBI INIT S626 WR7146( P_DEBICFG, DEBI_CFG_INTEL | DEBI_CFG_TOQ */
-		/* | DEBI_CFG_INCQ| DEBI_CFG_16Q); //end */
+		/*
+		 * DEBI INIT S626 WR7146( P_DEBICFG, DEBI_CFG_INTEL
+		 * | DEBI_CFG_TOQ | DEBI_CFG_INCQ| DEBI_CFG_16Q); //end
+		 */
 
 		/*  Paging is disabled. */
 		WR7146(P_DEBIPAGE, DEBI_PAGE_DISABLE);	/*  Disable MMU paging. */
@@ -785,24 +803,29 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		/*  Init GPIO so that ADC Start* is negated. */
 		WR7146(P_GPIO, GPIO_BASE | GPIO1_HI);
 
-		/* IsBoardRevA is a boolean that indicates whether the board is RevA.
+		/*
+		 * IsBoardRevA is a boolean that indicates whether the board is
+		 * RevA.
 		 *
-		 * VERSION 2.01 CHANGE: REV A & B BOARDS NOW SUPPORTED BY DYNAMIC
-		 * EEPROM ADDRESS SELECTION.  Initialize the I2C interface, which
-		 * is used to access the onboard serial EEPROM.  The EEPROM's I2C
-		 * DeviceAddress is hardwired to a value that is dependent on the
-		 * 626 board revision.  On all board revisions, the EEPROM stores
-		 * TrimDAC calibration constants for analog I/O.  On RevB and
-		 * higher boards, the DeviceAddress is hardwired to 0 to enable
-		 * the EEPROM to also store the PCI SubVendorID and SubDeviceID;
-		 * this is the address at which the SAA7146 expects a
-		 * configuration EEPROM to reside.  On RevA boards, the EEPROM
-		 * device address, which is hardwired to 4, prevents the SAA7146
-		 * from retrieving PCI sub-IDs, so the SAA7146 uses its built-in
-		 * default values, instead.
+		 * VERSION 2.01 CHANGE: REV A & B BOARDS NOW SUPPORTED BY
+		 * DYNAMIC EEPROM ADDRESS SELECTION.  Initialize the I2C
+		 * interface, which is used to access the onboard serial EEPROM.
+		 * The EEPROM's I2C DeviceAddress is hardwired to a value that
+		 * is dependent on the 626 board revision.  On all board
+		 * revisions, the EEPROM stores TrimDAC calibration constants
+		 * for analog I/O.  On RevB and higher boards, the DeviceAddress
+		 * is hardwired to 0 to enable the EEPROM to also store the PCI
+		 * SubVendorID and SubDeviceID;  this is the address at which
+		 * the SAA7146 expects a configuration EEPROM to reside.
+		 * On RevA boards, the EEPROM device address, which is hardwired
+		 * to 4, prevents the SAA7146 from retrieving PCI sub-IDs,
+		 * so the SAA7146 uses its built-in default values, instead.
 		 */
 
-		/*     devpriv->I2Cards= IsBoardRevA ? 0xA8 : 0xA0; // Set I2C EEPROM */
+		/*
+		 * devpriv->I2Cards= IsBoardRevA ? 0xA8 : 0xA0;
+		 * // Set I2C EEPROM
+		 */
 		/*  DeviceType (0xA0) */
 		/*  and DeviceAddress<<1. */
 
@@ -910,8 +933,10 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		    devpriv->ANABuf.PhysicalBase +
 		    (DAC_WDMABUF_OS * sizeof(uint32_t));
 
-		WR7146(P_BASEA2_OUT, (uint32_t) pPhysBuf);	/*  Buffer base adrs. */
-		WR7146(P_PROTA2_OUT, (uint32_t) (pPhysBuf + sizeof(uint32_t)));	/*  Protection address. */
+		/* Buffer base adrs. */
+		WR7146(P_BASEA2_OUT, (uint32_t) pPhysBuf);
+		/* Protection address. */
+		WR7146(P_PROTA2_OUT, (uint32_t) (pPhysBuf + sizeof(uint32_t)));
 
 		/* Cache Audio2's output DMA buffer logical address.  This is
 		 * where DAC data is buffered for A2 output DMA transfers. */
@@ -930,8 +955,8 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		 * to the DAC devices.  Slot 0 is a NOP that is used to trap TSL
 		 * execution; this permits other slots to be safely modified
 		 * without first turning off the TSL sequencer (which is
-		 * apparently impossible to do).  Also, SD3 (which is driven by a
-		 * pull-up resistor) is shifted in and stored to the MSB of
+		 * apparently impossible to do).  Also, SD3 (which is driven
+		 * by a pull-up resistor) is shifted in and stored to the MSB of
 		 * FB_BUFFER2 to be used as evidence that the slot sequence has
 		 * not yet finished executing.
 		 */
@@ -962,11 +987,13 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		LoadTrimDACs(dev);
 		LoadTrimDACs(dev);	/*  Insurance. */
 
-		/* Manually init all gate array hardware in case this is a soft
+		/*
+		 * Manually init all gate array hardware in case this is a soft
 		 * reset (we have no way of determining whether this is a warm
-		 * or cold start).  This is necessary because the gate array will
-		 * reset only in response to a PCI hard reset; there is no soft
-		 * reset function. */
+		 * or cold start).  This is necessary because the gate array
+		 * will reset only in response to a PCI hard reset; there is no
+		 * soft reset function.
+		 */
 
 		/* Init all DAC outputs to 0V and init all DAC setpoint and
 		 * polarity images.
-- 
1.6.5.2

