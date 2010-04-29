Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab0D3R45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:56:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56282 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460Ab0D3R40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RzzATa3hf0prkIqMiFKtjyciqYauJl/8rUVPp7Xp8wDY7pvtO9JQeh9wu0vJe14jgY
         Mlur2MXzTfSAtejGApC35AcxgLCQsz9DLHZ1qcI1dzXdjpwCwfGlVIk6gxRF9xXLantF
         QlGWTiGgClRIbFyDKaLqhtcR11dxKK9Gajrdg=
From: John D Sheehan <john.d.sheehan@gmail.com>
To: gregkh@suse.de, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       John Sheehan <john.d.sheehan@gmail.com>
Subject: [PATCH] Staging: winbond: checkpatch.pl tool fixes
Date: Thu, 29 Apr 2010 13:38:42 +0100
Message-Id: <1272544722-5908-1-git-send-email-john.d.sheehan@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sheehan <john.d.sheehan@gmail.com>

fix whitespace issues
replace C99 comments
add KERN_INFO to printk

Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
---
 drivers/staging/winbond/wbusb.c |  302 ++++++++++++++++++++++-----------------
 1 files changed, 170 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 3482eec..da735e7 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -77,7 +77,7 @@ static int wbsoft_add_interface(struct ieee80211_hw *dev,
 static void wbsoft_remove_interface(struct ieee80211_hw *dev,
 				    struct ieee80211_vif *vif)
 {
-	printk("wbsoft_remove interface called\n");
+	printk(KERN_INFO "wbsoft_remove interface called\n");
 }
 
 static void wbsoft_stop(struct ieee80211_hw *hw)
@@ -142,12 +142,14 @@ static void hal_set_radio_mode(struct hw_data *pHwData, unsigned char radio_off)
 	if (pHwData->SurpriseRemove)
 		return;
 
-	if (radio_off)		//disable Baseband receive off
-	{
-		pHwData->CurrentRadioSw = 1;	// off
+	if (radio_off) {
+		/* disable Baseband receive off */
+		/* off */
+		pHwData->CurrentRadioSw = 1;
 		reg->M24_MacControl &= 0xffffffbf;
 	} else {
-		pHwData->CurrentRadioSw = 0;	// on
+		/* on */
+		pHwData->CurrentRadioSw = 0;
 		reg->M24_MacControl |= 0x00000040;
 	}
 	Wb35Reg_Write(pHwData, 0x0824, reg->M24_MacControl);
@@ -161,19 +163,21 @@ hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info channel)
 	if (pHwData->SurpriseRemove)
 		return;
 
-	printk("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
+	printk(KERN_INFO "Going to channel: %d/%d\n", channel.band, channel.ChanNo);
 
-	RFSynthesizer_SwitchingChannel(pHwData, channel);	// Switch channel
+	/* Switch channel */
+	RFSynthesizer_SwitchingChannel(pHwData, channel);
 	pHwData->Channel = channel.ChanNo;
 	pHwData->band = channel.band;
 #ifdef _PE_STATE_DUMP_
-	printk("Set channel is %d, band =%d\n", pHwData->Channel,
+	printk(KERN_INFO "Set channel is %d, band =%d\n", pHwData->Channel,
 	       pHwData->band);
 #endif
-	reg->M28_MacControl &= ~0xff;	// Clean channel information field
+	/* Clean channel information field */
+	reg->M28_MacControl &= ~0xff;
 	reg->M28_MacControl |= channel.ChanNo;
 	Wb35Reg_WriteWithCallbackValue(pHwData, 0x0828, reg->M28_MacControl,
-				       (s8 *) & channel, sizeof(struct chan_info));
+				       (s8 *) &channel, sizeof(struct chan_info));
 }
 
 static void hal_set_current_channel(struct hw_data *pHwData, struct chan_info channel)
@@ -188,15 +192,19 @@ static void hal_set_accept_broadcast(struct hw_data *pHwData, u8 enable)
 	if (pHwData->SurpriseRemove)
 		return;
 
-	reg->M00_MacControl &= ~0x02000000;	//The HW value
+	/* The HW value */
+	reg->M00_MacControl &= ~0x02000000;
 
-	if (enable)
-		reg->M00_MacControl |= 0x02000000;	//The HW value
+	if (enable) {
+		/* The HW value */
+		reg->M00_MacControl |= 0x02000000;
+	}
 
 	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
 }
 
-//for wep key error detection, we need to accept broadcast packets to be received temporary.
+/* for wep key error detection, we need to accept broadcast packets to be
+   received temporary. */
 static void hal_set_accept_promiscuous(struct hw_data *pHwData, u8 enable)
 {
 	struct wb35_reg *reg = &pHwData->reg;
@@ -219,9 +227,13 @@ static void hal_set_accept_multicast(struct hw_data *pHwData, u8 enable)
 	if (pHwData->SurpriseRemove)
 		return;
 
-	reg->M00_MacControl &= ~0x01000000;	//The HW value
-	if (enable)
-		reg->M00_MacControl |= 0x01000000;	//The HW value
+	/* The HW value */
+	reg->M00_MacControl &= ~0x01000000;
+	if (enable) {
+		/* The HW value */
+		reg->M00_MacControl |= 0x01000000;
+	}
+
 	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
 }
 
@@ -232,13 +244,18 @@ static void hal_set_accept_beacon(struct hw_data *pHwData, u8 enable)
 	if (pHwData->SurpriseRemove)
 		return;
 
-	// 20040108 debug
-	if (!enable)		//Due to SME and MLME are not suitable for 35
+	/* 20040108 debug */
+	if (!enable) {
+		/* Due to SME and MLME are not suitable for 35 */
 		return;
+	}
 
-	reg->M00_MacControl &= ~0x04000000;	//The HW value
-	if (enable)
-		reg->M00_MacControl |= 0x04000000;	//The HW value
+	/* The HW value */
+	reg->M00_MacControl &= ~0x04000000;
+	if (enable) {
+		/* The HW value */
+		reg->M00_MacControl |= 0x04000000;
+	}
 
 	Wb35Reg_Write(pHwData, 0x0800, reg->M00_MacControl);
 }
@@ -248,7 +265,7 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 	struct wbsoft_priv *priv = dev->priv;
 	struct chan_info ch;
 
-	printk("wbsoft_config called\n");
+	printk(KERN_INFO "wbsoft_config called\n");
 
 	/* Should use channel_num, or something, as that is already pre-translated */
 	ch.band = 1;
@@ -266,7 +283,7 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 
 static u64 wbsoft_get_tsf(struct ieee80211_hw *dev)
 {
-	printk("wbsoft_get_tsf called\n");
+	printk(KERN_INFO "wbsoft_get_tsf called\n");
 	return 0;
 }
 
@@ -294,8 +311,7 @@ hal_set_ethernet_address(struct hw_data *pHwData, u8 * current_address)
 	memcpy(pHwData->CurrentMacAddress, current_address, ETH_ALEN);
 
 	ltmp[0] = cpu_to_le32(*(u32 *) pHwData->CurrentMacAddress);
-	ltmp[1] =
-	    cpu_to_le32(*(u32 *) (pHwData->CurrentMacAddress + 4)) & 0xffff;
+	ltmp[1] = cpu_to_le32(*(u32 *) (pHwData->CurrentMacAddress + 4)) & 0xffff;
 
 	Wb35Reg_BurstWrite(pHwData, 0x03e8, ltmp, 2, AUTO_INCREMENT);
 }
@@ -319,7 +335,8 @@ static void hal_stop(struct hw_data *pHwData)
 	pHwData->Wb35Tx.tx_halt = 1;
 	Wb35Tx_stop(pHwData);
 
-	reg->D00_DmaControl &= ~0xc0000000;	//Tx Off, Rx Off
+	/* Tx Off, Rx Off */
+	reg->D00_DmaControl &= ~0xc0000000;
 	Wb35Reg_Write(pHwData, 0x0400, reg->D00_DmaControl);
 }
 
@@ -346,14 +363,14 @@ u8 hal_get_antenna_number(struct hw_data *pHwData)
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
@@ -387,104 +404,128 @@ static void hal_led_control(unsigned long data)
 
 	if (pHwData->LED_control) {
 		ltmp2 = pHwData->LED_control & 0xff;
-		if (ltmp2 == 5)	// 5 is WPS mode
-		{
+		/* 5 is WPS mode */
+		if (ltmp2 == 5) {
 			TimeInterval = 100;
 			ltmp2 = (pHwData->LED_control >> 8) & 0xff;
 			switch (ltmp2) {
-			case 1:	// [0.2 On][0.1 Off]...
+			case 1:
+				/* [0.2 On][0.1 Off]... */
 				pHwData->LED_Blinking %= 3;
-				ltmp = 0x1010;	// Led 1 & 0 Green and Red
-				if (pHwData->LED_Blinking == 2)	// Turn off
+				/* Led 1 & 0 Green and Red */
+				ltmp = 0x1010;
+				if (pHwData->LED_Blinking == 2)	{
+					/* Turn off */
 					ltmp = 0;
+				}
 				break;
-			case 2:	// [0.1 On][0.1 Off]...
+			case 2:
+				/* [0.1 On][0.1 Off]... */
 				pHwData->LED_Blinking %= 2;
-				ltmp = 0x0010;	// Led 0 red color
-				if (pHwData->LED_Blinking)	// Turn off
+				/* Led 0 red color */
+				ltmp = 0x0010;
+				if (pHwData->LED_Blinking) {
+					/* Turn off */
 					ltmp = 0;
+				}
 				break;
-			case 3:	// [0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.5 Off]...
+			case 3:
+				/* [0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.1 On][0.1 Off][0.5 Off]... */
 				pHwData->LED_Blinking %= 15;
-				ltmp = 0x0010;	// Led 0 red color
-				if ((pHwData->LED_Blinking >= 9) || (pHwData->LED_Blinking % 2))	// Turn off 0.6 sec
+				/* Led 0 red color */
+				ltmp = 0x0010;
+				if ((pHwData->LED_Blinking >= 9) || (pHwData->LED_Blinking % 2)) {
+					/* Turn off 0.6 sec */
 					ltmp = 0;
+				}
 				break;
-			case 4:	// [300 On][ off ]
-				ltmp = 0x1000;	// Led 1 Green color
-				if (pHwData->LED_Blinking >= 3000)
-					ltmp = 0;	// led maybe on after 300sec * 32bit counter overlap.
+			case 4:
+				/* [300 On][ off ] */
+				/* Led 1 Green color */
+				ltmp = 0x1000;
+				if (pHwData->LED_Blinking >= 3000) {
+					/* led maybe on after 300sec * 32bit counter overlap. */
+					ltmp = 0;
+				}
 				break;
 			}
 			pHwData->LED_Blinking++;
 
 			reg->U1BC_LEDConfigure = ltmp;
-			if (LEDSet != 7)	// Only 111 mode has 2 LEDs on PCB.
-			{
-				reg->U1BC_LEDConfigure |= (ltmp & 0xff) << 8;	// Copy LED result to each LED control register
+			/* Only 111 mode has 2 LEDs on PCB. */
+			if (LEDSet != 7) {
+				reg->U1BC_LEDConfigure |= (ltmp & 0xff) << 8;
+				/* Copy LED result to each LED control register */
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
+		case 4:
+			/* [100] Only 1 Led be placed on PCB and use pin 21 of IC. Use LED_0 for showing */
+			/* Blink only if not Link On */
+			if (!pHwData->LED_LinkOn) {
+				/* Blinking if scanning is on progress */
 				if (pHwData->LED_Scanning) {
 					if (pHwData->LED_Blinking == 0) {
 						reg->U1BC_LEDConfigure |= 0x10;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 On
+						/* LED_0 On */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 						pHwData->LED_Blinking = 1;
 						TimeInterval = 300;
 					} else {
 						reg->U1BC_LEDConfigure &= ~0x10;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+						/* LED_0 Off */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 						pHwData->LED_Blinking = 0;
 						TimeInterval = 300;
 					}
 				} else {
-					//Turn Off LED_0
+					/* Turn Off LED_0 */
 					if (reg->U1BC_LEDConfigure & 0x10) {
 						reg->U1BC_LEDConfigure &= ~0x10;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+						/* LED_0 Off */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 					}
 				}
 			} else {
-				// Turn On LED_0
+				/* Turn On LED_0 */
 				if ((reg->U1BC_LEDConfigure & 0x10) == 0) {
 					reg->U1BC_LEDConfigure |= 0x10;
-					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+					/* LED_0 Off */
+					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 				}
 			}
 			break;
 
-		case 6:	// [110] Only 1 Led be placed on PCB and use pin 21 of IC. Use LED_0 for showing
-			if (!pHwData->LED_LinkOn)	// Blink only if not Link On
-			{
-				// Blinking if scanning is on progress
+		case 6:
+			/* [110] Only 1 Led be placed on PCB and use pin 21 of IC. Use LED_0 for showing */
+			/* Blink only if not Link On */
+			if (!pHwData->LED_LinkOn) {
+				/* Blinking if scanning is on progress */
 				if (pHwData->LED_Scanning) {
 					if (pHwData->LED_Blinking == 0) {
 						reg->U1BC_LEDConfigure &= ~0xf;
 						reg->U1BC_LEDConfigure |= 0x10;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 On
+						/* LED_0 On */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 						pHwData->LED_Blinking = 1;
 						TimeInterval = 300;
 					} else {
 						reg->U1BC_LEDConfigure &= ~0x1f;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+						/* LED_0 Off */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 						pHwData->LED_Blinking = 0;
 						TimeInterval = 300;
 					}
 				} else {
-					// 20060901 Gray blinking if in disconnect state and not scanning
+					/* 20060901 Gray blinking if in disconnect state and not scanning */
 					ltmp = reg->U1BC_LEDConfigure;
 					reg->U1BC_LEDConfigure &= ~0x1f;
 					if (LED_GRAY2[(pHwData->LED_Blinking % 30)]) {
@@ -493,136 +534,133 @@ static void hal_led_control(unsigned long data)
 						    LED_GRAY2[(pHwData->LED_Blinking % 30)];
 					}
 					pHwData->LED_Blinking++;
-					if (reg->U1BC_LEDConfigure != ltmp)
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+					if (reg->U1BC_LEDConfigure != ltmp) {
+						/* LED_0 Off */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
+					}
 					TimeInterval = 100;
 				}
 			} else {
-				// Turn On LED_0
+				/* Turn On LED_0 */
 				if ((reg->U1BC_LEDConfigure & 0x10) == 0) {
 					reg->U1BC_LEDConfigure |= 0x10;
-					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_0 Off
+					/* LED_0 Off */
+					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 				}
 			}
 			break;
 
-		case 5:	// [101] Only 1 Led be placed on PCB and use LED_1 for showing
-			if (!pHwData->LED_LinkOn)	// Blink only if not Link On
-			{
-				// Blinking if scanning is on progress
+		case 5:
+			/* [101] Only 1 Led be placed on PCB and use LED_1 for showing */
+			/* Blink only if not Link On */
+			if (!pHwData->LED_LinkOn) {
+				/* Blinking if scanning is on progress */
 				if (pHwData->LED_Scanning) {
 					if (pHwData->LED_Blinking == 0) {
-						reg->U1BC_LEDConfigure |=
-						    0x1000;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_1 On
+						reg->U1BC_LEDConfigure |= 0x1000;
+						/* LED_1 On */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 						pHwData->LED_Blinking = 1;
 						TimeInterval = 300;
 					} else {
-						reg->U1BC_LEDConfigure &=
-						    ~0x1000;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_1 Off
+						reg->U1BC_LEDConfigure &= ~0x1000;
+						/* LED_1 Off */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
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
+						/* LED_1 Off */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 					}
 				}
 			} else {
-				// Is transmitting/receiving ??
+				/* Is transmitting/receiving ?? */
 				if ((adapter->RxByteCount !=
 				     pHwData->RxByteCountLast)
 				    || (adapter->TxByteCount !=
 					pHwData->TxByteCountLast)) {
-					if ((reg->U1BC_LEDConfigure & 0x3000) !=
-					    0x3000) {
-						reg->U1BC_LEDConfigure |=
-						    0x3000;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_1 On
+					if ((reg->U1BC_LEDConfigure & 0x3000) != 0x3000) {
+						reg->U1BC_LEDConfigure |= 0x3000;
+						/* LED_1 On */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 					}
-					// Update variable
-					pHwData->RxByteCountLast =
-					    adapter->RxByteCount;
-					pHwData->TxByteCountLast =
-					    adapter->TxByteCount;
+					/* Update variable */
+					pHwData->RxByteCountLast = adapter->RxByteCount;
+					pHwData->TxByteCountLast = adapter->TxByteCount;
 					TimeInterval = 200;
 				} else {
-					// Turn On LED_1 and blinking if transmitting/receiving
-					if ((reg->U1BC_LEDConfigure & 0x3000) !=
-					    0x1000) {
-						reg->U1BC_LEDConfigure &=
-						    ~0x3000;
-						reg->U1BC_LEDConfigure |=
-						    0x1000;
-						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);	// LED_1 On
+					/* Turn On LED_1 and blinking if transmitting/receiving */
+					if ((reg->U1BC_LEDConfigure & 0x3000) != 0x1000) {
+						reg->U1BC_LEDConfigure &= ~0x3000;
+						reg->U1BC_LEDConfigure |= 0x1000;
+						/* LED_1 On */
+						Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 					}
 				}
 			}
 			break;
 
-		default:	// Default setting. 2 LED be placed on PCB. LED_0: Link On LED_1 Active
+		default:
+			/* Default setting. 2 LED be placed on PCB. LED_0: Link On LED_1 Active */
 			if ((reg->U1BC_LEDConfigure & 0x3000) != 0x3000) {
-				reg->U1BC_LEDConfigure |= 0x3000;	// LED_1 is always on and event enable
-				Wb35Reg_Write(pHwData, 0x03bc,
-					      reg->U1BC_LEDConfigure);
+				/* LED_1 is always on and event enable */
+				reg->U1BC_LEDConfigure |= 0x3000;
+				Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 			}
 
 			if (pHwData->LED_Blinking) {
-				// Gray blinking
+				/* Gray blinking */
 				reg->U1BC_LEDConfigure &= ~0x0f;
 				reg->U1BC_LEDConfigure |= 0x10;
-				reg->U1BC_LEDConfigure |=
-				    LED_GRAY[(pHwData->LED_Blinking - 1) % 20];
-				Wb35Reg_Write(pHwData, 0x03bc,
-					      reg->U1BC_LEDConfigure);
+				reg->U1BC_LEDConfigure |= LED_GRAY[(pHwData->LED_Blinking - 1) % 20];
+				Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 
 				pHwData->LED_Blinking += 2;
 				if (pHwData->LED_Blinking < 40)
 					TimeInterval = 100;
 				else {
-					pHwData->LED_Blinking = 0;	// Stop blinking
+					/* Stop blinking */
+					pHwData->LED_Blinking = 0;
 					reg->U1BC_LEDConfigure &= ~0x0f;
-					Wb35Reg_Write(pHwData, 0x03bc,
-						      reg->U1BC_LEDConfigure);
+					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 				}
 				break;
 			}
 
 			if (pHwData->LED_LinkOn) {
-				if (!(reg->U1BC_LEDConfigure & 0x10))	// Check the LED_0
-				{
-					//Try to turn ON LED_0 after gray blinking
+				/* Check the LED_0 */
+				if (!(reg->U1BC_LEDConfigure & 0x10)) {
+					/* Try to turn ON LED_0 after gray blinking */
 					reg->U1BC_LEDConfigure |= 0x10;
-					pHwData->LED_Blinking = 1;	//Start blinking
+					/* Start blinking */
+					pHwData->LED_Blinking = 1;
 					TimeInterval = 50;
 				}
 			} else {
-				if (reg->U1BC_LEDConfigure & 0x10)	// Check the LED_0
-				{
+				/* Check the LED_0 */
+				if (reg->U1BC_LEDConfigure & 0x10) {
 					reg->U1BC_LEDConfigure &= ~0x10;
-					Wb35Reg_Write(pHwData, 0x03bc,
-						      reg->U1BC_LEDConfigure);
+					Wb35Reg_Write(pHwData, 0x03bc, reg->U1BC_LEDConfigure);
 				}
 			}
 			break;
 		}
 
-		//20060828.1 Active send null packet to avoid AP disconnect
+		/* 20060828.1 Active send null packet to avoid AP disconnect */
 		if (pHwData->LED_LinkOn) {
 			pHwData->NullPacketCount += TimeInterval;
-			if (pHwData->NullPacketCount >=
-			    DEFAULT_NULL_PACKET_COUNT) {
+			if (pHwData->NullPacketCount >= DEFAULT_NULL_PACKET_COUNT)
 				pHwData->NullPacketCount = 0;
-			}
 		}
 	}
 
 	pHwData->time_count += TimeInterval;
-	Wb35Tx_CurrentTime(adapter, pHwData->time_count);	// 20060928 add
+	/* 20060928 add */
+	Wb35Tx_CurrentTime(adapter, pHwData->time_count);
 	pHwData->LEDTimer.expires = jiffies + msecs_to_jiffies(TimeInterval);
 	add_timer(&pHwData->LEDTimer);
 }
@@ -654,7 +692,7 @@ static int hal_init_hardware(struct ieee80211_hw *hw)
 	SoftwareSet = hal_software_set(pHwData);
 
 #ifdef Vendor2
-	// Try to make sure the EEPROM contain
+	/* Try to make sure the EEPROM contain */
 	SoftwareSet >>= 8;
 	if (SoftwareSet != 0x82)
 		return false;
@@ -737,7 +775,7 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 
 	priv->sLocalPara.bAntennaNo = hal_get_antenna_number(pHwData);
 #ifdef _PE_STATE_DUMP_
-	printk("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo);
+	printk(KERN_INFO "Driver init, antenna no = %d\n", psLOCAL->bAntennaNo);
 #endif
 	hal_get_hw_radio_off(pHwData);
 
@@ -811,7 +849,7 @@ static int wb35_probe(struct usb_interface *intf,
 	endpoint = &interface->endpoint[0].desc;
 
 	if (endpoint[2].wMaxPacketSize == 512) {
-		printk("[w35und] Working on USB 2.0\n");
+		printk(KERN_INFO "[w35und] Working on USB 2.0\n");
 		pWbUsb->IsUsb20 = 1;
 	}
 
@@ -869,7 +907,7 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 	/* Turn off Rx and Tx hardware ability */
 	hal_stop(&adapter->sHwData);
 #ifdef _PE_USB_INI_DUMP_
-	printk("[w35und] Hal_stop O.K.\n");
+	printk(KERN_INFO "[w35und] Hal_stop O.K.\n");
 #endif
 	/* Waiting Irp completed */
 	msleep(100);
-- 
1.6.3.3

