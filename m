Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0DTAGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 20:06:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51446 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0DTAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 20:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xQ9pPv2tp5OiZP2rpy5aDhiXrGfghVMqOFKj80WCOctI5iNvfIFS4QGsF2rpIaZGyS
         +S2Red5PgaEvbqL+RAze8W/oqk9bx9RQ1MdrK7tecHMQaU+a2rPd8j3epA7pRAEmx78z
         Yrf4eowp1fQQ0SxM+Utk/ULmf/qTVCb/6k7jI=
From: Niadh <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Niadh <neilmunro@gmail.com>
Subject: [PATCH] Staging: rt2860/rtmp.h: Fixed all bar one error.
Date: Tue, 20 Apr 2010 01:06:33 +0100
Message-Id: <1271721993-22299-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All simple errors have been removed, including +80 line character limits and various pointer syntax isues.

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/rtmp.h |  414 ++++++++++++++++++++---------------------
 1 files changed, 199 insertions(+), 215 deletions(-)

diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 4401a55..2342174 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -181,8 +181,7 @@ struct rt_queue_header {
 (QueueHeader)->Head;                                \
 {                                                   \
 	struct rt_queue_entry *pNext;                             \
-	if ((QueueHeader)->Head != NULL)				\
-	{												\
+	if ((QueueHeader)->Head != NULL) {				\
 		pNext = (QueueHeader)->Head->Next;          \
 		(QueueHeader)->Head->Next = NULL;		\
 		(QueueHeader)->Head = pNext;                \
@@ -242,9 +241,9 @@ struct rt_queue_header {
 #define OPSTATUS_CLEAR_FLAG(_pAd, _F)   ((_pAd)->CommonCfg.OpStatusFlags &= ~(_F))
 #define OPSTATUS_TEST_FLAG(_pAd, _F)    (((_pAd)->CommonCfg.OpStatusFlags & (_F)) != 0)
 
-#define CLIENT_STATUS_SET_FLAG(_pEntry,_F)      ((_pEntry)->ClientStatusFlags |= (_F))
-#define CLIENT_STATUS_CLEAR_FLAG(_pEntry,_F)    ((_pEntry)->ClientStatusFlags &= ~(_F))
-#define CLIENT_STATUS_TEST_FLAG(_pEntry,_F)     (((_pEntry)->ClientStatusFlags & (_F)) != 0)
+#define CLIENT_STATUS_SET_FLAG(_pEntry, _F)      ((_pEntry)->ClientStatusFlags |= (_F))
+#define CLIENT_STATUS_CLEAR_FLAG(_pEntry, _F)    ((_pEntry)->ClientStatusFlags &= ~(_F))
+#define CLIENT_STATUS_TEST_FLAG(_pEntry, _F)     (((_pEntry)->ClientStatusFlags & (_F)) != 0)
 
 #define RX_FILTER_SET_FLAG(_pAd, _F)    ((_pAd)->CommonCfg.PacketFilter |= (_F))
 #define RX_FILTER_CLEAR_FLAG(_pAd, _F)  ((_pAd)->CommonCfg.PacketFilter &= ~(_F))
@@ -279,13 +278,13 @@ struct rt_queue_header {
 	_pAd->StaActive.SupportedHtPhy.RecomWidth = _pAd->MlmeAux.AddHtInfo.AddHtInfo.RecomWidth;      \
 	_pAd->StaActive.SupportedHtPhy.OperaionMode = _pAd->MlmeAux.AddHtInfo.AddHtInfo2.OperaionMode;      \
 	_pAd->StaActive.SupportedHtPhy.NonGfPresent = _pAd->MlmeAux.AddHtInfo.AddHtInfo2.NonGfPresent;      \
-	NdisMoveMemory((_pAd)->MacTab.Content[BSSID_WCID].HTCapability.MCSSet, (_pAd)->StaActive.SupportedPhyInfo.MCSSet, sizeof(u8)* 16);\
+	NdisMoveMemory((_pAd)->MacTab.Content[BSSID_WCID].HTCapability.MCSSet, (_pAd)->StaActive.SupportedPhyInfo.MCSSet, sizeof(u8) * 16);\
 }
 
 #define COPY_AP_HTSETTINGS_FROM_BEACON(_pAd, _pHtCapability)                                 \
 {                                                                                       \
 	_pAd->MacTab.Content[BSSID_WCID].AMsduSize = (u8)(_pHtCapability->HtCapInfo.AMsduSize);	\
-	_pAd->MacTab.Content[BSSID_WCID].MmpsMode= (u8)(_pHtCapability->HtCapInfo.MimoPs);	\
+	_pAd->MacTab.Content[BSSID_WCID].MmpsMode = (u8)(_pHtCapability->HtCapInfo.MimoPs);	\
 	_pAd->MacTab.Content[BSSID_WCID].MaxRAmpduFactor = (u8)(_pHtCapability->HtCapParm.MaxRAmpduFactor);	\
 }
 
@@ -349,17 +348,14 @@ struct rt_rtmp_sg_list {
 /* if orginal Ethernet frame contains no LLC/SNAP, then an extra LLC/SNAP encap is required */
 #define EXTRA_LLCSNAP_ENCAP_FROM_PKT_START(_pBufVA, _pExtraLlcSnapEncap)		\
 {																\
-	if (((*(_pBufVA + 12) << 8) + *(_pBufVA + 13)) > 1500)		\
-	{															\
+	if (((*(_pBufVA + 12) << 8) + *(_pBufVA + 13)) > 1500) {	\
 		_pExtraLlcSnapEncap = SNAP_802_1H;						\
 		if (NdisEqualMemory(IPX, _pBufVA + 12, 2) || 			\
-			NdisEqualMemory(APPLE_TALK, _pBufVA + 12, 2))		\
-		{														\
+			NdisEqualMemory(APPLE_TALK, _pBufVA + 12, 2)) {	\
 			_pExtraLlcSnapEncap = SNAP_BRIDGE_TUNNEL;			\
 		}														\
 	}															\
-	else														\
-	{															\
+	else {				\
 		_pExtraLlcSnapEncap = NULL;								\
 	}															\
 }
@@ -367,17 +363,14 @@ struct rt_rtmp_sg_list {
 /* New Define for new Tx Path. */
 #define EXTRA_LLCSNAP_ENCAP_FROM_PKT_OFFSET(_pBufVA, _pExtraLlcSnapEncap)	\
 {																\
-	if (((*(_pBufVA) << 8) + *(_pBufVA + 1)) > 1500)			\
-	{															\
+	if (((*(_pBufVA) << 8) + *(_pBufVA + 1)) > 1500) {		\
 		_pExtraLlcSnapEncap = SNAP_802_1H;						\
 		if (NdisEqualMemory(IPX, _pBufVA, 2) || 				\
-			NdisEqualMemory(APPLE_TALK, _pBufVA, 2))			\
-		{														\
+			NdisEqualMemory(APPLE_TALK, _pBufVA, 2)) {		\
 			_pExtraLlcSnapEncap = SNAP_BRIDGE_TUNNEL;			\
 		}														\
 	}															\
-	else														\
-	{															\
+	else {		\
 		_pExtraLlcSnapEncap = NULL;								\
 	}															\
 }
@@ -399,33 +392,29 @@ struct rt_rtmp_sg_list {
 #define CONVERT_TO_802_3(_p8023hdr, _pDA, _pSA, _pData, _DataSize, _pRemovedLLCSNAP)      \
 {                                                                       \
     char LLC_Len[2];                                                    \
-                                                                        \
+									\
     _pRemovedLLCSNAP = NULL;                                            \
     if (NdisEqualMemory(SNAP_802_1H, _pData, 6)  ||                     \
-        NdisEqualMemory(SNAP_BRIDGE_TUNNEL, _pData, 6))                 \
-    {                                                                   \
-        u8 *pProto = _pData + 6;                                     \
-                                                                        \
-        if ((NdisEqualMemory(IPX, pProto, 2) || NdisEqualMemory(APPLE_TALK, pProto, 2)) &&  \
-            NdisEqualMemory(SNAP_802_1H, _pData, 6))                    \
-        {                                                               \
-            LLC_Len[0] = (u8)(_DataSize / 256);                      \
-            LLC_Len[1] = (u8)(_DataSize % 256);                      \
-            MAKE_802_3_HEADER(_p8023hdr, _pDA, _pSA, LLC_Len);          \
-        }                                                               \
-        else                                                            \
-        {                                                               \
-            MAKE_802_3_HEADER(_p8023hdr, _pDA, _pSA, pProto);           \
-            _pRemovedLLCSNAP = _pData;                                  \
-            _DataSize -= LENGTH_802_1_H;                                \
-            _pData += LENGTH_802_1_H;                                   \
-        }                                                               \
+	NdisEqualMemory(SNAP_BRIDGE_TUNNEL, _pData, 6))	{		\
+	u8 *pProto = _pData + 6;					\
+									\
+	if ((NdisEqualMemory(IPX, pProto, 2) || NdisEqualMemory(APPLE_TALK, pProto, 2)) &&  \
+		NdisEqualMemory(SNAP_802_1H, _pData, 6))	{	\
+		LLC_Len[0] = (u8)(_DataSize / 256);			\
+		LLC_Len[1] = (u8)(_DataSize % 256);			\
+		MAKE_802_3_HEADER(_p8023hdr, _pDA, _pSA, LLC_Len);	\
+	}								\
+	else	{							\
+		MAKE_802_3_HEADER(_p8023hdr, _pDA, _pSA, pProto);	\
+		_pRemovedLLCSNAP = _pData;				\
+		_DataSize -= LENGTH_802_1_H;				\
+		_pData += LENGTH_802_1_H;				\
+	}								\
     }                                                                   \
-    else                                                                \
-    {                                                                   \
-        LLC_Len[0] = (u8)(_DataSize / 256);                          \
-        LLC_Len[1] = (u8)(_DataSize % 256);                          \
-        MAKE_802_3_HEADER(_p8023hdr, _pDA, _pSA, LLC_Len);              \
+	else	{							\
+	LLC_Len[0] = (u8)(_DataSize / 256);				\
+	LLC_Len[1] = (u8)(_DataSize % 256);				\
+	MAKE_802_3_HEADER(_p8023hdr, _pDA, _pSA, LLC_Len);		\
     }                                                                   \
 }
 
@@ -438,19 +427,19 @@ struct rt_rtmp_sg_list {
     u32 High32TSF, Low32TSF;                                                          \
     RTMP_IO_READ32(_pAd, TSF_TIMER_DW1, &High32TSF);                                       \
     RTMP_IO_READ32(_pAd, TSF_TIMER_DW0, &Low32TSF);                                        \
-    MlmeEnqueueForRecv(_pAd, Wcid, High32TSF, Low32TSF, (u8)_Rssi0, (u8)_Rssi1,(u8)_Rssi2,_FrameSize, _pFrame, (u8)_PlcpSignal);   \
+    MlmeEnqueueForRecv(_pAd, Wcid, High32TSF, Low32TSF, (u8)_Rssi0, (u8)_Rssi1, (u8)_Rssi2, _FrameSize, _pFrame, (u8)_PlcpSignal);   \
 }
 #endif /* RTMP_MAC_PCI // */
 #ifdef RTMP_MAC_USB
 #define REPORT_MGMT_FRAME_TO_MLME(_pAd, Wcid, _pFrame, _FrameSize, _Rssi0, _Rssi1, _Rssi2, _PlcpSignal)        \
 {                                                                                       \
-    u32 High32TSF=0, Low32TSF=0;                                                          \
-    MlmeEnqueueForRecv(_pAd, Wcid, High32TSF, Low32TSF, (u8)_Rssi0, (u8)_Rssi1,(u8)_Rssi2,_FrameSize, _pFrame, (u8)_PlcpSignal);   \
+    u32 High32TSF = 0, Low32TSF = 0;                                                          \
+    MlmeEnqueueForRecv(_pAd, Wcid, High32TSF, Low32TSF, (u8)_Rssi0, (u8)_Rssi1, (u8)_Rssi2, _FrameSize, _pFrame, (u8)_PlcpSignal);   \
 }
 #endif /* RTMP_MAC_USB // */
 
-#define MAC_ADDR_EQUAL(pAddr1,pAddr2)           RTMPEqualMemory((void *)(pAddr1), (void *)(pAddr2), MAC_ADDR_LEN)
-#define SSID_EQUAL(ssid1, len1, ssid2, len2)    ((len1==len2) && (RTMPEqualMemory(ssid1, ssid2, len1)))
+#define MAC_ADDR_EQUAL(pAddr1, pAddr2)           RTMPEqualMemory((void *)(pAddr1), (void *)(pAddr2), MAC_ADDR_LEN)
+#define SSID_EQUAL(ssid1, len1, ssid2, len2)    ((len1 == len2) && (RTMPEqualMemory(ssid1, ssid2, len1)))
 
 /* */
 /* Check if it is Japan W53(ch52,56,60,64) channel. */
@@ -1054,7 +1043,7 @@ typedef union _BACAP_STRUC {
 		u32 MMPSmode:2;	/* MIMO power save more, 0:static, 1:dynamic, 2:rsv, 3:mimo enable */
 		u32 bHtAdhoc:1;	/* adhoc can use ht rate. */
 		u32 b2040CoexistScanSup:1;	/*As Sta, support do 2040 coexistence scan for AP. As Ap, support monitor trigger event to check if can use BW 40MHz. */
-		u32 : 4;
+		u32: 4;
 	} field;
 	u32 word;
 } BACAP_STRUC, *PBACAP_STRUC;
@@ -1334,7 +1323,7 @@ struct rt_common_config {
 
 	BOOLEAN PSPXlink;	/* 0: Disable. 1: Enable */
 
-#if defined(RT305x)||defined(RT30xx)
+#if defined(RT305x) || defined(RT30xx)
 	/* request by Gary, for High Power issue */
 	u8 HighPowerPatchDisabled;
 #endif
@@ -2169,8 +2158,8 @@ struct rt_rtmp_adapter {
   **************************************************************************/
 struct rt_rx_blk {
 	RT28XX_RXD_STRUC RxD;
-	struct rt_rxwi * pRxWI;
-	struct rt_header_802_11 * pHeader;
+	struct rt_rxwi *pRxWI;
+	struct rt_header_802_11 *pHeader;
 	void *pRxPacket;
 	u8 *pData;
 	u16 DataSize;
@@ -2268,7 +2257,7 @@ struct rt_tx_blk {
   *	Other static inline function definitions
   **************************************************************************/
 static inline void ConvertMulticastIP2MAC(u8 *pIpAddr,
-					  u8 ** ppMacAddr,
+					  u8 **ppMacAddr,
 					  u16 ProtoType)
 {
 	if (pIpAddr == NULL)
@@ -2310,7 +2299,7 @@ char *GetBW(int BW);
 /*  Private routines in rtmp_init.c */
 /* */
 int RTMPAllocAdapterBlock(void *handle,
-				  struct rt_rtmp_adapter * * ppAdapter);
+				  struct rt_rtmp_adapter **ppAdapter);
 
 int RTMPAllocTxRxRingMemory(struct rt_rtmp_adapter *pAd);
 
@@ -2431,11 +2420,11 @@ void ORIBATimerTimeout(struct rt_rtmp_adapter *pAd);
 void SendRefreshBAR(struct rt_rtmp_adapter *pAd, struct rt_mac_table_entry *pEntry);
 
 void ActHeaderInit(struct rt_rtmp_adapter *pAd,
-		   struct rt_header_802_11 * pHdr80211,
+		   struct rt_header_802_11 *pHdr80211,
 		   u8 *Addr1, u8 *Addr2, u8 *Addr3);
 
 void BarHeaderInit(struct rt_rtmp_adapter *pAd,
-		   struct rt_frame_bar * pCntlBar, u8 *pDA, u8 *pSA);
+		   struct rt_frame_bar *pCntlBar, u8 *pDA, u8 *pSA);
 
 void InsertActField(struct rt_rtmp_adapter *pAd,
 		    u8 *pFrameBuf,
@@ -2443,7 +2432,7 @@ void InsertActField(struct rt_rtmp_adapter *pAd,
 
 BOOLEAN CntlEnqueueForRecv(struct rt_rtmp_adapter *pAd,
 			   unsigned long Wcid,
-			   unsigned long MsgLen, struct rt_frame_ba_req * pMsg);
+			   unsigned long MsgLen, struct rt_frame_ba_req *pMsg);
 
 /* */
 /* Private routines in rtmp_data.c */
@@ -2511,7 +2500,7 @@ int MlmeDataHardTransmit(struct rt_rtmp_adapter *pAd,
 				 u8 QueIdx, void *pPacket);
 
 void RTMPWriteTxDescriptor(struct rt_rtmp_adapter *pAd,
-			   struct rt_txd * pTxD, IN BOOLEAN bWIV, u8 QSEL);
+			   struct rt_txd *pTxD, IN BOOLEAN bWIV, u8 QSEL);
 #endif /* RTMP_MAC_PCI // */
 
 u16 RTMPCalcDuration(struct rt_rtmp_adapter *pAd, u8 Rate, unsigned long Size);
@@ -2524,13 +2513,13 @@ void RTMPWriteTxWI(struct rt_rtmp_adapter *pAd, struct rt_txwi * pTxWI, IN BOOLE
 		   u8 TID,
 		   u8 TxRate,
 		   u8 Txopmode,
-		   IN BOOLEAN CfAck, IN HTTRANSMIT_SETTING * pTransmit);
+		   IN BOOLEAN CfAck, IN HTTRANSMIT_SETTING * pTransmit);
 
 void RTMPWriteTxWI_Data(struct rt_rtmp_adapter *pAd,
-			struct rt_txwi * pTxWI, struct rt_tx_blk *pTxBlk);
+			struct rt_txwi *pTxWI, struct rt_tx_blk *pTxBlk);
 
 void RTMPWriteTxWI_Cache(struct rt_rtmp_adapter *pAd,
-			 struct rt_txwi * pTxWI, struct rt_tx_blk *pTxBlk);
+			 struct rt_txwi *pTxWI, struct rt_tx_blk *pTxBlk);
 
 void RTMPSuspendMsduTransmission(struct rt_rtmp_adapter *pAd);
 
@@ -2573,10 +2562,10 @@ void WpaStaGroupKeySetting(struct rt_rtmp_adapter *pAd);
 int RTMPCloneNdisPacket(struct rt_rtmp_adapter *pAd,
 				IN BOOLEAN pInsAMSDUHdr,
 				void *pInPacket,
-				void ** ppOutPacket);
+				void **ppOutPacket);
 
 int RTMPAllocateNdisPacket(struct rt_rtmp_adapter *pAd,
-				   void ** pPacket,
+				   void **pPacket,
 				   u8 *pHeader,
 				   u32 HeaderLen,
 				   u8 *pData, u32 DataLen);
@@ -2717,7 +2706,7 @@ BOOLEAN AsicCheckCommanOk(struct rt_rtmp_adapter *pAd, u8 Command);
 void MacAddrRandomBssid(struct rt_rtmp_adapter *pAd, u8 *pAddr);
 
 void MgtMacHeaderInit(struct rt_rtmp_adapter *pAd,
-		      struct rt_header_802_11 * pHdr80211,
+		      struct rt_header_802_11 *pHdr80211,
 		      u8 SubType,
 		      u8 ToDs, u8 *pDA, u8 *pBssid);
 
@@ -2796,7 +2785,7 @@ void MlmeQueueDestroy(struct rt_mlme_queue *Queue);
 
 BOOLEAN MlmeEnqueue(struct rt_rtmp_adapter *pAd,
 		    unsigned long Machine,
-		    unsigned long MsgType, unsigned long MsgLen, void * Msg);
+		    unsigned long MsgType, unsigned long MsgLen, void *Msg);
 
 BOOLEAN MlmeEnqueueForRecv(struct rt_rtmp_adapter *pAd,
 			   unsigned long Wcid,
@@ -2807,7 +2796,7 @@ BOOLEAN MlmeEnqueueForRecv(struct rt_rtmp_adapter *pAd,
 			   u8 Rssi2,
 			   unsigned long MsgLen, void *Msg, u8 Signal);
 
-BOOLEAN MlmeDequeue(struct rt_mlme_queue *Queue, struct rt_mlme_queue_elem ** Elem);
+BOOLEAN MlmeDequeue(struct rt_mlme_queue *Queue, struct rt_mlme_queue_elem **Elem);
 
 void MlmeRestartStateMachine(struct rt_rtmp_adapter *pAd);
 
@@ -2816,8 +2805,8 @@ BOOLEAN MlmeQueueEmpty(struct rt_mlme_queue *Queue);
 BOOLEAN MlmeQueueFull(struct rt_mlme_queue *Queue);
 
 BOOLEAN MsgTypeSubst(struct rt_rtmp_adapter *pAd,
-		     struct rt_frame_802_11 * pFrame,
-		     int * Machine, int * MsgType);
+		     struct rt_frame_802_11 *pFrame,
+		     int *Machine, int *MsgType);
 
 void StateMachineInit(struct rt_state_machine *Sm,
 		      IN STATE_MACHINE_FUNC Trans[],
@@ -2895,8 +2884,8 @@ void AssocPostProc(struct rt_rtmp_adapter *pAd,
 		   u8 ExtRate[],
 		   u8 ExtRateLen,
 		   struct rt_edca_parm *pEdcaParm,
-		   struct rt_ht_capability_ie * pHtCapability,
-		   u8 HtCapabilityLen, struct rt_add_ht_info_ie * pAddHtInfo);
+		   struct rt_ht_capability_ie *pHtCapability,
+		   u8 HtCapabilityLen, struct rt_add_ht_info_ie *pAddHtInfo);
 
 void AuthStateMachineInit(struct rt_rtmp_adapter *pAd,
 			  struct rt_state_machine *sm, OUT STATE_MACHINE_FUNC Trans[]);
@@ -2928,7 +2917,7 @@ void AuthRspStateMachineInit(struct rt_rtmp_adapter *pAd,
 void PeerDeauthAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *Elem);
 
 void PeerAuthSimpleRspGenAndSend(struct rt_rtmp_adapter *pAd,
-				 struct rt_header_802_11 * pHdr80211,
+				 struct rt_header_802_11 *pHdr80211,
 				 u16 Alg,
 				 u16 Seq,
 				 u16 Reason, u16 Status);
@@ -3054,133 +3043,133 @@ void ScanNextChannel(struct rt_rtmp_adapter *pAd);
 unsigned long MakeIbssBeacon(struct rt_rtmp_adapter *pAd);
 
 BOOLEAN MlmeScanReqSanity(struct rt_rtmp_adapter *pAd,
-			  void * Msg,
+			  void *Msg,
 			  unsigned long MsgLen,
-			  u8 * BssType,
+			  u8 *BssType,
 			  char ssid[],
-			  u8 * SsidLen, u8 * ScanType);
+			  u8 *SsidLen, u8 *ScanType);
 
 BOOLEAN PeerBeaconAndProbeRspSanity(struct rt_rtmp_adapter *pAd,
-				    void * Msg,
+				    void *Msg,
 				    unsigned long MsgLen,
 				    u8 MsgChannel,
 				    u8 *pAddr2,
 				    u8 *pBssid,
 				    char Ssid[],
-				    u8 * pSsidLen,
-				    u8 * pBssType,
-				    u16 * pBeaconPeriod,
-				    u8 * pChannel,
-				    u8 * pNewChannel,
-				    OUT LARGE_INTEGER * pTimestamp,
-				    struct rt_cf_parm * pCfParm,
-				    u16 * pAtimWin,
-				    u16 * pCapabilityInfo,
-				    u8 * pErp,
-				    u8 * pDtimCount,
-				    u8 * pDtimPeriod,
-				    u8 * pBcastFlag,
-				    u8 * pMessageToMe,
+				    u8 *pSsidLen,
+				    u8 *pBssType,
+				    u16 *pBeaconPeriod,
+				    u8 *pChannel,
+				    u8 *pNewChannel,
+				    OUT LARGE_INTEGER * pTimestamp,
+				    struct rt_cf_parm *pCfParm,
+				    u16 *pAtimWin,
+				    u16 *pCapabilityInfo,
+				    u8 *pErp,
+				    u8 *pDtimCount,
+				    u8 *pDtimPeriod,
+				    u8 *pBcastFlag,
+				    u8 *pMessageToMe,
 				    u8 SupRate[],
-				    u8 * pSupRateLen,
+				    u8 *pSupRateLen,
 				    u8 ExtRate[],
-				    u8 * pExtRateLen,
-				    u8 * pCkipFlag,
-				    u8 * pAironetCellPowerLimit,
+				    u8 *pExtRateLen,
+				    u8 *pCkipFlag,
+				    u8 *pAironetCellPowerLimit,
 				    struct rt_edca_parm *pEdcaParm,
 				    struct rt_qbss_load_parm *pQbssLoad,
 				    struct rt_qos_capability_parm *pQosCapability,
-				    unsigned long * pRalinkIe,
-				    u8 * pHtCapabilityLen,
-				    u8 * pPreNHtCapabilityLen,
-				    struct rt_ht_capability_ie * pHtCapability,
-				    u8 * AddHtInfoLen,
-				    struct rt_add_ht_info_ie * AddHtInfo,
-				    u8 * NewExtChannel,
-				    u16 * LengthVIE,
+				    unsigned long *pRalinkIe,
+				    u8 *pHtCapabilityLen,
+				    u8 *pPreNHtCapabilityLen,
+				    struct rt_ht_capability_ie *pHtCapability,
+				    u8 *AddHtInfoLen,
+				    struct rt_add_ht_info_ie *AddHtInfo,
+				    u8 *NewExtChannel,
+				    u16 *LengthVIE,
 				    struct rt_ndis_802_11_variable_ies *pVIE);
 
 BOOLEAN PeerAddBAReqActionSanity(struct rt_rtmp_adapter *pAd,
-				 void * pMsg,
+				 void *pMsg,
 				 unsigned long MsgLen, u8 *pAddr2);
 
 BOOLEAN PeerAddBARspActionSanity(struct rt_rtmp_adapter *pAd,
-				 void * pMsg, unsigned long MsgLen);
+				 void *pMsg, unsigned long MsgLen);
 
 BOOLEAN PeerDelBAActionSanity(struct rt_rtmp_adapter *pAd,
-			      u8 Wcid, void * pMsg, unsigned long MsgLen);
+			      u8 Wcid, void *pMsg, unsigned long MsgLen);
 
 BOOLEAN MlmeAssocReqSanity(struct rt_rtmp_adapter *pAd,
-			   void * Msg,
+			   void *Msg,
 			   unsigned long MsgLen,
 			   u8 *pApAddr,
-			   u16 * CapabilityInfo,
-			   unsigned long * Timeout, u16 * ListenIntv);
+			   u16 *CapabilityInfo,
+			   unsigned long *Timeout, u16 *ListenIntv);
 
 BOOLEAN MlmeAuthReqSanity(struct rt_rtmp_adapter *pAd,
-			  void * Msg,
+			  void *Msg,
 			  unsigned long MsgLen,
 			  u8 *pAddr,
-			  unsigned long * Timeout, u16 * Alg);
+			  unsigned long *Timeout, u16 *Alg);
 
 BOOLEAN MlmeStartReqSanity(struct rt_rtmp_adapter *pAd,
-			   void * Msg,
+			   void *Msg,
 			   unsigned long MsgLen,
-			   char Ssid[], u8 * Ssidlen);
+			   char Ssid[], u8 *Ssidlen);
 
 BOOLEAN PeerAuthSanity(struct rt_rtmp_adapter *pAd,
-		       void * Msg,
+		       void *Msg,
 		       unsigned long MsgLen,
 		       u8 *pAddr,
-		       u16 * Alg,
-		       u16 * Seq,
-		       u16 * Status, char ChlgText[]);
+		       u16 *Alg,
+		       u16 *Seq,
+		       u16 *Status, char ChlgText[]);
 
-BOOLEAN PeerAssocRspSanity(struct rt_rtmp_adapter *pAd, void * pMsg, unsigned long MsgLen, u8 *pAddr2, u16 * pCapabilityInfo, u16 * pStatus, u16 * pAid, u8 SupRate[], u8 * pSupRateLen, u8 ExtRate[], u8 * pExtRateLen, struct rt_ht_capability_ie * pHtCapability, struct rt_add_ht_info_ie * pAddHtInfo,	/* AP might use this additional ht info IE */
-			   u8 * pHtCapabilityLen,
-			   u8 * pAddHtInfoLen,
-			   u8 * pNewExtChannelOffset,
-			   struct rt_edca_parm *pEdcaParm, u8 * pCkipFlag);
+BOOLEAN PeerAssocRspSanity(struct rt_rtmp_adapter *pAd, void *pMsg, unsigned long MsgLen, u8 *pAddr2, u16 *pCapabilityInfo, u16 *pStatus, u16 *pAid, u8 SupRate[], u8 *pSupRateLen, u8 ExtRate[], u8 *pExtRateLen, struct rt_ht_capability_ie *pHtCapability, struct rt_add_ht_info_ie *pAddHtInfo,	/* AP might use this additional ht info IE */
+			   u8 *pHtCapabilityLen,
+			   u8 *pAddHtInfoLen,
+			   u8 *pNewExtChannelOffset,
+			   struct rt_edca_parm *pEdcaParm, u8 *pCkipFlag);
 
 BOOLEAN PeerDisassocSanity(struct rt_rtmp_adapter *pAd,
-			   void * Msg,
+			   void *Msg,
 			   unsigned long MsgLen,
-			   u8 *pAddr2, u16 * Reason);
+			   u8 *pAddr2, u16 *Reason);
 
 BOOLEAN PeerWpaMessageSanity(struct rt_rtmp_adapter *pAd,
-			     struct rt_eapol_packet * pMsg,
+			     struct rt_eapol_packet *pMsg,
 			     unsigned long MsgLen,
 			     u8 MsgType, struct rt_mac_table_entry *pEntry);
 
 BOOLEAN PeerDeauthSanity(struct rt_rtmp_adapter *pAd,
-			 void * Msg,
+			 void *Msg,
 			 unsigned long MsgLen,
-			 u8 *pAddr2, u16 * Reason);
+			 u8 *pAddr2, u16 *Reason);
 
 BOOLEAN PeerProbeReqSanity(struct rt_rtmp_adapter *pAd,
-			   void * Msg,
+			   void *Msg,
 			   unsigned long MsgLen,
 			   u8 *pAddr2,
-			   char Ssid[], u8 * pSsidLen);
+			   char Ssid[], u8 *pSsidLen);
 
-BOOLEAN GetTimBit(char * Ptr,
+BOOLEAN GetTimBit(char *Ptr,
 		  u16 Aid,
-		  u8 * TimLen,
-		  u8 * BcastFlag,
-		  u8 * DtimCount,
-		  u8 * DtimPeriod, u8 * MessageToMe);
+		  u8 *TimLen,
+		  u8 *BcastFlag,
+		  u8 *DtimCount,
+		  u8 *DtimPeriod, u8 *MessageToMe);
 
 u8 ChannelSanity(struct rt_rtmp_adapter *pAd, u8 channel);
 
 NDIS_802_11_NETWORK_TYPE NetworkTypeInUseSanity(struct rt_bss_entry *pBss);
 
 BOOLEAN MlmeDelBAReqSanity(struct rt_rtmp_adapter *pAd,
-			   void * Msg, unsigned long MsgLen);
+			   void *Msg, unsigned long MsgLen);
 
 BOOLEAN MlmeAddBAReqSanity(struct rt_rtmp_adapter *pAd,
-			   void * Msg, unsigned long MsgLen, u8 *pAddr2);
+			   void *Msg, unsigned long MsgLen, u8 *pAddr2);
 
-unsigned long MakeOutgoingFrame(u8 * Buffer, unsigned long * Length, ...);
+unsigned long MakeOutgoingFrame(u8 *Buffer, unsigned long *Length, ...);
 
 void LfsrInit(struct rt_rtmp_adapter *pAd, unsigned long Seed);
 
@@ -3215,7 +3204,7 @@ void MlmeSetTxRate(struct rt_rtmp_adapter *pAd,
 
 void MlmeSelectTxRateTable(struct rt_rtmp_adapter *pAd,
 			   struct rt_mac_table_entry *pEntry,
-			   u8 ** ppTable,
+			   u8 **ppTable,
 			   u8 *pTableSize, u8 *pInitTxRateIdx);
 
 void MlmeCalculateChannelQuality(struct rt_rtmp_adapter *pAd,
@@ -3235,15 +3224,15 @@ void MlmeUpdateTxRates(struct rt_rtmp_adapter *pAd,
 void MlmeUpdateHtTxRates(struct rt_rtmp_adapter *pAd, u8 apidx);
 
 void RTMPCheckRates(struct rt_rtmp_adapter *pAd,
-		    IN u8 SupRate[], IN u8 * SupRateLen);
+		    IN u8 SupRate[], IN u8 *SupRateLen);
 
 BOOLEAN RTMPCheckChannel(struct rt_rtmp_adapter *pAd,
 			 u8 CentralChannel, u8 Channel);
 
 BOOLEAN RTMPCheckHt(struct rt_rtmp_adapter *pAd,
 		    u8 Wcid,
-		    struct rt_ht_capability_ie * pHtCapability,
-		    struct rt_add_ht_info_ie * pAddHtInfo);
+		    struct rt_ht_capability_ie *pHtCapability,
+		    struct rt_add_ht_info_ie *pAddHtInfo);
 
 void StaQuickResponeForRateUpExec(void *SystemSpecific1,
 				  void *FunctionContext,
@@ -3268,7 +3257,7 @@ int set_eFusedump_Proc(struct rt_rtmp_adapter *pAd, char *arg);
 
 void eFusePhysicalReadRegisters(struct rt_rtmp_adapter *pAd,
 				u16 Offset,
-				u16 Length, u16 * pData);
+				u16 Length, u16 *pData);
 
 int RtmpEfuseSupportCheck(struct rt_rtmp_adapter *pAd);
 
@@ -3391,7 +3380,7 @@ int RT_CfgSetWepKey(struct rt_rtmp_adapter *pAd,
 
 int RT_CfgSetWPAPSKKey(struct rt_rtmp_adapter *pAd,
 		       char *keyString,
-		       u8 * pHashStr,
+		       u8 *pHashStr,
 		       int hashStrLen, u8 *pPMKBuf);
 
 /* */
@@ -3402,9 +3391,9 @@ void RTMPWPARemoveAllKeys(struct rt_rtmp_adapter *pAd);
 void RTMPSetPhyMode(struct rt_rtmp_adapter *pAd, unsigned long phymode);
 
 void RTMPUpdateHTIE(struct rt_ht_capability *pRtHt,
-		    u8 * pMcsSet,
-		    struct rt_ht_capability_ie * pHtCapability,
-		    struct rt_add_ht_info_ie * pAddHtInfo);
+		    u8 *pMcsSet,
+		    struct rt_ht_capability_ie *pHtCapability,
+		    struct rt_add_ht_info_ie *pAddHtInfo);
 
 void RTMPAddWcidAttributeEntry(struct rt_rtmp_adapter *pAd,
 			       u8 BssIdx,
@@ -3436,22 +3425,22 @@ void RTMPToWirelessSta(struct rt_rtmp_adapter *pAd,
 		       u32 DataLen, IN BOOLEAN bClearFrame);
 
 void WpaDerivePTK(struct rt_rtmp_adapter *pAd,
-		  u8 * PMK,
-		  u8 * ANonce,
-		  u8 * AA,
-		  u8 * SNonce,
-		  u8 * SA, u8 * output, u32 len);
+		  u8 *PMK,
+		  u8 *ANonce,
+		  u8 *AA,
+		  u8 *SNonce,
+		  u8 *SA, u8 *output, u32 len);
 
-void GenRandom(struct rt_rtmp_adapter *pAd, u8 * macAddr, u8 * random);
+void GenRandom(struct rt_rtmp_adapter *pAd, u8 *macAddr, u8 *random);
 
 BOOLEAN RTMPCheckWPAframe(struct rt_rtmp_adapter *pAd,
 			  struct rt_mac_table_entry *pEntry,
 			  u8 *pData,
 			  unsigned long DataByteCount, u8 FromWhichBSSID);
 
-void AES_GTK_KEY_UNWRAP(u8 * key,
-			u8 * plaintext,
-			u32 c_len, u8 * ciphertext);
+void AES_GTK_KEY_UNWRAP(u8 *key,
+			u8 *plaintext,
+			u32 c_len, u8 *ciphertext);
 
 BOOLEAN RTMPParseEapolKeyData(struct rt_rtmp_adapter *pAd,
 			      u8 *pKeyData,
@@ -3464,11 +3453,11 @@ void ConstructEapolMsg(struct rt_mac_table_entry *pEntry,
 		       u8 GroupKeyWepStatus,
 		       u8 MsgType,
 		       u8 DefaultKeyIdx,
-		       u8 * KeyNonce,
-		       u8 * TxRSC,
-		       u8 * GTK,
-		       u8 * RSNIE,
-		       u8 RSNIE_Len, struct rt_eapol_packet * pMsg);
+		       u8 *KeyNonce,
+		       u8 *TxRSC,
+		       u8 *GTK,
+		       u8 *RSNIE,
+		       u8 RSNIE_Len, struct rt_eapol_packet *pMsg);
 
 int RTMPSoftDecryptBroadCastData(struct rt_rtmp_adapter *pAd,
 					 struct rt_rx_blk *pRxBlk,
@@ -3515,66 +3504,66 @@ void PeerGroupMsg1Action(struct rt_rtmp_adapter *pAd,
 
 void PeerGroupMsg2Action(struct rt_rtmp_adapter *pAd,
 			 struct rt_mac_table_entry *pEntry,
-			 void * Msg, u32 MsgLen);
+			 void *Msg, u32 MsgLen);
 
-void WpaDeriveGTK(u8 * PMK,
-		  u8 * GNonce,
-		  u8 * AA, u8 * output, u32 len);
+void WpaDeriveGTK(u8 *PMK,
+		  u8 *GNonce,
+		  u8 *AA, u8 *output, u32 len);
 
-void AES_GTK_KEY_WRAP(u8 * key,
-		      u8 * plaintext,
-		      u32 p_len, u8 * ciphertext);
+void AES_GTK_KEY_WRAP(u8 *key,
+		      u8 *plaintext,
+		      u32 p_len, u8 *ciphertext);
 
 /*typedef void (*TIMER_FUNCTION)(unsigned long); */
 
 /* timeout -- ms */
-void RTMP_SetPeriodicTimer(struct timer_list * pTimer,
+void RTMP_SetPeriodicTimer(struct timer_list *pTimer,
 			   IN unsigned long timeout);
 
 void RTMP_OS_Init_Timer(struct rt_rtmp_adapter *pAd,
-			struct timer_list * pTimer,
+			struct timer_list *pTimer,
 			IN TIMER_FUNCTION function, void *data);
 
-void RTMP_OS_Add_Timer(struct timer_list * pTimer,
+void RTMP_OS_Add_Timer(struct timer_list *pTimer,
 		       IN unsigned long timeout);
 
-void RTMP_OS_Mod_Timer(struct timer_list * pTimer,
+void RTMP_OS_Mod_Timer(struct timer_list *pTimer,
 		       IN unsigned long timeout);
 
-void RTMP_OS_Del_Timer(struct timer_list * pTimer,
-		       OUT BOOLEAN * pCancelled);
+void RTMP_OS_Del_Timer(struct timer_list *pTimer,
+		       OUT BOOLEAN *pCancelled);
 
 void RTMP_OS_Release_Packet(struct rt_rtmp_adapter *pAd, struct rt_queue_entry *pEntry);
 
 void RTMPusecDelay(unsigned long usec);
 
 int os_alloc_mem(struct rt_rtmp_adapter *pAd,
-			 u8 ** mem, unsigned long size);
+			 u8 **mem, unsigned long size);
 
 int os_free_mem(struct rt_rtmp_adapter *pAd, void *mem);
 
 void RTMP_AllocateSharedMemory(struct rt_rtmp_adapter *pAd,
 			       unsigned long Length,
 			       IN BOOLEAN Cached,
-			       void ** VirtualAddress,
+			       void **VirtualAddress,
 			       dma_addr_t *PhysicalAddress);
 
 void RTMPFreeTxRxRingMemory(struct rt_rtmp_adapter *pAd);
 
-int AdapterBlockAllocateMemory(void *handle, void ** ppAd);
+int AdapterBlockAllocateMemory(void *handle, void **ppAd);
 
 void RTMP_AllocateTxDescMemory(struct rt_rtmp_adapter *pAd,
 			       u32 Index,
 			       unsigned long Length,
 			       IN BOOLEAN Cached,
-			       void ** VirtualAddress,
+			       void **VirtualAddress,
 			       dma_addr_t *PhysicalAddress);
 
 void RTMP_AllocateFirstTxBuffer(struct rt_rtmp_adapter *pAd,
 				u32 Index,
 				unsigned long Length,
 				IN BOOLEAN Cached,
-				void ** VirtualAddress,
+				void **VirtualAddress,
 				dma_addr_t *PhysicalAddress);
 
 void RTMP_FreeFirstTxBuffer(struct rt_rtmp_adapter *pAd,
@@ -3586,13 +3575,13 @@ void RTMP_FreeFirstTxBuffer(struct rt_rtmp_adapter *pAd,
 void RTMP_AllocateMgmtDescMemory(struct rt_rtmp_adapter *pAd,
 				 unsigned long Length,
 				 IN BOOLEAN Cached,
-				 void ** VirtualAddress,
+				 void **VirtualAddress,
 				 dma_addr_t *PhysicalAddress);
 
 void RTMP_AllocateRxDescMemory(struct rt_rtmp_adapter *pAd,
 			       unsigned long Length,
 			       IN BOOLEAN Cached,
-			       void ** VirtualAddress,
+			       void **VirtualAddress,
 			       dma_addr_t *PhysicalAddress);
 
 void RTMP_FreeDescMemory(struct rt_rtmp_adapter *pAd,
@@ -3605,30 +3594,29 @@ void *RtmpOSNetPktAlloc(struct rt_rtmp_adapter *pAd, IN int size);
 void *RTMP_AllocateRxPacketBuffer(struct rt_rtmp_adapter *pAd,
 					 unsigned long Length,
 					 IN BOOLEAN Cached,
-					 void ** VirtualAddress,
-					 OUT dma_addr_t *
-					 PhysicalAddress);
+					 void **VirtualAddress,
+					 OUT dma_addr_t *PhysicalAddress);
 
 void *RTMP_AllocateTxPacketBuffer(struct rt_rtmp_adapter *pAd,
 					 unsigned long Length,
 					 IN BOOLEAN Cached,
-					 void ** VirtualAddress);
+					 void **VirtualAddress);
 
 void *RTMP_AllocateFragPacketBuffer(struct rt_rtmp_adapter *pAd,
 					   unsigned long Length);
 
 void RTMP_QueryPacketInfo(void *pPacket,
 			  struct rt_packet_info *pPacketInfo,
-			  u8 ** pSrcBufVA, u32 * pSrcBufLen);
+			  u8 **pSrcBufVA, u32 *pSrcBufLen);
 
-void RTMP_QueryNextPacketInfo(void ** ppPacket,
+void RTMP_QueryNextPacketInfo(void **ppPacket,
 			      struct rt_packet_info *pPacketInfo,
-			      u8 ** pSrcBufVA, u32 * pSrcBufLen);
+			      u8 **pSrcBufVA, u32 *pSrcBufLen);
 
 BOOLEAN RTMP_FillTxBlkInfo(struct rt_rtmp_adapter *pAd, struct rt_tx_blk *pTxBlk);
 
-struct rt_rtmp_sg_list *
-rt_get_sg_list_from_packet(void *pPacket, struct rt_rtmp_sg_list *sg);
+struct rt_rtmp_sg_list *rt_get_sg_list_from_packet(void *pPacket,
+						struct rt_rtmp_sg_list *sg);
 
 void announce_802_3_packet(struct rt_rtmp_adapter *pAd, void *pPacket);
 
@@ -3717,23 +3705,19 @@ void wlan_802_11_to_802_3_packet(struct rt_rtmp_adapter *pAd,
 {																				\
 	u8 *_pRemovedLLCSNAP = NULL, *_pDA, *_pSA;                                 \
 																				\
-	if (RX_BLK_TEST_FLAG(_pRxBlk, fRX_MESH))                                    \
-	{                                                                           \
+	if (RX_BLK_TEST_FLAG(_pRxBlk, fRX_MESH))	{            \
 		_pDA = _pRxBlk->pHeader->Addr3;                                         \
 		_pSA = (u8 *)_pRxBlk->pHeader + sizeof(struct rt_header_802_11);                \
 	}                                                                           \
-	else                                                                        \
-	{                                                                           \
-		if (RX_BLK_TEST_FLAG(_pRxBlk, fRX_INFRA))                              	\
-		{                                                                       \
+	else	{\
+		if (RX_BLK_TEST_FLAG(_pRxBlk, fRX_INFRA))	{\
 			_pDA = _pRxBlk->pHeader->Addr1;                                     \
 		if (RX_BLK_TEST_FLAG(_pRxBlk, fRX_DLS))									\
 			_pSA = _pRxBlk->pHeader->Addr2;										\
 		else																	\
 			_pSA = _pRxBlk->pHeader->Addr3;                                     \
 		}                                                                       \
-		else                                                                    \
-		{                                                                       \
+		else	{	\
 			_pDA = _pRxBlk->pHeader->Addr1;                                     \
 			_pSA = _pRxBlk->pHeader->Addr2;                                     \
 		}                                                                       \
@@ -3771,8 +3755,8 @@ void Update_Rssi_Sample(struct rt_rtmp_adapter *pAd,
 
 void *GetPacketFromRxRing(struct rt_rtmp_adapter *pAd,
 				 OUT PRT28XX_RXD_STRUC pSaveRxD,
-				 OUT BOOLEAN * pbReschedule,
-				 IN u32 * pRxPending);
+				 OUT BOOLEAN *pbReschedule,
+				 IN u32 *pRxPending);
 
 void *RTMPDeFragmentDataFrame(struct rt_rtmp_adapter *pAd, struct rt_rx_blk *pRxBlk);
 
@@ -3919,24 +3903,24 @@ BOOLEAN RtmpRaDevCtrlExit(struct rt_rtmp_adapter *pAd);
 /* */
 u16 RtmpPCI_WriteTxResource(struct rt_rtmp_adapter *pAd,
 			       struct rt_tx_blk *pTxBlk,
-			       IN BOOLEAN bIsLast, u16 * FreeNumber);
+			       IN BOOLEAN bIsLast, u16 *FreeNumber);
 
 u16 RtmpPCI_WriteSingleTxResource(struct rt_rtmp_adapter *pAd,
 				     struct rt_tx_blk *pTxBlk,
 				     IN BOOLEAN bIsLast,
-				     u16 * FreeNumber);
+				     u16 *FreeNumber);
 
 u16 RtmpPCI_WriteMultiTxResource(struct rt_rtmp_adapter *pAd,
 				    struct rt_tx_blk *pTxBlk,
-				    u8 frameNum, u16 * FreeNumber);
+				    u8 frameNum, u16 *FreeNumber);
 
 u16 RtmpPCI_WriteFragTxResource(struct rt_rtmp_adapter *pAd,
 				   struct rt_tx_blk *pTxBlk,
-				   u8 fragNum, u16 * FreeNumber);
+				   u8 fragNum, u16 *FreeNumber);
 
 u16 RtmpPCI_WriteSubTxResource(struct rt_rtmp_adapter *pAd,
 				  struct rt_tx_blk *pTxBlk,
-				  IN BOOLEAN bIsLast, u16 * FreeNumber);
+				  IN BOOLEAN bIsLast, u16 *FreeNumber);
 
 void RtmpPCI_FinalWriteTxResource(struct rt_rtmp_adapter *pAd,
 				  struct rt_tx_blk *pTxBlk,
@@ -3955,8 +3939,8 @@ int RtmpPCIMgmtKickOut(struct rt_rtmp_adapter *pAd,
 		       u8 *pSrcBufVA, u32 SrcBufLen);
 
 int RTMPCheckRxError(struct rt_rtmp_adapter *pAd,
-			     struct rt_header_802_11 * pHeader,
-			     struct rt_rxwi * pRxWI, IN PRT28XX_RXD_STRUC pRxD);
+			     struct rt_header_802_11 *pHeader,
+			     struct rt_rxwi *pRxWI, IN PRT28XX_RXD_STRUC pRxD);
 
 BOOLEAN RT28xxPciAsicRadioOff(struct rt_rtmp_adapter *pAd,
 			      u8 Level, u16 TbttNumToNextWakeUp);
@@ -4138,15 +4122,15 @@ void append_pkt(struct rt_rtmp_adapter *pAd,
 		u8 *pHeader802_3,
 		u32 HdrLen,
 		u8 *pData,
-		unsigned long DataSize, void ** ppPacket);
+		unsigned long DataSize, void **ppPacket);
 
 u32 deaggregate_AMSDU_announce(struct rt_rtmp_adapter *pAd,
 				void *pPacket,
 				u8 *pData, unsigned long DataSize);
 
 int RTMPCheckRxError(struct rt_rtmp_adapter *pAd,
-			     struct rt_header_802_11 * pHeader,
-			     struct rt_rxwi * pRxWI,
+			     struct rt_header_802_11 *pHeader,
+			     struct rt_rxwi *pRxWI,
 			     IN PRT28XX_RXD_STRUC pRxINFO);
 
 void RTUSBMlmeHardTransmit(struct rt_rtmp_adapter *pAd, struct rt_mgmt *pMgmt);
@@ -4173,20 +4157,20 @@ void RTMPWriteTxInfo(struct rt_rtmp_adapter *pAd,
 /* */
 u16 RtmpUSB_WriteSubTxResource(struct rt_rtmp_adapter *pAd,
 				  struct rt_tx_blk *pTxBlk,
-				  IN BOOLEAN bIsLast, u16 * FreeNumber);
+				  IN BOOLEAN bIsLast, u16 *FreeNumber);
 
 u16 RtmpUSB_WriteSingleTxResource(struct rt_rtmp_adapter *pAd,
 				     struct rt_tx_blk *pTxBlk,
 				     IN BOOLEAN bIsLast,
-				     u16 * FreeNumber);
+				     u16 *FreeNumber);
 
 u16 RtmpUSB_WriteFragTxResource(struct rt_rtmp_adapter *pAd,
 				   struct rt_tx_blk *pTxBlk,
-				   u8 fragNum, u16 * FreeNumber);
+				   u8 fragNum, u16 *FreeNumber);
 
 u16 RtmpUSB_WriteMultiTxResource(struct rt_rtmp_adapter *pAd,
 				    struct rt_tx_blk *pTxBlk,
-				    u8 frameNum, u16 * FreeNumber);
+				    u8 frameNum, u16 *FreeNumber);
 
 void RtmpUSB_FinalWriteTxResource(struct rt_rtmp_adapter *pAd,
 				  struct rt_tx_blk *pTxBlk,
@@ -4205,7 +4189,7 @@ int RtmpUSBMgmtKickOut(struct rt_rtmp_adapter *pAd,
 
 void RtmpUSBNullFrameKickOut(struct rt_rtmp_adapter *pAd,
 			     u8 QueIdx,
-			     u8 * pNullFrame, u32 frameLen);
+			     u8 *pNullFrame, u32 frameLen);
 
 void RtmpUsbStaAsicForceWakeupTimeout(void *SystemSpecific1,
 				      void *FunctionContext,
@@ -4245,9 +4229,9 @@ void AsicStaBbpTuning(struct rt_rtmp_adapter *pAd);
 BOOLEAN StaAddMacTableEntry(struct rt_rtmp_adapter *pAd,
 			    struct rt_mac_table_entry *pEntry,
 			    u8 MaxSupportedRateIn500Kbps,
-			    struct rt_ht_capability_ie * pHtCapability,
+			    struct rt_ht_capability_ie *pHtCapability,
 			    u8 HtCapabilityLen,
-			    struct rt_add_ht_info_ie * pAddHtInfo,
+			    struct rt_add_ht_info_ie *pAddHtInfo,
 			    u8 AddHtInfoLen, u16 CapabilityInfo);
 
 BOOLEAN AUTH_ReqSend(struct rt_rtmp_adapter *pAd,
@@ -4313,7 +4297,7 @@ void RtmpOSNetDevClose(struct net_device *pNetDev);
 
 void RtmpOSNetDevDetach(struct net_device *pNetDev);
 
-int RtmpOSNetDevAlloc(struct net_device ** pNewNetDev, u32 privDataSize);
+int RtmpOSNetDevAlloc(struct net_device **pNewNetDev, u32 privDataSize);
 
 void RtmpOSNetDevFree(struct net_device *pNetDev);
 
-- 
1.7.0.5

