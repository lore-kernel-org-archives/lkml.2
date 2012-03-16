Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032162Ab2CPWtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:49:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60128 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032103Ab2CPWtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:49:17 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 2/5] Staging: rtl8187se: r8185b_init.c: Fix function declarations
Date: Fri, 16 Mar 2012 18:47:37 -0400
Message-Id: <1331938060-10207-3-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331938060-10207-1-git-send-email-amiller@amilx.com>
References: <1331938060-10207-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reformated the function declarations

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |  206 ++++++++-----------------------
 1 files changed, 49 insertions(+), 157 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 3c1ca69..5650ef1 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -117,24 +117,14 @@ static u8 OFDM_CONFIG[]	=	{
 	*	the code is ported from Windows source code
 	----------------------------------------------------------------*/
 
-void
-PlatformIOWrite1Byte(
-	struct net_device *dev,
-	u32		offset,
-	u8		data
-	)
+void PlatformIOWrite1Byte(struct net_device *dev, u32 offset, u8 data)
 {
 	write_nic_byte(dev, offset, data);
 	read_nic_byte(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko. */
 
 }
 
-void
-PlatformIOWrite2Byte(
-	struct net_device *dev,
-	u32		offset,
-	u16		data
-	)
+void PlatformIOWrite2Byte(struct net_device *dev, u32 offset, u16 data)
 {
 	write_nic_word(dev, offset, data);
 	read_nic_word(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko. */
@@ -143,12 +133,7 @@ PlatformIOWrite2Byte(
 }
 u8 PlatformIORead1Byte(struct net_device *dev, u32 offset);
 
-void
-PlatformIOWrite4Byte(
-	struct net_device *dev,
-	u32		offset,
-	u32		data
-	)
+void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 {
 /* {by amy 080312 */
 	if (offset == PhyAddr)	{
@@ -194,11 +179,7 @@ PlatformIOWrite4Byte(
 	}
 }
 
-u8
-PlatformIORead1Byte(
-	struct net_device *dev,
-	u32		offset
-	)
+u8 PlatformIORead1Byte(struct net_device *dev, u32 offset)
 {
 	u8	data = 0;
 
@@ -208,11 +189,7 @@ PlatformIORead1Byte(
 	return data;
 }
 
-u16
-PlatformIORead2Byte(
-	struct net_device *dev,
-	u32		offset
-	)
+u16 PlatformIORead2Byte(struct net_device *dev, u32 offset)
 {
 	u16	data = 0;
 
@@ -222,11 +199,7 @@ PlatformIORead2Byte(
 	return data;
 }
 
-u32
-PlatformIORead4Byte(
-	struct net_device *dev,
-	u32		offset
-	)
+u32 PlatformIORead4Byte(struct net_device *dev, u32 offset)
 {
 	u32	data = 0;
 
@@ -241,14 +214,11 @@ void SetOutputEnableOfRfPins(struct net_device *dev)
 	write_nic_word(dev, RFPinsEnable, 0x1bff);
 }
 
-static int
-HwHSSIThreeWire(
-	struct net_device *dev,
-	u8			*pDataBuf,
-	u8			nDataBufBitCnt,
-	int			bSI,
-	int			bWrite
-	)
+static int HwHSSIThreeWire(struct net_device *dev,
+			   u8 *pDataBuf,
+			   u8 nDataBufBitCnt,
+			   int bSI,
+			   int bWrite)
 {
 	int	bResult = 1;
 	u8	TryCnt;
@@ -370,8 +340,7 @@ HwHSSIThreeWire(
 	return bResult;
 }
 
-void
-RF_WriteReg(struct net_device *dev, u8 offset, u32 data)
+void RF_WriteReg(struct net_device *dev, u8 offset, u32 data)
 {
 	u32 data2Write;
 	u8 len;
@@ -399,11 +368,7 @@ u32 RF_ReadReg(struct net_device *dev, u8 offset)
 
 
 /* by Owen on 04/07/14 for writing BB register successfully */
-void
-WriteBBPortUchar(
-	struct net_device *dev,
-	u32		Data
-	)
+void WriteBBPortUchar(struct net_device *dev, u32 Data)
 {
 	/* u8	TimeoutCounter; */
 	u8	RegisterContent;
@@ -420,11 +385,7 @@ WriteBBPortUchar(
 	}
 }
 
-u8
-ReadBBPortUchar(
-	struct net_device *dev,
-	u32		addr
-	)
+u8 ReadBBPortUchar(struct net_device *dev, u32 addr)
 {
 	/*u8	TimeoutCounter; */
 	u8	RegisterContent;
@@ -440,12 +401,9 @@ ReadBBPortUchar(
 	Perform Antenna settings with antenna diversity on 87SE.
 		Created by Roger, 2008.01.25.
 */
-bool
-SetAntennaConfig87SE(
-	struct	net_device *dev,
-	u8	DefaultAnt, /* 0: Main, 1: Aux. */
-	bool	bAntDiversity /* 1:Enable, 0: Disable. */
-)
+bool SetAntennaConfig87SE(struct net_device *dev,
+			  u8   DefaultAnt, /* 0: Main, 1: Aux. */
+			  bool bAntDiversity) /* 1:Enable, 0: Disable. */
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	bool   bAntennaSwitched = true;
@@ -516,10 +474,7 @@ SetAntennaConfig87SE(
 	*	the code is ported from Windows source code
 ----------------------------------------------------------------*/
 
-void
-ZEBRA_Config_85BASIC_HardCode(
-	struct net_device *dev
-	)
+void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 {
 
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -747,10 +702,7 @@ ZEBRA_Config_85BASIC_HardCode(
 }
 
 
-void
-UpdateInitialGain(
-	struct net_device *dev
-	)
+void UpdateInitialGain(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
@@ -825,10 +777,7 @@ UpdateInitialGain(
 		Tx Power tracking mechanism routine on 87SE.
 	Created by Roger, 2007.12.11.
 */
-void
-InitTxPwrTracking87SE(
-	struct net_device *dev
-)
+void InitTxPwrTracking87SE(struct net_device *dev)
 {
 	u32	u4bRfReg;
 
@@ -838,10 +787,7 @@ InitTxPwrTracking87SE(
 	RF_WriteReg(dev, 0x02, u4bRfReg|PWR_METER_EN);			mdelay(1);
 }
 
-void
-PhyConfig8185(
-	struct net_device *dev
-	)
+void PhyConfig8185(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 		write_nic_dword(dev, RCR, priv->ReceiveConfig);
@@ -870,10 +816,7 @@ PhyConfig8185(
 	return;
 }
 
-void
-HwConfigureRTL8185(
-		struct net_device *dev
-		)
+void HwConfigureRTL8185(struct net_device *dev)
 {
 	/* RTL8185_TODO: Determine Retrylimit, TxAGC, AutoRateFallback control. */
 	u8 bUNIVERSAL_CONTROL_RL = 0;
@@ -929,9 +872,7 @@ HwConfigureRTL8185(
 	write_nic_byte(dev, RATE_FALLBACK, val8);
 }
 
-static void
-MacConfig_85BASIC_HardCode(
-	struct net_device *dev)
+static void MacConfig_85BASIC_HardCode(struct net_device *dev)
 {
 	/*
 	============================================================================
@@ -958,9 +899,7 @@ MacConfig_85BASIC_HardCode(
 	/* ============================================================================ */
 }
 
-static void
-MacConfig_85BASIC(
-	struct net_device *dev)
+static void MacConfig_85BASIC(struct net_device *dev)
 {
 
 	u8			u1DA;
@@ -1002,10 +941,7 @@ MacConfig_85BASIC(
 	write_nic_byte(dev, 0x24E, 0x01);
 }
 
-u8
-GetSupportedWirelessMode8185(
-	struct net_device *dev
-)
+u8 GetSupportedWirelessMode8185(struct net_device *dev)
 {
 	u8 btSupportedWirelessMode = 0;
 
@@ -1013,12 +949,9 @@ GetSupportedWirelessMode8185(
 	return btSupportedWirelessMode;
 }
 
-void
-ActUpdateChannelAccessSetting(
-	struct net_device *dev,
-	WIRELESS_MODE			WirelessMode,
-	PCHANNEL_ACCESS_SETTING	ChnlAccessSetting
-	)
+void ActUpdateChannelAccessSetting(struct net_device *dev,
+				   WIRELESS_MODE WirelessMode,
+				   PCHANNEL_ACCESS_SETTING ChnlAccessSetting)
 {
 	struct		r8180_priv *priv = ieee80211_priv(dev);
 	struct		ieee80211_device *ieee = priv->ieee80211;
@@ -1172,11 +1105,7 @@ ActUpdateChannelAccessSetting(
 	}
 }
 
-void
-ActSetWirelessMode8185(
-	struct net_device *dev,
-	u8				btWirelessMode
-	)
+void ActSetWirelessMode8185(struct net_device *dev, u8 btWirelessMode)
 {
 	struct  r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	struct  ieee80211_device *ieee = priv->ieee80211;
@@ -1230,19 +1159,14 @@ void rtl8185b_irq_enable(struct net_device *dev)
 	priv->irq_enabled = 1;
 	write_nic_dword(dev, IMR, priv->IntrMask);
 }
+
 /* by amy for power save */
-void
-DrvIFIndicateDisassociation(
-	struct net_device *dev,
-	u16			reason
-	)
+void DrvIFIndicateDisassociation(struct net_device *dev, u16 reason)
 {
 		/* nothing is needed after disassociation request. */
-	}
-void
-MgntDisconnectIBSS(
-	struct net_device *dev
-)
+}
+
+void MgntDisconnectIBSS(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	u8 i;
@@ -1268,12 +1192,8 @@ MgntDisconnectIBSS(
 	priv->ieee80211->link_change(dev);
 	notify_wx_assoc_event(priv->ieee80211);
 }
-void
-MlmeDisassociateRequest(
-	struct net_device *dev,
-	u8 *asSta,
-	u8	asRsn
-	)
+
+void MlmeDisassociateRequest(struct net_device *dev, u8 *asSta, u8 asRsn)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	u8 i;
@@ -1292,11 +1212,7 @@ MlmeDisassociateRequest(
 	}
 }
 
-void
-MgntDisconnectAP(
-	struct net_device *dev,
-	u8			asRsn
-)
+void MgntDisconnectAP(struct net_device *dev, u8 asRsn)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
@@ -1312,11 +1228,8 @@ MgntDisconnectAP(
 
 	priv->ieee80211->state = IEEE80211_NOLINK;
 }
-bool
-MgntDisconnect(
-	struct net_device *dev,
-	u8			asRsn
-)
+
+bool MgntDisconnect(struct net_device *dev, u8 asRsn)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	/*
@@ -1350,11 +1263,7 @@ MgntDisconnect(
 	Assumption:
 		PASSIVE LEVEL.
 */
-bool
-SetRFPowerState(
-	struct net_device *dev,
-	RT_RF_POWER_STATE	eRFPowerState
-	)
+bool SetRFPowerState(struct net_device *dev, RT_RF_POWER_STATE eRFPowerState)
 {
 	struct	r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	bool	bResult = false;
@@ -1366,25 +1275,16 @@ SetRFPowerState(
 
 	return bResult;
 }
-void
-HalEnableRx8185Dummy(
-	struct net_device *dev
-	)
+
+void HalEnableRx8185Dummy(struct net_device *dev)
 {
 }
-void
-HalDisableRx8185Dummy(
-	struct net_device *dev
-	)
+
+void HalDisableRx8185Dummy(struct net_device *dev)
 {
 }
 
-bool
-MgntActSet_RF_State(
-	struct net_device *dev,
-	RT_RF_POWER_STATE	StateToSet,
-	u32	ChangeSource
-	)
+bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u32 ChangeSource)
 {
 	struct	r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	bool	bActionAllowed = false;
@@ -1488,10 +1388,8 @@ MgntActSet_RF_State(
 	spin_unlock_irqrestore(&priv->rf_ps_lock, flag);
 	return bActionAllowed;
 }
-void
-InactivePowerSave(
-	struct net_device *dev
-	)
+
+void InactivePowerSave(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	/*
@@ -1516,10 +1414,7 @@ InactivePowerSave(
 	Description:
 		Enter the inactive power save mode. RF will be off
 */
-void
-IPSEnter(
-	struct net_device *dev
-	)
+void IPSEnter(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	RT_RF_POWER_STATE rtState;
@@ -1541,10 +1436,7 @@ IPSEnter(
 		}
 	}
 }
-void
-IPSLeave(
-	struct net_device *dev
-	)
+void IPSLeave(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	RT_RF_POWER_STATE rtState;
-- 
1.7.7.6

