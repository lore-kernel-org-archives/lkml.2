Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0LQIvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 03:51:44 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60657 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab0LQIvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 03:51:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZctldxJpgGFDyA7fAjYsPj/pw5MF/J65nTghWxdJ6bxus+1UhpGhrdiKc380iCVvyF
         tvazXbkX+yowCBHUFPYzGW4Dac5pD3yVUqoAy3WH+96gpnSZVlRq2z4LMxu4SpCHU0xY
         W6hcZud9lvIEYR05RDge/SaMqSyvoKTe50NSI=
From: Xenofon Foukas <foukas.xenofon@gmail.com>
To: gregkh@suse.de, john.d.sheehan@gmail.com, u.kleine-koenig@pengutronix.de,
        arun.thomas@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Xenofon Foukas <foukas.xenofon@gmail.com>
Subject: [PATCH 2/2] Fix checkpatch issues in file s626.c
Date: Fri, 17 Dec 2010 10:51:33 +0200
Message-Id: <1292575893-17677-1-git-send-email-foukas.xenofon@gmail.com>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes line over 80 characters warnings
in file s626.c
Signed-off-by: Xenofon Foukas <foukas.xenofon@gmail.com>
---
 drivers/staging/comedi/drivers/s626.c |  652 ++++++++++++++++++++------------
 1 files changed, 407 insertions(+), 245 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index d5ba3ab..fcda2cc 100644
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
@@ -158,7 +159,7 @@ struct s626_private {
 	uint8_t TrimSetpoint[12];	/* Images of TrimDAC setpoints */
 	uint16_t ChargeEnabled;	/* Image of MISC2 Battery */
 	/* Charge Enabled (0 or WRMISC2_CHARGE_ENABLE). */
-	uint16_t WDInterval;	/* Image of MISC2 watchdog interval control bits. */
+	uint16_t WDInterval;/* Image of MISC2 watchdog interval control bits. */
 	uint32_t I2CAdrs;
 	/* I2C device address for onboard EEPROM (board rev dependent). */
 	/*   short         I2Cards; */
@@ -266,7 +267,8 @@ module_exit(driver_s626_cleanup_module);
 static int s626_ai_insn_config(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data);
-/* static int s626_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
+/* static int s626_ai_rinsn(struct comedi_device *dev,
+   struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
 static int s626_ai_insn_read(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data);
@@ -304,7 +306,8 @@ static int s626_ai_inttrig(struct comedi_device *dev,
 			   struct comedi_subdevice *s, unsigned int trignum);
 static irqreturn_t s626_irq_handler(int irq, void *d);
 static unsigned int s626_ai_reg_to_uint(int data);
-/* static unsigned int s626_uint_to_reg(struct comedi_subdevice *s, int data); */
+/* static unsigned int s626_uint_to_reg(struct comedi_subdevice *s,
+					int data); */
 
 /* end ioctl routines */
 
@@ -330,22 +333,38 @@ static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
 /*  COUNTER OBJECT ------------------------------------------------ */
 struct enc_private {
 	/*  Pointers to functions that differ for A and B counters: */
-	uint16_t(*GetEnable) (struct comedi_device *dev, struct enc_private *);	/* Return clock enable. */
-	uint16_t(*GetIntSrc) (struct comedi_device *dev, struct enc_private *);	/* Return interrupt source. */
-	uint16_t(*GetLoadTrig) (struct comedi_device *dev, struct enc_private *);	/* Return preload trigger source. */
-	uint16_t(*GetMode) (struct comedi_device *dev, struct enc_private *);	/* Return standardized operating mode. */
-	void (*PulseIndex) (struct comedi_device *dev, struct enc_private *);	/* Generate soft index strobe. */
-	void (*SetEnable) (struct comedi_device *dev, struct enc_private *, uint16_t enab);	/* Program clock enable. */
-	void (*SetIntSrc) (struct comedi_device *dev, struct enc_private *, uint16_t IntSource);	/* Program interrupt source. */
-	void (*SetLoadTrig) (struct comedi_device *dev, struct enc_private *, uint16_t Trig);	/* Program preload trigger source. */
-	void (*SetMode) (struct comedi_device *dev, struct enc_private *, uint16_t Setup, uint16_t DisableIntSrc);	/* Program standardized operating mode. */
-	void (*ResetCapFlags) (struct comedi_device *dev, struct enc_private *);	/* Reset event capture flags. */
+
+	/* Return clock enable. */
+	uint16_t(*GetEnable) (struct comedi_device *dev, struct enc_private *);
+	/* Return interrupt source. */
+	uint16_t(*GetIntSrc) (struct comedi_device *dev, struct enc_private *);
+	/* Return preload trigger source. */
+	uint16_t(*GetLoadTrig) (struct comedi_device *dev,
+					struct enc_private *);
+	/* Return standardized operating mode. */
+	uint16_t(*GetMode) (struct comedi_device *dev, struct enc_private *);
+	/* Generate soft index strobe. */
+	void (*PulseIndex) (struct comedi_device *dev, struct enc_private *);
+	/* Program clock enable. */
+	void (*SetEnable) (struct comedi_device *dev, struct enc_private *,
+							uint16_t enab);
+	/* Program interrupt source. */
+	void (*SetIntSrc) (struct comedi_device *dev, struct enc_private *,
+						uint16_t IntSource);
+	/* Program preload trigger source. */
+	void (*SetLoadTrig) (struct comedi_device *dev, struct enc_private *,
+							uint16_t Trig);
+	/* Program standardized operating mode. */
+	void (*SetMode) (struct comedi_device *dev, struct enc_private *,
+			uint16_t Setup, uint16_t DisableIntSrc);
+	/* Reset event capture flags. */
+	void (*ResetCapFlags) (struct comedi_device *dev, struct enc_private *);
 
 	uint16_t MyCRA;		/*    Address of CRA register. */
 	uint16_t MyCRB;		/*    Address of CRB register. */
 	uint16_t MyLatchLsw;	/*    Address of Latch least-significant-word */
 	/*    register. */
-	uint16_t MyEventBits[4];	/*    Bit translations for IntSrc -->RDMISC2. */
+	uint16_t MyEventBits[4];/*    Bit translations for IntSrc -->RDMISC2. */
 };
 
 #define encpriv ((struct enc_private *)(dev->subdevices+5)->private)
@@ -370,7 +389,8 @@ static uint16_t GetEnable_A(struct comedi_device *dev, struct enc_private *k);
 static uint16_t GetEnable_B(struct comedi_device *dev, struct enc_private *k);
 static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
 			   uint16_t value);
-/* static uint16_t GetLatchSource(struct comedi_device *dev, struct enc_private *k ); */
+/* static uint16_t GetLatchSource(struct comedi_device *dev,
+				struct enc_private *k ); */
 static void SetLoadTrig_A(struct comedi_device *dev, struct enc_private *k,
 			  uint16_t Trig);
 static void SetLoadTrig_B(struct comedi_device *dev, struct enc_private *k,
@@ -383,14 +403,22 @@ static void SetIntSrc_A(struct comedi_device *dev, struct enc_private *k,
 			uint16_t IntSource);
 static uint16_t GetIntSrc_A(struct comedi_device *dev, struct enc_private *k);
 static uint16_t GetIntSrc_B(struct comedi_device *dev, struct enc_private *k);
-/* static void SetClkMult(struct comedi_device *dev, struct enc_private *k, uint16_t value ) ; */
-/* static uint16_t GetClkMult(struct comedi_device *dev, struct enc_private *k ) ; */
-/* static void SetIndexPol(struct comedi_device *dev, struct enc_private *k, uint16_t value ); */
-/* static uint16_t GetClkPol(struct comedi_device *dev, struct enc_private *k ) ; */
-/* static void SetIndexSrc( struct comedi_device *dev,struct enc_private *k, uint16_t value );  */
-/* static uint16_t GetClkSrc( struct comedi_device *dev,struct enc_private *k );  */
-/* static void SetIndexSrc( struct comedi_device *dev,struct enc_private *k, uint16_t value );  */
-/* static uint16_t GetIndexSrc( struct comedi_device *dev,struct enc_private *k );  */
+/* static void SetClkMult(struct comedi_device *dev, struct enc_private *k,
+							uint16_t value ) ; */
+/* static uint16_t GetClkMult(struct comedi_device *dev,
+						struct enc_private *k ) ; */
+/* static void SetIndexPol(struct comedi_device *dev, struct enc_private *k,
+							uint16_t value ); */
+/* static uint16_t GetClkPol(struct comedi_device *dev,
+						struct enc_private *k ) ; */
+/* static void SetIndexSrc( struct comedi_device *dev,struct enc_private *k,
+							uint16_t value );  */
+/* static uint16_t GetClkSrc( struct comedi_device *dev,
+					struct enc_private *k );*/
+/* static void SetIndexSrc( struct comedi_device *dev,struct enc_private *k,
+							uint16_t value );  */
+/* static uint16_t GetIndexSrc( struct comedi_device *dev,
+						struct enc_private *k );  */
 static void PulseIndex_A(struct comedi_device *dev, struct enc_private *k);
 static void PulseIndex_B(struct comedi_device *dev, struct enc_private *k);
 static void Preload(struct comedi_device *dev, struct enc_private *k,
@@ -401,12 +429,14 @@ static void CountersInit(struct comedi_device *dev);
 /*  Counter objects constructor. */
 
 /*  Counter overflow/index event flag masks for RDMISC2. */
-#define INDXMASK(C)		(1 << (((C) > 2) ? ((C) * 2 - 1) : ((C) * 2 +  4)))
-#define OVERMASK(C)		(1 << (((C) > 2) ? ((C) * 2 + 5) : ((C) * 2 + 10)))
-#define EVBITS(C)		{ 0, OVERMASK(C), INDXMASK(C), OVERMASK(C) | INDXMASK(C) }
+#define INDXMASK(C)	(1 << (((C) > 2) ? ((C) * 2 - 1) : ((C) * 2 +  4)))
+#define OVERMASK(C)	(1 << (((C) > 2) ? ((C) * 2 + 5) : ((C) * 2 + 10)))
+#define EVBITS(C) \
+{ 0, OVERMASK(C), INDXMASK(C), OVERMASK(C) | INDXMASK(C) }
 
 /*  Translation table to map IntSrc into equivalent RDMISC2 event flag  bits. */
-/* static const uint16_t EventBits[][4] = { EVBITS(0), EVBITS(1), EVBITS(2), EVBITS(3), EVBITS(4), EVBITS(5) }; */
+/* static const uint16_t EventBits[][4] = { EVBITS(0), EVBITS(1), EVBITS(2),
+					EVBITS(3), EVBITS(4), EVBITS(5) }; */
 
 /* struct enc_private; */
 static struct enc_private enc_private_data[] = {
@@ -510,11 +540,15 @@ static struct enc_private enc_private_data[] = {
 
 /*  enab/disable a function or test status bit(s) that are accessed */
 /*  through Main Control Registers 1 or 2. */
-#define MC_ENABLE(REGADRS, CTRLWORD)	writel(((uint32_t)(CTRLWORD) << 16) | (uint32_t)(CTRLWORD), devpriv->base_addr+(REGADRS))
+#define MC_ENABLE(REGADRS, CTRLWORD) \
+writel(((uint32_t)(CTRLWORD) << 16) | \
+(uint32_t)(CTRLWORD), devpriv->base_addr+(REGADRS))
 
-#define MC_DISABLE(REGADRS, CTRLWORD)	writel((uint32_t)(CTRLWORD) << 16 , devpriv->base_addr+(REGADRS))
+#define MC_DISABLE(REGADRS, CTRLWORD) \
+writel((uint32_t)(CTRLWORD) << 16 , devpriv->base_addr+(REGADRS))
 
-#define MC_TEST(REGADRS, CTRLWORD)	((readl(devpriv->base_addr+(REGADRS)) & CTRLWORD) != 0)
+#define MC_TEST(REGADRS, CTRLWORD) \
+((readl(devpriv->base_addr+(REGADRS)) & CTRLWORD) != 0)
 
 /* #define WR7146(REGARDS,CTRLWORD)
     writel(CTRLWORD,(uint32_t)(devpriv->base_addr+(REGARDS))) */
@@ -621,8 +655,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		devpriv->ANABuf.PhysicalBase = appdma;
 
-		DEBUG
-		    ("s626_attach: AllocDMAB ADC Logical=%p, bsize=%d, Physical=0x%x\n",
+		printk(KERN_DEBUG "s626_attach: AllocDMAB ADC Logical=%p, bsize=%d, Physical=0x%x\n",
 		     devpriv->ANABuf.LogicalBase, DMABUF_SIZE,
 		     (uint32_t) devpriv->ANABuf.PhysicalBase);
 
@@ -638,8 +671,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		devpriv->RPSBuf.PhysicalBase = appdma;
 
-		DEBUG
-		    ("s626_attach: AllocDMAB RPS Logical=%p, bsize=%d, Physical=0x%x\n",
+		printk(KERN_DEBUG "s626_attach: AllocDMAB RPS Logical=%p, bsize=%d, Physical=0x%x\n",
 		     devpriv->RPSBuf.LogicalBase, DMABUF_SIZE,
 		     (uint32_t) devpriv->RPSBuf.PhysicalBase);
 
@@ -776,22 +808,26 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		      DEBI_CFG_INTEL | DEBI_CFG_TOQ | DEBI_CFG_INCQ |
 		      DEBI_CFG_16Q);
 
-		/* DEBI INIT S626 WR7146( P_DEBICFG, DEBI_CFG_INTEL | DEBI_CFG_TOQ */
+		/* DEBI INIT S626 WR7146( P_DEBICFG, DEBI_CFG_INTEL |
+							DEBI_CFG_TOQ */
 		/* | DEBI_CFG_INCQ| DEBI_CFG_16Q); //end */
 
 		/*  Paging is disabled. */
-		WR7146(P_DEBIPAGE, DEBI_PAGE_DISABLE);	/*  Disable MMU paging. */
+		/*  Disable MMU paging. */
+		WR7146(P_DEBIPAGE, DEBI_PAGE_DISABLE);
 
 		/*  Init GPIO so that ADC Start* is negated. */
 		WR7146(P_GPIO, GPIO_BASE | GPIO1_HI);
 
-		/* IsBoardRevA is a boolean that indicates whether the board is RevA.
+		/* IsBoardRevA is a boolean that indicates whether the board
+		 * is RevA.
 		 *
-		 * VERSION 2.01 CHANGE: REV A & B BOARDS NOW SUPPORTED BY DYNAMIC
-		 * EEPROM ADDRESS SELECTION.  Initialize the I2C interface, which
-		 * is used to access the onboard serial EEPROM.  The EEPROM's I2C
-		 * DeviceAddress is hardwired to a value that is dependent on the
-		 * 626 board revision.  On all board revisions, the EEPROM stores
+		 * VERSION 2.01 CHANGE: REV A & B BOARDS NOW SUPPORTED BY
+		 * DYNAMIC EEPROM ADDRESS SELECTION.  Initialize the I2C
+		 * interface, which is used to access the onboard serial
+		 * EEPROM.  The EEPROM's I2C DeviceAddress is hardwired to
+		 * a value that is dependent on the 626 board revision.
+		 * On all board revisions, the EEPROM stores
 		 * TrimDAC calibration constants for analog I/O.  On RevB and
 		 * higher boards, the DeviceAddress is hardwired to 0 to enable
 		 * the EEPROM to also store the PCI SubVendorID and SubDeviceID;
@@ -802,11 +838,12 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		 * default values, instead.
 		 */
 
-		/*     devpriv->I2Cards= IsBoardRevA ? 0xA8 : 0xA0; // Set I2C EEPROM */
+		/*     devpriv->I2Cards= IsBoardRevA ? 0xA8 : 0xA0;
+			// Set I2C EEPROM */
 		/*  DeviceType (0xA0) */
 		/*  and DeviceAddress<<1. */
 
-		devpriv->I2CAdrs = 0xA0;	/*  I2C device address for onboard */
+		devpriv->I2CAdrs = 0xA0; /*I2C device address for onboard */
 		/*  eeprom(revb) */
 
 		/*  Issue an I2C ABORT command to halt any I2C operation in */
@@ -824,7 +861,8 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		for (i = 0; i < 2; i++) {
 			WR7146(P_I2CSTAT, I2C_CLKSEL);
 			/*  Write I2C control: reset  error flags. */
-			MC_ENABLE(P_MC2, MC2_UPLD_IIC);	/*  Invoke command upload */
+			/*  Invoke command upload */
+			MC_ENABLE(P_MC2, MC2_UPLD_IIC);
 			while (!MC_TEST(P_MC2, MC2_UPLD_IIC))
 				;
 			/* and wait for upload to complete. */
@@ -910,8 +948,10 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		    devpriv->ANABuf.PhysicalBase +
 		    (DAC_WDMABUF_OS * sizeof(uint32_t));
 
-		WR7146(P_BASEA2_OUT, (uint32_t) pPhysBuf);	/*  Buffer base adrs. */
-		WR7146(P_PROTA2_OUT, (uint32_t) (pPhysBuf + sizeof(uint32_t)));	/*  Protection address. */
+		/*  Buffer base adrs. */
+		WR7146(P_BASEA2_OUT, (uint32_t) pPhysBuf);
+		/*  Protection address. */
+		WR7146(P_PROTA2_OUT, (uint32_t) (pPhysBuf + sizeof(uint32_t)));
 
 		/* Cache Audio2's output DMA buffer logical address.  This is
 		 * where DAC data is buffered for A2 output DMA transfers. */
@@ -930,7 +970,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		 * to the DAC devices.  Slot 0 is a NOP that is used to trap TSL
 		 * execution; this permits other slots to be safely modified
 		 * without first turning off the TSL sequencer (which is
-		 * apparently impossible to do).  Also, SD3 (which is driven by a
+		 * apparently impossible to do). Also, SD3 (which is driven by a
 		 * pull-up resistor) is shifted in and stored to the MSB of
 		 * FB_BUFFER2 to be used as evidence that the slot sequence has
 		 * not yet finished executing.
@@ -964,7 +1004,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		/* Manually init all gate array hardware in case this is a soft
 		 * reset (we have no way of determining whether this is a warm
-		 * or cold start).  This is necessary because the gate array will
+		 * or cold start).This is necessary because the gate array will
 		 * reset only in response to a PCI hard reset; there is no soft
 		 * reset function. */
 
@@ -980,9 +1020,10 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		 */
 		devpriv->ChargeEnabled = 0;
 
-		/* Init image of watchdog timer interval in WRMISC2.  This image
+		/* Init image of watchdog timer interval in WRMISC2.This image
 		 * maintains the value of the control bits of MISC2 are
-		 * continuously reset to zero as long as the WD timer is disabled.
+		 * continuously reset to zero as long as the WD timer
+		 * is disabled
 		 */
 		devpriv->WDInterval = 0;
 
@@ -995,10 +1036,11 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		/*  Init counters. */
 		CountersInit(dev);
 
-		/* Without modifying the state of the Battery Backup enab, disable
-		 * the watchdog timer, set DIO channels 0-5 to operate in the
-		 * standard DIO (vs. counter overflow) mode, disable the battery
-		 * charger, and reset the watchdog interval selector to zero.
+		/* Without modifying the state of the Battery Backup enab,
+		 * the watchdog timer, set DIO channels 0-5 to operate in
+		 * the standard DIO (vs. counter overflow) mode, disable
+		 * the battery charger, and reset the watchdog interval
+		 * selector to zero.
 		 */
 		WriteMISC2(dev, (uint16_t) (DEBIread(dev,
 						     LP_RDMISC2) &
@@ -1030,7 +1072,8 @@ static unsigned int s626_ai_reg_to_uint(int data)
 	return tempdata;
 }
 
-/* static unsigned int s626_uint_to_reg(struct comedi_subdevice *s, int data){ */
+/* static unsigned int s626_uint_to_reg(struct comedi_subdevice *s,
+							int data){ */
 /*   return 0; */
 /* } */
 
@@ -1080,14 +1123,15 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 		cmd = &(s->async->cmd);
 
 		/* Init ptr to DMA buffer that holds new ADC data.  We skip the
-		 * first uint16_t in the buffer because it contains junk data from
-		 * the final ADC of the previous poll list scan.
+		 * first uint16_t in the buffer because it contains
+		 * junk data from the final ADC of the previous poll list scan.
 		 */
 		readaddr = (int32_t *) devpriv->ANABuf.LogicalBase + 1;
 
 		/*  get the data and hand it over to comedi */
 		for (i = 0; i < (s->async->cmd.chanlist_len); i++) {
-			/*  Convert ADC data to 16-bit integer values and copy to application */
+			/*  Convert ADC data to 16-bit integer values
+			    and copy to application */
 			/*  buffer. */
 			tempdata = s626_ai_reg_to_uint((int)*readaddr);
 			readaddr++;
@@ -1095,8 +1139,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 			/* put data into read buffer */
 			/*  comedi_buf_put(s->async, tempdata); */
 			if (cfc_write_to_buffer(s, tempdata) == 0)
-				printk
-				    ("s626_irq_handler: cfc_write_to_buffer error!\n");
+				printk(KERN_WARNING "s626_irq_handler: cfc_write_to_buffer error!\n");
 
 			DEBUG("s626_irq_handler: ai channel %d acquired: %d\n",
 			      i, tempdata);
@@ -1120,9 +1163,9 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 			irqstatus = 0;
 		}
 
-		if (devpriv->ai_cmd_running && cmd->scan_begin_src == TRIG_EXT) {
-			DEBUG
-			    ("s626_irq_handler: enable interrupt on dio channel %d\n",
+		if (devpriv->ai_cmd_running && cmd->scan_begin_src ==
+								TRIG_EXT) {
+			printk(KERN_DEBUG "s626_irq_handler: enable interrupt on dio channel %d\n",
 			     cmd->scan_begin_arg);
 
 			s626_dio_set_irq(dev, cmd->scan_begin_arg);
@@ -1156,36 +1199,34 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 			/* check if interrupt is generated from dio channels */
 			if (irqbit) {
 				s626_dio_reset_irq(dev, group, irqbit);
-				DEBUG
-				    ("s626_irq_handler: check interrupt on dio group %d %d\n",
+				printk(KERN_DEBUG "s626_irq_handler: check interrupt on dio group %d %d\n",
 				     group, i);
 				if (devpriv->ai_cmd_running) {
-					/* check if interrupt is an ai acquisition start trigger */
+					/* check if interrupt is
+					   an ai acquisition start trigger */
 					if ((irqbit >> (cmd->start_arg -
 							(16 * group)))
-					    == 1 && cmd->start_src == TRIG_EXT) {
-						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+					    == 1 && cmd->start_src
+						== TRIG_EXT) {
+						printk(KERN_DEBUG "s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
 						     cmd->start_arg);
 
-						/*  Start executing the RPS program. */
+						/*  Start executing
+						    the RPS program. */
 						MC_ENABLE(P_MC1, MC1_ERPS1);
 
-						DEBUG
-						    ("s626_irq_handler: aquisition start triggered!!!\n");
+						printk(KERN_DEBUG "s626_irq_handler: aquisition start triggered!!!\n");
 
 						if (cmd->scan_begin_src ==
 						    TRIG_EXT) {
-							DEBUG
-							    ("s626_ai_cmd: enable interrupt on dio channel %d\n",
+							printk(KERN_DEBUG "s626_ai_cmd: enable interrupt on dio channel %d\n",
 							     cmd->
 							     scan_begin_arg);
 
 							s626_dio_set_irq(dev,
-									 cmd->scan_begin_arg);
+							  cmd->scan_begin_arg);
 
-							DEBUG
-							    ("s626_irq_handler: External scan trigger is set!!!\n");
+							printk(KERN_DEBUG "s626_irq_handler: External scan trigger is set!!!\n");
 						}
 					}
 					if ((irqbit >> (cmd->scan_begin_arg -
@@ -1193,74 +1234,70 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					    == 1
 					    && cmd->scan_begin_src ==
 					    TRIG_EXT) {
-						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						printk(KERN_DEBUG "s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
 						     cmd->scan_begin_arg);
 
-						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
+						/*  Trigger ADC scan loop start
+						    by setting RPS Signal 0. */
 						MC_ENABLE(P_MC2, MC2_ADC_RPS);
 
-						DEBUG
-						    ("s626_irq_handler: scan triggered!!! %d\n",
+						printk(KERN_DEBUG "s626_irq_handler: scan triggered!!! %d\n",
 						     devpriv->ai_sample_count);
 						if (cmd->convert_src ==
 						    TRIG_EXT) {
 
-							DEBUG
-							    ("s626_ai_cmd: enable interrupt on dio channel %d group %d\n",
+							printk(KERN_DEBUG "s626_ai_cmd: enable interrupt on dio channel %d group %d\n",
 							     cmd->convert_arg -
 							     (16 * group),
 							     group);
 
-							devpriv->ai_convert_count
+							devpriv->
+							       ai_convert_count
 							    = cmd->chanlist_len;
 
 							s626_dio_set_irq(dev,
-									 cmd->convert_arg);
+							     cmd->convert_arg);
 
-							DEBUG
-							    ("s626_irq_handler: External convert trigger is set!!!\n");
+							printk(KERN_DEBUG "s626_irq_handler: External convert trigger is set!!!\n");
 						}
 
 						if (cmd->convert_src ==
-						    TRIG_TIMER) {
+							TRIG_TIMER) {
 							k = &encpriv[5];
-							devpriv->ai_convert_count
+							devpriv->
+								ai_convert_count
 							    = cmd->chanlist_len;
 							k->SetEnable(dev, k,
-								     CLKENAB_ALWAYS);
+							       CLKENAB_ALWAYS);
 						}
 					}
 					if ((irqbit >> (cmd->convert_arg -
 							(16 * group)))
 					    == 1
 					    && cmd->convert_src == TRIG_EXT) {
-						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						printk(KERN_DEBUG "s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
 						     cmd->convert_arg);
 
-						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
+						/*  Trigger ADC scan loop start
+						    by setting RPS Signal 0. */
 						MC_ENABLE(P_MC2, MC2_ADC_RPS);
 
-						DEBUG
-						    ("s626_irq_handler: adc convert triggered!!!\n");
+						printk(KERN_DEBUG "s626_irq_handler: adc convert triggered!!!\n");
 
 						devpriv->ai_convert_count--;
 
 						if (devpriv->ai_convert_count >
 						    0) {
 
-							DEBUG
-							    ("s626_ai_cmd: enable interrupt on dio channel %d group %d\n",
+							printk(KERN_DEBUG "s626_ai_cmd: enable interrupt on dio channel %d group %d\n",
 							     cmd->convert_arg -
 							     (16 * group),
 							     group);
 
 							s626_dio_set_irq(dev,
-									 cmd->convert_arg);
+							     cmd->convert_arg);
 
-							DEBUG
-							    ("s626_irq_handler: External trigger is set!!!\n");
+							printk(KERN_DEBUG "s626_irq_handler: External trigger is set!!!\n");
 						}
 					}
 				}
@@ -1276,40 +1313,35 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 		      irqbit);
 
 		if (irqbit & IRQ_COINT1A) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 1A overflow\n");
+			printk(KERN_DEBUG "s626_irq_handler: interrupt on counter 1A overflow\n");
 			k = &encpriv[0];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 		}
 		if (irqbit & IRQ_COINT2A) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 2A overflow\n");
+			printk(KERN_DEBUG "s626_irq_handler: interrupt on counter 2A overflow\n");
 			k = &encpriv[1];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 		}
 		if (irqbit & IRQ_COINT3A) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 3A overflow\n");
+			printk(KERN_DEBUG "s626_irq_handler: interrupt on counter 3A overflow\n");
 			k = &encpriv[2];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 		}
 		if (irqbit & IRQ_COINT1B) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 1B overflow\n");
+			printk(KERN_DEBUG "s626_irq_handler: interrupt on counter 1B overflow\n");
 			k = &encpriv[3];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 		}
 		if (irqbit & IRQ_COINT2B) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 2B overflow\n");
+			printk(KERN_DEBUG "s626_irq_handler: interrupt on counter 2B overflow\n");
 			k = &encpriv[4];
 
 			/* clear interrupt capture flag */
@@ -1321,34 +1353,32 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					k->SetEnable(dev, k, CLKENAB_INDEX);
 
 				if (cmd->convert_src == TRIG_TIMER) {
-					DEBUG
-					    ("s626_irq_handler: conver timer trigger!!! %d\n",
+					printk(KERN_DEBUG "s626_irq_handler: conver timer trigger!!! %d\n",
 					     devpriv->ai_convert_count);
 
-					/*  Trigger ADC scan loop start by setting RPS Signal 0. */
+					/*  Trigger ADC scan loop start by
+					    setting RPS Signal 0. */
 					MC_ENABLE(P_MC2, MC2_ADC_RPS);
 				}
 			}
 		}
 		if (irqbit & IRQ_COINT3B) {
-			DEBUG
-			    ("s626_irq_handler: interrupt on counter 3B overflow\n");
+			printk(KERN_DEBUG "s626_irq_handler: interrupt on counter 3B overflow\n");
 			k = &encpriv[5];
 
 			/* clear interrupt capture flag */
 			k->ResetCapFlags(dev, k);
 
 			if (cmd->scan_begin_src == TRIG_TIMER) {
-				DEBUG
-				    ("s626_irq_handler: scan timer trigger!!!\n");
+				printk(KERN_DEBUG "s626_irq_handler: scan timer trigger!!!\n");
 
-				/*  Trigger ADC scan loop start by setting RPS Signal 0. */
+				/*  Trigger ADC scan loop start
+				    by setting RPS Signal 0. */
 				MC_ENABLE(P_MC2, MC2_ADC_RPS);
 			}
 
 			if (cmd->convert_src == TRIG_TIMER) {
-				DEBUG
-				    ("s626_irq_handler: convert timer trigger is set\n");
+				printk(KERN_DEBUG "s626_irq_handler: convert timer trigger is set\n");
 				k = &encpriv[4];
 				devpriv->ai_convert_count = cmd->chanlist_len;
 				k->SetEnable(dev, k, CLKENAB_ALWAYS);
@@ -1373,8 +1403,9 @@ static int s626_detach(struct comedi_device *dev)
 
 		if (devpriv->base_addr) {
 			/* interrupt mask */
-			WR7146(P_IER, 0);	/*  Disable master interrupt. */
-			WR7146(P_ISR, IRQ_GPIO3 | IRQ_RPS1);	/*  Clear board's IRQ status flag. */
+			WR7146(P_IER, 0);   /*  Disable master interrupt. */
+			/*  Clear board's IRQ status flag. */
+			WR7146(P_ISR, IRQ_GPIO3 | IRQ_RPS1);
 
 			/*  Disable the watchdog timer and battery charger. */
 			WriteMISC2(dev, 0);
@@ -1461,7 +1492,8 @@ void ResetADC(struct comedi_device *dev, uint8_t * ppl)
 	 * for loop to limit the slot count to 16 in case the application
 	 * forgot to set the EOPL flag in the final slot.
 	 */
-	for (devpriv->AdcItems = 0; devpriv->AdcItems < 16; devpriv->AdcItems++) {
+	for (devpriv->AdcItems = 0; devpriv->AdcItems < 16;
+						devpriv->AdcItems++) {
 		/* Convert application's poll list item to private board class
 		 * format.  Each app poll list item is an uint8_t with form
 		 * (EOPL,x,x,RANGE,CHAN<3:0>), where RANGE code indicates 0 =
@@ -1472,7 +1504,8 @@ void ResetADC(struct comedi_device *dev, uint8_t * ppl)
 				   GSEL_BIPOLAR10V);
 
 		/*  Switch ADC analog gain. */
-		*pRPS++ = RPS_LDREG | (P_DEBICMD >> 2);	/*  Write DEBI command */
+		/*  Write DEBI command */
+		*pRPS++ = RPS_LDREG | (P_DEBICMD >> 2);
 		/*  and address to */
 		/*  shadow RAM. */
 		*pRPS++ = DEBI_CMD_WRWORD | LP_GSEL;
@@ -1480,9 +1513,10 @@ void ResetADC(struct comedi_device *dev, uint8_t * ppl)
 		/*  immediate data to */
 		/*  shadow RAM. */
 		*pRPS++ = LocalPPL;
-		*pRPS++ = RPS_CLRSIGNAL | RPS_DEBI;	/*  Reset "shadow RAM uploaded" */
+		/*Reset "shadow RAM uploaded"*/
+		*pRPS++ = RPS_CLRSIGNAL | RPS_DEBI;
 		/*  flag. */
-		*pRPS++ = RPS_UPLOAD | RPS_DEBI;	/*  Invoke shadow RAM upload. */
+		*pRPS++ = RPS_UPLOAD | RPS_DEBI;/*  Invoke shadow RAM upload. */
 		*pRPS++ = RPS_PAUSE | RPS_DEBI;	/*  Wait for shadow upload to */
 		/*  finish. */
 
@@ -1514,7 +1548,7 @@ void ResetADC(struct comedi_device *dev, uint8_t * ppl)
 				(unsigned long)devpriv->RPSBuf.LogicalBase);
 		for (i = 0; i < (10 * RPSCLK_PER_US / 2); i++) {
 			JmpAdrs += 8;	/*  Repeat to implement time delay: */
-			*pRPS++ = RPS_JUMP;	/*  Jump to next RPS instruction. */
+			*pRPS++ = RPS_JUMP;/*  Jump to next RPS instruction. */
 			*pRPS++ = JmpAdrs;
 		}
 
@@ -1525,29 +1559,34 @@ void ResetADC(struct comedi_device *dev, uint8_t * ppl)
 			*pRPS++ = RPS_CLRSIGNAL | RPS_SIGADC;
 		}
 		/*  Start ADC by pulsing GPIO1. */
-		*pRPS++ = RPS_LDREG | (P_GPIO >> 2);	/*  Begin ADC Start pulse. */
+		/*  Begin ADC Start pulse. */
+		*pRPS++ = RPS_LDREG | (P_GPIO >> 2);
 		*pRPS++ = GPIO_BASE | GPIO1_LO;
 		*pRPS++ = RPS_NOP;
 		/*  VERSION 2.03 CHANGE: STRETCH OUT ADC START PULSE. */
-		*pRPS++ = RPS_LDREG | (P_GPIO >> 2);	/*  End ADC Start pulse. */
+		/*  End ADC Start pulse. */
+		*pRPS++ = RPS_LDREG | (P_GPIO >> 2);
 		*pRPS++ = GPIO_BASE | GPIO1_HI;
 
 		/* Wait for ADC to complete (GPIO2 is asserted high when ADC not
 		 * busy) and for data from previous conversion to shift into FB
 		 * BUFFER 1 register.
 		 */
-		*pRPS++ = RPS_PAUSE | RPS_GPIO2;	/*  Wait for ADC done. */
+		/*  Wait for ADC done. */
+		*pRPS++ = RPS_PAUSE | RPS_GPIO2;
 
-		/*  Transfer ADC data from FB BUFFER 1 register to DMA buffer. */
+		/*  Transfer ADC data from FB BUFFER 1 register
+		    to DMA buffer. */
 		*pRPS++ = RPS_STREG | (BUGFIX_STREG(P_FB_BUFFER1) >> 2);
 		*pRPS++ =
 		    (uint32_t) devpriv->ANABuf.PhysicalBase +
 		    (devpriv->AdcItems << 2);
 
-		/*  If this slot's EndOfPollList flag is set, all channels have */
-		/*  now been processed. */
+		/*  If this slot's EndOfPollList flag is set,
+		    all channels have now been processed. */
 		if (*ppl++ & EOPL) {
-			devpriv->AdcItems++;	/*  Adjust poll list item count. */
+			/*  Adjust poll list item count. */
+			devpriv->AdcItems++;
 			break;	/*  Exit poll list processing loop. */
 		}
 	}
@@ -1584,7 +1623,8 @@ void ResetADC(struct comedi_device *dev, uint8_t * ppl)
 	    (uint32_t) devpriv->ANABuf.PhysicalBase + (devpriv->AdcItems << 2);
 
 	/*  Indicate ADC scan loop is finished. */
-	/*  *pRPS++= RPS_CLRSIGNAL | RPS_SIGADC ;  // Signal ReadADC() that scan is done. */
+	/*  *pRPS++= RPS_CLRSIGNAL | RPS_SIGADC ;
+	     // Signal ReadADC() that scan is done. */
 
 	/* invoke interrupt */
 	if (devpriv->ai_cmd_running == 1) {
@@ -1607,7 +1647,9 @@ static int s626_ai_insn_config(struct comedi_device *dev,
 	return -EINVAL;
 }
 
-/* static int s626_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data) */
+/* static int s626_ai_rinsn(struct comedi_device *dev,
+			struct comedi_subdevice *s,
+			struct comedi_insn *insn,unsigned int *data) */
 /* { */
 /*   register uint8_t	i; */
 /*   register int32_t	*readaddr; */
@@ -1822,7 +1864,8 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	case TRIG_FOLLOW:
 		break;
 	case TRIG_TIMER:
-		/*  set a conter to generate adc trigger at scan_begin_arg interval */
+		/*  set a conter to generate adc trigger
+		    at scan_begin_arg interval */
 		k = &encpriv[5];
 		tick = s626_ns_to_timer((int *)&cmd->scan_begin_arg,
 					cmd->flags & TRIG_ROUND_MASK);
@@ -1849,7 +1892,8 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	case TRIG_NOW:
 		break;
 	case TRIG_TIMER:
-		/*  set a conter to generate adc trigger at convert_arg interval */
+		/*  set a conter to generate adc trigger
+		    at convert_arg interval */
 		k = &encpriv[4];
 		tick = s626_ns_to_timer((int *)&cmd->convert_arg,
 					cmd->flags & TRIG_ROUND_MASK);
@@ -1858,8 +1902,7 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		s626_timer_load(dev, k, tick);
 		k->SetEnable(dev, k, CLKENAB_INDEX);
 
-		DEBUG
-		    ("s626_ai_cmd: convert trigger timer is set with value %d\n",
+		printk(KERN_DEBUG "s626_ai_cmd: convert trigger timer is set with value %d\n",
 		     tick);
 		break;
 	case TRIG_EXT:
@@ -2178,13 +2221,17 @@ static void s626_dio_init(struct comedi_device *dev)
 	/*  For each group of sixteen channels ... */
 	for (group = 0; group < S626_DIO_BANKS; group++) {
 		s = dev->subdevices + 2 + group;
-		DEBIwrite(dev, diopriv->WRIntSel, 0);	/*  Disable all interrupts. */
-		DEBIwrite(dev, diopriv->WRCapSel, 0xFFFF);	/*  Disable all event */
+		/*  Disable all interrupts. */
+		DEBIwrite(dev, diopriv->WRIntSel, 0);
+		/*  Disable all event */
+		DEBIwrite(dev, diopriv->WRCapSel, 0xFFFF);
 		/*  captures. */
-		DEBIwrite(dev, diopriv->WREdgSel, 0);	/*  Init all DIOs to */
+		/*  Init all DIOs to */
+		DEBIwrite(dev, diopriv->WREdgSel, 0);
 		/*  default edge */
 		/*  polarity. */
-		DEBIwrite(dev, diopriv->WRDOut, 0);	/*  Program all outputs */
+		/*  Program all outputs */
+		DEBIwrite(dev, diopriv->WRDOut, 0);
 		/*  to inactive state. */
 	}
 	DEBUG("s626_dio_init: DIO initialized\n");
@@ -2206,8 +2253,7 @@ static int s626_dio_insn_bits(struct comedi_device *dev,
 		return 0;
 
 	if (insn->n != 2) {
-		printk
-		    ("comedi%d: s626: s626_dio_insn_bits(): Invalid instruction length\n",
+		printk(KERN_ERR "comedi%d: s626: s626_dio_insn_bits(): Invalid instruction length\n",
 		     dev->minor);
 		return -EINVAL;
 	}
@@ -2308,11 +2354,10 @@ static int s626_dio_set_irq(struct comedi_device *dev, unsigned int chan)
 	return 0;
 }
 
-static int s626_dio_reset_irq(struct comedi_device *dev, unsigned int group,
-			      unsigned int mask)
+static int s626_dio_reset_irq(struct comedi_device *dev,
+			unsigned int group, unsigned int mask)
 {
-	DEBUG
-	    ("s626_dio_reset_irq: disable  interrupt on dio channel %d group %d\n",
+	printk(KERN_DEBUG "s626_dio_reset_irq: disable  interrupt on dio channel %d group %d\n",
 	     mask, group);
 
 	/* disable edge capture write command */
@@ -2353,8 +2398,8 @@ static int s626_enc_insn_config(struct comedi_device *dev,
 {
 	uint16_t Setup = (LOADSRC_INDX << BF_LOADSRC) |	/*  Preload upon */
 	    /*  index. */
-	    (INDXSRC_SOFT << BF_INDXSRC) |	/*  Disable hardware index. */
-	    (CLKSRC_COUNTER << BF_CLKSRC) |	/*  Operating mode is Counter. */
+	    (INDXSRC_SOFT << BF_INDXSRC) |    /*  Disable hardware index. */
+	    (CLKSRC_COUNTER << BF_CLKSRC) |   /*  Operating mode is Counter. */
 	    (CLKPOL_POS << BF_CLKPOL) |	/*  Active high clock. */
 	    /* ( CNTDIR_UP << BF_CLKPOL ) |      // Count direction is Down. */
 	    (CLKMULT_1X << BF_CLKMULT) |	/*  Clock multiplier is 1x. */
@@ -2465,7 +2510,8 @@ static void s626_timer_load(struct comedi_device *dev, struct enc_private *k,
 static uint8_t trimchan[] = { 10, 9, 8, 3, 2, 7, 6, 1, 0, 5, 4 };
 
 /*  TrimDac LogicalChan-to-EepromAdrs mapping table. */
-static uint8_t trimadrs[] = { 0x40, 0x41, 0x42, 0x50, 0x51, 0x52, 0x53, 0x60, 0x61, 0x62, 0x63 };
+static uint8_t trimadrs[] = { 0x40, 0x41, 0x42, 0x50, 0x51, 0x52,
+			      0x53, 0x60, 0x61, 0x62, 0x63 };
 
 static void LoadTrimDACs(struct comedi_device *dev)
 {
@@ -2481,7 +2527,8 @@ static void WriteTrimDAC(struct comedi_device *dev, uint8_t LogicalChan,
 {
 	uint32_t chan;
 
-	/*  Save the new setpoint in case the application needs to read it back later. */
+	/*  Save the new setpoint in case the application needs
+	    to read it back later. */
 	devpriv->TrimSetpoint[LogicalChan] = (uint8_t) DacData;
 
 	/*  Map logical channel number to physical channel number. */
@@ -2543,7 +2590,7 @@ static uint8_t I2Cread(struct comedi_device *dev, uint8_t addr)
 			 /*  Byte1 receives */
 			 /*  uint8_t from */
 			 /*  EEPROM. */
-			 |I2C_B0(I2C_ATTRNOP, 0))) {	/*  Byte0 = Not  sent. */
+			 |I2C_B0(I2C_ATTRNOP, 0))) {/*  Byte0 = Not  sent. */
 
 		/*  Abort function and declare error if handshake failed. */
 		DEBUG("I2Cread: error handshake I2Cread b\n");
@@ -2623,10 +2670,11 @@ static void SetDAC(struct comedi_device *dev, uint16_t chan, short dacdata)
 	 * running after the packet has been sent to the target DAC.
 	 */
 	SendDAC(dev, 0x0F000000
-		/* Continue clock after target DAC data (write to non-existent trimdac). */
+		/* Continue clock after target DAC data
+		   (write to non-existent trimdac). */
 		| 0x00004000
-		/* Address the two main dual-DAC devices (TSL's chip select enables
-		 * target device). */
+		/* Address the two main dual-DAC devices
+		   (TSL's chip select enables target device). */
 		| ((uint32_t) (chan & 1) << 15)
 		/*  Address the DAC channel within the  device. */
 		| (uint32_t) dacdata);	/*  Include DAC setpoint data. */
@@ -2760,10 +2808,13 @@ static void SendDAC(struct comedi_device *dev, uint32_t val)
 
 static void WriteMISC2(struct comedi_device *dev, uint16_t NewImage)
 {
-	DEBIwrite(dev, LP_MISC1, MISC1_WENABLE);	/*  enab writes to */
+	/*  enab writes to */
+	DEBIwrite(dev, LP_MISC1, MISC1_WENABLE);
 	/*  MISC2 register. */
-	DEBIwrite(dev, LP_WRMISC2, NewImage);	/*  Write new image to MISC2. */
-	DEBIwrite(dev, LP_MISC1, MISC1_WDISABLE);	/*  Disable writes to MISC2. */
+	/*  Write new image to MISC2. */
+	DEBIwrite(dev, LP_WRMISC2, NewImage);
+	/*  Disable writes to MISC2. */
+	DEBIwrite(dev, LP_MISC1, MISC1_WDISABLE);
 }
 
 /*  Initialize the DEBI interface for all transfers. */
@@ -2866,7 +2917,8 @@ static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
  * 2=2A, 3=0B, 4=1B, 5=2B.
  */
 
-/* Forward declarations for functions that are common to both A and B counters: */
+/* Forward declarations for functions that are common
+   to both A and B counters: */
 
 /* ******  PRIVATE COUNTER FUNCTIONS ****** */
 
@@ -2919,22 +2971,44 @@ static uint16_t GetMode_A(struct comedi_device *dev, struct enc_private *k)
 	/*  Populate the standardized counter setup bit fields.  Note: */
 	/*  IndexSrc is restricted to ENC_X or IndxPol. */
 	setup = ((cra & STDMSK_LOADSRC)	/*  LoadSrc  = LoadSrcA. */
-		 |((crb << (STDBIT_LATCHSRC - CRBBIT_LATCHSRC)) & STDMSK_LATCHSRC)	/*  LatchSrc = LatchSrcA. */
-		 |((cra << (STDBIT_INTSRC - CRABIT_INTSRC_A)) & STDMSK_INTSRC)	/*  IntSrc   = IntSrcA. */
-		 |((cra << (STDBIT_INDXSRC - (CRABIT_INDXSRC_A + 1))) & STDMSK_INDXSRC)	/*  IndxSrc  = IndxSrcA<1>. */
-		 |((cra >> (CRABIT_INDXPOL_A - STDBIT_INDXPOL)) & STDMSK_INDXPOL)	/*  IndxPol  = IndxPolA. */
-		 |((crb >> (CRBBIT_CLKENAB_A - STDBIT_CLKENAB)) & STDMSK_CLKENAB));	/*  ClkEnab  = ClkEnabA. */
+		/*  LatchSrc = LatchSrcA. */
+		 |((crb << (STDBIT_LATCHSRC - CRBBIT_LATCHSRC)) &
+							STDMSK_LATCHSRC)
+		/*  IntSrc   = IntSrcA. */
+		 |((cra << (STDBIT_INTSRC - CRABIT_INTSRC_A)) &
+							STDMSK_INTSRC)
+		/*  IndxSrc  = IndxSrcA<1>. */
+		 |((cra << (STDBIT_INDXSRC - (CRABIT_INDXSRC_A + 1))) &
+							STDMSK_INDXSRC)
+		/*  IndxPol  = IndxPolA. */
+		 |((cra >> (CRABIT_INDXPOL_A - STDBIT_INDXPOL)) &
+							STDMSK_INDXPOL)
+		/*  ClkEnab  = ClkEnabA. */
+		 |((crb >> (CRBBIT_CLKENAB_A - STDBIT_CLKENAB)) &
+							STDMSK_CLKENAB));
 
 	/*  Adjust mode-dependent parameters. */
-	if (cra & (2 << CRABIT_CLKSRC_A))	/*  If Timer mode (ClkSrcA<1> == 1): */
-		setup |= ((CLKSRC_TIMER << STDBIT_CLKSRC)	/*    Indicate Timer mode. */
-			  |((cra << (STDBIT_CLKPOL - CRABIT_CLKSRC_A)) & STDMSK_CLKPOL)	/*    Set ClkPol to indicate count direction (ClkSrcA<0>). */
-			  |(MULT_X1 << STDBIT_CLKMULT));	/*    ClkMult must be 1x in Timer mode. */
+		/*  If Timer mode (ClkSrcA<1> == 1): */
+	if (cra & (2 << CRABIT_CLKSRC_A))
+			/*    Indicate Timer mode. */
+		setup |= ((CLKSRC_TIMER << STDBIT_CLKSRC)
+			/*  Set ClkPol to indicate count direction
+			    (ClkSrcA<0>). */
+			  |((cra << (STDBIT_CLKPOL - CRABIT_CLKSRC_A)) &
+								STDMSK_CLKPOL)
+			/*    ClkMult must be 1x in Timer mode. */
+			  |(MULT_X1 << STDBIT_CLKMULT));
 
 	else			/*  If Counter mode (ClkSrcA<1> == 0): */
-		setup |= ((CLKSRC_COUNTER << STDBIT_CLKSRC)	/*    Indicate Counter mode. */
-			  |((cra >> (CRABIT_CLKPOL_A - STDBIT_CLKPOL)) & STDMSK_CLKPOL)	/*    Pass through ClkPol. */
-			  |(((cra & CRAMSK_CLKMULT_A) == (MULT_X0 << CRABIT_CLKMULT_A)) ?	/*    Force ClkMult to 1x if not legal, else pass through. */
+			/*    Indicate Counter mode. */
+		setup |= ((CLKSRC_COUNTER << STDBIT_CLKSRC)
+			/*    Pass through ClkPol. */
+			  |((cra >> (CRABIT_CLKPOL_A - STDBIT_CLKPOL)) &
+								STDMSK_CLKPOL)
+			/* Force ClkMult to 1x if not legal,
+			   else pass through. */
+			  |(((cra & CRAMSK_CLKMULT_A) ==
+					  (MULT_X0 << CRABIT_CLKMULT_A)) ?
 			    (MULT_X1 << STDBIT_CLKMULT) :
 			    ((cra >> (CRABIT_CLKMULT_A -
 				      STDBIT_CLKMULT)) & STDMSK_CLKMULT)));
@@ -2955,28 +3029,56 @@ static uint16_t GetMode_B(struct comedi_device *dev, struct enc_private *k)
 
 	/*  Populate the standardized counter setup bit fields.  Note: */
 	/*  IndexSrc is restricted to ENC_X or IndxPol. */
-	setup = (((crb << (STDBIT_INTSRC - CRBBIT_INTSRC_B)) & STDMSK_INTSRC)	/*  IntSrc   = IntSrcB. */
-		 |((crb << (STDBIT_LATCHSRC - CRBBIT_LATCHSRC)) & STDMSK_LATCHSRC)	/*  LatchSrc = LatchSrcB. */
-		 |((crb << (STDBIT_LOADSRC - CRBBIT_LOADSRC_B)) & STDMSK_LOADSRC)	/*  LoadSrc  = LoadSrcB. */
-		 |((crb << (STDBIT_INDXPOL - CRBBIT_INDXPOL_B)) & STDMSK_INDXPOL)	/*  IndxPol  = IndxPolB. */
-		 |((crb >> (CRBBIT_CLKENAB_B - STDBIT_CLKENAB)) & STDMSK_CLKENAB)	/*  ClkEnab  = ClkEnabB. */
-		 |((cra >> ((CRABIT_INDXSRC_B + 1) - STDBIT_INDXSRC)) & STDMSK_INDXSRC));	/*  IndxSrc  = IndxSrcB<1>. */
+		/*  IntSrc   = IntSrcB. */
+	setup = (((crb << (STDBIT_INTSRC - CRBBIT_INTSRC_B)) &
+							STDMSK_INTSRC)
+		/*  LatchSrc = LatchSrcB. */
+		 |((crb << (STDBIT_LATCHSRC - CRBBIT_LATCHSRC)) &
+							STDMSK_LATCHSRC)
+		/*  LoadSrc  = LoadSrcB. */
+		 |((crb << (STDBIT_LOADSRC - CRBBIT_LOADSRC_B)) &
+							STDMSK_LOADSRC)
+		/*  IndxPol  = IndxPolB. */
+		 |((crb << (STDBIT_INDXPOL - CRBBIT_INDXPOL_B)) &
+							STDMSK_INDXPOL)
+		/*  ClkEnab  = ClkEnabB. */
+		 |((crb >> (CRBBIT_CLKENAB_B - STDBIT_CLKENAB)) &
+							STDMSK_CLKENAB)
+		/*  IndxSrc  = IndxSrcB<1>. */
+		 |((cra >> ((CRABIT_INDXSRC_B + 1) - STDBIT_INDXSRC)) &
+							STDMSK_INDXSRC));
 
 	/*  Adjust mode-dependent parameters. */
-	if ((crb & CRBMSK_CLKMULT_B) == (MULT_X0 << CRBBIT_CLKMULT_B))	/*  If Extender mode (ClkMultB == MULT_X0): */
-		setup |= ((CLKSRC_EXTENDER << STDBIT_CLKSRC)	/*    Indicate Extender mode. */
-			  |(MULT_X1 << STDBIT_CLKMULT)	/*    Indicate multiplier is 1x. */
-			  |((cra >> (CRABIT_CLKSRC_B - STDBIT_CLKPOL)) & STDMSK_CLKPOL));	/*    Set ClkPol equal to Timer count direction (ClkSrcB<0>). */
-
-	else if (cra & (2 << CRABIT_CLKSRC_B))	/*  If Timer mode (ClkSrcB<1> == 1): */
-		setup |= ((CLKSRC_TIMER << STDBIT_CLKSRC)	/*    Indicate Timer mode. */
-			  |(MULT_X1 << STDBIT_CLKMULT)	/*    Indicate multiplier is 1x. */
-			  |((cra >> (CRABIT_CLKSRC_B - STDBIT_CLKPOL)) & STDMSK_CLKPOL));	/*    Set ClkPol equal to Timer count direction (ClkSrcB<0>). */
+		/*  If Extender mode (ClkMultB == MULT_X0): */
+	if ((crb & CRBMSK_CLKMULT_B) == (MULT_X0 << CRBBIT_CLKMULT_B))
+			/*    Indicate Extender mode. */
+		setup |= ((CLKSRC_EXTENDER << STDBIT_CLKSRC)
+			/*    Indicate multiplier is 1x. */
+			  |(MULT_X1 << STDBIT_CLKMULT)
+			/*    Set ClkPol equal to Timer count direction
+			      (ClkSrcB<0>). */
+			  |((cra >> (CRABIT_CLKSRC_B - STDBIT_CLKPOL)) &
+							STDMSK_CLKPOL));
+		/*  If Timer mode (ClkSrcB<1> == 1): */
+	else if (cra & (2 << CRABIT_CLKSRC_B))
+			/*    Indicate Timer mode. */
+		setup |= ((CLKSRC_TIMER << STDBIT_CLKSRC)
+			/*    Indicate multiplier is 1x. */
+			  |(MULT_X1 << STDBIT_CLKMULT)
+			/*    Set ClkPol equal to Timer count direction
+			      (ClkSrcB<0>). */
+			  |((cra >> (CRABIT_CLKSRC_B - STDBIT_CLKPOL)) &
+							STDMSK_CLKPOL));
 
 	else			/*  If Counter mode (ClkSrcB<1> == 0): */
-		setup |= ((CLKSRC_COUNTER << STDBIT_CLKSRC)	/*    Indicate Timer mode. */
-			  |((crb >> (CRBBIT_CLKMULT_B - STDBIT_CLKMULT)) & STDMSK_CLKMULT)	/*    Clock multiplier is passed through. */
-			  |((crb << (STDBIT_CLKPOL - CRBBIT_CLKPOL_B)) & STDMSK_CLKPOL));	/*    Clock polarity is passed through. */
+			/*    Indicate Timer mode. */
+		setup |= ((CLKSRC_COUNTER << STDBIT_CLKSRC)
+			/*    Clock multiplier is passed through. */
+			  |((crb >> (CRBBIT_CLKMULT_B - STDBIT_CLKMULT)) &
+							STDMSK_CLKMULT)
+			/*    Clock polarity is passed through. */
+			  |((crb << (STDBIT_CLKPOL - CRBBIT_CLKPOL_B)) &
+							STDMSK_CLKPOL));
 
 	/*  Return adjusted counter setup. */
 	return setup;
@@ -2994,14 +3096,20 @@ static void SetMode_A(struct comedi_device *dev, struct enc_private *k,
 {
 	register uint16_t cra;
 	register uint16_t crb;
-	register uint16_t setup = Setup;	/*  Cache the Standard Setup. */
+	register uint16_t setup = Setup; /* Cache the Standard Setup. */
 
 	/*  Initialize CRA and CRB images. */
-	cra = ((setup & CRAMSK_LOADSRC_A)	/*  Preload trigger is passed through. */
-	       |((setup & STDMSK_INDXSRC) >> (STDBIT_INDXSRC - (CRABIT_INDXSRC_A + 1))));	/*  IndexSrc is restricted to ENC_X or IndxPol. */
-
-	crb = (CRBMSK_INTRESETCMD | CRBMSK_INTRESET_A	/*  Reset any pending CounterA event captures. */
-	       | ((setup & STDMSK_CLKENAB) << (CRBBIT_CLKENAB_A - STDBIT_CLKENAB)));	/*  Clock enable is passed through. */
+		/*  Preload trigger is passed through. */
+	cra = ((setup & CRAMSK_LOADSRC_A)
+		/*  IndexSrc is restricted to ENC_X or IndxPol. */
+	       |((setup & STDMSK_INDXSRC) >>
+		       (STDBIT_INDXSRC - (CRABIT_INDXSRC_A + 1))));
+
+		/*  Reset any pending CounterA event captures. */
+	crb = (CRBMSK_INTRESETCMD | CRBMSK_INTRESET_A
+		/*  Clock enable is passed through. */
+	       | ((setup & STDMSK_CLKENAB) <<
+		       (CRBBIT_CLKENAB_A - STDBIT_CLKENAB)));
 
 	/*  Force IntSrc to Disabled if DisableIntSrc is asserted. */
 	if (!DisableIntSrc)
@@ -3014,16 +3122,28 @@ static void SetMode_A(struct comedi_device *dev, struct enc_private *k,
 		/*  (Extender valid only for B counters). */
 
 	case CLKSRC_TIMER:	/*  Timer Mode: */
-		cra |= ((2 << CRABIT_CLKSRC_A)	/*    ClkSrcA<1> selects system clock */
-			|((setup & STDMSK_CLKPOL) >> (STDBIT_CLKPOL - CRABIT_CLKSRC_A))	/*      with count direction (ClkSrcA<0>) obtained from ClkPol. */
-			|(1 << CRABIT_CLKPOL_A)	/*    ClkPolA behaves as always-on clock enable. */
-			|(MULT_X1 << CRABIT_CLKMULT_A));	/*    ClkMult must be 1x. */
+			/*    ClkSrcA<1> selects system clock */
+		cra |= ((2 << CRABIT_CLKSRC_A)
+			/* with count direction (ClkSrcA<0>)
+			   obtained from ClkPol. */
+			|((setup & STDMSK_CLKPOL) >>
+				(STDBIT_CLKPOL - CRABIT_CLKSRC_A))
+			/*    ClkPolA behaves as always-on clock enable. */
+			|(1 << CRABIT_CLKPOL_A)
+			/*    ClkMult must be 1x. */
+			|(MULT_X1 << CRABIT_CLKMULT_A));
 		break;
 
 	default:		/*  Counter Mode: */
-		cra |= (CLKSRC_COUNTER	/*    Select ENC_C and ENC_D as clock/direction inputs. */
-			| ((setup & STDMSK_CLKPOL) << (CRABIT_CLKPOL_A - STDBIT_CLKPOL))	/*    Clock polarity is passed through. */
-			|(((setup & STDMSK_CLKMULT) == (MULT_X0 << STDBIT_CLKMULT)) ?	/*    Force multiplier to x1 if not legal, otherwise pass through. */
+			/* Select ENC_C and ENC_D as clock/direction inputs. */
+		cra |= (CLKSRC_COUNTER
+			/*    Clock polarity is passed through. */
+			| ((setup & STDMSK_CLKPOL) <<
+				(CRABIT_CLKPOL_A - STDBIT_CLKPOL))
+			/*    Force multiplier to x1 if not legal,
+			      otherwise pass through. */
+			|(((setup & STDMSK_CLKMULT) ==
+					(MULT_X0 << STDBIT_CLKMULT)) ?
 			  (MULT_X1 << CRABIT_CLKMULT_A) :
 			  ((setup & STDMSK_CLKMULT) << (CRABIT_CLKMULT_A -
 							STDBIT_CLKMULT))));
@@ -3055,11 +3175,18 @@ static void SetMode_B(struct comedi_device *dev, struct enc_private *k,
 	register uint16_t setup = Setup;	/*  Cache the Standard Setup. */
 
 	/*  Initialize CRA and CRB images. */
-	cra = ((setup & STDMSK_INDXSRC) << ((CRABIT_INDXSRC_B + 1) - STDBIT_INDXSRC));	/*  IndexSrc field is restricted to ENC_X or IndxPol. */
-
-	crb = (CRBMSK_INTRESETCMD | CRBMSK_INTRESET_B	/*  Reset event captures and disable interrupts. */
-	       | ((setup & STDMSK_CLKENAB) << (CRBBIT_CLKENAB_B - STDBIT_CLKENAB))	/*  Clock enable is passed through. */
-	       |((setup & STDMSK_LOADSRC) >> (STDBIT_LOADSRC - CRBBIT_LOADSRC_B)));	/*  Preload trigger source is passed through. */
+		/*  IndexSrc field is restricted to ENC_X or IndxPol. */
+	cra = ((setup & STDMSK_INDXSRC) <<
+		((CRABIT_INDXSRC_B + 1) - STDBIT_INDXSRC));
+
+		/*  Reset event captures and disable interrupts. */
+	crb = (CRBMSK_INTRESETCMD | CRBMSK_INTRESET_B
+		/*  Clock enable is passed through. */
+	       | ((setup & STDMSK_CLKENAB) <<
+		       (CRBBIT_CLKENAB_B - STDBIT_CLKENAB))
+		/*  Preload trigger source is passed through. */
+	       |((setup & STDMSK_LOADSRC) >>
+		       (STDBIT_LOADSRC - CRBBIT_LOADSRC_B)));
 
 	/*  Force IntSrc to Disabled if DisableIntSrc is asserted. */
 	if (!DisableIntSrc)
@@ -3069,23 +3196,39 @@ static void SetMode_B(struct comedi_device *dev, struct enc_private *k,
 	/*  Populate all mode-dependent attributes of CRA & CRB images. */
 	switch ((setup & STDMSK_CLKSRC) >> STDBIT_CLKSRC) {
 	case CLKSRC_TIMER:	/*  Timer Mode: */
-		cra |= ((2 << CRABIT_CLKSRC_B)	/*    ClkSrcB<1> selects system clock */
-			|((setup & STDMSK_CLKPOL) << (CRABIT_CLKSRC_B - STDBIT_CLKPOL)));	/*      with direction (ClkSrcB<0>) obtained from ClkPol. */
-		crb |= ((1 << CRBBIT_CLKPOL_B)	/*    ClkPolB behaves as always-on clock enable. */
-			|(MULT_X1 << CRBBIT_CLKMULT_B));	/*    ClkMultB must be 1x. */
+			/*    ClkSrcB<1> selects system clock */
+		cra |= ((2 << CRABIT_CLKSRC_B)
+			/* with direction (ClkSrcB<0>) obtained from ClkPol. */
+			|((setup & STDMSK_CLKPOL) <<
+				(CRABIT_CLKSRC_B - STDBIT_CLKPOL)));
+			/*    ClkPolB behaves as always-on clock enable. */
+		crb |= ((1 << CRBBIT_CLKPOL_B)
+			/*    ClkMultB must be 1x. */
+			|(MULT_X1 << CRBBIT_CLKMULT_B));
 		break;
 
 	case CLKSRC_EXTENDER:	/*  Extender Mode: */
-		cra |= ((2 << CRABIT_CLKSRC_B)	/*    ClkSrcB source is OverflowA (same as "timer") */
-			|((setup & STDMSK_CLKPOL) << (CRABIT_CLKSRC_B - STDBIT_CLKPOL)));	/*      with direction obtained from ClkPol. */
-		crb |= ((1 << CRBBIT_CLKPOL_B)	/*    ClkPolB controls IndexB -- always set to active. */
-			|(MULT_X0 << CRBBIT_CLKMULT_B));	/*    ClkMultB selects OverflowA as the clock source. */
+			/*    ClkSrcB source is OverflowA (same as "timer") */
+		cra |= ((2 << CRABIT_CLKSRC_B)
+			/*      with direction obtained from ClkPol. */
+			|((setup & STDMSK_CLKPOL) <<
+				(CRABIT_CLKSRC_B - STDBIT_CLKPOL)));
+			/*  ClkPolB controls IndexB -- always set to active. */
+		crb |= ((1 << CRBBIT_CLKPOL_B)
+			/*  ClkMultB selects OverflowA as the clock source. */
+			|(MULT_X0 << CRBBIT_CLKMULT_B));
 		break;
 
 	default:		/*  Counter Mode: */
-		cra |= (CLKSRC_COUNTER << CRABIT_CLKSRC_B);	/*    Select ENC_C and ENC_D as clock/direction inputs. */
-		crb |= (((setup & STDMSK_CLKPOL) >> (STDBIT_CLKPOL - CRBBIT_CLKPOL_B))	/*    ClkPol is passed through. */
-			|(((setup & STDMSK_CLKMULT) == (MULT_X0 << STDBIT_CLKMULT)) ?	/*    Force ClkMult to x1 if not legal, otherwise pass through. */
+			/*Select ENC_C and ENC_D as clock/direction inputs. */
+		cra |= (CLKSRC_COUNTER << CRABIT_CLKSRC_B);
+			/*    ClkPol is passed through. */
+		crb |= (((setup & STDMSK_CLKPOL) >>
+				(STDBIT_CLKPOL - CRBBIT_CLKPOL_B))
+			/*Force ClkMult to x1 if not legal,
+			  otherwise pass through.*/
+			|(((setup & STDMSK_CLKMULT) ==
+					(MULT_X0 << STDBIT_CLKMULT)) ?
 			  (MULT_X1 << CRBBIT_CLKMULT_B) :
 			  ((setup & STDMSK_CLKMULT) << (CRBBIT_CLKMULT_B -
 							STDBIT_CLKMULT))));
@@ -3109,7 +3252,8 @@ static void SetMode_B(struct comedi_device *dev, struct enc_private *k,
 	DEBIreplace(dev, k->MyCRB, CRBMSK_CLKENAB_A | CRBMSK_LATCHSRC, crb);
 }
 
-/*  Return/set a counter's enable.  enab: 0=always enabled, 1=enabled by index. */
+/*  Return/set a counter's enable.  enab:
+    0=always enabled, 1=enabled by index. */
 
 static void SetEnable_A(struct comedi_device *dev, struct enc_private *k,
 			uint16_t enab)
@@ -3155,7 +3299,8 @@ static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
 }
 
 /*
- * static uint16_t GetLatchSource(struct comedi_device *dev, struct enc_private *k )
+ * static uint16_t GetLatchSource(struct comedi_device *dev,
+ *					struct enc_private *k )
  * {
  *	return ( DEBIread( dev, k->MyCRB) >> CRBBIT_LATCHSRC ) & 3;
  * }
@@ -3249,61 +3394,76 @@ static uint16_t GetIntSrc_B(struct comedi_device *dev, struct enc_private *k)
 
 /*  Return/set the clock multiplier. */
 
-/* static void SetClkMult(struct comedi_device *dev, struct enc_private *k, uint16_t value )  */
+/* static void SetClkMult(struct comedi_device *dev, struct enc_private *k,
+							uint16_t value )  */
 /* { */
-/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) & ~STDMSK_CLKMULT ) | ( value << STDBIT_CLKMULT ) ), FALSE ); */
+/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) &
+		~STDMSK_CLKMULT ) | ( value << STDBIT_CLKMULT ) ), FALSE ); */
 /* } */
 
-/* static uint16_t GetClkMult(struct comedi_device *dev, struct enc_private *k )  */
+/* static uint16_t GetClkMult(struct comedi_device *dev,
+					struct enc_private *k )  */
 /* { */
 /*   return ( k->GetMode(dev, k ) >> STDBIT_CLKMULT ) & 3; */
 /* } */
 
 /* Return/set the clock polarity. */
 
-/* static void SetClkPol( struct comedi_device *dev,struct enc_private *k, uint16_t value )  */
+/* static void SetClkPol( struct comedi_device *dev,struct enc_private *k,
+							uint16_t value )  */
 /* { */
-/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) & ~STDMSK_CLKPOL ) | ( value << STDBIT_CLKPOL ) ), FALSE ); */
+/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) &
+		~STDMSK_CLKPOL ) | ( value << STDBIT_CLKPOL ) ), FALSE ); */
 /* } */
 
-/* static uint16_t GetClkPol(struct comedi_device *dev, struct enc_private *k )  */
+/* static uint16_t GetClkPol(struct comedi_device *dev,
+					struct enc_private *k )  */
 /* { */
 /*   return ( k->GetMode(dev, k ) >> STDBIT_CLKPOL ) & 1; */
 /* } */
 
 /* Return/set the clock source.  */
 
-/* static void SetClkSrc( struct comedi_device *dev,struct enc_private *k, uint16_t value )  */
+/* static void SetClkSrc( struct comedi_device *dev,struct enc_private *k,
+							uint16_t value )  */
 /* { */
-/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) & ~STDMSK_CLKSRC ) | ( value << STDBIT_CLKSRC ) ), FALSE ); */
+/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) &
+		~STDMSK_CLKSRC ) | ( value << STDBIT_CLKSRC ) ), FALSE ); */
 /* } */
 
-/* static uint16_t GetClkSrc( struct comedi_device *dev,struct enc_private *k )  */
+/* static uint16_t GetClkSrc( struct comedi_device *dev,
+				struct enc_private *k )  */
 /* { */
 /*   return ( k->GetMode(dev, k ) >> STDBIT_CLKSRC ) & 3; */
 /* } */
 
 /* Return/set the index polarity. */
 
-/* static void SetIndexPol(struct comedi_device *dev, struct enc_private *k, uint16_t value )  */
+/* static void SetIndexPol(struct comedi_device *dev, struct enc_private *k,
+							uint16_t value )  */
 /* { */
-/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) & ~STDMSK_INDXPOL ) | ( (value != 0) << STDBIT_INDXPOL ) ), FALSE ); */
+/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) &
+	~STDMSK_INDXPOL ) | ( (value != 0) << STDBIT_INDXPOL ) ), FALSE ); */
 /* } */
 
-/* static uint16_t GetIndexPol(struct comedi_device *dev, struct enc_private *k )  */
+/* static uint16_t GetIndexPol(struct comedi_device *dev,
+				struct enc_private *k )  */
 /* { */
 /*   return ( k->GetMode(dev, k ) >> STDBIT_INDXPOL ) & 1; */
 /* } */
 
 /*  Return/set the index source. */
 
-/* static void SetIndexSrc(struct comedi_device *dev, struct enc_private *k, uint16_t value )  */
+/* static void SetIndexSrc(struct comedi_device *dev, struct enc_private *k,
+							uint16_t value )  */
 /* { */
 /*   DEBUG("SetIndexSrc: set index src enter 3700\n"); */
-/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) & ~STDMSK_INDXSRC ) | ( (value != 0) << STDBIT_INDXSRC ) ), FALSE ); */
+/*   k->SetMode(dev, k, (uint16_t)( ( k->GetMode(dev, k ) &
+	~STDMSK_INDXSRC ) | ( (value != 0) << STDBIT_INDXSRC ) ), FALSE ); */
 /* } */
 
-/* static uint16_t GetIndexSrc(struct comedi_device *dev, struct enc_private *k )  */
+/* static uint16_t GetIndexSrc(struct comedi_device *dev,
+				struct enc_private *k )  */
 /* { */
 /*   return ( k->GetMode(dev, k ) >> STDBIT_INDXSRC ) & 1; */
 /* } */
@@ -3326,7 +3486,7 @@ static void PulseIndex_B(struct comedi_device *dev, struct enc_private *k)
 {
 	register uint16_t crb;
 
-	crb = DEBIread(dev, k->MyCRB) & ~CRBMSK_INTCTRL;	/*  Pulse index. */
+	crb = DEBIread(dev, k->MyCRB) & ~CRBMSK_INTCTRL; /*  Pulse index. */
 	DEBIwrite(dev, k->MyCRB, (uint16_t) (crb ^ CRBMSK_INDXPOL_B));
 	DEBIwrite(dev, k->MyCRB, crb);
 }
@@ -3337,7 +3497,8 @@ static void Preload(struct comedi_device *dev, struct enc_private *k,
 		    uint32_t value)
 {
 	DEBUG("Preload: preload enter\n");
-	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw), (uint16_t) value);	/*  Write value to preload register. */
+	/*  Write value to preload register. */
+	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw), (uint16_t) value);
 	DEBUG("Preload: preload step 1\n");
 	DEBIwrite(dev, (uint16_t) (k->MyLatchLsw + 2),
 		  (uint16_t) (value >> 16));
@@ -3350,13 +3511,14 @@ static void CountersInit(struct comedi_device *dev)
 	uint16_t Setup = (LOADSRC_INDX << BF_LOADSRC) |	/*  Preload upon */
 	    /*  index. */
 	    (INDXSRC_SOFT << BF_INDXSRC) |	/*  Disable hardware index. */
-	    (CLKSRC_COUNTER << BF_CLKSRC) |	/*  Operating mode is counter. */
+	    (CLKSRC_COUNTER << BF_CLKSRC) |  /*  Operating mode is counter. */
 	    (CLKPOL_POS << BF_CLKPOL) |	/*  Active high clock. */
 	    (CNTDIR_UP << BF_CLKPOL) |	/*  Count direction is up. */
 	    (CLKMULT_1X << BF_CLKMULT) |	/*  Clock multiplier is 1x. */
 	    (CLKENAB_INDEX << BF_CLKENAB);	/*  Enabled by index */
 
-	/*  Disable all counter interrupts and clear any captured counter events. */
+	/*  Disable all counter interrupts and clear
+	    any captured counter events. */
 	for (chan = 0; chan < S626_ENCODER_CHANNELS; chan++) {
 		k = &encpriv[chan];
 		k->SetMode(dev, k, Setup, TRUE);
-- 
1.7.3.3

