Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0EVQnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 12:43:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61744 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0EVQnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 12:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VU2gcnP10XxYWNHTjzBwqYkLH62uo7pqppIoZElsbVC8pMxG98LHce8ZU9kgt92yxg
         ACQJZ7rD92rT2eKFZmS6lQ9qha1AJCfo54TCQi5ymjDSZthgIW35BXzi/l/SAzB30f5j
         upHP5yq6LgNoA6mjlm0svwwZAK4YGsRY6r+8g=
From: Timofey Trofimov <tumoxep@gmail.com>
To: gregkh@suse.de, lieb@canonical.com, more.andres@gmail.com,
       forest@alittletooquiet.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Timofey Trofimov <tumoxep@gmail.com>
Subject: [PATCH] Staging: vt6656: fix brace coding style issue in 80211mgr.c This is a patch to the 80211mgr.c file that fixes up a brace warning found by the checkpatch.pl tool Signed-off-by: Timofey Trofimov <tumoxep@gmail.com>
Date: Sat, 22 May 2010 20:42:54 +0400
Message-Id: <1274546574-8338-1-git-send-email-tumoxep@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/vt6656/80211mgr.c |  514 ++++++++++++++++++-------------------
 1 files changed, 251 insertions(+), 263 deletions(-)

diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
index f24dc55..7236019 100644
--- a/drivers/staging/vt6656/80211mgr.c
+++ b/drivers/staging/vt6656/80211mgr.c
@@ -67,8 +67,8 @@
 
 /*---------------------  Static Variables  --------------------------*/
 
-static int          msglevel                =MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
+static int          msglevel                = MSG_LEVEL_INFO;
+/*static int          msglevel                =MSG_LEVEL_DEBUG;*/
 /*---------------------  Static Functions  --------------------------*/
 
 
@@ -96,7 +96,7 @@ vMgrEncodeBeacon(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                     + WLAN_BEACON_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -130,7 +130,7 @@ vMgrDecodeBeacon(
 
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                     + WLAN_BEACON_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -138,88 +138,87 @@ vMgrDecodeBeacon(
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_BEACON_OFF_CAPINFO);
 
-    // Information elements
+    /* Information elements */
     pItem = (PWLAN_IE)((PBYTE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)))
                        + WLAN_BEACON_OFF_SSID);
-    while( ((PBYTE)pItem) < (pFrame->pBuf + pFrame->len) ){
+    while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
 
         switch (pItem->byElementID) {
-            case WLAN_EID_SSID:
-                if (pFrame->pSSID == NULL)
-                    pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-                break;
-            case WLAN_EID_SUPP_RATES:
-                if (pFrame->pSuppRates == NULL)
-                    pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
-            case WLAN_EID_FH_PARMS:
-                //pFrame->pFHParms = (PWLAN_IE_FH_PARMS)pItem;
-                break;
-            case WLAN_EID_DS_PARMS:
-                if (pFrame->pDSParms == NULL)
-                    pFrame->pDSParms = (PWLAN_IE_DS_PARMS)pItem;
-                break;
-            case WLAN_EID_CF_PARMS:
-                if (pFrame->pCFParms == NULL)
-                    pFrame->pCFParms = (PWLAN_IE_CF_PARMS)pItem;
-                break;
-            case WLAN_EID_IBSS_PARMS:
-                if (pFrame->pIBSSParms == NULL)
-                    pFrame->pIBSSParms = (PWLAN_IE_IBSS_PARMS)pItem;
-                break;
-            case WLAN_EID_TIM:
-                if (pFrame->pTIM == NULL)
-                    pFrame->pTIM = (PWLAN_IE_TIM)pItem;
-                break;
-
-            case WLAN_EID_RSN:
-                if (pFrame->pRSN == NULL) {
-                    pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-                }
-                break;
-            case WLAN_EID_RSN_WPA:
-                if (pFrame->pRSNWPA == NULL) {
-                    if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
-                        pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-                }
-                break;
-
-            case WLAN_EID_ERP:
-                if (pFrame->pERP == NULL)
-                    pFrame->pERP = (PWLAN_IE_ERP)pItem;
-                break;
-            case WLAN_EID_EXTSUPP_RATES:
-                if (pFrame->pExtSuppRates == NULL)
-                    pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
-
-            case WLAN_EID_COUNTRY:      //7
-                if (pFrame->pIE_Country == NULL)
-                    pFrame->pIE_Country = (PWLAN_IE_COUNTRY)pItem;
-                break;
-
-            case WLAN_EID_PWR_CONSTRAINT:   //32
-                if (pFrame->pIE_PowerConstraint == NULL)
-                    pFrame->pIE_PowerConstraint = (PWLAN_IE_PW_CONST)pItem;
-                break;
-
-            case WLAN_EID_CH_SWITCH:    //37
-                if (pFrame->pIE_CHSW == NULL)
-                    pFrame->pIE_CHSW = (PWLAN_IE_CH_SW)pItem;
-                break;
-
-            case WLAN_EID_QUIET:        //40
-                if (pFrame->pIE_Quiet == NULL)
-                    pFrame->pIE_Quiet = (PWLAN_IE_QUIET)pItem;
-                break;
-
-            case WLAN_EID_IBSS_DFS:
-                if (pFrame->pIE_IBSSDFS == NULL)
-                    pFrame->pIE_IBSSDFS = (PWLAN_IE_IBSS_DFS)pItem;
-                break;
-
-            default:
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in beacon decode.\n", pItem->byElementID);
+        case WLAN_EID_SSID:
+            if (pFrame->pSSID == NULL)
+                pFrame->pSSID = (PWLAN_IE_SSID)pItem;
+            break;
+        case WLAN_EID_SUPP_RATES:
+            if (pFrame->pSuppRates == NULL)
+                pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+            break;
+        case WLAN_EID_FH_PARMS:
+            /* pFrame->pFHParms = (PWLAN_IE_FH_PARMS)pItem; */
+            break;
+        case WLAN_EID_DS_PARMS:
+            if (pFrame->pDSParms == NULL)
+                pFrame->pDSParms = (PWLAN_IE_DS_PARMS)pItem;
+            break;
+        case WLAN_EID_CF_PARMS:
+            if (pFrame->pCFParms == NULL)
+                pFrame->pCFParms = (PWLAN_IE_CF_PARMS)pItem;
+            break;
+        case WLAN_EID_IBSS_PARMS:
+            if (pFrame->pIBSSParms == NULL)
+                pFrame->pIBSSParms = (PWLAN_IE_IBSS_PARMS)pItem;
+            break;
+        case WLAN_EID_TIM:
+            if (pFrame->pTIM == NULL)
+                pFrame->pTIM = (PWLAN_IE_TIM)pItem;
+            break;
+
+        case WLAN_EID_RSN:
+            if (pFrame->pRSN == NULL) 
+                pFrame->pRSN = (PWLAN_IE_RSN)pItem;
+            break;
+        case WLAN_EID_RSN_WPA:
+            if (pFrame->pRSNWPA == NULL) {
+                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
+            }
+            break;
+
+        case WLAN_EID_ERP:
+            if (pFrame->pERP == NULL)
+                pFrame->pERP = (PWLAN_IE_ERP)pItem;
+            break;
+        case WLAN_EID_EXTSUPP_RATES:
+            if (pFrame->pExtSuppRates == NULL)
+                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+            break;
+
+        case WLAN_EID_COUNTRY:      /* 7 */
+            if (pFrame->pIE_Country == NULL)
+                pFrame->pIE_Country = (PWLAN_IE_COUNTRY)pItem;
+            break;
+
+        case WLAN_EID_PWR_CONSTRAINT:   /* 32 */
+            if (pFrame->pIE_PowerConstraint == NULL)
+                pFrame->pIE_PowerConstraint = (PWLAN_IE_PW_CONST)pItem;
+            break;
+
+        case WLAN_EID_CH_SWITCH:    /* 37 */
+            if (pFrame->pIE_CHSW == NULL)
+                pFrame->pIE_CHSW = (PWLAN_IE_CH_SW)pItem;
+            break;
+
+        case WLAN_EID_QUIET:        /* 40 */
+            if (pFrame->pIE_Quiet == NULL)
+                pFrame->pIE_Quiet = (PWLAN_IE_QUIET)pItem;
+            break;
+
+        case WLAN_EID_IBSS_DFS:
+            if (pFrame->pIE_IBSSDFS == NULL)
+                pFrame->pIE_IBSSDFS = (PWLAN_IE_IBSS_DFS)pItem;
+            break;
+
+        default:
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in beacon decode.\n", pItem->byElementID);
                 break;
 
         }
@@ -295,7 +294,7 @@ vMgrEncodeDisassociation(
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DISASSOC_OFF_REASON);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_DISASSOC_OFF_REASON + sizeof(*(pFrame->pwReason));
@@ -322,7 +321,7 @@ vMgrDecodeDisassociation(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DISASSOC_OFF_REASON);
 
@@ -347,7 +346,7 @@ vMgrEncodeAssocRequest(
     )
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_ASSOCREQ_OFF_CAP_INFO);
     pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -376,47 +375,46 @@ vMgrDecodeAssocRequest(
     PWLAN_IE   pItem;
 
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_ASSOCREQ_OFF_CAP_INFO);
     pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_ASSOCREQ_OFF_LISTEN_INT);
 
-    // Information elements
+    /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                             + WLAN_ASSOCREQ_OFF_SSID);
 
     while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
-        switch (pItem->byElementID){
-            case WLAN_EID_SSID:
-                if (pFrame->pSSID == NULL)
-                    pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-                break;
-            case WLAN_EID_SUPP_RATES:
-                if (pFrame->pSuppRates == NULL)
-                    pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
-
-            case WLAN_EID_RSN:
-                if (pFrame->pRSN == NULL) {
-                    pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-                }
-                break;
-            case WLAN_EID_RSN_WPA:
-                if (pFrame->pRSNWPA == NULL) {
-                    if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
-                        pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-                }
-                break;
-            case WLAN_EID_EXTSUPP_RATES:
-                if (pFrame->pExtSuppRates == NULL)
-                    pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
-
-            default:
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in assocreq decode.\n",
-                        pItem->byElementID);
-                break;
+        switch (pItem->byElementID) {
+        case WLAN_EID_SSID:
+            if (pFrame->pSSID == NULL)
+                pFrame->pSSID = (PWLAN_IE_SSID)pItem;
+            break;
+        case WLAN_EID_SUPP_RATES:
+            if (pFrame->pSuppRates == NULL)
+                pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+            break;
+
+        case WLAN_EID_RSN:
+            if (pFrame->pRSN == NULL)
+                pFrame->pRSN = (PWLAN_IE_RSN)pItem;
+            break;
+        case WLAN_EID_RSN_WPA:
+            if (pFrame->pRSNWPA == NULL) {
+                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
+            }
+            break;
+        case WLAN_EID_EXTSUPP_RATES:
+            if (pFrame->pExtSuppRates == NULL)
+                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+            break;
+
+        default:
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in assocreq decode.\n",
+                    pItem->byElementID);
+            break;
         }
         pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
     }
@@ -441,7 +439,7 @@ vMgrEncodeAssocResponse(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_ASSOCRESP_OFF_CAP_INFO);
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -475,7 +473,7 @@ vMgrDecodeAssocResponse(
 
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_ASSOCRESP_OFF_CAP_INFO);
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -483,7 +481,7 @@ vMgrDecodeAssocResponse(
     pFrame->pwAid = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                             + WLAN_ASSOCRESP_OFF_AID);
 
-    // Information elements
+    /* Information elements */
     pFrame->pSuppRates  = (PWLAN_IE_SUPP_RATES)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                            + WLAN_ASSOCRESP_OFF_SUPP_RATES);
 
@@ -493,8 +491,7 @@ vMgrDecodeAssocResponse(
     if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_EXTSUPP_RATES)) {
         pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pFrame->pExtSuppRates=[%p].\n", pItem);
-    }
-    else {
+    } else {
         pFrame->pExtSuppRates = NULL;
     }
     return;
@@ -519,7 +516,7 @@ vMgrEncodeReassocRequest(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_REASSOCREQ_OFF_CAP_INFO);
     pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -552,7 +549,7 @@ vMgrDecodeReassocRequest(
     PWLAN_IE   pItem;
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_REASSOCREQ_OFF_CAP_INFO);
     pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -560,42 +557,41 @@ vMgrDecodeReassocRequest(
     pFrame->pAddrCurrAP = (PIEEE_ADDR)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                        + WLAN_REASSOCREQ_OFF_CURR_AP);
 
-    // Information elements
+    /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                        + WLAN_REASSOCREQ_OFF_SSID);
 
-    while(((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
-
-        switch (pItem->byElementID){
-            case WLAN_EID_SSID:
-                if (pFrame->pSSID == NULL)
-                    pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-                break;
-            case WLAN_EID_SUPP_RATES:
-                if (pFrame->pSuppRates == NULL)
-                    pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
-
-            case WLAN_EID_RSN:
-                if (pFrame->pRSN == NULL) {
-                    pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-                }
-                break;
-            case WLAN_EID_RSN_WPA:
-                if (pFrame->pRSNWPA == NULL) {
-                    if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
-                        pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-                }
-                break;
+    while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
 
-            case WLAN_EID_EXTSUPP_RATES:
-                if (pFrame->pExtSuppRates == NULL)
-                    pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
-            default:
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in reassocreq decode.\n",
-                            pItem->byElementID);
-                break;
+        switch (pItem->byElementID) {
+        case WLAN_EID_SSID:
+            if (pFrame->pSSID == NULL)
+                pFrame->pSSID = (PWLAN_IE_SSID)pItem;
+            break;
+        case WLAN_EID_SUPP_RATES:
+            if (pFrame->pSuppRates == NULL)
+                pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+            break;
+
+        case WLAN_EID_RSN:
+            if (pFrame->pRSN == NULL)
+                pFrame->pRSN = (PWLAN_IE_RSN)pItem;
+            break;
+        case WLAN_EID_RSN_WPA:
+            if (pFrame->pRSNWPA == NULL) {
+                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
+            }
+            break;
+
+        case WLAN_EID_EXTSUPP_RATES:
+            if (pFrame->pExtSuppRates == NULL)
+                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+            break;
+        default:
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Unrecognized EID=%dd in reassocreq decode.\n",
+                        pItem->byElementID);
+            break;
         }
         pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
     }
@@ -646,30 +642,30 @@ vMgrDecodeProbeRequest(
 
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Information elements
+    /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3)));
 
-    while( ((PBYTE)pItem) < (pFrame->pBuf + pFrame->len) ) {
+    while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
 
         switch (pItem->byElementID) {
-            case WLAN_EID_SSID:
-                if (pFrame->pSSID == NULL)
-                    pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-                break;
+        case WLAN_EID_SSID:
+            if (pFrame->pSSID == NULL)
+                pFrame->pSSID = (PWLAN_IE_SSID)pItem;
+            break;
 
-            case WLAN_EID_SUPP_RATES:
-                if (pFrame->pSuppRates == NULL)
-                    pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
+        case WLAN_EID_SUPP_RATES:
+            if (pFrame->pSuppRates == NULL)
+                pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+            break;
 
-            case WLAN_EID_EXTSUPP_RATES:
-                if (pFrame->pExtSuppRates == NULL)
-                    pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
+        case WLAN_EID_EXTSUPP_RATES:
+            if (pFrame->pExtSuppRates == NULL)
+                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+            break;
 
-            default:
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Bad EID=%dd in probereq\n", pItem->byElementID);
-                break;
+        default:
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Bad EID=%dd in probereq\n", pItem->byElementID);
+            break;
         }
 
         pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 +  pItem->len);
@@ -697,7 +693,7 @@ vMgrEncodeProbeResponse(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                     + WLAN_PROBERESP_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -734,7 +730,7 @@ vMgrDecodeProbeResponse(
 
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pqwTimestamp = (PQWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                     + WLAN_PROBERESP_OFF_TS);
     pFrame->pwBeaconInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -742,83 +738,82 @@ vMgrDecodeProbeResponse(
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_PROBERESP_OFF_CAP_INFO);
 
-    // Information elements
+    /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                        + WLAN_PROBERESP_OFF_SSID);
 
-    while( ((PBYTE)pItem) < (pFrame->pBuf + pFrame->len) ) {
+    while (((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) {
         switch (pItem->byElementID) {
-            case WLAN_EID_SSID:
-                if (pFrame->pSSID == NULL)
+        case WLAN_EID_SSID:
+            if (pFrame->pSSID == NULL)
                 pFrame->pSSID = (PWLAN_IE_SSID)pItem;
-                break;
-            case WLAN_EID_SUPP_RATES:
-                if (pFrame->pSuppRates == NULL)
+            break;
+        case WLAN_EID_SUPP_RATES:
+            if (pFrame->pSuppRates == NULL)
                 pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
-            case WLAN_EID_FH_PARMS:
-                break;
-            case WLAN_EID_DS_PARMS:
-                if (pFrame->pDSParms == NULL)
-                    pFrame->pDSParms = (PWLAN_IE_DS_PARMS)pItem;
-                break;
-            case WLAN_EID_CF_PARMS:
-                if (pFrame->pCFParms == NULL)
-                    pFrame->pCFParms = (PWLAN_IE_CF_PARMS)pItem;
-                break;
-            case WLAN_EID_IBSS_PARMS:
-                if (pFrame->pIBSSParms == NULL)
-                    pFrame->pIBSSParms = (PWLAN_IE_IBSS_PARMS)pItem;
-                break;
-
-            case WLAN_EID_RSN:
-                if (pFrame->pRSN == NULL) {
-                    pFrame->pRSN = (PWLAN_IE_RSN)pItem;
-                }
-                break;
-            case WLAN_EID_RSN_WPA:
-                if (pFrame->pRSNWPA == NULL) {
-                    if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
-                        pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-                }
-                break;
-            case WLAN_EID_ERP:
-                if (pFrame->pERP == NULL)
-                    pFrame->pERP = (PWLAN_IE_ERP)pItem;
-                break;
-            case WLAN_EID_EXTSUPP_RATES:
-                if (pFrame->pExtSuppRates == NULL)
-                    pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-                break;
-
-            case WLAN_EID_COUNTRY:      //7
-                if (pFrame->pIE_Country == NULL)
-                    pFrame->pIE_Country = (PWLAN_IE_COUNTRY)pItem;
-                break;
-
-            case WLAN_EID_PWR_CONSTRAINT:   //32
-                if (pFrame->pIE_PowerConstraint == NULL)
-                    pFrame->pIE_PowerConstraint = (PWLAN_IE_PW_CONST)pItem;
-                break;
-
-            case WLAN_EID_CH_SWITCH:    //37
-                if (pFrame->pIE_CHSW == NULL)
-                    pFrame->pIE_CHSW = (PWLAN_IE_CH_SW)pItem;
-                break;
-
-            case WLAN_EID_QUIET:        //40
-                if (pFrame->pIE_Quiet == NULL)
-                    pFrame->pIE_Quiet = (PWLAN_IE_QUIET)pItem;
-                break;
-
-            case WLAN_EID_IBSS_DFS:
-                if (pFrame->pIE_IBSSDFS == NULL)
-                    pFrame->pIE_IBSSDFS = (PWLAN_IE_IBSS_DFS)pItem;
-                break;
-
-            default:
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Bad EID=%dd in proberesp\n", pItem->byElementID);
-                break;
+            break;
+        case WLAN_EID_FH_PARMS:
+            break;
+        case WLAN_EID_DS_PARMS:
+            if (pFrame->pDSParms == NULL)
+                pFrame->pDSParms = (PWLAN_IE_DS_PARMS)pItem;
+            break;
+        case WLAN_EID_CF_PARMS:
+            if (pFrame->pCFParms == NULL)
+                pFrame->pCFParms = (PWLAN_IE_CF_PARMS)pItem;
+            break;
+        case WLAN_EID_IBSS_PARMS:
+            if (pFrame->pIBSSParms == NULL)
+                pFrame->pIBSSParms = (PWLAN_IE_IBSS_PARMS)pItem;
+            break;
+
+        case WLAN_EID_RSN:
+            if (pFrame->pRSN == NULL)
+                pFrame->pRSN = (PWLAN_IE_RSN)pItem;
+            break;
+        case WLAN_EID_RSN_WPA:
+            if (pFrame->pRSNWPA == NULL) {
+                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
+            }
+            break;
+        case WLAN_EID_ERP:
+            if (pFrame->pERP == NULL)
+                pFrame->pERP = (PWLAN_IE_ERP)pItem;
+            break;
+        case WLAN_EID_EXTSUPP_RATES:
+            if (pFrame->pExtSuppRates == NULL)
+                pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
+            break;
+
+        case WLAN_EID_COUNTRY:      /* 7 */
+            if (pFrame->pIE_Country == NULL)
+                pFrame->pIE_Country = (PWLAN_IE_COUNTRY)pItem;
+            break;
+
+        case WLAN_EID_PWR_CONSTRAINT:   /* 32 */
+            if (pFrame->pIE_PowerConstraint == NULL)
+                pFrame->pIE_PowerConstraint = (PWLAN_IE_PW_CONST)pItem;
+            break;
+
+        case WLAN_EID_CH_SWITCH:    /* 37 */
+            if (pFrame->pIE_CHSW == NULL)
+                pFrame->pIE_CHSW = (PWLAN_IE_CH_SW)pItem;
+            break;
+
+        case WLAN_EID_QUIET:        /* 40 */
+            if (pFrame->pIE_Quiet == NULL)
+                pFrame->pIE_Quiet = (PWLAN_IE_QUIET)pItem;
+            break;
+
+        case WLAN_EID_IBSS_DFS:
+            if (pFrame->pIE_IBSSDFS == NULL)
+                pFrame->pIE_IBSSDFS = (PWLAN_IE_IBSS_DFS)pItem;
+            break;
+
+        default:
+            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Bad EID=%dd in proberesp\n", pItem->byElementID);
+            break;
         }
 
         pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 +  pItem->len);
@@ -845,7 +840,7 @@ vMgrEncodeAuthen(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwAuthAlgorithm = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                       + WLAN_AUTHEN_OFF_AUTH_ALG);
     pFrame->pwAuthSequence = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -853,7 +848,6 @@ vMgrEncodeAuthen(
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_AUTHEN_OFF_STATUS);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_AUTHEN_OFF_STATUS + sizeof(*(pFrame->pwStatus));
-
     return;
 }
 
@@ -878,7 +872,7 @@ vMgrDecodeAuthen(
 
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwAuthAlgorithm = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                       + WLAN_AUTHEN_OFF_AUTH_ALG);
     pFrame->pwAuthSequence = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -886,14 +880,12 @@ vMgrDecodeAuthen(
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_AUTHEN_OFF_STATUS);
 
-    // Information elements
+    /* Information elements */
     pItem = (PWLAN_IE)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                        + WLAN_AUTHEN_OFF_CHALLENGE);
 
-    if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_CHALLENGE)) {
+    if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_CHALLENGE))
         pFrame->pChallenge = (PWLAN_IE_CHALLENGE)pItem;
-    }
-
     return;
 }
 
@@ -916,11 +908,10 @@ vMgrEncodeDeauthen(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DEAUTHEN_OFF_REASON);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_DEAUTHEN_OFF_REASON + sizeof(*(pFrame->pwReason));
-
     return;
 }
 
@@ -943,10 +934,9 @@ vMgrDecodeDeauthen(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DEAUTHEN_OFF_REASON);
-
     return;
 }
 
@@ -969,7 +959,7 @@ vMgrEncodeReassocResponse(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_REASSOCRESP_OFF_CAP_INFO);
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -978,7 +968,6 @@ vMgrEncodeReassocResponse(
                             + WLAN_REASSOCRESP_OFF_AID);
 
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_REASSOCRESP_OFF_AID + sizeof(*(pFrame->pwAid));
-
     return;
 }
 
@@ -1004,7 +993,7 @@ vMgrDecodeReassocResponse(
 
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-    // Fixed Fields
+    /* Fixed Fields */
     pFrame->pwCapInfo = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                 + WLAN_REASSOCRESP_OFF_CAP_INFO);
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
@@ -1012,15 +1001,14 @@ vMgrDecodeReassocResponse(
     pFrame->pwAid = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                             + WLAN_REASSOCRESP_OFF_AID);
 
-    //Information elements
+    /* Information elements */
     pFrame->pSuppRates = (PWLAN_IE_SUPP_RATES)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                                + WLAN_REASSOCRESP_OFF_SUPP_RATES);
 
     pItem = (PWLAN_IE)(pFrame->pSuppRates);
     pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
 
-    if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_EXTSUPP_RATES)) {
+    if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_EXTSUPP_RATES))
         pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-    }
     return;
 }
-- 
1.7.0.4

