Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2IZGFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:05:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50085 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2IZGFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:05:18 -0400
From: Ilya gorskin <revent82@gmail.com>
To: gregkh@linuxfoundation.org, forest@alittletooquiet.net, revent82@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:vt6656: Fix tabs error in 80211mgr.c
Date: Wed, 26 Sep 2012 12:05:11 +0600
Message-Id: <1348639511-19305-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the 80211mgr.c file that fixes up a tabs
error found by the checkpatch.pl tool

Signed-off-by: Goirskin Ilya <revent82@gmail.com>
---
 drivers/staging/vt6656/80211mgr.c | 628 +++++++++++++++++++-------------------
 1 file changed, 310 insertions(+), 318 deletions(-)

diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
index 39f9842..4241d29 100644
--- a/drivers/staging/vt6656/80211mgr.c
+++ b/drivers/staging/vt6656/80211mgr.c
@@ -98,11 +98,11 @@ vMgrEncodeBeacon(
 
     /* Fixed Fields */
     pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                    + WLAN_BEACON_OFF_TS);
+							+ WLAN_BEACON_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                       + WLAN_BEACON_OFF_BCN_INT);
+						+ WLAN_BEACON_OFF_BCN_INT);
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_BEACON_OFF_CAPINFO);
+						+ WLAN_BEACON_OFF_CAPINFO);
 
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_BEACON_OFF_SSID;
 
@@ -132,98 +132,90 @@ vMgrDecodeBeacon(
 
     /* Fixed Fields */
     pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                    + WLAN_BEACON_OFF_TS);
+							+ WLAN_BEACON_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                       + WLAN_BEACON_OFF_BCN_INT);
+						+ WLAN_BEACON_OFF_BCN_INT);
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_BEACON_OFF_CAPINFO);
+						+ WLAN_BEACON_OFF_CAPINFO);
 
     /* Information elements */
     pItem = (PWLAN_IE)((PBYTE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)))
-                       + WLAN_BEACON_OFF_SSID);
+						+ WLAN_BEACON_OFF_SSID);
     while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
 
-        switch (pItem->byElementID) {
-        case WLAN_EID_SSID:
-            if (pFrame->pSSID == NULL)
-                pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-            break;
-        case WLAN_EID_SUPP_RATES:
-            if (pFrame->pSuppRates == NULL)
-                pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-        case WLAN_EID_FH_PARMS:
-            /* pFrame->pFHParms = (PWLAN_IE_FH_PARMS)pItem; */
-            break;
-        case WLAN_EID_DS_PARMS:
-            if (pFrame->pDSParms == NULL)
-                pFrame->pDSParms = (PWLAN_IE_DS_PARMS)pItem;
-            break;
-        case WLAN_EID_CF_PARMS:
-            if (pFrame->pCFParms == NULL)
-                pFrame->pCFParms = (PWLAN_IE_CF_PARMS)pItem;
-            break;
-        case WLAN_EID_IBSS_PARMS:
-            if (pFrame->pIBSSParms == NULL)
-                pFrame->pIBSSParms = (PWLAN_IE_IBSS_PARMS)pItem;
-            break;
-        case WLAN_EID_TIM:
-            if (pFrame->pTIM == NULL)
-                pFrame->pTIM = (PWLAN_IE_TIM)pItem;
-            break;
-
-        case WLAN_EID_RSN:
-            if (pFrame->pRSN == NULL) 
-                pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-            break;
-        case WLAN_EID_RSN_WPA:
-            if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
-                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-            }
-            break;
-
-        case WLAN_EID_ERP:
-            if (pFrame->pERP == NULL)
-                pFrame->pERP = (PWLAN_IE_ERP)pItem;
-            break;
-        case WLAN_EID_EXTSUPP_RATES:
-            if (pFrame->pExtSuppRates == NULL)
-                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-
-        case WLAN_EID_COUNTRY:      /* 7 */
-            if (pFrame->pIE_Country == NULL)
-                pFrame->pIE_Country = (PWLAN_IE_COUNTRY)pItem;
-            break;
-
-        case WLAN_EID_PWR_CONSTRAINT:   /* 32 */
-            if (pFrame->pIE_PowerConstraint == NULL)
-                pFrame->pIE_PowerConstraint = (PWLAN_IE_PW_CONST)pItem;
-            break;
-
-        case WLAN_EID_CH_SWITCH:    /* 37 */
-            if (pFrame->pIE_CHSW == NULL)
-                pFrame->pIE_CHSW = (PWLAN_IE_CH_SW)pItem;
-            break;
-
-        case WLAN_EID_QUIET:        /* 40 */
-            if (pFrame->pIE_Quiet == NULL)
-                pFrame->pIE_Quiet = (PWLAN_IE_QUIET)pItem;
-            break;
-
-        case WLAN_EID_IBSS_DFS:
-            if (pFrame->pIE_IBSSDFS == NULL)
-                pFrame->pIE_IBSSDFS = (PWLAN_IE_IBSS_DFS)pItem;
-            break;
-
-        default:
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in beacon decode.\n", pItem->byElementID);
-                break;
-
-        }
-        pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
-    }
+		switch (pItem->byElementID) {
+		case WLAN_EID_SSID:
+			if (pFrame->pSSID == NULL)
+				pFrame->pSSID = (PWLAN_IE_SSID)pItem;
+			break;
+		case WLAN_EID_SUPP_RATES:
+			if (pFrame->pSuppRates == NULL)
+				pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
+		case WLAN_EID_FH_PARMS:
+		/* pFrame->pFHParms = (PWLAN_IE_FH_PARMS)pItem; */
+			break;
+		case WLAN_EID_DS_PARMS:
+			if (pFrame->pDSParms == NULL)
+				pFrame->pDSParms = (PWLAN_IE_DS_PARMS)pItem;
+			break;
+		case WLAN_EID_CF_PARMS:
+			if (pFrame->pCFParms == NULL)
+				pFrame->pCFParms = (PWLAN_IE_CF_PARMS)pItem;
+			break;
+		case WLAN_EID_IBSS_PARMS:
+			if (pFrame->pIBSSParms == NULL)
+				pFrame->pIBSSParms = (PWLAN_IE_IBSS_PARMS)pItem;
+			break;
+		case WLAN_EID_TIM:
+			if (pFrame->pTIM == NULL)
+				pFrame->pTIM = (PWLAN_IE_TIM)pItem;
+			break;
+		case WLAN_EID_RSN:
+			if (pFrame->pRSN == NULL)
+				pFrame->pRSN = (PWLAN_IE_RSN)pItem;
+			break;
+		case WLAN_EID_RSN_WPA:
+			if (pFrame->pRSNWPA == NULL) {
+				if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+					pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
+			}
+			break;
+		case WLAN_EID_ERP:
+			if (pFrame->pERP == NULL)
+				pFrame->pERP = (PWLAN_IE_ERP)pItem;
+			break;
+		case WLAN_EID_EXTSUPP_RATES:
+			if (pFrame->pExtSuppRates == NULL)
+				pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
+		case WLAN_EID_COUNTRY:      /* 7 */
+			if (pFrame->pIE_Country == NULL)
+				pFrame->pIE_Country = (PWLAN_IE_COUNTRY)pItem;
+			break;
+		case WLAN_EID_PWR_CONSTRAINT:   /* 32 */
+			if (pFrame->pIE_PowerConstraint == NULL)
+				pFrame->pIE_PowerConstraint = (PWLAN_IE_PW_CONST)pItem
+			break;
+		case WLAN_EID_CH_SWITCH:    /* 37 */
+			if (pFrame->pIE_CHSW == NULL)
+				pFrame->pIE_CHSW = (PWLAN_IE_CH_SW)pItem;
+			break;
+		case WLAN_EID_QUIET:        /* 40 */
+			if (pFrame->pIE_Quiet == NULL)
+				pFrame->pIE_Quiet = (PWLAN_IE_QUIET)pItem;
+			break;
+		case WLAN_EID_IBSS_DFS:
+			if (pFrame->pIE_IBSSDFS == NULL)
+				pFrame->pIE_IBSSDFS = (PWLAN_IE_IBSS_DFS)pItem;
+			break;
+		default:
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in beacon decode.\n", pItem->byElementID);
+			break;
+
+		}
+		pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
+	}
 }
 
 
@@ -290,7 +282,7 @@ vMgrEncodeDisassociation(
 
     /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_DISASSOC_OFF_REASON);
+												+ WLAN_DISASSOC_OFF_REASON);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_DISASSOC_OFF_REASON + sizeof(*(pFrame->pwReason));
 }
 
@@ -315,7 +307,7 @@ vMgrDecodeDisassociation(
 
     /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_DISASSOC_OFF_REASON);
+						+ WLAN_DISASSOC_OFF_REASON);
 }
 
 /*+
@@ -338,9 +330,9 @@ vMgrEncodeAssocRequest(
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
     /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_ASSOCREQ_OFF_CAP_INFO);
+											+ WLAN_ASSOCREQ_OFF_CAP_INFO);
     pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                       + WLAN_ASSOCREQ_OFF_LISTEN_INT);
+											+ WLAN_ASSOCREQ_OFF_LISTEN_INT);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_ASSOCREQ_OFF_LISTEN_INT + sizeof(*(pFrame->pwListenInterval));
 }
 
@@ -366,47 +358,45 @@ vMgrDecodeAssocRequest(
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
     /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_ASSOCREQ_OFF_CAP_INFO);
+											+ WLAN_ASSOCREQ_OFF_CAP_INFO);
     pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_ASSOCREQ_OFF_LISTEN_INT);
+											+ WLAN_ASSOCREQ_OFF_LISTEN_INT);
 
     /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                            + WLAN_ASSOCREQ_OFF_SSID);
-
-    while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
-        switch (pItem->byElementID) {
-        case WLAN_EID_SSID:
-            if (pFrame->pSSID == NULL)
-                pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-            break;
-        case WLAN_EID_SUPP_RATES:
-            if (pFrame->pSuppRates == NULL)
-                pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-
-        case WLAN_EID_RSN:
-            if (pFrame->pRSN == NULL)
-                pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-            break;
-        case WLAN_EID_RSN_WPA:
-            if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
-                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-            }
-            break;
-        case WLAN_EID_EXTSUPP_RATES:
-            if (pFrame->pExtSuppRates == NULL)
-                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-
-        default:
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in assocreq decode.\n",
-                    pItem->byElementID);
-            break;
-        }
-        pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
-    }
+											+ WLAN_ASSOCREQ_OFF_SSID);
+
+	while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
+		switch (pItem->byElementID) {
+		case WLAN_EID_SSID:
+			if (pFrame->pSSID == NULL)
+				pFrame->pSSID = (PWLAN_IE_SSID)pItem;
+			break;
+		case WLAN_EID_SUPP_RATES:
+			if (pFrame->pSuppRates == NULL)
+				pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
+		case WLAN_EID_RSN:
+			if (pFrame->pRSN == NULL)
+				pFrame->pRSN = (PWLAN_IE_RSN)pItem;
+			break;
+		case WLAN_EID_RSN_WPA:
+			if (pFrame->pRSNWPA == NULL) {
+				if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+					pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
+			}
+			break;
+		case WLAN_EID_EXTSUPP_RATES:
+			if (pFrame->pExtSuppRates == NULL)
+				pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
+		default:
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in assocreq decode.\n",
+			pItem->byElementID);
+			break;
+		}
+	pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
+	}
 }
 
 /*+
@@ -425,17 +415,17 @@ vMgrEncodeAssocResponse(
       PWLAN_FR_ASSOCRESP  pFrame
      )
 {
-    pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
+	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
     /* Fixed Fields */
-    pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_ASSOCRESP_OFF_CAP_INFO);
-    pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_ASSOCRESP_OFF_STATUS);
-    pFrame->pwAid = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                            + WLAN_ASSOCRESP_OFF_AID);
-    pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_ASSOCRESP_OFF_AID
-                  + sizeof(*(pFrame->pwAid));
+	pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
+											+ WLAN_ASSOCRESP_OFF_CAP_INFO);
+	pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
+											+ WLAN_ASSOCRESP_OFF_STATUS);
+	pFrame->pwAid = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
+											+ WLAN_ASSOCRESP_OFF_AID);
+	pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_ASSOCRESP_OFF_AID
+											+ sizeof(*(pFrame->pwAid));
 }
 
 
@@ -461,24 +451,24 @@ vMgrDecodeAssocResponse(
 
     /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_ASSOCRESP_OFF_CAP_INFO);
+											+ WLAN_ASSOCRESP_OFF_CAP_INFO);
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_ASSOCRESP_OFF_STATUS);
+											+ WLAN_ASSOCRESP_OFF_STATUS);
     pFrame->pwAid = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                            + WLAN_ASSOCRESP_OFF_AID);
+											+ WLAN_ASSOCRESP_OFF_AID);
 
     /* Information elements */
     pFrame->pSuppRates  = (PWLAN_IE_SUPP_RATES)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                           + WLAN_ASSOCRESP_OFF_SUPP_RATES);
+											+ WLAN_ASSOCRESP_OFF_SUPP_RATES);
 
     pItem = (PWLAN_IE)(pFrame->pSuppRates);
     pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
 
     if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_EXTSUPP_RATES)) {
-        pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pFrame->pExtSuppRates=[%p].\n", pItem);
+		pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pFrame->pExtSuppRates=[%p].\n", pItem);
 	} else
-        pFrame->pExtSuppRates = NULL;
+		pFrame->pExtSuppRates = NULL;
 }
 
 
@@ -502,11 +492,11 @@ vMgrEncodeReassocRequest(
 
     /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_REASSOCREQ_OFF_CAP_INFO);
+											+ WLAN_REASSOCREQ_OFF_CAP_INFO);
     pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                      + WLAN_REASSOCREQ_OFF_LISTEN_INT);
+											+ WLAN_REASSOCREQ_OFF_LISTEN_INT);
     pFrame->pAddrCurrAP = (PIEEE_ADDR)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                       + WLAN_REASSOCREQ_OFF_CURR_AP);
+											+ WLAN_REASSOCREQ_OFF_CURR_AP);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_REASSOCREQ_OFF_CURR_AP + sizeof(*(pFrame->pAddrCurrAP));
 }
 
@@ -533,49 +523,48 @@ vMgrDecodeReassocRequest(
 
     /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_REASSOCREQ_OFF_CAP_INFO);
+											+ WLAN_REASSOCREQ_OFF_CAP_INFO);
     pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                      + WLAN_REASSOCREQ_OFF_LISTEN_INT);
+											+ WLAN_REASSOCREQ_OFF_LISTEN_INT);
     pFrame->pAddrCurrAP = (PIEEE_ADDR)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                       + WLAN_REASSOCREQ_OFF_CURR_AP);
+											+ WLAN_REASSOCREQ_OFF_CURR_AP);
 
     /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                       + WLAN_REASSOCREQ_OFF_SSID);
-
-    while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
-
-        switch (pItem->byElementID) {
-        case WLAN_EID_SSID:
-            if (pFrame->pSSID == NULL)
-                pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-            break;
-        case WLAN_EID_SUPP_RATES:
-            if (pFrame->pSuppRates == NULL)
-                pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-
-        case WLAN_EID_RSN:
-            if (pFrame->pRSN == NULL)
-                pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-            break;
-        case WLAN_EID_RSN_WPA:
-		if (pFrame->pRSNWPA == NULL)
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
-                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-            break;
-
-        case WLAN_EID_EXTSUPP_RATES:
-            if (pFrame->pExtSuppRates == NULL)
-                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-        default:
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in reassocreq decode.\n",
-                        pItem->byElementID);
-            break;
-        }
-        pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
-    }
+											+ WLAN_REASSOCREQ_OFF_SSID);
+
+	while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
+
+		switch (pItem->byElementID) {
+		case WLAN_EID_SSID:
+			if (pFrame->pSSID == NULL)
+				pFrame->pSSID = (PWLAN_IE_SSID)pItem;
+			break;
+		case WLAN_EID_SUPP_RATES:
+			if (pFrame->pSuppRates == NULL)
+				pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
+
+		case WLAN_EID_RSN:\
+			if (pFrame->pRSN == NULL)
+				pFrame->pRSN = (PWLAN_IE_RSN)pItem;
+			break;
+		case WLAN_EID_RSN_WPA:
+			if (pFrame->pRSNWPA == NULL)
+				if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+					pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
+			break;
+
+		case WLAN_EID_EXTSUPP_RATES:
+			if (pFrame->pExtSuppRates == NULL)
+				pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
+		default:
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in reassocreq decode.\n", pItem->byElementID);
+			break;
+		}
+	pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
+	}
 }
 
 
@@ -624,31 +613,31 @@ vMgrDecodeProbeRequest(
     /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)));
 
-    while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
+	while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
+
+		switch (pItem->byElementID) {
+		case WLAN_EID_SSID:
+			if (pFrame->pSSID == NULL)
+				pFrame->pSSID = (PWLAN_IE_SSID)pItem;
+			break;
+
+		case WLAN_EID_SUPP_RATES:
+			if (pFrame->pSuppRates == NULL)
+				pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
+
+		case WLAN_EID_EXTSUPP_RATES:
+			if (pFrame->pExtSuppRates == NULL)
+				pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
 
-        switch (pItem->byElementID) {
-        case WLAN_EID_SSID:
-            if (pFrame->pSSID == NULL)
-                pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-            break;
-
-        case WLAN_EID_SUPP_RATES:
-            if (pFrame->pSuppRates == NULL)
-                pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-
-        case WLAN_EID_EXTSUPP_RATES:
-            if (pFrame->pExtSuppRates == NULL)
-                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-
-        default:
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Bad EID=%dd in probereq\n", pItem->byElementID);
-            break;
-        }
-
-        pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 +  pItem->len);
-    }
+		default:
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Bad EID=%dd in probereq\n", pItem->byElementID);
+			break;
+		}
+
+		pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 +  pItem->len);
+	}
 }
 
 
@@ -673,14 +662,14 @@ vMgrEncodeProbeResponse(
 
     /* Fixed Fields */
     pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                    + WLAN_PROBERESP_OFF_TS);
+												+ WLAN_PROBERESP_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                       + WLAN_PROBERESP_OFF_BCN_INT);
+												+ WLAN_PROBERESP_OFF_BCN_INT);
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_PROBERESP_OFF_CAP_INFO);
+												+ WLAN_PROBERESP_OFF_CAP_INFO);
 
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_PROBERESP_OFF_CAP_INFO +
-                  sizeof(*(pFrame->pwCapInfo));
+												sizeof(*(pFrame->pwCapInfo));
 }
 
 
@@ -708,92 +697,92 @@ vMgrDecodeProbeResponse(
 
     /* Fixed Fields */
     pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                    + WLAN_PROBERESP_OFF_TS);
+												+ WLAN_PROBERESP_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                       + WLAN_PROBERESP_OFF_BCN_INT);
+												+ WLAN_PROBERESP_OFF_BCN_INT);
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_PROBERESP_OFF_CAP_INFO);
+												+ WLAN_PROBERESP_OFF_CAP_INFO);
 
     /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                       + WLAN_PROBERESP_OFF_SSID);
-
-    while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
-        switch (pItem->byElementID) {
-        case WLAN_EID_SSID:
-            if (pFrame->pSSID == NULL)
-                pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-            break;
-        case WLAN_EID_SUPP_RATES:
-            if (pFrame->pSuppRates == NULL)
-                pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-        case WLAN_EID_FH_PARMS:
-            break;
-        case WLAN_EID_DS_PARMS:
-            if (pFrame->pDSParms == NULL)
-                pFrame->pDSParms = (PWLAN_IE_DS_PARMS)pItem;
-            break;
-        case WLAN_EID_CF_PARMS:
-            if (pFrame->pCFParms == NULL)
-                pFrame->pCFParms = (PWLAN_IE_CF_PARMS)pItem;
-            break;
-        case WLAN_EID_IBSS_PARMS:
-            if (pFrame->pIBSSParms == NULL)
-                pFrame->pIBSSParms = (PWLAN_IE_IBSS_PARMS)pItem;
-            break;
-
-        case WLAN_EID_RSN:
-            if (pFrame->pRSN == NULL)
-                pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-            break;
-        case WLAN_EID_RSN_WPA:
-            if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
-                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-            }
-            break;
-        case WLAN_EID_ERP:
-            if (pFrame->pERP == NULL)
-                pFrame->pERP = (PWLAN_IE_ERP)pItem;
-            break;
-        case WLAN_EID_EXTSUPP_RATES:
-            if (pFrame->pExtSuppRates == NULL)
-                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-            break;
-
-        case WLAN_EID_COUNTRY:      /* 7 */
-            if (pFrame->pIE_Country == NULL)
-                pFrame->pIE_Country = (PWLAN_IE_COUNTRY)pItem;
-            break;
-
-        case WLAN_EID_PWR_CONSTRAINT:   /* 32 */
-            if (pFrame->pIE_PowerConstraint == NULL)
-                pFrame->pIE_PowerConstraint = (PWLAN_IE_PW_CONST)pItem;
-            break;
-
-        case WLAN_EID_CH_SWITCH:    /* 37 */
-            if (pFrame->pIE_CHSW == NULL)
-                pFrame->pIE_CHSW = (PWLAN_IE_CH_SW)pItem;
-            break;
-
-        case WLAN_EID_QUIET:        /* 40 */
-            if (pFrame->pIE_Quiet == NULL)
-                pFrame->pIE_Quiet = (PWLAN_IE_QUIET)pItem;
-            break;
-
-        case WLAN_EID_IBSS_DFS:
-            if (pFrame->pIE_IBSSDFS == NULL)
-                pFrame->pIE_IBSSDFS = (PWLAN_IE_IBSS_DFS)pItem;
-            break;
-
-        default:
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Bad EID=%dd in proberesp\n", pItem->byElementID);
-            break;
-        }
-
-        pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 +  pItem->len);
-    }
+												+ WLAN_PROBERESP_OFF_SSID);
+
+	while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
+		switch (pItem->byElementID) {
+		case WLAN_EID_SSID:
+			if (pFrame->pSSID == NULL)
+				pFrame->pSSID = (PWLAN_IE_SSID)pItem;
+			break;
+		case WLAN_EID_SUPP_RATES:
+			if (pFrame->pSuppRates == NULL)
+				pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
+		case WLAN_EID_FH_PARMS:
+			break;
+		case WLAN_EID_DS_PARMS:
+			if (pFrame->pDSParms == NULL)
+				pFrame->pDSParms = (PWLAN_IE_DS_PARMS)pItem;
+			break;
+		case WLAN_EID_CF_PARMS:
+			if (pFrame->pCFParms == NULL)
+				pFrame->pCFParms = (PWLAN_IE_CF_PARMS)pItem;
+			break;
+		case WLAN_EID_IBSS_PARMS:
+			if (pFrame->pIBSSParms == NULL)
+				pFrame->pIBSSParms = (PWLAN_IE_IBSS_PARMS)pItem;
+			break;
+
+		case WLAN_EID_RSN:
+			if (pFrame->pRSN == NULL)
+				pFrame->pRSN = (PWLAN_IE_RSN)pItem;
+			break;
+		case WLAN_EID_RSN_WPA:
+			if (pFrame->pRSNWPA == NULL) {
+				if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+					pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
+			}
+			break;
+		case WLAN_EID_ERP:
+			if (pFrame->pERP == NULL)
+				pFrame->pERP = (PWLAN_IE_ERP)pItem;
+			break;
+		case WLAN_EID_EXTSUPP_RATES:
+			if (pFrame->pExtSuppRates == NULL)
+				pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+			break;
+
+		case WLAN_EID_COUNTRY:      /* 7 */
+			if (pFrame->pIE_Country == NULL)
+				pFrame->pIE_Country = (PWLAN_IE_COUNTRY)pItem;
+			break;
+
+		case WLAN_EID_PWR_CONSTRAINT:   /* 32 */
+			if (pFrame->pIE_PowerConstraint == NULL)
+				pFrame->pIE_PowerConstraint = (PWLAN_IE_PW_CONST)pItem;
+			break;
+
+		case WLAN_EID_CH_SWITCH:    /* 37 */
+			if (pFrame->pIE_CHSW == NULL)
+				pFrame->pIE_CHSW = (PWLAN_IE_CH_SW)pItem;
+			break;
+
+		case WLAN_EID_QUIET:        /* 40 */
+			if (pFrame->pIE_Quiet == NULL)
+				pFrame->pIE_Quiet = (PWLAN_IE_QUIET)pItem;
+			break;
+
+		case WLAN_EID_IBSS_DFS:
+			if (pFrame->pIE_IBSSDFS == NULL)
+				pFrame->pIE_IBSSDFS = (PWLAN_IE_IBSS_DFS)pItem;
+			break;
+
+		default:
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Bad EID=%dd in proberesp\n", pItem->byElementID);
+			break;
+		}
+
+		pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 +  pItem->len);
+	}
 }
 
 
@@ -817,12 +806,13 @@ vMgrEncodeAuthen(
 
     /* Fixed Fields */
     pFrame->pwAuthAlgorithm = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                      + WLAN_AUTHEN_OFF_AUTH_ALG);
+											+ WLAN_AUTHEN_OFF_AUTH_ALG);
     pFrame->pwAuthSequence = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                     + WLAN_AUTHEN_OFF_AUTH_SEQ);
+											+ WLAN_AUTHEN_OFF_AUTH_SEQ);
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_AUTHEN_OFF_STATUS);
-    pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_AUTHEN_OFF_STATUS + sizeof(*(pFrame->pwStatus));
+											+ WLAN_AUTHEN_OFF_STATUS);
+    pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_AUTHEN_OFF_STATUS
+											+ sizeof(*(pFrame->pwStatus));
 }
 
 
@@ -848,18 +838,18 @@ vMgrDecodeAuthen(
 
     /* Fixed Fields */
     pFrame->pwAuthAlgorithm = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                      + WLAN_AUTHEN_OFF_AUTH_ALG);
+											+ WLAN_AUTHEN_OFF_AUTH_ALG);
     pFrame->pwAuthSequence = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                     + WLAN_AUTHEN_OFF_AUTH_SEQ);
+											+ WLAN_AUTHEN_OFF_AUTH_SEQ);
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_AUTHEN_OFF_STATUS);
+											+ WLAN_AUTHEN_OFF_STATUS);
 
     /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                       + WLAN_AUTHEN_OFF_CHALLENGE);
-
-    if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_CHALLENGE))
-        pFrame->pChallenge = (PWLAN_IE_CHALLENGE)pItem;
+											+ WLAN_AUTHEN_OFF_CHALLENGE);
+	if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len))
+							&& (pItem->byElementID == WLAN_EID_CHALLENGE))
+			pFrame->pChallenge = (PWLAN_IE_CHALLENGE)pItem;
 }
 
 
@@ -883,8 +873,9 @@ vMgrEncodeDeauthen(
 
     /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_DEAUTHEN_OFF_REASON);
-    pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_DEAUTHEN_OFF_REASON + sizeof(*(pFrame->pwReason));
+												+ WLAN_DEAUTHEN_OFF_REASON);
+    pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_DEAUTHEN_OFF_REASON
+												+ sizeof(*(pFrame->pwReason));
 }
 
 
@@ -908,7 +899,7 @@ vMgrDecodeDeauthen(
 
     /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_DEAUTHEN_OFF_REASON);
+												+ WLAN_DEAUTHEN_OFF_REASON);
 }
 
 
@@ -932,13 +923,14 @@ vMgrEncodeReassocResponse(
 
     /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_REASSOCRESP_OFF_CAP_INFO);
+											+ WLAN_REASSOCRESP_OFF_CAP_INFO);
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_REASSOCRESP_OFF_STATUS);
+											+ WLAN_REASSOCRESP_OFF_STATUS);
     pFrame->pwAid = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                            + WLAN_REASSOCRESP_OFF_AID);
+											+ WLAN_REASSOCRESP_OFF_AID);
 
-    pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_REASSOCRESP_OFF_AID + sizeof(*(pFrame->pwAid));
+    pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_REASSOCRESP_OFF_AID
+											+ sizeof(*(pFrame->pwAid));
 }
 
 
@@ -965,19 +957,19 @@ vMgrDecodeReassocResponse(
 
     /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                + WLAN_REASSOCRESP_OFF_CAP_INFO);
+											+ WLAN_REASSOCRESP_OFF_CAP_INFO);
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                               + WLAN_REASSOCRESP_OFF_STATUS);
+											+ WLAN_REASSOCRESP_OFF_STATUS);
     pFrame->pwAid = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                            + WLAN_REASSOCRESP_OFF_AID);
+											+ WLAN_REASSOCRESP_OFF_AID);
 
     /* Information elements */
     pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
-                                               + WLAN_REASSOCRESP_OFF_SUPP_RATES);
+											+ WLAN_REASSOCRESP_OFF_SUPP_RATES);
 
     pItem = (PWLAN_IE)(pFrame->pSuppRates);
     pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
 
     if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_EXTSUPP_RATES))
-        pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+		pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
 }
-- 
1.7.12

