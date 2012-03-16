Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945951Ab2CPWt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:49:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54205 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032103Ab2CPWtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:49:25 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 4/5] Staging: rtl8187se: r8185b_init.c: Removed old comments
Date: Fri, 16 Mar 2012 18:47:39 -0400
Message-Id: <1331938060-10207-5-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331938060-10207-1-git-send-email-amiller@amilx.com>
References: <1331938060-10207-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed some old comments and a few blank lines

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |   24 ++----------------------
 1 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 3f9be9b..d90cf10 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -25,13 +25,10 @@ Notes:
 #include "r8180_rtl8225.h" /* RTL8225 Radio frontend */
 #include "r8180_93cx6.h"   /* Card EEPROM */
 #include "r8180_wx.h"
-
 #include "ieee80211/dot11d.h"
-
-
 /* #define CONFIG_RTL8180_IO_MAP */
-
 #define TC_3W_POLL_MAX_TRY_CNT 5
+
 static u8 MAC_REG_TABLE[][2] =	{
 	/*PAGA 0:	*/
 	/* 0x34(BRSR), 0xBE(RATE_FALLBACK_CTL), 0x1E0(ARFR) would set in HwConfigureRTL8185() */
@@ -133,7 +130,6 @@ u8 PlatformIORead1Byte(struct net_device *dev, u32 offset);
 
 void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 {
-/* {by amy 080312 */
 	if (offset == PhyAddr) {
 	/* For Base Band configuration. */
 		unsigned char	cmdByte;
@@ -169,9 +165,7 @@ void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 		write_nic_byte(dev, offset, cmdByte);
 
 		/* NdisReleaseSpinLock( &(pDevice->IoSpinLock) ); */
-	}
-/* by amy 080312} */
-	else	{
+	} else {
 		write_nic_dword(dev, offset, data);
 		read_nic_dword(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko. */
 	}
@@ -393,7 +387,6 @@ u8 ReadBBPortUchar(struct net_device *dev, u32 addr)
 
 	return RegisterContent;
 }
-/* {by amy 080312 */
 /*
 	Description:
 	Perform Antenna settings with antenna diversity on 87SE.
@@ -465,7 +458,6 @@ bool SetAntennaConfig87SE(struct net_device *dev,
 	priv->CurrAntennaIndex = DefaultAnt; /* Update default settings. */
 	return	bAntennaSwitched;
 }
-/* by amy 080312 */
 /*
 ---------------------------------------------------------------
 	*	Hardware Initialization.
@@ -583,7 +575,6 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 	/* DAC calibration off 20070702	*/
 	RF_WriteReg(dev, 0x06, 0x00c1);		mdelay(1);
 	RF_WriteReg(dev, 0x0a, 0x0001);		mdelay(1);
-/* {by amy 080312 */
 	/* For crystal calibration, added by Roger, 2007.12.11. */
 	if (priv->bXtalCalibration) { /* reg 30.	*/
 	 /* enable crystal calibration.
@@ -598,7 +589,6 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 		/* using default value. Xin=6, Xout=6.	*/
 		RF_WriteReg(dev, 0x0f, 0x0acc);		mdelay(1);
 	}
-/* by amy 080312 */
 
 	RF_WriteReg(dev, 0x00, 0x00bf);		mdelay(1); /* switch to reg0-reg15, and HSSI enable */
 	RF_WriteReg(dev, 0x0d, 0x08df);		mdelay(1); /* Rx BB start calibration, 00c//+edward */
@@ -692,11 +682,8 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 	by amy for antenna
 	=============================================================================
 	*/
-/* {by amy 080312 */
 	/* Config Sw/Hw  Combinational Antenna Diversity. Added by Roger, 2008.02.26.	*/
 	SetAntennaConfig87SE(dev, priv->bDefaultAntenna1, priv->bSwAntennaDiverity);
-/* by amy 080312} */
-/* by amy for antenna */
 }
 
 
@@ -792,7 +779,6 @@ void PhyConfig8185(struct net_device *dev)
 	   priv->RFProgType = read_nic_byte(dev, CONFIG4) & 0x03;
 	/*  RF config */
 	ZEBRA_Config_85BASIC_HardCode(dev);
-/* {by amy 080312 */
 	/* Set default initial gain state to 4, approved by SD3 DZ, by Bruce, 2007-06-06. */
 	if (priv->bDigMechanism) {
 		if (priv->InitialGain == 0)
@@ -807,7 +793,6 @@ void PhyConfig8185(struct net_device *dev)
 	if (priv->bTxPowerTrack)
 		InitTxPwrTracking87SE(dev);
 
-/* by amy 080312} */
 	priv->InitialGainBackUp = priv->InitialGain;
 	UpdateInitialGain(dev);
 
@@ -1055,7 +1040,6 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 					PACI_AIFSN	pAciAifsn = (PACI_AIFSN)(&pAcParam->f.AciAifsn);
 					AC_CODING	eACI = pAciAifsn->f.ACI;
 
-					/*modified Joseph */
 					/*for 8187B AsynIORead issue */
 					u8	AcmCtrl = 0;
 					if (pAciAifsn->f.ACM) {
@@ -1158,7 +1142,6 @@ void rtl8185b_irq_enable(struct net_device *dev)
 	write_nic_dword(dev, IMR, priv->IntrMask);
 }
 
-/* by amy for power save */
 void DrvIFIndicateDisassociation(struct net_device *dev, u16 reason)
 {
 		/* nothing is needed after disassociation request. */
@@ -1565,7 +1548,6 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	/* One of B, G, A. */
 		InitWirelessMode = ieee->mode;
 	}
-/* by amy for power save */
 	priv->eRFPowerState = eRfOff;
 	priv->RfOffReason = 0;
 	{
@@ -1577,8 +1559,6 @@ void rtl8185b_adapter_start(struct net_device *dev)
 	if (priv->bInactivePs)
 		MgntActSet_RF_State(dev , eRfOff, RF_CHANGE_BY_IPS);
 
-/* by amy for power save */
-
 	ActSetWirelessMode8185(dev, (u8)(InitWirelessMode));
 
 	/* ----------------------------------------------------------------------------- */
-- 
1.7.7.6

