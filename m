Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0DCIaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 04:30:09 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:35060 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0DCIaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 04:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=P6gnjbgbmOnQx9ApMBxcoXsE9aB6/zRkZBAabjdMLV09+9z0XOE6lL1ieZakbxqH9K
         4L9vlbv1k57u2cP/f1KlKyuJSgxU+KksxzHxBFEWypYmducXEuBpaAwTdhvfgcjU3qvC
         y0ZjBO4FOIUq7r1Ofd4l7cwWuGwkbZFde/DxY=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, bzolnier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 9/9] Staging:rt2860: fix coding style issue in mac_pci.h, mac_usb.h, rtmp_mac.h, rtmp_phy.h
Date: Sat,  3 Apr 2010 14:29:13 +0600
Message-Id: <1270283353-20009-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the mac_pci.h, mac_usb.h, rtmp_mac.h, rtmp_phy.h files
that fixes up errors found by the checkpatch.pl tool

Signed-off-by: Gorskin Ilya <revent82@gmail.com>
---
 drivers/staging/rt2860/chip/mac_pci.h  |   41 ++--
 drivers/staging/rt2860/chip/mac_usb.h  |   55 +++---
 drivers/staging/rt2860/chip/rtmp_mac.h |   52 +++---
 drivers/staging/rt2860/chip/rtmp_phy.h |  338 ++++++++++++++------------------
 4 files changed, 221 insertions(+), 265 deletions(-)

diff --git a/drivers/staging/rt2860/chip/mac_pci.h b/drivers/staging/rt2860/chip/mac_pci.h
index bc704ac..9f25ef0 100644
--- a/drivers/staging/rt2860/chip/mac_pci.h
+++ b/drivers/staging/rt2860/chip/mac_pci.h
@@ -147,13 +147,12 @@ typedef union _TX_ATTENUATION_CTRL_STRUC {
 
 /* ----------------- Frimware Related MACRO ----------------- */
 #define RTMP_WRITE_FIRMWARE(_pAd, _pFwImage, _FwLen)			\
-	do{								\
+	do {								\
 		unsigned long	_i, _firm;					\
 		RTMP_IO_WRITE32(_pAd, PBF_SYS_CTRL, 0x10000);		\
 									\
-		for(_i=0; _i<_FwLen; _i+=4)				\
-		{							\
-			_firm = _pFwImage[_i] +				\
+		for (_i = 0; _i < _FwLen; _i += 4) {				\
+				_firm = _pFwImage[_i] +				\
 			   (_pFwImage[_i+3] << 24) +			\
 			   (_pFwImage[_i+2] << 16) +			\
 			   (_pFwImage[_i+1] << 8);			\
@@ -165,19 +164,19 @@ typedef union _TX_ATTENUATION_CTRL_STRUC {
 		/* initialize BBP R/W access agent */			\
 		RTMP_IO_WRITE32(_pAd, H2M_BBP_AGENT, 0);		\
 		RTMP_IO_WRITE32(_pAd, H2M_MAILBOX_CSR, 0);		\
-	}while(0)
+	} while (0)
 
 /* ----------------- TX Related MACRO ----------------- */
-#define RTMP_START_DEQUEUE(pAd, QueIdx, irqFlags)		do{}while(0)
-#define RTMP_STOP_DEQUEUE(pAd, QueIdx, irqFlags)		do{}while(0)
+#define RTMP_START_DEQUEUE(pAd, QueIdx, irqFlags)		do {} while (0)
+#define RTMP_STOP_DEQUEUE(pAd, QueIdx, irqFlags)		do {} while (0)
 
 #define RTMP_HAS_ENOUGH_FREE_DESC(pAd, pTxBlk, freeNum, pPacket) \
 		((freeNum) >= (unsigned long)(pTxBlk->TotalFragNum + RTMP_GET_PACKET_FRAGMENTS(pPacket) + 3))	/* rough estimate we will use 3 more descriptor. */
-#define RTMP_RELEASE_DESC_RESOURCE(pAd, QueIdx)	\
-		do{}while(0)
+#define RTMP_RELEASE_DESC_RESOURCE(pAd, QueIdx)			do {} while (0)
 
 #define NEED_QUEUE_BACK_FOR_AGG(pAd, QueIdx, freeNum, _TxFrameType) \
-		(((freeNum != (TX_RING_SIZE-1)) && (pAd->TxSwQueue[QueIdx].Number == 0)) || (freeNum<3))
+		(((freeNum != (TX_RING_SIZE-1)) && \
+		(pAd->TxSwQueue[QueIdx].Number == 0)) || (freeNum < 3))
 
 #define HAL_KickOutMgmtTx(_pAd, _QueIdx, _pPacket, _pSrcBufVA, _SrcBufLen)	\
 			RtmpPCIMgmtKickOut(_pAd, _QueIdx, _pPacket, _pSrcBufVA, _SrcBufLen)
@@ -185,19 +184,19 @@ typedef union _TX_ATTENUATION_CTRL_STRUC {
 #define HAL_WriteSubTxResource(pAd, pTxBlk, bIsLast, pFreeNumber)	\
 				/* RtmpPCI_WriteSubTxResource(pAd, pTxBlk, bIsLast, pFreeNumber) */
 
-#define HAL_WriteTxResource(pAd, pTxBlk,bIsLast, pFreeNumber)	\
+#define HAL_WriteTxResource(pAd, pTxBlk, bIsLast, pFreeNumber)	\
 			RtmpPCI_WriteSingleTxResource(pAd, pTxBlk, bIsLast, pFreeNumber)
 
 #define HAL_WriteFragTxResource(pAd, pTxBlk, fragNum, pFreeNumber) \
 			RtmpPCI_WriteFragTxResource(pAd, pTxBlk, fragNum, pFreeNumber)
 
-#define HAL_WriteMultiTxResource(pAd, pTxBlk,frameNum, pFreeNumber)	\
+#define HAL_WriteMultiTxResource(pAd, pTxBlk, frameNum, pFreeNumber) \
 			RtmpPCI_WriteMultiTxResource(pAd, pTxBlk, frameNum, pFreeNumber)
 
 #define HAL_FinalWriteTxResource(_pAd, _pTxBlk, _TotalMPDUSize, _FirstTxIdx)	\
 			RtmpPCI_FinalWriteTxResource(_pAd, _pTxBlk, _TotalMPDUSize, _FirstTxIdx)
 
-#define HAL_LastTxIdx(_pAd, _QueIdx,_LastTxIdx) \
+#define HAL_LastTxIdx(_pAd, _QueIdx, _LastTxIdx) \
 				/*RtmpPCIDataLastTxIdx(_pAd, _QueIdx,_LastTxIdx) */
 
 #define HAL_KickOutTx(_pAd, _pTxBlk, _QueIdx)	\
@@ -259,24 +258,24 @@ typedef union _TX_ATTENUATION_CTRL_STRUC {
 
 /* Insert the BA bitmap to ASIC for the Wcid entry */
 #define RTMP_ADD_BA_SESSION_TO_ASIC(_pAd, _Aid, _TID)	\
-		do{					\
+		do {					\
 			u32 _Value = 0, _Offset;					\
 			_Offset = MAC_WCID_BASE + (_Aid) * HW_WCID_ENTRY_SIZE + 4;	\
 			RTMP_IO_READ32((_pAd), _Offset, &_Value);\
 			_Value |= (0x10000<<(_TID));	\
 			RTMP_IO_WRITE32((_pAd), _Offset, _Value);\
-		}while(0)
+		} while (0)
 
 /* Remove the BA bitmap from ASIC for the Wcid entry */
 /*              bitmap field starts at 0x10000 in ASIC WCID table */
 #define RTMP_DEL_BA_SESSION_FROM_ASIC(_pAd, _Wcid, _TID)				\
-		do{								\
+		do {								\
 			u32 _Value = 0, _Offset;				\
 			_Offset = MAC_WCID_BASE + (_Wcid) * HW_WCID_ENTRY_SIZE + 4;	\
 			RTMP_IO_READ32((_pAd), _Offset, &_Value);			\
 			_Value &= (~(0x10000 << (_TID)));				\
 			RTMP_IO_WRITE32((_pAd), _Offset, _Value);			\
-		}while(0)
+		} while (0)
 
 /* ----------------- Interface Related MACRO ----------------- */
 
@@ -285,16 +284,16 @@ typedef union _TX_ATTENUATION_CTRL_STRUC {
 /* Since it use ADAPTER structure, it have to be put after structure definition. */
 /* */
 #define RTMP_ASIC_INTERRUPT_DISABLE(_pAd)		\
-	do{			\
+	do {			\
 		RTMP_IO_WRITE32((_pAd), INT_MASK_CSR, 0x0);     /* 0: disable */	\
 		RTMP_CLEAR_FLAG((_pAd), fRTMP_ADAPTER_INTERRUPT_ACTIVE);		\
-	}while(0)
+	} while (0)
 
 #define RTMP_ASIC_INTERRUPT_ENABLE(_pAd)\
-	do{				\
+	do {				\
 		RTMP_IO_WRITE32((_pAd), INT_MASK_CSR, (_pAd)->int_enable_reg /*DELAYINTMASK*/);     /* 1:enable */	\
 		RTMP_SET_FLAG((_pAd), fRTMP_ADAPTER_INTERRUPT_ACTIVE);	\
-	}while(0)
+	} while (0)
 
 #define RTMP_IRQ_INIT(pAd)	\
 	{	pAd->int_enable_reg = ((DELAYINTMASK) |		\
diff --git a/drivers/staging/rt2860/chip/mac_usb.h b/drivers/staging/rt2860/chip/mac_usb.h
index 0b67c0b..ed0c0b4 100644
--- a/drivers/staging/rt2860/chip/mac_usb.h
+++ b/drivers/staging/rt2860/chip/mac_usb.h
@@ -25,7 +25,7 @@
  *************************************************************************
 
     Module Name:
-        mac_usb.h
+		mac_usb.h
 
     Abstract:
 
@@ -46,7 +46,7 @@
 #define USB_CYC_CFG				0x02a4
 
 #define BEACON_RING_SIZE		2
-#define MGMTPIPEIDX				0	/* EP6 is highest priority */
+#define MGMTPIPEIDX			0	/* EP6 is highest priority */
 
 #define RTMP_PKT_TAIL_PADDING	11	/* 3(max 4 byte padding) + 4 (last packet padding) + 4 (MaxBulkOutsize align padding) */
 
@@ -220,53 +220,51 @@ struct rt_rx_context {
 
 ******************************************************************************/
 #define RTMP_START_DEQUEUE(pAd, QueIdx, irqFlags)				\
-			do{													\
+			do {													\
 				RTMP_IRQ_LOCK(&pAd->DeQueueLock[QueIdx], irqFlags);		\
-				if (pAd->DeQueueRunning[QueIdx])						\
-				{														\
-					RTMP_IRQ_UNLOCK(&pAd->DeQueueLock[QueIdx], irqFlags);\
+				if (pAd->DeQueueRunning[QueIdx]) {						\
+					RTMP_IRQ_UNLOCK(&pAd->DeQueueLock[QueIdx], irqFlags); \
 					DBGPRINT(RT_DEBUG_OFF, ("DeQueueRunning[%d]= TRUE!\n", QueIdx));		\
 					continue;											\
-				}														\
-				else													\
-				{														\
+				} else {												\
 					pAd->DeQueueRunning[QueIdx] = TRUE;					\
 					RTMP_IRQ_UNLOCK(&pAd->DeQueueLock[QueIdx], irqFlags);\
 				}														\
-			}while(0)
+			} while (0)
 
 #define RTMP_STOP_DEQUEUE(pAd, QueIdx, irqFlags)						\
-			do{															\
+			do {													\
 				RTMP_IRQ_LOCK(&pAd->DeQueueLock[QueIdx], irqFlags);		\
 				pAd->DeQueueRunning[QueIdx] = FALSE;					\
 				RTMP_IRQ_UNLOCK(&pAd->DeQueueLock[QueIdx], irqFlags);	\
-			}while(0)
+			} while (0)
 
 #define	RTMP_HAS_ENOUGH_FREE_DESC(pAd, pTxBlk, freeNum, pPacket) \
 		(RTUSBFreeDescriptorRequest(pAd, pTxBlk->QueIdx, (pTxBlk->TotalFrameLen + GET_OS_PKT_LEN(pPacket))) == NDIS_STATUS_SUCCESS)
 
 #define RTMP_RELEASE_DESC_RESOURCE(pAd, QueIdx)			\
-		do{}while(0)
+		do {} while (0)
 
 #define NEED_QUEUE_BACK_FOR_AGG(_pAd, _QueIdx, _freeNum, _TxFrameType)		\
-		((_TxFrameType == TX_RALINK_FRAME) && (RTUSBNeedQueueBackForAgg(_pAd, _QueIdx)))
+		((_TxFrameType == TX_RALINK_FRAME) && \
+		(RTUSBNeedQueueBackForAgg(_pAd, _QueIdx)))
 
 #define HAL_WriteSubTxResource(pAd, pTxBlk, bIsLast, pFreeNumber)	\
-			RtmpUSB_WriteSubTxResource(pAd, pTxBlk, bIsLast, pFreeNumber)
+		RtmpUSB_WriteSubTxResource(pAd, pTxBlk, bIsLast, pFreeNumber)
 
-#define HAL_WriteTxResource(pAd, pTxBlk,bIsLast, pFreeNumber)	\
-			RtmpUSB_WriteSingleTxResource(pAd, pTxBlk,bIsLast, pFreeNumber)
+#define HAL_WriteTxResource(pAd, pTxBlk, bIsLast, pFreeNumber)	\
+		RtmpUSB_WriteSingleTxResource(pAd, pTxBlk, bIsLast, pFreeNumber)
 
 #define HAL_WriteFragTxResource(pAd, pTxBlk, fragNum, pFreeNumber) \
-			RtmpUSB_WriteFragTxResource(pAd, pTxBlk, fragNum, pFreeNumber)
+		RtmpUSB_WriteFragTxResource(pAd, pTxBlk, fragNum, pFreeNumber)
 
-#define HAL_WriteMultiTxResource(pAd, pTxBlk,frameNum, pFreeNumber)	\
-			RtmpUSB_WriteMultiTxResource(pAd, pTxBlk,frameNum, pFreeNumber)
+#define HAL_WriteMultiTxResource(pAd, pTxBlk, frameNum, pFreeNumber)	\
+		RtmpUSB_WriteMultiTxResource(pAd, pTxBlk, frameNum, pFreeNumber)
 
 #define HAL_FinalWriteTxResource(pAd, pTxBlk, totalMPDUSize, TxIdx)	\
-			RtmpUSB_FinalWriteTxResource(pAd, pTxBlk, totalMPDUSize, TxIdx)
+		RtmpUSB_FinalWriteTxResource(pAd, pTxBlk, totalMPDUSize, TxIdx)
 
-#define HAL_LastTxIdx(pAd, QueIdx,TxIdx) \
+#define HAL_LastTxIdx(pAd, QueIdx, TxIdx) \
 				/*RtmpUSBDataLastTxIdx(pAd, QueIdx,TxIdx) */
 
 #define HAL_KickOutTx(pAd, pTxBlk, QueIdx)	\
@@ -286,8 +284,8 @@ struct rt_rx_context {
 /*
   *	Device Hardware Interface Related MACRO
   */
-#define RTMP_IRQ_INIT(pAd)				do{}while(0)
-#define RTMP_IRQ_ENABLE(pAd)			do{}while(0)
+#define RTMP_IRQ_INIT(pAd)				do {} while (0)
+#define RTMP_IRQ_ENABLE(pAd)			do {} while (0)
 
 /*
   *	MLME Related MACRO
@@ -305,8 +303,8 @@ struct rt_rx_context {
 		RTUSBMlmeUp(pAd); }
 
 #define RTMP_MLME_RESET_STATE_MACHINE(pAd)	\
-		        MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_RESET_CONF, 0, NULL);	\
-		        RTUSBMlmeUp(pAd);
+	{	MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_RESET_CONF, 0, NULL);	\
+		RTUSBMlmeUp(pAd); }
 
 #define RTMP_HANDLE_COUNTER_MEASURE(_pAd, _pEntry)		\
 	{	RTUSBEnqueueInternalCmd(_pAd, CMDTHREAD_802_11_COUNTER_MEASURE, _pEntry, sizeof(struct rt_mac_table_entry));	\
@@ -330,12 +328,11 @@ struct rt_rx_context {
 	{\
 		if ((_pAd)->StaCfg.WindowsPowerMode == Ndis802_11PowerModeFast_PSP) \
 			MlmeSetPsmBit(_pAd, _val);\
-		else \
-		{ \
+		else { \
 			u16 _psm_val; \
 			_psm_val = _val; \
 			RTUSBEnqueueInternalCmd(_pAd, CMDTHREAD_SET_PSM_BIT, &(_psm_val), sizeof(u16)); \
-		}\
+		} \
 	}
 
 #define RTMP_MLME_RADIO_ON(pAd) \
diff --git a/drivers/staging/rt2860/chip/rtmp_mac.h b/drivers/staging/rt2860/chip/rtmp_mac.h
index f6a7258..e8f7172 100644
--- a/drivers/staging/rt2860/chip/rtmp_mac.h
+++ b/drivers/staging/rt2860/chip/rtmp_mac.h
@@ -154,7 +154,7 @@ typedef union _INT_SOURCE_CSR_STRUC {
 		u32 GPTimer:1;
 		u32 RxCoherent:1;	/*bit16 */
 		u32 TxCoherent:1;
-		u32 : 14;
+		u32: 14;
 	} field;
 	u32 word;
 } INT_SOURCE_CSR_STRUC, *PINT_SOURCE_CSR_STRUC;
@@ -175,7 +175,7 @@ typedef union _INT_MASK_CSR_STRUC {
 		u32 HccaDmaDone:1;
 		u32 MgmtDmaDone:1;
 		u32 MCUCommandINT:1;
-		u32 : 20;
+		u32: 20;
 		u32 RxCoherent:1;
 		u32 TxCoherent:1;
 	} field;
@@ -209,7 +209,7 @@ typedef union _WPDMA_RST_IDX_STRUC {
 		u32 RST_DTX_IDX5:1;
 		u32 rsv:10;
 		u32 RST_DRX_IDX0:1;
-		u32 : 15;
+		u32: 15;
 	} field;
 	u32 word;
 } WPDMA_RST_IDX_STRUC, *PWPDMA_RST_IDX_STRUC;
@@ -448,7 +448,7 @@ typedef union _BBP_CSR_CFG_STRUC {
 		u32 Busy:1;	/* 1: ASIC is busy execute BBP programming. */
 		u32 BBP_PAR_DUR:1;	/* 0: 4 MAC clock cycles  1: 8 MAC clock cycles */
 		u32 BBP_RW_MODE:1;	/* 0: use serial mode  1:parallel */
-		u32 : 12;
+		u32: 12;
 	} field;
 	u32 word;
 } BBP_CSR_CFG_STRUC, *PBBP_CSR_CFG_STRUC;
@@ -494,7 +494,7 @@ typedef union _LED_CFG_STRUC {
 		u32 GLedMode:2;	/* green Led Mode */
 		u32 YLedMode:2;	/* yellow Led Mode */
 		u32 LedPolar:1;	/* Led Polarity.  0: active low1: active high */
-		u32 : 1;
+		u32: 1;
 	} field;
 	u32 word;
 } LED_CFG_STRUC, *PLED_CFG_STRUC;
@@ -533,7 +533,7 @@ typedef union _BCN_TIME_CFG_STRUC {
 		u32 TsfSyncMode:2;	/* Enable TSF sync, 00: disable, 01: infra mode, 10: ad-hoc mode */
 		u32 bTBTTEnable:1;
 		u32 bBeaconGen:1;	/* Enable beacon generator */
-		u32 : 3;
+		u32: 3;
 		u32 TxTimestampCompensate:8;
 	} field;
 	u32 word;
@@ -560,7 +560,7 @@ typedef union _AUTO_WAKEUP_STRUC {
 		u32 AutoLeadTime:8;
 		u32 NumofSleepingTbtt:7;	/* ForceWake has high privilege than PutToSleep when both set */
 		u32 EnableAutoWakeup:1;	/* 0:sleep, 1:awake */
-		u32 : 16;
+		u32: 16;
 	} field;
 	u32 word;
 } AUTO_WAKEUP_STRUC, *PAUTO_WAKEUP_STRUC;
@@ -578,7 +578,7 @@ typedef union _EDCA_AC_CFG_STRUC {
 		u32 Aifsn:4;	/* # of slot time */
 		u32 Cwmin:4;	/* */
 		u32 Cwmax:4;	/*unit power of 2 */
-		u32 : 12;	/* */
+		u32: 12;	/* */
 	} field;
 	u32 word;
 } EDCA_AC_CFG_STRUC, *PEDCA_AC_CFG_STRUC;
@@ -751,7 +751,7 @@ typedef union _AUTO_RSP_CFG_STRUC {
 		u32 rsv:1;	/* Power bit value in conrtrol frame */
 		u32 DualCTSEn:1;	/* Power bit value in conrtrol frame */
 		u32 AckCtsPsmBit:1;	/* Power bit value in conrtrol frame */
-		u32 : 24;
+		u32: 24;
 	} field;
 	u32 word;
 } AUTO_RSP_CFG_STRUC, *PAUTO_RSP_CFG_STRUC;
@@ -981,21 +981,21 @@ typedef union _MPDU_DEN_CNT_STRUC {
 typedef union _SHAREDKEY_MODE_STRUC {
 	struct {
 		u32 Bss0Key0CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss0Key1CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss0Key2CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss0Key3CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss1Key0CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss1Key1CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss1Key2CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss1Key3CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 	} field;
 	u32 word;
 } SHAREDKEY_MODE_STRUC, *PSHAREDKEY_MODE_STRUC;
@@ -1103,7 +1103,7 @@ typedef union _RX_FILTR_CFG_STRUC {
 		u32 DropBAR:1;	/* */
 
 		u32 DropRsvCntlType:1;
-		u32 : 15;
+		u32: 15;
 	} field;
 	u32 word;
 } RX_FILTR_CFG_STRUC, *PRX_FILTR_CFG_STRUC;
@@ -1128,21 +1128,21 @@ typedef union _PHY_CSR4_STRUC {
 typedef union _SEC_CSR5_STRUC {
 	struct {
 		u32 Bss2Key0CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss2Key1CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss2Key2CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss2Key3CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss3Key0CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss3Key1CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss3Key2CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 		u32 Bss3Key3CipherAlg:3;
-		u32 : 1;
+		u32: 1;
 	} field;
 	u32 word;
 } SEC_CSR5_STRUC, *PSEC_CSR5_STRUC;
diff --git a/drivers/staging/rt2860/chip/rtmp_phy.h b/drivers/staging/rt2860/chip/rtmp_phy.h
index 8b8b0f4..9f924ea 100644
--- a/drivers/staging/rt2860/chip/rtmp_phy.h
+++ b/drivers/staging/rt2860/chip/rtmp_phy.h
@@ -177,8 +177,7 @@
 #ifdef RTMP_MAC_PCI
 #define RTMP_RF_IO_WRITE32(_A, _V)                  \
 {											\
-	if ((_A)->bPCIclkOff == FALSE)	                \
-	{												\
+	if ((_A)->bPCIclkOff == FALSE) {				\
 		PHY_CSR4_STRUC  _value;                          \
 		unsigned long           _busyCnt = 0;                    \
 											\
@@ -187,9 +186,8 @@
 			if (_value.field.Busy == IDLE)               \
 				break;                                  \
 			_busyCnt++;                                  \
-		}while (_busyCnt < MAX_BUSY_COUNT);			\
-		if(_busyCnt < MAX_BUSY_COUNT)                   \
-		{                                               \
+		} while (_busyCnt < MAX_BUSY_COUNT);			\
+		if (_busyCnt < MAX_BUSY_COUNT) {			\
 			RTMP_IO_WRITE32((_A), RF_CSR_CFG0, (_V));          \
 		}                                               \
 	}								\
@@ -218,52 +216,46 @@
 	_bViaMCU: if we need access the bbp via the MCU.
 */
 #define RTMP_BBP_IO_READ8(_pAd, _bbpID, _pV, _bViaMCU)			\
-	do{															\
-		BBP_CSR_CFG_STRUC  BbpCsr;								\
-		int   _busyCnt, _secCnt, _regID;						\
-																\
-		_regID = ((_bViaMCU) == TRUE ? H2M_BBP_AGENT : BBP_CSR_CFG);	\
-		for (_busyCnt=0; _busyCnt<MAX_BUSY_COUNT; _busyCnt++)      \
-		{													\
-			RTMP_IO_READ32(_pAd, _regID, &BbpCsr.word);		\
+	do {								\
+		BBP_CSR_CFG_STRUC  BbpCsr;				\
+		int   _busyCnt, _secCnt, _regID;			\
+									\
+		_regID = ((_bViaMCU) == TRUE ? H2M_BBP_AGENT : BBP_CSR_CFG); \
+		for (_busyCnt = 0; _busyCnt < MAX_BUSY_COUNT; _busyCnt++) { \
+			RTMP_IO_READ32(_pAd, _regID, &BbpCsr.word);	\
 			if (BbpCsr.field.Busy == BUSY)                  \
-				continue;                                               \
+				continue;                               \
 			BbpCsr.word = 0;                                \
 			BbpCsr.field.fRead = 1;                         \
-			BbpCsr.field.BBP_RW_MODE = 1;                         \
+			BbpCsr.field.BBP_RW_MODE = 1;                   \
 			BbpCsr.field.Busy = 1;                          \
-			BbpCsr.field.RegNum = _bbpID;                       \
+			BbpCsr.field.RegNum = _bbpID;                   \
 			RTMP_IO_WRITE32(_pAd, _regID, BbpCsr.word);     \
-			if ((_bViaMCU) == TRUE)							\
-			{													\
-				AsicSendCommandToMcu(_pAd, 0x80, 0xff, 0x0, 0x0); \
-				RTMPusecDelay(1000);	\
-			}							\
-			for (_secCnt=0; _secCnt<MAX_BUSY_COUNT; _secCnt++)       \
-			{                                               \
+			if ((_bViaMCU) == TRUE) {			\
+			    AsicSendCommandToMcu(_pAd, 0x80, 0xff, 0x0, 0x0); \
+			    RTMPusecDelay(1000);	\
+			}						\
+			for (_secCnt = 0; _secCnt < MAX_BUSY_COUNT; _secCnt++) { \
 				RTMP_IO_READ32(_pAd, _regID, &BbpCsr.word); \
-				if (BbpCsr.field.Busy == IDLE)              \
-					break;                                  \
-			}                                               \
-			if ((BbpCsr.field.Busy == IDLE) &&              \
-				(BbpCsr.field.RegNum == _bbpID))                \
-			{                                               \
-				*(_pV) = (u8)BbpCsr.field.Value;         \
-				break;                                      \
-			}                                               \
-		}                                                   \
-		if (BbpCsr.field.Busy == BUSY)                      \
-		{                                                   \
-			DBGPRINT_ERR(("BBP(viaMCU=%d) read R%d fail\n", (_bViaMCU), _bbpID));      \
+				if (BbpCsr.field.Busy == IDLE)		\
+					break;				\
+			}						\
+			if ((BbpCsr.field.Busy == IDLE) &&		\
+				(BbpCsr.field.RegNum == _bbpID)) {	\
+				*(_pV) = (u8)BbpCsr.field.Value;	\
+				break;					\
+			}						\
+		}							\
+		if (BbpCsr.field.Busy == BUSY) {			\
+			DBGPRINT_ERR(("BBP(viaMCU=%d) read R%d fail\n", (_bViaMCU), _bbpID));	\
 			*(_pV) = (_pAd)->BbpWriteLatch[_bbpID];               \
-			if ((_bViaMCU) == TRUE)				\
-			{									\
+			if ((_bViaMCU) == TRUE) {			\
 				RTMP_IO_READ32(_pAd, _regID, &BbpCsr.word);				\
 				BbpCsr.field.Busy = 0;                          \
 				RTMP_IO_WRITE32(_pAd, _regID, BbpCsr.word);				\
 			}				\
 		}													\
-	}while(0)
+	} while (0)
 
 /*
 	This marco used for the BBP read operation which didn't need via MCU.
@@ -283,42 +275,35 @@
 	int					i, k;			\
 	BOOLEAN					brc;			\
 	BbpCsr.field.Busy = IDLE;			\
-	if ((IS_RT3090((_A)) || IS_RT3572((_A)) || IS_RT3390((_A))) && ((_A)->StaCfg.PSControl.field.rt30xxPowerMode == 3)	\
+	if ((IS_RT3090((_A)) || IS_RT3572((_A)) || IS_RT3390((_A)))  \
+		&& ((_A)->StaCfg.PSControl.field.rt30xxPowerMode == 3)	\
 		&& ((_A)->StaCfg.PSControl.field.EnableNewPS == TRUE)	\
 		&& ((_A)->bPCIclkOff == FALSE)	\
-		&& ((_A)->brt30xxBanMcuCmd == FALSE))	\
-	{																	\
-		for (i=0; i<MAX_BUSY_COUNT; i++)									\
-		{																	\
-			RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word);				\
-			if (BbpCsr.field.Busy == BUSY)									\
-			{																\
-				continue;													\
-			}																\
-			BbpCsr.word = 0;												\
-			BbpCsr.field.fRead = 1;											\
-			BbpCsr.field.BBP_RW_MODE = 1;									\
-			BbpCsr.field.Busy = 1;											\
-			BbpCsr.field.RegNum = _I;										\
-			RTMP_IO_WRITE32(_A, H2M_BBP_AGENT, BbpCsr.word);				\
-			brc = AsicSendCommandToMcu(_A, 0x80, 0xff, 0x0, 0x0);					\
-			if (brc == TRUE)																\
-			{																\
-				for (k=0; k<MAX_BUSY_COUNT; k++)								\
-				{																\
-					RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word);			\
-					if (BbpCsr.field.Busy == IDLE)								\
-						break;													\
-				}																\
-				if ((BbpCsr.field.Busy == IDLE) &&								\
-					(BbpCsr.field.RegNum == _I))								\
-				{																\
-					*(_pV) = (u8)BbpCsr.field.Value;							\
-					break;														\
-				}																\
-			}																\
-			else																\
-			{																\
+		&& ((_A)->brt30xxBanMcuCmd == FALSE)) {			\
+		for (i = 0; i < MAX_BUSY_COUNT; i++) {			\
+			RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word); \
+			if (BbpCsr.field.Busy == BUSY) {		\
+				continue;				\
+			}						\
+			BbpCsr.word = 0;				\
+			BbpCsr.field.fRead = 1;				\
+			BbpCsr.field.BBP_RW_MODE = 1;			\
+			BbpCsr.field.Busy = 1;				\
+			BbpCsr.field.RegNum = _I;			\
+			RTMP_IO_WRITE32(_A, H2M_BBP_AGENT, BbpCsr.word); \
+			brc = AsicSendCommandToMcu(_A, 0x80, 0xff, 0x0, 0x0); \
+			if (brc == TRUE) {				\
+				for (k = 0; k < MAX_BUSY_COUNT; k++) {	\
+					RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word); \
+					if (BbpCsr.field.Busy == IDLE)	\
+						break;			\
+				}					\
+				if ((BbpCsr.field.Busy == IDLE) &&	\
+					(BbpCsr.field.RegNum == _I)) {	\
+					*(_pV) = (u8)BbpCsr.field.Value; \
+					break;				\
+				}					\
+			} else {					\
 				BbpCsr.field.Busy = 0;											\
 				RTMP_IO_WRITE32(_A, H2M_BBP_AGENT, BbpCsr.word);				\
 			}																\
@@ -326,46 +311,38 @@
 	}	\
 	else if (!((IS_RT3090((_A)) || IS_RT3572((_A)) || IS_RT3390((_A))) && ((_A)->StaCfg.PSControl.field.rt30xxPowerMode == 3)	\
 		&& ((_A)->StaCfg.PSControl.field.EnableNewPS == TRUE))	\
-		&& ((_A)->bPCIclkOff == FALSE))	\
-	{																	\
-		for (i=0; i<MAX_BUSY_COUNT; i++)									\
-		{																	\
-			RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word);				\
-			if (BbpCsr.field.Busy == BUSY)									\
-			{																\
-				continue;													\
-			}																\
-			BbpCsr.word = 0;												\
-			BbpCsr.field.fRead = 1;											\
-			BbpCsr.field.BBP_RW_MODE = 1;									\
-			BbpCsr.field.Busy = 1;											\
-			BbpCsr.field.RegNum = _I;										\
-			RTMP_IO_WRITE32(_A, H2M_BBP_AGENT, BbpCsr.word);				\
-			AsicSendCommandToMcu(_A, 0x80, 0xff, 0x0, 0x0);					\
-			for (k=0; k<MAX_BUSY_COUNT; k++)								\
-			{																\
-				RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word);			\
-				if (BbpCsr.field.Busy == IDLE)								\
-					break;													\
-			}																\
-			if ((BbpCsr.field.Busy == IDLE) &&								\
-				(BbpCsr.field.RegNum == _I))								\
-			{																\
-				*(_pV) = (u8)BbpCsr.field.Value;							\
-				break;														\
-			}																\
-		}																	\
-	}																	\
-	else										\
-	{																	\
+		&& ((_A)->bPCIclkOff == FALSE)) {			\
+		for (i = 0; i < MAX_BUSY_COUNT; i++) {			\
+			RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word); \
+			if (BbpCsr.field.Busy == BUSY) {		\
+				continue;				\
+			}						\
+			BbpCsr.word = 0;				\
+			BbpCsr.field.fRead = 1;				\
+			BbpCsr.field.BBP_RW_MODE = 1;			\
+			BbpCsr.field.Busy = 1;				\
+			BbpCsr.field.RegNum = _I;			\
+			RTMP_IO_WRITE32(_A, H2M_BBP_AGENT, BbpCsr.word); \
+			AsicSendCommandToMcu(_A, 0x80, 0xff, 0x0, 0x0);	\
+			for (k = 0; k < MAX_BUSY_COUNT; k++) {		\
+				RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word); \
+				if (BbpCsr.field.Busy == IDLE)		\
+					break;				\
+			}						\
+			if ((BbpCsr.field.Busy == IDLE) &&		\
+				(BbpCsr.field.RegNum == _I)) {		\
+				*(_pV) = (u8)BbpCsr.field.Value;	\
+				break;					\
+			}						\
+		}							\
+	} else {							\
 		DBGPRINT_ERR((" , brt30xxBanMcuCmd = %d, Read BBP %d \n", (_A)->brt30xxBanMcuCmd, (_I)));	\
-		*(_pV) = (_A)->BbpWriteLatch[_I];								\
-	}																	\
-	if ((BbpCsr.field.Busy == BUSY) || ((_A)->bPCIclkOff == TRUE))										\
-	{																	\
-		DBGPRINT_ERR(("BBP read R%d=0x%x fail\n", _I, BbpCsr.word));	\
-		*(_pV) = (_A)->BbpWriteLatch[_I];								\
-	}																	\
+		*(_pV) = (_A)->BbpWriteLatch[_I];			\
+	}								\
+	if ((BbpCsr.field.Busy == BUSY) || ((_A)->bPCIclkOff == TRUE)) { \
+		DBGPRINT_ERR(("BBP read R%d=0x%x fail\n", _I, BbpCsr.word)); \
+		*(_pV) = (_A)->BbpWriteLatch[_I];			\
+	}								\
 }
 
 /*
@@ -376,43 +353,39 @@
 	_bViaMCU: if we need access the bbp via the MCU.
 */
 #define RTMP_BBP_IO_WRITE8(_pAd, _bbpID, _pV, _bViaMCU)			\
-	do{															\
+	do {								\
 		BBP_CSR_CFG_STRUC  BbpCsr;                             \
-		int             _busyCnt, _regID;							\
-																\
+		int             _busyCnt, _regID;			\
+									\
 		_regID = ((_bViaMCU) == TRUE ? H2M_BBP_AGENT : BBP_CSR_CFG);	\
-		for (_busyCnt=0; _busyCnt<MAX_BUSY_COUNT; _busyCnt++)  \
-		{                                                   \
+		for (_busyCnt = 0; _busyCnt < MAX_BUSY_COUNT; _busyCnt++) { \
 			RTMP_IO_READ32((_pAd), BBP_CSR_CFG, &BbpCsr.word);     \
-			if (BbpCsr.field.Busy == BUSY)                  \
-				continue;                                   \
-			BbpCsr.word = 0;                                \
-			BbpCsr.field.fRead = 0;                         \
-			BbpCsr.field.BBP_RW_MODE = 1;                         \
-			BbpCsr.field.Busy = 1;                          \
-			BbpCsr.field.Value = _pV;                        \
-			BbpCsr.field.RegNum = _bbpID;                       \
-			RTMP_IO_WRITE32((_pAd), BBP_CSR_CFG, BbpCsr.word);     \
-			if ((_bViaMCU) == TRUE)									\
-			{														\
-				AsicSendCommandToMcu(_pAd, 0x80, 0xff, 0x0, 0x0);		\
-				if ((_pAd)->OpMode == OPMODE_AP)						\
-					RTMPusecDelay(1000);							\
-			}														\
-			(_pAd)->BbpWriteLatch[_bbpID] = _pV;					\
-			break;													\
-		}														\
-		if (_busyCnt == MAX_BUSY_COUNT)								\
-		{														\
-			DBGPRINT_ERR(("BBP write R%d fail\n", _bbpID));				\
-			if((_bViaMCU) == TRUE)									\
-			{														\
+			if (BbpCsr.field.Busy == BUSY)			\
+				continue;				\
+			BbpCsr.word = 0;				\
+			BbpCsr.field.fRead = 0;				\
+			BbpCsr.field.BBP_RW_MODE = 1;			\
+			BbpCsr.field.Busy = 1;				\
+			BbpCsr.field.Value = _pV;			\
+			BbpCsr.field.RegNum = _bbpID;			\
+			RTMP_IO_WRITE32((_pAd), BBP_CSR_CFG, BbpCsr.word); \
+			if ((_bViaMCU) == TRUE) {			\
+				AsicSendCommandToMcu(_pAd, 0x80, 0xff, 0x0, 0x0); \
+				if ((_pAd)->OpMode == OPMODE_AP)	\
+					RTMPusecDelay(1000);		\
+			}						\
+			(_pAd)->BbpWriteLatch[_bbpID] = _pV;		\
+			break;						\
+		}							\
+		if (_busyCnt == MAX_BUSY_COUNT) {			\
+			DBGPRINT_ERR(("BBP write R%d fail\n", _bbpID));	\
+			if ((_bViaMCU) == TRUE) {			\
 				RTMP_IO_READ32(_pAd, H2M_BBP_AGENT, &BbpCsr.word);	\
-				BbpCsr.field.Busy = 0;									\
+				BbpCsr.field.Busy = 0;			\
 				RTMP_IO_WRITE32(_pAd, H2M_BBP_AGENT, BbpCsr.word);	\
-			}														\
-		}														\
-	}while(0)
+			}						\
+		}							\
+	} while (0)
 
 /*
 	This marco used for the BBP write operation which didn't need via MCU.
@@ -426,25 +399,22 @@
 	will use this function too and didn't access the bbp register via the MCU.
 */
 /* Write BBP register by register's ID & value */
-#define RTMP_BBP_IO_WRITE8_BY_REG_ID(_A, _I, _V)						\
-{																		\
-	BBP_CSR_CFG_STRUC	BbpCsr;											\
-	int					BusyCnt = 0;										\
+#define RTMP_BBP_IO_WRITE8_BY_REG_ID(_A, _I, _V)			\
+{									\
+	BBP_CSR_CFG_STRUC	BbpCsr;					\
+	int					BusyCnt = 0;		\
 	BOOLEAN					brc;			\
-	if (_I < MAX_NUM_OF_BBP_LATCH)										\
-	{																	\
-		if ((IS_RT3090((_A)) || IS_RT3572((_A)) || IS_RT3390((_A))) && ((_A)->StaCfg.PSControl.field.rt30xxPowerMode == 3)	\
+	if (_I < MAX_NUM_OF_BBP_LATCH) {				\
+		if ((IS_RT3090((_A)) || IS_RT3572((_A)) || IS_RT3390((_A))) \
+			&& ((_A)->StaCfg.PSControl.field.rt30xxPowerMode == 3)	\
 			&& ((_A)->StaCfg.PSControl.field.EnableNewPS == TRUE)	\
 			&& ((_A)->bPCIclkOff == FALSE)	\
-			&& ((_A)->brt30xxBanMcuCmd == FALSE))	\
-		{																	\
-			if (_A->AccessBBPFailCount > 20)									\
-			{																	\
-				AsicResetBBPAgent(_A);				\
-				_A->AccessBBPFailCount = 0;											\
-			}																	\
-			for (BusyCnt=0; BusyCnt<MAX_BUSY_COUNT; BusyCnt++)					\
-			{																	\
+			&& ((_A)->brt30xxBanMcuCmd == FALSE)) {		\
+			if (_A->AccessBBPFailCount > 20) {		\
+				AsicResetBBPAgent(_A);			\
+				_A->AccessBBPFailCount = 0;		\
+			}						\
+			for (BusyCnt = 0; BusyCnt < MAX_BUSY_COUNT; BusyCnt++) { \
 				RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word);				\
 				if (BbpCsr.field.Busy == BUSY)									\
 					continue;													\
@@ -456,29 +426,24 @@
 				BbpCsr.field.RegNum = _I;										\
 				RTMP_IO_WRITE32(_A, H2M_BBP_AGENT, BbpCsr.word);				\
 				brc = AsicSendCommandToMcu(_A, 0x80, 0xff, 0x0, 0x0);					\
-				if (brc == TRUE)																\
-				{																\
+				if (brc == TRUE) {			\
 					(_A)->BbpWriteLatch[_I] = _V;									\
-				}																\
-				else																\
-				{																\
+				} else {				\
 					BbpCsr.field.Busy = 0;											\
 					RTMP_IO_WRITE32(_A, H2M_BBP_AGENT, BbpCsr.word);				\
 				}																\
 				break;															\
 			}																	\
 		}																	\
-		else if (!((IS_RT3090((_A)) || IS_RT3572((_A)) || IS_RT3390((_A))) && ((_A)->StaCfg.PSControl.field.rt30xxPowerMode == 3)	\
+		else if (!((IS_RT3090((_A)) || IS_RT3572((_A)) || IS_RT3390((_A))) \
+			&& ((_A)->StaCfg.PSControl.field.rt30xxPowerMode == 3)	\
 			&& ((_A)->StaCfg.PSControl.field.EnableNewPS == TRUE))	\
-			&& ((_A)->bPCIclkOff == FALSE))	\
-		{																	\
-			if (_A->AccessBBPFailCount > 20)									\
-			{																	\
-				AsicResetBBPAgent(_A);				\
-				_A->AccessBBPFailCount = 0;											\
-			}																	\
-			for (BusyCnt=0; BusyCnt<MAX_BUSY_COUNT; BusyCnt++)					\
-			{																	\
+			&& ((_A)->bPCIclkOff == FALSE)) { 		\
+			if (_A->AccessBBPFailCount > 20) {		\
+				AsicResetBBPAgent(_A);			\
+				_A->AccessBBPFailCount = 0;		\
+			}						\
+			for (BusyCnt = 0; BusyCnt < MAX_BUSY_COUNT; BusyCnt++) { \
 				RTMP_IO_READ32(_A, H2M_BBP_AGENT, &BbpCsr.word);				\
 				if (BbpCsr.field.Busy == BUSY)									\
 					continue;													\
@@ -493,20 +458,15 @@
 				(_A)->BbpWriteLatch[_I] = _V;									\
 				break;															\
 			}																	\
-		}																	\
-		else										\
-		{																	\
+		} else {						\
 			DBGPRINT_ERR(("  brt30xxBanMcuCmd = %d. Write BBP %d \n",  (_A)->brt30xxBanMcuCmd, (_I)));	\
 		}																	\
-		if ((BusyCnt == MAX_BUSY_COUNT) || ((_A)->bPCIclkOff == TRUE))			\
-		{																	\
-			if (BusyCnt == MAX_BUSY_COUNT)					\
+		if ((BusyCnt == MAX_BUSY_COUNT) || ((_A)->bPCIclkOff == TRUE)) { \
+			if (BusyCnt == MAX_BUSY_COUNT)				\
 				(_A)->AccessBBPFailCount++;					\
-			DBGPRINT_ERR(("BBP write R%d=0x%x fail. BusyCnt= %d.bPCIclkOff = %d. \n", _I, BbpCsr.word, BusyCnt, (_A)->bPCIclkOff ));	\
+			DBGPRINT_ERR(("BBP write R%d=0x%x fail. BusyCnt= %d.bPCIclkOff = %d. \n", _I, BbpCsr.word, BusyCnt, (_A)->bPCIclkOff));	\
 		}																	\
-	}																		\
-	else																		\
-	{																		\
+	} else {							\
 		DBGPRINT_ERR(("****** BBP_Write_Latch Buffer exceeds max boundry ****** \n"));	\
 	}																		\
 }
@@ -522,7 +482,7 @@
 
 #ifdef RT30xx
 #define RTMP_ASIC_MMPS_DISABLE(_pAd)							\
-	do{															\
+	do {															\
 		u32 _macData; \
 		u8 _bbpData = 0; \
 		/* disable MMPS BBP control register */						\
@@ -534,10 +494,10 @@
 		RTMP_IO_READ32(_pAd, 0x1210, &_macData);				\
 		_macData &= ~(0x09);	/*bit 0, 3*/							\
 		RTMP_IO_WRITE32(_pAd, 0x1210, _macData);				\
-	}while(0)
+	} while (0)
 
 #define RTMP_ASIC_MMPS_ENABLE(_pAd)							\
-	do{															\
+	do {															\
 		u32 _macData; \
 		u8 _bbpData = 0; \
 		/* enable MMPS BBP control register */						\
@@ -549,7 +509,7 @@
 		RTMP_IO_READ32(_pAd, 0x1210, &_macData);				\
 		_macData |= (0x09);	/*bit 0, 3*/							\
 		RTMP_IO_WRITE32(_pAd, 0x1210, _macData);				\
-	}while(0)
+	} while (0)
 
 #endif /* RT30xx // */
 
-- 
1.7.0.3

