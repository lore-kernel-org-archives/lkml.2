Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880Ab0FRRjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:39:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53796 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933853Ab0FRRjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EBc9gYW+8/XoqLViJ3Es/9hhheaaPO41cSK2dg2CaJ6aPnpvcUp7jgbEZdf6Jl7RGH
         1w7VQ36wV9JNZkkIRFrVg6a74BLvRFUp+ArtKuc0Pf0YXnwGGAExoP0Z962oHfd5FALm
         xP0pQfcMhGrojzNVXaWIlLDUmySuz0rZu2s5Y=
From: John Sheehan <john.d.sheehan@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, roel.kluin@gmail.com, jkosina@suse.cz,
       john.d.sheehan@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: fix code warnings in s626.c
Date: Fri, 18 Jun 2010 18:39:15 +0100
Message-Id: <1276882755-10134-1-git-send-email-john.d.sheehan@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sheehan <john.d.sheehan@gmail.com>

A patch for s626.c to fix some of the warnings
reported by the checkpatch.pl tool, namely,
-suspect code indent for conditional statements
-please, no space before tabs

Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
---
 drivers/staging/comedi/drivers/s626.c |   44 ++++++++++++++++----------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index b78d7ad..d5ba3ab 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -816,7 +816,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		MC_ENABLE(P_MC2, MC2_UPLD_IIC);
 		/*  Invoke command  upload */
 		while ((RR7146(P_MC2) & MC2_UPLD_IIC) == 0)
-		    ;
+			;
 		/*  and wait for upload to complete. */
 
 		/* Per SAA7146 data sheet, write to STATUS reg twice to
@@ -826,7 +826,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			/*  Write I2C control: reset  error flags. */
 			MC_ENABLE(P_MC2, MC2_UPLD_IIC);	/*  Invoke command upload */
 			while (!MC_TEST(P_MC2, MC2_UPLD_IIC))
-			    ;
+				;
 			/* and wait for upload to complete. */
 		}
 
@@ -866,14 +866,14 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		 * not start up in a defined state after a PCI reset.
 		 */
 
-/*     PollList = EOPL;			// Create a simple polling */
-/* 					// list for analog input */
-/* 					// channel 0. */
+/*     PollList = EOPL;		// Create a simple polling */
+/*				// list for analog input */
+/*				// channel 0. */
 /*     ResetADC( dev, &PollList ); */
 
 /*     s626_ai_rinsn(dev,dev->subdevices,NULL,data); //( &AdcData ); // */
-/* 						  //Get initial ADC */
-/* 						  //value. */
+/*							//Get initial ADC */
+/*							//value. */
 
 /*     StartVal = data[0]; */
 
@@ -886,10 +886,10 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 /*     for ( index = 0; index < 500; index++ ) */
 /*       { */
-/* 	s626_ai_rinsn(dev,dev->subdevices,NULL,data); */
-/* 	AdcData = data[0];	//ReadADC(  &AdcData ); */
-/* 	if ( AdcData != StartVal ) */
-/* 	  break; */
+/*	s626_ai_rinsn(dev,dev->subdevices,NULL,data); */
+/*	AdcData = data[0];	//ReadADC(  &AdcData ); */
+/*	if ( AdcData != StartVal ) */
+/*		break; */
 /*       } */
 
 		/*  end initADC */
@@ -1690,7 +1690,7 @@ static int s626_ai_insn_read(struct comedi_device *dev,
 
 		/*  Wait for ADC done. */
 		while (!(RR7146(P_PSR) & PSR_GPIO2))
-		    ;
+			;
 
 		/*  Fetch ADC data. */
 		if (n != 0)
@@ -1723,7 +1723,7 @@ static int s626_ai_insn_read(struct comedi_device *dev,
 
 	/*  Wait for ADC done. */
 	while (!(RR7146(P_PSR) & PSR_GPIO2))
-	    ;
+		;
 
 	/*  Fetch ADC data from audio interface's input shift register. */
 
@@ -2564,11 +2564,11 @@ static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val)
 
 	MC_ENABLE(P_MC2, MC2_UPLD_IIC);
 	while (!MC_TEST(P_MC2, MC2_UPLD_IIC))
-	    ;
+		;
 
 	/*  Wait until I2C bus transfer is finished or an error occurs. */
 	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY)
-	    ;
+		;
 
 	/*  Return non-zero if I2C error occured. */
 	return RR7146(P_I2CCTRL) & I2C_ERR;
@@ -2683,7 +2683,7 @@ static void SendDAC(struct comedi_device *dev, uint32_t val)
 	 * cleared when the transfer has finished.
 	 */
 	while ((RR7146(P_MC1) & MC1_A2OUT) != 0)
-	    ;
+		;
 
 	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
 
@@ -2701,7 +2701,7 @@ static void SendDAC(struct comedi_device *dev, uint32_t val)
 	 * to the output buffer register.
 	 */
 	while ((RR7146(P_SSR) & SSR_AF2_OUT) == 0)
-	    ;
+		;
 
 	/* Set up to trap execution at slot 0 when the TSL sequencer cycles
 	 * back to slot 0 after executing the EOS in slot 5.  Also,
@@ -2738,7 +2738,7 @@ static void SendDAC(struct comedi_device *dev, uint32_t val)
 		 * out/in on SD2 the 0x00 that is always referenced by slot 5.
 		 */
 		while ((RR7146(P_FB_BUFFER2) & 0xFF000000) != 0)
-		    ;
+			;
 	}
 	/* Either (1) we were too late setting the slot 0 trap; the TSL
 	 * sequencer restarted slot 0 before we could set the EOS trap flag,
@@ -2755,7 +2755,7 @@ static void SendDAC(struct comedi_device *dev, uint32_t val)
 	 * from 0x00 to 0xFF.
 	 */
 	while ((RR7146(P_FB_BUFFER2) & 0xFF000000) == 0)
-	    ;
+		;
 }
 
 static void WriteMISC2(struct comedi_device *dev, uint16_t NewImage)
@@ -2795,11 +2795,11 @@ static void DEBItransfer(struct comedi_device *dev)
 	/*  Wait for completion of upload from shadow RAM to DEBI control */
 	/*  register. */
 	while (!MC_TEST(P_MC2, MC2_UPLD_DEBI))
-	    ;
+		;
 
 	/*  Wait until DEBI transfer is done. */
 	while (RR7146(P_PSR) & PSR_DEBI_S)
-	    ;
+		;
 }
 
 /*  Write a value to a gate array register. */
@@ -3157,7 +3157,7 @@ static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
 /*
  * static uint16_t GetLatchSource(struct comedi_device *dev, struct enc_private *k )
  * {
- * 	return ( DEBIread( dev, k->MyCRB) >> CRBBIT_LATCHSRC ) & 3;
+ *	return ( DEBIread( dev, k->MyCRB) >> CRBBIT_LATCHSRC ) & 3;
  * }
  */
 
-- 
1.7.0.4

