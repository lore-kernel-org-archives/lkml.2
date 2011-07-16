Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1GPXif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 19:38:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48475 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab1GPXid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 19:38:33 -0400
Subject: [PATCH] Summary: Fixed all the indents and other errors in
 IEEE11h.c
From: Toon Schoenmakers <nighteyes1993@gmail.com>
To: gregkh@suse.de, caratorn@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jul 2011 01:38:29 +0200
Message-ID: <1310859509.4191.6.camel@Rarity>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dcfffc596cfcfe1cb38bc230c036c3dc0788779d Mon Sep 17 00:00:00 2001
From: Toon Schoenmakers <nighteyes1993@gmail.com>
Date: Sun, 17 Jul 2011 01:35:14 +0200
Subject: [PATCH] Summary: Fixed all the indents and other errors in IEEE11h.c
Signed-off-by: Toon Schoenmakers <nighteyes1993@gmail.com>

---
 drivers/staging/vt6655/IEEE11h.c |  406 ++++++++++++++++++++------------------
 1 files changed, 215 insertions(+), 191 deletions(-)

diff --git a/drivers/staging/vt6655/IEEE11h.c b/drivers/staging/vt6655/IEEE11h.c
index e07ebd5..cf7364d 100644
--- a/drivers/staging/vt6655/IEEE11h.c
+++ b/drivers/staging/vt6655/IEEE11h.c
@@ -41,52 +41,52 @@
 #include "channel.h"
 
 /*---------------------  Static Definitions -------------------------*/
-static int          msglevel                =MSG_LEVEL_INFO;
+static int          msglevel                = MSG_LEVEL_INFO;
 
 #pragma pack(1)
 
 typedef struct _WLAN_FRAME_ACTION {
-    WLAN_80211HDR_A3    Header;
-    unsigned char byCategory;
-    unsigned char byAction;
-    unsigned char abyVars[1];
+	WLAN_80211HDR_A3    Header;
+	unsigned char byCategory;
+	unsigned char byAction;
+	unsigned char abyVars[1];
 } WLAN_FRAME_ACTION, *PWLAN_FRAME_ACTION;
 
 typedef struct _WLAN_FRAME_MSRREQ {
-    WLAN_80211HDR_A3    Header;
-    unsigned char byCategory;
-    unsigned char byAction;
-    unsigned char byDialogToken;
-    WLAN_IE_MEASURE_REQ sMSRReqEIDs[1];
+	WLAN_80211HDR_A3    Header;
+	unsigned char byCategory;
+	unsigned char byAction;
+	unsigned char byDialogToken;
+	WLAN_IE_MEASURE_REQ sMSRReqEIDs[1];
 } WLAN_FRAME_MSRREQ, *PWLAN_FRAME_MSRREQ;
 
 typedef struct _WLAN_FRAME_MSRREP {
-    WLAN_80211HDR_A3    Header;
-    unsigned char byCategory;
-    unsigned char byAction;
-    unsigned char byDialogToken;
-    WLAN_IE_MEASURE_REP sMSRRepEIDs[1];
+	WLAN_80211HDR_A3    Header;
+	unsigned char byCategory;
+	unsigned char byAction;
+	unsigned char byDialogToken;
+	WLAN_IE_MEASURE_REP sMSRRepEIDs[1];
 } WLAN_FRAME_MSRREP, *PWLAN_FRAME_MSRREP;
 
 typedef struct _WLAN_FRAME_TPCREQ {
-    WLAN_80211HDR_A3    Header;
-    unsigned char byCategory;
-    unsigned char byAction;
-    unsigned char byDialogToken;
-    WLAN_IE_TPC_REQ     sTPCReqEIDs;
+	WLAN_80211HDR_A3    Header;
+	unsigned char byCategory;
+	unsigned char byAction;
+	unsigned char byDialogToken;
+	WLAN_IE_TPC_REQ     sTPCReqEIDs;
 } WLAN_FRAME_TPCREQ, *PWLAN_FRAME_TPCREQ;
 
 typedef struct _WLAN_FRAME_TPCREP {
-    WLAN_80211HDR_A3    Header;
-    unsigned char byCategory;
-    unsigned char byAction;
-    unsigned char byDialogToken;
-    WLAN_IE_TPC_REP     sTPCRepEIDs;
+	WLAN_80211HDR_A3    Header;
+	unsigned char byCategory;
+	unsigned char byAction;
+	unsigned char byDialogToken;
+	WLAN_IE_TPC_REP     sTPCRepEIDs;
 } WLAN_FRAME_TPCREP, *PWLAN_FRAME_TPCREP;
 
 #pragma pack()
 
-// action field reference ieee 802.11h Table 20e
+/* action field reference ieee 802.11h Table 20e */
 #define ACTION_MSRREQ       0
 #define ACTION_MSRREP       1
 #define ACTION_TPCREQ       2
@@ -101,84 +101,100 @@ typedef struct _WLAN_FRAME_TPCREP {
 static bool s_bRxMSRReq(PSMgmtObject pMgmt, PWLAN_FRAME_MSRREQ pMSRReq,
 		unsigned int uLength)
 {
-    size_t    uNumOfEIDs = 0;
-    bool bResult = true;
-
-    if (uLength <= WLAN_A3FR_MAXLEN) {
-        memcpy(pMgmt->abyCurrentMSRReq, pMSRReq, uLength);
-    }
-    uNumOfEIDs = ((uLength - offsetof(WLAN_FRAME_MSRREQ, sMSRReqEIDs))/ (sizeof(WLAN_IE_MEASURE_REQ)));
-    pMgmt->pCurrMeasureEIDRep = &(((PWLAN_FRAME_MSRREP) (pMgmt->abyCurrentMSRRep))->sMSRRepEIDs[0]);
-    pMgmt->uLengthOfRepEIDs = 0;
-    bResult = CARDbStartMeasure(pMgmt->pAdapter,
-                                ((PWLAN_FRAME_MSRREQ) (pMgmt->abyCurrentMSRReq))->sMSRReqEIDs,
-                                uNumOfEIDs
-                                );
-    return (bResult);
+	size_t    uNumOfEIDs = 0;
+	bool bResult = true;
+
+	if (uLength <= WLAN_A3FR_MAXLEN)
+		memcpy(pMgmt->abyCurrentMSRReq, pMSRReq, uLength);
+	uNumOfEIDs = ((uLength - offsetof(WLAN_FRAME_MSRREQ,
+			sMSRReqEIDs))/
+			(sizeof(WLAN_IE_MEASURE_REQ)));
+	pMgmt->pCurrMeasureEIDRep = &(((PWLAN_FRAME_MSRREP)
+			(pMgmt->abyCurrentMSRRep))->sMSRRepEIDs[0]);
+	pMgmt->uLengthOfRepEIDs = 0;
+	bResult = CARDbStartMeasure(pMgmt->pAdapter,
+				((PWLAN_FRAME_MSRREQ)
+				(pMgmt->abyCurrentMSRReq))->sMSRReqEIDs,
+				uNumOfEIDs
+				);
+	return bResult;
 }
 
 
-static bool s_bRxTPCReq(PSMgmtObject pMgmt, PWLAN_FRAME_TPCREQ pTPCReq, unsigned char byRate, unsigned char byRSSI)
+static bool s_bRxTPCReq(PSMgmtObject pMgmt,
+			PWLAN_FRAME_TPCREQ pTPCReq,
+			unsigned char byRate,
+			unsigned char byRSSI)
 {
-    PWLAN_FRAME_TPCREP  pFrame;
-    PSTxMgmtPacket      pTxPacket = NULL;
-
-
-    pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-
-    pFrame = (PWLAN_FRAME_TPCREP)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-
-    pFrame->Header.wFrameCtl = (   WLAN_SET_FC_FTYPE(WLAN_FTYPE_MGMT) |
-                                    WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_ACTION)
-                                );
-
-    memcpy( pFrame->Header.abyAddr1, pTPCReq->Header.abyAddr2, WLAN_ADDR_LEN);
-    memcpy( pFrame->Header.abyAddr2, CARDpGetCurrentAddress(pMgmt->pAdapter), WLAN_ADDR_LEN);
-    memcpy( pFrame->Header.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
-
-    pFrame->byCategory = 0;
-    pFrame->byAction = 3;
-    pFrame->byDialogToken = ((PWLAN_FRAME_MSRREQ) (pMgmt->abyCurrentMSRReq))->byDialogToken;
-
-    pFrame->sTPCRepEIDs.byElementID = WLAN_EID_TPC_REP;
-    pFrame->sTPCRepEIDs.len = 2;
-    pFrame->sTPCRepEIDs.byTxPower = CARDbyGetTransmitPower(pMgmt->pAdapter);
-    switch (byRate) {
-        case RATE_54M:
-            pFrame->sTPCRepEIDs.byLinkMargin = 65 - byRSSI;
-            break;
-        case RATE_48M:
-            pFrame->sTPCRepEIDs.byLinkMargin = 66 - byRSSI;
-            break;
-        case RATE_36M:
-            pFrame->sTPCRepEIDs.byLinkMargin = 70 - byRSSI;
-            break;
-        case RATE_24M:
-            pFrame->sTPCRepEIDs.byLinkMargin = 74 - byRSSI;
-            break;
-        case RATE_18M:
-            pFrame->sTPCRepEIDs.byLinkMargin = 77 - byRSSI;
-            break;
-        case RATE_12M:
-            pFrame->sTPCRepEIDs.byLinkMargin = 79 - byRSSI;
-            break;
-        case RATE_9M:
-            pFrame->sTPCRepEIDs.byLinkMargin = 81 - byRSSI;
-            break;
-        case RATE_6M:
-        default:
-            pFrame->sTPCRepEIDs.byLinkMargin = 82 - byRSSI;
-            break;
-    }
-
-    pTxPacket->cbMPDULen = sizeof(WLAN_FRAME_TPCREP);
-    pTxPacket->cbPayloadLen = sizeof(WLAN_FRAME_TPCREP) - WLAN_HDR_ADDR3_LEN;
-    if (csMgmt_xmit(pMgmt->pAdapter, pTxPacket) != CMD_STATUS_PENDING)
-        return (false);
-    return (true);
-//    return (CARDbSendPacket(pMgmt->pAdapter, pFrame, PKT_TYPE_802_11_MNG, sizeof(WLAN_FRAME_TPCREP)));
+	PWLAN_FRAME_TPCREP  pFrame;
+	PSTxMgmtPacket      pTxPacket = NULL;
+
+	pTxPacket = (PSTxMgmtPacket)pMgmt->pbyMgmtPacketPool;
+	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket +
+sizeof(STxMgmtPacket));
+
+	pFrame = (PWLAN_FRAME_TPCREP)((unsigned char *)pTxPacket +
+sizeof(STxMgmtPacket));
+
+	pFrame->Header.wFrameCtl = (WLAN_SET_FC_FTYPE(WLAN_FTYPE_MGMT) |
+				WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_ACTION)
+				);
+
+	memcpy(pFrame->Header.abyAddr1,
+		pTPCReq->Header.abyAddr2,
+		WLAN_ADDR_LEN);
+	memcpy(pFrame->Header.abyAddr2,
+		CARDpGetCurrentAddress(pMgmt->pAdapter),
+		WLAN_ADDR_LEN);
+	memcpy(pFrame->Header.abyAddr3,
+		pMgmt->abyCurrBSSID,
+		WLAN_BSSID_LEN);
+
+	pFrame->byCategory = 0;
+	pFrame->byAction = 3;
+	pFrame->byDialogToken = ((PWLAN_FRAME_MSRREQ)
+(pMgmt->abyCurrentMSRReq))->byDialogToken;
+
+	pFrame->sTPCRepEIDs.byElementID = WLAN_EID_TPC_REP;
+	pFrame->sTPCRepEIDs.len = 2;
+	pFrame->sTPCRepEIDs.byTxPower = CARDbyGetTransmitPower(pMgmt->pAdapter);
+	switch (byRate) {
+	case RATE_54M:
+		pFrame->sTPCRepEIDs.byLinkMargin = 65 - byRSSI;
+		break;
+	case RATE_48M:
+		pFrame->sTPCRepEIDs.byLinkMargin = 66 - byRSSI;
+		break;
+	case RATE_36M:
+		pFrame->sTPCRepEIDs.byLinkMargin = 70 - byRSSI;
+		break;
+	case RATE_24M:
+		pFrame->sTPCRepEIDs.byLinkMargin = 74 - byRSSI;
+		break;
+	case RATE_18M:
+		pFrame->sTPCRepEIDs.byLinkMargin = 77 - byRSSI;
+		break;
+	case RATE_12M:
+		pFrame->sTPCRepEIDs.byLinkMargin = 79 - byRSSI;
+		break;
+	case RATE_9M:
+		pFrame->sTPCRepEIDs.byLinkMargin = 81 - byRSSI;
+		break;
+	case RATE_6M:
+	default:
+		pFrame->sTPCRepEIDs.byLinkMargin = 82 - byRSSI;
+		break;
+}
+
+	pTxPacket->cbMPDULen = sizeof(WLAN_FRAME_TPCREP);
+	pTxPacket->cbPayloadLen = sizeof(WLAN_FRAME_TPCREP) -
+WLAN_HDR_ADDR3_LEN;
+	if (csMgmt_xmit(pMgmt->pAdapter, pTxPacket) != CMD_STATUS_PENDING)
+		return false;
+	return true;
+/*    return (CARDbSendPacket(pMgmt->pAdapter, pFrame, PKT_TYPE_802_11_MNG,
+sizeof(WLAN_FRAME_TPCREP))); */
 
 }
 
@@ -204,102 +220,110 @@ static bool s_bRxTPCReq(PSMgmtObject pMgmt, PWLAN_FRAME_TPCREQ pTPCReq, unsigned
  *
 -*/
 bool
-IEEE11hbMgrRxAction (
-    void *pMgmtHandle,
-    void *pRxPacket
-    )
+IEEE11hbMgrRxAction(void *pMgmtHandle, void *pRxPacket)
 {
-    PSMgmtObject            pMgmt = (PSMgmtObject) pMgmtHandle;
-    PWLAN_FRAME_ACTION      pAction = NULL;
-    unsigned int uLength = 0;
-    PWLAN_IE_CH_SW          pChannelSwitch = NULL;
-
-
-    // decode the frame
-    uLength = ((PSRxMgmtPacket)pRxPacket)->cbMPDULen;
-    if (uLength > WLAN_A3FR_MAXLEN) {
-        return (false);
-    }
-
-
-    pAction = (PWLAN_FRAME_ACTION) (((PSRxMgmtPacket)pRxPacket)->p80211Header);
-
-    if (pAction->byCategory == 0) {
-        switch (pAction->byAction) {
-            case ACTION_MSRREQ:
-                return (s_bRxMSRReq(pMgmt, (PWLAN_FRAME_MSRREQ) pAction, uLength));
-                break;
-            case ACTION_MSRREP:
-                break;
-            case ACTION_TPCREQ:
-                return (s_bRxTPCReq(pMgmt,
-                                    (PWLAN_FRAME_TPCREQ) pAction,
-                                    ((PSRxMgmtPacket)pRxPacket)->byRxRate,
-                                    (unsigned char) ((PSRxMgmtPacket)pRxPacket)->uRSSI));
-                break;
-            case ACTION_TPCREP:
-                break;
-            case ACTION_CHSW:
-                pChannelSwitch = (PWLAN_IE_CH_SW) (pAction->abyVars);
-                if ((pChannelSwitch->byElementID == WLAN_EID_CH_SWITCH) &&
-                    (pChannelSwitch->len == 3)) {
-                    // valid element id
-                    CARDbChannelSwitch( pMgmt->pAdapter,
-                                        pChannelSwitch->byMode,
-                                        get_channel_mapping(pMgmt->pAdapter, pChannelSwitch->byChannel, pMgmt->eCurrentPHYMode),
-                                        pChannelSwitch->byCount
-                                        );
-                }
-                break;
-            default:
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Unknown Action = %d\n", pAction->byAction);
-                break;
-        }
-    } else {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Unknown Category = %d\n", pAction->byCategory);
-        pAction->byCategory |= 0x80;
-
-       //return (CARDbSendPacket(pMgmt->pAdapter, pAction, PKT_TYPE_802_11_MNG, uLength));
-        return (true);
-    }
-    return (true);
+	PSMgmtObject            pMgmt = (PSMgmtObject) pMgmtHandle;
+	PWLAN_FRAME_ACTION      pAction = NULL;
+	unsigned int uLength = 0;
+	PWLAN_IE_CH_SW          pChannelSwitch = NULL;
+
+	/* decode the frame */
+	uLength = ((PSRxMgmtPacket)pRxPacket)->cbMPDULen;
+	if (uLength > WLAN_A3FR_MAXLEN)
+		return false;
+
+	pAction = (PWLAN_FRAME_ACTION)
+(((PSRxMgmtPacket)pRxPacket)->p80211Header);
+
+	if (pAction->byCategory == 0) {
+		switch (pAction->byAction) {
+		case ACTION_MSRREQ:
+			return s_bRxMSRReq(pMgmt,
+					(PWLAN_FRAME_MSRREQ)
+					pAction,
+					uLength);
+			break;
+		case ACTION_MSRREP:
+			break;
+		case ACTION_TPCREQ:
+			return s_bRxTPCReq(pMgmt,
+				(PWLAN_FRAME_TPCREQ) pAction,
+				((PSRxMgmtPacket)pRxPacket)->byRxRate,
+				(unsigned char)
+				((PSRxMgmtPacket)pRxPacket)->uRSSI);
+			break;
+		case ACTION_TPCREP:
+			break;
+		case ACTION_CHSW:
+			pChannelSwitch = (PWLAN_IE_CH_SW) (pAction->abyVars);
+			if ((pChannelSwitch->byElementID == WLAN_EID_CH_SWITCH)
+			&& (pChannelSwitch->len == 3)) {
+				/* valid element id */
+				CARDbChannelSwitch(pMgmt->pAdapter,
+				pChannelSwitch->byMode,
+				get_channel_mapping(pMgmt->pAdapter,
+				pChannelSwitch->byChannel,
+				pMgmt->eCurrentPHYMode),
+				pChannelSwitch->byCount);
+			}
+			break;
+		default:
+			DBG_PRT(MSG_LEVEL_DEBUG,
+				KERN_INFO"Unknown Action = %d\n",
+				pAction->byAction);
+			break;
+		}
+	} else {
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Unknown Category = %d\n",
+pAction->byCategory);
+	pAction->byCategory |= 0x80;
+
+	/*return (CARDbSendPacket(pMgmt->pAdapter, pAction, PKT_TYPE_802_11_MNG,
+uLength));*/
+	return true;
+	}
+	return true;
 }
 
 
-bool IEEE11hbMSRRepTx (
-    void *pMgmtHandle
-    )
+bool IEEE11hbMSRRepTx(void *pMgmtHandle)
 {
-    PSMgmtObject            pMgmt = (PSMgmtObject) pMgmtHandle;
-    PWLAN_FRAME_MSRREP      pMSRRep = (PWLAN_FRAME_MSRREP) (pMgmt->abyCurrentMSRRep + sizeof(STxMgmtPacket));
-    size_t                    uLength = 0;
-    PSTxMgmtPacket          pTxPacket = NULL;
-
-    pTxPacket = (PSTxMgmtPacket)pMgmt->abyCurrentMSRRep;
-    memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN);
-    pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket + sizeof(STxMgmtPacket));
-
-
-    pMSRRep->Header.wFrameCtl = (   WLAN_SET_FC_FTYPE(WLAN_FTYPE_MGMT) |
-                                    WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_ACTION)
-                                );
-
-    memcpy( pMSRRep->Header.abyAddr1, ((PWLAN_FRAME_MSRREQ) (pMgmt->abyCurrentMSRReq))->Header.abyAddr2, WLAN_ADDR_LEN);
-    memcpy( pMSRRep->Header.abyAddr2, CARDpGetCurrentAddress(pMgmt->pAdapter), WLAN_ADDR_LEN);
-    memcpy( pMSRRep->Header.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
-
-    pMSRRep->byCategory = 0;
-    pMSRRep->byAction = 1;
-    pMSRRep->byDialogToken = ((PWLAN_FRAME_MSRREQ) (pMgmt->abyCurrentMSRReq))->byDialogToken;
-
-    uLength = pMgmt->uLengthOfRepEIDs + offsetof(WLAN_FRAME_MSRREP, sMSRRepEIDs);
-
-    pTxPacket->cbMPDULen = uLength;
-    pTxPacket->cbPayloadLen = uLength - WLAN_HDR_ADDR3_LEN;
-    if (csMgmt_xmit(pMgmt->pAdapter, pTxPacket) != CMD_STATUS_PENDING)
-        return (false);
-    return (true);
-//    return (CARDbSendPacket(pMgmt->pAdapter, pMSRRep, PKT_TYPE_802_11_MNG, uLength));
+	PSMgmtObject            pMgmt = (PSMgmtObject) pMgmtHandle;
+	PWLAN_FRAME_MSRREP      pMSRRep = (PWLAN_FRAME_MSRREP)
+(pMgmt->abyCurrentMSRRep + sizeof(STxMgmtPacket));
+	size_t                    uLength = 0;
+	PSTxMgmtPacket          pTxPacket = NULL;
+
+	pTxPacket = (PSTxMgmtPacket)pMgmt->abyCurrentMSRRep;
+	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN);
+	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket +
+sizeof(STxMgmtPacket));
+
+	pMSRRep->Header.wFrameCtl = (WLAN_SET_FC_FTYPE(WLAN_FTYPE_MGMT) |
+				WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_ACTION)
+				);
+
+	memcpy(pMSRRep->Header.abyAddr1, ((PWLAN_FRAME_MSRREQ)
+		(pMgmt->abyCurrentMSRReq))->Header.abyAddr2, WLAN_ADDR_LEN);
+	memcpy(pMSRRep->Header.abyAddr2,
+		CARDpGetCurrentAddress(pMgmt->pAdapter), WLAN_ADDR_LEN);
+	memcpy(pMSRRep->Header.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
+
+	pMSRRep->byCategory = 0;
+	pMSRRep->byAction = 1;
+	pMSRRep->byDialogToken = ((PWLAN_FRAME_MSRREQ)
+		(pMgmt->abyCurrentMSRReq))->byDialogToken;
+
+	uLength = pMgmt->uLengthOfRepEIDs + offsetof(WLAN_FRAME_MSRREP,
+						     sMSRRepEIDs);
+
+	pTxPacket->cbMPDULen = uLength;
+	pTxPacket->cbPayloadLen = uLength - WLAN_HDR_ADDR3_LEN;
+	if (csMgmt_xmit(pMgmt->pAdapter, pTxPacket) != CMD_STATUS_PENDING)
+		return false;
+	return true;
+/*    return (CARDbSendPacket(pMgmt->pAdapter, pMSRRep, PKT_TYPE_802_11_MNG,
+uLength)); */
 
 }
 
-- 
1.7.4.4



