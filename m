Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2KCXkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 19:40:39 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39220 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2KCXkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 19:40:36 -0400
From: Mladen Mijatov <meaneye.rcf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mladen Mijatov <meaneye.rcf@gmail.com>
Subject: [PATCH] Staging: rtl8187se: Fixed coding style issues.
Date: Sun,  4 Nov 2012 00:40:26 +0100
Message-Id: <1351986026-26580-1-git-send-email-meaneye.rcf@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.
---
 drivers/staging/rtl8187se/r8185b_init.c |   57 ++++++++++++++++---------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index bf34319..da4f592 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -579,13 +579,13 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 	RF_WriteReg(dev, 0x0a, 0x0001);		mdelay(1);
 	/* For crystal calibration, added by Roger, 2007.12.11. */
 	if (priv->bXtalCalibration) { /* reg 30.	*/
-	 /*
- 	  *  enable crystal calibration.
-	  *		RF Reg[30], (1)Xin:[12:9], Xout:[8:5],  addr[4:0].
-	  *		(2)PA Pwr delay timer[15:14], default: 2.4us, set BIT15=0
-	  *		(3)RF signal on/off when calibration[13], default: on, set BIT13=0.
-	  *		So we should minus 4 BITs offset. 
-	  */
+		/*
+		 *  enable crystal calibration.
+		 *		RF Reg[30], (1)Xin:[12:9], Xout:[8:5],  addr[4:0].
+		 *		(2)PA Pwr delay timer[15:14], default: 2.4us, set BIT15=0
+		 *		(3)RF signal on/off when calibration[13], default: on, set BIT13=0.
+		 *		So we should minus 4 BITs offset.
+		 */
 		RF_WriteReg(dev, 0x0f, (priv->XtalCal_Xin<<5) | (priv->XtalCal_Xout<<1) | BIT11 | BIT9); mdelay(1);
 		printk("ZEBRA_Config_85BASIC_HardCode(): (%02x)\n",
 		      (priv->XtalCal_Xin<<5) | (priv->XtalCal_Xout<<1) | BIT11 | BIT9);
@@ -1120,24 +1120,24 @@ void ActSetWirelessMode8185(struct net_device *dev, u8 btWirelessMode)
 		}
 	}
 
-	/* 
- 	 * 2. Swtich band: RF or BB specific actions,
+	/*
+	 * 2. Swtich band: RF or BB specific actions,
 	 * for example, refresh tables in omc8255, or change initial gain if necessary.
 	 * Nothing to do for Zebra to switch band.
-	 * Update current wireless mode if we switch to specified band successfully. 
+	 * Update current wireless mode if we switch to specified band successfully.
 	 */
 
 	ieee->mode = (WIRELESS_MODE)btWirelessMode;
 
 	/* 3. Change related setting. */
-	if( ieee->mode == WIRELESS_MODE_A ) {
+	if (ieee->mode == WIRELESS_MODE_A) {
 		DMESG("WIRELESS_MODE_A\n");
-	} else if( ieee->mode == WIRELESS_MODE_B ) {
+	} else if (ieee->mode == WIRELESS_MODE_B) {
 		DMESG("WIRELESS_MODE_B\n");
-	} else if( ieee->mode == WIRELESS_MODE_G ) {
+	} else if (ieee->mode == WIRELESS_MODE_G) {
 		DMESG("WIRELESS_MODE_G\n");
 	}
-	ActUpdateChannelAccessSetting( dev, ieee->mode, &priv->ChannelAccessSetting);
+	ActUpdateChannelAccessSetting(dev, ieee->mode, &priv->ChannelAccessSetting);
 }
 
 void rtl8185b_irq_enable(struct net_device *dev)
@@ -1167,13 +1167,14 @@ void MgntDisconnectIBSS(struct net_device *dev)
 
 	priv->ieee80211->state = IEEE80211_NOLINK;
 	/*
-	 *	Stop Beacon.
+	 * Stop Beacon.
 	 *
-	 *	Vista add a Adhoc profile, HW radio off until OID_DOT11_RESET_REQUEST
-	 *	Driver would set MSR=NO_LINK, then HW Radio ON, MgntQueue Stuck.
-	 *	Because Bcn DMA isn't complete, mgnt queue would stuck until Bcn packet send.
+	 * Vista add a Adhoc profile, HW radio off until OID_DOT11_RESET_REQUEST
+	 * Driver would set MSR=NO_LINK, then HW Radio ON, MgntQueue Stuck.
+	 * Because Bcn DMA isn't complete, mgnt queue would stuck until Bcn
+	 * packet send.
 	 *
-	 *	Disable Beacon Queue Own bit, suggested by jong	
+	 * Disable Beacon Queue Own bit, suggested by jong
 	 */
 	ieee80211_stop_send_beacons(priv->ieee80211);
 
@@ -1208,10 +1209,12 @@ void MgntDisconnectAP(struct net_device *dev, u8 asRsn)
 	 * Commented out by rcnjko, 2005.01.27:
 	 * I move SecClearAllKeys() to MgntActSet_802_11_DISASSOCIATE().
 	 *
-	 *	2004/09/15, kcwu, the key should be cleared, or the new handshaking will not success
+	 * 2004/09/15, kcwu, the key should be cleared, or
+	 * the new handshaking will not success
 	 *
-	 *	In WPA WPA2 need to Clear all key ... because new key will set after new handshaking.
-	 *	2004.10.11, by rcnjko. 
+	 * In WPA WPA2 need to Clear all key ... because new key
+	 * will set after new handshaking.
+	 * 2004.10.11, by rcnjko.
 	 */
 	MlmeDisassociateRequest(dev, priv->ieee80211->current_network.bssid, asRsn);
 
@@ -1234,11 +1237,11 @@ bool MgntDisconnect(struct net_device *dev, u8 asRsn)
 
 		if (priv->ieee80211->iw_mode == IW_MODE_INFRA) {
 			/*
- 			 * 	We clear key here instead of MgntDisconnectAP() because that
-			 *	MgntActSet_802_11_DISASSOCIATE() is an interface called by OS,
-			 *	e.g. OID_802_11_DISASSOCIATE in Windows while as MgntDisconnectAP() is
-			 *	used to handle disassociation related things to AP, e.g. send Disassoc
-			 *	frame to AP.  2005.01.27, by rcnjko. 
+			 * We clear key here instead of MgntDisconnectAP() because that
+			 * MgntActSet_802_11_DISASSOCIATE() is an interface called by OS,
+			 * e.g. OID_802_11_DISASSOCIATE in Windows while as MgntDisconnectAP() is
+			 * used to handle disassociation related things to AP, e.g. send Disassoc
+			 * frame to AP.  2005.01.27, by rcnjko.
 			 */
 			MgntDisconnectAP(dev, asRsn);
 		}
-- 
1.7.10.4

