Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0DBI5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 04:57:44 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:39244 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0DBI5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 04:57:36 -0400
X-SENDER-IP: [83.226.251.198]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ans0AMNNtUtT4vvGPGdsb2JhbACHY5NdDAEBAQE1LaYNjViFBQQ
X-IronPort-AV: E=Sophos;i="4.51,352,1267398000"; 
   d="scan'208";a="58566100"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wbusb.c Coding style fixes.
Date: Fri,  2 Apr 2010 10:57:35 +0200
Message-Id: <1270198655-29471-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the reported checkpatch.pl problems except for a bunch of
long lines and some printk:s.
I also removed versioning comments.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/wbusb.c |  187 +++++++++++++++++---------------------
 1 files changed, 84 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 3482eec..d7694e6 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -142,19 +142,17 @@ static void hal_set_radio_mode(struct hw_data *pHwData, unsigned char radio_off)
 	if (pHwData->SurpriseRemove)
 		return;
 
-	if (radio_off)		//disable Baseband receive off
-	{
-		pHwData->CurrentRadioSw = 1;	// off
+	if (radio_off) {	/* disable Baseband receive off */
+		pHwData->CurrentRadioSw = 1;	/* off */
 		reg->M24_MacControl &= 0xffffffbf;
 	} else {
-		pHwData->CurrentRadioSw = 0;	// on
+		pHwData->CurrentRadioSw = 0;	/* on */
 		reg->M24_MacControl |= 0x00000040;
 	}
 	Wb35Reg_Write(pHwData, 0x0824, reg->M24_MacControl);
 }
 
-static void
-hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info channel)
+static void hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info channel)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 
@@ -163,17 +161,18 @@ hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info channel)
 
 	printk("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
 
-	RFSynthesizer_SwitchingChannel(pHwData, channel);	// Switch channel
+	RFSynthesizer_SwitchingChannel(pHwData, channel); /* Switch channel */
 	pHwData->Channel = channel.ChanNo;
 	pHwData->band = channel.band;
 #ifdef _PE_STATE_DUMP_
 	printk("Set channel is %d, band =%d\n", pHwData->Channel,
 	       pHwData->band);
 #endif
-	reg->M28_MacControl &= ~0xff;	// Clean channel information field
+	reg->M28_MacControl &= ~0xff;	/* Clean channel information field */
 	reg->M28_MacControl |= channel.ChanNo;
 	Wb35Reg_WriteWithCallbackValue(pHwData, 0x0828, reg->M28_MacControl,
-				       (s8 *) & channel, sizeof(struct chan_info));
+				       (s8 *) &channel,
+				       sizeof(struct chan_info));
 }
 
 static void hal_set_current_channel(struct hw_data *pHwData, struct chan_info channel)
@@ -188,21 +187,22 @@ static void hal_set_accept_broadcast(struct hw_data *pHwData, u8 enable)
 	if (pHwData->SurpriseRemove)
 		return;
 
-	reg->M00_MacControl &= ~0x02000000;	//The HW value
+	reg->M00_MacControl &= ~0x02000000;	/* The HW value */
 
 	if (enable)
-		reg->M00_MacControl |= 0x02000000;	//The HW value
+		reg->M00_MacControl |= 0x02000000;	/* The HW value */
 
 	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
 }
 
-//for wep key error detection, we need to accept broadcast packets to be received temporary.
+/* For wep key error detection, we need to accept broadcast packets to be received temporary. */
 static void hal_set_accept_promiscuous(struct hw_data *pHwData, u8 enable)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 
 	if (pHwData->SurpriseRemove)
 		return;
+
 	if (enable) {
 		reg->M00_MacControl |= 0x00400000;
 		Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
@@ -219,9 +219,9 @@ static void hal_set_accept_multicast(struct hw_data *pHwData, u8 enable)
 	if (pHwData->SurpriseRemove)
 		return;
 
-	reg->M00_MacControl &= ~0x01000000;	//The HW value
+	reg->M00_MacControl &= ~0x01000000;	/* The HW value */
 	if (enable)
-		reg->M00_MacControl |= 0x01000000;	//The HW value
+		reg->M00_MacControl |= 0x01000000;	/* The HW value */
 	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
 }
 
@@ -232,13 +232,12 @@ static void hal_set_accept_beacon(struct hw_data *pHwData, u8 enable)
 	if (pHwData->SurpriseRemove)
 		return;
 
-	// 20040108 debug
-	if (!enable)		//Due to SME and MLME are not suitable for 35
+	if (!enable)	/* Due to SME and MLME are not suitable for 35 */
 		return;
 
-	reg->M00_MacControl &= ~0x04000000;	//The HW value
+	reg->M00_MacControl &= ~0x04000000;	/* The HW value */
 	if (enable)
-		reg->M00_MacControl |= 0x04000000;	//The HW value
+		reg->M00_MacControl |= 0x04000000;	/* The HW value */
 
 	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
 }
@@ -283,8 +282,7 @@ static const struct ieee80211_ops wbsoft_ops = {
 	.get_tsf		= wbsoft_get_tsf,
 };
 
-static void
-hal_set_ethernet_address(struct hw_data *pHwData, u8 * current_address)
+static void hal_set_ethernet_address(struct hw_data *pHwData, u8 *current_address)
 {
 	u32 ltmp[2];
 
@@ -294,14 +292,12 @@ hal_set_ethernet_address(struct hw_data *pHwData, u8 * current_address)
 	memcpy(pHwData->CurrentMacAddress, current_address, ETH_ALEN);
 
 	ltmp[0] = cpu_to_le32(*(u32 *) pHwData->CurrentMacAddress);
-	ltmp[1] =
-	    cpu_to_le32(*(u32 *) (pHwData->CurrentMacAddress + 4)) & 0xffff;
+	ltmp[1] = cpu_to_le32(*(u32 *) (pHwData->CurrentMacAddress + 4)) & 0xffff;
 
 	Wb35Reg_BurstWrite(pHwData, 0x03e8, ltmp, 2, AUTO_INCREMENT);
 }
 
-static void
-hal_get_permanent_address(struct hw_data *pHwData, u8 * pethernet_address)
+static void hal_get_permanent_address(struct hw_data *pHwData, u8 *pethernet_address)
 {
 	if (pHwData->SurpriseRemove)
 		return;
@@ -319,7 +315,7 @@ static void hal_stop(struct hw_data *pHwData)
 	pHwData->Wb35Tx.tx_halt = 1;
 	Wb35Tx_stop(pHwData);
 
-	reg->D00_DmaControl &= ~0xc0000000;	//Tx Off, Rx Off
+	reg->D00_DmaControl &= ~0xc0000000;	/* Tx Off, Rx Off */
 	Wb35Reg_Write(pHwData, 0x0400, reg->D00_DmaControl);
 }
 
@@ -346,14 +342,14 @@ u8 hal_get_antenna_number(struct hw_data *pHwData)
 }
 
 /* 0 : radio on; 1: radio off */
-static u8 hal_get_hw_radio_off(struct hw_data * pHwData)
+static u8 hal_get_hw_radio_off(struct hw_data *pHwData)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 
 	if (pHwData->SurpriseRemove)
 		return 1;
 
-	//read the bit16 of register U1B0
+	/* read the bit16 of register U1B0 */
 	Wb35Reg_Read(pHwData, 0x3b0, &reg->U1B0);
 	if ((reg->U1B0 & 0x00010000)) {
 		pHwData->CurrentRadioHw = 1;
@@ -387,104 +383,98 @@ static void hal_led_control(unsigned long data)
 
 	if (pHwData->LED_control) {
 		ltmp2 = pHwData->LED_control & 0xff;
-		if (ltmp2 == 5)	// 5 is WPS mode
-		{
+		if (ltmp2 == 5)	{ /* 5 is WPS mode */
 			TimeInterval = 100;
 			ltmp2 = (pHwData->LED_control >> 8) & 0xff;
 			switch (ltmp2) {
-			case 1:	// [0.2 On][0.1 Off]...
+			case 1:	/* [0.2 On][0.1 Off]... */
 				pHwData->LED_Blinking %= 3;
-				ltmp = 0x1010;	// Led 1 & 0 Green and Red
-				if (pHwData->LED_Blinking == 2)	// Turn off
+				ltmp = 0x1010;	/* Led 1 & 0 Green and Red */
+				if (pHwData->LED_Blinking == 2)	/* Turn off */
 					ltmp = 0;
 				break;
-			case 2:	// [0.1 On][0.1 Off]...
+			case 2:	/* [0.1 On][0.1 Off]... */
 				pHwData->LED_Blinking %= 2;
-				ltmp = 0x0010;	// Led 0 red color
-				if (pHwData->LED_Blinking)	// Turn off
+				ltmp = 0x0010;	/* Led 0 red color */
+				if (pHwData->LED_Blinking) /* Turn off */
 					ltmp = 0;
 				break;
-			case 3:	// [0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.5 Off]...
+			case 3:	/* [0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.5 Off]... */
 				pHwData->LED_Blinking %= 15;
-				ltmp = 0x0010;	// Led 0 red color
-				if ((pHwData->LED_Blinking >= 9) || (pHwData->LED_Blinking % 2))	// Turn off 0.6 sec
+				ltmp = 0x0010;	/* Led 0 red color */
+				if ((pHwData->LED_Blinking >= 9) || (pHwData->LED_Blinking % 2)) /* Turn off 0.6 sec */
 					ltmp = 0;
 				break;
-			case 4:	// [300 On][ off ]
-				ltmp = 0x1000;	// Led 1 Green color
+			case 4:	/* [300 On][ off ] */
+				ltmp = 0x1000;	/* Led 1 Green color */
 				if (pHwData->LED_Blinking >= 3000)
-					ltmp = 0;	// led maybe on after 300sec * 32bit counter overlap.
+					ltmp = 0; /* led maybe on after 300sec * 32bit counter overlap. */
 				break;
 			}
 			pHwData->LED_Blinking++;
 
 			reg->U1BC_LEDConfigure = ltmp;
-			if (LEDSet != 7)	// Only 111 mode has 2 LEDs on PCB.
-			{
-				reg->U1BC_LEDConfigure |= (ltmp & 0xff) << 8;	// Copy LED result to each LED control register
+			if (LEDSet != 7) { /* Only 111 mode has 2 LEDs on PCB. */
+				reg->U1BC_LEDConfigure |= (ltmp & 0xff) << 8; /* Copy LED result to each LED control register */
 				reg->U1BC_LEDConfigure |= (ltmp & 0xff00) >> 8;
 			}
 			Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 		}
-	} else if (pHwData->CurrentRadioSw || pHwData->CurrentRadioHw)	// If radio off
-	{
+	} else if (pHwData->CurrentRadioSw || pHwData->CurrentRadioHw) { /* If radio off */
 		if (reg->U1BC_LEDConfigure & 0x1010) {
 			reg->U1BC_LEDConfigure &= ~0x1010;
 			Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 		}
 	} else {
 		switch (LEDSet) {
-		case 4:	// [100] Only 1 Led be placed on PCB and use pin 21 of IC. Use LED_0 for showing
-			if (!pHwData->LED_LinkOn)	// Blink only if not Link On
-			{
-				// Blinking if scanning is on progress
+		case 4:	/* [100] Only 1 Led be placed on PCB and use pin 21 of IC. Use LED_0 for showing */
+			if (!pHwData->LED_LinkOn) { /* Blink only if not Link On */
+				/* Blinking if scanning is on progress */
 				if (pHwData->LED_Scanning) {
 					if (pHwData->LED_Blinking == 0) {
 						reg->U1BC_LEDConfigure |= 0x10;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 On
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_0 On */
 						pHwData->LED_Blinking = 1;
 						TimeInterval = 300;
 					} else {
 						reg->U1BC_LEDConfigure &= ~0x10;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_0 Off */
 						pHwData->LED_Blinking = 0;
 						TimeInterval = 300;
 					}
 				} else {
-					//Turn Off LED_0
+					/* Turn Off LED_0 */
 					if (reg->U1BC_LEDConfigure & 0x10) {
 						reg->U1BC_LEDConfigure &= ~0x10;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_0 Off */
 					}
 				}
 			} else {
-				// Turn On LED_0
+				/* Turn On LED_0 */
 				if ((reg->U1BC_LEDConfigure & 0x10) == 0) {
 					reg->U1BC_LEDConfigure |= 0x10;
-					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_0 Off */
 				}
 			}
 			break;
-
-		case 6:	// [110] Only 1 Led be placed on PCB and use pin 21 of IC. Use LED_0 for showing
-			if (!pHwData->LED_LinkOn)	// Blink only if not Link On
-			{
-				// Blinking if scanning is on progress
+		case 6:	/* [110] Only 1 Led be placed on PCB and use pin 21 of IC. Use LED_0 for showing */
+			if (!pHwData->LED_LinkOn) { /* Blink only if not Link On */
+				/* Blinking if scanning is on progress */
 				if (pHwData->LED_Scanning) {
 					if (pHwData->LED_Blinking == 0) {
 						reg->U1BC_LEDConfigure &= ~0xf;
 						reg->U1BC_LEDConfigure |= 0x10;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 On
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_0 On */
 						pHwData->LED_Blinking = 1;
 						TimeInterval = 300;
 					} else {
 						reg->U1BC_LEDConfigure &= ~0x1f;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_0 Off */
 						pHwData->LED_Blinking = 0;
 						TimeInterval = 300;
 					}
 				} else {
-					// 20060901 Gray blinking if in disconnect state and not scanning
+					/* Gray blinking if in disconnect state and not scanning */
 					ltmp = reg->U1BC_LEDConfigure;
 					reg->U1BC_LEDConfigure &= ~0x1f;
 					if (LED_GRAY2[(pHwData->LED_Blinking % 30)]) {
@@ -494,85 +484,78 @@ static void hal_led_control(unsigned long data)
 					}
 					pHwData->LED_Blinking++;
 					if (reg->U1BC_LEDConfigure != ltmp)
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_0 Off */
 					TimeInterval = 100;
 				}
 			} else {
-				// Turn On LED_0
+				/* Turn On LED_0 */
 				if ((reg->U1BC_LEDConfigure & 0x10) == 0) {
 					reg->U1BC_LEDConfigure |= 0x10;
-					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_0 Off */
 				}
 			}
 			break;
-
-		case 5:	// [101] Only 1 Led be placed on PCB and use LED_1 for showing
-			if (!pHwData->LED_LinkOn)	// Blink only if not Link On
-			{
-				// Blinking if scanning is on progress
+		case 5:	/* [101] Only 1 Led be placed on PCB and use LED_1 for showing */
+			if (!pHwData->LED_LinkOn) { /* Blink only if not Link On */
+				/* Blinking if scanning is on progress */
 				if (pHwData->LED_Scanning) {
 					if (pHwData->LED_Blinking == 0) {
-						reg->U1BC_LEDConfigure |=
-						    0x1000;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_1 On
+						reg->U1BC_LEDConfigure |= 0x1000;
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_1 On */
 						pHwData->LED_Blinking = 1;
 						TimeInterval = 300;
 					} else {
-						reg->U1BC_LEDConfigure &=
-						    ~0x1000;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_1 Off
+						reg->U1BC_LEDConfigure &= ~0x1000;
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_1 Off */
 						pHwData->LED_Blinking = 0;
 						TimeInterval = 300;
 					}
 				} else {
-					//Turn Off LED_1
+					/* Turn Off LED_1 */
 					if (reg->U1BC_LEDConfigure & 0x1000) {
-						reg->U1BC_LEDConfigure &=
-						    ~0x1000;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_1 Off
+						reg->U1BC_LEDConfigure &= ~0x1000;
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_1 Off */
 					}
 				}
 			} else {
-				// Is transmitting/receiving ??
+				/* Is transmitting/receiving ?? */
 				if ((adapter->RxByteCount !=
 				     pHwData->RxByteCountLast)
 				    || (adapter->TxByteCount !=
 					pHwData->TxByteCountLast)) {
 					if ((reg->U1BC_LEDConfigure & 0x3000) !=
 					    0x3000) {
-						reg->U1BC_LEDConfigure |=
-						    0x3000;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_1 On
+						reg->U1BC_LEDConfigure |= 0x3000;
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_1 On */
 					}
-					// Update variable
+					/* Update variable */
 					pHwData->RxByteCountLast =
 					    adapter->RxByteCount;
 					pHwData->TxByteCountLast =
 					    adapter->TxByteCount;
 					TimeInterval = 200;
 				} else {
-					// Turn On LED_1 and blinking if transmitting/receiving
+					/* Turn On LED_1 and blinking if transmitting/receiving */
 					if ((reg->U1BC_LEDConfigure & 0x3000) !=
 					    0x1000) {
 						reg->U1BC_LEDConfigure &=
 						    ~0x3000;
 						reg->U1BC_LEDConfigure |=
 						    0x1000;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_1 On
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	/* LED_1 On */
 					}
 				}
 			}
 			break;
-
-		default:	// Default setting. 2 LED be placed on PCB. LED_0: Link On LED_1 Active
+		default: /* Default setting. 2 LED be placed on PCB. LED_0: Link On LED_1 Active */
 			if ((reg->U1BC_LEDConfigure & 0x3000) != 0x3000) {
-				reg->U1BC_LEDConfigure |= 0x3000;	// LED_1 is always on and event enable
+				reg->U1BC_LEDConfigure |= 0x3000;	/* LED_1 is always on and event enable */
 				Wb35Reg_Write(pHwData, 0x03bc,
 					      reg->U1BC_LEDConfigure);
 			}
 
 			if (pHwData->LED_Blinking) {
-				// Gray blinking
+				/* Gray blinking */
 				reg->U1BC_LEDConfigure &= ~0x0f;
 				reg->U1BC_LEDConfigure |= 0x10;
 				reg->U1BC_LEDConfigure |=
@@ -584,7 +567,7 @@ static void hal_led_control(unsigned long data)
 				if (pHwData->LED_Blinking < 40)
 					TimeInterval = 100;
 				else {
-					pHwData->LED_Blinking = 0;	// Stop blinking
+					pHwData->LED_Blinking = 0; /* Stop blinking */
 					reg->U1BC_LEDConfigure &= ~0x0f;
 					Wb35Reg_Write(pHwData, 0x03bc,
 						      reg->U1BC_LEDConfigure);
@@ -593,16 +576,14 @@ static void hal_led_control(unsigned long data)
 			}
 
 			if (pHwData->LED_LinkOn) {
-				if (!(reg->U1BC_LEDConfigure & 0x10))	// Check the LED_0
-				{
-					//Try to turn ON LED_0 after gray blinking
+				if (!(reg->U1BC_LEDConfigure & 0x10)) { /* Check the LED_0 */
+					/* Try to turn ON LED_0 after gray blinking */
 					reg->U1BC_LEDConfigure |= 0x10;
-					pHwData->LED_Blinking = 1;	//Start blinking
+					pHwData->LED_Blinking = 1; /* Start blinking */
 					TimeInterval = 50;
 				}
 			} else {
-				if (reg->U1BC_LEDConfigure & 0x10)	// Check the LED_0
-				{
+				if (reg->U1BC_LEDConfigure & 0x10) { /* Check the LED_0 */
 					reg->U1BC_LEDConfigure &= ~0x10;
 					Wb35Reg_Write(pHwData, 0x03bc,
 						      reg->U1BC_LEDConfigure);
@@ -611,7 +592,7 @@ static void hal_led_control(unsigned long data)
 			break;
 		}
 
-		//20060828.1 Active send null packet to avoid AP disconnect
+		/* Active send null packet to avoid AP disconnect */
 		if (pHwData->LED_LinkOn) {
 			pHwData->NullPacketCount += TimeInterval;
 			if (pHwData->NullPacketCount >=
@@ -622,7 +603,7 @@ static void hal_led_control(unsigned long data)
 	}
 
 	pHwData->time_count += TimeInterval;
-	Wb35Tx_CurrentTime(adapter, pHwData->time_count);	// 20060928 add
+	Wb35Tx_CurrentTime(adapter, pHwData->time_count);
 	pHwData->LEDTimer.expires = jiffies + msecs_to_jiffies(TimeInterval);
 	add_timer(&pHwData->LEDTimer);
 }
@@ -654,7 +635,7 @@ static int hal_init_hardware(struct ieee80211_hw *hw)
 	SoftwareSet = hal_software_set(pHwData);
 
 #ifdef Vendor2
-	// Try to make sure the EEPROM contain
+	/* Try to make sure the EEPROM contain */
 	SoftwareSet >>= 8;
 	if (SoftwareSet != 0x82)
 		return false;
-- 
1.7.0.4

