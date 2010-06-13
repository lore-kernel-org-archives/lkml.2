Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0FMH0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 03:26:06 -0400
Received: from outbound-mail01.westnet.com.au ([203.10.1.242]:31406 "EHLO
	outbound-mail01.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146Ab0FMHZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 03:25:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ama+AMYUFEw6B0zXPGdsb2JhbACHbpE7BoVQDAEBAQE1LbBrjE6FGgSDSw
X-IronPort-AV: E=Sophos;i="4.53,410,1272816000"; 
   d="scan'208";a="84157943"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 1/4] staging: rtl8192u: fix checkpatch.pl issues to line 4000 Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 4000
Date: Sun, 13 Jun 2010 14:16:48 +0800
Message-Id: <1276409811-16682-2-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1276409811-16682-1-git-send-email-mike.kernel@gilksonline.com>
References: <1276409811-16682-1-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |  343 ++++++++++++++++----------------
 1 files changed, 173 insertions(+), 170 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 6f20518..21e3ac3 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3524,9 +3524,7 @@ void rtl8192_hwconfig(struct net_device *dev)
 		u32 ratr_value = 0;
 		ratr_value = regRATR;
 		if (priv->rf_type == RF_1T2R)
-		{
 			ratr_value &= ~(RATE_ALL_OFDM_2SS);
-		}
 		write_nic_dword(dev, RATR0, ratr_value);
 		write_nic_byte(dev, UFWP, 1);
 	}
@@ -3570,7 +3568,9 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	else if (priv->pFirmware->firmware_status == FW_STATUS_5_READY)
 		dwRegRead |= CPU_GEN_FIRMWARE_RESET;
 	else
-		RT_TRACE(COMP_ERR, "ERROR in %s(): undefined firmware state(%d)\n", __func__,   priv->pFirmware->firmware_status);
+		RT_TRACE(COMP_ERR, "ERROR in %s(): undefined firmware "
+			"state(%d)\n", __func__,
+			priv->pFirmware->firmware_status);
 
 	write_nic_dword(dev, CPU_GEN, dwRegRead);
 	/* mdelay(30); */
@@ -3583,11 +3583,13 @@ bool rtl8192_adapter_start(struct net_device *dev)
 
 	dwRegRead = read_nic_dword(dev, CPU_GEN);
 	if (priv->LoopbackMode == RTL819xU_NO_LOOPBACK)
-		dwRegRead = ((dwRegRead & CPU_GEN_NO_LOOPBACK_MSK) | CPU_GEN_NO_LOOPBACK_SET);
+		dwRegRead = ((dwRegRead & CPU_GEN_NO_LOOPBACK_MSK) |
+					CPU_GEN_NO_LOOPBACK_SET);
 	else if (priv->LoopbackMode == RTL819xU_MAC_LOOPBACK)
 		dwRegRead |= CPU_CCK_LOOPBACK;
 	else
-		RT_TRACE(COMP_ERR, "Serious error in %s(): wrong loopback mode setting(%d)\n", __func__,  priv->LoopbackMode);
+		RT_TRACE(COMP_ERR, "Serious error in %s(): wrong loopback"
+			" mode setting(%d)\n", __func__,  priv->LoopbackMode);
 
 	write_nic_dword(dev, CPU_GEN, dwRegRead);
 
@@ -3606,27 +3608,34 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	write_nic_byte(dev, CMDR, CR_RE|CR_TE);
 
 	/* set IDR0 here */
-	write_nic_dword(dev, MAC0, ((u32*)dev->dev_addr)[0]);
-	write_nic_word(dev, MAC4, ((u16*)(dev->dev_addr + 4))[0]);
+	write_nic_dword(dev, MAC0, ((u32 *)dev->dev_addr)[0]);
+	write_nic_word(dev, MAC4, ((u16 *)(dev->dev_addr + 4))[0]);
 
 	/* set RCR */
 	write_nic_dword(dev, RCR, priv->ReceiveConfig);
 
 	/* Initialize Number of Reserved Pages in Firmware Queue */
-	write_nic_dword(dev, RQPN1,  NUM_OF_PAGE_IN_FW_QUEUE_BK << RSVD_FW_QUEUE_PAGE_BK_SHIFT |\
-						NUM_OF_PAGE_IN_FW_QUEUE_BE << RSVD_FW_QUEUE_PAGE_BE_SHIFT | \
-						NUM_OF_PAGE_IN_FW_QUEUE_VI << RSVD_FW_QUEUE_PAGE_VI_SHIFT | \
-						NUM_OF_PAGE_IN_FW_QUEUE_VO <<RSVD_FW_QUEUE_PAGE_VO_SHIFT);
-	write_nic_dword(dev, RQPN2, NUM_OF_PAGE_IN_FW_QUEUE_MGNT << RSVD_FW_QUEUE_PAGE_MGNT_SHIFT |\
-						NUM_OF_PAGE_IN_FW_QUEUE_CMD << RSVD_FW_QUEUE_PAGE_CMD_SHIFT);
-	write_nic_dword(dev, RQPN3, APPLIED_RESERVED_QUEUE_IN_FW| \
-						NUM_OF_PAGE_IN_FW_QUEUE_BCN<<RSVD_FW_QUEUE_PAGE_BCN_SHIFT
+	write_nic_dword(dev, RQPN1,  NUM_OF_PAGE_IN_FW_QUEUE_BK <<
+					RSVD_FW_QUEUE_PAGE_BK_SHIFT |
+					NUM_OF_PAGE_IN_FW_QUEUE_BE <<
+						RSVD_FW_QUEUE_PAGE_BE_SHIFT |
+					NUM_OF_PAGE_IN_FW_QUEUE_VI <<
+						RSVD_FW_QUEUE_PAGE_VI_SHIFT |
+					NUM_OF_PAGE_IN_FW_QUEUE_VO <<
+						RSVD_FW_QUEUE_PAGE_VO_SHIFT);
+	write_nic_dword(dev, RQPN2, NUM_OF_PAGE_IN_FW_QUEUE_MGNT <<
+				RSVD_FW_QUEUE_PAGE_MGNT_SHIFT |
+				NUM_OF_PAGE_IN_FW_QUEUE_CMD <<
+				RSVD_FW_QUEUE_PAGE_CMD_SHIFT);
+	write_nic_dword(dev, RQPN3, APPLIED_RESERVED_QUEUE_IN_FW|
+						NUM_OF_PAGE_IN_FW_QUEUE_BCN <<
+						RSVD_FW_QUEUE_PAGE_BCN_SHIFT
 						/* | NUM_OF_PAGE_IN_FW_QUEUE_
 						 *PUB<<RSVD_FW_QUEUE_PAGE_
 						 *PUB_SHIFT
 						 */
 						);
-	write_nic_dword(dev, RATR0+4*7, (RATE_ALL_OFDM_AG | RATE_ALL_CCK));
+	write_nic_dword(dev, RATR0 + 4 * 7, (RATE_ALL_OFDM_AG | RATE_ALL_CCK));
 
 	/* Set AckTimeout */
 	/* TODO: (it value is only for FPGA version).
@@ -3637,17 +3646,17 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	/* RT_TRACE(COMP_INIT, "%s():priv->ResetProgress is %d\n", __func__,
 	 *priv->ResetProgress);
 	 */
-	if(priv->ResetProgress == RESET_TYPE_NORESET)
-	rtl8192_SetWirelessMode(dev, priv->ieee80211->mode);
-	if(priv->ResetProgress == RESET_TYPE_NORESET){
-	CamResetAllEntry(dev);
-	{
-		u8 SECR_value = 0x0;
-		SECR_value |= SCR_TxEncEnable;
-		SECR_value |= SCR_RxDecEnable;
-		SECR_value |= SCR_NoSKMC;
-		write_nic_byte(dev, SECR, SECR_value);
-	}
+	if (priv->ResetProgress == RESET_TYPE_NORESET)
+		rtl8192_SetWirelessMode(dev, priv->ieee80211->mode);
+	if (priv->ResetProgress == RESET_TYPE_NORESET) {
+		CamResetAllEntry(dev);
+		{
+			u8 SECR_value = 0x0;
+			SECR_value |= SCR_TxEncEnable;
+			SECR_value |= SCR_RxDecEnable;
+			SECR_value |= SCR_NoSKMC;
+			write_nic_byte(dev, SECR, SECR_value);
+		}
 	}
 
 	/* Beacon related */
@@ -3657,17 +3666,18 @@ bool rtl8192_adapter_start(struct net_device *dev)
 	{
 #define DEFAULT_EDCA 0x005e4332
 		int i;
-		for (i=0; i<QOS_QUEUE_NUM; i++)
-		write_nic_dword(dev, WDCAPARA_ADD[i], DEFAULT_EDCA);
+		for (i = 0; i < QOS_QUEUE_NUM; i++)
+			write_nic_dword(dev, WDCAPARA_ADD[i], DEFAULT_EDCA);
 	}
 #ifdef USB_RX_AGGREGATION_SUPPORT
 	/* 3 For usb rx firmware aggregation control */
-	if(priv->ResetProgress == RESET_TYPE_NORESET)
-	{
+	if (priv->ResetProgress == RESET_TYPE_NORESET) {
 		u32 ulValue;
 		PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;
-		ulValue = (pHTInfo->UsbRxFwAggrEn<<24) | (pHTInfo->UsbRxFwAggrPageNum<<16) |
-					(pHTInfo->UsbRxFwAggrPacketNum<<8) | (pHTInfo->UsbRxFwAggrTimeout);
+		ulValue = (pHTInfo->UsbRxFwAggrEn<<24) |
+				(pHTInfo->UsbRxFwAggrPageNum<<16) |
+				(pHTInfo->UsbRxFwAggrPacketNum<<8) |
+				pHTInfo->UsbRxFwAggrTimeout);
 		/*
 		 * If usb rx firmware aggregation is enabled,
 		 * when anyone of three threshold conditions above is reached,
@@ -3680,67 +3690,72 @@ bool rtl8192_adapter_start(struct net_device *dev)
 
 	rtl8192_phy_configmac(dev);
 
-	if (priv->card_8192_version == (u8) VERSION_819xU_A)
-	{
+	if (priv->card_8192_version == (u8) VERSION_819xU_A) {
 		rtl8192_phy_getTxPower(dev);
 		rtl8192_phy_setTxPower(dev, priv->chan);
 	}
 
 	/* Firmware download */
 	init_status = init_firmware(dev);
-	if(!init_status)
-	{
-		RT_TRACE(COMP_ERR,"ERR!!! %s(): Firmware download is failed\n", __func__);
+	if (!init_status) {
+		RT_TRACE(COMP_ERR, "ERR!!! %s(): Firmware download is failed\n",
+			__func__);
 		return init_status;
 	}
 	RT_TRACE(COMP_INIT, "%s():after firmware download\n", __func__);
 
 #ifdef TO_DO_LIST
-if(Adapter->ResetProgress == RESET_TYPE_NORESET)
-	{
-		if(pMgntInfo->RegRfOff == TRUE) {
-			/* User disable RF via registry. */
-			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RegRfOff ----------\n"));
-			MgntActSet_RF_State(Adapter, eRfOff, RF_CHANGE_BY_SW);
-			/* Those action will be discard in MgntActSet_RF_State
-			 * because off the same state
-			 */
-			for(eRFPath = 0; eRFPath <pHalData->NumTotalRFPath; eRFPath++)
-				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
-		}
-		else if(pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) {
+if (Adapter->ResetProgress == RESET_TYPE_NORESET) {
+	if (pMgntInfo->RegRfOff == TRUE) {
+		/* User disable RF via registry. */
+		RT_TRACE((COMP_INIT | COMP_RF), DBG_LOUD,
+			("InitializeAdapter819xUsb(): Turn off RF for RegRfOff"
+			" ----------\n"));
+		MgntActSet_RF_State(Adapter, eRfOff, RF_CHANGE_BY_SW);
+		/* Those action will be discard in MgntActSet_RF_State
+		 * because off the same state
+		 */
+		for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++)
+			PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath,
+					0x4, 0xC00, 0x0);
+		} else if (pMgntInfo->RfOffReason > RF_CHANGE_BY_PS) {
 			/* H/W or S/W RF OFF before sleep. */
-			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): Turn off RF for RfOffReason(%d) ----------\n", pMgntInfo->RfOffReason));
-			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
-		}
-		else
-		{
+			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD,
+				("InitializeAdapter819xUsb(): Turn off RF for"
+				" RfOffReason(%d) ----------\n",
+				pMgntInfo->RfOffReason));
+			MgntActSet_RF_State(Adapter, eRfOff,
+					pMgntInfo->RfOffReason);
+		} else {
 			pHalData->eRFPowerState = eRfOn;
 			pMgntInfo->RfOffReason = 0;
-			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD, ("InitializeAdapter819xUsb(): RF is on ----------\n"));
+			RT_TRACE((COMP_INIT|COMP_RF), DBG_LOUD,
+				("InitializeAdapter819xUsb(): RF is on"
+				" ----------\n"));
 		}
-	}
-	else
-	{
-		if(pHalData->eRFPowerState == eRfOff)
-		{
-			MgntActSet_RF_State(Adapter, eRfOff, pMgntInfo->RfOffReason);
+	} else {
+		if (pHalData->eRFPowerState == eRfOff) {
+			MgntActSet_RF_State(Adapter, eRfOff,
+						pMgntInfo->RfOffReason);
 			/* Those action will be discard in MgntActSet_RF_State
 			 * because off the same state
 			 */
-			for(eRFPath = 0; eRFPath <pHalData->NumTotalRFPath; eRFPath++)
-				PHY_SetRFReg(Adapter, (RF90_RADIO_PATH_E)eRFPath, 0x4, 0xC00, 0x0);
+			for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath;
+								eRFPath++)
+				PHY_SetRFReg(Adapter,
+					(RF90_RADIO_PATH_E)eRFPath,
+					0x4, 0xC00, 0x0);
 		}
 	}
 #endif
 	/* config RF. */
-	if(priv->ResetProgress == RESET_TYPE_NORESET){
-	rtl8192_phy_RFConfig(dev);
+	if (priv->ResetProgress == RESET_TYPE_NORESET) {
+		rtl8192_phy_RFConfig(dev);
 	RT_TRACE(COMP_INIT, "%s():after phy RF config\n", __func__);
 	}
 
 
-	if(priv->ieee80211->FwRWRF)
+	if (priv->ieee80211->FwRWRF)
 		/* We can force firmware to do RF-R/W */
 		priv->Rf_Mode = RF_OP_By_FW;
 	else
@@ -3752,54 +3767,49 @@ if(Adapter->ResetProgress == RESET_TYPE_NORESET)
 	rtl8192_setBBreg(dev, rFPGA0_RFMOD, bCCKEn, 0x1);
 	rtl8192_setBBreg(dev, rFPGA0_RFMOD, bOFDMEn, 0x1);
 
-	if(priv->ResetProgress == RESET_TYPE_NORESET)
-	{
+	if (priv->ResetProgress == RESET_TYPE_NORESET) {
 		/* if D or C cut */
 		u8 tmpvalue = read_nic_byte(dev, 0x301);
-		if(tmpvalue ==0x03)
-		{
+		if (tmpvalue == 0x03) {
 			priv->bDcut = TRUE;
 			RT_TRACE(COMP_POWER_TRACKING, "D-cut\n");
-		}
-		else
-		{
+		} else {
 			priv->bDcut = FALSE;
 			RT_TRACE(COMP_POWER_TRACKING, "C-cut\n");
 		}
 		dm_initialize_txpower_tracking(dev);
 
-		if(priv->bDcut == TRUE)
-		{
+		if (priv->bDcut == TRUE) {
 			u32 i, TempCCk;
-			u32 tmpRegA= rtl8192_QueryBBReg(dev,rOFDM0_XATxIQImbalance,bMaskDWord);
+			u32 tmpRegA = rtl8192_QueryBBReg(dev,
+					rOFDM0_XATxIQImbalance, bMaskDWord);
 			/* u32 tmpRegC= rtl8192_QueryBBReg(dev,
 			 * rOFDM0_XCTxIQImbalance,bMaskDWord);
 			 */
-			for(i = 0; i<TxBBGainTableLength; i++)
-			{
-				if(tmpRegA == priv->txbbgain_table[i].txbbgain_value)
-				{
-					priv->rfa_txpowertrackingindex= (u8)i;
-					priv->rfa_txpowertrackingindex_real= (u8)i;
-					priv->rfa_txpowertracking_default= priv->rfa_txpowertrackingindex;
+			for (i = 0; i < TxBBGainTableLength; i++) {
+				if (tmpRegA == priv->txbbgain_table[i].txbbgain_value) {
+					priv->rfa_txpowertrackingindex = (u8)i;
+					priv->rfa_txpowertrackingindex_real =
+									(u8)i;
+					priv->rfa_txpowertracking_default =
+						priv->rfa_txpowertrackingindex;
 					break;
 				}
 			}
 
-			TempCCk = rtl8192_QueryBBReg(dev, rCCK0_TxFilter1, bMaskByte2);
-
-			for(i=0 ; i<CCKTxBBGainTableLength ; i++)
-			{
+			TempCCk = rtl8192_QueryBBReg(dev, rCCK0_TxFilter1,
+							bMaskByte2);
 
-				if(TempCCk == priv->cck_txbbgain_table[i].ccktxbb_valuearray[0])
-				{
-					priv->cck_present_attentuation_20Mdefault=(u8) i;
+			for (i = 0 ; i < CCKTxBBGainTableLength ; i++) {
+				if (TempCCk == priv->cck_txbbgain_table[i].ccktxbb_valuearray[0]) {
+					priv->cck_present_attentuation_20Mdefault = (u8) i;
 					break;
 				}
 			}
-			priv->cck_present_attentuation_40Mdefault= 0;
-			priv->cck_present_attentuation_difference= 0;
-			priv->cck_present_attentuation = priv->cck_present_attentuation_20Mdefault;
+			priv->cck_present_attentuation_40Mdefault = 0;
+			priv->cck_present_attentuation_difference = 0;
+			priv->cck_present_attentuation =
+				priv->cck_present_attentuation_20Mdefault;
 
 			/* pMgntInfo->bTXPowerTracking = FALSE; */
 			/* TEMPLY DISABLE */
@@ -3833,14 +3843,13 @@ HalTxCheckStuck819xUsb(
 	)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	u16 		RegTxCounter = read_nic_word(dev, 0x128);
+	u16		RegTxCounter = read_nic_word(dev, 0x128);
 	bool		bStuck = FALSE;
-	RT_TRACE(COMP_RESET,"%s():RegTxCounter is %d,TxCounter is %d\n",__func__,RegTxCounter,priv->TxCounter);
-	if(priv->TxCounter==RegTxCounter)
+	RT_TRACE(COMP_RESET, "%s():RegTxCounter is %d, TxCounter is %d\n",
+				__func__, RegTxCounter, priv->TxCounter);
+	if (priv->TxCounter == RegTxCounter)
 		bStuck = TRUE;
-
 	priv->TxCounter = RegTxCounter;
-
 	return bStuck;
 }
 
@@ -3863,27 +3872,28 @@ TxCheckStuck(struct net_device *dev)
 	/* RT_TRACE(COMP_RESET, " ==> TxCheckStuck()\n"); */
 	/* PlatformAcquireSpinLock(Adapter, RT_TX_SPINLOCK); */
 	/* spin_lock_irqsave(&priv->ieee80211->lock,flags); */
-	     for (QueueID = 0; QueueID<=BEACON_QUEUE;QueueID ++)
-	     {
-	     		if(QueueID == TXCMD_QUEUE)
-		         continue;
+	for (QueueID = 0; QueueID <= BEACON_QUEUE; QueueID++) {
+		if (QueueID == TXCMD_QUEUE)
+			continue;
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
-			if((skb_queue_len(&priv->ieee80211->skb_waitQ[QueueID]) == 0) && (skb_queue_len(&priv->ieee80211->skb_aggQ[QueueID]) == 0) && (skb_queue_len(&priv->ieee80211->skb_drv_aggQ[QueueID]) == 0))
+			if ((skb_queue_len(&priv->ieee80211->skb_waitQ[QueueID]) == 0)
+					&& (skb_queue_len(&priv->ieee80211->skb_aggQ[QueueID]) == 0)
+					&& (skb_queue_len(&priv->ieee80211->skb_drv_aggQ[QueueID]) == 0))
 #else
-		     	if((skb_queue_len(&priv->ieee80211->skb_waitQ[QueueID]) == 0)  && (skb_queue_len(&priv->ieee80211->skb_aggQ[QueueID]) == 0))
+			if ((skb_queue_len(&priv->ieee80211->skb_waitQ[QueueID]) == 0)
+					&& (skb_queue_len(&priv->ieee80211->skb_aggQ[QueueID]) == 0))
 #endif
-			 	continue;
+				continue;
 
-	             bCheckFwTxCnt = true;
+			bCheckFwTxCnt = true;
 	     }
 	/* PlatformReleaseSpinLock(Adapter, RT_TX_SPINLOCK); */
 	/* spin_unlock_irqrestore(&priv->ieee80211->lock,flags); */
 	/* RT_TRACE(COMP_RESET,"bCheckFwTxCnt is %d\n",bCheckFwTxCnt); */
-	if(bCheckFwTxCnt)
-	{
-		if(HalTxCheckStuck819xUsb(dev))
-		{
-			RT_TRACE(COMP_RESET, "TxCheckStuck(): Fw indicates no Tx condition! \n");
+	if (bCheckFwTxCnt) {
+		if (HalTxCheckStuck819xUsb(dev)) {
+			RT_TRACE(COMP_RESET, "TxCheckStuck(): Fw indicates no"
+					" Tx condition!\n");
 			return RESET_TYPE_SILENT;
 		}
 	}
@@ -3893,73 +3903,62 @@ TxCheckStuck(struct net_device *dev)
 bool
 HalRxCheckStuck819xUsb(struct net_device *dev)
 {
-	u16 	RegRxCounter = read_nic_word(dev, 0x130);
+	u16	RegRxCounter = read_nic_word(dev, 0x130);
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	bool bStuck = FALSE;
-	static u8	rx_chk_cnt = 0;
-	RT_TRACE(COMP_RESET,"%s(): RegRxCounter is %d,RxCounter is %d\n",__func__,RegRxCounter,priv->RxCounter);
+	static u8	rx_chk_cnt;
+	RT_TRACE(COMP_RESET, "%s(): RegRxCounter is %d, RxCounter is %d\n",
+				__func__, RegRxCounter, priv->RxCounter);
 	/* If rssi is small, we should check rx for long time because of bad rx.
 	 * or maybe it will continuous silent reset every 2 seconds.
 	 */
 	rx_chk_cnt++;
-	if(priv->undecorated_smoothed_pwdb >= (RateAdaptiveTH_High+5))
-	{
+	if (priv->undecorated_smoothed_pwdb >= (RateAdaptiveTH_High + 5))
 		rx_chk_cnt = 0;	/* high rssi, check rx stuck right now. */
-	}
-	else if(priv->undecorated_smoothed_pwdb < (RateAdaptiveTH_High+5) &&
-		((priv->CurrentChannelBW!=HT_CHANNEL_WIDTH_20&&priv->undecorated_smoothed_pwdb>=RateAdaptiveTH_Low_40M) ||
-		(priv->CurrentChannelBW==HT_CHANNEL_WIDTH_20&&priv->undecorated_smoothed_pwdb>=RateAdaptiveTH_Low_20M)) )
-	{
-		if(rx_chk_cnt < 2)
-		{
+	else if (priv->undecorated_smoothed_pwdb < (RateAdaptiveTH_High + 5) &&
+			((priv->CurrentChannelBW != HT_CHANNEL_WIDTH_20 &&
+			priv->undecorated_smoothed_pwdb >=
+			RateAdaptiveTH_Low_40M) ||
+			(priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20 &&
+			priv->undecorated_smoothed_pwdb >=
+			RateAdaptiveTH_Low_20M))) {
+		if (rx_chk_cnt < 2)
 			return bStuck;
-		}
 		else
-		{
 			rx_chk_cnt = 0;
-		}
-	}
-	else if(((priv->CurrentChannelBW!=HT_CHANNEL_WIDTH_20&&priv->undecorated_smoothed_pwdb<RateAdaptiveTH_Low_40M) ||
-		(priv->CurrentChannelBW==HT_CHANNEL_WIDTH_20&&priv->undecorated_smoothed_pwdb<RateAdaptiveTH_Low_20M)) &&
-		priv->undecorated_smoothed_pwdb >= VeryLowRSSI)
-	{
-		if(rx_chk_cnt < 4)
-		{
+	} else if (((priv->CurrentChannelBW != HT_CHANNEL_WIDTH_20 &&
+			priv->undecorated_smoothed_pwdb <
+			RateAdaptiveTH_Low_40M) ||
+			(priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20 &&
+			priv->undecorated_smoothed_pwdb <
+			RateAdaptiveTH_Low_20M)) &&
+			priv->undecorated_smoothed_pwdb >= VeryLowRSSI) {
+		if (rx_chk_cnt < 4)
 			/* DbgPrint("RSSI < %d && RSSI >= %d,"
-			 *	" no check this time \n", RateAdaptiveTH_Low,
+			 *	" no check this time\n", RateAdaptiveTH_Low,
 			 *					 VeryLowRSSI);
 			 */
 			return bStuck;
-		}
 		else
-		{
 			rx_chk_cnt = 0;
 			/* DbgPrint("RSSI < %d && RSSI >= %d, check this time"
 			 *		"\n", RateAdaptiveTH_Low, VeryLowRSSI);
 			 */
-		}
-	}
-	else
-	{
-		if(rx_chk_cnt < 8)
-		{
-			/* DbgPrint("RSSI <= %d, no check this time \n",
+	} else {
+		if (rx_chk_cnt < 8)
+			/* DbgPrint("RSSI <= %d, no check this time\n",
 			 *					 VeryLowRSSI);
 			 */
 			return bStuck;
-		}
 		else
-		{
 			rx_chk_cnt = 0;
-			/* DbgPrint("RSSI <= %d, check this time \n",
+			/* DbgPrint("RSSI <= %d, check this time\n",
 			 *					 VeryLowRSSI);
 			 */
-		}
 	}
 
-	if(priv->RxCounter==RegRxCounter)
+	if (priv->RxCounter == RegRxCounter)
 		bStuck = TRUE;
-
 	priv->RxCounter = RegRxCounter;
 
 	return bStuck;
@@ -3975,15 +3974,13 @@ RxCheckStuck(struct net_device *dev)
 	/* RT_TRACE(COMP_RESET," ==> RxCheckStuck()\n"); */
 	/* PlatformAcquireSpinLock(Adapter, RT_RX_SPINLOCK); */
 
-	 if(priv->IrpPendingCount > 1)
+	 if (priv->IrpPendingCount > 1)
 		bRxCheck = TRUE;
 	/* PlatformReleaseSpinLock(Adapter, RT_RX_SPINLOCK); */
 
-	/* RT_TRACE(COMP_RESET,"bRxCheck is %d \n",bRxCheck); */
-	if(bRxCheck)
-	{
-		if(HalRxCheckStuck819xUsb(dev))
-		{
+	/* RT_TRACE(COMP_RESET,"bRxCheck is %d\n",bRxCheck); */
+	if (bRxCheck) {
+		if (HalRxCheckStuck819xUsb(dev)) {
 			RT_TRACE(COMP_RESET, "RxStuck Condition\n");
 			return RESET_TYPE_SILENT;
 		}
@@ -3991,30 +3988,35 @@ RxCheckStuck(struct net_device *dev)
 	return RESET_TYPE_NORESET;
 }
 
-/*	This function is called by Checkforhang to check whether we should ask OS to reset driver
+/*	This function is called by Checkforhang to check whether we should
+ *	 ask OS to reset driver
  *
  *	\param pAdapter	The adapter context for this miniport
  *
- *	Note:NIC with USB interface sholud not call this function because we cannot scan descriptor
+ *	Note:NIC with USB interface sholud not call this function because we
+ *	 cannot scan descriptor
  *	to judge whether there is tx stuck.
  *	Note: This function may be required to be rewrite for Vista OS.
  *	<<<Assumption: Tx spinlock has been acquired >>>
  *
- *	8185 and 8185b does not implement this function. This is added by Emily at 2006.11.24
+ *	8185 and 8185b does not implement this function.
+ *	 This is added by Emily at 2006.11.24
  */
 RESET_TYPE
 rtl819x_ifcheck_resetornot(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	RESET_TYPE	TxResetType = RESET_TYPE_NORESET;
-	RESET_TYPE	RxResetType = RESET_TYPE_NORESET;
-	RT_RF_POWER_STATE 	rfState;
+	RESET_TYPE		TxResetType = RESET_TYPE_NORESET;
+	RESET_TYPE		RxResetType = RESET_TYPE_NORESET;
+	RT_RF_POWER_STATE	rfState;
 
 	rfState = priv->ieee80211->eRFPowerState;
 
 	TxResetType = TxCheckStuck(dev);
-	if( rfState != eRfOff ||
-		/* ADAPTER_TEST_STATUS_FLAG(Adapter, ADAPTER_STATUS_FW_DOWNLOAD_FAILURE)) && */
+	if (rfState != eRfOff ||
+		/* ADAPTER_TEST_STATUS_FLAG(Adapter,
+		 * ADAPTER_STATUS_FW_DOWNLOAD_FAILURE)) &&
+		 */
 		(priv->ieee80211->iw_mode != IW_MODE_ADHOC))
 	{
 		/* If driver is in the status of firmware download failure,
@@ -4032,13 +4034,14 @@ rtl819x_ifcheck_resetornot(struct net_device *dev)
 		 */
 		RxResetType = RxCheckStuck(dev);
 	}
-	if(TxResetType==RESET_TYPE_NORMAL || RxResetType==RESET_TYPE_NORMAL)
+	if (TxResetType == RESET_TYPE_NORMAL ||
+				RxResetType == RESET_TYPE_NORMAL)
 		return RESET_TYPE_NORMAL;
-	else if(TxResetType==RESET_TYPE_SILENT || RxResetType==RESET_TYPE_SILENT){
-		RT_TRACE(COMP_RESET,"%s():silent reset\n",__func__);
+	else if(TxResetType == RESET_TYPE_SILENT ||
+				RxResetType==RESET_TYPE_SILENT){
+		RT_TRACE(COMP_RESET, "%s():silent reset\n", __func__);
 		return RESET_TYPE_SILENT;
-	}
-	else
+	} else
 		return RESET_TYPE_NORESET;
 
 }
-- 
1.6.3.3

