Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab0FEKhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:37:45 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:3123 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933164Ab0FEKge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:36:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Amu6APbECUw6B9wNPGdsb2JhbACHb5ELBoVUDAEBAQE1LbAkjUSFFwSDSA
X-IronPort-AV: E=Sophos;i="4.53,366,1272816000"; 
   d="scan'208";a="77635038"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 10/12] staging: rtl8192u: remove C99 comments to line 4500 in file rtl8192U_core.c Patch to continue removal of all C99 style comments in file rtl8192U_core.c Fixed up until line 4588
Date: Sat,  5 Jun 2010 18:36:25 +0800
Message-Id: <1275734187-26583-11-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275734187-26583-10-git-send-email-mike.kernel@gilksonline.com>
References: <1275734187-26583-1-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-2-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-3-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-4-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-5-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-6-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-7-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-8-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-9-git-send-email-mike.kernel@gilksonline.com>
 <1275734187-26583-10-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  461 +++++++++++++++++---------------
 1 files changed, 248 insertions(+), 213 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index a7b43a0..d4498fe 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3064,13 +3064,13 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 		else
 			priv->EEPROMCrystalCap = EEPROM_Default_CrystalCap;
 		RT_TRACE(COMP_EPROM, "CrystalCap = %d\n", priv->EEPROMCrystalCap);
-		//get per-channel Tx power level
+		/* get per-channel Tx power level */
 		if (bLoad_From_EEPOM)
 			priv->EEPROM_Def_Ver = (eprom_read(dev, (EEPROM_TxPwIndex_Ver>>1))&0xff00)>>8;
 		else
 			priv->EEPROM_Def_Ver = 1;
 		RT_TRACE(COMP_EPROM, "EEPROM_DEF_VER:%d\n", priv->EEPROM_Def_Ver);
-		if (priv->EEPROM_Def_Ver == 0) //old eeprom definition
+		if (priv->EEPROM_Def_Ver == 0)	/* old eeprom definition */
 		{
 			int i;
 			if (bLoad_From_EEPOM)
@@ -3093,7 +3093,7 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 				priv->EEPROMTxPowerLevelOFDM24G[i] = (u8) tmpValue;
 				RT_TRACE(COMP_EPROM, "OFDM 2.4G Tx Power Level, Index %d = 0x%02x\n", i, priv->EEPROMTxPowerLevelCCK);
 			}
-		}//end if EEPROM_DEF_VER == 0
+		}	/* end if EEPROM_DEF_VER == 0 */
 		else if (priv->EEPROM_Def_Ver == 1)
 		{
 			if (bLoad_From_EEPOM)
@@ -3120,29 +3120,24 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 			else
 				tmpValue = 0x10;
 			priv->EEPROMTxPowerLevelOFDM24G[2] = (u8)tmpValue;
-		}//endif EEPROM_Def_Ver == 1
+		}		/* endif EEPROM_Def_Ver == 1 */
 
-		//update HAL variables
-		//
+		/* update HAL variables */
 		{
 			int i;
-			for (i=0; i<14; i++)
-			{
-				if (i<=3)
+			for (i = 0; i < 14; i++) {
+				if (i <= 3)
 					priv->TxPowerLevelOFDM24G[i] = priv->EEPROMTxPowerLevelOFDM24G[0];
-				else if (i>=4 && i<=9)
+				else if (i >= 4 && i <= 9)
 					priv->TxPowerLevelOFDM24G[i] = priv->EEPROMTxPowerLevelOFDM24G[1];
 				else
 					priv->TxPowerLevelOFDM24G[i] = priv->EEPROMTxPowerLevelOFDM24G[2];
 			}
-
-			for (i=0; i<14; i++)
-			{
-				if (priv->EEPROM_Def_Ver == 0)
-				{
-					if (i<=3)
+			for (i = 0; i < 14; i++) {
+				if (priv->EEPROM_Def_Ver == 0) {
+					if (i <= 3)
 						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelOFDM24G[0] + (priv->EEPROMTxPowerLevelCCK - priv->EEPROMTxPowerLevelOFDM24G[1]);
-					else if (i>=4 && i<=9)
+					else if (i >= 4 && i <= 9)
 						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelCCK;
 					else
 						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelOFDM24G[2] + (priv->EEPROMTxPowerLevelCCK - priv->EEPROMTxPowerLevelOFDM24G[1]);
@@ -3157,20 +3152,20 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 						priv->TxPowerLevelCCK[i] = priv->EEPROMTxPowerLevelCCK_V1[2];
 				}
 			}
-		}//end update HAL variables
+		}	/* end update HAL variables */
 		priv->TxPowerDiff = priv->EEPROMPwDiff;
-// Antenna B gain offset to antenna A, bit0~3
+		/* Antenna B gain offset to antenna A, bit0~3 */
 		priv->AntennaTxPwDiff[0] = (priv->EEPROMTxPowerDiff & 0xf);
-		// Antenna C gain offset to antenna A, bit4~7
+		/* Antenna C gain offset to antenna A, bit4~7 */
 		priv->AntennaTxPwDiff[1] = ((priv->EEPROMTxPowerDiff & 0xf0)>>4);
-		// CrystalCap, bit12~15
+		/* CrystalCap, bit12~15 */
 		priv->CrystalCap = priv->EEPROMCrystalCap;
-		// ThermalMeter, bit0~3 for RFIC1, bit4~7 for RFIC2
-		// 92U does not enable TX power tracking.
+		/* ThermalMeter, bit0~3 for RFIC1, bit4~7 for RFIC2 */
+		/* 92U does not enable TX power tracking. */
 		priv->ThermalMeter[0] = priv->EEPROMThermalMeter;
-	}//end if VersionID == VERSION_819xU_A
+	}	/* end if VersionID == VERSION_819xU_A */
 
-//added by vivi, for dlink led, 20080416
+	/* added by vivi, for dlink led, 20080416 */
 	switch(priv->eeprom_CustomerID)
 	{
 		case EEPROM_CID_RUNTOP:
@@ -3213,10 +3208,11 @@ static void rtl8192_read_eeprom_info(struct net_device* dev)
 		RT_TRACE(COMP_EPROM, "\n2T4R config\n");
 	}
 
-	// 2008/01/16 MH We can only know RF type in the function. So we have to init
-	// DIG RATR table again.
+	/* 2008/01/16 MH We can only know RF type in the function.
+	 * So we have to init DIG RATR table again.
+	 */
 	init_rate_adaptive(dev);
-	//we need init DIG RATR table here again.
+	/* we need init DIG RATR table here again. */
 
 	RT_TRACE(COMP_EPROM, "<===========%s()\n", __func__);
 	return;
@@ -3235,14 +3231,14 @@ short rtl8192_get_channel_map(struct net_device * dev)
 	rtl819x_set_channel_map(priv->ChannelPlan, priv);
 #else
 	int ch,i;
-	//Set Default Channel Plan
+	/* Set Default Channel Plan */
 	if(!channels){
 		DMESG("No channels, aborting");
 		return -1;
 	}
 	ch=channels;
-	priv->ChannelPlan= 0;//hikaru
-	 // set channels 1..14 allowed in given locale
+	priv->ChannelPlan= 0;		/* hikaru */
+	/* set channels 1..14 allowed in given locale */
 	for (i=1; i<=14; i++) {
 		(priv->ieee80211->channel_map)[i] = (u8)(ch & 0x01);
 		ch >>= 1;
@@ -3260,20 +3256,22 @@ short rtl8192_init(struct net_device *dev)
 	memset(priv->txqueue_to_outpipemap,0,9);
 #ifdef PIPE12
 	{
-		int i=0;
-		u8 queuetopipe[]={3,2,1,0,4,8,7,6,5};
-		memcpy(priv->txqueue_to_outpipemap,queuetopipe,9);
-/*		for(i=0;i<9;i++)
-			printk("%d ",priv->txqueue_to_outpipemap[i]);
-		printk("\n");*/
+		int i = 0;
+		u8 queuetopipe[]={3, 2, 1, 0, 4, 8, 7, 6, 5};
+		memcpy(priv->txqueue_to_outpipemap,queuetopipe, 9);
+		/* for(i = 0; i < 9; i++)
+		 *	printk("%d ", priv->txqueue_to_outpipemap[i]);
+		 *printk("\n");
+		 */
 	}
 #else
 	{
-		u8 queuetopipe[]={3,2,1,0,4,4,0,4,4};
-		memcpy(priv->txqueue_to_outpipemap,queuetopipe,9);
-/*		for(i=0;i<9;i++)
-			printk("%d ",priv->txqueue_to_outpipemap[i]);
-		printk("\n");*/
+		u8 queuetopipe[]={3, 2, 1, 0, 4, 4, 0, 4, 4};
+		memcpy(priv->txqueue_to_outpipemap,queuetopipe, 9);
+		/* for(i = 0; i < 9; i++)
+		 *	printk("%d ", priv->txqueue_to_outpipemap[i]);
+		 *printk("\n");
+		 */
 	}
 #endif
 	rtl8192_init_priv_variable(dev);
@@ -3291,7 +3289,7 @@ short rtl8192_init(struct net_device *dev)
 		return -ENOMEM;
 	}
 
-	//rtl8192_adapter_start(dev);
+	/* rtl8192_adapter_start(dev); */
 #ifdef DEBUG_EPROM
 	dump_eprom(dev);
 #endif
@@ -3312,8 +3310,7 @@ void rtl8192_hwconfig(struct net_device* dev)
 	u8 regBwOpMode = 0, regTmp = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-// Set RRSR, RATR, and BW_OPMODE registers
-	//
+/* Set RRSR, RATR, and BW_OPMODE registers */
 	switch(priv->ieee80211->mode)
 	{
 	case WIRELESS_MODE_B:
@@ -3348,8 +3345,8 @@ void rtl8192_hwconfig(struct net_device* dev)
 		}
 		break;
 	case WIRELESS_MODE_N_24G:
-		// It support CCK rate by default.
-		// CCK rate will be filtered out only when associated AP does not support it.
+		/* It support CCK rate by default. */
+		/* CCK rate will be filtered out only when associated AP does not support it. */
 		regBwOpMode = BW_OPMODE_20MHZ;
 			regRATR = RATE_ALL_CCK | RATE_ALL_OFDM_AG | RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
 			regRRSR = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
@@ -3376,25 +3373,17 @@ void rtl8192_hwconfig(struct net_device* dev)
 	regRRSR = ((regTmp) << 24) | (regRRSR & 0x00ffffff);
 	write_nic_dword(dev, RRSR, regRRSR);
 
-	//
-	// Set Retry Limit here
-	//
+	/* Set Retry Limit here */
 	write_nic_word(dev, RETRY_LIMIT,
 			priv->ShortRetryLimit << RETRY_LIMIT_SHORT_SHIFT | \
 			priv->LongRetryLimit << RETRY_LIMIT_LONG_SHIFT);
-	// Set Contention Window here
-
-	// Set Tx AGC
-
-	// Set Tx Antenna including Feedback control
-
-	// Set Auto Rate fallback control
-
-
+	/* Set Contention Window here */
+	/* Set Tx AGC */
+	/* Set Tx Antenna including Feedback control */
+	/* Set Auto Rate fallback control */
 }
 
-
-//InitializeAdapter and PhyCfg
+/*InitializeAdapter and PhyCfg */
 bool rtl8192_adapter_start(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
@@ -3402,7 +3391,7 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	bool init_status = true;
 	RT_TRACE(COMP_INIT, "====>%s()\n", __func__);
 	priv->Rf_Mode = RF_OP_By_SW_3wire;
-	//for ASIC power on sequence
+	/* for ASIC power on sequence */
 	write_nic_byte_E(dev, 0x5f, 0x80);
 	mdelay(50);
 	write_nic_byte_E(dev, 0x5f, 0xf0);
@@ -3410,26 +3399,26 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	write_nic_byte_E(dev, 0x5e, 0x80);
 	write_nic_byte(dev, 0x17, 0x37);
 	mdelay(10);
-//#ifdef TO_DO_LIST
+/* #ifdef TO_DO_LIST */
 	priv->pFirmware->firmware_status = FW_STATUS_0_INIT;
-	//config CPUReset Register
-	//Firmware Reset or not?
+	/* config CPUReset Register */
+	/* Firmware Reset or not? */
 	dwRegRead = read_nic_dword(dev, CPU_GEN);
 	if (priv->pFirmware->firmware_status == FW_STATUS_0_INIT)
-		dwRegRead |= CPU_GEN_SYSTEM_RESET; //do nothing here?
+		dwRegRead |= CPU_GEN_SYSTEM_RESET;	/* do nothing here? */
 	else if (priv->pFirmware->firmware_status == FW_STATUS_5_READY)
 		dwRegRead |= CPU_GEN_FIRMWARE_RESET;
 	else
 		RT_TRACE(COMP_ERR, "ERROR in %s(): undefined firmware state(%d)\n", __func__,   priv->pFirmware->firmware_status);
 
 	write_nic_dword(dev, CPU_GEN, dwRegRead);
-	//mdelay(30);
-	//config BB.
+	/* mdelay(30); */
+	/* config BB. */
 	rtl8192_BBConfig(dev);
 
-	//Loopback mode or not
+	/* Loopback mode or not */
 	priv->LoopbackMode = RTL819xU_NO_LOOPBACK;
-//	priv->LoopbackMode = RTL819xU_MAC_LOOPBACK;
+	/* priv->LoopbackMode = RTL819xU_MAC_LOOPBACK; */
 
 	dwRegRead = read_nic_dword(dev, CPU_GEN);
 	if (priv->LoopbackMode == RTL819xU_NO_LOOPBACK)
@@ -3441,26 +3430,28 @@ bool rtl8192_adapter_start(struct net_device *dev)
 
 	write_nic_dword(dev, CPU_GEN, dwRegRead);
 
-	//after reset cpu, we need wait for a seconds to write in register.
+	/* after reset cpu, we need wait for a seconds to write in register. */
 	udelay(500);
 
-	//xiong add for new bitfile:usb suspend reset pin set to 1. //do we need?
+	/* xiong add for new bitfile:usb suspend reset pin set to 1.
+	 * do we need?
+	 */
 	write_nic_byte_E(dev, 0x5f, (read_nic_byte_E(dev, 0x5f)|0x20));
 
-	//Set Hardware
+	/* Set Hardware */
 	rtl8192_hwconfig(dev);
 
-	//turn on Tx/Rx
+	/* turn on Tx/Rx */
 	write_nic_byte(dev, CMDR, CR_RE|CR_TE);
 
-	//set IDR0 here
+	/* set IDR0 here */
 	write_nic_dword(dev, MAC0, ((u32*)dev->dev_addr)[0]);
 	write_nic_word(dev, MAC4, ((u16*)(dev->dev_addr + 4))[0]);
 
-	//set RCR
+	/* set RCR */
 	write_nic_dword(dev, RCR, priv->ReceiveConfig);
 
-	//Initialize Number of Reserved Pages in Firmware Queue
+	/* Initialize Number of Reserved Pages in Firmware Queue */
 	write_nic_dword(dev, RQPN1,  NUM_OF_PAGE_IN_FW_QUEUE_BK << RSVD_FW_QUEUE_PAGE_BK_SHIFT |\
 						NUM_OF_PAGE_IN_FW_QUEUE_BE << RSVD_FW_QUEUE_PAGE_BE_SHIFT | \
 						NUM_OF_PAGE_IN_FW_QUEUE_VI << RSVD_FW_QUEUE_PAGE_VI_SHIFT | \
@@ -3469,15 +3460,22 @@ bool rtl8192_adapter_start(struct net_device *dev)
 						NUM_OF_PAGE_IN_FW_QUEUE_CMD << RSVD_FW_QUEUE_PAGE_CMD_SHIFT);
 	write_nic_dword(dev, RQPN3, APPLIED_RESERVED_QUEUE_IN_FW| \
 						NUM_OF_PAGE_IN_FW_QUEUE_BCN<<RSVD_FW_QUEUE_PAGE_BCN_SHIFT
-//						| NUM_OF_PAGE_IN_FW_QUEUE_PUB<<RSVD_FW_QUEUE_PAGE_PUB_SHIFT
+						/* | NUM_OF_PAGE_IN_FW_QUEUE_
+						 *PUB<<RSVD_FW_QUEUE_PAGE_
+						 *PUB_SHIFT
+						 */
 						);
 	write_nic_dword(dev, RATR0+4*7, (RATE_ALL_OFDM_AG | RATE_ALL_CCK));
 
-	//Set AckTimeout
-	// TODO: (it value is only for FPGA version). need to be changed!!2006.12.18, by Emily
+	/* Set AckTimeout */
+	/* TODO: (it value is only for FPGA version).
+	 * need to be changed!!2006.12.18, by Emily
+	 */
 	write_nic_byte(dev, ACK_TIMEOUT, 0x30);
 
-//	RT_TRACE(COMP_INIT, "%s():priv->ResetProgress is %d\n", __func__,priv->ResetProgress);
+	/* RT_TRACE(COMP_INIT, "%s():priv->ResetProgress is %d\n", __func__,
+	 *priv->ResetProgress);
+	 */
 	if(priv->ResetProgress == RESET_TYPE_NORESET)
 	rtl8192_SetWirelessMode(dev, priv->ieee80211->mode);
 	if(priv->ResetProgress == RESET_TYPE_NORESET){
@@ -3491,7 +3489,7 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	}
 	}
 
-	//Beacon related
+	/* Beacon related */
 	write_nic_word(dev, ATIMWND, 2);
 	write_nic_word(dev, BCN_INTERVAL, 100);
 
@@ -3502,7 +3500,7 @@ bool rtl8192_adapter_start(struct net_device *dev)
 		write_nic_dword(dev, WDCAPARA_ADD[i], DEFAULT_EDCA);
 	}
 #ifdef USB_RX_AGGREGATION_SUPPORT
-	//3 For usb rx firmware aggregation control
+	/* 3 For usb rx firmware aggregation control */
 	if(priv->ResetProgress == RESET_TYPE_NORESET)
 	{
 		u32 ulValue;
@@ -3527,7 +3525,7 @@ bool rtl8192_adapter_start(struct net_device *dev)
 		rtl8192_phy_setTxPower(dev, priv->chan);
 	}
 
-	//Firmware download
+	/* Firmware download */
 	init_status = init_firmware(dev);
 	if(!init_status)
 	{
@@ -3535,20 +3533,22 @@ bool rtl8192_adapter_start(struct net_device *dev)
 		return init_status;
 	}
 	RT_TRACE(COMP_INIT, "%s():after firmware download\n", __func__);
-	//
+
 #ifdef TO_DO_LIST
 if(Adapter->ResetProgress == RESET_TYPE_NORESET)
 	{
-		if(pMgntInfo->RegRfOff == TRUE)
-		{ // User disable RF via registry.
+		if(pMgntInfo->RegRfOff == TRUE) {
+			/* User disable RF via registry. */
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RegRfOff ----------\n"));
 			MgntActSet_RF_State(Adapter, eRfOff, RF_CHANGE_BY_SW);
-			// Those action will be discard in MgntActSet_RF_State because off the same state
+			/* Those action will be discard in MgntActSet_RF_State
+			 * because off the same state
+			 */
 			for(eRFPath = 0; eRFPath <pHalData->NumTotalRFPath; eRFPath++)
 				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
 		}
-		else if(pMgntInfo->RfOffReason > RF_CHANGE_BY_PS)
-		{ // H/W or S/W RF OFF before sleep.
+		else if(pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) {
+			/* H/W or S/W RF OFF before sleep. */
 			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RfOffReason(%d) ----------\n", pMgntInfo->RfOffReason));
 			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
 		}
@@ -3564,13 +3564,15 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
 		if(pHalData->eRFPowerState == eRfOff)
 		{
 			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
-			// Those action will be discard in MgntActSet_RF_State because off the same state
+			/* Those action will be discard in MgntActSet_RF_State
+			 * because off the same state
+			 */
 			for(eRFPath = 0; eRFPath <pHalData->NumTotalRFPath; eRFPath++)
 				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
 		}
 	}
 #endif
-	//config RF.
+	/* config RF. */
 	if(priv->ResetProgress == RESET_TYPE_NORESET){
 	rtl8192_phy_RFConfig(dev);
 	RT_TRACE(COMP_INIT, "%s():after phy RF config\n", __func__);
@@ -3578,20 +3580,20 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
 
 
 	if(priv->ieee80211->FwRWRF)
-		// We can force firmware to do RF-R/W
+		/* We can force firmware to do RF-R/W */
 		priv->Rf_Mode = RF_OP_By_FW;
 	else
 		priv->Rf_Mode = RF_OP_By_SW_3wire;
 
 
 	rtl8192_phy_updateInitGain(dev);
-	/*--set CCK and OFDM Block "ON"--*/
+	/* --set CCK and OFDM Block "ON"-- */
 	rtl8192_setBBreg(dev, rFPGA0_RFMOD, bCCKEn, 0x1);
 	rtl8192_setBBreg(dev, rFPGA0_RFMOD, bOFDMEn, 0x1);
 
 	if(priv->ResetProgress == RESET_TYPE_NORESET)
 	{
-		//if D or C cut
+		/* if D or C cut */
 		u8 tmpvalue = read_nic_byte(dev, 0x301);
 		if(tmpvalue ==0x03)
 		{
@@ -3609,7 +3611,9 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
 		{
 			u32 i, TempCCk;
 			u32 tmpRegA= rtl8192_QueryBBReg(dev,rOFDM0_XATxIQImbalance,bMaskDWord);
-		//	u32 tmpRegC= rtl8192_QueryBBReg(dev,rOFDM0_XCTxIQImbalance,bMaskDWord);
+			/* u32 tmpRegC= rtl8192_QueryBBReg(dev,
+			 * rOFDM0_XCTxIQImbalance,bMaskDWord);
+			 */
 			for(i = 0; i<TxBBGainTableLength; i++)
 			{
 				if(tmpRegA == priv->txbbgain_table[i].txbbgain_value)
@@ -3636,7 +3640,8 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
 			priv->cck_present_attentuation_difference= 0;
 			priv->cck_present_attentuation = priv->cck_present_attentuation_20Mdefault;
 
-	//		pMgntInfo->bTXPowerTracking = FALSE;//TEMPLY DISABLE
+			/* pMgntInfo->bTXPowerTracking = FALSE; */
+			/* TEMPLY DISABLE */
 		}
 	}
 	write_nic_byte(dev, 0x87, 0x0);
@@ -3650,8 +3655,9 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
  * be used to stop beacon transmission
  */
 /***************************************************************************
-    -------------------------------NET STUFF---------------------------
-***************************************************************************/
+ *    -------------------------------NET STUFF---------------------------
+ ***************************************************************************
+ */
 
 static struct net_device_stats *rtl8192_stats(struct net_device *dev)
 {
@@ -3686,18 +3692,16 @@ TxCheckStuck(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8			QueueID;
-//	PRT_TCB			pTcb;
-//	u8			ResetThreshold;
+	/* PRT_TCB			pTcb; */
+	/* u8			ResetThreshold; */
 	bool			bCheckFwTxCnt = false;
-	//unsigned long flags;
+	/* unsigned long flags; */
 
-	//
-	// Decide Stuch threshold according to current power save mode
-	//
+	/* Decide Stuch threshold according to current power save mode */
 
-//     RT_TRACE(COMP_RESET, " ==> TxCheckStuck()\n");
-//	     PlatformAcquireSpinLock(Adapter, RT_TX_SPINLOCK);
-//	     spin_lock_irqsave(&priv->ieee80211->lock,flags);
+	/* RT_TRACE(COMP_RESET, " ==> TxCheckStuck()\n"); */
+	/* PlatformAcquireSpinLock(Adapter, RT_TX_SPINLOCK); */
+	/* spin_lock_irqsave(&priv->ieee80211->lock,flags); */
 	     for (QueueID = 0; QueueID<=BEACON_QUEUE;QueueID ++)
 	     {
 	     		if(QueueID == TXCMD_QUEUE)
@@ -3711,9 +3715,9 @@ TxCheckStuck(struct net_device *dev)
 
 	             bCheckFwTxCnt = true;
 	     }
-//	     PlatformReleaseSpinLock(Adapter, RT_TX_SPINLOCK);
-//	spin_unlock_irqrestore(&priv->ieee80211->lock,flags);
-//	RT_TRACE(COMP_RESET,"bCheckFwTxCnt is %d\n",bCheckFwTxCnt);
+	/* PlatformReleaseSpinLock(Adapter, RT_TX_SPINLOCK); */
+	/* spin_unlock_irqrestore(&priv->ieee80211->lock,flags); */
+	/* RT_TRACE(COMP_RESET,"bCheckFwTxCnt is %d\n",bCheckFwTxCnt); */
 	if(bCheckFwTxCnt)
 	{
 		if(HalTxCheckStuck819xUsb(dev))
@@ -3733,12 +3737,13 @@ HalRxCheckStuck819xUsb(struct net_device *dev)
 	bool bStuck = FALSE;
 	static u8	rx_chk_cnt = 0;
 	RT_TRACE(COMP_RESET,"%s(): RegRxCounter is %d,RxCounter is %d\n",__func__,RegRxCounter,priv->RxCounter);
-	// If rssi is small, we should check rx for long time because of bad rx.
-	// or maybe it will continuous silent reset every 2 seconds.
+	/* If rssi is small, we should check rx for long time because of bad rx.
+	 * or maybe it will continuous silent reset every 2 seconds.
+	 */
 	rx_chk_cnt++;
 	if(priv->undecorated_smoothed_pwdb >= (RateAdaptiveTH_High+5))
 	{
-		rx_chk_cnt = 0;	//high rssi, check rx stuck right now.
+		rx_chk_cnt = 0;	/* high rssi, check rx stuck right now. */
 	}
 	else if(priv->undecorated_smoothed_pwdb < (RateAdaptiveTH_High+5) &&
 		((priv->CurrentChannelBW!=HT_CHANNEL_WIDTH_20&&priv->undecorated_smoothed_pwdb>=RateAdaptiveTH_Low_40M) ||
@@ -3759,26 +3764,35 @@ HalRxCheckStuck819xUsb(struct net_device *dev)
 	{
 		if(rx_chk_cnt < 4)
 		{
-			//DbgPrint("RSSI < %d && RSSI >= %d, no check this time \n", RateAdaptiveTH_Low, VeryLowRSSI);
+			/* DbgPrint("RSSI < %d && RSSI >= %d,"
+			 *	" no check this time \n", RateAdaptiveTH_Low,
+			 *					 VeryLowRSSI);
+			 */
 			return bStuck;
 		}
 		else
 		{
 			rx_chk_cnt = 0;
-			//DbgPrint("RSSI < %d && RSSI >= %d, check this time \n", RateAdaptiveTH_Low, VeryLowRSSI);
+			/* DbgPrint("RSSI < %d && RSSI >= %d, check this time"
+			 *		"\n", RateAdaptiveTH_Low, VeryLowRSSI);
+			 */
 		}
 	}
 	else
 	{
 		if(rx_chk_cnt < 8)
 		{
-			//DbgPrint("RSSI <= %d, no check this time \n", VeryLowRSSI);
+			/* DbgPrint("RSSI <= %d, no check this time \n",
+			 *					 VeryLowRSSI);
+			 */
 			return bStuck;
 		}
 		else
 		{
 			rx_chk_cnt = 0;
-			//DbgPrint("RSSI <= %d, check this time \n", VeryLowRSSI);
+			/* DbgPrint("RSSI <= %d, check this time \n",
+			 *					 VeryLowRSSI);
+			 */
 		}
 	}
 
@@ -3794,17 +3808,17 @@ RESET_TYPE
 RxCheckStuck(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	//int                     i;
+	/* int                     i; */
 	bool        bRxCheck = FALSE;
 
-//       RT_TRACE(COMP_RESET," ==> RxCheckStuck()\n");
-	//PlatformAcquireSpinLock(Adapter, RT_RX_SPINLOCK);
+	/* RT_TRACE(COMP_RESET," ==> RxCheckStuck()\n"); */
+	/* PlatformAcquireSpinLock(Adapter, RT_RX_SPINLOCK); */
 
 	 if(priv->IrpPendingCount > 1)
 		bRxCheck = TRUE;
-       //PlatformReleaseSpinLock(Adapter, RT_RX_SPINLOCK);
+	/* PlatformReleaseSpinLock(Adapter, RT_RX_SPINLOCK); */
 
-//       RT_TRACE(COMP_RESET,"bRxCheck is %d \n",bRxCheck);
+	/* RT_TRACE(COMP_RESET,"bRxCheck is %d \n",bRxCheck); */
 	if(bRxCheck)
 	{
 		if(HalRxCheckStuck819xUsb(dev))
@@ -3816,19 +3830,17 @@ RxCheckStuck(struct net_device *dev)
 	return RESET_TYPE_NORESET;
 }
 
-
-/**
-*	This function is called by Checkforhang to check whether we should ask OS to reset driver
-*
-*	\param pAdapter	The adapter context for this miniport
-*
-*	Note:NIC with USB interface sholud not call this function because we cannot scan descriptor
-*	to judge whether there is tx stuck.
-*	Note: This function may be required to be rewrite for Vista OS.
-*	<<<Assumption: Tx spinlock has been acquired >>>
-*
-*	8185 and 8185b does not implement this function. This is added by Emily at 2006.11.24
-*/
+/*	This function is called by Checkforhang to check whether we should ask OS to reset driver
+ *
+ *	\param pAdapter	The adapter context for this miniport
+ *
+ *	Note:NIC with USB interface sholud not call this function because we cannot scan descriptor
+ *	to judge whether there is tx stuck.
+ *	Note: This function may be required to be rewrite for Vista OS.
+ *	<<<Assumption: Tx spinlock has been acquired >>>
+ *
+ *	8185 and 8185b does not implement this function. This is added by Emily at 2006.11.24
+ */
 RESET_TYPE
 rtl819x_ifcheck_resetornot(struct net_device *dev)
 {
@@ -3841,17 +3853,22 @@ rtl819x_ifcheck_resetornot(struct net_device *dev)
 
 	TxResetType = TxCheckStuck(dev);
 	if( rfState != eRfOff ||
-		/*ADAPTER_TEST_STATUS_FLAG(Adapter, ADAPTER_STATUS_FW_DOWNLOAD_FAILURE)) &&*/
+		/* ADAPTER_TEST_STATUS_FLAG(Adapter, ADAPTER_STATUS_FW_DOWNLOAD_FAILURE)) && */
 		(priv->ieee80211->iw_mode != IW_MODE_ADHOC))
 	{
-		// If driver is in the status of firmware download failure , driver skips RF initialization and RF is
-		// in turned off state. Driver should check whether Rx stuck and do silent reset. And
-		// if driver is in firmware download failure status, driver should initialize RF in the following
-		// silent reset procedure Emily, 2008.01.21
-
-		// Driver should not check RX stuck in IBSS mode because it is required to
-		// set Check BSSID in order to send beacon, however, if check BSSID is
-		// set, STA cannot hear any packet a all. Emily, 2008.04.12
+		/* If driver is in the status of firmware download failure,
+		 * driver skips RF initialization and RF is in turned off state
+		 *. Driver should check whether Rx stuck and do silent reset.
+		 * And if driver is in firmware download failure status, driver
+		 * should initialize RF in the following silent reset procedure
+		 * Emily, 2008.01.21
+		 *
+		 * Driver should not check RX stuck in IBSS mode because it is
+		 * required to set Check BSSID in order to send beacon,
+		 * however, if check BSSID is set, STA cannot hear any packet
+		 * at all.
+		 * Emily, 2008.04.12
+		 */
 		RxResetType = RxCheckStuck(dev);
 	}
 	if(TxResetType==RESET_TYPE_NORMAL || RxResetType==RESET_TYPE_NORMAL)
@@ -4005,24 +4022,24 @@ CamRestoreAllEntry(	struct net_device *dev)
 						NULL);
 	}
 }
-//////////////////////////////////////////////////////////////
-// This function is used to fix Tx/Rx stop bug temporarily.
-// This function will do "system reset" to NIC when Tx or Rx is stuck.
-// The method checking Tx/Rx stuck of this function is supported by FW,
-// which reports Tx and Rx counter to register 0x128 and 0x130.
-//////////////////////////////////////////////////////////////
+
+/* This function is used to fix Tx/Rx stop bug temporarily.
+ * This function will do "system reset" to NIC when Tx or Rx is stuck.
+ * The method checking Tx/Rx stuck of this function is supported by FW,
+ * which reports Tx and Rx counter to register 0x128 and 0x130.
+ */
 void
 rtl819x_ifsilentreset(struct net_device *dev)
 {
-	//OCTET_STRING asocpdu;
+	/* OCTET_STRING asocpdu; */
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8	reset_times = 0;
 	int reset_status = 0;
 	struct ieee80211_device *ieee = priv->ieee80211;
 
 
-	// 2007.07.20. If we need to check CCK stop, please uncomment this line.
-	//bStuck = Adapter->HalFunc.CheckHWStopHandler(Adapter);
+	/* 2007.07.20. If we need to check CCK stop, uncomment this line. */
+	/* bStuck = Adapter->HalFunc.CheckHWStopHandler(Adapter); */
 
 	if(priv->ResetProgress==RESET_TYPE_NORESET)
 	{
@@ -4030,9 +4047,9 @@ RESET_START:
 
 		RT_TRACE(COMP_RESET,"=========>Reset progress!! \n");
 
-		// Set the variable for reset.
+		/* Set the variable for reset. */
 		priv->ResetProgress = RESET_TYPE_SILENT;
-//		rtl8192_close(dev);
+		/* rtl8192_close(dev); */
 		down(&priv->wx_sem);
 		if(priv->up == 0)
 		{
@@ -4042,8 +4059,9 @@ RESET_START:
 		}
 		priv->up = 0;
 		RT_TRACE(COMP_RESET,"%s():======>start to down the driver\n",__func__);
-//		if(!netif_queue_stopped(dev))
-//			netif_stop_queue(dev);
+		/* if(!netif_queue_stopped(dev))
+		 *	netif_stop_queue(dev);
+		 */
 
 		rtl8192_rtx_disable(dev);
 		rtl8192_cancel_deferred_work(priv);
@@ -4067,7 +4085,7 @@ RESET_START:
 			ieee80211_softmac_stop_protocol(priv->ieee80211);			}
 		up(&priv->wx_sem);
 		RT_TRACE(COMP_RESET,"%s():<==========down process is finished\n",__func__);
-	//rtl8192_irq_disable(dev);
+		/* rtl8192_irq_disable(dev); */
 		RT_TRACE(COMP_RESET,"%s():===========>start to up the driver\n",__func__);
 		reset_status = _rtl8192_up(dev);
 
@@ -4098,7 +4116,7 @@ RESET_START:
 			ieee->set_chan(ieee->dev, ieee->current_network.channel);
 			ieee->link_change(ieee->dev);
 
-		//	notify_wx_assoc_event(ieee);
+			/* notify_wx_assoc_event(ieee); */
 
 			ieee80211_start_send_beacons(ieee);
 
@@ -4115,7 +4133,7 @@ RESET_START:
 		priv->bForcedSilentReset =false;
 		priv->bResetInProgress = false;
 
-		// For test --> force write UFWP.
+		/* For test --> force write UFWP. */
 		write_nic_byte(dev, UFWP, 1);
 		RT_TRACE(COMP_RESET, "Reset finished!! ====>[%d]\n", priv->reset_count);
 	}
@@ -4131,17 +4149,16 @@ void CAM_read_entry(
 	 u8 entry_i=0;
 	 u32 ulStatus;
 	s32 i=100;
-//	printk("=======>start read CAM\n");
+	/* printk("=======>start read CAM\n"); */
  	for(entry_i=0;entry_i<CAM_CONTENT_COUNT;entry_i++)
  	{
-   	// polling bit, and No Write enable, and address
-		target_command= entry_i+CAM_CONTENT_COUNT*iIndex;
+   	/* polling bit, and No Write enable, and address */
+		target_command= entry_i + CAM_CONTENT_COUNT * iIndex;
 		target_command= target_command | BIT31;
 
-	//Check polling bit is clear
-//	mdelay(1);
-		while((i--)>=0)
-		{
+	/* Check polling bit is clear */
+	/* mdelay(1); */
+		while ((i--) >=0 ) {
 			ulStatus = read_nic_dword(dev, RWCAM);
 			if(ulStatus & BIT31){
 				continue;
@@ -4152,10 +4169,10 @@ void CAM_read_entry(
 		}
 		write_nic_dword(dev, RWCAM, target_command);
 		RT_TRACE(COMP_SEC,"CAM_read_entry(): WRITE A0: %x \n",target_command);
-	 //	printk("CAM_read_entry(): WRITE A0: %lx \n",target_command);
+		/* printk("CAM_read_entry(): WRITE A0: %lx \n",target_command); */
 		target_content = read_nic_dword(dev, RCAMO);
 		RT_TRACE(COMP_SEC, "CAM_read_entry(): WRITE A8: %x \n",target_content);
-	 //	printk("CAM_read_entry(): WRITE A8: %lx \n",target_content);
+	 	/* printk("CAM_read_entry(): WRITE A8: %lx \n",target_content); */
 	}
 	printk("\n");
 }
@@ -4196,9 +4213,8 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 		return;
 	hal_dm_watchdog(dev);
 
-	{//to get busy traffic condition
-		if(ieee->state == IEEE80211_LINKED)
-		{
+	/* to get busy traffic condition */
+	{ if(ieee->state == IEEE80211_LINKED) {
 			if(	ieee->LinkDetectInfo.NumRxOkInPeriod> 666 ||
 				ieee->LinkDetectInfo.NumTxOkInPeriod> 666 ) {
 				bBusyTraffic = true;
@@ -4208,7 +4224,7 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 			ieee->LinkDetectInfo.bBusyTraffic = bBusyTraffic;
 		}
 	}
-	//added by amy for AP roaming
+	/* added by amy for AP roaming */
 	{
 		if(priv->ieee80211->state == IEEE80211_LINKED && priv->ieee80211->iw_mode == IW_MODE_INFRA)
 		{
@@ -4223,7 +4239,7 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 					RT_TRACE(COMP_ERR,"========>%s()\n",__func__);
 				#endif
 				printk("===>%s(): AP is power off,connect another one\n",__func__);
-			//	Dot11d_Reset(dev);
+				/* Dot11d_Reset(dev); */
 				priv->ieee80211->state = IEEE80211_ASSOCIATING;
 				notify_wx_assoc_event(priv->ieee80211);
 				RemovePeerTS(priv->ieee80211,priv->ieee80211->current_network.bssid);
@@ -4235,18 +4251,24 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 		priv->ieee80211->LinkDetectInfo.NumRecvBcnInPeriod=0;
 		priv->ieee80211->LinkDetectInfo.NumRecvDataInPeriod=0;
 	}
-//	CAM_read_entry(dev,4);
-	//check if reset the driver
+	/* CAM_read_entry(dev,4); */
+	/* check if reset the driver */
 	if(check_reset_cnt++ >= 3)
 	{
     		ResetType = rtl819x_ifcheck_resetornot(dev);
 		check_reset_cnt = 3;
-		//DbgPrint("Start to check silent reset\n");
+		/* DbgPrint("Start to check silent reset\n"); */
 	}
-	//	RT_TRACE(COMP_RESET,"%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n",__func__,priv->force_reset,priv->ResetProgress,priv->bForcedSilentReset,priv->bDisableNormalResetCheck,ResetType);
+	/* RT_TRACE(COMP_RESET,"%s():priv->force_reset is %d,"
+	 * "priv->ResetProgress is %d, priv->bForcedSilentReset is %d,"
+	 * "priv->bDisableNormalResetCheck is %d,ResetType is %d\n", __func__,
+	 * priv->force_reset, priv->ResetProgress, priv->bForcedSilentReset,
+	 * priv->bDisableNormalResetCheck,ResetType);
+	 */
 	if( (priv->force_reset) || (priv->ResetProgress==RESET_TYPE_NORESET &&
 		(priv->bForcedSilentReset ||
-		(!priv->bDisableNormalResetCheck && ResetType==RESET_TYPE_SILENT)))) // This is control by OID set in Pomelo
+		(!priv->bDisableNormalResetCheck && ResetType==RESET_TYPE_SILENT))))
+		/*  This is control by OID set in Pomelo */
 	{
 		RT_TRACE(COMP_RESET,"%s():priv->force_reset is %d,priv->ResetProgress is %d, priv->bForcedSilentReset is %d,priv->bDisableNormalResetCheck is %d,ResetType is %d\n",__func__,priv->force_reset,priv->ResetProgress,priv->bForcedSilentReset,priv->bDisableNormalResetCheck,ResetType);
 		rtl819x_ifsilentreset(dev);
@@ -4261,14 +4283,14 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 void watch_dog_timer_callback(unsigned long data)
 {
 	struct r8192_priv *priv = ieee80211_priv((struct net_device *) data);
-	//printk("===============>watch_dog  timer\n");
+	/* printk("===============>watch_dog  timer\n"); */
 	queue_delayed_work(priv->priv_wq,&priv->watch_dog_wq, 0);
 	mod_timer(&priv->watch_dog_timer, jiffies + MSECS(IEEE80211_WATCH_DOG_TIME));
 }
 int _rtl8192_up(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	//int i;
+	/* int i; */
 	int init_status = 0;
 	priv->up=1;
 	priv->ieee80211->ieee_up=1;
@@ -4282,7 +4304,7 @@ int _rtl8192_up(struct net_device *dev)
 	}
 	RT_TRACE(COMP_INIT, "start adapter finished\n");
 	rtl8192_rx_enable(dev);
-//	rtl8192_tx_enable(dev);
+	/* rtl8192_tx_enable(dev); */
 	if(priv->ieee80211->state != IEEE80211_LINKED)
 	ieee80211_softmac_start_protocol(priv->ieee80211);
 	ieee80211_reset_queue(priv->ieee80211);
@@ -4343,14 +4365,14 @@ int rtl8192_down(struct net_device *dev)
 	priv->up=0;
 	priv->ieee80211->ieee_up = 0;
 	RT_TRACE(COMP_DOWN, "==========>%s()\n", __func__);
-/* FIXME */
+	/* FIXME */
 	if (!netif_queue_stopped(dev))
 		netif_stop_queue(dev);
 
 	rtl8192_rtx_disable(dev);
-	//rtl8192_irq_disable(dev);
+	/* rtl8192_irq_disable(dev); */
 
- /* Tx related queue release */
+	/* Tx related queue release */
 	for(i = 0; i < MAX_QUEUE_SIZE; i++) {
 		skb_queue_purge(&priv->ieee80211->skb_waitQ [i]);
 	}
@@ -4362,8 +4384,10 @@ int rtl8192_down(struct net_device *dev)
 		skb_queue_purge(&priv->ieee80211->skb_drv_aggQ [i]);
 	}
 
-	//as cancel_delayed_work will del work->timer, so if work is not definedas struct delayed_work, it will corrupt
-//	flush_scheduled_work();
+	/* as cancel_delayed_work will del work->timer, so if work is not
+	 * defined as struct delayed_work, it will corrupt
+	 */
+	/* flush_scheduled_work();	evvl */
 	rtl8192_cancel_deferred_work(priv);
 	deinit_hal_dm(dev);
 	del_timer_sync(&priv->watch_dog_timer);
@@ -4381,27 +4405,26 @@ void rtl8192_commit(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	int reset_status = 0;
-	//u8 reset_times = 0;
+	/* u8 reset_times = 0; */
 	if (priv->up == 0) return ;
 	priv->up = 0;
 
 	rtl8192_cancel_deferred_work(priv);
 	del_timer_sync(&priv->watch_dog_timer);
-	//cancel_delayed_work(&priv->SwChnlWorkItem);
+	/* cancel_delayed_work(&priv->SwChnlWorkItem); */
 
 	ieee80211_softmac_stop_protocol(priv->ieee80211);
 
-	//rtl8192_irq_disable(dev);
+	/* rtl8192_irq_disable(dev); */
 	rtl8192_rtx_disable(dev);
 	reset_status = _rtl8192_up(dev);
 
 }
 
-/*
-void rtl8192_restart(struct net_device *dev)
-{
-	struct r8192_priv *priv = ieee80211_priv(dev);
-*/
+/* void rtl8192_restart(struct net_device *dev)
+ * {
+ *	struct r8192_priv *priv = ieee80211_priv(dev);
+ */
 void rtl8192_restart(struct work_struct *work)
 {
 	struct r8192_priv *priv = container_of(work, struct r8192_priv, reset_wq);
@@ -4419,19 +4442,19 @@ static void r8192_set_multicast(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	short promisc;
 
-	//down(&priv->wx_sem);
+	/* down(&priv->wx_sem); */
 
 	/* FIXME FIXME */
 
 	promisc = (dev->flags & IFF_PROMISC) ? 1:0;
 
 	if (promisc != priv->promisc)
-	//	rtl8192_commit(dev);
+		/* rtl8192_commit(dev); */
 
 	priv->promisc = promisc;
 
-	//schedule_work(&priv->reset_wq);
-	//up(&priv->wx_sem);
+	/* schedule_work(&priv->reset_wq); */
+	/* up(&priv->wx_sem); */
 }
 
 
@@ -4460,7 +4483,8 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	u32 key[4];
 	u8 broadcast_addr[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
 	struct iw_point *p = &wrq->u.data;
-	struct ieee_param *ipw = NULL;//(struct ieee_param *)wrq->u.data.pointer;
+	struct ieee_param *ipw = NULL;
+	/* (struct ieee_param *)wrq->u.data.pointer; */
 
 	down(&priv->wx_sem);
 
@@ -4483,7 +4507,7 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	switch (cmd) {
 	    case RTL_IOCTL_WPA_SUPPLICANT:
-	//parse here for HW security
+	/* parse here for HW security */
 			if (ipw->cmd == IEEE_CMD_SET_ENCRYPTION)
 			{
 				if (ipw->u.crypt.set_tx)
@@ -4506,15 +4530,21 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 					{
 						memcpy((u8*)key, ipw->u.crypt.key, 16);
 						EnableHWSecurityConfig8192(dev);
-					//we fill both index entry and 4th entry for pairwise key as in IPW interface, adhoc will only get here, so we need index entry for its default key serching!
-					//added by WB.
+					/* we fill both index entry and 4th
+					 * entry for pairwise key as in IPW
+					 * interface, adhoc will only get here,
+					 * so we need index entry for its
+					 * default key serching!
+					 */
+					/* added by WB. */
 						setKey(dev, 4, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8*)ieee->ap_mac_addr, 0, key);
 						if (ieee->auth_mode != 2)
 						setKey(dev, ipw->u.crypt.idx, ipw->u.crypt.idx, ieee->pairwise_key_type, (u8*)ieee->ap_mac_addr, 0, key);
 					}
 				}
-				else //if (ipw->u.crypt.idx) //group key use idx > 0
-				{
+				else {
+					/* if (ipw->u.crypt.idx) */
+					/* group key use idx > 0 */
 					memcpy((u8*)key, ipw->u.crypt.key, 16);
 					if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
 						ieee->group_key_type= KEY_TYPE_CCMP;
@@ -4534,23 +4564,28 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 					{
 							setKey(	dev,
 								ipw->u.crypt.idx,
-								ipw->u.crypt.idx,		//KeyIndex
-						     		ieee->group_key_type,	//KeyType
-						            	broadcast_addr,	//MacAddr
-								0,		//DefaultKey
-							      	key);		//KeyContent
+								ipw->u.crypt.idx,
+								/* KeyIndex */
+						     		ieee->group_key_type,
+								/* KeyType */
+						            	broadcast_addr,
+								/* MacAddr */
+								0,
+								/* DefaultKey */
+							      	key);
+								/* KeyContent */
 					}
 				}
 			}
 #ifdef JOHN_HWSEC_DEBUG
-		//john's test 0711
+		/* john's test 0711 */
 		printk("@@ wrq->u pointer = ");
 		for(i=0;i<wrq->u.data.length;i++){
 			if(i%10==0) printk("\n");
 			printk( "%8x|", ((u32*)wrq->u.data.pointer)[i] );
 		}
 		printk("\n");
-#endif /*JOHN_HWSEC_DEBUG*/
+#endif /* JOHN_HWSEC_DEBUG */
 		ret = ieee80211_wpa_supplicant_ioctl(priv->ieee80211, &wrq->u.data);
 		break;
 
-- 
1.6.3.3

