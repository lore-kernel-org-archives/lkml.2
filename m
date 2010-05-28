Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab0E1PcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:32:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62418 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576Ab0E1PcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mzafu6HbXcNiDmCrvgTYDoqoX9I9lpiNyLlLcaYc5pHwiSdL0v7twd2V3mee2mGGGU
         wjSoGii7NpK5vFx+RQ9Gg2Sj6tgxa/IVbxb70LqDxRBs1WbjPZAUOiVWPi+R+E0+apKh
         6gDrSRhNrhuqhF/bkOYE/hEQelPXnEqVNzXVE=
From: John Sheehan <john.d.sheehan@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, roel.kluin@gmail.com, jkosina@suse.cz,
       john.d.sheehan@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: comedi: fix code style errors in s626.c
Date: Fri, 28 May 2010 16:31:28 +0100
Message-Id: <1275060688-18454-1-git-send-email-john.d.sheehan@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sheehan <john.d.sheehan@gmail.com>

A patch for s626.c to fix errors reported by
checkpatch.pl tool, namely,
code indent should use tabs where possible
"foo * bar" should be "foo *bar"
trailing statements should be on next line

Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
---
 drivers/staging/comedi/drivers/s626.c |   67 +++++++++++++++++++--------------
 1 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index a3cc933..83e1bb1 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -60,10 +60,10 @@ INSN_CONFIG instructions:
    insn.insn=INSN_CONFIG;   //configuration instruction
    insn.n=1;                //number of operation (must be 1)
    insn.data=&initialvalue; //initial value loaded into encoder
-                            //during configuration
+							//during configuration
    insn.subdev=5;           //encoder subdevice
    insn.chanspec=CR_PACK(encoder_channel,0,AREF_OTHER); //encoder_channel
-                                                        //to configure
+														//to configure
 
    comedi_do_insn(cf,&insn); //executing configuration
 */
@@ -263,7 +263,7 @@ static int s626_enc_insn_write(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data);
 static int s626_ns_to_timer(int *nanosec, int round_mode);
-static int s626_ai_load_polllist(uint8_t * ppl, struct comedi_cmd *cmd);
+static int s626_ai_load_polllist(uint8_t *ppl, struct comedi_cmd *cmd);
 static int s626_ai_inttrig(struct comedi_device *dev,
 			   struct comedi_subdevice *s, unsigned int trignum);
 static irqreturn_t s626_irq_handler(int irq, void *d);
@@ -294,16 +294,16 @@ static void CloseDMAB(struct comedi_device *dev, struct bufferDMA *pdma,
 /*  COUNTER OBJECT ------------------------------------------------ */
 struct enc_private {
 	/*  Pointers to functions that differ for A and B counters: */
-	uint16_t(*GetEnable) (struct comedi_device * dev, struct enc_private *);	/* Return clock enable. */
-	uint16_t(*GetIntSrc) (struct comedi_device * dev, struct enc_private *);	/* Return interrupt source. */
-	uint16_t(*GetLoadTrig) (struct comedi_device * dev, struct enc_private *);	/* Return preload trigger source. */
-	uint16_t(*GetMode) (struct comedi_device * dev, struct enc_private *);	/* Return standardized operating mode. */
-	void (*PulseIndex) (struct comedi_device * dev, struct enc_private *);	/* Generate soft index strobe. */
-	void (*SetEnable) (struct comedi_device * dev, struct enc_private *, uint16_t enab);	/* Program clock enable. */
-	void (*SetIntSrc) (struct comedi_device * dev, struct enc_private *, uint16_t IntSource);	/* Program interrupt source. */
-	void (*SetLoadTrig) (struct comedi_device * dev, struct enc_private *, uint16_t Trig);	/* Program preload trigger source. */
-	void (*SetMode) (struct comedi_device * dev, struct enc_private *, uint16_t Setup, uint16_t DisableIntSrc);	/* Program standardized operating mode. */
-	void (*ResetCapFlags) (struct comedi_device * dev, struct enc_private *);	/* Reset event capture flags. */
+	uint16_t(*GetEnable) (struct comedi_device *dev, struct enc_private *);	/* Return clock enable. */
+	uint16_t(*GetIntSrc) (struct comedi_device *dev, struct enc_private *);	/* Return interrupt source. */
+	uint16_t(*GetLoadTrig) (struct comedi_device *dev, struct enc_private *);	/* Return preload trigger source. */
+	uint16_t(*GetMode) (struct comedi_device *dev, struct enc_private *);	/* Return standardized operating mode. */
+	void (*PulseIndex) (struct comedi_device *dev, struct enc_private *);	/* Generate soft index strobe. */
+	void (*SetEnable) (struct comedi_device *dev, struct enc_private *, uint16_t enab);	/* Program clock enable. */
+	void (*SetIntSrc) (struct comedi_device *dev, struct enc_private *, uint16_t IntSource);	/* Program interrupt source. */
+	void (*SetLoadTrig) (struct comedi_device *dev, struct enc_private *, uint16_t Trig);	/* Program preload trigger source. */
+	void (*SetMode) (struct comedi_device *dev, struct enc_private *, uint16_t Setup, uint16_t DisableIntSrc);	/* Program standardized operating mode. */
+	void (*ResetCapFlags) (struct comedi_device *dev, struct enc_private *);	/* Reset event capture flags. */
 
 	uint16_t MyCRA;		/*    Address of CRA register. */
 	uint16_t MyCRB;		/*    Address of CRB register. */
@@ -779,7 +779,8 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		/*  Write I2C control: abort any I2C activity. */
 		MC_ENABLE(P_MC2, MC2_UPLD_IIC);
 		/*  Invoke command  upload */
-		while ((RR7146(P_MC2) & MC2_UPLD_IIC) == 0) ;
+		while ((RR7146(P_MC2) & MC2_UPLD_IIC) == 0)
+			;
 		/*  and wait for upload to complete. */
 
 		/* Per SAA7146 data sheet, write to STATUS reg twice to
@@ -788,7 +789,8 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			WR7146(P_I2CSTAT, I2C_CLKSEL);
 			/*  Write I2C control: reset  error flags. */
 			MC_ENABLE(P_MC2, MC2_UPLD_IIC);	/*  Invoke command upload */
-			while (!MC_TEST(P_MC2, MC2_UPLD_IIC)) ;
+			while (!MC_TEST(P_MC2, MC2_UPLD_IIC))
+				;
 			/* and wait for upload to complete. */
 		}
 
@@ -1651,7 +1653,8 @@ static int s626_ai_insn_read(struct comedi_device *dev,
 		/*  shift into FB BUFFER 1 register. */
 
 		/*  Wait for ADC done. */
-		while (!(RR7146(P_PSR) & PSR_GPIO2)) ;
+		while (!(RR7146(P_PSR) & PSR_GPIO2))
+			;
 
 		/*  Fetch ADC data. */
 		if (n != 0)
@@ -1683,7 +1686,8 @@ static int s626_ai_insn_read(struct comedi_device *dev,
 	/*  Wait for the data to arrive in FB BUFFER 1 register. */
 
 	/*  Wait for ADC done. */
-	while (!(RR7146(P_PSR) & PSR_GPIO2)) ;
+	while (!(RR7146(P_PSR) & PSR_GPIO2))
+		;
 
 	/*  Fetch ADC data from audio interface's input shift register. */
 
@@ -1696,7 +1700,7 @@ static int s626_ai_insn_read(struct comedi_device *dev,
 	return n;
 }
 
-static int s626_ai_load_polllist(uint8_t * ppl, struct comedi_cmd *cmd)
+static int s626_ai_load_polllist(uint8_t *ppl, struct comedi_cmd *cmd)
 {
 
 	int n;
@@ -2425,8 +2429,7 @@ static void s626_timer_load(struct comedi_device *dev, struct enc_private *k,
 static uint8_t trimchan[] = { 10, 9, 8, 3, 2, 7, 6, 1, 0, 5, 4 };
 
 /*  TrimDac LogicalChan-to-EepromAdrs mapping table. */
-static uint8_t trimadrs[] =
-    { 0x40, 0x41, 0x42, 0x50, 0x51, 0x52, 0x53, 0x60, 0x61, 0x62, 0x63 };
+static uint8_t trimadrs[] = { 0x40, 0x41, 0x42, 0x50, 0x51, 0x52, 0x53, 0x60, 0x61, 0x62, 0x63 };
 
 static void LoadTrimDACs(struct comedi_device *dev)
 {
@@ -2524,10 +2527,12 @@ static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val)
 	/*  upload confirmation. */
 
 	MC_ENABLE(P_MC2, MC2_UPLD_IIC);
-	while (!MC_TEST(P_MC2, MC2_UPLD_IIC)) ;
+	while (!MC_TEST(P_MC2, MC2_UPLD_IIC))
+		;
 
 	/*  Wait until I2C bus transfer is finished or an error occurs. */
-	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY) ;
+	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY)
+		;
 
 	/*  Return non-zero if I2C error occured. */
 	return RR7146(P_I2CCTRL) & I2C_ERR;
@@ -2641,7 +2646,8 @@ static void SendDAC(struct comedi_device *dev, uint32_t val)
 	 * Done by polling the DMAC enable flag; this flag is automatically
 	 * cleared when the transfer has finished.
 	 */
-	while ((RR7146(P_MC1) & MC1_A2OUT) != 0) ;
+	while ((RR7146(P_MC1) & MC1_A2OUT) != 0)
+		;
 
 	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
 
@@ -2658,7 +2664,8 @@ static void SendDAC(struct comedi_device *dev, uint32_t val)
 	 * finished transferring the DAC's data DWORD from the output FIFO
 	 * to the output buffer register.
 	 */
-	while ((RR7146(P_SSR) & SSR_AF2_OUT) == 0) ;
+	while ((RR7146(P_SSR) & SSR_AF2_OUT) == 0)
+		;
 
 	/* Set up to trap execution at slot 0 when the TSL sequencer cycles
 	 * back to slot 0 after executing the EOS in slot 5.  Also,
@@ -2694,7 +2701,8 @@ static void SendDAC(struct comedi_device *dev, uint32_t val)
 		 * from 0xFF to 0x00, which slot 0 causes to happen by shifting
 		 * out/in on SD2 the 0x00 that is always referenced by slot 5.
 		 */
-		while ((RR7146(P_FB_BUFFER2) & 0xFF000000) != 0) ;
+		while ((RR7146(P_FB_BUFFER2) & 0xFF000000) != 0)
+			;
 	}
 	/* Either (1) we were too late setting the slot 0 trap; the TSL
 	 * sequencer restarted slot 0 before we could set the EOS trap flag,
@@ -2710,7 +2718,8 @@ static void SendDAC(struct comedi_device *dev, uint32_t val)
 	 * the next DAC write.  This is detected when FB_BUFFER2 MSB changes
 	 * from 0x00 to 0xFF.
 	 */
-	while ((RR7146(P_FB_BUFFER2) & 0xFF000000) == 0) ;
+	while ((RR7146(P_FB_BUFFER2) & 0xFF000000) == 0)
+		;
 }
 
 static void WriteMISC2(struct comedi_device *dev, uint16_t NewImage)
@@ -2749,10 +2758,12 @@ static void DEBItransfer(struct comedi_device *dev)
 
 	/*  Wait for completion of upload from shadow RAM to DEBI control */
 	/*  register. */
-	while (!MC_TEST(P_MC2, MC2_UPLD_DEBI)) ;
+	while (!MC_TEST(P_MC2, MC2_UPLD_DEBI))
+		;
 
 	/*  Wait until DEBI transfer is done. */
-	while (RR7146(P_PSR) & PSR_DEBI_S) ;
+	while (RR7146(P_PSR) & PSR_DEBI_S)
+		;
 }
 
 /*  Write a value to a gate array register. */
-- 
1.7.0.4

