Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945938Ab2CPWte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:49:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57006 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab2CPWt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:49:27 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 5/5] Staging: rtl8187se: r8185b_init.c: Fix comment blocks
Date: Fri, 16 Mar 2012 18:47:40 -0400
Message-Id: <1331938060-10207-6-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331938060-10207-1-git-send-email-amiller@amilx.com>
References: <1331938060-10207-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reformated comment blocks to meet Coding Style

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |  348 ++++++++++++++++---------------
 1 files changed, 179 insertions(+), 169 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index d90cf10..af9be96 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -1,22 +1,22 @@
-/*++
-Copyright (c) Realtek Semiconductor Corp. All rights reserved.
-
-Module Name:
-	r8185b_init.c
-
-Abstract:
-	Hardware Initialization and Hardware IO for RTL8185B
-
-Major Change History:
-	When		Who				What
-	----------	---------------		-------------------------------
-	2006-11-15	Xiong			Created
-
-Notes:
-	This file is ported from RTL8185B Windows driver.
-
-
---*/
+/*
+ * Copyright (c) Realtek Semiconductor Corp. All rights reserved.
+ *
+ * Module Name:
+ *	r8185b_init.c
+ *
+ * Abstract:
+ *	Hardware Initialization and Hardware IO for RTL8185B
+ *
+ * Major Change History:
+ *	When		Who				What
+ *	----------	---------------		-------------------------------
+ *	2006-11-15	Xiong			Created
+ *
+ * Notes:
+ *	This file is ported from RTL8185B Windows driver.
+ *
+ *
+ */
 
 /*--------------------------Include File------------------------------------*/
 #include <linux/spinlock.h>
@@ -110,9 +110,10 @@ static u8 OFDM_CONFIG[]	= {
 	};
 
 	/*---------------------------------------------------------------
-	*	Hardware IO
-	*	the code is ported from Windows source code
-	----------------------------------------------------------------*/
+	 *	Hardware IO
+	 *	the code is ported from Windows source code
+	 *---------------------------------------------------------------
+	 */
 
 void PlatformIOWrite1Byte(struct net_device *dev, u32 offset, u8 data)
 {
@@ -141,13 +142,13 @@ void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 		dataBytes = data>>8;
 
 		/*
-			071010, rcnjko:
-			The critical section is only BB read/write race condition.
-			Assumption:
-			1. We assume NO one will access BB at DIRQL, otherwise, system will crash for
-			acquiring the spinlock in such context.
-			2. PlatformIOWrite4Byte() MUST NOT be recursive.
-		*/
+		 *	071010, rcnjko:
+		 *	The critical section is only BB read/write race condition.
+		 *	Assumption:
+		 *	1. We assume NO one will access BB at DIRQL, otherwise, system will crash for
+		 *	acquiring the spinlock in such context.
+		 *	2. PlatformIOWrite4Byte() MUST NOT be recursive.
+		 */
 		/* NdisAcquireSpinLock( &(pDevice->IoSpinLock) ); */
 
 		for (idx = 0; idx < 30; idx++) {
@@ -388,10 +389,10 @@ u8 ReadBBPortUchar(struct net_device *dev, u32 addr)
 	return RegisterContent;
 }
 /*
-	Description:
-	Perform Antenna settings with antenna diversity on 87SE.
-		Created by Roger, 2008.01.25.
-*/
+ *	Description:
+ *	Perform Antenna settings with antenna diversity on 87SE.
+ *		Created by Roger, 2008.01.25.
+ */
 bool SetAntennaConfig87SE(struct net_device *dev,
 			  u8   DefaultAnt, /* 0: Main, 1: Aux. */
 			  bool bAntDiversity) /* 1:Enable, 0: Disable. */
@@ -459,10 +460,11 @@ bool SetAntennaConfig87SE(struct net_device *dev,
 	return	bAntennaSwitched;
 }
 /*
----------------------------------------------------------------
-	*	Hardware Initialization.
-	*	the code is ported from Windows source code
-----------------------------------------------------------------*/
+ *--------------------------------------------------------------
+ *		Hardware Initialization.
+ *		the code is ported from Windows source code
+ *--------------------------------------------------------------
+ */
 
 void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 {
@@ -476,10 +478,10 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 
 
 /*
-=============================================================================
-	87S_PCIE :: RADIOCFG.TXT
-=============================================================================
-*/
+ *===========================================================================
+ *	87S_PCIE :: RADIOCFG.TXT
+ *===========================================================================
+ */
 
 
 	/* Page1 : reg16-reg30 */
@@ -577,11 +579,13 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 	RF_WriteReg(dev, 0x0a, 0x0001);		mdelay(1);
 	/* For crystal calibration, added by Roger, 2007.12.11. */
 	if (priv->bXtalCalibration) { /* reg 30.	*/
-	 /* enable crystal calibration.
-			RF Reg[30], (1)Xin:[12:9], Xout:[8:5],  addr[4:0].
-			(2)PA Pwr delay timer[15:14], default: 2.4us, set BIT15=0
-			(3)RF signal on/off when calibration[13], default: on, set BIT13=0.
-			So we should minus 4 BITs offset. */
+	 /*
+ 	  *  enable crystal calibration.
+	  *		RF Reg[30], (1)Xin:[12:9], Xout:[8:5],  addr[4:0].
+	  *		(2)PA Pwr delay timer[15:14], default: 2.4us, set BIT15=0
+	  *		(3)RF signal on/off when calibration[13], default: on, set BIT13=0.
+	  *		So we should minus 4 BITs offset. 
+	  */
 		RF_WriteReg(dev, 0x0f, (priv->XtalCal_Xin<<5) | (priv->XtalCal_Xout<<1) | BIT11 | BIT9); mdelay(1);
 		printk("ZEBRA_Config_85BASIC_HardCode(): (%02x)\n",
 		      (priv->XtalCal_Xin<<5) | (priv->XtalCal_Xout<<1) | BIT11 | BIT9);
@@ -607,18 +611,18 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 	write_nic_byte(dev, 0x24E, (u1b24E & (~(BIT5|BIT6))));
 
 	/*=============================================================================
-
-	=============================================================================
-	CCKCONF.TXT
-	=============================================================================
-	*/
-	/*	[POWER SAVE] Power Saving Parameters by jong. 2007-11-27
-		CCK reg0x00[7]=1'b1 :power saving for TX (default)
-		CCK reg0x00[6]=1'b1: power saving for RX (default)
-		CCK reg0x06[4]=1'b1: turn off channel estimation related circuits if not doing channel estimation.
-		CCK reg0x06[3]=1'b1: turn off unused circuits before cca = 1
-		CCK reg0x06[2]=1'b1: turn off cck's circuit if macrst =0
-	*/
+	 *
+	 *===========================================================================
+	 * CCKCONF.TXT
+	 *===========================================================================
+	 *
+	 *	[POWER SAVE] Power Saving Parameters by jong. 2007-11-27
+	 *	CCK reg0x00[7]=1'b1 :power saving for TX (default)
+	 *	CCK reg0x00[6]=1'b1: power saving for RX (default)
+	 *	CCK reg0x06[4]=1'b1: turn off channel estimation related circuits if not doing channel estimation.
+	 *	CCK reg0x06[3]=1'b1: turn off unused circuits before cca = 1
+	 *	CCK reg0x06[2]=1'b1: turn off cck's circuit if macrst =0
+	 */
 
 	write_phy_cck(dev, 0x00, 0xc8);
 	write_phy_cck(dev, 0x06, 0x1c);
@@ -635,10 +639,10 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 
 
 	/*
-	=============================================================================
-		AGC.txt
-	=============================================================================
-	*/
+	 *===========================================================================
+	 *	AGC.txt
+	 *===========================================================================
+	 */
 
 	write_phy_ofdm(dev, 0x00, 0x12);
 
@@ -660,12 +664,12 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 	PlatformIOWrite4Byte(dev, PhyAddr, 0x00001080);	/* Annie, 2006-05-05 */
 
 	/*
-	=============================================================================
-
-	=============================================================================
-	OFDMCONF.TXT
-	=============================================================================
-	*/
+	 *===========================================================================
+	 *
+	 *===========================================================================
+	 * OFDMCONF.TXT
+	 *===========================================================================
+	 */
 
 	for (i = 0; i < 60; i++) {
 		u4bRegOffset = i;
@@ -678,10 +682,10 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 	}
 
 	/*
-	=============================================================================
-	by amy for antenna
-	=============================================================================
-	*/
+	 *===========================================================================
+	 * by amy for antenna
+	 *===========================================================================
+	 */
 	/* Config Sw/Hw  Combinational Antenna Diversity. Added by Roger, 2008.02.26.	*/
 	SetAntennaConfig87SE(dev, priv->bDefaultAntenna1, priv->bSwAntennaDiverity);
 }
@@ -694,9 +698,9 @@ void UpdateInitialGain(struct net_device *dev)
 	/* lzm add 080826 */
 	if (priv->eRFPowerState != eRfOn) {
 		/*	Don't access BB/RF under disable PLL situation.
-			RT_TRACE(COMP_DIG, DBG_LOUD, ("UpdateInitialGain - pHalData->eRFPowerState!=eRfOn\n"));
-			Back to the original state
-		*/
+		 *	RT_TRACE(COMP_DIG, DBG_LOUD, ("UpdateInitialGain - pHalData->eRFPowerState!=eRfOn\n"));
+		 *	Back to the original state
+		 */
 		priv->InitialGain = priv->InitialGainBackUp;
 		return;
 	}
@@ -758,10 +762,10 @@ void UpdateInitialGain(struct net_device *dev)
 	}
 }
 /*
-	Description:
-		Tx Power tracking mechanism routine on 87SE.
-	Created by Roger, 2007.12.11.
-*/
+ *	Description:
+ *		Tx Power tracking mechanism routine on 87SE.
+ *	Created by Roger, 2007.12.11.
+ */
 void InitTxPwrTracking87SE(struct net_device *dev)
 {
 	u32	u4bRfReg;
@@ -786,10 +790,10 @@ void PhyConfig8185(struct net_device *dev)
 	}
 
 	/*
-		Enable thermal meter indication to implement TxPower tracking on 87SE.
-		We initialize thermal meter here to avoid unsuccessful configuration.
-		Added by Roger, 2007.12.11.
-	*/
+	 *	Enable thermal meter indication to implement TxPower tracking on 87SE.
+	 *	We initialize thermal meter here to avoid unsuccessful configuration.
+	 *	Added by Roger, 2007.12.11.
+	 */
 	if (priv->bTxPowerTrack)
 		InitTxPwrTracking87SE(dev);
 
@@ -858,10 +862,10 @@ void HwConfigureRTL8185(struct net_device *dev)
 static void MacConfig_85BASIC_HardCode(struct net_device *dev)
 {
 	/*
-	============================================================================
-	MACREG.TXT
-	============================================================================
-	*/
+	 *==========================================================================
+	 * MACREG.TXT
+	 *==========================================================================
+	 */
 	int nLinesRead = 0;
 	u32 u4bRegOffset, u4bRegValue, u4bPageIndex = 0;
 	int i;
@@ -944,15 +948,15 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 	u8		u1bAIFS;
 
 	/*
-		<RJ_TODO_8185B>
-		TODO: We still don't know how to set up these registers, just follow WMAC to
-		verify 8185B FPAG.
-
-		<RJ_TODO_8185B>
-		Jong said CWmin/CWmax register are not functional in 8185B,
-		so we shall fill channel access realted register into AC parameter registers,
-		even in nQBss.
-	*/
+	 *	<RJ_TODO_8185B>
+	 *	TODO: We still don't know how to set up these registers, just follow WMAC to
+	 *	verify 8185B FPAG.
+	 *
+	 *	<RJ_TODO_8185B>
+	 *	Jong said CWmin/CWmax register are not functional in 8185B,
+	 *	so we shall fill channel access realted register into AC parameter registers,
+	 *	even in nQBss.
+	 */
 	ChnlAccessSetting->SIFS_Timer = 0x22; /* Suggested by Jong, 2005.12.08. */
 	ChnlAccessSetting->DIFS_Timer = 0x1C; /* 2006.06.02, by rcnjko. */
 	ChnlAccessSetting->SlotTimeTimer = 9; /* 2006.06.02, by rcnjko. */
@@ -978,9 +982,9 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 	if (bFollowLegacySetting) {
 
 		/*
-			Follow 802.11 seeting to AC parameter, all AC shall use the same parameter.
-			2005.12.01, by rcnjko.
-		*/
+		 *	Follow 802.11 seeting to AC parameter, all AC shall use the same parameter.
+		 *	2005.12.01, by rcnjko.
+		 */
 		AcParam.longData = 0;
 		AcParam.f.AciAifsn.f.AIFSN = 2; /* Follow 802.11 DIFS.	*/
 		AcParam.f.AciAifsn.f.ACM = 0;
@@ -1116,10 +1120,12 @@ void ActSetWirelessMode8185(struct net_device *dev, u8 btWirelessMode)
 		}
 	}
 
-	/* 2. Swtich band: RF or BB specific actions,
+	/* 
+ 	 * 2. Swtich band: RF or BB specific actions,
 	 * for example, refresh tables in omc8255, or change initial gain if necessary.
 	 * Nothing to do for Zebra to switch band.
-	 * Update current wireless mode if we swtich to specified band successfully. */
+	 * Update current wireless mode if we swtich to specified band successfully. 
+	 */
 
 	ieee->mode = (WIRELESS_MODE)btWirelessMode;
 
@@ -1161,13 +1167,14 @@ void MgntDisconnectIBSS(struct net_device *dev)
 
 	priv->ieee80211->state = IEEE80211_NOLINK;
 	/*
-		Stop Beacon.
-
-		Vista add a Adhoc profile, HW radio off until OID_DOT11_RESET_REQUEST
-		Driver would set MSR=NO_LINK, then HW Radio ON, MgntQueue Stuck.
-		Because Bcn DMA isn't complete, mgnt queue would stuck until Bcn packet send.
-
-		Disable Beacon Queue Own bit, suggested by jong	*/
+	 *	Stop Beacon.
+	 *
+	 *	Vista add a Adhoc profile, HW radio off until OID_DOT11_RESET_REQUEST
+	 *	Driver would set MSR=NO_LINK, then HW Radio ON, MgntQueue Stuck.
+	 *	Because Bcn DMA isn't complete, mgnt queue would stuck until Bcn packet send.
+	 *
+	 *	Disable Beacon Queue Own bit, suggested by jong	
+	 */
 	ieee80211_stop_send_beacons(priv->ieee80211);
 
 	priv->ieee80211->link_change(dev);
@@ -1198,13 +1205,14 @@ void MgntDisconnectAP(struct net_device *dev, u8 asRsn)
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
 	/*
-	Commented out by rcnjko, 2005.01.27:
-	I move SecClearAllKeys() to MgntActSet_802_11_DISASSOCIATE().
-
-		2004/09/15, kcwu, the key should be cleared, or the new handshaking will not success
-
-		In WPA WPA2 need to Clear all key ... because new key will set after new handshaking.
-		2004.10.11, by rcnjko. */
+	 * Commented out by rcnjko, 2005.01.27:
+	 * I move SecClearAllKeys() to MgntActSet_802_11_DISASSOCIATE().
+	 *
+	 *	2004/09/15, kcwu, the key should be cleared, or the new handshaking will not success
+	 *
+	 *	In WPA WPA2 need to Clear all key ... because new key will set after new handshaking.
+	 *	2004.10.11, by rcnjko. 
+	 */
 	MlmeDisassociateRequest(dev, priv->ieee80211->current_network.bssid, asRsn);
 
 	priv->ieee80211->state = IEEE80211_NOLINK;
@@ -1214,8 +1222,8 @@ bool MgntDisconnect(struct net_device *dev, u8 asRsn)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	/*
-		Schedule an workitem to wake up for ps mode, 070109, by rcnjko.
-	*/
+	 *	Schedule an workitem to wake up for ps mode, 070109, by rcnjko.
+	 */
 
 	if (IS_DOT11D_ENABLE(priv->ieee80211))
 		Dot11d_Reset(priv->ieee80211);
@@ -1225,11 +1233,13 @@ bool MgntDisconnect(struct net_device *dev, u8 asRsn)
 			MgntDisconnectIBSS(dev);
 
 		if (priv->ieee80211->iw_mode == IW_MODE_INFRA) {
-			/*	We clear key here instead of MgntDisconnectAP() because that
-				MgntActSet_802_11_DISASSOCIATE() is an interface called by OS,
-				e.g. OID_802_11_DISASSOCIATE in Windows while as MgntDisconnectAP() is
-				used to handle disassociation related things to AP, e.g. send Disassoc
-				frame to AP.  2005.01.27, by rcnjko. */
+			/*
+ 			 * 	We clear key here instead of MgntDisconnectAP() because that
+			 *	MgntActSet_802_11_DISASSOCIATE() is an interface called by OS,
+			 *	e.g. OID_802_11_DISASSOCIATE in Windows while as MgntDisconnectAP() is
+			 *	used to handle disassociation related things to AP, e.g. send Disassoc
+			 *	frame to AP.  2005.01.27, by rcnjko. 
+			 */
 			MgntDisconnectAP(dev, asRsn);
 		}
 		/* Inidicate Disconnect, 2005.02.23, by rcnjko.	*/
@@ -1237,13 +1247,13 @@ bool MgntDisconnect(struct net_device *dev, u8 asRsn)
 	return true;
 }
 /*
-	Description:
-		Chang RF Power State.
-		Note that, only MgntActSet_RF_State() is allowed to set HW_VAR_RF_STATE.
-
-	Assumption:
-		PASSIVE LEVEL.
-*/
+ *	Description:
+ *		Chang RF Power State.
+ *		Note that, only MgntActSet_RF_State() is allowed to set HW_VAR_RF_STATE.
+ *
+ *	Assumption:
+ *		PASSIVE LEVEL.
+ */
 bool SetRFPowerState(struct net_device *dev, RT_RF_POWER_STATE eRFPowerState)
 {
 	struct	r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -1274,9 +1284,9 @@ bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u
 	u16	RFWaitCounter = 0;
 	unsigned long flag;
 	/*
-		Prevent the race condition of RF state change. By Bruce, 2007-11-28.
-		Only one thread can change the RF state at one time, and others should wait to be executed.
-	*/
+	 *	Prevent the race condition of RF state change. By Bruce, 2007-11-28.
+	 *	Only one thread can change the RF state at one time, and others should wait to be executed.
+	 */
 	while (true) {
 		spin_lock_irqsave(&priv->rf_ps_lock, flag);
 		if (priv->RFChangeInProgress) {
@@ -1304,9 +1314,9 @@ bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u
 	switch (StateToSet) {
 	case eRfOn:
 		/*
-			Turn On RF no matter the IPS setting because we need to update the RF state to Ndis under Vista, or
-			the Windows does not allow the driver to perform site survey any more. By Bruce, 2007-10-02.
-		*/
+		 *	Turn On RF no matter the IPS setting because we need to update the RF state to Ndis under Vista, or
+		 *	the Windows does not allow the driver to perform site survey any more. By Bruce, 2007-10-02.
+		 */
 		priv->RfOffReason &= (~ChangeSource);
 
 		if (!priv->RfOffReason)	{
@@ -1325,12 +1335,12 @@ bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u
 
 		if (priv->RfOffReason > RF_CHANGE_BY_IPS) {
 			/*
-				060808, Annie:
-				Disconnect to current BSS when radio off. Asked by QuanTa.
-
-				Calling MgntDisconnect() instead of MgntActSet_802_11_DISASSOCIATE(),
-				because we do NOT need to set ssid to dummy ones.
-			*/
+			 *	060808, Annie:
+			 *	Disconnect to current BSS when radio off. Asked by QuanTa.
+			 *
+			 *	Calling MgntDisconnect() instead of MgntActSet_802_11_DISASSOCIATE(),
+			 *	because we do NOT need to set ssid to dummy ones.
+			 */
 			MgntDisconnect(dev, disas_lv_ss);
 			/* Clear content of bssDesc[] and bssDesc4Query[] to avoid reporting old bss to UI. */
 		}
@@ -1374,27 +1384,27 @@ void InactivePowerSave(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	/*
-		This flag "bSwRfProcessing", indicates the status of IPS procedure, should be set if the IPS workitem
-		is really scheduled.
-		The old code, sets this flag before scheduling the IPS workitem and however, at the same time the
-		previous IPS workitem did not end yet, fails to schedule the current workitem. Thus, bSwRfProcessing
-		blocks the IPS procedure of switching RF.
-	*/
+	 *	This flag "bSwRfProcessing", indicates the status of IPS procedure, should be set if the IPS workitem
+	 *	is really scheduled.
+	 *	The old code, sets this flag before scheduling the IPS workitem and however, at the same time the
+	 *	previous IPS workitem did not end yet, fails to schedule the current workitem. Thus, bSwRfProcessing
+	 *	blocks the IPS procedure of switching RF.
+	 */
 	priv->bSwRfProcessing = true;
 
 	MgntActSet_RF_State(dev, priv->eInactivePowerState, RF_CHANGE_BY_IPS);
 
 	/*
-		To solve CAM values miss in RF OFF, rewrite CAM values after RF ON. By Bruce, 2007-09-20.
-	*/
+	 *	To solve CAM values miss in RF OFF, rewrite CAM values after RF ON. By Bruce, 2007-09-20.
+	 */
 
 	priv->bSwRfProcessing = false;
 }
 
 /*
-	Description:
-		Enter the inactive power save mode. RF will be off
-*/
+ *	Description:
+ *		Enter the inactive power save mode. RF will be off
+ */
 void IPSEnter(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -1403,13 +1413,13 @@ void IPSEnter(struct net_device *dev)
 		rtState = priv->eRFPowerState;
 
 		/*
-			Do not enter IPS in the following conditions:
-			(1) RF is already OFF or Sleep
-			(2) bSwRfProcessing (indicates the IPS is still under going)
-			(3) Connectted (only disconnected can trigger IPS)
-			(4) IBSS (send Beacon)
-			(5) AP mode (send Beacon)
-		*/
+		 *	Do not enter IPS in the following conditions:
+		 *	(1) RF is already OFF or Sleep
+		 *	(2) bSwRfProcessing (indicates the IPS is still under going)
+		 *	(3) Connectted (only disconnected can trigger IPS)
+		 *	(4) IBSS (send Beacon)
+		 *	(5) AP mode (send Beacon)
+		 */
 		if (rtState == eRfOn && !priv->bSwRfProcessing
 			&& (priv->ieee80211->state != IEEE80211_LINKED)) {
 			priv->eInactivePowerState = eRfOff;
@@ -1463,10 +1473,10 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	PlatformIOWrite2Byte(dev, RFSW_CTRL, 0x569a);
 
 	/*
-	-----------------------------------------------------------------------------
-		Set up PHY related.
-	-----------------------------------------------------------------------------
-	*/
+	 *---------------------------------------------------------------------------
+	 *	Set up PHY related.
+	 *---------------------------------------------------------------------------
+	 */
 	/* Enable Config3.PARAM_En to revise AnaaParm. */
 	write_nic_byte(dev, CR9346, 0xc0); /* enable config register write */
 	tmpu8 = read_nic_byte(dev, CONFIG3);
@@ -1505,10 +1515,10 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	PhyConfig8185(dev);
 
 	/*
-		We assume RegWirelessMode has already been initialized before,
-		however, we has to validate the wireless mode here and provide a
-		reasonable initialized value if necessary. 2005.01.13, by rcnjko.
-	*/
+	 *	We assume RegWirelessMode has already been initialized before,
+	 *	however, we has to validate the wireless mode here and provide a
+	 *	reasonable initialized value if necessary. 2005.01.13, by rcnjko.
+	 */
 	SupportedWirelessMode = GetSupportedWirelessMode8185(dev);
 	if ((ieee->mode != WIRELESS_MODE_B) &&
 		(ieee->mode != WIRELESS_MODE_G) &&
@@ -1554,8 +1564,8 @@ void rtl8185b_adapter_start(struct net_device *dev)
 		MgntActSet_RF_State(dev, eRfOn, 0);
 	}
 		/*
-			If inactive power mode is enabled, disable rf while in disconnected state.
-		*/
+		 *	If inactive power mode is enabled, disable rf while in disconnected state.
+		 */
 	if (priv->bInactivePs)
 		MgntActSet_RF_State(dev , eRfOff, RF_CHANGE_BY_IPS);
 
-- 
1.7.7.6

