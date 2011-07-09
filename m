Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1GINmP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 09:42:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46990 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab1GINmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 09:42:13 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fix warning: line over 80 character  issue in s626.c
Date: Sat,  9 Jul 2011 19:24:43 +0530
Message-Id: <1310219683-26160-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 2/2]STAGING: Comedi: fix warning: line over 80 character issue in s626.c>
References: <[PATCH 2/2]STAGING: Comedi: fix warning: line over 80 character issue in s626.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the s626.c file that fixes up a  warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/s626.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 290d4d8..fee5faa 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -338,7 +338,8 @@ struct enc_private {
 	uint16_t(*GetIntSrc) (struct comedi_device *dev, struct enc_private *);
 	uint16_t(*GetLoadTrig) (struct comedi_device *dev, struct enc_private *);	/* Return preload trigger source. */
 	uint16_t(*GetMode) (struct comedi_device *dev, struct enc_private *);	/* Return standardized operating mode. */
-	void (*PulseIndex) (struct comedi_device *dev, struct enc_private *);	/* Generate soft index strobe. */
+	/* Generate soft index strobe. */
+	void (*PulseIndex) (struct comedi_device *dev, struct enc_private *);
 	void (*SetEnable) (struct comedi_device *dev, struct enc_private *, uint16_t enab);	/* Program clock enable. */
 	void (*SetIntSrc) (struct comedi_device *dev, struct enc_private *, uint16_t IntSource);	/* Program interrupt source. */
 	void (*SetLoadTrig) (struct comedi_device *dev, struct enc_private *, uint16_t Trig);	/* Program preload trigger source. */
@@ -349,7 +350,8 @@ struct enc_private {
 	uint16_t MyCRB;		/*    Address of CRB register. */
 	uint16_t MyLatchLsw;	/*    Address of Latch least-significant-word */
 	/*    register. */
-	uint16_t MyEventBits[4];	/*    Bit translations for IntSrc -->RDMISC2. */
+	/*    Bit translations for IntSrc -->RDMISC2. */
+	uint16_t MyEventBits[4];
 };
 
 #define encpriv ((struct enc_private *)(dev->subdevices+5)->private)
@@ -784,7 +786,8 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		/* | DEBI_CFG_INCQ| DEBI_CFG_16Q); //end */
 
 		/*  Paging is disabled. */
-		WR7146(P_DEBIPAGE, DEBI_PAGE_DISABLE);	/*  Disable MMU paging. */
+		/*  Disable MMU paging. */
+		WR7146(P_DEBIPAGE, DEBI_PAGE_DISABLE);
 
 		/*  Init GPIO so that ADC Start* is negated. */
 		WR7146(P_GPIO, GPIO_BASE | GPIO1_HI);
@@ -809,8 +812,8 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		/*     devpriv->I2Cards= IsBoardRevA ? 0xA8 : 0xA0; // Set I2C EEPROM */
 		/*  DeviceType (0xA0) */
 		/*  and DeviceAddress<<1. */
-
-		devpriv->I2CAdrs = 0xA0;	/*  I2C device address for onboard */
+		/*  I2C device address for onboard */
+		devpriv->I2CAdrs = 0xA0;
 		/*  eeprom(revb) */
 
 		/*  Issue an I2C ABORT command to halt any I2C operation in */
@@ -828,7 +831,8 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		for (i = 0; i < 2; i++) {
 			WR7146(P_I2CSTAT, I2C_CLKSEL);
 			/*  Write I2C control: reset  error flags. */
-			MC_ENABLE(P_MC2, MC2_UPLD_IIC);	/*  Invoke command upload */
+			/*  Invoke command upload */
+			MC_ENABLE(P_MC2, MC2_UPLD_IIC);
 			while (!MC_TEST(P_MC2, MC2_UPLD_IIC))
 				;
 			/* and wait for upload to complete. */
-- 
1.6.5.2

