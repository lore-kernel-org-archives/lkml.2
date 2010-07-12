Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0GLV1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:27:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60558 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0GLV1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s0JN/6RMdbbVzX3goo1Z7GUjMzLhia5TFP0lcX5XMmAm0pCfDrD77LX9nF3g2A+kfy
         9uzyiD8Zb0ov+DyiybyqNJOEhn9/Kjy0EYpd3Yw/MkICD+lecuRtHN/e1iZPOo1Yurx3
         4TSanNHu4O2Zxy546G6hGFoNzm6L0BIvqU8cc=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>, linux-kernel@vger.kernel.org,
        Roel Van Nyen <roel.vannyen@gmail.com>
Subject: [PATCH] Staging: vt6656: Change the define FALSE and TRUE to the lower case variant.
Date: Mon, 12 Jul 2010 23:26:37 +0200
Message-Id: <1278969997-24254-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the TRUE and FALSE define from the ttype.h

Signed-of-by: Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/vt6656/80211mgr.c   |    8 +-
 drivers/staging/vt6656/aes_ccmp.c   |    8 +-
 drivers/staging/vt6656/baseband.c   |   16 +-
 drivers/staging/vt6656/bssdb.c      |  154 ++++++++--------
 drivers/staging/vt6656/card.c       |   60 +++---
 drivers/staging/vt6656/channel.c    |  146 ++++++++--------
 drivers/staging/vt6656/datarate.c   |   18 +-
 drivers/staging/vt6656/device_cfg.h |    8 +-
 drivers/staging/vt6656/dpc.c        |  176 +++++++++---------
 drivers/staging/vt6656/firmware.c   |   16 +-
 drivers/staging/vt6656/hostap.c     |   50 +++---
 drivers/staging/vt6656/int.c        |   12 +-
 drivers/staging/vt6656/ioctl.c      |   68 ++++----
 drivers/staging/vt6656/iwctl.c      |  100 +++++-----
 drivers/staging/vt6656/key.c        |  178 +++++++++---------
 drivers/staging/vt6656/mac.c        |    4 +-
 drivers/staging/vt6656/main_usb.c   |  174 +++++++++---------
 drivers/staging/vt6656/power.c      |   46 +++---
 drivers/staging/vt6656/rf.c         |   30 ++--
 drivers/staging/vt6656/rxtx.c       |  222 +++++++++++-----------
 drivers/staging/vt6656/tether.c     |    6 +-
 drivers/staging/vt6656/ttype.h      |    7 -
 drivers/staging/vt6656/usbpipe.c    |   34 ++--
 drivers/staging/vt6656/wcmd.c       |  170 +++++++++---------
 drivers/staging/vt6656/wctl.c       |   36 ++--
 drivers/staging/vt6656/wmgr.c       |  348 +++++++++++++++++-----------------
 drivers/staging/vt6656/wpa.c        |   26 ++--
 drivers/staging/vt6656/wpa2.c       |   22 +-
 drivers/staging/vt6656/wpactl.c     |   44 +++---
 29 files changed, 1090 insertions(+), 1097 deletions(-)

diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
index fceec49..c6f4c5d 100644
--- a/drivers/staging/vt6656/80211mgr.c
+++ b/drivers/staging/vt6656/80211mgr.c
@@ -178,7 +178,7 @@ vMgrDecodeBeacon(
             break;
         case WLAN_EID_RSN_WPA:
             if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
                     pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
             }
             break;
@@ -402,7 +402,7 @@ vMgrDecodeAssocRequest(
             break;
         case WLAN_EID_RSN_WPA:
             if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
                     pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
             }
             break;
@@ -579,7 +579,7 @@ vMgrDecodeReassocRequest(
             break;
         case WLAN_EID_RSN_WPA:
             if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
                     pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
             }
             break;
@@ -773,7 +773,7 @@ vMgrDecodeProbeResponse(
             break;
         case WLAN_EID_RSN_WPA:
             if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
+                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
                     pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
             }
             break;
diff --git a/drivers/staging/vt6656/aes_ccmp.c b/drivers/staging/vt6656/aes_ccmp.c
index f7a3b8f..55ee099 100644
--- a/drivers/staging/vt6656/aes_ccmp.c
+++ b/drivers/staging/vt6656/aes_ccmp.c
@@ -249,7 +249,7 @@ BOOL AESbGenCCMP(PBYTE pbyRxKey, PBYTE pbyFrame, WORD wFrameSize)
 	WORD            wHLen = 22;
 	/* 8 is IV, 8 is MIC, 4 is CRC */
 	WORD            wPayloadSize = wFrameSize - 8 - 8 - 4 - WLAN_HDR_ADDR3_LEN;
-	BOOL            bA4 = FALSE;
+	BOOL            bA4 = false;
 	BYTE            byTmp;
 	WORD            wCnt;
 	int             ii, jj, kk;
@@ -257,7 +257,7 @@ BOOL AESbGenCCMP(PBYTE pbyRxKey, PBYTE pbyFrame, WORD wFrameSize)
 	pbyIV = pbyFrame + WLAN_HDR_ADDR3_LEN;
 	if (WLAN_GET_FC_TODS(*(PWORD) pbyFrame) &&
 	    WLAN_GET_FC_FROMDS(*(PWORD) pbyFrame)) {
-		bA4 = TRUE;
+		bA4 = true;
 		pbyIV += 6;             /* 6 is 802.11 address4 */
 		wHLen += 6;
 		wPayloadSize -= 6;
@@ -380,7 +380,7 @@ BOOL AESbGenCCMP(PBYTE pbyRxKey, PBYTE pbyFrame, WORD wFrameSize)
 	/* => above is the packet dec-MIC */
 
 	if (!memcmp(abyMIC, abyTmp, 8))
-		return TRUE;
+		return true;
 	else
-		return FALSE;
+		return false;
 }
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index d3de94f..a64fd25 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -775,7 +775,7 @@ BBvCaculateParameter (
     BOOL bCCK = pDevice->bCCK;
 
     cbBitCount = cbFrameLength * 8;
-    bExtBit = FALSE;
+    bExtBit = false;
 
     switch (wRate) {
     case RATE_1M :
@@ -792,7 +792,7 @@ BBvCaculateParameter (
         break;
 
     case RATE_5M :
-        if (bCCK == FALSE)
+        if (bCCK == false)
             cbBitCount ++;
         cbUsCount = (cbBitCount * 10) / 55;
         cbTmp = (cbUsCount * 55) / 10;
@@ -806,14 +806,14 @@ BBvCaculateParameter (
 
     case RATE_11M :
 
-        if (bCCK == FALSE)
+        if (bCCK == false)
             cbBitCount ++;
         cbUsCount = cbBitCount / 11;
         cbTmp = cbUsCount * 11;
         if (cbTmp != cbBitCount) {
             cbUsCount ++;
             if ((cbBitCount - cbTmp) <= 3)
-                bExtBit = TRUE;
+                bExtBit = true;
         }
         if (byPreambleType == 1)
             *pbyPhySgn = 0x0b;
@@ -1006,13 +1006,13 @@ BBbVT3184Init (PSDevice pDevice)
                                   EEP_MAX_CONTEXT_SIZE,
                                   pDevice->abyEEPROM);
     if (ntStatus != STATUS_SUCCESS) {
-        return FALSE;
+        return false;
     }
 
 
     //20080215-01,<Add> by Mike Liu
 //    if ((pDevice->abyEEPROM[EEP_OFS_RADIOCTL]&0x06)==0x04)
-//        return FALSE;
+//        return false;
 
 //20080804-01,<Add> by Mike Liu
 //zonetype initial
@@ -1129,7 +1129,7 @@ else {
         MACvRegBitsOn(pDevice, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
     //}}
     } else {
-        return TRUE;
+        return true;
     }
 
    memcpy(abyArray, pbyAddr, wLength);
@@ -1168,7 +1168,7 @@ else {
     ControlvWriteByte(pDevice,MESSAGE_REQUEST_BBREG,0x0D,0x01);
 
     RFbRFTableDownload(pDevice);
-    return TRUE;//ntStatus;
+    return true;//ntStatus;
 }
 
 
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 830dd23..f880a53 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -146,16 +146,16 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
         }
     }
 
-    if ((pbyBSSID != NULL)&&(pDevice->bRoaming == FALSE)) {
+    if ((pbyBSSID != NULL)&&(pDevice->bRoaming == false)) {
         // match BSSID first
         for (ii = 0; ii <MAX_BSS_NUM; ii++) {
             pCurrBSS = &(pMgmt->sBSSList[ii]);
 
 	//2008-0718-01<Add>by MikeLiu
-	   pCurrBSS->bSelected = FALSE;
+	   pCurrBSS->bSelected = false;
 
             if ((pCurrBSS->bActive) &&
-                (pCurrBSS->bSelected == FALSE)) {
+                (pCurrBSS->bSelected == false)) {
 		    if (!compare_ether_addr(pCurrBSS->abyBSSID, pbyBSSID)) {
                     if (pSSID != NULL) {
                         // compare ssid
@@ -166,7 +166,7 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
                                 ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
                                 ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
                                 ) {
-                                pCurrBSS->bSelected = TRUE;
+                                pCurrBSS->bSelected = true;
                                 return(pCurrBSS);
                             }
                         }
@@ -175,7 +175,7 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
                             ((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
                             ((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))
                             ) {
-                            pCurrBSS->bSelected = TRUE;
+                            pCurrBSS->bSelected = true;
                             return(pCurrBSS);
                         }
                     }
@@ -189,10 +189,10 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
 
            //2007-0721-01<Mark>by MikeLiu
          //   if ((pCurrBSS->bActive) &&
-         //       (pCurrBSS->bSelected == FALSE)) {
+         //       (pCurrBSS->bSelected == false)) {
 
 	//2007-0721-01<Add>by MikeLiu
-	  pCurrBSS->bSelected = FALSE;
+	  pCurrBSS->bSelected = false;
           if (pCurrBSS->bActive) {
 
                 if (pSSID != NULL) {
@@ -223,19 +223,19 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
                 }
 /*
                 if (pMgmt->eAuthenMode < WMAC_AUTH_WPA) {
-                    if (pCurrBSS->bWPAValid == TRUE) {
+                    if (pCurrBSS->bWPAValid == true) {
                         // WPA AP will reject connection of station without WPA enable.
                         continue;
                     }
                 } else if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA) ||
                            (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK)) {
-                    if (pCurrBSS->bWPAValid == FALSE) {
+                    if (pCurrBSS->bWPAValid == false) {
                         // station with WPA enable can't join NonWPA AP.
                         continue;
                     }
                 } else if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) ||
                            (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {
-                    if (pCurrBSS->bWPA2Valid == FALSE) {
+                    if (pCurrBSS->bWPA2Valid == false) {
                         // station with WPA2 enable can't join NonWPA2 AP.
                         continue;
                     }
@@ -261,8 +261,8 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
 pDevice->bSameBSSMaxNum = jj;
 //DavidWang
         if (pSelect != NULL) {
-            pSelect->bSelected = TRUE;
-                        if (pDevice->bRoaming == FALSE)  {
+            pSelect->bSelected = true;
+                        if (pDevice->bRoaming == false)  {
 	//       Einsn Add @20070907
 				memset(pbyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 			memcpy(pbyDesireSSID,pCurrBSS->abySSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1) ;
@@ -301,7 +301,7 @@ void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID)
  //mike mark: there are two same BSSID in list if that AP is in hidden ssid mode,one 's SSID is null,
  //                 but other's is obvious, so if it acssociate with your STA  exactly,you must keep two
  //                 of them!!!!!!!!!
-               // bKeepCurrBSSID = FALSE;
+               // bKeepCurrBSSID = false;
                 continue;
             }
         }
@@ -311,7 +311,7 @@ void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID)
              continue;
         }
 */
-        pMgmt->sBSSList[ii].bActive = FALSE;
+        pMgmt->sBSSList[ii].bActive = false;
         memset(&pMgmt->sBSSList[ii], 0, sizeof(KnownBSS));
     }
     BSSvClearAnyBSSJoinRecord(pDevice);
@@ -327,7 +327,7 @@ void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID)
  *    search BSS list by BSSID & SSID if matched
  *
  * Return Value:
- *    TRUE if found.
+ *    true if found.
  *
 -*/
 PKnownBSS BSSpAddrIsInBSSList(void *hDeviceContext,
@@ -364,7 +364,7 @@ PKnownBSS BSSpAddrIsInBSSList(void *hDeviceContext,
  *    Insert a BSS set into known BSS list
  *
  * Return Value:
- *    TRUE if success.
+ *    true if success.
  *
 -*/
 
@@ -392,7 +392,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
     PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
     PKnownBSS       pBSSList = NULL;
     unsigned int            ii;
-    BOOL            bParsingQuiet = FALSE;
+    BOOL            bParsingQuiet = false;
 
 
 
@@ -406,10 +406,10 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 
     if (ii == MAX_BSS_NUM){
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Get free KnowBSS node failed.\n");
-        return FALSE;
+        return false;
     }
     // save the BSS info
-    pBSSList->bActive = TRUE;
+    pBSSList->bActive = true;
     memcpy( pBSSList->abyBSSID, abyBSSIDAddr, WLAN_BSSID_LEN);
     HIDWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(HIDWORD(qwTimestamp));
     LODWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(LODWORD(qwTimestamp));
@@ -443,7 +443,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
     if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
         pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
     } else {
-        if (pBSSList->sERP.bERPExist == TRUE) {
+        if (pBSSList->sERP.bERPExist == true) {
             pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
         } else {
             pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
@@ -459,7 +459,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
         (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
         // assoc with BSS
         if (pBSSList == pMgmt->pCurrBSS) {
-            bParsingQuiet = TRUE;
+            bParsingQuiet = true;
         }
     }
 
@@ -489,27 +489,27 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 	}
     }
 
-    if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) || (pBSSList->bWPA2Valid == TRUE)) {
+    if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) || (pBSSList->bWPA2Valid == true)) {
 
         PSKeyItem  pTransmitKey = NULL;
-        BOOL       bIs802_1x = FALSE;
+        BOOL       bIs802_1x = false;
 
         for (ii = 0; ii < pBSSList->wAKMSSAuthCount; ii ++) {
             if (pBSSList->abyAKMSSAuthType[ii] == WLAN_11i_AKMSS_802_1X) {
-                bIs802_1x = TRUE;
+                bIs802_1x = true;
                 break;
             }
         }
-        if ((bIs802_1x == TRUE) && (pSSID->len == ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->len) &&
+        if ((bIs802_1x == true) && (pSSID->len == ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->len) &&
             ( !memcmp(pSSID->abySSID, ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySSID, pSSID->len))) {
 
 		bAdd_PMKID_Candidate((void *) pDevice,
 				     pBSSList->abyBSSID,
 				     &pBSSList->sRSNCapObj);
 
-            if ((pDevice->bLinkPass == TRUE) && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
-                if ((KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, PAIRWISE_KEY, &pTransmitKey) == TRUE) ||
-                    (KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, GROUP_KEY, &pTransmitKey) == TRUE)) {
+            if ((pDevice->bLinkPass == true) && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
+                if ((KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, PAIRWISE_KEY, &pTransmitKey) == true) ||
+                    (KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBSSID, GROUP_KEY, &pTransmitKey) == true)) {
                     pDevice->gsPMKIDCandidate.StatusType = Ndis802_11StatusType_PMKID_CandidateList;
                     pDevice->gsPMKIDCandidate.Version = 1;
 
@@ -531,20 +531,20 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 
 /*
     if ((pIE_Country != NULL) &&
-        (pMgmt->b11hEnable == TRUE)) {
+        (pMgmt->b11hEnable == true)) {
         CARDvSetCountryInfo(pMgmt->pAdapter,
                             pBSSList->eNetworkTypeInUse,
                             pIE_Country);
     }
 
-    if ((bParsingQuiet == TRUE) && (pIE_Quiet != NULL)) {
+    if ((bParsingQuiet == true) && (pIE_Quiet != NULL)) {
         if ((((PWLAN_IE_QUIET)pIE_Quiet)->len == 8) &&
             (((PWLAN_IE_QUIET)pIE_Quiet)->byQuietCount != 0)) {
             // valid EID
             if (pQuiet == NULL) {
                 pQuiet = (PWLAN_IE_QUIET)pIE_Quiet;
                 CARDbSetQuiet(  pMgmt->pAdapter,
-                                TRUE,
+                                true,
                                 pQuiet->byQuietCount,
                                 pQuiet->byQuietPeriod,
                                 *((PWORD)pQuiet->abyQuietDuration),
@@ -553,7 +553,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
             } else {
                 pQuiet = (PWLAN_IE_QUIET)pIE_Quiet;
                 CARDbSetQuiet(  pMgmt->pAdapter,
-                                FALSE,
+                                false,
                                 pQuiet->byQuietCount,
                                 pQuiet->byQuietPeriod,
                                 *((PWORD)pQuiet->abyQuietDuration),
@@ -563,7 +563,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
         }
     }
 
-    if ((bParsingQuiet == TRUE) &&
+    if ((bParsingQuiet == true) &&
         (pQuiet != NULL)) {
         CARDbStartQuiet(pMgmt->pAdapter);
     }
@@ -574,7 +574,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
         pBSSList->uIELength = WLAN_BEACON_FR_MAXLEN;
     memcpy(pBSSList->abyIEs, pbyIEs, pBSSList->uIELength);
 
-    return TRUE;
+    return true;
 }
 
 
@@ -584,7 +584,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
  *    Update BSS set in known BSS list
  *
  * Return Value:
- *    TRUE if success.
+ *    true if success.
  *
 -*/
 // TODO: input structure modify
@@ -613,12 +613,12 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
     PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
     signed long            ldBm, ldBmSum;
-    BOOL            bParsingQuiet = FALSE;
+    BOOL            bParsingQuiet = false;
   //  BYTE            abyTmpSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 
 
     if (pBSSList == NULL)
-        return FALSE;
+        return false;
 
 
     HIDWORD(pBSSList->qwBSSTimestamp) = cpu_to_le32(HIDWORD(qwTimestamp));
@@ -648,7 +648,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
     if (pBSSList->uChannel > CB_MAX_CHANNEL_24G) {
         pBSSList->eNetworkTypeInUse = PHY_TYPE_11A;
     } else {
-        if (pBSSList->sERP.bERPExist == TRUE) {
+        if (pBSSList->sERP.bERPExist == true) {
             pBSSList->eNetworkTypeInUse = PHY_TYPE_11G;
         } else {
             pBSSList->eNetworkTypeInUse = PHY_TYPE_11B;
@@ -665,7 +665,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
         (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
         // assoc with BSS
         if (pBSSList == pMgmt->pCurrBSS) {
-            bParsingQuiet = TRUE;
+            bParsingQuiet = true;
         }
     }
 
@@ -717,7 +717,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
         pBSSList->uIELength = WLAN_BEACON_FR_MAXLEN;
     memcpy(pBSSList->abyIEs, pbyIEs, pBSSList->uIELength);
 
-    return TRUE;
+    return true;
 }
 
 
@@ -748,12 +748,12 @@ BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
 		if (!compare_ether_addr(abyDstAddr,
 					pMgmt->sNodeDBTable[ii].abyMACAddr)) {
                 *puNodeIndex = ii;
-                return TRUE;
+                return true;
             }
         }
     }
 
-   return FALSE;
+   return false;
 };
 
 
@@ -807,7 +807,7 @@ void BSSvCreateOneNode(void *hDeviceContext, PUINT puNodeIndex)
     }
 
     memset(&pMgmt->sNodeDBTable[*puNodeIndex], 0, sizeof(KnownNodeDB));
-    pMgmt->sNodeDBTable[*puNodeIndex].bActive = TRUE;
+    pMgmt->sNodeDBTable[*puNodeIndex].bActive = true;
     pMgmt->sNodeDBTable[*puNodeIndex].uRatePollTimeout = FALLBACK_POLL_SECOND;
     // for AP mode PS queue
     skb_queue_head_init(&pMgmt->sNodeDBTable[*puNodeIndex].sTxPSQueue);
@@ -870,7 +870,7 @@ void BSSvUpdateAPNode(void *hDeviceContext,
 
     memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
 
-    pMgmt->sNodeDBTable[0].bActive = TRUE;
+    pMgmt->sNodeDBTable[0].bActive = true;
     if (pDevice->byBBType == BB_TYPE_11B) {
         uRateLen = WLAN_RATES_MAXLEN_11B;
     }
@@ -883,7 +883,7 @@ void BSSvUpdateAPNode(void *hDeviceContext,
     RATEvParseMaxRate((void *) pDevice,
                        (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
                        (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
-                       TRUE,
+                       true,
                        &(pMgmt->sNodeDBTable[0].wMaxBasicRate),
                        &(pMgmt->sNodeDBTable[0].wMaxSuppRate),
                        &(pMgmt->sNodeDBTable[0].wSuppRate),
@@ -919,13 +919,13 @@ void BSSvAddMulticastNode(void *hDeviceContext)
     if (!pDevice->bEnableHostWEP)
         memset(&pMgmt->sNodeDBTable[0], 0, sizeof(KnownNodeDB));
     memset(pMgmt->sNodeDBTable[0].abyMACAddr, 0xff, WLAN_ADDR_LEN);
-    pMgmt->sNodeDBTable[0].bActive = TRUE;
-    pMgmt->sNodeDBTable[0].bPSEnable = FALSE;
+    pMgmt->sNodeDBTable[0].bActive = true;
+    pMgmt->sNodeDBTable[0].bPSEnable = false;
     skb_queue_head_init(&pMgmt->sNodeDBTable[0].sTxPSQueue);
     RATEvParseMaxRate((void *) pDevice,
                       (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
                       (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
-                      TRUE,
+                      true,
                       &(pMgmt->sNodeDBTable[0].wMaxBasicRate),
                       &(pMgmt->sNodeDBTable[0].wMaxSuppRate),
                        &(pMgmt->sNodeDBTable[0].wSuppRate),
@@ -966,11 +966,11 @@ void BSSvSecondCallBack(void *hDeviceContext)
     pDevice->uAssocCount = 0;
 
     //Power Saving Mode Tx Burst
-    if ( pDevice->bEnablePSMode == TRUE ) {
+    if ( pDevice->bEnablePSMode == true ) {
         pDevice->ulPSModeWaitTx++;
         if ( pDevice->ulPSModeWaitTx >= 2 ) {
             pDevice->ulPSModeWaitTx = 0;
-            pDevice->bPSModeTxBurst = FALSE;
+            pDevice->bPSModeTxBurst = false;
         }
     }
 
@@ -987,11 +987,11 @@ void BSSvSecondCallBack(void *hDeviceContext)
 
 if(pDevice->byReAssocCount > 0) {
        pDevice->byReAssocCount++;
-   if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != TRUE)) {  //10 sec timeout
+   if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  //10 sec timeout
                      printk("Re-association timeout!!!\n");
 		   pDevice->byReAssocCount = 0;
                      #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-                    // if(pDevice->bWPASuppWextEnabled == TRUE)
+                    // if(pDevice->bWPASuppWextEnabled == true)
                         {
                   	union iwreq_data  wrqu;
                   	memset(&wrqu, 0, sizeof (wrqu));
@@ -1001,7 +1001,7 @@ if(pDevice->byReAssocCount > 0) {
                        }
                     #endif
      }
-   else if(pDevice->bLinkPass == TRUE)
+   else if(pDevice->bLinkPass == true)
    	pDevice->byReAssocCount = 0;
 }
 
@@ -1100,27 +1100,27 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
         if (WLAN_GET_ERP_USE_PROTECTION(pDevice->byERPFlag)) {
             if (!pDevice->bProtectMode) {
                 MACvEnableProtectMD(pDevice);
-                pDevice->bProtectMode = TRUE;
+                pDevice->bProtectMode = true;
             }
         }
         else {
             if (pDevice->bProtectMode) {
                 MACvDisableProtectMD(pDevice);
-                pDevice->bProtectMode = FALSE;
+                pDevice->bProtectMode = false;
             }
         }
         // on/off short slot time
 
         if (uNonShortSlotSTACnt > 0) {
             if (pDevice->bShortSlotTime) {
-                pDevice->bShortSlotTime = FALSE;
+                pDevice->bShortSlotTime = false;
                 BBvSetShortSlotTime(pDevice);
 		vUpdateIFS((void *)pDevice);
             }
         }
         else {
             if (!pDevice->bShortSlotTime) {
-                pDevice->bShortSlotTime = TRUE;
+                pDevice->bShortSlotTime = true;
                 BBvSetShortSlotTime(pDevice);
 		vUpdateIFS((void *)pDevice);
             }
@@ -1131,13 +1131,13 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
         if (uLongPreambleSTACnt > 0) {
             if (!pDevice->bBarkerPreambleMd) {
                 MACvEnableBarkerPreambleMd(pDevice);
-                pDevice->bBarkerPreambleMd = TRUE;
+                pDevice->bBarkerPreambleMd = true;
             }
         }
         else {
             if (pDevice->bBarkerPreambleMd) {
                 MACvDisableBarkerPreambleMd(pDevice);
-                pDevice->bBarkerPreambleMd = FALSE;
+                pDevice->bBarkerPreambleMd = false;
             }
         }
 
@@ -1147,9 +1147,9 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
     // Check if any STA in PS mode, enable DTIM multicast deliver
     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
         if (uSleepySTACnt > 0)
-            pMgmt->sNodeDBTable[0].bPSEnable = TRUE;
+            pMgmt->sNodeDBTable[0].bPSEnable = true;
         else
-            pMgmt->sNodeDBTable[0].bPSEnable = FALSE;
+            pMgmt->sNodeDBTable[0].bPSEnable = false;
     }
 
     pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
@@ -1175,14 +1175,14 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
     	    }
 
         	if (pMgmt->sNodeDBTable[0].uInActiveCount >= LOST_BEACON_COUNT) {
-                pMgmt->sNodeDBTable[0].bActive = FALSE;
+                pMgmt->sNodeDBTable[0].bActive = false;
                 pMgmt->eCurrMode = WMAC_MODE_STANDBY;
                 pMgmt->eCurrState = WMAC_STATE_IDLE;
                 netif_stop_queue(pDevice->dev);
-                pDevice->bLinkPass = FALSE;
+                pDevice->bLinkPass = false;
                 ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
-                pDevice->bRoaming = TRUE;
-                pDevice->bIsRoaming = FALSE;
+                pDevice->bRoaming = true;
+                pDevice->bIsRoaming = false;
 
                 DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost AP beacon [%d] sec, disconnected !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
 	//let wpa supplicant know AP may disconnect.//20080717-01,<Add> by James Li
@@ -1201,7 +1201,7 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
              pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
          };
    #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-  // if(pDevice->bWPASuppWextEnabled == TRUE)
+  // if(pDevice->bWPASuppWextEnabled == true)
       {
 	union iwreq_data  wrqu;
 	memset(&wrqu, 0, sizeof (wrqu));
@@ -1214,10 +1214,10 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
         }
         else if (pItemSSID->len != 0) {
 //Davidwang
-      if ((pDevice->bEnableRoaming == TRUE)&&(!(pMgmt->Cisco_cckm))) {
+      if ((pDevice->bEnableRoaming == true)&&(!(pMgmt->Cisco_cckm))) {
 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bRoaming %d, !\n", pDevice->bRoaming );
 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
-          if ((pDevice->bRoaming == TRUE)&&(pDevice->bIsRoaming == TRUE)){
+          if ((pDevice->bRoaming == true)&&(pDevice->bIsRoaming == true)){
 	    	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fast   Roaming ...\n");
 		BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
 		bScheduleCommand((void *) pDevice,
@@ -1228,7 +1228,7 @@ DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
 				 pMgmt->abyDesireSSID);
                 pDevice->uAutoReConnectTime = 0;
                 pDevice->uIsroamingTime = 0;
-                pDevice->bRoaming = FALSE;
+                pDevice->bRoaming = false;
 
 //            if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
              wpahdr = (viawget_wpa_header *)pDevice->skb->data;
@@ -1246,10 +1246,10 @@ DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
 
 //         }
           }
-      else if ((pDevice->bRoaming == FALSE)&&(pDevice->bIsRoaming == TRUE)) {
+      else if ((pDevice->bRoaming == false)&&(pDevice->bIsRoaming == true)) {
                             pDevice->uIsroamingTime++;
        if (pDevice->uIsroamingTime >= 20)
-            pDevice->bIsRoaming = FALSE;
+            pDevice->bIsRoaming = false;
          }
 
    }
@@ -1258,7 +1258,7 @@ else {
                 pDevice->uAutoReConnectTime++;
                #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
                 //network manager support need not do Roaming scan???
-                if(pDevice->bWPASuppWextEnabled ==TRUE)
+                if(pDevice->bWPASuppWextEnabled ==true)
 		 pDevice->uAutoReConnectTime = 0;
 	     #endif
             }
@@ -1307,13 +1307,13 @@ else {
                 pMgmt->sNodeDBTable[0].uInActiveCount = 0;
                 pMgmt->eCurrState = WMAC_STATE_STARTED;
                 netif_stop_queue(pDevice->dev);
-                pDevice->bLinkPass = FALSE;
+                pDevice->bLinkPass = false;
                 ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
             }
         }
     }
 
-    if (pDevice->bLinkPass == TRUE) {
+    if (pDevice->bLinkPass == true) {
         if (netif_queue_stopped(pDevice->dev))
             netif_wake_queue(pDevice->dev);
     }
@@ -1590,7 +1590,7 @@ RxCnt = pDevice->scStatistic.RxFcsErrCnt +
 TxOkRatio = (TxCnt < 6) ? 4000:((pDevice->scStatistic.TxNoRetryOkCount * 4000) / TxCnt);
 RxOkRatio = (RxCnt < 6) ? 2000:((pDevice->scStatistic.RxOkCnt * 2000) / RxCnt);
 //decide link quality
-if(pDevice->bLinkPass !=TRUE)
+if(pDevice->bLinkPass !=true)
 {
  //  printk("s_uCalculateLinkQual-->Link disconnect and Poor quality**\n");
    pDevice->scStatistic.LinkQuality = 0;
@@ -1627,7 +1627,7 @@ void BSSvClearAnyBSSJoinRecord(void *hDeviceContext)
     unsigned int            ii;
 
     for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-        pMgmt->sBSSList[ii].bSelected = FALSE;
+        pMgmt->sBSSList[ii].bSelected = false;
     }
     return;
 }
@@ -1643,7 +1643,7 @@ void s_vCheckPreEDThreshold(void *hDeviceContext)
         pBSSList = BSSpAddrIsInBSSList(pDevice, pMgmt->abyCurrBSSID, (PWLAN_IE_SSID)pMgmt->abyCurrSSID);
         if (pBSSList != NULL) {
             pDevice->byBBPreEDRSSI = (BYTE) (~(pBSSList->ldBmAverRange) + 1);
-            BBvUpdatePreEDThreshold(pDevice, FALSE);
+            BBvUpdatePreEDThreshold(pDevice, false);
         }
     }
     return;
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 35bf4fd..e703039 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -92,13 +92,13 @@ const WORD cwRXBCNTSFOff[MAX_RATE] =
  *  Out:
  *      none
  *
- * Return Value: TRUE if succeeded; FALSE if failed.
+ * Return Value: true if succeeded; false if failed.
  *
  */
 BOOL CARDbSetMediaChannel(void *pDeviceHandler, unsigned int uConnectionChannel)
 {
 PSDevice            pDevice = (PSDevice) pDeviceHandler;
-BOOL                bResult = TRUE;
+BOOL                bResult = true;
 
 
     if (pDevice->byBBType == BB_TYPE_11A) { // 15 ~ 38
@@ -506,7 +506,7 @@ void vUpdateIFS(void *pDeviceHandler)
     }
     else {// PK_TYPE_11GA & PK_TYPE_11GB
         BYTE byRate = 0;
-        BOOL bOFDMRate = FALSE;
+        BOOL bOFDMRate = false;
 	unsigned int ii = 0;
         PWLAN_IE_SUPP_RATES pItemRates = NULL;
 
@@ -522,21 +522,21 @@ void vUpdateIFS(void *pDeviceHandler)
         for (ii = 0; ii < pItemRates->len; ii++) {
             byRate = (BYTE)(pItemRates->abyRates[ii]&0x7F);
             if (RATEwGetRateIdx(byRate) > RATE_11M) {
-                bOFDMRate = TRUE;
+                bOFDMRate = true;
                 break;
             }
         }
-        if (bOFDMRate == FALSE) {
+        if (bOFDMRate == false) {
             pItemRates = (PWLAN_IE_SUPP_RATES)pDevice->sMgmtObj.abyCurrExtSuppRates;
             for (ii = 0; ii < pItemRates->len; ii++) {
                 byRate = (BYTE)(pItemRates->abyRates[ii]&0x7F);
                 if (RATEwGetRateIdx(byRate) > RATE_11M) {
-                    bOFDMRate = TRUE;
+                    bOFDMRate = true;
                     break;
                 }
             }
         }
-        if (bOFDMRate == TRUE) {
+        if (bOFDMRate == true) {
             pDevice->uCwMin = C_CWMIN_A;
             byMaxMin = 4;
         } else {
@@ -604,7 +604,7 @@ BYTE ii;
  *  Out:
  *      none
  *
- * Return Value: TRUE if succeeded; FALSE if failed.
+ * Return Value: true if succeeded; false if failed.
  *
  */
 BOOL CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx)
@@ -617,7 +617,7 @@ WORD wRate = (WORD)(1<<wRateIdx);
     //Determines the highest basic rate.
     CARDvUpdateBasicTopRate(pDevice);
 
-    return(TRUE);
+    return(true);
 }
 
 BOOL CARDbIsOFDMinBasicRate(void *pDeviceHandler)
@@ -627,9 +627,9 @@ int ii;
 
     for (ii = RATE_54M; ii >= RATE_6M; ii --) {
         if ((pDevice->wBasicRate) & ((WORD)(1<<ii)))
-            return TRUE;
+            return true;
     }
-    return FALSE;
+    return false;
 }
 
 BYTE CARDbyGetPktType(void *pDeviceHandler)
@@ -751,7 +751,7 @@ void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
  *  Out:
  *      qwCurrTSF       - Current TSF counter
  *
- * Return Value: TRUE if success; otherwise FALSE
+ * Return Value: true if success; otherwise false
  *
  */
 BOOL CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF)
@@ -761,7 +761,7 @@ BOOL CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF)
     LODWORD(*pqwCurrTSF) = LODWORD(pDevice->qwCurrTSF);
     HIDWORD(*pqwCurrTSF) = HIDWORD(pDevice->qwCurrTSF);
 
-    return(TRUE);
+    return(true);
 }
 
 
@@ -773,7 +773,7 @@ BOOL CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF)
  *  In:
  *      pDevice         - The adapter to be read
  *
- * Return Value: TRUE if success; otherwise FALSE
+ * Return Value: true if success; otherwise false
  *
  */
 BOOL CARDbClearCurrentTSF(void *pDeviceHandler)
@@ -785,7 +785,7 @@ BOOL CARDbClearCurrentTSF(void *pDeviceHandler)
     LODWORD(pDevice->qwCurrTSF) = 0;
     HIDWORD(pDevice->qwCurrTSF) = 0;
 
-    return(TRUE);
+    return(true);
 }
 
 /*
@@ -941,18 +941,18 @@ void CARDvUpdateNextTBTT(void *pDeviceHandler, QWORD qwTSF,
  *  Out:
  *      none
  *
- * Return Value: TRUE if success; otherwise FALSE
+ * Return Value: true if success; otherwise false
  *
  */
 BOOL CARDbRadioPowerOff(void *pDeviceHandler)
 {
 PSDevice    pDevice = (PSDevice) pDeviceHandler;
-BOOL bResult = TRUE;
+BOOL bResult = true;
 
-    //if (pDevice->bRadioOff == TRUE)
-    //    return TRUE;
+    //if (pDevice->bRadioOff == true)
+    //    return true;
 
-    pDevice->bRadioOff = TRUE;
+    pDevice->bRadioOff = true;
 
     switch (pDevice->byRFType) {
         case RF_AL2230:
@@ -982,23 +982,23 @@ BOOL bResult = TRUE;
  *  Out:
  *      none
  *
- * Return Value: TRUE if success; otherwise FALSE
+ * Return Value: true if success; otherwise false
  *
  */
 BOOL CARDbRadioPowerOn(void *pDeviceHandler)
 {
 PSDevice    pDevice = (PSDevice) pDeviceHandler;
-BOOL bResult = TRUE;
+BOOL bResult = true;
 
 
-    if ((pDevice->bHWRadioOff == TRUE) || (pDevice->bRadioControlOff == TRUE)) {
-        return FALSE;
+    if ((pDevice->bHWRadioOff == true) || (pDevice->bRadioControlOff == true)) {
+        return false;
     }
 
-    //if (pDevice->bRadioOff == FALSE)
-    //    return TRUE;
+    //if (pDevice->bRadioOff == false)
+    //    return true;
 
-    pDevice->bRadioOff = FALSE;
+    pDevice->bRadioOff = false;
 
     BBvExitDeepSleep(pDevice);
 
@@ -1086,7 +1086,7 @@ CARDbChannelSwitch (
     )
 {
     PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    BOOL        bResult = TRUE;
+    BOOL        bResult = true;
 
     if (byCount == 0) {
         pDevice->sMgmtObj.uCurrChannel = byNewChannel;
@@ -1096,11 +1096,11 @@ CARDbChannelSwitch (
     }
     pDevice->byChannelSwitchCount = byCount;
     pDevice->byNewChannel = byNewChannel;
-    pDevice->bChannelSwitch = TRUE;
+    pDevice->bChannelSwitch = true;
 
     if (byMode == 1) {
         //bResult=CARDbStopTxPacket(pDevice, PKT_TYPE_802_11_ALL);
-        pDevice->bStopDataPkt = TRUE;
+        pDevice->bStopDataPkt = true;
     }
     return (bResult);
 }
diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 6ad03e4..5b12fab 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -49,63 +49,63 @@ static int          msglevel                =MSG_LEVEL_INFO;
 
 static SChannelTblElement sChannelTbl[CB_MAX_CHANNEL+1] =
 {
-  {0,   0,    FALSE},
-  {1,   2412, TRUE},
-  {2,   2417, TRUE},
-  {3,   2422, TRUE},
-  {4,   2427, TRUE},
-  {5,   2432, TRUE},
-  {6,   2437, TRUE},
-  {7,   2442, TRUE},
-  {8,   2447, TRUE},
-  {9,   2452, TRUE},
-  {10,  2457, TRUE},
-  {11,  2462, TRUE},
-  {12,  2467, TRUE},
-  {13,  2472, TRUE},
-  {14,  2484, TRUE},
-  {183, 4915, TRUE}, //15
-  {184, 4920, TRUE}, //16
-  {185, 4925, TRUE}, //17
-  {187, 4935, TRUE}, //18
-  {188, 4940, TRUE}, //19
-  {189, 4945, TRUE}, //20
-  {192, 4960, TRUE}, //21
-  {196, 4980, TRUE}, //22
-  {7,   5035, TRUE}, //23
-  {8,   5040, TRUE}, //24
-  {9,   5045, TRUE}, //25
-  {11,  5055, TRUE}, //26
-  {12,  5060, TRUE}, //27
-  {16,  5080, TRUE}, //28
-  {34,  5170, TRUE}, //29
-  {36,  5180, TRUE}, //30
-  {38,  5190, TRUE}, //31
-  {40,  5200, TRUE}, //32
-  {42,  5210, TRUE}, //33
-  {44,  5220, TRUE}, //34
-  {46,  5230, TRUE}, //35
-  {48,  5240, TRUE}, //36
-  {52,  5260, TRUE}, //37
-  {56,  5280, TRUE}, //38
-  {60,  5300, TRUE}, //39
-  {64,  5320, TRUE}, //40
-  {100, 5500, TRUE}, //41
-  {104, 5520, TRUE}, //42
-  {108, 5540, TRUE}, //43
-  {112, 5560, TRUE}, //44
-  {116, 5580, TRUE}, //45
-  {120, 5600, TRUE}, //46
-  {124, 5620, TRUE}, //47
-  {128, 5640, TRUE}, //48
-  {132, 5660, TRUE}, //49
-  {136, 5680, TRUE}, //50
-  {140, 5700, TRUE}, //51
-  {149, 5745, TRUE}, //52
-  {153, 5765, TRUE}, //53
-  {157, 5785, TRUE}, //54
-  {161, 5805, TRUE}, //55
-  {165, 5825, TRUE}  //56
+  {0,   0,    false},
+  {1,   2412, true},
+  {2,   2417, true},
+  {3,   2422, true},
+  {4,   2427, true},
+  {5,   2432, true},
+  {6,   2437, true},
+  {7,   2442, true},
+  {8,   2447, true},
+  {9,   2452, true},
+  {10,  2457, true},
+  {11,  2462, true},
+  {12,  2467, true},
+  {13,  2472, true},
+  {14,  2484, true},
+  {183, 4915, true}, //15
+  {184, 4920, true}, //16
+  {185, 4925, true}, //17
+  {187, 4935, true}, //18
+  {188, 4940, true}, //19
+  {189, 4945, true}, //20
+  {192, 4960, true}, //21
+  {196, 4980, true}, //22
+  {7,   5035, true}, //23
+  {8,   5040, true}, //24
+  {9,   5045, true}, //25
+  {11,  5055, true}, //26
+  {12,  5060, true}, //27
+  {16,  5080, true}, //28
+  {34,  5170, true}, //29
+  {36,  5180, true}, //30
+  {38,  5190, true}, //31
+  {40,  5200, true}, //32
+  {42,  5210, true}, //33
+  {44,  5220, true}, //34
+  {46,  5230, true}, //35
+  {48,  5240, true}, //36
+  {52,  5260, true}, //37
+  {56,  5280, true}, //38
+  {60,  5300, true}, //39
+  {64,  5320, true}, //40
+  {100, 5500, true}, //41
+  {104, 5520, true}, //42
+  {108, 5540, true}, //43
+  {112, 5560, true}, //44
+  {116, 5580, true}, //45
+  {120, 5600, true}, //46
+  {124, 5620, true}, //47
+  {128, 5640, true}, //48
+  {132, 5660, true}, //49
+  {136, 5680, true}, //50
+  {140, 5700, true}, //51
+  {149, 5745, true}, //52
+  {153, 5765, true}, //53
+  {157, 5785, true}, //54
+  {161, 5805, true}, //55
+  {165, 5825, true}  //56
 };
 
 
@@ -381,7 +381,7 @@ static  struct
  *              15  = 4.9G channel 183
  *              16  = 4.9G channel 184
  *              .....
- *  Output: TRUE if the specified 5GHz band is allowed to be used.
+ *  Output: true if the specified 5GHz band is allowed to be used.
             False otherwise.
 // 4.9G => Ch 183, 184, 185, 187, 188, 189, 192, 196 (Value:15 ~ 22)
 
@@ -393,14 +393,14 @@ ChannelValid(unsigned int CountryCode, unsigned int ChannelIndex)
 {
     BOOL    bValid;
 
-    bValid = FALSE;
+    bValid = false;
     /*
      * If Channel Index is invalid, return invalid
      */
     if ((ChannelIndex > CB_MAX_CHANNEL) ||
         (ChannelIndex == 0))
     {
-        bValid = FALSE;
+        bValid = false;
         goto exit;
     }
 
@@ -430,41 +430,41 @@ CHvChannelGetList (
     )
 {
     if (uCountryCodeIdx >= CCODE_MAX) {
-        return (FALSE);
+        return (false);
     }
     memcpy(pbyChannelTable, ChannelRuleTab[uCountryCodeIdx].bChannelIdxList, CB_MAX_CHANNEL);
-    return (TRUE);
+    return (true);
 }
 
 
 void CHvInitChannelTable(void *pDeviceHandler)
 {
     PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    BOOL        bMultiBand = FALSE;
+    BOOL        bMultiBand = false;
     unsigned int ii;
 
     for (ii = 1; ii <= CB_MAX_CHANNEL; ii++)
-	sChannelTbl[ii].bValid = FALSE;
+	sChannelTbl[ii].bValid = false;
 
     switch (pDevice->byRFType) {
         case RF_AL2230:
         case RF_AL2230S:
         case RF_VT3226:
         case RF_VT3226D0:
-            bMultiBand = FALSE;
+            bMultiBand = false;
             break;
         case RF_AIROHA7230:
         case RF_VT3342A0:
         default :
-            bMultiBand = TRUE;
+            bMultiBand = true;
             break;
     }
 
     if ((pDevice->dwDiagRefCount != 0) ||
-        (pDevice->b11hEable == TRUE)) {
-        if (bMultiBand == TRUE) {
+        (pDevice->b11hEable == true)) {
+        if (bMultiBand == true) {
 		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
-			sChannelTbl[ii+1].bValid = TRUE;
+			sChannelTbl[ii+1].bValid = true;
                 //pDevice->abyRegPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
                 //pDevice->abyLocalPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
 		}
@@ -474,16 +474,16 @@ void CHvInitChannelTable(void *pDeviceHandler)
 		}
         } else {
 		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-			sChannelTbl[ii+1].bValid = TRUE;
+			sChannelTbl[ii+1].bValid = true;
                 //pDevice->abyRegPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
                 //pDevice->abyLocalPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
 		}
         }
     } else if (pDevice->byZoneType <= CCODE_MAX) {
-        if (bMultiBand == TRUE) {
+        if (bMultiBand == true) {
 		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
 			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0) {
-				sChannelTbl[ii+1].bValid = TRUE;
+				sChannelTbl[ii+1].bValid = true;
                     //pDevice->abyRegPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
                     //pDevice->abyLocalPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
 			}
@@ -491,7 +491,7 @@ void CHvInitChannelTable(void *pDeviceHandler)
         } else {
 		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
 			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0) {
-				sChannelTbl[ii+1].bValid = TRUE;
+				sChannelTbl[ii+1].bValid = true;
                     //pDevice->abyRegPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
                     //pDevice->abyLocalPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
 			}
diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index 51dc540..00f4b97 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -226,7 +226,7 @@ unsigned int  uRateLen;
     for (ii = 0; ii < uRateLen; ii++) {
     	byRate = (BYTE)(pItemRates->abyRates[ii]);
         if (WLAN_MGMT_IS_BASICRATE(byRate) &&
-            (bUpdateBasicRate == TRUE))  {
+            (bUpdateBasicRate == true))  {
             // Add to basic rate set, update pDevice->byTopCCKBasicRate and pDevice->byTopOFDMBasicRate
 		CARDbAddBasicRate((void *)pDevice, RATEwGetRateIdx(byRate));
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ParseMaxRate AddBasicRate: %d\n", RATEwGetRateIdx(byRate));
@@ -312,7 +312,7 @@ PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
 #if 1  //mike fixed old: use packet lose ratio algorithm to control rate
 WORD            wIdxDownRate = 0;
 unsigned int            ii;
-BOOL            bAutoRate[MAX_RATE]    = {TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE};
+BOOL            bAutoRate[MAX_RATE]    = {true,true,true,true,false,false,true,true,true,true,true,true};
 DWORD           dwThroughputTbl[MAX_RATE] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540};
 DWORD           dwThroughput = 0;
 WORD            wIdxUpRate = 0;
@@ -339,11 +339,11 @@ DWORD           dwTxDiff = 0;
 
     for (ii = 0; ii < MAX_RATE; ii++) {
         if (psNodeDBTable->wSuppRate & (0x0001<<ii)) {
-            if (bAutoRate[ii] == TRUE) {
+            if (bAutoRate[ii] == true) {
                 wIdxUpRate = (WORD) ii;
             }
         } else {
-            bAutoRate[ii] = FALSE;
+            bAutoRate[ii] = false;
         }
     }
 
@@ -365,7 +365,7 @@ DWORD           dwTxDiff = 0;
     for (ii = psNodeDBTable->wTxDataRate; ii > 0;) {
         ii--;
         if ( (dwThroughputTbl[ii] > dwThroughput) &&
-             (bAutoRate[ii]==TRUE) ) {
+             (bAutoRate[ii]==true) ) {
             dwThroughput = dwThroughputTbl[ii];
             wIdxDownRate = (WORD) ii;
         }
@@ -391,7 +391,7 @@ DWORD           dwTxDiff = 0;
     return;
 #else  //mike fixed new: use differ-signal strength to control rate
 WORD            wIdxUpRate = 0;
-BOOL            bAutoRate[MAX_RATE]    = {TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE};
+BOOL            bAutoRate[MAX_RATE]    = {true,true,true,true,false,false,true,true,true,true,true,true};
 unsigned int            ii;
 long  ldBm;
 
@@ -402,11 +402,11 @@ long  ldBm;
 
     for (ii = 0; ii < MAX_RATE; ii++) {
         if (psNodeDBTable->wSuppRate & (0x0001<<ii)) {
-            if (bAutoRate[ii] == TRUE) {
+            if (bAutoRate[ii] == true) {
                 wIdxUpRate = (WORD) ii;
             }
         } else {
-            bAutoRate[ii] = FALSE;
+            bAutoRate[ii] = false;
         }
     }
 
@@ -435,7 +435,7 @@ if (wIdxUpRate == RATE_54M ) {     //11a/g
 			psNodeDBTable->wTxDataRate = RATE_5M;
 		else {
 			psNodeDBTable->wTxDataRate = RATE_1M;
-			//increasingVGA = TRUE;
+			//increasingVGA = true;
 		}
 	}
 	else {  //11b
diff --git a/drivers/staging/vt6656/device_cfg.h b/drivers/staging/vt6656/device_cfg.h
index a0b8216..3be2e87 100644
--- a/drivers/staging/vt6656/device_cfg.h
+++ b/drivers/staging/vt6656/device_cfg.h
@@ -38,12 +38,12 @@ struct _version {
     unsigned char   build;
 } version_t, *pversion_t;
 
-#ifndef FALSE
-#define FALSE   (0)
+#ifndef false
+#define false   (0)
 #endif
 
-#ifndef TRUE
-#define TRUE    (!(FALSE))
+#ifndef true
+#define true    (!(false))
 #endif
 
 #define VID_TABLE_SIZE      64
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 81ce46f..98facb3 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -331,7 +331,7 @@ RXbBulkInProcessData (
     PBYTE           pbyRSSI;
     PQWORD          pqwTSFTime;
     PBYTE           pbyFrame;
-    BOOL            bDeFragRx = FALSE;
+    BOOL            bDeFragRx = false;
     unsigned int            cbHeaderOffset;
     unsigned int            FrameSize;
     WORD            wEtherType = 0;
@@ -352,8 +352,8 @@ RXbBulkInProcessData (
     SKeyItem        STempKey;
     // 802.11h RPI
     /* signed long ldBm = 0; */
-    BOOL            bIsWEP = FALSE;
-    BOOL            bExtIV = FALSE;
+    BOOL            bIsWEP = false;
+    BOOL            bExtIV = false;
     DWORD           dwWbkStatus;
     PRCB            pRCBIndicate = pRCB;
     PBYTE           pbyDAddress;
@@ -361,7 +361,7 @@ RXbBulkInProcessData (
     BYTE            abyVaildRate[MAX_RATE] = {2,4,11,22,12,18,24,36,48,72,96,108};
     WORD            wPLCPwithPadding;
     PS802_11Header  pMACHeader;
-    BOOL            bRxeapol_key = FALSE;
+    BOOL            bRxeapol_key = false;
 
 
 
@@ -376,13 +376,13 @@ RXbBulkInProcessData (
 
     if (BytesToIndicate != FrameSize) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---------- WRONG Length 1 \n");
-        return FALSE;
+        return false;
     }
 
     if ((BytesToIndicate > 2372)||(BytesToIndicate <= 40)) {
         // Frame Size error drop this packet.
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---------- WRONG Length 2 \n");
-        return FALSE;
+        return false;
     }
 
     pbyDAddress = (PBYTE)(skb->data);
@@ -400,7 +400,7 @@ RXbBulkInProcessData (
 
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Wrong PLCP Length %x\n", (int) *pwPLCP_Length);
         ASSERT(0);
-        return FALSE;
+        return false;
     }
     for ( ii=RATE_1M;ii<MAX_RATE;ii++) {
         if ( *pbyRxRate == abyVaildRate[ii] ) {
@@ -409,7 +409,7 @@ RXbBulkInProcessData (
     }
     if ( ii==MAX_RATE ) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Wrong RxRate %x\n",(int) *pbyRxRate);
-        return FALSE;
+        return false;
     }
 
     wPLCPwithPadding = ( (*pwPLCP_Length / 4) + ( (*pwPLCP_Length % 4) ? 1:0 ) ) *4;
@@ -462,12 +462,12 @@ RXbBulkInProcessData (
     if (!is_multicast_ether_addr(pMACHeader->abyAddr1) && !is_broadcast_ether_addr(pMACHeader->abyAddr1)) {
         if ( WCTLbIsDuplicate(&(pDevice->sDupRxCache), (PS802_11Header) pbyFrame) ) {
             pDevice->s802_11Counter.FrameDuplicateCount++;
-            return FALSE;
+            return false;
         }
 
 	if (compare_ether_addr(pDevice->abyCurrentNetAddr,
 			       pMACHeader->abyAddr1)) {
-		return FALSE;
+		return false;
         }
     }
 
@@ -477,7 +477,7 @@ RXbBulkInProcessData (
 
     if (!compare_ether_addr((PBYTE)&(pDevice->sRxEthHeader.abySrcAddr[0]),
 			    pDevice->abyCurrentNetAddr))
-        return FALSE;
+        return false;
 
     if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) || (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA)) {
         if (IS_CTL_PSPOLL(pbyFrame) || !IS_TYPE_CONTROL(pbyFrame)) {
@@ -491,17 +491,17 @@ RXbBulkInProcessData (
     }
 
     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-        if (s_bAPModeRxCtl(pDevice, pbyFrame, iSANodeIndex) == TRUE) {
-            return FALSE;
+        if (s_bAPModeRxCtl(pDevice, pbyFrame, iSANodeIndex) == true) {
+            return false;
         }
     }
 
 
     if (IS_FC_WEP(pbyFrame)) {
-        BOOL     bRxDecryOK = FALSE;
+        BOOL     bRxDecryOK = false;
 
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"rx WEP pkt\n");
-        bIsWEP = TRUE;
+        bIsWEP = true;
         if ((pDevice->bEnableHostWEP) && (iSANodeIndex >= 0)) {
             pKey = &STempKey;
             pKey->byCipherSuite = pMgmt->sNodeDBTable[iSANodeIndex].byCipherSuite;
@@ -553,11 +553,11 @@ RXbBulkInProcessData (
 //                      pDevice->s802_11Counter.WEPICVErrorCount.QuadPart++;
                     }
                 }
-                return FALSE;
+                return false;
             }
         } else {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"WEP Func Fail\n");
-            return FALSE;
+            return false;
         }
         if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_CCMP))
             FrameSize -= 8;         // Message Integrity Code
@@ -586,14 +586,14 @@ RXbBulkInProcessData (
             pbyFrame = skb->data + 8;
         }
         else {
-            return FALSE;
+            return false;
         }
     }
 
     //
     // Management & Control frame Handle
     //
-    if ((IS_TYPE_DATA((pbyFrame))) == FALSE) {
+    if ((IS_TYPE_DATA((pbyFrame))) == false) {
         // Handle Control & Manage Frame
 
         if (IS_TYPE_MGMT((pbyFrame))) {
@@ -624,7 +624,7 @@ RXbBulkInProcessData (
                 //Discard beacon packet which channel is 0
                 if ( (WLAN_GET_FC_FSTYPE((pRxPacket->p80211Header->sA3.wFrameCtl)) == WLAN_FSTYPE_BEACON) ||
                      (WLAN_GET_FC_FSTYPE((pRxPacket->p80211Header->sA3.wFrameCtl)) == WLAN_FSTYPE_PROBERESP) ) {
-                    return TRUE;
+                    return true;
                 }
             }
             pRxPacket->byRxChannel = (*pbyRxSts) >> 2;
@@ -642,7 +642,7 @@ RXbBulkInProcessData (
     	        skb->protocol = htons(ETH_P_802_2);
 	            memset(skb->cb, 0, sizeof(skb->cb));
 	            netif_rx(skb);
-                return TRUE;
+                return true;
 	        }
 
             //
@@ -650,11 +650,11 @@ RXbBulkInProcessData (
             //
             EnqueueRCB(pDevice->FirstRecvMngList, pDevice->LastRecvMngList, pRCBIndicate);
             pDevice->NumRecvMngList++;
-            if ( bDeFragRx == FALSE) {
+            if ( bDeFragRx == false) {
                 pRCB->Ref++;
             }
-            if (pDevice->bIsRxMngWorkItemQueued == FALSE) {
-                pDevice->bIsRxMngWorkItemQueued = TRUE;
+            if (pDevice->bIsRxMngWorkItemQueued == false) {
+                pDevice->bIsRxMngWorkItemQueued = true;
                 tasklet_schedule(&pDevice->RxMngWorkItem);
             }
 
@@ -662,7 +662,7 @@ RXbBulkInProcessData (
         else {
             // Control Frame
         };
-        return FALSE;
+        return false;
     }
     else {
         if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -674,12 +674,12 @@ RXbBulkInProcessData (
                         pDevice->dev->name);
                     }
                 }
-                return FALSE;
+                return false;
             }
         }
         else {
             // discard DATA packet while not associate || BSSID error
-            if ((pDevice->bLinkPass == FALSE) ||
+            if ((pDevice->bLinkPass == false) ||
                 !(*pbyRsr & RSR_BSSIDOK)) {
                 if (bDeFragRx) {
                     if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
@@ -687,7 +687,7 @@ RXbBulkInProcessData (
                         pDevice->dev->name);
                     }
                 }
-                return FALSE;
+                return false;
             }
    //mike add:station mode check eapol-key challenge--->
    	  {
@@ -706,7 +706,7 @@ RXbBulkInProcessData (
 	     if (wEtherType == ETH_P_PAE) {         //Protocol Type in LLC-Header
                   if(((Protocol_Version==1) ||(Protocol_Version==2)) &&
 		     (Packet_Type==3)) {  //802.1x OR eapol-key challenge frame receive
-                        bRxeapol_key = TRUE;
+                        bRxeapol_key = true;
 		      Descriptor_type = skb->data[cbIVOffset + 8 + 24 + 6 + 1 +1+1+1+2];
 		      Key_info = (skb->data[cbIVOffset + 8 + 24 + 6 + 1 +1+1+1+2+1]<<8) |skb->data[cbIVOffset + 8 + 24 + 6 + 1 +1+1+1+2+2] ;
 		      if(Descriptor_type==2) {    //RSN
@@ -733,8 +733,8 @@ RXbBulkInProcessData (
             }
         }
         else {
-            if (pMgmt->bInTIMWake == TRUE) {
-                pMgmt->bInTIMWake = FALSE;
+            if (pMgmt->bInTIMWake == true) {
+                pMgmt->bInTIMWake = false;
             }
         }
     };
@@ -742,7 +742,7 @@ RXbBulkInProcessData (
     // Now it only supports 802.11g Infrastructure Mode, and support rate must up to 54 Mbps
     if (pDevice->bDiversityEnable && (FrameSize>50) &&
        (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) &&
-       (pDevice->bLinkPass == TRUE)) {
+       (pDevice->bLinkPass == true)) {
         BBvAntennaDiversity(pDevice, s_byGetRateIdx(*pbyRxRate), 0);
     }
 
@@ -771,7 +771,7 @@ RXbBulkInProcessData (
 
     // -----------------------------------------------
 
-    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnable8021x == TRUE)){
+    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnable8021x == true)){
         BYTE    abyMacHdr[24];
 
         // Only 802.1x packet incoming allowed
@@ -786,7 +786,7 @@ RXbBulkInProcessData (
         if (wEtherType == ETH_P_PAE) {
             skb->dev = pDevice->apdev;
 
-            if (bIsWEP == TRUE) {
+            if (bIsWEP == true) {
                 // strip IV header(8)
                 memcpy(&abyMacHdr[0], (skb->data + 8), 24);
                 memcpy((skb->data + 8 + cbIVOffset), &abyMacHdr[0], 24);
@@ -800,12 +800,12 @@ RXbBulkInProcessData (
             skb->protocol = htons(ETH_P_802_2);
             memset(skb->cb, 0, sizeof(skb->cb));
             netif_rx(skb);
-            return TRUE;
+            return true;
 
         }
         // check if 802.1x authorized
         if (!(pMgmt->sNodeDBTable[iSANodeIndex].dwFlags & WLAN_STA_AUTHORIZED))
-            return FALSE;
+            return false;
     }
 
 
@@ -860,9 +860,9 @@ RXbBulkInProcessData (
 
 
             if ((cpu_to_le32(*pdwMIC_L) != dwLocalMIC_L) || (cpu_to_le32(*pdwMIC_R) != dwLocalMIC_R) ||
-                (pDevice->bRxMICFail == TRUE)) {
+                (pDevice->bRxMICFail == true)) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC comparison is fail!\n");
-                pDevice->bRxMICFail = FALSE;
+                pDevice->bRxMICFail = false;
                 //pDevice->s802_11Counter.TKIPLocalMICFailures.QuadPart++;
                 pDevice->s802_11Counter.TKIPLocalMICFailures++;
                 if (bDeFragRx) {
@@ -874,7 +874,7 @@ RXbBulkInProcessData (
 		//2008-0409-07, <Add> by Einsn Liu
        #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 				//send event to wpa_supplicant
-				//if(pDevice->bWPASuppWextEnabled == TRUE)
+				//if(pDevice->bWPASuppWextEnabled == true)
 				{
 					union iwreq_data wrqu;
 					struct iw_michaelmicfailure ev;
@@ -923,7 +923,7 @@ RXbBulkInProcessData (
                      pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
                  };
 
-                return FALSE;
+                return false;
 
             }
         }
@@ -967,7 +967,7 @@ RXbBulkInProcessData (
                                 pDevice->dev->name);
                         }
                     }
-                    return FALSE;
+                    return false;
                 }
             }
         }
@@ -980,7 +980,7 @@ RXbBulkInProcessData (
 
     // Null data, framesize = 12
     if (FrameSize < 12)
-        return FALSE;
+        return false;
 
     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
         if (s_bAPModeRxData(pDevice,
@@ -989,7 +989,7 @@ RXbBulkInProcessData (
                             cbHeaderOffset,
                             iSANodeIndex,
                             iDANodeIndex
-                            ) == FALSE) {
+                            ) == false) {
 
             if (bDeFragRx) {
                 if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
@@ -997,7 +997,7 @@ RXbBulkInProcessData (
                     pDevice->dev->name);
                 }
             }
-            return FALSE;
+            return false;
         }
 
     }
@@ -1015,10 +1015,10 @@ RXbBulkInProcessData (
             DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "%s: can not alloc more frag bufs\n",
                 pDevice->dev->name);
         }
-        return FALSE;
+        return false;
     }
 
-    return TRUE;
+    return true;
 }
 
 
@@ -1052,7 +1052,7 @@ static BOOL s_bAPModeRxCtl (
                                          &Status
                                          );
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDeAuthenBeginSta 1\n");
-                    return TRUE;
+                    return true;
                 };
                 if (pMgmt->sNodeDBTable[iSANodeIndex].eNodeState < NODE_ASSOC) {
                     // send deassoc notification
@@ -1064,13 +1064,13 @@ static BOOL s_bAPModeRxCtl (
                                          &Status
                                          );
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDisassocBeginSta 2\n");
-                    return TRUE;
+                    return true;
                 };
 
                 if (pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable) {
                     // delcare received ps-poll event
                     if (IS_CTL_PSPOLL(pbyFrame)) {
-                        pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = TRUE;
+                        pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = true;
 			bScheduleCommand((void *) pDevice,
 					 WLAN_CMD_RX_PSPOLL,
 					 NULL);
@@ -1080,8 +1080,8 @@ static BOOL s_bAPModeRxCtl (
                         // check Data PS state
                         // if PW bit off, send out all PS bufferring packets.
                         if (!IS_FC_POWERMGT(pbyFrame)) {
-                            pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = FALSE;
-                            pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = TRUE;
+                            pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = false;
+                            pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = true;
 				bScheduleCommand((void *) pDevice,
 						 WLAN_CMD_RX_PSPOLL,
 						 NULL);
@@ -1091,15 +1091,15 @@ static BOOL s_bAPModeRxCtl (
                 }
                 else {
                    if (IS_FC_POWERMGT(pbyFrame)) {
-                       pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = TRUE;
+                       pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = true;
                        // Once if STA in PS state, enable multicast bufferring
-                       pMgmt->sNodeDBTable[0].bPSEnable = TRUE;
+                       pMgmt->sNodeDBTable[0].bPSEnable = true;
                    }
                    else {
                       // clear all pending PS frame.
                       if (pMgmt->sNodeDBTable[iSANodeIndex].wEnQueueCnt > 0) {
-                          pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = FALSE;
-                          pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = TRUE;
+                          pMgmt->sNodeDBTable[iSANodeIndex].bPSEnable = false;
+                          pMgmt->sNodeDBTable[iSANodeIndex].bRxPSPoll = true;
 			bScheduleCommand((void *) pDevice,
 					 WLAN_CMD_RX_PSPOLL,
 					 NULL);
@@ -1142,11 +1142,11 @@ static BOOL s_bAPModeRxCtl (
                                 p802_11Header->abyAddr1[5]
                                );
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: wFrameCtl= %x\n", p802_11Header->wFrameCtl );
-                    return TRUE;
+                    return true;
             }
         }
     }
-    return FALSE;
+    return false;
 
 }
 
@@ -1192,7 +1192,7 @@ static BOOL s_bHandleRxEncryption (
             (pMgmt->byCSSPK != KEY_CTL_NONE)) {
             // unicast pkt use pairwise key
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"unicast pkt\n");
-            if (KeybGetKey(&(pDevice->sKey), pDevice->abyBSSID, 0xFFFFFFFF, &pKey) == TRUE) {
+            if (KeybGetKey(&(pDevice->sKey), pDevice->abyBSSID, 0xFFFFFFFF, &pKey) == true) {
                 if (pMgmt->byCSSPK == KEY_CTL_TKIP)
                     byDecMode = KEY_CTL_TKIP;
                 else if (pMgmt->byCSSPK == KEY_CTL_CCMP)
@@ -1226,24 +1226,24 @@ static BOOL s_bHandleRxEncryption (
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey == NULL\n");
         if (byDecMode == KEY_CTL_WEP) {
 //            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass == TRUE) {
+        } else if (pDevice->bLinkPass == true) {
 //            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
         }
-        return FALSE;
+        return false;
     }
     if (byDecMode != pKey->byCipherSuite) {
         if (byDecMode == KEY_CTL_WEP) {
 //            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass == TRUE) {
+        } else if (pDevice->bLinkPass == true) {
 //            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
         }
         *pKeyOut = NULL;
-        return FALSE;
+        return false;
     }
     if (byDecMode == KEY_CTL_WEP) {
         // handle WEP
         if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
-            (((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == TRUE)) {
+            (((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == true)) {
             // Software WEP
             // 1. 3253A
             // 2. WEP 256
@@ -1291,8 +1291,8 @@ static BOOL s_bHandleRxEncryption (
     }// end of TKIP/AES
 
     if ((*(pbyIV+3) & 0x20) != 0)
-        *pbExtIV = TRUE;
-    return TRUE;
+        *pbExtIV = true;
+    return true;
 }
 
 
@@ -1342,18 +1342,18 @@ static BOOL s_bHostWepRxEncryption (
     if (byDecMode != pKey->byCipherSuite) {
         if (byDecMode == KEY_CTL_WEP) {
 //            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass == TRUE) {
+        } else if (pDevice->bLinkPass == true) {
 //            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
         }
-        return FALSE;
+        return false;
     }
 
     if (byDecMode == KEY_CTL_WEP) {
         // handle WEP
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"byDecMode == KEY_CTL_WEP \n");
         if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
-            (((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == TRUE) ||
-            (bOnFly == FALSE)) {
+            (((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == true) ||
+            (bOnFly == false)) {
             // Software WEP
             // 1. 3253A
             // 2. WEP 256
@@ -1386,7 +1386,7 @@ static BOOL s_bHostWepRxEncryption (
 
         if (byDecMode == KEY_CTL_TKIP) {
 
-            if ((pDevice->byLocalID <= REV_ID_VT3253_A1) || (bOnFly == FALSE)) {
+            if ((pDevice->byLocalID <= REV_ID_VT3253_A1) || (bOnFly == false)) {
                 // Software TKIP
                 // 1. 3253 A
                 // 2. NotOnFly
@@ -1406,7 +1406,7 @@ static BOOL s_bHostWepRxEncryption (
         }
 
         if (byDecMode == KEY_CTL_CCMP) {
-            if (bOnFly == FALSE) {
+            if (bOnFly == false) {
                 // Software CCMP
                 // NotOnFly
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"soft KEY_CTL_CCMP\n");
@@ -1422,8 +1422,8 @@ static BOOL s_bHostWepRxEncryption (
     }// end of TKIP/AES
 
     if ((*(pbyIV+3) & 0x20) != 0)
-        *pbExtIV = TRUE;
-    return TRUE;
+        *pbExtIV = true;
+    return true;
 }
 
 
@@ -1439,8 +1439,8 @@ static BOOL s_bAPModeRxData (
 
 {
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    BOOL                bRelayAndForward = FALSE;
-    BOOL                bRelayOnly = FALSE;
+    BOOL                bRelayAndForward = false;
+    BOOL                bRelayOnly = false;
     BYTE                byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
     WORD                wAID;
 
@@ -1448,7 +1448,7 @@ static BOOL s_bAPModeRxData (
     struct sk_buff* skbcpy = NULL;
 
     if (FrameSize > CB_MAX_BUF_SIZE)
-        return FALSE;
+        return false;
     // check DA
     if (is_multicast_ether_addr((PBYTE)(skb->data+cbHeaderOffset))) {
        if (pMgmt->sNodeDBTable[0].bPSEnable) {
@@ -1470,7 +1470,7 @@ static BOOL s_bAPModeRxData (
            }
        }
        else {
-           bRelayAndForward = TRUE;
+           bRelayAndForward = true;
        }
     }
     else {
@@ -1490,10 +1490,10 @@ static BOOL s_bAPModeRxData (
                     pMgmt->abyPSTxMap[wAID >> 3] |=  byMask[wAID & 7];
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "relay: index= %d, pMgmt->abyPSTxMap[%d]= %d\n",
                                iDANodeIndex, (wAID >> 3), pMgmt->abyPSTxMap[wAID >> 3]);
-                    return TRUE;
+                    return true;
                 }
                 else {
-                    bRelayOnly = TRUE;
+                    bRelayOnly = true;
                 }
             }
         };
@@ -1510,13 +1510,13 @@ static BOOL s_bAPModeRxData (
         }
 
         if (bRelayOnly)
-            return FALSE;
+            return false;
     }
     // none associate, don't forward
     if (pDevice->uAssocCount == 0)
-        return FALSE;
+        return false;
 
-    return TRUE;
+    return true;
 }
 
 
@@ -1539,7 +1539,7 @@ void RXvWorkItem(void *Context)
         DequeueRCB(pDevice->FirstRecvFreeList, pDevice->LastRecvFreeList);
         ntStatus = PIPEnsBulkInUsbRead(pDevice, pRCB);
     }
-    pDevice->bIsRxWorkItemQueued = FALSE;
+    pDevice->bIsRxWorkItemQueued = false;
     spin_unlock_irq(&pDevice->lock);
 
 }
@@ -1559,7 +1559,7 @@ RXvFreeRCB(
     ASSERT(!pRCB->Ref);     // should be 0
     ASSERT(pRCB->pDevice);  // shouldn't be NULL
 
-    if (bReAllocSkb == TRUE) {
+    if (bReAllocSkb == true) {
         pRCB->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
         // todo error handling
         if (pRCB->skb == NULL) {
@@ -1576,9 +1576,9 @@ RXvFreeRCB(
 
 
     if (MP_TEST_FLAG(pDevice, fMP_POST_READS) && MP_IS_READY(pDevice) &&
-        (pDevice->bIsRxWorkItemQueued == FALSE) ) {
+        (pDevice->bIsRxWorkItemQueued == false) ) {
 
-        pDevice->bIsRxWorkItemQueued = TRUE;
+        pDevice->bIsRxWorkItemQueued = true;
         tasklet_schedule(&pDevice->ReadWorkItem);
     }
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----RXFreeRCB %d %d\n",pDevice->NumRecvFreeList, pDevice->NumRecvMngList);
@@ -1590,7 +1590,7 @@ void RXvMngWorkItem(void *Context)
     PSDevice pDevice = (PSDevice) Context;
     PRCB            pRCB=NULL;
     PSRxMgmtPacket  pRxPacket;
-    BOOL            bReAllocSkb = FALSE;
+    BOOL            bReAllocSkb = false;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Mng Thread\n");
 
@@ -1615,7 +1615,7 @@ void RXvMngWorkItem(void *Context)
         }
     }
 
-    pDevice->bIsRxMngWorkItemQueued = FALSE;
+    pDevice->bIsRxMngWorkItemQueued = false;
     spin_unlock_irq(&pDevice->lock);
 
 }
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index e1f96d7..36826c9 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -806,7 +806,7 @@ FIRMWAREbDownload(
                 if (pBuffer)
                     kfree(pBuffer);
                 spin_lock_irq(&pDevice->lock);
-                return (FALSE);
+                return (false);
             }
         }
     }
@@ -815,7 +815,7 @@ FIRMWAREbDownload(
         kfree(pBuffer);
 
     spin_lock_irq(&pDevice->lock);
-    return (TRUE);
+    return (true);
 }
 
 BOOL
@@ -836,9 +836,9 @@ FIRMWAREbBrach2Sram(
                                     );
 
     if (NdisStatus != STATUS_SUCCESS) {
-        return (FALSE);
+        return (false);
     } else {
-        return (TRUE);
+        return (true);
     }
 }
 
@@ -860,17 +860,17 @@ FIRMWAREbCheckVersion(
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Firmware Version [%04x]\n", pDevice->wFirmwareVersion);
     if (ntStatus != STATUS_SUCCESS) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Firmware Invalid.\n");
-        return FALSE;
+        return false;
     }
     if (pDevice->wFirmwareVersion == 0xFFFF) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"In Loader.\n");
-        return FALSE;
+        return false;
     }
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Firmware Version [%04x]\n", pDevice->wFirmwareVersion);
     if (pDevice->wFirmwareVersion != FIRMWARE_VERSION) {
         // branch to loader for download new firmware
         FIRMWAREbBrach2Sram(pDevice);
-        return FALSE;
+        return false;
     }
-    return TRUE;
+    return true;
 }
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index f70e922..0c3b519 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -155,9 +155,9 @@ static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
 	}
 	kfree(pDevice->apdev);
 	pDevice->apdev = NULL;
-    pDevice->bEnable8021x = FALSE;
-    pDevice->bEnableHostWEP = FALSE;
-    pDevice->bEncryptionEnable = FALSE;
+    pDevice->bEnable8021x = false;
+    pDevice->bEnableHostWEP = false;
+    pDevice->bEncryptionEnable = false;
 
 	return 0;
 }
@@ -250,7 +250,7 @@ static int hostap_add_sta(PSDevice pDevice,
     pMgmt->sNodeDBTable[uNodeIndex].wCapInfo = param->u.add_sta.capability;
 // TODO listenInterval
 //    pMgmt->sNodeDBTable[uNodeIndex].wListenInterval = 1;
-    pMgmt->sNodeDBTable[uNodeIndex].bPSEnable = FALSE;
+    pMgmt->sNodeDBTable[uNodeIndex].bPSEnable = false;
     pMgmt->sNodeDBTable[uNodeIndex].bySuppRate = param->u.add_sta.tx_supp_rates;
 
     // set max tx rate
@@ -323,7 +323,7 @@ static int hostap_get_info_sta(PSDevice pDevice,
  *      pDevice   -
  *      param     -
  *  Out:
- *      TURE, FALSE
+ *      TURE, false
  *
  * Return Value:
  *
@@ -474,7 +474,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 	int     ret = 0;
 	int     iNodeIndex = -1;
 	int     ii;
-	BOOL    bKeyTableFull = FALSE;
+	BOOL    bKeyTableFull = false;
 	WORD    wKeyCtl = 0;
 
 
@@ -504,7 +504,7 @@ static int hostap_set_encryption(PSDevice pDevice,
         iNodeIndex = 0;
 
 	} else {
-	    if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &iNodeIndex) == FALSE) {
+	    if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &iNodeIndex) == false) {
 	        param->u.crypt.err = HOSTAP_CRYPT_ERR_UNKNOWN_ADDR;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " HOSTAP_CRYPT_ERR_UNKNOWN_ADDR\n");
 	        return -EINVAL;
@@ -515,15 +515,15 @@ static int hostap_set_encryption(PSDevice pDevice,
 
 	if (param->u.crypt.alg == WPA_ALG_NONE) {
 
-        if (pMgmt->sNodeDBTable[iNodeIndex].bOnFly == TRUE) {
+        if (pMgmt->sNodeDBTable[iNodeIndex].bOnFly == true) {
             if (KeybRemoveKey( pDevice,
                                &(pDevice->sKey),
                                param->sta_addr,
                                pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex
-                              ) == FALSE) {
+                              ) == false) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "KeybRemoveKey fail \n");
             }
-            pMgmt->sNodeDBTable[iNodeIndex].bOnFly = FALSE;
+            pMgmt->sNodeDBTable[iNodeIndex].bOnFly = false;
         }
         pMgmt->sNodeDBTable[iNodeIndex].byKeyIndex = 0;
         pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex = 0;
@@ -552,13 +552,13 @@ static int hostap_set_encryption(PSDevice pDevice,
     dwKeyIndex = (DWORD)(param->u.crypt.idx);
     if (param->u.crypt.flags & HOSTAP_CRYPT_FLAG_SET_TX_KEY) {
         pDevice->byKeyIndex = (BYTE)dwKeyIndex;
-        pDevice->bTransmitKey = TRUE;
+        pDevice->bTransmitKey = true;
         dwKeyIndex |= (1 << 31);
     }
 
 	if (param->u.crypt.alg == WPA_ALG_WEP) {
 
-        if ((pDevice->bEnable8021x == FALSE) || (iNodeIndex == 0)) {
+        if ((pDevice->bEnable8021x == false) || (iNodeIndex == 0)) {
             KeybSetDefaultKey(  pDevice,
                                 &(pDevice->sKey),
                                 dwKeyIndex & ~(BIT30 | USE_KEYRSC),
@@ -579,19 +579,19 @@ static int hostap_set_encryption(PSDevice pDevice,
                            (PQWORD) &(KeyRSC),
                            (PBYTE)abyKey,
                             KEY_CTL_WEP
-                           ) == TRUE) {
+                           ) == true) {
 
 
-                pMgmt->sNodeDBTable[iNodeIndex].bOnFly = TRUE;
+                pMgmt->sNodeDBTable[iNodeIndex].bOnFly = true;
 
             } else {
                 // Key Table Full
-                pMgmt->sNodeDBTable[iNodeIndex].bOnFly = FALSE;
-                bKeyTableFull = TRUE;
+                pMgmt->sNodeDBTable[iNodeIndex].bOnFly = false;
+                bKeyTableFull = true;
             }
         }
         pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-        pDevice->bEncryptionEnable = TRUE;
+        pDevice->bEncryptionEnable = true;
         pMgmt->byCSSPK = KEY_CTL_WEP;
         pMgmt->byCSSGK = KEY_CTL_WEP;
         pMgmt->sNodeDBTable[iNodeIndex].byCipherSuite = KEY_CTL_WEP;
@@ -637,7 +637,7 @@ static int hostap_set_encryption(PSDevice pDevice,
                            abyKey,
                            byKeyDecMode
                           );
-       pMgmt->sNodeDBTable[iNodeIndex].bOnFly = TRUE;
+       pMgmt->sNodeDBTable[iNodeIndex].bOnFly = true;
 
     } else {
         dwKeyIndex |= (1 << 30); // set pairwise key
@@ -649,20 +649,20 @@ static int hostap_set_encryption(PSDevice pDevice,
                        (PQWORD) &(KeyRSC),
                        (PBYTE)abyKey,
                         byKeyDecMode
-                       ) == TRUE) {
+                       ) == true) {
 
-            pMgmt->sNodeDBTable[iNodeIndex].bOnFly = TRUE;
+            pMgmt->sNodeDBTable[iNodeIndex].bOnFly = true;
 
         } else {
             // Key Table Full
-            pMgmt->sNodeDBTable[iNodeIndex].bOnFly = FALSE;
-            bKeyTableFull = TRUE;
+            pMgmt->sNodeDBTable[iNodeIndex].bOnFly = false;
+            bKeyTableFull = true;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Key Table Full\n");
         }
 
     }
 
-    if (bKeyTableFull == TRUE) {
+    if (bKeyTableFull == true) {
         wKeyCtl &= 0x7F00;              // clear all key control filed
         wKeyCtl |= (byKeyDecMode << 4);
         wKeyCtl |= (byKeyDecMode);
@@ -684,7 +684,7 @@ static int hostap_set_encryption(PSDevice pDevice,
               );
 
 	// set wep key
-    pDevice->bEncryptionEnable = TRUE;
+    pDevice->bEncryptionEnable = true;
     pMgmt->sNodeDBTable[iNodeIndex].byCipherSuite = byKeyDecMode;
     pMgmt->sNodeDBTable[iNodeIndex].dwKeyIndex = dwKeyIndex;
     pMgmt->sNodeDBTable[iNodeIndex].dwTSC47_16 = 0;
@@ -725,7 +725,7 @@ static int hostap_get_encryption(PSDevice pDevice,
 	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
         iNodeIndex = 0;
 	} else {
-	    if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &iNodeIndex) == FALSE) {
+	    if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &iNodeIndex) == false) {
 	        param->u.crypt.err = HOSTAP_CRYPT_ERR_UNKNOWN_ADDR;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "hostap_get_encryption: HOSTAP_CRYPT_ERR_UNKNOWN_ADDR\n");
 	        return -EINVAL;
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 89f5b18..853a4f5 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -87,7 +87,7 @@ void INTvWorkItem(void *Context)
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
 
 	spin_lock_irq(&pDevice->lock);
-	if (pDevice->fKillEventPollingThread != TRUE)
+	if (pDevice->fKillEventPollingThread != true)
 		ntStatus = PIPEnsInterruptRead(pDevice);
 	spin_unlock_irq(&pDevice->lock);
 }
@@ -153,12 +153,12 @@ INTnsProcessData(PSDevice pDevice)
 				if (pMgmt->byDTIMCount > 0) {
 					pMgmt->byDTIMCount--;
 					pMgmt->sNodeDBTable[0].bRxPSPoll =
-						FALSE;
+						false;
 				} else if (pMgmt->byDTIMCount == 0) {
 					/* check if mutltcast tx bufferring */
 					pMgmt->byDTIMCount =
 						pMgmt->byDTIMPeriod-1;
-					pMgmt->sNodeDBTable[0].bRxPSPoll = TRUE;
+					pMgmt->sNodeDBTable[0].bRxPSPoll = true;
 					if (pMgmt->sNodeDBTable[0].bPSEnable)
 						bScheduleCommand((void *) pDevice,
 								 WLAN_CMD_RX_PSPOLL,
@@ -168,9 +168,9 @@ INTnsProcessData(PSDevice pDevice)
 						WLAN_CMD_BECON_SEND,
 						NULL);
 			} /* if (pDevice->eOPMode == OP_MODE_AP) */
-		pDevice->bBeaconSent = TRUE;
+		pDevice->bBeaconSent = true;
 		} else {
-			pDevice->bBeaconSent = FALSE;
+			pDevice->bBeaconSent = false;
 		}
 		if (pINTData->byISR0 & ISR_TBTT) {
 			if (pDevice->bEnablePSMode)
@@ -211,7 +211,7 @@ INTnsProcessData(PSDevice pDevice)
 					WLAN_CMD_RADIO,
 					NULL);
 	pDevice->intBuf.uDataLen = 0;
-	pDevice->intBuf.bInUse = FALSE;
+	pDevice->intBuf.bInUse = false;
 
 	pStats->tx_packets = pDevice->scStatistic.ullTsrOK;
 	pStats->tx_bytes = pDevice->scStatistic.ullTxDirectedBytes +
diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index fc4554f..2444c50 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -102,7 +102,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         spin_lock_irq(&pDevice->lock);
 
 	if (memcmp(pMgmt->abyCurrBSSID, &abyNullAddr[0], 6) == 0)
-		BSSvClearBSSList((void *) pDevice, FALSE);
+		BSSvClearBSSList((void *) pDevice, false);
 	else
 		BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
 
@@ -128,7 +128,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 			break;
 		};
 
-          if(sZoneTypeCmd.bWrite==TRUE) {
+          if(sZoneTypeCmd.bWrite==true) {
 	  //////write zonetype
                 if(sZoneTypeCmd.ZoneType == ZoneType_USA) {
                   //set to USA
@@ -188,7 +188,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	        pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
 	        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ioct set to STA mode\n");
 	    }
-	    if (sJoinCmd.bPSEnable == TRUE) {
+	    if (sJoinCmd.bPSEnable == true) {
             pDevice->ePSMode = WMAC_POWER_FAST;
 //            pDevice->ePSMode = WMAC_POWER_MAX;
             pMgmt->wListenInterval = 2;
@@ -200,12 +200,12 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Power Saving Off \n");
         }
 
-        if (sJoinCmd.bShareKeyAuth == TRUE){
-            pMgmt->bShareKeyAlgorithm = TRUE;
+        if (sJoinCmd.bShareKeyAuth == true){
+            pMgmt->bShareKeyAlgorithm = true;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Share Key \n");
         }
         else {
-            pMgmt->bShareKeyAlgorithm = FALSE;
+            pMgmt->bShareKeyAlgorithm = false;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Open System \n");
         }
 	    pDevice->uChannel = sJoinCmd.uChannel;
@@ -226,10 +226,10 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 			result = -EFAULT;
 			break;
 		};
-	    if (sWEPCmd.bEnableWep != TRUE) {
+	    if (sWEPCmd.bEnableWep != true) {
 	        int uu;
 
-            pDevice->bEncryptionEnable = FALSE;
+            pDevice->bEncryptionEnable = false;
             pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
             spin_lock_irq(&pDevice->lock);
 	    for (uu = 0; uu < MAX_KEY_TABLE; uu++)
@@ -261,8 +261,8 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
             }
         }
         pDevice->byKeyIndex = sWEPCmd.byKeyIndex;
-        pDevice->bTransmitKey = TRUE;
-        pDevice->bEncryptionEnable = TRUE;
+        pDevice->bTransmitKey = true;
+        pDevice->bEncryptionEnable = true;
         pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 
         break;
@@ -283,8 +283,8 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
             sLinkStatus.byState = ADHOC_STARTED;
 
         sLinkStatus.uChannel = pMgmt->uCurrChannel;
-        if (pDevice->bLinkPass == TRUE) {
-            sLinkStatus.bLink = TRUE;
+        if (pDevice->bLinkPass == true) {
+            sLinkStatus.bLink = true;
  		    pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
 		    memcpy(sLinkStatus.abySSID, pItemSSID->abySSID, pItemSSID->len);
 		    memcpy(sLinkStatus.abyBSSID, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
@@ -292,7 +292,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Link Success ! \n");
         }
         else {
-            sLinkStatus.bLink = FALSE;
+            sLinkStatus.bLink = false;
         }
         if (copy_to_user(pReq->data, &sLinkStatus, sizeof(SCmdLinkStatus))) {
 			result = -EFAULT;
@@ -350,10 +350,10 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
     		        pList->sBSSIDList[ii].byNetType = ADHOC;
     		    }
     		    if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo)) {
-    		        pList->sBSSIDList[ii].bWEPOn = TRUE;
+    		        pList->sBSSIDList[ii].bWEPOn = true;
                 }
                 else {
-    		        pList->sBSSIDList[ii].bWEPOn = FALSE;
+    		        pList->sBSSIDList[ii].bWEPOn = false;
     		    }
     		    ii ++;
     		    if (ii >= pList->uItem)
@@ -388,16 +388,16 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         // Todo xxxxxx
         netif_stop_queue(pDevice->dev);
         spin_lock_irq(&pDevice->lock);
-        if (pDevice->bRadioOff == FALSE) {
+        if (pDevice->bRadioOff == false) {
             CARDbRadioPowerOff(pDevice);
         }
-        pDevice->bLinkPass = FALSE;
+        pDevice->bLinkPass = false;
         ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
         memset(pMgmt->abyCurrBSSID, 0, 6);
         pMgmt->eCurrState = WMAC_STATE_IDLE;
 //        del_timer(&pDevice->sTimerCommand);
 //        del_timer(&pMgmt->sTimerSecondCallback);
-        pDevice->bCmdRunning = FALSE;
+        pDevice->bCmdRunning = false;
         spin_unlock_irq(&pDevice->lock);
 
         break;
@@ -406,7 +406,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_START_MAC\n");
         // Todo xxxxxxx
-        if (pDevice->bRadioOff == TRUE)
+        if (pDevice->bRadioOff == true)
             CARDbRadioPowerOn(pDevice);
         break;
 
@@ -448,11 +448,11 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 		};
 
 		if (sValue.dwValue == 1) {
-            pDevice->bEnable8021x = TRUE;
+            pDevice->bEnable8021x = true;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable 802.1x\n");
         }
         else {
-            pDevice->bEnable8021x = FALSE;
+            pDevice->bEnable8021x = false;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable 802.1x\n");
         }
 
@@ -468,11 +468,11 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 		};
 
 		if (sValue.dwValue == 1) {
-            pDevice->bEnableHostWEP = TRUE;
+            pDevice->bEnableHostWEP = true;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable HostWEP\n");
         }
         else {
-            pDevice->bEnableHostWEP = FALSE;
+            pDevice->bEnableHostWEP = false;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable HostWEP\n");
         }
 
@@ -490,11 +490,11 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 		   memcpy(pDevice->wpadev->dev_addr,
 			  pDevice->dev->dev_addr,
 			  ETH_ALEN);
-		   pDevice->bWPADEVUp = TRUE;
+		   pDevice->bWPADEVUp = true;
         }
         else {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "close wpadev\n");
-	   pDevice->bWPADEVUp = FALSE;
+	   pDevice->bWPADEVUp = false;
         }
 
         break;
@@ -502,7 +502,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
     case WLAN_CMD_AP_START:
 
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_AP_START\n");
-        if (pDevice->bRadioOff == TRUE) {
+        if (pDevice->bRadioOff == true) {
             CARDbRadioPowerOn(pDevice);
             add_timer(&pMgmt->sTimerSecondCallback);
         }
@@ -544,12 +544,12 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
         else
             pMgmt->wIBSSBeaconPeriod = 100;
 
-        if (sStartAPCmd.bShareKeyAuth == TRUE){
-            pMgmt->bShareKeyAlgorithm = TRUE;
+        if (sStartAPCmd.bShareKeyAuth == true){
+            pMgmt->bShareKeyAlgorithm = true;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Share Key \n");
         }
         else {
-            pMgmt->bShareKeyAlgorithm = FALSE;
+            pMgmt->bShareKeyAlgorithm = false;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Open System \n");
         }
         memcpy(pMgmt->abyIBSSSuppRates, abySuppRates, 6);
@@ -662,8 +662,8 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	    wpa_Result.proto = 0;
 	    wpa_Result.key_mgmt = 0;
 	    wpa_Result.eap_type = 0;
-	    wpa_Result.authenticated = FALSE;
-	      pDevice->fWPA_Authened = FALSE;
+	    wpa_Result.authenticated = false;
+	      pDevice->fWPA_Authened = false;
         if (copy_from_user(&wpa_Result, pReq->data, sizeof(wpa_Result))) {
             result = -EFAULT;
 			break;
@@ -675,7 +675,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
     pMgmt->Cisco_cckm =0;
 //DavidWang
 
-if(wpa_Result.authenticated==TRUE) {
+if(wpa_Result.authenticated==true) {
    {
      union iwreq_data      wrqu;
 
@@ -686,7 +686,7 @@ if(wpa_Result.authenticated==TRUE) {
      wrqu.data.length =pItemSSID->len;
      wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, pItemSSID->abySSID);
    }
-         pDevice->fWPA_Authened = TRUE;           //is successful peer to wpa_Result.authenticated?
+         pDevice->fWPA_Authened = true;           //is successful peer to wpa_Result.authenticated?
 }
 
         //printk("get private wpa_supplicant announce WPA SM\n");
@@ -694,7 +694,7 @@ if(wpa_Result.authenticated==TRUE) {
 	//printk("wpa-->proto=%d\n",wpa_Result.proto);
 	//printk("wpa-->key-mgmt=%d\n",wpa_Result.key_mgmt);
 	//printk("wpa-->eap_type=%d\n",wpa_Result.eap_type);
-	//printk("wpa-->authenticated is %s\n",(wpa_Result.authenticated==TRUE)?"TRUE":"FALSE");
+	//printk("wpa-->authenticated is %s\n",(wpa_Result.authenticated==true)?"true":"false");
 
 	pReq->wResult = 0;
         break;
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 5ad57a0..7c13d55 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -99,7 +99,7 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	       else
 		   pDevice->scStatistic.LinkQuality = (96-pDevice->byCurrSQ)*100/76;
 	   }
-	   if(pDevice->bLinkPass !=TRUE)
+	   if(pDevice->bLinkPass !=true)
 	       pDevice->scStatistic.LinkQuality = 0;
 	  #endif
 	   if(pDevice->scStatistic.LinkQuality > 100)
@@ -512,7 +512,7 @@ int iwctl_siwmode(struct net_device *dev,
 	    if (pMgmt->eConfigMode != WMAC_CONFIG_IBSS_STA) {
             pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
             if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-		        pDevice->bCommit = TRUE;
+		        pDevice->bCommit = true;
    		    }
 		}
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to ad-hoc \n");
@@ -522,7 +522,7 @@ int iwctl_siwmode(struct net_device *dev,
 	    if (pMgmt->eConfigMode != WMAC_CONFIG_ESS_STA) {
             pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
             if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-		        pDevice->bCommit = TRUE;
+		        pDevice->bCommit = true;
    		    }
 		}
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to infrastructure \n");
@@ -536,7 +536,7 @@ int iwctl_siwmode(struct net_device *dev,
 	    if (pMgmt->eConfigMode != WMAC_CONFIG_AP) {
             pMgmt->eConfigMode = WMAC_CONFIG_AP;
             if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-		        pDevice->bCommit = TRUE;
+		        pDevice->bCommit = true;
    		    }
 		}
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to Access Point \n");
@@ -751,7 +751,7 @@ int iwctl_siwap(struct net_device *dev,
        	}
 
         if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-		    pDevice->bCommit = TRUE;
+		    pDevice->bCommit = true;
    		}
 	}
 	return rc;
@@ -775,8 +775,8 @@ int iwctl_giwap(struct net_device *dev,
     memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
 
 //20080123-02,<Modify> by Einsn Liu
- if ((pDevice->bLinkPass == FALSE) && (pMgmt->eCurrMode != WMAC_MODE_ESS_AP))
- //   if ((pDevice->bLinkPass == FALSE) && (pMgmt->eCurrMode == WMAC_MODE_ESS_STA))
+ if ((pDevice->bLinkPass == false) && (pMgmt->eCurrMode != WMAC_MODE_ESS_AP))
+ //   if ((pDevice->bLinkPass == false) && (pMgmt->eCurrMode == WMAC_MODE_ESS_STA))
         memset(wrq->sa_data, 0, 6);
 
     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -861,7 +861,7 @@ int iwctl_siwessid(struct net_device *dev,
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWESSID :\n");
 
-         pDevice->fWPA_Authened = FALSE;
+         pDevice->fWPA_Authened = false;
 	// Check if we asked for `any'
 	if(wrq->flags == 0) {
 		// Just send an empty SSID list
@@ -896,7 +896,7 @@ int iwctl_siwessid(struct net_device *dev,
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
  //Wext wil order another command of siwap to link with desired AP,
  //so here need not associate??
-  if(pDevice->bWPASuppWextEnabled == TRUE)  {
+  if(pDevice->bWPASuppWextEnabled == true)  {
         /*******search if  in hidden ssid mode ****/
         {
            PKnownBSS       pCurr = NULL;
@@ -951,7 +951,7 @@ int iwctl_siwessid(struct net_device *dev,
 	}
 
     if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-	    pDevice->bCommit = TRUE;
+	    pDevice->bCommit = true;
 	}
 
 
@@ -1055,7 +1055,7 @@ int iwctl_siwrate(struct net_device *dev,
 	if(wrq->fixed != 0) {
 		// Fixed mode
 		// One rate, fixed
-		pDevice->bFixRate = TRUE;
+		pDevice->bFixRate = true;
         if ((pDevice->byBBType == BB_TYPE_11B)&& (brate > 3)) {
             pDevice->uConnectionRate = 3;
         }
@@ -1066,7 +1066,7 @@ int iwctl_siwrate(struct net_device *dev,
 
 	}
 	else {
-        pDevice->bFixRate = FALSE;
+        pDevice->bFixRate = false;
         pDevice->uConnectionRate = 13;
     }
 
@@ -1112,8 +1112,8 @@ int iwctl_giwrate(struct net_device *dev,
                 brate = abySupportedRates[pDevice->wCurrentRate];
 	    wrq->value = brate * 500000;
 	    // If more than one rate, set auto
-	    if (pDevice->bFixRate == TRUE)
-	        wrq->fixed = TRUE;
+	    if (pDevice->bFixRate == true)
+	        wrq->fixed = true;
     }
 
 
@@ -1353,8 +1353,8 @@ int iwctl_siwencode(struct net_device *dev,
         }
         pDevice->byKeyIndex = (BYTE)dwKeyIndex;
         pDevice->uKeyLength = wrq->length;
-        pDevice->bTransmitKey = TRUE;
-        pDevice->bEncryptionEnable = TRUE;
+        pDevice->bTransmitKey = true;
+        pDevice->bEncryptionEnable = true;
         pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 
 		// Do we want to just set the transmit key index ?
@@ -1369,8 +1369,8 @@ int iwctl_siwencode(struct net_device *dev,
 	if(wrq->flags & IW_ENCODE_DISABLED){
 
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable WEP function\n");
-		pMgmt->bShareKeyAlgorithm = FALSE;
-        pDevice->bEncryptionEnable = FALSE;
+		pMgmt->bShareKeyAlgorithm = false;
+        pDevice->bEncryptionEnable = false;
         pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
         if (pDevice->flags & DEVICE_FLAGS_OPENED) {
             spin_lock_irq(&pDevice->lock);
@@ -1381,11 +1381,11 @@ int iwctl_siwencode(struct net_device *dev,
 	}
 	if(wrq->flags & IW_ENCODE_RESTRICTED) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & ShareKey System\n");
-		pMgmt->bShareKeyAlgorithm = TRUE;
+		pMgmt->bShareKeyAlgorithm = true;
 	}
 	if(wrq->flags & IW_ENCODE_OPEN) {
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & Open System\n");
-		pMgmt->bShareKeyAlgorithm = FALSE;
+		pMgmt->bShareKeyAlgorithm = false;
 	}
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
@@ -1599,7 +1599,7 @@ int iwctl_giwsens(struct net_device *dev,
     long ldBm;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS \n");
-    if (pDevice->bLinkPass == TRUE) {
+    if (pDevice->bLinkPass == true) {
         RFvRSSITodBm(pDevice, (BYTE)(pDevice->uCurrRSSI), &ldBm);
 	    wrq->value = ldBm;
 	}
@@ -1633,7 +1633,7 @@ int iwctl_siwauth(struct net_device *dev,
 		wpa_version = wrq->value;
 		if(wrq->value == IW_AUTH_WPA_VERSION_DISABLED) {
 		       PRINT_K("iwctl_siwauth:set WPADEV to disable at 1??????\n");
-			//pDevice->bWPADEVUp = FALSE;
+			//pDevice->bWPADEVUp = false;
 		}
 		else if(wrq->value == IW_AUTH_WPA_VERSION_WPA) {
                           PRINT_K("iwctl_siwauth:set WPADEV to WPA1******\n");
@@ -1641,7 +1641,7 @@ int iwctl_siwauth(struct net_device *dev,
 		else {
                           PRINT_K("iwctl_siwauth:set WPADEV to WPA2******\n");
 		}
-		//pDevice->bWPASuppWextEnabled =TRUE;
+		//pDevice->bWPASuppWextEnabled =true;
 		break;
 	case IW_AUTH_CIPHER_PAIRWISE:
 		pairwise = wrq->value;
@@ -1691,14 +1691,14 @@ int iwctl_siwauth(struct net_device *dev,
 	case IW_AUTH_80211_AUTH_ALG:
 		 PRINT_K("iwctl_siwauth:set AUTH_ALG=%d\n",wrq->value);
 		if(wrq->value==IW_AUTH_ALG_OPEN_SYSTEM){
-			pMgmt->bShareKeyAlgorithm=FALSE;
+			pMgmt->bShareKeyAlgorithm=false;
 		}else if(wrq->value==IW_AUTH_ALG_SHARED_KEY){
-			pMgmt->bShareKeyAlgorithm=TRUE;
+			pMgmt->bShareKeyAlgorithm=true;
 		}
 		break;
 	case IW_AUTH_WPA_ENABLED:
 		//pDevice->bWPADEVUp = !! wrq->value;
-		//if(pDevice->bWPADEVUp==TRUE)
+		//if(pDevice->bWPADEVUp==true)
 		  // printk("iwctl_siwauth:set WPADEV to enable successful*******\n");
 		//else
 		 //  printk("iwctl_siwauth:set WPADEV to enable fail?????\n");
@@ -1710,13 +1710,13 @@ int iwctl_siwauth(struct net_device *dev,
 		break;
 	case IW_AUTH_PRIVACY_INVOKED:
 		pDevice->bEncryptionEnable = !!wrq->value;
-		if(pDevice->bEncryptionEnable == FALSE){
+		if(pDevice->bEncryptionEnable == false){
 			wpa_version = 0;
 			pairwise = 0;
 			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-			pMgmt->bShareKeyAlgorithm = FALSE;
+			pMgmt->bShareKeyAlgorithm = false;
 			pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-			//pDevice->bWPADEVUp = FALSE;
+			//pDevice->bWPADEVUp = false;
 			 PRINT_K("iwctl_siwauth:set WPADEV to disaable at 2?????\n");
 		}
 
@@ -1730,9 +1730,9 @@ int iwctl_siwauth(struct net_device *dev,
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise = %d\n",pairwise);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->eEncryptionStatus = %d\n",pDevice->eEncryptionStatus);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->eAuthenMode  = %d\n",pMgmt->eAuthenMode);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->bShareKeyAlgorithm = %s\n",pMgmt->bShareKeyAlgorithm?"TRUE":"FALSE");
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->bEncryptionEnable = %s\n",pDevice->bEncryptionEnable?"TRUE":"FALSE");
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->bWPADEVUp = %s\n",pDevice->bWPADEVUp?"TRUE":"FALSE");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->bShareKeyAlgorithm = %s\n",pMgmt->bShareKeyAlgorithm?"true":"false");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->bEncryptionEnable = %s\n",pDevice->bEncryptionEnable?"true":"false");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->bWPADEVUp = %s\n",pDevice->bWPADEVUp?"true":"false");
 */
    return ret;
 }
@@ -1899,35 +1899,35 @@ param->u.wpa_key.seq_len = seq_len;
 //****this method is so foolish,but there is no other way???
 if(param->u.wpa_key.alg_name == WPA_ALG_NONE) {
    if(param->u.wpa_key.key_index ==0) {
-     pDevice->bwextstep0 = TRUE;
+     pDevice->bwextstep0 = true;
     }
-   if((pDevice->bwextstep0 = TRUE)&&(param->u.wpa_key.key_index ==1)) {
-     pDevice->bwextstep0 = FALSE;
-     pDevice->bwextstep1 = TRUE;
+   if((pDevice->bwextstep0 = true)&&(param->u.wpa_key.key_index ==1)) {
+     pDevice->bwextstep0 = false;
+     pDevice->bwextstep1 = true;
     }
-   if((pDevice->bwextstep1 = TRUE)&&(param->u.wpa_key.key_index ==2)) {
-     pDevice->bwextstep1 = FALSE;
-     pDevice->bwextstep2 = TRUE;
+   if((pDevice->bwextstep1 = true)&&(param->u.wpa_key.key_index ==2)) {
+     pDevice->bwextstep1 = false;
+     pDevice->bwextstep2 = true;
 	}
-   if((pDevice->bwextstep2 = TRUE)&&(param->u.wpa_key.key_index ==3)) {
-     pDevice->bwextstep2 = FALSE;
-     pDevice->bwextstep3 = TRUE;
+   if((pDevice->bwextstep2 = true)&&(param->u.wpa_key.key_index ==3)) {
+     pDevice->bwextstep2 = false;
+     pDevice->bwextstep3 = true;
         }
 		 }
-if(pDevice->bwextstep3 == TRUE) {
+if(pDevice->bwextstep3 == true) {
     PRINT_K("SIOCSIWENCODEEXT:Enable WPA WEXT SUPPORT!!!!!\n");
-     pDevice->bwextstep0 = FALSE;
-     pDevice->bwextstep1 = FALSE;
-     pDevice->bwextstep2 = FALSE;
-     pDevice->bwextstep3 = FALSE;
-     pDevice->bWPASuppWextEnabled = TRUE;
+     pDevice->bwextstep0 = false;
+     pDevice->bwextstep1 = false;
+     pDevice->bwextstep2 = false;
+     pDevice->bwextstep3 = false;
+     pDevice->bWPASuppWextEnabled = true;
      memset(pMgmt->abyDesireBSSID, 0xFF,6);
      KeyvInitTable(pDevice,&pDevice->sKey);
 		 }
 //******
 
 		spin_lock_irq(&pDevice->lock);
- ret = wpa_set_keys(pDevice, param, TRUE);
+ ret = wpa_set_keys(pDevice, param, true);
 		spin_unlock_irq(&pDevice->lock);
 
 error:
@@ -1969,7 +1969,7 @@ int iwctl_siwmlme(struct net_device *dev,
 		   (PBYTE)&reason); */
 		//break;
 	case IW_MLME_DISASSOC:
-		if(pDevice->bLinkPass == TRUE){
+		if(pDevice->bLinkPass == true){
 		  PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
 		  bScheduleCommand((void *) pDevice,
 				   WLAN_CMD_DISASSOCIATE,
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index d181a2f..d923cc9 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -69,17 +69,17 @@ static void s_vCheckKeyTableValid(void *pDeviceHandler,
     BYTE        pbyData[MAX_KEY_TABLE];
 
     for (i=0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse == TRUE) &&
-            (pTable->KeyTable[i].PairwiseKey.bKeyValid == FALSE) &&
-            (pTable->KeyTable[i].GroupKey[0].bKeyValid == FALSE) &&
-            (pTable->KeyTable[i].GroupKey[1].bKeyValid == FALSE) &&
-            (pTable->KeyTable[i].GroupKey[2].bKeyValid == FALSE) &&
-            (pTable->KeyTable[i].GroupKey[3].bKeyValid == FALSE)
+        if ((pTable->KeyTable[i].bInUse == true) &&
+            (pTable->KeyTable[i].PairwiseKey.bKeyValid == false) &&
+            (pTable->KeyTable[i].GroupKey[0].bKeyValid == false) &&
+            (pTable->KeyTable[i].GroupKey[1].bKeyValid == false) &&
+            (pTable->KeyTable[i].GroupKey[2].bKeyValid == false) &&
+            (pTable->KeyTable[i].GroupKey[3].bKeyValid == false)
             ) {
 
-            pTable->KeyTable[i].bInUse = FALSE;
+            pTable->KeyTable[i].bInUse = false;
             pTable->KeyTable[i].wKeyCtl = 0;
-            pTable->KeyTable[i].bSoftWEP = FALSE;
+            pTable->KeyTable[i].bSoftWEP = false;
             pbyData[wLength++] = (BYTE) i;
             //MACvDisableKeyEntry(pDevice, i);
         }
@@ -121,18 +121,18 @@ void KeyvInitTable(void *pDeviceHandler, PSKeyManagement pTable)
 
     spin_lock_irq(&pDevice->lock);
     for (i=0;i<MAX_KEY_TABLE;i++) {
-        pTable->KeyTable[i].bInUse = FALSE;
-        pTable->KeyTable[i].PairwiseKey.bKeyValid = FALSE;
+        pTable->KeyTable[i].bInUse = false;
+        pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
 	pTable->KeyTable[i].PairwiseKey.pvKeyTable =
 	  (void *)&pTable->KeyTable[i];
         for (jj=0; jj < MAX_GROUP_KEY; jj++) {
-            pTable->KeyTable[i].GroupKey[jj].bKeyValid = FALSE;
+            pTable->KeyTable[i].GroupKey[jj].bKeyValid = false;
 	    pTable->KeyTable[i].GroupKey[jj].pvKeyTable =
 	      (void *) &(pTable->KeyTable[i]);
         }
         pTable->KeyTable[i].wKeyCtl = 0;
         pTable->KeyTable[i].dwGTKeyIndex = 0;
-        pTable->KeyTable[i].bSoftWEP = FALSE;
+        pTable->KeyTable[i].bSoftWEP = false;
         pbyData[i] = (BYTE) i;
     }
     pbyData[i] = (BYTE) i;
@@ -161,7 +161,7 @@ void KeyvInitTable(void *pDeviceHandler, PSKeyManagement pTable)
  *  Out:
  *      pKey            - Key return
  *
- * Return Value: TRUE if found otherwise FALSE
+ * Return Value: true if found otherwise false
  *
  */
 BOOL KeybGetKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyIndex,
@@ -173,31 +173,31 @@ BOOL KeybGetKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyIndex,
 
     *pKey = NULL;
     for (i=0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse == TRUE) &&
+        if ((pTable->KeyTable[i].bInUse == true) &&
 	    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
             if (dwKeyIndex == 0xFFFFFFFF) {
-                if (pTable->KeyTable[i].PairwiseKey.bKeyValid == TRUE) {
+                if (pTable->KeyTable[i].PairwiseKey.bKeyValid == true) {
                     *pKey = &(pTable->KeyTable[i].PairwiseKey);
-                    return (TRUE);
+                    return (true);
                 }
                 else {
-                    return (FALSE);
+                    return (false);
                 }
             } else if (dwKeyIndex < MAX_GROUP_KEY) {
-                if (pTable->KeyTable[i].GroupKey[dwKeyIndex].bKeyValid == TRUE) {
+                if (pTable->KeyTable[i].GroupKey[dwKeyIndex].bKeyValid == true) {
                     *pKey = &(pTable->KeyTable[i].GroupKey[dwKeyIndex]);
-                    return (TRUE);
+                    return (true);
                 }
                 else {
-                    return (FALSE);
+                    return (false);
                 }
             }
             else {
-                return (FALSE);
+                return (false);
             }
         }
     }
-    return (FALSE);
+    return (false);
 }
 
 
@@ -215,7 +215,7 @@ BOOL KeybGetKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyIndex,
  *  Out:
  *      none
  *
- * Return Value: TRUE if success otherwise FALSE
+ * Return Value: true if success otherwise false
  *
  */
 BOOL KeybSetKey(
@@ -239,12 +239,12 @@ BOOL KeybSetKey(
 
     j = (MAX_KEY_TABLE-1);
     for (i=0;i<(MAX_KEY_TABLE-1);i++) {
-        if ((pTable->KeyTable[i].bInUse == FALSE) &&
+        if ((pTable->KeyTable[i].bInUse == false) &&
             (j == (MAX_KEY_TABLE-1))) {
             // found empty table
             j = i;
         }
-        if ((pTable->KeyTable[i].bInUse == TRUE) &&
+        if ((pTable->KeyTable[i].bInUse == true) &&
 	    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
             // found table already exist
             if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
@@ -256,7 +256,7 @@ BOOL KeybSetKey(
             } else {
                 // Group key
                 if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY)
-                    return (FALSE);
+                    return (false);
                 pKey = &(pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF]);
                 if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
                     // Group transmit key
@@ -270,7 +270,7 @@ BOOL KeybSetKey(
             }
             pTable->KeyTable[i].wKeyCtl |= 0x8000;              // enable on-fly
 
-            pKey->bKeyValid = TRUE;
+            pKey->bKeyValid = true;
             pKey->uKeyLength = uKeyLength;
             pKey->dwKeyIndex = dwKeyIndex;
             pKey->byCipherSuite = byKeyDecMode;
@@ -306,12 +306,12 @@ BOOL KeybSetKey(
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ", pKey->wTSC15_0);
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %lx\n ", pKey->dwKeyIndex);
 
-            return (TRUE);
+            return (true);
         }
     }
     if (j < (MAX_KEY_TABLE-1)) {
 	memcpy(pTable->KeyTable[j].abyBSSID, pbyBSSID, ETH_ALEN);
-        pTable->KeyTable[j].bInUse = TRUE;
+        pTable->KeyTable[j].bInUse = true;
         if ((dwKeyIndex & PAIRWISE_KEY) != 0)  {
             // Pairwise key
             pKey = &(pTable->KeyTable[j].PairwiseKey);
@@ -321,7 +321,7 @@ BOOL KeybSetKey(
         } else {
             // Group key
             if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY)
-                return (FALSE);
+                return (false);
             pKey = &(pTable->KeyTable[j].GroupKey[dwKeyIndex & 0x000000FF]);
             if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
                 // Group transmit key
@@ -335,7 +335,7 @@ BOOL KeybSetKey(
         }
         pTable->KeyTable[j].wKeyCtl |= 0x8000;              // enable on-fly
 
-        pKey->bKeyValid = TRUE;
+        pKey->bKeyValid = true;
         pKey->uKeyLength = uKeyLength;
         pKey->dwKeyIndex = dwKeyIndex;
         pKey->byCipherSuite = byKeyDecMode;
@@ -371,9 +371,9 @@ BOOL KeybSetKey(
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ", pKey->wTSC15_0);
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %lx\n ", pKey->dwKeyIndex);
 
-        return (TRUE);
+        return (true);
     }
-    return (FALSE);
+    return (false);
 }
 
 
@@ -388,7 +388,7 @@ BOOL KeybSetKey(
  *  Out:
  *      none
  *
- * Return Value: TRUE if success otherwise FALSE
+ * Return Value: true if success otherwise false
  *
  */
 BOOL KeybRemoveKey(
@@ -400,56 +400,56 @@ BOOL KeybRemoveKey(
 {
     PSDevice    pDevice = (PSDevice) pDeviceHandler;
     int     i;
-    BOOL    bReturnValue = FALSE;
+    BOOL    bReturnValue = false;
 
     if (is_broadcast_ether_addr(pbyBSSID)) {
         // dealte all key
         if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
             for (i=0;i<MAX_KEY_TABLE;i++) {
-                pTable->KeyTable[i].PairwiseKey.bKeyValid = FALSE;
+                pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
             }
-            bReturnValue =  TRUE;
+            bReturnValue =  true;
         }
         else if ((dwKeyIndex & 0x000000FF) < MAX_GROUP_KEY) {
             for (i=0;i<MAX_KEY_TABLE;i++) {
-                pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF].bKeyValid = FALSE;
+                pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF].bKeyValid = false;
                 if ((dwKeyIndex & 0x7FFFFFFF) == (pTable->KeyTable[i].dwGTKeyIndex & 0x7FFFFFFF)) {
                     // remove Group transmit key
                     pTable->KeyTable[i].dwGTKeyIndex = 0;
                 }
             }
-            bReturnValue = TRUE;
+            bReturnValue = true;
         }
         else {
-            bReturnValue = FALSE;
+            bReturnValue = false;
         }
 
     } else {
         for (i=0;i<MAX_KEY_TABLE;i++) {
-            if ( (pTable->KeyTable[i].bInUse == TRUE) &&
+            if ( (pTable->KeyTable[i].bInUse == true) &&
 		 !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 
                 if ((dwKeyIndex & PAIRWISE_KEY) != 0) {
-                    pTable->KeyTable[i].PairwiseKey.bKeyValid = FALSE;
-                    bReturnValue = TRUE;
+                    pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
+                    bReturnValue = true;
                     break;
                 }
                 else if ((dwKeyIndex & 0x000000FF) < MAX_GROUP_KEY) {
-                    pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF].bKeyValid = FALSE;
+                    pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF].bKeyValid = false;
                     if ((dwKeyIndex & 0x7FFFFFFF) == (pTable->KeyTable[i].dwGTKeyIndex & 0x7FFFFFFF)) {
                         // remove Group transmit key
                         pTable->KeyTable[i].dwGTKeyIndex = 0;
                     }
-                    bReturnValue = TRUE;
+                    bReturnValue = true;
                     break;
                 }
                 else {
-                    bReturnValue = FALSE;
+                    bReturnValue = false;
                     break;
                 }
-            } //pTable->KeyTable[i].bInUse == TRUE
+            } //pTable->KeyTable[i].bInUse == true
         }  //for
-        bReturnValue = TRUE;
+        bReturnValue = true;
     }
 
     s_vCheckKeyTableValid(pDevice,pTable);
@@ -469,7 +469,7 @@ BOOL KeybRemoveKey(
  *  Out:
  *      none
  *
- * Return Value: TRUE if success otherwise FALSE
+ * Return Value: true if success otherwise false
  *
  */
 BOOL KeybRemoveAllKey(
@@ -482,18 +482,18 @@ BOOL KeybRemoveAllKey(
     int  i,u;
 
     for (i=0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse == TRUE) &&
+        if ((pTable->KeyTable[i].bInUse == true) &&
 	    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
-            pTable->KeyTable[i].PairwiseKey.bKeyValid = FALSE;
+            pTable->KeyTable[i].PairwiseKey.bKeyValid = false;
 	    for (u = 0; u < MAX_GROUP_KEY; u++)
-		pTable->KeyTable[i].GroupKey[u].bKeyValid = FALSE;
+		pTable->KeyTable[i].GroupKey[u].bKeyValid = false;
 
             pTable->KeyTable[i].dwGTKeyIndex = 0;
             s_vCheckKeyTableValid(pDevice, pTable);
-            return (TRUE);
+            return (true);
         }
     }
-    return (FALSE);
+    return (false);
 }
 
 /*
@@ -505,7 +505,7 @@ BOOL KeybRemoveAllKey(
  *  Out:
  *      none
  *
- * Return Value: TRUE if success otherwise FALSE
+ * Return Value: true if success otherwise false
  *
  */
 void KeyvRemoveWEPKey(
@@ -517,9 +517,9 @@ void KeyvRemoveWEPKey(
     PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
    if ((dwKeyIndex & 0x000000FF) < MAX_GROUP_KEY) {
-        if (pTable->KeyTable[MAX_KEY_TABLE-1].bInUse == TRUE) {
+        if (pTable->KeyTable[MAX_KEY_TABLE-1].bInUse == true) {
             if (pTable->KeyTable[MAX_KEY_TABLE-1].GroupKey[dwKeyIndex & 0x000000FF].byCipherSuite == KEY_CTL_WEP) {
-                pTable->KeyTable[MAX_KEY_TABLE-1].GroupKey[dwKeyIndex & 0x000000FF].bKeyValid = FALSE;
+                pTable->KeyTable[MAX_KEY_TABLE-1].GroupKey[dwKeyIndex & 0x000000FF].bKeyValid = false;
                 if ((dwKeyIndex & 0x7FFFFFFF) == (pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex & 0x7FFFFFFF)) {
                     // remove Group transmit key
                     pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex = 0;
@@ -550,7 +550,7 @@ void KeyvRemoveAllWEPKey(void *pDeviceHandler, PSKeyManagement pTable)
  *  Out:
  *      pKey            - Key return
  *
- * Return Value: TRUE if found otherwise FALSE
+ * Return Value: true if found otherwise false
  *
  */
 BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
@@ -560,12 +560,12 @@ BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
 
     *pKey = NULL;
     for (i=0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse == TRUE) &&
+        if ((pTable->KeyTable[i].bInUse == true) &&
 	    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
 
             if (dwKeyType == PAIRWISE_KEY) {
 
-                if (pTable->KeyTable[i].PairwiseKey.bKeyValid == TRUE) {
+                if (pTable->KeyTable[i].PairwiseKey.bKeyValid == true) {
                     *pKey = &(pTable->KeyTable[i].PairwiseKey);
 
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybGetTransmitKey:");
@@ -576,19 +576,19 @@ BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
 
 
-                    return (TRUE);
+                    return (true);
                 }
                 else {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"PairwiseKey.bKeyValid == FALSE\n");
-                    return (FALSE);
+                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"PairwiseKey.bKeyValid == false\n");
+                    return (false);
                 }
             } // End of Type == PAIRWISE
             else {
                 if (pTable->KeyTable[i].dwGTKeyIndex == 0) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ERROR: dwGTKeyIndex == 0 !!!\n");
-                    return FALSE;
+                    return false;
                 }
-                if (pTable->KeyTable[i].GroupKey[(pTable->KeyTable[i].dwGTKeyIndex&0x000000FF)].bKeyValid == TRUE) {
+                if (pTable->KeyTable[i].GroupKey[(pTable->KeyTable[i].dwGTKeyIndex&0x000000FF)].bKeyValid == true) {
                     *pKey = &(pTable->KeyTable[i].GroupKey[(pTable->KeyTable[i].dwGTKeyIndex&0x000000FF)]);
 
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybGetTransmitKey:");
@@ -599,11 +599,11 @@ BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"dwGTKeyIndex: %lX\n", pTable->KeyTable[i].dwGTKeyIndex);
 
-                    return (TRUE);
+                    return (true);
                 }
                 else {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GroupKey.bKeyValid == FALSE\n");
-                    return (FALSE);
+                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GroupKey.bKeyValid == false\n");
+                    return (false);
                 }
             } // End of Type = GROUP
         } // BSSID match
@@ -613,7 +613,7 @@ BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"%02x ", *(pbyBSSID+ii));
     }
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-    return (FALSE);
+    return (false);
 }
 
 
@@ -626,7 +626,7 @@ BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
  *  Out:
  *      none
  *
- * Return Value: TRUE if found otherwise FALSE
+ * Return Value: true if found otherwise false
  *
  */
 BOOL KeybCheckPairewiseKey(PSKeyManagement pTable, PSKeyItem *pKey)
@@ -635,13 +635,13 @@ BOOL KeybCheckPairewiseKey(PSKeyManagement pTable, PSKeyItem *pKey)
 
     *pKey = NULL;
     for (i=0;i<MAX_KEY_TABLE;i++) {
-        if ((pTable->KeyTable[i].bInUse == TRUE) &&
-            (pTable->KeyTable[i].PairwiseKey.bKeyValid == TRUE)) {
+        if ((pTable->KeyTable[i].bInUse == true) &&
+            (pTable->KeyTable[i].PairwiseKey.bKeyValid == true)) {
             *pKey = &(pTable->KeyTable[i].PairwiseKey);
-            return (TRUE);
+            return (true);
         }
     }
-    return (FALSE);
+    return (false);
 }
 
 /*
@@ -657,7 +657,7 @@ BOOL KeybCheckPairewiseKey(PSKeyManagement pTable, PSKeyItem *pKey)
  *  Out:
  *      none
  *
- * Return Value: TRUE if success otherwise FALSE
+ * Return Value: true if success otherwise false
  *
  */
 BOOL KeybSetDefaultKey(
@@ -679,12 +679,12 @@ BOOL KeybSetDefaultKey(
 	    (int) dwKeyIndex, (int) uKeyLength);
 
     if ((dwKeyIndex & PAIRWISE_KEY) != 0) {                  // Pairwise key
-        return (FALSE);
+        return (false);
     } else if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY) {
-        return (FALSE);
+        return (false);
     }
 
-    pTable->KeyTable[MAX_KEY_TABLE-1].bInUse = TRUE;
+    pTable->KeyTable[MAX_KEY_TABLE-1].bInUse = true;
     for (ii = 0; ii < ETH_ALEN; ii++)
         pTable->KeyTable[MAX_KEY_TABLE-1].abyBSSID[ii] = 0xFF;
 
@@ -705,13 +705,13 @@ BOOL KeybSetDefaultKey(
     if ((uKeyLength == WLAN_WEP232_KEYLEN) &&
         (byKeyDecMode == KEY_CTL_WEP)) {
         pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl |= 0x4000;              // disable on-fly disable address match
-        pTable->KeyTable[MAX_KEY_TABLE-1].bSoftWEP = TRUE;
+        pTable->KeyTable[MAX_KEY_TABLE-1].bSoftWEP = true;
     } else {
-        if (pTable->KeyTable[MAX_KEY_TABLE-1].bSoftWEP == FALSE)
+        if (pTable->KeyTable[MAX_KEY_TABLE-1].bSoftWEP == false)
             pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl |= 0xC000;          // enable on-fly disable address match
     }
 
-    pKey->bKeyValid = TRUE;
+    pKey->bKeyValid = true;
     pKey->uKeyLength = uKeyLength;
     pKey->dwKeyIndex = dwKeyIndex;
     pKey->byCipherSuite = byKeyDecMode;
@@ -748,7 +748,7 @@ BOOL KeybSetDefaultKey(
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n", pKey->wTSC15_0);
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %lx\n", pKey->dwKeyIndex);
 
-    return (TRUE);
+    return (true);
 }
 
 
@@ -765,7 +765,7 @@ BOOL KeybSetDefaultKey(
  *  Out:
  *      none
  *
- * Return Value: TRUE if success otherwise FALSE
+ * Return Value: true if success otherwise false
  *
  */
 BOOL KeybSetAllGroupKey(
@@ -788,13 +788,13 @@ BOOL KeybSetAllGroupKey(
 
 
     if ((dwKeyIndex & PAIRWISE_KEY) != 0) {                  // Pairwise key
-        return (FALSE);
+        return (false);
     } else if ((dwKeyIndex & 0x000000FF) >= MAX_GROUP_KEY) {
-        return (FALSE);
+        return (false);
     }
 
     for (i=0; i < MAX_KEY_TABLE-1; i++) {
-        if (pTable->KeyTable[i].bInUse == TRUE) {
+        if (pTable->KeyTable[i].bInUse == true) {
             // found table already exist
             // Group key
             pKey = &(pTable->KeyTable[i].GroupKey[dwKeyIndex & 0x000000FF]);
@@ -811,7 +811,7 @@ BOOL KeybSetAllGroupKey(
 
             pTable->KeyTable[i].wKeyCtl |= 0x8000;              // enable on-fly
 
-            pKey->bKeyValid = TRUE;
+            pKey->bKeyValid = true;
             pKey->uKeyLength = uKeyLength;
             pKey->dwKeyIndex = dwKeyIndex;
             pKey->byCipherSuite = byKeyDecMode;
@@ -848,7 +848,7 @@ BOOL KeybSetAllGroupKey(
             //DBG_PRN_GRP12(("pKey->wTSC15_0: %X\n ", pKey->wTSC15_0));
             //DBG_PRN_GRP12(("pKey->dwKeyIndex: %lX\n ", pKey->dwKeyIndex));
 
-        } // (pTable->KeyTable[i].bInUse == TRUE)
+        } // (pTable->KeyTable[i].bInUse == true)
     }
-    return (TRUE);
+    return (true);
 }
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 33698ed..92d9bfb 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -133,7 +133,7 @@ void MACvWriteMultiAddr(PSDevice pDevice, unsigned int uByteIdx, BYTE byData)
  *  Out:
  *      none
  *
- * Return Value: TRUE if success; otherwise FALSE
+ * Return Value: true if success; otherwise false
  *
  */
 BOOL MACbShutdown (PSDevice pDevice)
@@ -145,7 +145,7 @@ BOOL MACbShutdown (PSDevice pDevice)
                         0,
                         NULL
                         );
-    return TRUE;
+    return true;
 }
 
 void MACvSetBBType(PSDevice pDevice,BYTE byType)
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 37bb5a0..f412dbc 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -318,18 +318,18 @@ device_set_options(PSDevice pDevice) {
     pDevice->b11hEnable = X80211h_MODE_DEF;
     pDevice->eOPMode = OP_MODE_DEF;
     pDevice->uConnectionRate = DATA_RATE_DEF;
-    if (pDevice->uConnectionRate < RATE_AUTO) pDevice->bFixRate = TRUE;
+    if (pDevice->uConnectionRate < RATE_AUTO) pDevice->bFixRate = true;
     pDevice->byBBType = BBP_TYPE_DEF;
     pDevice->byPacketType = pDevice->byBBType;
     pDevice->byAutoFBCtrl = AUTO_FB_0;
-    pDevice->bUpdateBBVGA = TRUE;
+    pDevice->bUpdateBBVGA = true;
     pDevice->byFOETuning = 0;
     pDevice->byAutoPwrTunning = 0;
     pDevice->wCTSDuration = 0;
     pDevice->byPreambleType = 0;
-    pDevice->bExistSWNetAddr = FALSE;
-//    pDevice->bDiversityRegCtlON = TRUE;
-    pDevice->bDiversityRegCtlON = FALSE;
+    pDevice->bExistSWNetAddr = false;
+//    pDevice->bDiversityRegCtlON = true;
+    pDevice->bDiversityRegCtlON = false;
 }
 
 
@@ -384,24 +384,24 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 		       ETH_ALEN);
 
         if ( !FIRMWAREbCheckVersion(pDevice) ) {
-            if (FIRMWAREbDownload(pDevice) == TRUE) {
-                if (FIRMWAREbBrach2Sram(pDevice) == FALSE) {
+            if (FIRMWAREbDownload(pDevice) == true) {
+                if (FIRMWAREbBrach2Sram(pDevice) == false) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" FIRMWAREbBrach2Sram fail \n");
                   	spin_unlock_irq(&pDevice->lock);
-                    return FALSE;
+                    return false;
                 }
             } else {
 
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" FIRMWAREbDownload fail \n");
                 spin_unlock_irq(&pDevice->lock);
-                return FALSE;
+                return false;
             }
         }
 
         if ( !BBbVT3184Init(pDevice) ) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" BBbVT3184Init fail \n");
             spin_unlock_irq(&pDevice->lock);
-            return FALSE;
+            return false;
         }
     }
 
@@ -423,7 +423,7 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
     if ( ntStatus != STATUS_SUCCESS ) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Issue Card init fail \n");
         spin_unlock_irq(&pDevice->lock);
-        return FALSE;
+        return false;
     }
     if (InitType == DEVICE_INIT_COLD) {
 
@@ -432,7 +432,7 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
         if (ntStatus != STATUS_SUCCESS) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Cardinit request in status fail!\n");
             spin_unlock_irq(&pDevice->lock);
-            return FALSE;
+            return false;
         }
 
         //Local ID for AES functions
@@ -445,15 +445,15 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
         if ( ntStatus != STATUS_SUCCESS ) {
             spin_unlock_irq(&pDevice->lock);
-            return FALSE;
+            return false;
         }
 
         // Do MACbSoftwareReset in MACvInitialize
         // force CCK
-        pDevice->bCCK = TRUE;
-        pDevice->bProtectMode = FALSE;          //Only used in 11g type, sync with ERP IE
-        pDevice->bNonERPPresent = FALSE;
-        pDevice->bBarkerPreambleMd = FALSE;
+        pDevice->bCCK = true;
+        pDevice->bProtectMode = false;          //Only used in 11g type, sync with ERP IE
+        pDevice->bNonERPPresent = false;
+        pDevice->bBarkerPreambleMd = false;
         if ( pDevice->bFixRate ) {
             pDevice->wCurrentRate = (WORD) pDevice->uConnectionRate;
         } else {
@@ -505,9 +505,9 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
         byAntenna = pDevice->abyEEPROM[EEP_OFS_ANTENNA];
         if (byAntenna & EEP_ANTINV)
-            pDevice->bTxRxAntInv = TRUE;
+            pDevice->bTxRxAntInv = true;
         else
-            pDevice->bTxRxAntInv = FALSE;
+            pDevice->bTxRxAntInv = false;
 
         byAntenna &= (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
@@ -519,29 +519,29 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
             pDevice->byTxAntennaMode = ANT_B;
             pDevice->dwTxAntennaSel = 1;
             pDevice->dwRxAntennaSel = 1;
-            if (pDevice->bTxRxAntInv == TRUE)
+            if (pDevice->bTxRxAntInv == true)
                 pDevice->byRxAntennaMode = ANT_A;
             else
                 pDevice->byRxAntennaMode = ANT_B;
 
             if (pDevice->bDiversityRegCtlON)
-                pDevice->bDiversityEnable = TRUE;
+                pDevice->bDiversityEnable = true;
             else
-                pDevice->bDiversityEnable = FALSE;
+                pDevice->bDiversityEnable = false;
         } else  {
-            pDevice->bDiversityEnable = FALSE;
+            pDevice->bDiversityEnable = false;
             pDevice->byAntennaCount = 1;
             pDevice->dwTxAntennaSel = 0;
             pDevice->dwRxAntennaSel = 0;
             if (byAntenna & EEP_ANTENNA_AUX) {
                 pDevice->byTxAntennaMode = ANT_A;
-                if (pDevice->bTxRxAntInv == TRUE)
+                if (pDevice->bTxRxAntInv == true)
                     pDevice->byRxAntennaMode = ANT_B;
                 else
                     pDevice->byRxAntennaMode = ANT_A;
             } else {
                 pDevice->byTxAntennaMode = ANT_B;
-                if (pDevice->bTxRxAntInv == TRUE)
+                if (pDevice->bTxRxAntInv == true)
                     pDevice->byRxAntennaMode = ANT_A;
                 else
                     pDevice->byRxAntennaMode = ANT_B;
@@ -627,10 +627,10 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
     // Set Short Slot Time, xIFS, and RSPINF.
     if (pDevice->byBBType == BB_TYPE_11A) {
         CARDbAddBasicRate(pDevice, RATE_6M);
-        pDevice->bShortSlotTime = TRUE;
+        pDevice->bShortSlotTime = true;
     } else {
         CARDbAddBasicRate(pDevice, RATE_1M);
-        pDevice->bShortSlotTime = FALSE;
+        pDevice->bShortSlotTime = false;
     }
     BBvSetShortSlotTime(pDevice);
     CARDvSetBSSMode(pDevice);
@@ -642,7 +642,7 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
     }
 
     pDevice->byRadioCtl = pDevice->abyEEPROM[EEP_OFS_RADIOCTL];
-    pDevice->bHWRadioOff = FALSE;
+    pDevice->bHWRadioOff = false;
     if ( (pDevice->byRadioCtl & EEP_RADIOCTL_ENABLE) != 0 ) {
         ntStatus = CONTROLnsRequestIn(pDevice,
                                     MESSAGE_TYPE_READ,
@@ -653,14 +653,14 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
         if ( ntStatus != STATUS_SUCCESS ) {
             spin_unlock_irq(&pDevice->lock);
-            return FALSE;
+            return false;
         }
         if ( (byTmp & GPIO3_DATA) == 0 ) {
-            pDevice->bHWRadioOff = TRUE;
+            pDevice->bHWRadioOff = true;
             MACvRegBitsOn(pDevice,MAC_REG_GPIOCTL1,GPIO3_INTMD);
         } else {
             MACvRegBitsOff(pDevice,MAC_REG_GPIOCTL1,GPIO3_INTMD);
-            pDevice->bHWRadioOff = FALSE;
+            pDevice->bHWRadioOff = false;
         }
 
     } //EEP_RADIOCTL_ENABLE
@@ -669,7 +669,7 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
     ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
     MACvRegBitsOn(pDevice,MAC_REG_GPIOCTL0,0x01);
 
-    if ((pDevice->bHWRadioOff == TRUE) || (pDevice->bRadioControlOff == TRUE)) {
+    if ((pDevice->bHWRadioOff == true) || (pDevice->bRadioControlOff == true)) {
         CARDbRadioPowerOff(pDevice);
     } else {
         CARDbRadioPowerOn(pDevice);
@@ -677,7 +677,7 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
     spin_unlock_irq(&pDevice->lock);
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----INIbInitAdapter Exit\n");
-    return TRUE;
+    return true;
 }
 
 static BOOL device_release_WPADEV(PSDevice pDevice)
@@ -686,7 +686,7 @@ static BOOL device_release_WPADEV(PSDevice pDevice)
   int ii=0;
  // wait_queue_head_t	Set_wait;
   //send device close to wpa_supplicnat layer
-    if (pDevice->bWPADEVUp==TRUE) {
+    if (pDevice->bWPADEVUp==true) {
                  wpahdr = (viawget_wpa_header *)pDevice->skb->data;
                  wpahdr->type = VIAWGET_DEVICECLOSE_MSG;
                  wpahdr->resp_ie_len = 0;
@@ -703,7 +703,7 @@ static BOOL device_release_WPADEV(PSDevice pDevice)
  //wait release WPADEV
               //    init_waitqueue_head(&Set_wait);
               //    wait_event_timeout(Set_wait, ((pDevice->wpadev==NULL)&&(pDevice->skb == NULL)),5*HZ);    //1s wait
-              while(pDevice->bWPADEVUp==TRUE) {
+              while(pDevice->bWPADEVUp==true) {
 	        set_current_state(TASK_UNINTERRUPTIBLE);
                  schedule_timeout (HZ/20);          //wait 50ms
                  ii++;
@@ -711,7 +711,7 @@ static BOOL device_release_WPADEV(PSDevice pDevice)
 		  break;
               }
            };
-    return TRUE;
+    return true;
 }
 
 #ifdef CONFIG_PM	/* Minimal support for suspend and resume */
@@ -915,7 +915,7 @@ static BOOL device_alloc_bufs(PSDevice pDevice) {
             DBG_PRT(MSG_LEVEL_ERR,KERN_ERR "alloc tx urb failed\n");
             goto free_tx;
         }
-        pTxContext->bBoolInUse = FALSE;
+        pTxContext->bBoolInUse = false;
     }
 
     // allocate rcb mem
@@ -951,7 +951,7 @@ static BOOL device_alloc_bufs(PSDevice pDevice) {
             goto free_rx_tx;
         }
         pRCB->skb->dev = pDevice->dev;
-        pRCB->bBoolInUse = FALSE;
+        pRCB->bBoolInUse = false;
         EnqueueRCB(pDevice->FirstRecvFreeList, pDevice->LastRecvFreeList, pRCB);
         pDevice->NumRecvFreeList++;
         pRCB++;
@@ -982,7 +982,7 @@ static BOOL device_alloc_bufs(PSDevice pDevice) {
 	    goto free_rx_tx;
 	}
 
-    return TRUE;
+    return true;
 
 free_rx_tx:
     device_free_rx_bufs(pDevice);
@@ -990,7 +990,7 @@ free_rx_tx:
 free_tx:
     device_free_tx_bufs(pDevice);
 
-	return FALSE;
+	return false;
 }
 
 
@@ -1011,11 +1011,11 @@ static BOOL device_init_defrag_cb(PSDevice pDevice) {
     }
     pDevice->cbDFCB = CB_MAX_RX_FRAG;
     pDevice->cbFreeDFCB = pDevice->cbDFCB;
-    return TRUE;
+    return true;
 
 free_frag:
     device_free_frag_bufs(pDevice);
-    return FALSE;
+    return false;
 }
 
 
@@ -1039,11 +1039,11 @@ BOOL device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF) {
 
     pDeF->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
     if (pDeF->skb == NULL)
-        return FALSE;
+        return false;
     ASSERT(pDeF->skb);
     pDeF->skb->dev = pDevice->dev;
 
-    return TRUE;
+    return true;
 }
 
 
@@ -1058,8 +1058,8 @@ static int  device_open(struct net_device *dev) {
      wpa_Result.proto = 0;
      wpa_Result.key_mgmt = 0;
      wpa_Result.eap_type = 0;
-     wpa_Result.authenticated = FALSE;
-     pDevice->fWPA_Authened = FALSE;
+     wpa_Result.authenticated = false;
+     pDevice->fWPA_Authened = false;
 #endif
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " device_open...\n");
@@ -1067,12 +1067,12 @@ static int  device_open(struct net_device *dev) {
 
     pDevice->rx_buf_sz = MAX_TOTAL_SIZE_WITH_ALL_HEADERS;
 
-    if (device_alloc_bufs(pDevice) == FALSE) {
+    if (device_alloc_bufs(pDevice) == false) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " device_alloc_bufs fail... \n");
         return -ENOMEM;
     }
 
-    if (device_init_defrag_cb(pDevice)== FALSE) {
+    if (device_init_defrag_cb(pDevice)== false) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Initial defragement cb fail \n");
         goto free_rx_tx;
     }
@@ -1086,7 +1086,7 @@ static int  device_open(struct net_device *dev) {
    //read config file
     Read_config_file(pDevice);
 
-    if (device_init_registers(pDevice, DEVICE_INIT_COLD) == FALSE) {
+    if (device_init_registers(pDevice, DEVICE_INIT_COLD) == false) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " init register fail\n");
         goto free_all;
     }
@@ -1097,11 +1097,11 @@ static int  device_open(struct net_device *dev) {
     KeyvInitTable(pDevice,&pDevice->sKey);
     memcpy(pDevice->sMgmtObj.abyMACAddr, pDevice->abyCurrentNetAddr, ETH_ALEN);
     memcpy(pDevice->dev->dev_addr, pDevice->abyCurrentNetAddr, ETH_ALEN);
-    pDevice->bStopTx0Pkt = FALSE;
-    pDevice->bStopDataPkt = FALSE;
-    pDevice->bRoaming = FALSE;  //DavidWang
-    pDevice->bIsRoaming = FALSE;//DavidWang
-    pDevice->bEnableRoaming = FALSE;
+    pDevice->bStopTx0Pkt = false;
+    pDevice->bStopDataPkt = false;
+    pDevice->bRoaming = false;  //DavidWang
+    pDevice->bIsRoaming = false;//DavidWang
+    pDevice->bEnableRoaming = false;
     if (pDevice->bDiversityRegCtlON) {
         device_init_diversity_timer(pDevice);
     }
@@ -1114,17 +1114,17 @@ static int  device_open(struct net_device *dev) {
     pDevice->int_interval = 100;  //Max 100 microframes.
     pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
-    pDevice->bIsRxWorkItemQueued = TRUE;
-    pDevice->fKillEventPollingThread = FALSE;
-    pDevice->bEventAvailable = FALSE;
+    pDevice->bIsRxWorkItemQueued = true;
+    pDevice->fKillEventPollingThread = false;
+    pDevice->bEventAvailable = false;
 
-   pDevice->bWPADEVUp = FALSE;
+   pDevice->bWPADEVUp = false;
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-     pDevice->bwextstep0 = FALSE;
-     pDevice->bwextstep1 = FALSE;
-     pDevice->bwextstep2 = FALSE;
-     pDevice->bwextstep3 = FALSE;
-     pDevice->bWPASuppWextEnabled = FALSE;
+     pDevice->bwextstep0 = false;
+     pDevice->bwextstep1 = false;
+     pDevice->bwextstep2 = false;
+     pDevice->bwextstep3 = false;
+     pDevice->bWPASuppWextEnabled = false;
 #endif
     pDevice->byReAssocCount = 0;
 
@@ -1132,7 +1132,7 @@ static int  device_open(struct net_device *dev) {
     INTvWorkItem(pDevice);
 
     // Patch: if WEP key already set by iwconfig but device not yet open
-    if ((pDevice->bEncryptionEnable == TRUE) && (pDevice->bTransmitKey == TRUE)) {
+    if ((pDevice->bEncryptionEnable == true) && (pDevice->bTransmitKey == true)) {
          spin_lock_irq(&pDevice->lock);
          KeybSetDefaultKey( pDevice,
                             &(pDevice->sKey),
@@ -1214,22 +1214,22 @@ static int  device_close(struct net_device *dev) {
 device_release_WPADEV(pDevice);
 
         memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-        pMgmt->bShareKeyAlgorithm = FALSE;
-        pDevice->bEncryptionEnable = FALSE;
+        pMgmt->bShareKeyAlgorithm = false;
+        pDevice->bEncryptionEnable = false;
         pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 	spin_lock_irq(&pDevice->lock);
 	for (uu = 0; uu < MAX_KEY_TABLE; uu++)
                 MACvDisableKeyEntry(pDevice,uu);
 	spin_unlock_irq(&pDevice->lock);
 
-    if ((pDevice->flags & DEVICE_FLAGS_UNPLUG) == FALSE) {
+    if ((pDevice->flags & DEVICE_FLAGS_UNPLUG) == false) {
         MACbShutdown(pDevice);
     }
     netif_stop_queue(pDevice->dev);
     MP_SET_FLAG(pDevice, fMP_DISCONNECTED);
     MP_CLEAR_FLAG(pDevice, fMP_POST_WRITES);
     MP_CLEAR_FLAG(pDevice, fMP_POST_READS);
-    pDevice->fKillEventPollingThread = TRUE;
+    pDevice->fKillEventPollingThread = true;
     del_timer(&pDevice->sTimerCommand);
     del_timer(&pMgmt->sTimerSecondCallback);
 
@@ -1244,11 +1244,11 @@ device_release_WPADEV(pDevice);
     tasklet_kill(&pDevice->ReadWorkItem);
     tasklet_kill(&pDevice->EventWorkItem);
 
-   pDevice->bRoaming = FALSE;  //DavidWang
-   pDevice->bIsRoaming = FALSE;//DavidWang
-   pDevice->bEnableRoaming = FALSE;
-    pDevice->bCmdRunning = FALSE;
-    pDevice->bLinkPass = FALSE;
+   pDevice->bRoaming = false;  //DavidWang
+   pDevice->bIsRoaming = false;//DavidWang
+   pDevice->bEnableRoaming = false;
+    pDevice->bCmdRunning = false;
+    pDevice->bLinkPass = false;
     memset(pMgmt->abyCurrBSSID, 0, 6);
     pMgmt->eCurrState = WMAC_STATE_IDLE;
 
@@ -1307,7 +1307,7 @@ static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev) {
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_dma0_tx_80211\n");
     spin_lock_irq(&pDevice->lock);
 
-    if (pDevice->bStopTx0Pkt == TRUE) {
+    if (pDevice->bStopTx0Pkt == true) {
         dev_kfree_skb_irq(skb);
         spin_unlock_irq(&pDevice->lock);
         return 0;
@@ -1335,12 +1335,12 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
 
     netif_stop_queue(pDevice->dev);
 
-    if (pDevice->bLinkPass == FALSE) {
+    if (pDevice->bLinkPass == false) {
         dev_kfree_skb_irq(skb);
         spin_unlock_irq(&pDevice->lock);
         return 0;
     }
-    if (pDevice->bStopDataPkt == TRUE) {
+    if (pDevice->bStopDataPkt == true) {
         dev_kfree_skb_irq(skb);
         pStats->tx_dropped++;
         spin_unlock_irq(&pDevice->lock);
@@ -1407,14 +1407,14 @@ static int Config_FileGetParameter(unsigned char *string,
 //find target string start point
     start_p = kstrstr(source,buf1);
     if (start_p == NULL)
-	return FALSE;
+	return false;
 
 //check if current config line is marked by "#" ??
     for (ii = 1; ; ii++) {
 	if (memcmp(start_p - ii, "\n", 1) == 0)
 		break;
 	if (memcmp(start_p - ii, "#", 1) == 0)
-		return FALSE;
+		return false;
     }
 
 //find target string end point
@@ -1430,7 +1430,7 @@ static int Config_FileGetParameter(unsigned char *string,
    //find value
    start_p = kstrstr(buf2,"=");
    if (start_p == NULL)
-      return FALSE;
+      return false;
    memset(buf1,0,100);
    strcpy(buf1,start_p+1);
 
@@ -1444,7 +1444,7 @@ static int Config_FileGetParameter(unsigned char *string,
   }
 
    memcpy(dest,tmp_p,strlen(tmp_p));
- return TRUE;
+ return true;
 }
 
 //if read fail,return NULL,or return data pointer;
@@ -1532,7 +1532,7 @@ static int Read_config_file(PSDevice pDevice) {
 //get zonetype
 {
     memset(tmpbuffer,0,sizeof(tmpbuffer));
-    if(Config_FileGetParameter("ZONETYPE",tmpbuffer,buffer) ==TRUE) {
+    if(Config_FileGetParameter("ZONETYPE",tmpbuffer,buffer) ==true) {
     if(memcmp(tmpbuffer,"USA",3)==0) {
       pDevice->config_file.ZoneType=ZoneType_USA;
     }
@@ -1552,12 +1552,12 @@ static int Read_config_file(PSDevice pDevice) {
 //get other parameter
   {
 	memset(tmpbuffer,0,sizeof(tmpbuffer));
-       if(Config_FileGetParameter("AUTHENMODE",tmpbuffer,buffer)==TRUE) {
+       if(Config_FileGetParameter("AUTHENMODE",tmpbuffer,buffer)==true) {
 	 pDevice->config_file.eAuthenMode = (int) simple_strtol(tmpbuffer, NULL, 10);
        }
 
 	memset(tmpbuffer,0,sizeof(tmpbuffer));
-       if(Config_FileGetParameter("ENCRYPTIONMODE",tmpbuffer,buffer)==TRUE) {
+       if(Config_FileGetParameter("ENCRYPTIONMODE",tmpbuffer,buffer)==true) {
 	 pDevice->config_file.eEncryptionStatus= (int) simple_strtol(tmpbuffer, NULL, 10);
        }
   }
@@ -1643,7 +1643,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
     PSCmdRequest        pReq;
-    //BOOL                bCommit = FALSE;
+    //BOOL                bCommit = false;
 	struct iwreq *wrq = (struct iwreq *) rq;
 	int                 rc =0;
 
@@ -2007,7 +2007,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
         pReq = (PSCmdRequest)rq;
 
    //20080130-01,<Remark> by Mike Liu
-      // if(pDevice->bLinkPass==TRUE)
+      // if(pDevice->bLinkPass==true)
           pReq->wResult = MAGIC_CODE;         //Linking status:0x3142
    //20080130-02,<Remark> by Mike Liu
       //  else
@@ -2081,7 +2081,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		  memcmp(pMgmt->abyCurrSSID,pMgmt->abyDesireSSID,WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN)) {
 		bScheduleCommand((void *) pDevice, WLAN_CMD_DISASSOCIATE, NULL);
 	     } else {
-           pDevice->bLinkPass = FALSE;
+           pDevice->bLinkPass = false;
 	   pMgmt->eCurrState = WMAC_STATE_IDLE;
 	   memset(pMgmt->abyCurrBSSID, 0, 6);
 		 }
@@ -2100,7 +2100,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 				 NULL);
            spin_unlock_irq(&pDevice->lock);
       }
-      pDevice->bCommit = FALSE;
+      pDevice->bCommit = false;
     }
 
 
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 4d7d4e0..cf367b9 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -116,7 +116,7 @@ void PSvEnablePowerSaving(void *hDeviceContext,
 
     }
 
-    pDevice->bEnablePSMode = TRUE;
+    pDevice->bEnablePSMode = true;
 
     if (pDevice->eOPMode == OP_MODE_ADHOC) {
 	/* bMgrPrepareBeaconToSend((void *) pDevice, pMgmt); */
@@ -125,7 +125,7 @@ void PSvEnablePowerSaving(void *hDeviceContext,
     else if (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) {
         PSbSendNullPacket(pDevice);
     }
-    pDevice->bPWBitOn = TRUE;
+    pDevice->bPWBitOn = true;
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS:Power Saving Mode Enable... \n");
     return;
 }
@@ -161,12 +161,12 @@ void PSvDisablePowerSaving(void *hDeviceContext)
     // set always listen beacon
     MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
 
-    pDevice->bEnablePSMode = FALSE;
+    pDevice->bEnablePSMode = false;
 
     if (pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) {
         PSbSendNullPacket(pDevice);
     }
-    pDevice->bPWBitOn = FALSE;
+    pDevice->bPWBitOn = false;
     return;
 }
 
@@ -176,8 +176,8 @@ void PSvDisablePowerSaving(void *hDeviceContext)
  * Consider to power down when no more packets to tx or rx.
  *
  * Return Value:
- *    TRUE, if power down success
- *    FALSE, if fail
+ *    true, if power down success
+ *    false, if fail
 -*/
 
 BOOL PSbConsiderPowerDown(void *hDeviceContext,
@@ -192,21 +192,21 @@ BOOL PSbConsiderPowerDown(void *hDeviceContext,
     // check if already in Doze mode
     ControlvReadByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PSCTL, &byData);
     if ( (byData & PSCTL_PS) != 0 )
-        return TRUE;;
+        return true;;
 
     if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
         // check if in TIM wake period
         if (pMgmt->bInTIMWake)
-            return FALSE;
+            return false;
     }
 
     // check scan state
     if (pDevice->bCmdRunning)
-        return FALSE;
+        return false;
 
     //Tx Burst
     if ( pDevice->bPSModeTxBurst )
-        return FALSE;
+        return false;
 
     // Froce PSEN on
     MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_PSEN);
@@ -214,16 +214,16 @@ BOOL PSbConsiderPowerDown(void *hDeviceContext,
     if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
         if (bCheckCountToWakeUp &&
             (pMgmt->wCountToWakeUp == 0 || pMgmt->wCountToWakeUp == 1)) {
-             return FALSE;
+             return false;
         }
     }
 
-    pDevice->bPSRxBeacon = TRUE;
+    pDevice->bPSRxBeacon = true;
     // no Tx, no Rx isr, now go to Doze
     MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_GO2DOZE);
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Go to Doze ZZZZZZZZZZZZZZZ\n");
-    return TRUE;
+    return true;
 }
 
 /*+
@@ -286,13 +286,13 @@ BOOL PSbSendNullPacket(void *hDeviceContext)
 
 
 
-    if (pDevice->bLinkPass == FALSE) {
-        return FALSE;
+    if (pDevice->bLinkPass == false) {
+        return false;
     }
 
-     if ((pDevice->bEnablePSMode == FALSE) &&
-	  (pDevice->fTxDataInSleep == FALSE)){
-        return FALSE;
+     if ((pDevice->bEnablePSMode == false) &&
+	  (pDevice->fTxDataInSleep == false)){
+        return false;
     }
 
     memset(pMgmt->pbyPSPacketPool, 0, sizeof(STxMgmtPacket) + WLAN_NULLDATA_FR_MAXLEN);
@@ -329,14 +329,14 @@ BOOL PSbSendNullPacket(void *hDeviceContext)
     // send the frame
     if (csMgmt_xmit(pDevice, pTxPacket) != CMD_STATUS_PENDING) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send Null Packet failed !\n");
-        return FALSE;
+        return false;
     }
     else {
 //            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Send Null Packet success....\n");
     }
 
 
-    return TRUE ;
+    return true ;
 }
 
 /*+
@@ -354,7 +354,7 @@ BOOL PSbIsNextTBTTWakeUp(void *hDeviceContext)
 
     PSDevice         pDevice = (PSDevice)hDeviceContext;
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    BOOL                bWakeUp = FALSE;
+    BOOL                bWakeUp = false;
 
     if (pMgmt->wListenInterval >= 2) {
         if (pMgmt->wCountToWakeUp == 0) {
@@ -367,8 +367,8 @@ BOOL PSbIsNextTBTTWakeUp(void *hDeviceContext)
 
             // Turn on wake up to listen next beacon
             MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
-            pDevice->bPSRxBeacon = FALSE;
-            bWakeUp = TRUE;
+            pDevice->bPSRxBeacon = false;
+            bWakeUp = true;
 
         } else if ( !pDevice->bPSRxBeacon ) {
             //Listen until RxBeacon
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 3fd0478..7cc600b 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -719,7 +719,7 @@ const BYTE RFaby11aChannelIndex[200] = {
  *  Out:
  *      none
  *
- * Return Value: TRUE if succeeded; FALSE if failed.
+ * Return Value: true if succeeded; false if failed.
  *
  */
 BOOL IFRFbWriteEmbeded (PSDevice pDevice, DWORD dwData)
@@ -739,7 +739,7 @@ BOOL IFRFbWriteEmbeded (PSDevice pDevice, DWORD dwData)
                         );
 
 
-    return TRUE;
+    return true;
 }
 
 
@@ -753,7 +753,7 @@ BOOL IFRFbWriteEmbeded (PSDevice pDevice, DWORD dwData)
  *  Out:
  *      none
  *
- * Return Value: TRUE if succeeded; FALSE if failed.
+ * Return Value: true if succeeded; false if failed.
  *
  */
 BOOL RFbSetPower (
@@ -762,11 +762,11 @@ BOOL RFbSetPower (
       unsigned int      uCH
     )
 {
-BOOL    bResult = TRUE;
+BOOL    bResult = true;
 BYTE    byPwr = pDevice->byCCKPwr;
 
     if (pDevice->dwDiagRefCount != 0) {
-        return TRUE;
+        return true;
     }
 
     switch (uRATE) {
@@ -807,7 +807,7 @@ BYTE    byPwr = pDevice->byCCKPwr;
  *  Out:
  *      none
  *
- * Return Value: TRUE if succeeded; FALSE if failed.
+ * Return Value: true if succeeded; false if failed.
  *
  */
 BOOL RFbRawSetPower (
@@ -816,10 +816,10 @@ BOOL RFbRawSetPower (
       unsigned int      uRATE
     )
 {
-BOOL        bResult = TRUE;
+BOOL        bResult = true;
 
     if (pDevice->byCurPwr == byPwr)
-        return TRUE;
+        return true;
 
     pDevice->byCurPwr = byPwr;
 
@@ -827,7 +827,7 @@ BOOL        bResult = TRUE;
 
         case RF_AL2230 :
             if (pDevice->byCurPwr >= AL2230_PWR_IDX_LEN)
-                return FALSE;
+                return false;
             bResult &= IFRFbWriteEmbeded(pDevice, dwAL2230PowerTable[pDevice->byCurPwr]);
             if (uRATE <= RATE_11M)
                 bResult &= IFRFbWriteEmbeded(pDevice, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
@@ -837,7 +837,7 @@ BOOL        bResult = TRUE;
 
         case RF_AL2230S :
             if (pDevice->byCurPwr >= AL2230_PWR_IDX_LEN)
-                return FALSE;
+                return false;
             bResult &= IFRFbWriteEmbeded(pDevice, dwAL2230PowerTable[pDevice->byCurPwr]);
             if (uRATE <= RATE_11M) {
                 bResult &= IFRFbWriteEmbeded(pDevice, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
@@ -860,7 +860,7 @@ BOOL        bResult = TRUE;
                     bResult &= IFRFbWriteEmbeded(pDevice, 0x221BB900+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW);
                 }
 
-                if (pDevice->byCurPwr > AL7230_PWR_IDX_LEN) return FALSE;
+                if (pDevice->byCurPwr > AL7230_PWR_IDX_LEN) return false;
 
                 //  0x080F1B00 for 3 wire control TxGain(D10) and 0x31 as TX Gain value
                 dwMax7230Pwr = 0x080C0B00 | ( (pDevice->byCurPwr) << 12 ) |
@@ -876,7 +876,7 @@ BOOL        bResult = TRUE;
             DWORD       dwVT3226Pwr;
 
             if (pDevice->byCurPwr >= VT3226_PWR_IDX_LEN)
-                return FALSE;
+                return false;
             dwVT3226Pwr = ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0x17 << 8 ) /* Reg7 */ |
                            (BY_VT3226_REG_LEN << 3 )  | IFREGCTL_REGW;
             bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226Pwr);
@@ -888,7 +888,7 @@ BOOL        bResult = TRUE;
             DWORD       dwVT3226Pwr;
 
             if (pDevice->byCurPwr >= VT3226_PWR_IDX_LEN)
-                return FALSE;
+                return false;
 
             if (uRATE <= RATE_11M) {
 
@@ -925,7 +925,7 @@ BOOL        bResult = TRUE;
             DWORD       dwVT3342Pwr;
 
             if (pDevice->byCurPwr >= VT3342_PWR_IDX_LEN)
-                return FALSE;
+                return false;
 
             dwVT3342Pwr =  ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0x27 << 8 ) /* Reg7 */ |
                             (BY_VT3342_REG_LEN << 3 )  | IFREGCTL_REGW;
@@ -1139,7 +1139,7 @@ BOOL s_bVT3226D0_11bLoCurrentAdjust(
 {
     BOOL    bResult;
 
-    bResult = TRUE;
+    bResult = true;
     if( b11bMode )
         bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226D0LoCurrentTable[byChannel-1]);
     else
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 24437a0..963206b 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -285,8 +285,8 @@ s_vGetFreeContext(
 
     for (ii = 0; ii < pDevice->cbTD; ii++) {
         pContext = pDevice->apTD[ii];
-        if (pContext->bBoolInUse == FALSE) {
-            pContext->bBoolInUse = TRUE;
+        if (pContext->bBoolInUse == false) {
+            pContext->bBoolInUse = true;
             pReturnContext = pContext;
             break;
         }
@@ -717,7 +717,7 @@ s_uGetDataDuration (
         break;
     }
 
-	ASSERT(FALSE);
+	ASSERT(false);
 	return 0;
 }
 
@@ -1313,7 +1313,7 @@ s_vGenerateTxParameter (
 {
 	unsigned int cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
     WORD wFifoCtl;
-    BOOL bDisCRC = FALSE;
+    BOOL bDisCRC = false;
     BYTE byFBOption = AUTO_FB_NONE;
 //    WORD wCurrentRate = pDevice->wCurrentRate;
 
@@ -1323,7 +1323,7 @@ s_vGenerateTxParameter (
     wFifoCtl = pFifoHead->wFIFOCtl;
 
     if (wFifoCtl & FIFOCTL_CRCDIS) {
-        bDisCRC = TRUE;
+        bDisCRC = true;
     }
 
     if (wFifoCtl & FIFOCTL_AUTO_FB_0) {
@@ -1452,16 +1452,16 @@ s_bPacketToWirelessUsb(
     WORD                wTxBufSize;
     DWORD               dwMICKey0,dwMICKey1,dwMIC_Priority,dwCRC;
     PDWORD              pdwMIC_L,pdwMIC_R;
-    BOOL                bSoftWEP = FALSE;
+    BOOL                bSoftWEP = false;
 
 
 
 
     pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
     if ((bNeedEncryption) && (pTransmitKey != NULL))  {
-        if (((PSKeyTable) (pTransmitKey->pvKeyTable))->bSoftWEP == TRUE) {
+        if (((PSKeyTable) (pTransmitKey->pvKeyTable))->bSoftWEP == true) {
             // WEP 256
-            bSoftWEP = TRUE;
+            bSoftWEP = true;
         }
     }
 
@@ -1485,24 +1485,24 @@ s_bPacketToWirelessUsb(
     pTxBufHead->wFIFOCtl |= (WORD)(byPktType<<8);
 
     if (pDevice->dwDiagRefCount != 0) {
-        bNeedACK = FALSE;
+        bNeedACK = false;
         pTxBufHead->wFIFOCtl = pTxBufHead->wFIFOCtl & (~FIFOCTL_NEEDACK);
     } else { //if (pDevice->dwDiagRefCount != 0) {
         if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
             (pDevice->eOPMode == OP_MODE_AP)) {
 	    if (is_multicast_ether_addr(&(psEthHeader->abyDstAddr[0])) ||
 		is_broadcast_ether_addr(&(psEthHeader->abyDstAddr[0]))) {
-                bNeedACK = FALSE;
+                bNeedACK = false;
                 pTxBufHead->wFIFOCtl = pTxBufHead->wFIFOCtl & (~FIFOCTL_NEEDACK);
             }
             else {
-                bNeedACK = TRUE;
+                bNeedACK = true;
                 pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
             }
         }
         else {
             // MSDUs in Infra mode always need ACK
-            bNeedACK = TRUE;
+            bNeedACK = true;
             pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
         }
     } //if (pDevice->dwDiagRefCount != 0) {
@@ -1526,7 +1526,7 @@ s_bPacketToWirelessUsb(
     pTxBufHead->wFragCtl |= (WORD)(cbMACHdLen << 10);
 
     //Set FIFOCTL_GrpAckPolicy
-    if (pDevice->bGrpAckPolicy == TRUE) {//0000 0100 0000 0000
+    if (pDevice->bGrpAckPolicy == true) {//0000 0100 0000 0000
         pTxBufHead->wFIFOCtl |=	FIFOCTL_GRPACK;
     }
 
@@ -1541,7 +1541,7 @@ s_bPacketToWirelessUsb(
         }
     }
 
-    if (bSoftWEP != TRUE) {
+    if (bSoftWEP != true) {
         if ((bNeedEncryption) && (pTransmitKey != NULL))  { //WEP enabled
             if (pTransmitKey->byCipherSuite == KEY_CTL_WEP) { //WEP40 or WEP104
                 pTxBufHead->wFragCtl |= FRAGCTL_LEGACY;
@@ -1572,7 +1572,7 @@ s_bPacketToWirelessUsb(
             cbICVlen = 8;//MIC
             cbMICHDR = sizeof(SMICHDRHead);
         }
-        if (bSoftWEP == FALSE) {
+        if (bSoftWEP == false) {
             //MAC Header should be padding 0 to DW alignment.
             uPadding = 4 - (cbMACHdLen%4);
             uPadding %= 4;
@@ -1581,10 +1581,10 @@ s_bPacketToWirelessUsb(
 
     cbFrameSize = cbMACHdLen + cbIVlen + (cbFrameBodySize + cbMIClen) + cbICVlen + cbFCSlen;
 
-    if ( (bNeedACK == FALSE) ||(cbFrameSize < pDevice->wRTSThreshold) ) {
-        bRTS = FALSE;
+    if ( (bNeedACK == false) ||(cbFrameSize < pDevice->wRTSThreshold) ) {
+        bRTS = false;
     } else {
-        bRTS = TRUE;
+        bRTS = true;
         pTxBufHead->wFIFOCtl |= (FIFOCTL_RTS | FIFOCTL_LRETRY);
     }
 
@@ -1592,7 +1592,7 @@ s_bPacketToWirelessUsb(
     wTxBufSize = sizeof(STxBufHead);
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
         if (byFBOption == AUTO_FB_NONE) {
-            if (bRTS == TRUE) {//RTS_need
+            if (bRTS == true) {//RTS_need
                 pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
                 pvRTS = (PSRTS_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR);
@@ -1610,7 +1610,7 @@ s_bPacketToWirelessUsb(
             }
         } else {
             // Auto Fall Back
-            if (bRTS == TRUE) {//RTS_need
+            if (bRTS == true) {//RTS_need
                 pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
                 pvRTS = (PSRTS_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR);
@@ -1618,7 +1618,7 @@ s_bPacketToWirelessUsb(
                 pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g_FB));
                 cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g_FB) + sizeof(STxDataHead_g_FB);
             }
-            else if (bRTS == FALSE) { //RTS_needless
+            else if (bRTS == false) { //RTS_needless
                 pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
                 pvRTS = NULL;
@@ -1630,7 +1630,7 @@ s_bPacketToWirelessUsb(
     }
     else {//802.11a/b packet
         if (byFBOption == AUTO_FB_NONE) {
-            if (bRTS == TRUE) {//RTS_need
+            if (bRTS == true) {//RTS_need
                 pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
                 pvRTS = (PSRTS_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
@@ -1638,7 +1638,7 @@ s_bPacketToWirelessUsb(
                 pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(SRTS_ab));
                 cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_ab) + sizeof(STxDataHead_ab);
             }
-            else if (bRTS == FALSE) { //RTS_needless, no MICHDR
+            else if (bRTS == false) { //RTS_needless, no MICHDR
                 pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
                 pvRTS = NULL;
@@ -1648,7 +1648,7 @@ s_bPacketToWirelessUsb(
             }
         } else {
             // Auto Fall Back
-            if (bRTS == TRUE) {//RTS_need
+            if (bRTS == true) {//RTS_need
                 pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
                 pvRTS = (PSRTS_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
@@ -1656,7 +1656,7 @@ s_bPacketToWirelessUsb(
                 pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(SRTS_a_FB));
                 cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_a_FB) + sizeof(STxDataHead_a_FB);
             }
-            else if (bRTS == FALSE) { //RTS_needless
+            else if (bRTS == false) { //RTS_needless
                 pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
                 pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
                 pvRTS = NULL;
@@ -1692,7 +1692,7 @@ s_bPacketToWirelessUsb(
     s_vGenerateMACHeader(pDevice, pbyMacHdr, (WORD)uDuration, psEthHeader, bNeedEncryption,
                            byFragType, uDMAIdx, 0);
 
-    if (bNeedEncryption == TRUE) {
+    if (bNeedEncryption == true) {
         //Fill TXKEY
         s_vFillTxKey(pDevice, (PBYTE)(pTxBufHead->adwTxKey), pbyIVHead, pTransmitKey,
                          pbyMacHdr, (WORD)cbFrameBodySize, (PBYTE)pMICHDR);
@@ -1736,7 +1736,7 @@ s_bPacketToWirelessUsb(
 
     ASSERT(uLength == cbNdisBodySize);
 
-    if ((bNeedEncryption == TRUE) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
+    if ((bNeedEncryption == true) && (pTransmitKey != NULL) && (pTransmitKey->byCipherSuite == KEY_CTL_TKIP)) {
 
         ///////////////////////////////////////////////////////////////////
 
@@ -1775,10 +1775,10 @@ s_bPacketToWirelessUsb(
         MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
         MIC_vUnInit();
 
-        if (pDevice->bTxMICFail == TRUE) {
+        if (pDevice->bTxMICFail == true) {
             *pdwMIC_L = 0;
             *pdwMIC_R = 0;
-            pDevice->bTxMICFail = FALSE;
+            pDevice->bTxMICFail = false;
         }
         //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"uLength: %d, %d\n", uLength, cbFrameBodySize);
         //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"cbReqCount:%d, %d, %d, %d\n", cbReqCount, cbHeaderLength, uPadding, cbIVlen);
@@ -1786,17 +1786,17 @@ s_bPacketToWirelessUsb(
     }
 
 
-    if (bSoftWEP == TRUE) {
+    if (bSoftWEP == true) {
 
         s_vSWencryption(pDevice, pTransmitKey, (pbyPayloadHead), (WORD)(cbFrameBodySize + cbMIClen));
 
-    } else if (  ((pDevice->eEncryptionStatus == Ndis802_11Encryption1Enabled) && (bNeedEncryption == TRUE))  ||
-          ((pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) && (bNeedEncryption == TRUE))   ||
-          ((pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) && (bNeedEncryption == TRUE))      ) {
+    } else if (  ((pDevice->eEncryptionStatus == Ndis802_11Encryption1Enabled) && (bNeedEncryption == true))  ||
+          ((pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) && (bNeedEncryption == true))   ||
+          ((pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) && (bNeedEncryption == true))      ) {
         cbFrameSize -= cbICVlen;
     }
 
-    if (pDevice->bSoftwareGenCrcErr == TRUE) {
+    if (pDevice->bSoftwareGenCrcErr == true) {
 	unsigned int cbLen;
         PDWORD pdwCRC;
 
@@ -1821,7 +1821,7 @@ s_bPacketToWirelessUsb(
     pTxBufHead->wFragCtl |= (WORD)byFragType;
 
 
-    return TRUE;
+    return true;
 
 }
 
@@ -1942,7 +1942,7 @@ s_vGenerateMACHeader (
  *  Out:
  *      none
  *
- * Return Value: CMD_STATUS_PENDING if MAC Tx resource avaliable; otherwise FALSE
+ * Return Value: CMD_STATUS_PENDING if MAC Tx resource avaliable; otherwise false
  *
 -*/
 
@@ -1962,7 +1962,7 @@ CMD_STATUS csMgmt_xmit(
     unsigned int            cbHeaderSize;
     unsigned int            cbFrameBodySize;
     BOOL            bNeedACK;
-    BOOL            bIsPSPOLL = FALSE;
+    BOOL            bIsPSPOLL = false;
     PSTxBufHead     pTxBufHead;
     unsigned int            cbFrameSize;
     unsigned int            cbIVlen = 0;
@@ -2036,10 +2036,10 @@ CMD_STATUS csMgmt_xmit(
 
     if (is_multicast_ether_addr(&(pPacket->p80211Header->sA3.abyAddr1[0])) ||
 	is_broadcast_ether_addr(&(pPacket->p80211Header->sA3.abyAddr1[0]))) {
-        bNeedACK = FALSE;
+        bNeedACK = false;
     }
     else {
-        bNeedACK = TRUE;
+        bNeedACK = true;
         pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
     };
 
@@ -2051,7 +2051,7 @@ CMD_STATUS csMgmt_xmit(
         //pDevice->byPreambleType = PREAMBLE_LONG;
         // probe-response don't retry
         //if ((pPacket->p80211Header->sA4.wFrameCtl & TYPE_SUBTYPE_MASK) == TYPE_MGMT_PROBE_RSP) {
-        //     bNeedACK = FALSE;
+        //     bNeedACK = false;
         //     pTxBufHead->wFIFOCtl  &= (~FIFOCTL_NEEDACK);
         //}
     }
@@ -2059,7 +2059,7 @@ CMD_STATUS csMgmt_xmit(
     pTxBufHead->wFIFOCtl |= (FIFOCTL_GENINT | FIFOCTL_ISDMA0);
 
     if ((pPacket->p80211Header->sA4.wFrameCtl & TYPE_SUBTYPE_MASK) == TYPE_CTL_PSPOLL) {
-        bIsPSPOLL = TRUE;
+        bIsPSPOLL = true;
         cbMacHdLen = WLAN_HDR_ADDR2_LEN;
     } else {
         cbMacHdLen = WLAN_HDR_ADDR3_LEN;
@@ -2071,7 +2071,7 @@ CMD_STATUS csMgmt_xmit(
     // Notes:
     // Although spec says MMPDU can be fragmented; In most case,
     // no one will send a MMPDU under fragmentation. With RTS may occur.
-    pDevice->bAES = FALSE;  //Set FRAGCTL_WEPTYP
+    pDevice->bAES = false;  //Set FRAGCTL_WEPTYP
 
     if (WLAN_GET_FC_ISWEP(pPacket->p80211Header->sA4.wFrameCtl) != 0) {
         if (pDevice->eEncryptionStatus == Ndis802_11Encryption1Enabled) {
@@ -2092,7 +2092,7 @@ CMD_STATUS csMgmt_xmit(
             cbIVlen = 8;//RSN Header
             cbICVlen = 8;//MIC
             pTxBufHead->wFragCtl |= FRAGCTL_AES;
-            pDevice->bAES = TRUE;
+            pDevice->bAES = true;
         }
         //MAC Header should be padding 0 to DW alignment.
         uPadding = 4 - (cbMacHdLen%4);
@@ -2102,7 +2102,7 @@ CMD_STATUS csMgmt_xmit(
     cbFrameSize = cbMacHdLen + cbFrameBodySize + cbIVlen + cbMIClen + cbICVlen + cbFCSlen;
 
     //Set FIFOCTL_GrpAckPolicy
-    if (pDevice->bGrpAckPolicy == TRUE) {//0000 0100 0000 0000
+    if (pDevice->bGrpAckPolicy == true) {//0000 0100 0000 0000
         pTxBufHead->wFIFOCtl |=	FIFOCTL_GRPACK;
     }
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
@@ -2163,12 +2163,12 @@ CMD_STATUS csMgmt_xmit(
         pbyPayloadHead = (PBYTE)(pbyTxBufferAddr + cbHeaderSize + cbMacHdLen + uPadding + cbIVlen);
         do {
             if ((pDevice->eOPMode == OP_MODE_INFRASTRUCTURE) &&
-                (pDevice->bLinkPass == TRUE)) {
+                (pDevice->bLinkPass == true)) {
                 pbyBSSID = pDevice->abyBSSID;
                 // get pairwise key
-                if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWISE_KEY, &pTransmitKey) == FALSE) {
+                if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWISE_KEY, &pTransmitKey) == false) {
                     // get group key
-                    if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == TRUE) {
+                    if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == true) {
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Get GTK.\n");
                         break;
                     }
@@ -2179,13 +2179,13 @@ CMD_STATUS csMgmt_xmit(
             }
             // get group key
             pbyBSSID = pDevice->abyBroadcastAddr;
-            if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == FALSE) {
+            if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
                 pTransmitKey = NULL;
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KEY is NULL. OP Mode[%d]\n", pDevice->eOPMode);
             } else {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Get GTK.\n");
             }
-        } while(FALSE);
+        } while(false);
         //Fill TXKEY
         s_vFillTxKey(pDevice, (PBYTE)(pTxBufHead->adwTxKey), pbyIVHead, pTransmitKey,
                      (PBYTE)pMACHeader, (WORD)cbFrameBodySize, NULL);
@@ -2285,7 +2285,7 @@ csBeacon_xmit(
         );
         //Get Duration and TimeStampOff
         pTxDataHead->wDuration = cpu_to_le16((WORD)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameSize, PK_TYPE_11A,
-                                                          wCurrentRate, FALSE, 0, 0, 1, AUTO_FB_NONE));
+                                                          wCurrentRate, false, 0, 0, 1, AUTO_FB_NONE));
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
         cbHeaderSize = wTxBufSize + sizeof(STxDataHead_ab);
     } else {
@@ -2298,7 +2298,7 @@ csBeacon_xmit(
         );
         //Get Duration and TimeStampOff
         pTxDataHead->wDuration = cpu_to_le16((WORD)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameSize, PK_TYPE_11B,
-                                                          wCurrentRate, FALSE, 0, 0, 1, AUTO_FB_NONE));
+                                                          wCurrentRate, false, 0, 0, 1, AUTO_FB_NONE));
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
         cbHeaderSize = wTxBufSize + sizeof(STxDataHead_ab);
     }
@@ -2347,7 +2347,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
     unsigned int            cbHeaderSize;
     unsigned int            cbFrameBodySize;
     BOOL            bNeedACK;
-    BOOL            bIsPSPOLL = FALSE;
+    BOOL            bIsPSPOLL = false;
     PSTxBufHead     pTxBufHead;
     unsigned int            cbFrameSize;
     unsigned int            cbIVlen = 0;
@@ -2369,7 +2369,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
     WORD            wCurrentRate = RATE_1M;
     PUWLAN_80211HDR  p80211Header;
     unsigned int             uNodeIndex = 0;
-    BOOL            bNodeExist = FALSE;
+    BOOL            bNodeExist = false;
     SKeyItem        STempKey;
     PSKeyItem       pTransmitKey = NULL;
     PBYTE           pbyIVHead;
@@ -2445,18 +2445,18 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
 
     if (is_multicast_ether_addr(&(p80211Header->sA3.abyAddr1[0])) ||
 	is_broadcast_ether_addr(&(p80211Header->sA3.abyAddr1[0]))) {
-        bNeedACK = FALSE;
+        bNeedACK = false;
         if (pDevice->bEnableHostWEP) {
             uNodeIndex = 0;
-            bNodeExist = TRUE;
+            bNodeExist = true;
         };
     }
     else {
         if (pDevice->bEnableHostWEP) {
             if (BSSbIsSTAInNodeDB(pDevice, (PBYTE)(p80211Header->sA3.abyAddr1), &uNodeIndex))
-                bNodeExist = TRUE;
+                bNodeExist = true;
         };
-        bNeedACK = TRUE;
+        bNeedACK = true;
         pTxBufHead->wFIFOCtl |= FIFOCTL_NEEDACK;
     };
 
@@ -2469,7 +2469,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
 
         // probe-response don't retry
         //if ((p80211Header->sA4.wFrameCtl & TYPE_SUBTYPE_MASK) == TYPE_MGMT_PROBE_RSP) {
-        //     bNeedACK = FALSE;
+        //     bNeedACK = false;
         //     pTxBufHead->wFIFOCtl  &= (~FIFOCTL_NEEDACK);
         //}
     }
@@ -2477,7 +2477,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
     pTxBufHead->wFIFOCtl |= (FIFOCTL_GENINT | FIFOCTL_ISDMA0);
 
     if ((p80211Header->sA4.wFrameCtl & TYPE_SUBTYPE_MASK) == TYPE_CTL_PSPOLL) {
-        bIsPSPOLL = TRUE;
+        bIsPSPOLL = true;
         cbMacHdLen = WLAN_HDR_ADDR2_LEN;
     } else {
         cbMacHdLen = WLAN_HDR_ADDR3_LEN;
@@ -2506,7 +2506,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
     // Notes:
     // Although spec says MMPDU can be fragmented; In most case,
     // no one will send a MMPDU under fragmentation. With RTS may occur.
-    pDevice->bAES = FALSE;  //Set FRAGCTL_WEPTYP
+    pDevice->bAES = false;  //Set FRAGCTL_WEPTYP
 
 
     if (WLAN_GET_FC_ISWEP(p80211Header->sA4.wFrameCtl) != 0) {
@@ -2529,7 +2529,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
             cbICVlen = 8;//MIC
             cbMICHDR = sizeof(SMICHDRHead);
             pTxBufHead->wFragCtl |= FRAGCTL_AES;
-            pDevice->bAES = TRUE;
+            pDevice->bAES = true;
         }
         //MAC Header should be padding 0 to DW alignment.
         uPadding = 4 - (cbMacHdLen%4);
@@ -2539,7 +2539,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
     cbFrameSize = cbMacHdLen + cbFrameBodySize + cbIVlen + cbMIClen + cbICVlen + cbFCSlen + cbExtSuppRate;
 
     //Set FIFOCTL_GrpAckPolicy
-    if (pDevice->bGrpAckPolicy == TRUE) {//0000 0100 0000 0000
+    if (pDevice->bGrpAckPolicy == true) {//0000 0100 0000 0000
         pTxBufHead->wFIFOCtl |=	FIFOCTL_GRPACK;
     }
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
@@ -2655,10 +2655,10 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
             MIC_vGetMIC(pdwMIC_L, pdwMIC_R);
             MIC_vUnInit();
 
-            if (pDevice->bTxMICFail == TRUE) {
+            if (pDevice->bTxMICFail == true) {
                 *pdwMIC_L = 0;
                 *pdwMIC_R = 0;
-                pDevice->bTxMICFail = FALSE;
+                pDevice->bTxMICFail = false;
             }
 
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"uLength: %d, %d\n", uLength, cbFrameBodySize);
@@ -2752,14 +2752,14 @@ nsDMA_tx_packet(
     BYTE            byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
     WORD            wAID;
     BYTE            byPktType;
-    BOOL            bNeedEncryption = FALSE;
+    BOOL            bNeedEncryption = false;
     PSKeyItem       pTransmitKey = NULL;
     SKeyItem        STempKey;
     unsigned int            ii;
-    BOOL            bTKIP_UseGTK = FALSE;
-    BOOL            bNeedDeAuth = FALSE;
+    BOOL            bTKIP_UseGTK = false;
+    BOOL            bNeedDeAuth = false;
     PBYTE           pbyBSSID;
-    BOOL            bNodeExist = FALSE;
+    BOOL            bNodeExist = false;
     PUSB_SEND_CONTEXT pContext;
     BOOL            fConvertedPacket;
     PTX_BUFFER      pTX_Buffer;
@@ -2769,7 +2769,7 @@ nsDMA_tx_packet(
 //#ifdef WPA_SM_Transtatus
   //  extern SWPAResult wpa_Result;
 //#endif
-     BOOL            bTxeapol_key = FALSE;
+     BOOL            bTxeapol_key = false;
 
 
     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -2781,7 +2781,7 @@ nsDMA_tx_packet(
 
 	if (is_multicast_ether_addr((PBYTE)(skb->data))) {
             uNodeIndex = 0;
-            bNodeExist = TRUE;
+            bNodeExist = true;
             if (pMgmt->sNodeDBTable[0].bPSEnable) {
 
                 skb_queue_tail(&(pMgmt->sNodeDBTable[0].sTxPSQueue), skb);
@@ -2826,11 +2826,11 @@ nsDMA_tx_packet(
                 }else {
                     pDevice->byPreambleType = PREAMBLE_LONG;
                 }
-                bNodeExist = TRUE;
+                bNodeExist = true;
             }
         }
 
-        if (bNodeExist == FALSE) {
+        if (bNodeExist == false) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"Unknown STA not found in node DB \n");
             dev_kfree_skb_irq(skb);
             return 0;
@@ -2861,22 +2861,22 @@ nsDMA_tx_packet(
    if (pDevice->sTxEthHeader.wType == TYPE_PKT_802_1x) {
            if(((Protocol_Version==1) ||(Protocol_Version==2)) &&
 	        (Packet_Type==3)) {  //802.1x OR eapol-key challenge frame transfer
-                        bTxeapol_key = TRUE;
+                        bTxeapol_key = true;
                        if(!(Key_info & BIT3) &&  //WPA or RSN group-key challenge
 			   (Key_info & BIT8) && (Key_info & BIT9)) {    //send 2/2 key
 			  if(Descriptor_type==254) {
-                               pDevice->fWPA_Authened = TRUE;
+                               pDevice->fWPA_Authened = true;
 			     PRINT_K("WPA ");
 			  }
 			  else {
-                               pDevice->fWPA_Authened = TRUE;
+                               pDevice->fWPA_Authened = true;
 			     PRINT_K("WPA2(re-keying) ");
 			  }
 			  PRINT_K("Authentication completed!!\n");
                         }
 		    else if((Key_info & BIT3) && (Descriptor_type==2) &&  //RSN pairse-key challenge
 			       (Key_info & BIT8) && (Key_info & BIT9)) {
-			  pDevice->fWPA_Authened = TRUE;
+			  pDevice->fWPA_Authened = true;
                             PRINT_K("WPA2 Authentication completed!!\n");
 		     }
              }
@@ -2884,18 +2884,18 @@ nsDMA_tx_packet(
 }
 //mike add:station mode check eapol-key challenge<---
 
-    if (pDevice->bEncryptionEnable == TRUE) {
-        bNeedEncryption = TRUE;
+    if (pDevice->bEncryptionEnable == true) {
+        bNeedEncryption = true;
         // get Transmit key
         do {
             if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
                 (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
                 pbyBSSID = pDevice->abyBSSID;
                 // get pairwise key
-                if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWISE_KEY, &pTransmitKey) == FALSE) {
+                if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWISE_KEY, &pTransmitKey) == false) {
                     // get group key
-                    if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == TRUE) {
-                        bTKIP_UseGTK = TRUE;
+                    if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == true) {
+                        bTKIP_UseGTK = true;
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"Get GTK.\n");
                         break;
                     }
@@ -2912,12 +2912,12 @@ nsDMA_tx_packet(
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"\n");
 
                 // get pairwise key
-                if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWISE_KEY, &pTransmitKey) == TRUE)
+                if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, PAIRWISE_KEY, &pTransmitKey) == true)
                     break;
             }
             // get group key
             pbyBSSID = pDevice->abyBroadcastAddr;
-            if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == FALSE) {
+            if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
                 pTransmitKey = NULL;
                 if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"IBSS and KEY is NULL. [%d]\n", pMgmt->eCurrMode);
@@ -2925,15 +2925,15 @@ nsDMA_tx_packet(
                 else
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"NOT IBSS and KEY is NULL. [%d]\n", pMgmt->eCurrMode);
             } else {
-                bTKIP_UseGTK = TRUE;
+                bTKIP_UseGTK = true;
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"Get GTK.\n");
             }
-        } while(FALSE);
+        } while(false);
     }
 
     if (pDevice->bEnableHostWEP) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"acdma0: STA index %d\n", uNodeIndex);
-        if (pDevice->bEncryptionEnable == TRUE) {
+        if (pDevice->bEncryptionEnable == true) {
             pTransmitKey = &STempKey;
             pTransmitKey->byCipherSuite = pMgmt->sNodeDBTable[uNodeIndex].byCipherSuite;
             pTransmitKey->dwKeyIndex = pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex;
@@ -3032,28 +3032,28 @@ nsDMA_tx_packet(
         byPktType = PK_TYPE_11B;
     }
 
-    if (bNeedEncryption == TRUE) {
+    if (bNeedEncryption == true) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ntohs Pkt Type=%04x\n", ntohs(pDevice->sTxEthHeader.wType));
         if ((pDevice->sTxEthHeader.wType) == TYPE_PKT_802_1x) {
-            bNeedEncryption = FALSE;
+            bNeedEncryption = false;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Pkt Type=%04x\n", (pDevice->sTxEthHeader.wType));
             if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) && (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
                 if (pTransmitKey == NULL) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Don't Find TX KEY\n");
                 }
                 else {
-                    if (bTKIP_UseGTK == TRUE) {
+                    if (bTKIP_UseGTK == true) {
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"error: KEY is GTK!!~~\n");
                     }
                     else {
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%lX]\n", pTransmitKey->dwKeyIndex);
-                        bNeedEncryption = TRUE;
+                        bNeedEncryption = true;
                     }
                 }
             }
 
             if (pDevice->byCntMeasure == 2) {
-                bNeedDeAuth = TRUE;
+                bNeedDeAuth = true;
                 pDevice->s802_11Counter.TKIPCounterMeasuresInvoked++;
             }
 
@@ -3061,7 +3061,7 @@ nsDMA_tx_packet(
                 if ((uNodeIndex != 0) &&
                     (pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex & PAIRWISE_KEY)) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%lX]\n", pTransmitKey->dwKeyIndex);
-                    bNeedEncryption = TRUE;
+                    bNeedEncryption = true;
                  }
              }
         }
@@ -3084,18 +3084,18 @@ nsDMA_tx_packet(
                         &uHeaderLen, &BytesToWrite
                        );
 
-    if (fConvertedPacket == FALSE) {
-        pContext->bBoolInUse = FALSE;
+    if (fConvertedPacket == false) {
+        pContext->bBoolInUse = false;
         dev_kfree_skb_irq(skb);
         return STATUS_FAILURE;
     }
 
-    if ( pDevice->bEnablePSMode == TRUE ) {
+    if ( pDevice->bEnablePSMode == true ) {
         if ( !pDevice->bPSModeTxBurst ) {
 		bScheduleCommand((void *) pDevice,
 				 WLAN_CMD_MAC_DISPOWERSAVING,
 				 NULL);
-            pDevice->bPSModeTxBurst = TRUE;
+            pDevice->bPSModeTxBurst = true;
         }
     }
 
@@ -3111,14 +3111,14 @@ nsDMA_tx_packet(
 
     status = PIPEnsSendBulkOut(pDevice,pContext);
 
-    if (bNeedDeAuth == TRUE) {
+    if (bNeedDeAuth == true) {
         WORD wReason = WLAN_MGMT_REASON_MIC_FAILURE;
 
 	bScheduleCommand((void *) pDevice, WLAN_CMD_DEAUTH, (PBYTE) &wReason);
     }
 
   if(status!=STATUS_PENDING) {
-     pContext->bBoolInUse = FALSE;
+     pContext->bBoolInUse = false;
     dev_kfree_skb_irq(skb);
     return STATUS_FAILURE;
   }
@@ -3139,9 +3139,9 @@ nsDMA_tx_packet(
  *      pPacket         - Pointer to rx packet
  *      cbPacketSize    - rx ethernet frame size
  *  Out:
- *      TURE, FALSE
+ *      TURE, false
  *
- * Return Value: Return TRUE if packet is copy to dma1; otherwise FALSE
+ * Return Value: Return true if packet is copy to dma1; otherwise false
  */
 
 
@@ -3156,7 +3156,7 @@ bRelayPacketSend (
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
     unsigned int BytesToWrite = 0, uHeaderLen = 0;
     BYTE            byPktType = PK_TYPE_11B;
-    BOOL            bNeedEncryption = FALSE;
+    BOOL            bNeedEncryption = false;
     SKeyItem        STempKey;
     PSKeyItem       pTransmitKey = NULL;
     PBYTE           pbyBSSID;
@@ -3172,16 +3172,16 @@ bRelayPacketSend (
     pContext = (PUSB_SEND_CONTEXT)s_vGetFreeContext(pDevice);
 
     if (NULL == pContext) {
-        return FALSE;
+        return false;
     }
 
     memcpy(pDevice->sTxEthHeader.abyDstAddr, (PBYTE)pbySkbData, ETH_HLEN);
 
-    if (pDevice->bEncryptionEnable == TRUE) {
-        bNeedEncryption = TRUE;
+    if (pDevice->bEncryptionEnable == true) {
+        bNeedEncryption = true;
         // get group key
         pbyBSSID = pDevice->abyBroadcastAddr;
-        if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == FALSE) {
+        if(KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID, GROUP_KEY, &pTransmitKey) == false) {
             pTransmitKey = NULL;
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG"KEY is NULL. [%d]\n", pMgmt->eCurrMode);
         } else {
@@ -3205,8 +3205,8 @@ bRelayPacketSend (
     }
 
     if ( bNeedEncryption && (pTransmitKey == NULL) ) {
-        pContext->bBoolInUse = FALSE;
-        return FALSE;
+        pContext->bBoolInUse = false;
+        return false;
     }
 
     byPktTyp = (BYTE)pDevice->byPacketType;
@@ -3253,9 +3253,9 @@ bRelayPacketSend (
                          &uHeaderLen, &BytesToWrite
                         );
 
-    if (fConvertedPacket == FALSE) {
-        pContext->bBoolInUse = FALSE;
-        return FALSE;
+    if (fConvertedPacket == false) {
+        pContext->bBoolInUse = false;
+        return false;
     }
 
     pTX_Buffer = (PTX_BUFFER)&(pContext->Data[0]);
@@ -3270,6 +3270,6 @@ bRelayPacketSend (
 
     status = PIPEnsSendBulkOut(pDevice,pContext);
 
-    return TRUE;
+    return true;
 }
 
diff --git a/drivers/staging/vt6656/tether.c b/drivers/staging/vt6656/tether.c
index 4f368f1..c268c7b 100644
--- a/drivers/staging/vt6656/tether.c
+++ b/drivers/staging/vt6656/tether.c
@@ -93,7 +93,7 @@ BYTE ETHbyGetHashIndexByCrc32(PBYTE pbyMultiAddr)
  *  Out:
  *      none
  *
- * Return Value: TRUE if ok; FALSE if error.
+ * Return Value: true if ok; false if error.
  *
  */
 BOOL ETHbIsBufferCrc32Ok(PBYTE pbyBuffer, unsigned int cbFrameLength)
@@ -102,7 +102,7 @@ BOOL ETHbIsBufferCrc32Ok(PBYTE pbyBuffer, unsigned int cbFrameLength)
 
 	dwCRC = CRCdwGetCrc32(pbyBuffer, cbFrameLength - 4);
 	if (cpu_to_le32(*((PDWORD)(pbyBuffer + cbFrameLength - 4))) != dwCRC)
-		return FALSE;
-	return TRUE;
+		return false;
+	return true;
 }
 
diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 3425773..12eea7b 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -43,13 +43,6 @@
 
 typedef int             BOOL;
 
-#if !defined(TRUE)
-#define TRUE            1
-#endif
-#if !defined(FALSE)
-#define FALSE           0
-#endif
-
 //2007-0809-01<Add>by MikeLiu
 #ifndef update_BssList
 #define update_BssList
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 8c7b3af..bfb8be2 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -370,11 +370,11 @@ PIPEnsInterruptRead(
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsStartInterruptUsbRead()\n");
 
-    if(pDevice->intBuf.bInUse == TRUE){
+    if(pDevice->intBuf.bInUse == true){
         return (STATUS_FAILURE);
     }
-    pDevice->intBuf.bInUse = TRUE;
-//    pDevice->bEventAvailable = FALSE;
+    pDevice->intBuf.bInUse = true;
+//    pDevice->bEventAvailable = false;
     pDevice->ulIntInPosted++;
 
     //
@@ -461,7 +461,7 @@ s_nsInterruptUsbIoCompleteRead(
     // otherwise interrupt data handler will free int buffer after it handle it.
     if (( ntStatus != STATUS_SUCCESS )) {
         pDevice->ulBulkInError++;
-        pDevice->intBuf.bInUse = FALSE;
+        pDevice->intBuf.bInUse = false;
 
 //        if (ntStatus == USBD_STATUS_CRC) {
 //            pDevice->ulIntInContCRCError++;
@@ -469,20 +469,20 @@ s_nsInterruptUsbIoCompleteRead(
 
 //        if (ntStatus == STATUS_NOT_CONNECTED )
 //        {
-            pDevice->fKillEventPollingThread = TRUE;
+            pDevice->fKillEventPollingThread = true;
 //        }
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"IntUSBIoCompleteControl STATUS = %d\n", ntStatus );
     } else {
 	    pDevice->ulIntInBytesRead += (unsigned long) urb->actual_length;
 	    pDevice->ulIntInContCRCError = 0;
-	    pDevice->bEventAvailable = TRUE;
+	    pDevice->bEventAvailable = true;
 	    INTnsProcessData(pDevice);
     }
 
     STAvUpdateUSBCounter(&pDevice->scStatistic.USB_InterruptStat, ntStatus);
 
 
-    if (pDevice->fKillEventPollingThread != TRUE) {
+    if (pDevice->fKillEventPollingThread != true) {
     #ifdef Safe_Close
        usb_fill_bulk_urb(pDevice->pInterruptURB,
 		      pDevice->usb,
@@ -563,7 +563,7 @@ PIPEnsBulkInUsbRead(
 		return STATUS_FAILURE ;
 	}
     pRCB->Ref = 1;
-    pRCB->bBoolInUse= TRUE;
+    pRCB->bBoolInUse= true;
 
     return ntStatus;
 }
@@ -595,8 +595,8 @@ s_nsBulkInUsbIoCompleteRead(
     PRCB    pRCB = (PRCB)urb->context;
     PSDevice pDevice = (PSDevice)pRCB->pDevice;
     unsigned long   bytesRead;
-    BOOL    bIndicateReceive = FALSE;
-    BOOL    bReAllocSkb = FALSE;
+    BOOL    bIndicateReceive = false;
+    BOOL    bReAllocSkb = false;
     NTSTATUS    status;
 
 
@@ -621,7 +621,7 @@ s_nsBulkInUsbIoCompleteRead(
 //            MP_SET_FLAG(pDevice, fMP_DISCONNECTED);
 //        }
     } else {
-        bIndicateReceive = TRUE;
+        bIndicateReceive = true;
         pDevice->ulBulkInContCRCError = 0;
         pDevice->ulBulkInBytesRead += bytesRead;
 
@@ -635,8 +635,8 @@ s_nsBulkInUsbIoCompleteRead(
 
     if (bIndicateReceive) {
         spin_lock(&pDevice->lock);
-        if (RXbBulkInProcessData(pDevice, pRCB, bytesRead) == TRUE)
-            bReAllocSkb = TRUE;
+        if (RXbBulkInProcessData(pDevice, pRCB, bytesRead) == true)
+            bReAllocSkb = true;
         spin_unlock(&pDevice->lock);
     }
     pRCB->Ref--;
@@ -676,7 +676,7 @@ PIPEnsSendBulkOut(
 
 
 
-    pDevice->bPWBitOn = FALSE;
+    pDevice->bPWBitOn = false;
 
 /*
     if (pDevice->pPendingBulkOutContext != NULL) {
@@ -713,7 +713,7 @@ PIPEnsSendBulkOut(
         return STATUS_PENDING;
     }
     else {
-        pContext->bBoolInUse = FALSE;
+        pContext->bBoolInUse = false;
         return STATUS_RESOURCES;
     }
 }
@@ -815,11 +815,11 @@ s_nsBulkOutIoCompleteWrite(
         }
 
     }
-    if (pDevice->bLinkPass == TRUE) {
+    if (pDevice->bLinkPass == true) {
         if (netif_queue_stopped(pDevice->dev))
             netif_wake_queue(pDevice->dev);
     }
-    pContext->bBoolInUse = FALSE;
+    pContext->bBoolInUse = false;
 
     return;
 }
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index ec1c057..5c5b624 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -133,18 +133,18 @@ vAdHocBeaconStop(PSDevice  pDevice)
      *      or
      *      (3.2) AdHoc channel is in A mode
      */
-    bStop = FALSE;
+    bStop = false;
     if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) &&
     (pMgmt->eCurrState >= WMAC_STATE_STARTED))
     {
         if ((pMgmt->uIBSSChannel <=  CB_MAX_CHANNEL_24G) &&
              (pMgmt->uScanChannel > CB_MAX_CHANNEL_24G))
         {
-            bStop = TRUE;
+            bStop = true;
         }
         if (pMgmt->uIBSSChannel >  CB_MAX_CHANNEL_24G)
         {
-            bStop = TRUE;
+            bStop = true;
         }
     }
 
@@ -344,7 +344,7 @@ void vRunCommand(void *hDeviceContext)
 
     if (pDevice->dwDiagRefCount != 0)
         return;
-    if (pDevice->bCmdRunning != TRUE)
+    if (pDevice->bCmdRunning != true)
         return;
 
     spin_lock_irq(&pDevice->lock);
@@ -354,7 +354,7 @@ void vRunCommand(void *hDeviceContext)
         case WLAN_CMD_SCAN_START:
 
 		pDevice->byReAssocCount = 0;
-            if (pDevice->bRadioOff == TRUE) {
+            if (pDevice->bRadioOff == true) {
                 s_bCommandComplete(pDevice);
                 spin_unlock_irq(&pDevice->lock);
                 return;
@@ -382,7 +382,7 @@ void vRunCommand(void *hDeviceContext)
                 if (pDevice->bUpdateBBVGA) {
                     BBvSetShortSlotTime(pDevice);
                     BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
-                    BBvUpdatePreEDThreshold(pDevice, FALSE);
+                    BBvUpdatePreEDThreshold(pDevice, false);
                 }
                 // Set channel back
                 vAdHocBeaconRestart(pDevice);
@@ -394,7 +394,7 @@ void vRunCommand(void *hDeviceContext)
                     pDevice->byRxMode |= RCR_BSSID;
                 }
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning, set back to channel: [%d]\n", pMgmt->uCurrChannel);
-                pDevice->bStopDataPkt = FALSE;
+                pDevice->bStopDataPkt = false;
                 s_bCommandComplete(pDevice);
                 spin_unlock_irq(&pDevice->lock);
                 return;
@@ -420,7 +420,7 @@ void vRunCommand(void *hDeviceContext)
 		       pDevice->bLinkPass); */
                     pMgmt->eScanState = WMAC_IS_SCANNING;
                     pDevice->byScanBBType = pDevice->byBBType;  //lucas
-                    pDevice->bStopDataPkt = TRUE;
+                    pDevice->bStopDataPkt = true;
                     // Turn off RCR_BSSID filter everytime
                     MACvRegBitsOff(pDevice, MAC_REG_RCR, RCR_BSSID);
                     pDevice->byRxMode &= ~RCR_BSSID;
@@ -444,7 +444,7 @@ void vRunCommand(void *hDeviceContext)
                 if (pDevice->bUpdateBBVGA) {
                     BBvSetShortSlotTime(pDevice);
                     BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
-                    BBvUpdatePreEDThreshold(pDevice, TRUE);
+                    BBvUpdatePreEDThreshold(pDevice, true);
                 }
                 pMgmt->uScanChannel++;
 
@@ -458,7 +458,7 @@ void vRunCommand(void *hDeviceContext)
                     pDevice->eCommandState = WLAN_CMD_SCAN_END;
 
                 }
-                if ((pMgmt->b11hEnable == FALSE) ||
+                if ((pMgmt->b11hEnable == false) ||
                     (pMgmt->uScanChannel < CB_MAX_CHANNEL_24G)) {
                     s_vProbeChannel(pDevice);
                     spin_unlock_irq(&pDevice->lock);
@@ -485,7 +485,7 @@ void vRunCommand(void *hDeviceContext)
             if (pDevice->bUpdateBBVGA) {
                 BBvSetShortSlotTime(pDevice);
                 BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
-                BBvUpdatePreEDThreshold(pDevice, FALSE);
+                BBvUpdatePreEDThreshold(pDevice, false);
             }
 
             // Set channel back
@@ -499,7 +499,7 @@ void vRunCommand(void *hDeviceContext)
             }
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning, set back to channel: [%d]\n", pMgmt->uCurrChannel);
             pMgmt->eScanState = WMAC_NO_SCANNING;
-            pDevice->bStopDataPkt = FALSE;
+            pDevice->bStopDataPkt = false;
 //2008-0409-07, <Add> by Einsn Liu
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	if(pMgmt->eScanType == WMAC_SCAN_PASSIVE)
@@ -524,13 +524,13 @@ void vRunCommand(void *hDeviceContext)
             } else {
 
           #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-		      pDevice->bwextstep0 = FALSE;
-                        pDevice->bwextstep1 = FALSE;
-                        pDevice->bwextstep2 = FALSE;
-                        pDevice->bwextstep3 = FALSE;
-		   pDevice->bWPASuppWextEnabled = FALSE;
+		      pDevice->bwextstep0 = false;
+                        pDevice->bwextstep1 = false;
+                        pDevice->bwextstep2 = false;
+                        pDevice->bwextstep3 = false;
+		   pDevice->bWPASuppWextEnabled = false;
 	 #endif
-                   pDevice->fWPA_Authened = FALSE;
+                   pDevice->fWPA_Authened = false;
 
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Send Disassociation Packet..\n");
                 // reason = 8 : disassoc because sta has left
@@ -539,18 +539,18 @@ void vRunCommand(void *hDeviceContext)
 				     pMgmt->abyCurrBSSID,
 				     (8),
 				     &Status);
-                pDevice->bLinkPass = FALSE;
+                pDevice->bLinkPass = false;
                 ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
                 // unlock command busy
                 pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
                 pItemSSID->len = 0;
                 memset(pItemSSID->abySSID, 0, WLAN_SSID_MAXLEN);
                 pMgmt->eCurrState = WMAC_STATE_IDLE;
-                pMgmt->sNodeDBTable[0].bActive = FALSE;
-//                pDevice->bBeaconBufReady = FALSE;
+                pMgmt->sNodeDBTable[0].bActive = false;
+//                pDevice->bBeaconBufReady = false;
             }
             netif_stop_queue(pDevice->dev);
-            if (pDevice->bNeedRadioOFF == TRUE)
+            if (pDevice->bNeedRadioOFF == true)
                 CARDbRadioPowerOff(pDevice);
             s_bCommandComplete(pDevice);
             break;
@@ -559,7 +559,7 @@ void vRunCommand(void *hDeviceContext)
         case WLAN_CMD_SSID_START:
 
 		pDevice->byReAssocCount = 0;
-            if (pDevice->bRadioOff == TRUE) {
+            if (pDevice->bRadioOff == true) {
                 s_bCommandComplete(pDevice);
                 spin_unlock_irq(&pDevice->lock);
                 return;
@@ -594,7 +594,7 @@ void vRunCommand(void *hDeviceContext)
                     }
                 }
                 netif_stop_queue(pDevice->dev);
-                pDevice->bLinkPass = FALSE;
+                pDevice->bLinkPass = false;
                 ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
             }
             // set initial state
@@ -631,9 +631,9 @@ void vRunCommand(void *hDeviceContext)
                     if (netif_queue_stopped(pDevice->dev)){
                         netif_wake_queue(pDevice->dev);
                     }
-                    pDevice->bLinkPass = TRUE;
+                    pDevice->bLinkPass = true;
                     ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
-                    pMgmt->sNodeDBTable[0].bActive = TRUE;
+                    pMgmt->sNodeDBTable[0].bActive = true;
                     pMgmt->sNodeDBTable[0].uInActiveCount = 0;
                 }
                 else {
@@ -664,7 +664,7 @@ void vRunCommand(void *hDeviceContext)
                     BSSvAddMulticastNode(pDevice);
                     s_bClearBSSID_SCAN(pDevice);
 /*
-                    pDevice->bLinkPass = TRUE;
+                    pDevice->bLinkPass = true;
                     ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
                     if (netif_queue_stopped(pDevice->dev)){
                         netif_wake_queue(pDevice->dev);
@@ -675,7 +675,7 @@ void vRunCommand(void *hDeviceContext)
                 else {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disconnect SSID none\n");
                      #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-                    // if(pDevice->bWPASuppWextEnabled == TRUE)
+                    // if(pDevice->bWPASuppWextEnabled == true)
                         {
                   	union iwreq_data  wrqu;
                   	memset(&wrqu, 0, sizeof (wrqu));
@@ -734,7 +734,7 @@ void vRunCommand(void *hDeviceContext)
 */
                 pDevice->byLinkWaitCount = 0;
                 pDevice->byReAssocCount = 0;
-                pDevice->bLinkPass = TRUE;
+                pDevice->bLinkPass = true;
                 ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
                 s_bClearBSSID_SCAN(pDevice);
 
@@ -742,20 +742,20 @@ void vRunCommand(void *hDeviceContext)
                     netif_wake_queue(pDevice->dev);
                 }
 
-		 if(pDevice->IsTxDataTrigger != FALSE)   {    //TxDataTimer is not triggered at the first time
+		 if(pDevice->IsTxDataTrigger != false)   {    //TxDataTimer is not triggered at the first time
                      // printk("Re-initial TxDataTimer****\n");
 		    del_timer(&pDevice->sTimerTxData);
                       init_timer(&pDevice->sTimerTxData);
 			pDevice->sTimerTxData.data = (unsigned long) pDevice;
                       pDevice->sTimerTxData.function = (TimerFunction)BSSvSecondTxData;
                       pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
-                      pDevice->fTxDataInSleep = FALSE;
+                      pDevice->fTxDataInSleep = false;
                       pDevice->nTxDataTimeCout = 0;
 		 }
 		 else {
 		   // printk("mike:-->First time triger TimerTxData InSleep\n");
 		 }
-		pDevice->IsTxDataTrigger = TRUE;
+		pDevice->IsTxDataTrigger = true;
                 add_timer(&pDevice->sTimerTxData);
 
             }
@@ -781,15 +781,15 @@ void vRunCommand(void *hDeviceContext)
                 del_timer(&pMgmt->sTimerSecondCallback);
                 pMgmt->eCurrState = WMAC_STATE_IDLE;
                 pMgmt->eCurrMode = WMAC_MODE_STANDBY;
-                pDevice->bLinkPass = FALSE;
+                pDevice->bLinkPass = false;
                 ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
-                if (pDevice->bEnableHostWEP == TRUE)
+                if (pDevice->bEnableHostWEP == true)
                     BSSvClearNodeDBTable(pDevice, 1);
                 else
                     BSSvClearNodeDBTable(pDevice, 0);
                 pDevice->uAssocCount = 0;
                 pMgmt->eCurrState = WMAC_STATE_IDLE;
-                pDevice->bFixRate = FALSE;
+                pDevice->bFixRate = false;
 
 		vMgrCreateOwnIBSS((void *) pDevice, &Status);
 		if (Status != CMD_STATUS_SUCCESS) {
@@ -804,7 +804,7 @@ void vRunCommand(void *hDeviceContext)
                 if (netif_queue_stopped(pDevice->dev)){
                     netif_wake_queue(pDevice->dev);
                 }
-                pDevice->bLinkPass = TRUE;
+                pDevice->bLinkPass = true;
                 ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
                 add_timer(&pMgmt->sTimerSecondCallback);
             }
@@ -817,10 +817,10 @@ void vRunCommand(void *hDeviceContext)
                 while ((skb = skb_dequeue(&pMgmt->sNodeDBTable[0].sTxPSQueue)) != NULL) {
                     if (skb_queue_empty(&pMgmt->sNodeDBTable[0].sTxPSQueue)) {
                         pMgmt->abyPSTxMap[0] &= ~byMask[0];
-                        pDevice->bMoreData = FALSE;
+                        pDevice->bMoreData = false;
                     }
                     else {
-                        pDevice->bMoreData = TRUE;
+                        pDevice->bMoreData = true;
                     }
 
                     if (nsDMA_tx_packet(pDevice, TYPE_AC0DMA, skb) != 0) {
@@ -842,10 +842,10 @@ void vRunCommand(void *hDeviceContext)
                             // clear tx map
                             pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[ii].wAID >> 3] &=
                                     ~byMask[pMgmt->sNodeDBTable[ii].wAID & 7];
-                            pDevice->bMoreData = FALSE;
+                            pDevice->bMoreData = false;
                         }
                         else {
-                            pDevice->bMoreData = TRUE;
+                            pDevice->bMoreData = true;
                         }
 
                         if (nsDMA_tx_packet(pDevice, TYPE_AC0DMA, skb) != 0) {
@@ -864,7 +864,7 @@ void vRunCommand(void *hDeviceContext)
                                     ~byMask[pMgmt->sNodeDBTable[ii].wAID & 7];
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Index=%d PS queue clear \n", ii);
                     }
-                    pMgmt->sNodeDBTable[ii].bRxPSPoll = FALSE;
+                    pMgmt->sNodeDBTable[ii].bRxPSPoll = false;
                 }
             }
 
@@ -874,7 +874,7 @@ void vRunCommand(void *hDeviceContext)
         case WLAN_CMD_RADIO_START:
 
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"eCommandState == WLAN_CMD_RADIO_START\n");
-       //     if (pDevice->bRadioCmd == TRUE)
+       //     if (pDevice->bRadioCmd == true)
        //         CARDbRadioPowerOn(pDevice);
        //     else
        //         CARDbRadioPowerOff(pDevice);
@@ -902,32 +902,32 @@ void vRunCommand(void *hDeviceContext)
 	       pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
                 pDevice->uCmdDequeueIdx = 0;
                 pDevice->uCmdEnqueueIdx = 0;
-                //0415pDevice->bCmdRunning = FALSE;
-                pDevice->bCmdClear = TRUE;
-                pDevice->bStopTx0Pkt = FALSE;
-                pDevice->bStopDataPkt = TRUE;
+                //0415pDevice->bCmdRunning = false;
+                pDevice->bCmdClear = true;
+                pDevice->bStopTx0Pkt = false;
+                pDevice->bStopDataPkt = true;
 
                 pDevice->byKeyIndex = 0;
-                pDevice->bTransmitKey = FALSE;
+                pDevice->bTransmitKey = false;
 	    spin_unlock_irq(&pDevice->lock);
 	    KeyvInitTable(pDevice,&pDevice->sKey);
 	    spin_lock_irq(&pDevice->lock);
 	       pMgmt->byCSSPK = KEY_CTL_NONE;
                 pMgmt->byCSSGK = KEY_CTL_NONE;
 
-	  if (pDevice->bLinkPass == TRUE) {
+	  if (pDevice->bLinkPass == true) {
                 // reason = 8 : disassoc because sta has left
 		vMgrDisassocBeginSta((void *) pDevice,
 				     pMgmt,
 				     pMgmt->abyCurrBSSID,
 				     (8),
 				     &Status);
-                       pDevice->bLinkPass = FALSE;
+                       pDevice->bLinkPass = false;
                 // unlock command busy
                         pMgmt->eCurrState = WMAC_STATE_IDLE;
-                        pMgmt->sNodeDBTable[0].bActive = FALSE;
+                        pMgmt->sNodeDBTable[0].bActive = false;
                      #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-                    // if(pDevice->bWPASuppWextEnabled == TRUE)
+                    // if(pDevice->bWPASuppWextEnabled == true)
                         {
                   	union iwreq_data  wrqu;
                   	memset(&wrqu, 0, sizeof (wrqu));
@@ -938,11 +938,11 @@ void vRunCommand(void *hDeviceContext)
                     #endif
 	  	}
 	       #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-	               pDevice->bwextstep0 = FALSE;
-                        pDevice->bwextstep1 = FALSE;
-                        pDevice->bwextstep2 = FALSE;
-                        pDevice->bwextstep3 = FALSE;
-		      pDevice->bWPASuppWextEnabled = FALSE;
+	               pDevice->bwextstep0 = false;
+                        pDevice->bwextstep1 = false;
+                        pDevice->bwextstep2 = false;
+                        pDevice->bwextstep3 = false;
+		      pDevice->bWPASuppWextEnabled = false;
 		#endif
 	                  //clear current SSID
                   pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
@@ -957,10 +957,10 @@ void vRunCommand(void *hDeviceContext)
 	    CARDbRadioPowerOff(pDevice);
              MACvRegBitsOn(pDevice,MAC_REG_GPIOCTL1,GPIO3_INTMD);
 	    ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_OFF);
-	    pDevice->bHWRadioOff = TRUE;
+	    pDevice->bHWRadioOff = true;
         } else {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" WLAN_CMD_RADIO_START_ON........................\n");
-            pDevice->bHWRadioOff = FALSE;
+            pDevice->bHWRadioOff = false;
                 CARDbRadioPowerOn(pDevice);
             MACvRegBitsOff(pDevice,MAC_REG_GPIOCTL1,GPIO3_INTMD);
             ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_ON);
@@ -973,11 +973,11 @@ void vRunCommand(void *hDeviceContext)
 
         case WLAN_CMD_CHANGE_BBSENSITIVITY_START:
 
-            pDevice->bStopDataPkt = TRUE;
+            pDevice->bStopDataPkt = true;
             pDevice->byBBVGACurrent = pDevice->byBBVGANew;
             BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Change sensitivity pDevice->byBBVGACurrent = %x\n", pDevice->byBBVGACurrent);
-            pDevice->bStopDataPkt = FALSE;
+            pDevice->bStopDataPkt = false;
             s_bCommandComplete(pDevice);
             break;
 
@@ -1002,13 +1002,13 @@ void vRunCommand(void *hDeviceContext)
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Change from Antenna%d to", (int)pDevice->dwRxAntennaSel);
             if ( pDevice->dwRxAntennaSel == 0) {
                 pDevice->dwRxAntennaSel=1;
-                if (pDevice->bTxRxAntInv == TRUE)
+                if (pDevice->bTxRxAntInv == true)
                     BBvSetAntennaMode(pDevice, ANT_RXA);
                 else
                     BBvSetAntennaMode(pDevice, ANT_RXB);
             } else {
                 pDevice->dwRxAntennaSel=0;
-                if (pDevice->bTxRxAntInv == TRUE)
+                if (pDevice->bTxRxAntInv == true)
                     BBvSetAntennaMode(pDevice, ANT_RXB);
                 else
                     BBvSetAntennaMode(pDevice, ANT_RXA);
@@ -1039,9 +1039,9 @@ void vRunCommand(void *hDeviceContext)
 
         case WLAN_CMD_11H_CHSW_START:
             CARDbSetMediaChannel(pDevice, pDevice->byNewChannel);
-            pDevice->bChannelSwitch = FALSE;
+            pDevice->bChannelSwitch = false;
             pMgmt->uCurrChannel = pDevice->byNewChannel;
-            pDevice->bStopDataPkt = FALSE;
+            pDevice->bStopDataPkt = false;
             s_bCommandComplete(pDevice);
             break;
 
@@ -1062,17 +1062,17 @@ s_bCommandComplete (
     )
 {
     PWLAN_IE_SSID pSSID;
-    BOOL          bRadioCmd = FALSE;
+    BOOL          bRadioCmd = false;
     //WORD          wDeAuthenReason = 0;
-    BOOL          bForceSCAN = TRUE;
+    BOOL          bForceSCAN = true;
     PSMgmtObject  pMgmt = &(pDevice->sMgmtObj);
 
 
     pDevice->eCommandState = WLAN_CMD_IDLE;
     if (pDevice->cbFreeCmdQueue == CMD_Q_SIZE) {
         //Command Queue Empty
-        pDevice->bCmdRunning = FALSE;
-        return TRUE;
+        pDevice->bCmdRunning = false;
+        return true;
     }
     else {
         pDevice->eCommand = pDevice->eCmdQueue[pDevice->uCmdDequeueIdx].eCmd;
@@ -1081,7 +1081,7 @@ s_bCommandComplete (
         bForceSCAN = pDevice->eCmdQueue[pDevice->uCmdDequeueIdx].bForceSCAN;
         ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdDequeueIdx, CMD_Q_SIZE);
         pDevice->cbFreeCmdQueue++;
-        pDevice->bCmdRunning = TRUE;
+        pDevice->bCmdRunning = true;
         switch ( pDevice->eCommand ) {
             case WLAN_CMD_BSSID_SCAN:
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"eCommandState= WLAN_CMD_BSSID_SCAN\n");
@@ -1093,7 +1093,7 @@ s_bCommandComplete (
                     memset(pMgmt->abyScanSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
                 }
 /*
-                if ((bForceSCAN == FALSE) && (pDevice->bLinkPass == TRUE)) {
+                if ((bForceSCAN == false) && (pDevice->bLinkPass == true)) {
                     if ((pSSID->len == ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len) &&
                         ( !memcmp(pSSID->abySSID, ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->abySSID, pSSID->len))) {
                         pDevice->eCommandState = WLAN_CMD_IDLE;
@@ -1161,7 +1161,7 @@ s_bCommandComplete (
 	vCommandTimerWait((void *) pDevice, 0);
     }
 
-    return TRUE;
+    return true;
 }
 
 BOOL bScheduleCommand(void *hDeviceContext,
@@ -1172,15 +1172,15 @@ BOOL bScheduleCommand(void *hDeviceContext,
 
 
     if (pDevice->cbFreeCmdQueue == 0) {
-        return (FALSE);
+        return (false);
     }
     pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].eCmd = eCommand;
-    pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bForceSCAN = TRUE;
+    pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bForceSCAN = true;
     memset(pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].abyCmdDesireSSID, 0 , WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
     if (pbyItem0 != NULL) {
         switch (eCommand) {
             case WLAN_CMD_BSSID_SCAN:
-                pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bForceSCAN = FALSE;
+                pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bForceSCAN = false;
                 memcpy(pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].abyCmdDesireSSID,
                          pbyItem0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
                 break;
@@ -1211,12 +1211,12 @@ BOOL bScheduleCommand(void *hDeviceContext,
     ADD_ONE_WITH_WRAP_AROUND(pDevice->uCmdEnqueueIdx, CMD_Q_SIZE);
     pDevice->cbFreeCmdQueue--;
 
-    if (pDevice->bCmdRunning == FALSE) {
+    if (pDevice->bCmdRunning == false) {
         s_bCommandComplete(pDevice);
     }
     else {
     }
-    return (TRUE);
+    return (true);
 
 }
 
@@ -1231,7 +1231,7 @@ BOOL bScheduleCommand(void *hDeviceContext,
  *  Out:
  *      none
  *
- * Return Value: TRUE if success; otherwise FALSE
+ * Return Value: true if success; otherwise false
  *
  */
 static BOOL s_bClearBSSID_SCAN(void *hDeviceContext)
@@ -1249,7 +1249,7 @@ static BOOL s_bClearBSSID_SCAN(void *hDeviceContext)
                 break;
         }
     }
-    return TRUE;
+    return true;
 }
 
 
@@ -1269,8 +1269,8 @@ void vResetCommandTimer(void *hDeviceContext)
     pDevice->uCmdDequeueIdx = 0;
     pDevice->uCmdEnqueueIdx = 0;
     pDevice->eCommandState = WLAN_CMD_IDLE;
-    pDevice->bCmdRunning = FALSE;
-    pDevice->bCmdClear = FALSE;
+    pDevice->bCmdRunning = false;
+    pDevice->bCmdClear = false;
 }
 
 void BSSvSecondTxData(void *hDeviceContext)
@@ -1292,15 +1292,15 @@ void BSSvSecondTxData(void *hDeviceContext)
   spin_lock_irq(&pDevice->lock);
   //is wap_supplicant running successful OR only open && sharekey mode!
   #if 1
-  if(((pDevice->bLinkPass ==TRUE)&&(pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||  //open && sharekey linking
-      (pDevice->fWPA_Authened == TRUE)) {   //wpa linking
+  if(((pDevice->bLinkPass ==true)&&(pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||  //open && sharekey linking
+      (pDevice->fWPA_Authened == true)) {   //wpa linking
  #else
-  if(pDevice->bLinkPass ==TRUE) {
+  if(pDevice->bLinkPass ==true) {
  #endif
         //   printk("mike:%s-->InSleep Tx Data Procedure\n",__FUNCTION__);
-	  pDevice->fTxDataInSleep = TRUE;
+	  pDevice->fTxDataInSleep = true;
 	  PSbSendNullPacket(pDevice);      //send null packet
-	  pDevice->fTxDataInSleep = FALSE;
+	  pDevice->fTxDataInSleep = false;
   	}
   spin_unlock_irq(&pDevice->lock);
 
diff --git a/drivers/staging/vt6656/wctl.c b/drivers/staging/vt6656/wctl.c
index c231ae7..0ece360 100644
--- a/drivers/staging/vt6656/wctl.c
+++ b/drivers/staging/vt6656/wctl.c
@@ -53,8 +53,8 @@
 
 /*
  * Description:
- *      Scan Rx cache.  Return TRUE if packet is duplicate, else
- *      inserts in receive cache and returns FALSE.
+ *      Scan Rx cache.  Return true if packet is duplicate, else
+ *      inserts in receive cache and returns false.
  *
  * Parameters:
  *  In:
@@ -63,7 +63,7 @@
  *  Out:
  *      none
  *
- * Return Value: TRUE if packet duplicate; otherwise FALSE
+ * Return Value: true if packet duplicate; otherwise false
  *
  */
 
@@ -84,7 +84,7 @@ BOOL WCTLbIsDuplicate (PSCache pCache, PS802_11Header pMACHeader)
                 (LOBYTE(pCacheEntry->wFrameCtl) == LOBYTE(pMACHeader->wFrameCtl))
                 ) {
                 /* Duplicate match */
-                return TRUE;
+                return true;
             }
             ADD_ONE_WITH_WRAP_AROUND(uIndex, DUPLICATE_RX_CACHE_LENGTH);
         }
@@ -95,7 +95,7 @@ BOOL WCTLbIsDuplicate (PSCache pCache, PS802_11Header pMACHeader)
     memcpy(&(pCacheEntry->abyAddr2[0]), &(pMACHeader->abyAddr2[0]), ETH_ALEN);
     pCacheEntry->wFrameCtl = pMACHeader->wFrameCtl;
     ADD_ONE_WITH_WRAP_AROUND(pCache->uInPtr, DUPLICATE_RX_CACHE_LENGTH);
-    return FALSE;
+    return false;
 }
 
 /*
@@ -118,7 +118,7 @@ unsigned int WCTLuSearchDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
 	unsigned int ii;
 
 	for (ii = 0; ii < pDevice->cbDFCB; ii++) {
-		if ((pDevice->sRxDFCB[ii].bInUse == TRUE) &&
+		if ((pDevice->sRxDFCB[ii].bInUse == true) &&
 		    (!compare_ether_addr(&(pDevice->sRxDFCB[ii].abyAddr2[0]),
 					  &(pMACHeader->abyAddr2[0])))) {
 			return ii;
@@ -148,10 +148,10 @@ unsigned int WCTLuInsertDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
     if (pDevice->cbFreeDFCB == 0)
         return(pDevice->cbDFCB);
     for (ii = 0; ii < pDevice->cbDFCB; ii++) {
-        if (pDevice->sRxDFCB[ii].bInUse == FALSE) {
+        if (pDevice->sRxDFCB[ii].bInUse == false) {
             pDevice->cbFreeDFCB--;
             pDevice->sRxDFCB[ii].uLifetime = pDevice->dwMaxReceiveLifetime;
-            pDevice->sRxDFCB[ii].bInUse = TRUE;
+            pDevice->sRxDFCB[ii].bInUse = true;
             pDevice->sRxDFCB[ii].wSequence = (pMACHeader->wSeqCtl >> 4);
             pDevice->sRxDFCB[ii].wFragNum = (pMACHeader->wSeqCtl & 0x000F);
 	    memcpy(&(pDevice->sRxDFCB[ii].abyAddr2[0]),
@@ -177,7 +177,7 @@ unsigned int WCTLuInsertDFCB(PSDevice pDevice, PS802_11Header pMACHeader)
  *  Out:
  *      none
  *
- * Return Value: TRUE if it is valid fragment packet and we have resource to defragment; otherwise FALSE
+ * Return Value: true if it is valid fragment packet and we have resource to defragment; otherwise false
  *
  */
 BOOL WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader,
@@ -186,7 +186,7 @@ BOOL WCTLbHandleFragment(PSDevice pDevice, PS802_11Header pMACHeader,
 unsigned int            uHeaderSize;
 
 
-    if (bWEP == TRUE) {
+    if (bWEP == true) {
         uHeaderSize = 28;
         if (bExtIV)
         // ExtIV
@@ -207,7 +207,7 @@ unsigned int            uHeaderSize;
         else {
             pDevice->uCurrentDFCBIdx = WCTLuInsertDFCB(pDevice, pMACHeader);
             if (pDevice->uCurrentDFCBIdx == pDevice->cbDFCB) {
-                return(FALSE);
+                return(false);
             }
         }
         // reserve 8 byte to match MAC RX Buffer
@@ -218,7 +218,7 @@ unsigned int            uHeaderSize;
         pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer += cbFrameLength;
         pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum++;
         //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "First pDevice->uCurrentDFCBIdx= %d\n", pDevice->uCurrentDFCBIdx);
-        return(FALSE);
+        return(false);
     }
     else {
         pDevice->uCurrentDFCBIdx = WCTLuSearchDFCB(pDevice, pMACHeader);
@@ -236,21 +236,21 @@ unsigned int            uHeaderSize;
             else {
                 // seq error or frag # error flush DFCB
                 pDevice->cbFreeDFCB++;
-                pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].bInUse = FALSE;
-                return(FALSE);
+                pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].bInUse = false;
+                return(false);
             }
         }
         else {
-            return(FALSE);
+            return(false);
         }
         if (IS_LAST_FRAGMENT_PKT(pMACHeader)) {
             //enq defragcontrolblock
             pDevice->cbFreeDFCB++;
-            pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].bInUse = FALSE;
+            pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].bInUse = false;
             //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Last pDevice->uCurrentDFCBIdx= %d\n", pDevice->uCurrentDFCBIdx);
-            return(TRUE);
+            return(true);
         }
-        return(FALSE);
+        return(false);
     }
 }
 
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index c84b788..a96bc39 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -361,7 +361,7 @@ void vMgrObjectInit(void *hDeviceContext)
     pMgmt->byCSSPK = KEY_CTL_NONE;
     pMgmt->byCSSGK = KEY_CTL_NONE;
     pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
-    BSSvClearBSSList((void *) pDevice, FALSE);
+    BSSvClearBSSList((void *) pDevice, false);
 
     init_timer(&pMgmt->sTimerSecondCallback);
     pMgmt->sTimerSecondCallback.data = (unsigned long)pDevice;
@@ -377,16 +377,16 @@ void vMgrObjectInit(void *hDeviceContext)
     pDevice->sTimerTxData.data = (unsigned long)pDevice;
     pDevice->sTimerTxData.function = (TimerFunction)BSSvSecondTxData;
     pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
-    pDevice->fTxDataInSleep = FALSE;
-    pDevice->IsTxDataTrigger = FALSE;
+    pDevice->fTxDataInSleep = false;
+    pDevice->IsTxDataTrigger = false;
     pDevice->nTxDataTimeCout = 0;
 
     pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
     pDevice->uCmdDequeueIdx = 0;
     pDevice->uCmdEnqueueIdx = 0;
     pDevice->eCommandState = WLAN_CMD_IDLE;
-    pDevice->bCmdRunning = FALSE;
-    pDevice->bCmdClear = FALSE;
+    pDevice->bCmdRunning = false;
+    pDevice->bCmdClear = false;
 
     return;
 }
@@ -426,7 +426,7 @@ void vMgrAssocBeginSta(void *hDeviceContext,
     // ERP Phy (802.11g) should support short preamble.
     if (pMgmt->eCurrentPHYMode == PHY_TYPE_11G) {
         pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
-        if (pDevice->bShortSlotTime == TRUE)
+        if (pDevice->bShortSlotTime == true)
             pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTSLOTTIME(1);
 
     } else if (pMgmt->eCurrentPHYMode == PHY_TYPE_11B) {
@@ -434,7 +434,7 @@ void vMgrAssocBeginSta(void *hDeviceContext,
             pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
         }
     }
-    if (pMgmt->b11hEnable == TRUE)
+    if (pMgmt->b11hEnable == true)
         pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SPECTRUMMNG(1);
 
     // build an assocreq frame and send it
@@ -502,7 +502,7 @@ void vMgrReAssocBeginSta(void *hDeviceContext,
     // ERP Phy (802.11g) should support short preamble.
     if (pMgmt->eCurrentPHYMode == PHY_TYPE_11G) {
         pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
-      if (pDevice->bShortSlotTime == TRUE)
+      if (pDevice->bShortSlotTime == true)
           pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTSLOTTIME(1);
 
     } else if (pMgmt->eCurrentPHYMode == PHY_TYPE_11B) {
@@ -510,7 +510,7 @@ void vMgrReAssocBeginSta(void *hDeviceContext,
             pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SHORTPREAMBLE(1);
         }
     }
-    if (pMgmt->b11hEnable == TRUE)
+    if (pMgmt->b11hEnable == true)
         pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_SPECTRUMMNG(1);
 
 
@@ -650,7 +650,7 @@ s_vMgrRxAssocRequest(
         pMgmt->sNodeDBTable[uNodeIndex].wCapInfo = cpu_to_le16(*sFrame.pwCapInfo);
         pMgmt->sNodeDBTable[uNodeIndex].wListenInterval = cpu_to_le16(*sFrame.pwListenInterval);
         pMgmt->sNodeDBTable[uNodeIndex].bPSEnable =
-                WLAN_GET_FC_PWRMGT(sFrame.pHdr->sA3.wFrameCtl) ? TRUE : FALSE;
+                WLAN_GET_FC_PWRMGT(sFrame.pHdr->sA3.wFrameCtl) ? true : false;
         // Todo: check sta basic rate, if ap can't support, set status code
         if (pDevice->byBBType == BB_TYPE_11B) {
             uRateLen = WLAN_RATES_MAXLEN_11B;
@@ -672,7 +672,7 @@ s_vMgrRxAssocRequest(
 	RATEvParseMaxRate((void *)pDevice,
                            (PWLAN_IE_SUPP_RATES)abyCurrSuppRates,
                            (PWLAN_IE_SUPP_RATES)abyCurrExtSuppRates,
-                           FALSE, // do not change our basic rate
+                           false, // do not change our basic rate
                            &(pMgmt->sNodeDBTable[uNodeIndex].wMaxBasicRate),
                            &(pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate),
                            &(pMgmt->sNodeDBTable[uNodeIndex].wSuppRate),
@@ -693,15 +693,15 @@ s_vMgrRxAssocRequest(
         wAssocAID = (WORD)uNodeIndex;
         // check if ERP support
         if(pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate > RATE_11M)
-           pMgmt->sNodeDBTable[uNodeIndex].bERPExist = TRUE;
+           pMgmt->sNodeDBTable[uNodeIndex].bERPExist = true;
 
         if (pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate <= RATE_11M) {
             // B only STA join
-            pDevice->bProtectMode = TRUE;
-            pDevice->bNonERPPresent = TRUE;
+            pDevice->bProtectMode = true;
+            pDevice->bNonERPPresent = true;
         }
-        if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble == FALSE) {
-            pDevice->bBarkerPreambleMd = TRUE;
+        if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble == false) {
+            pDevice->bBarkerPreambleMd = true;
         }
 
         DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Associate AID= %d \n", wAssocAID);
@@ -801,7 +801,7 @@ s_vMgrRxReAssocRequest(
         pMgmt->sNodeDBTable[uNodeIndex].wCapInfo = cpu_to_le16(*sFrame.pwCapInfo);
         pMgmt->sNodeDBTable[uNodeIndex].wListenInterval = cpu_to_le16(*sFrame.pwListenInterval);
         pMgmt->sNodeDBTable[uNodeIndex].bPSEnable =
-                WLAN_GET_FC_PWRMGT(sFrame.pHdr->sA3.wFrameCtl) ? TRUE : FALSE;
+                WLAN_GET_FC_PWRMGT(sFrame.pHdr->sA3.wFrameCtl) ? true : false;
         // Todo: check sta basic rate, if ap can't support, set status code
 
         if (pDevice->byBBType == BB_TYPE_11B) {
@@ -825,7 +825,7 @@ s_vMgrRxReAssocRequest(
 	RATEvParseMaxRate((void *)pDevice,
                           (PWLAN_IE_SUPP_RATES)abyCurrSuppRates,
                           (PWLAN_IE_SUPP_RATES)abyCurrExtSuppRates,
-                           FALSE, // do not change our basic rate
+                           false, // do not change our basic rate
                            &(pMgmt->sNodeDBTable[uNodeIndex].wMaxBasicRate),
                            &(pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate),
                            &(pMgmt->sNodeDBTable[uNodeIndex].wSuppRate),
@@ -847,15 +847,15 @@ s_vMgrRxReAssocRequest(
 
         // if suppurt ERP
         if(pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate > RATE_11M)
-           pMgmt->sNodeDBTable[uNodeIndex].bERPExist = TRUE;
+           pMgmt->sNodeDBTable[uNodeIndex].bERPExist = true;
 
         if (pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate <= RATE_11M) {
             // B only STA join
-            pDevice->bProtectMode = TRUE;
-            pDevice->bNonERPPresent = TRUE;
+            pDevice->bProtectMode = true;
+            pDevice->bNonERPPresent = true;
         }
-        if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble == FALSE) {
-            pDevice->bBarkerPreambleMd = TRUE;
+        if (pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble == false) {
+            pDevice->bBarkerPreambleMd = true;
         }
 
         DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Rx ReAssociate AID= %d \n", wAssocAID);
@@ -971,7 +971,7 @@ s_vMgrRxAssocResponse(
 			     sFrame.pExtSuppRates);
             pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
             DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Link with AP(SSID): %s\n", pItemSSID->abySSID);
-            pDevice->bLinkPass = TRUE;
+            pDevice->bLinkPass = true;
             ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
             if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
 	       if(skb_tailroom(pDevice->skb) <(sizeof(viawget_wpa_header)+pMgmt->sAssocInfo.AssocInfo.ResponseIELength+
@@ -999,7 +999,7 @@ s_vMgrRxAssocResponse(
             }
 //2008-0409-07, <Add> by Einsn Liu
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-	//if(pDevice->bWPASuppWextEnabled == TRUE)
+	//if(pDevice->bWPASuppWextEnabled == true)
 	   {
 		BYTE buf[512];
 		size_t len;
@@ -1056,11 +1056,11 @@ s_vMgrRxAssocResponse(
 #if 1
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 //need clear flags related to Networkmanager
-              pDevice->bwextstep0 = FALSE;
-              pDevice->bwextstep1 = FALSE;
-              pDevice->bwextstep2 = FALSE;
-              pDevice->bwextstep3 = FALSE;
-              pDevice->bWPASuppWextEnabled = FALSE;
+              pDevice->bwextstep0 = false;
+              pDevice->bwextstep1 = false;
+              pDevice->bwextstep2 = false;
+              pDevice->bwextstep3 = false;
+              pDevice->bWPASuppWextEnabled = false;
 #endif
 #endif
 
@@ -1316,7 +1316,7 @@ s_vMgrRxAuthenSequence_1(
         sFrame.pChallenge->len = WLAN_CHALLENGE_LEN;
         memset(pMgmt->abyChallenge, 0, WLAN_CHALLENGE_LEN);
         // get group key
-        if(KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, GROUP_KEY, &pTransmitKey) == TRUE) {
+        if(KeybGetTransmitKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, GROUP_KEY, &pTransmitKey) == true) {
             rc4_init(&pDevice->SBox, pDevice->abyPRNG, pTransmitKey->uKeyLength+3);
             rc4_encrypt(&pDevice->SBox, pMgmt->abyChallenge, pMgmt->abyChallenge, WLAN_CHALLENGE_LEN);
         }
@@ -1609,7 +1609,7 @@ s_vMgrRxDisassociation(
         vMgrDecodeDisassociation(&sFrame);
         DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "AP disassociated me, reason=%d.\n", cpu_to_le16(*(sFrame.pwReason)));
 
-          pDevice->fWPA_Authened = FALSE;
+          pDevice->fWPA_Authened = false;
 	if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
              wpahdr = (viawget_wpa_header *)pDevice->skb->data;
              wpahdr->type = VIAWGET_DISASSOC_MSG;
@@ -1628,8 +1628,8 @@ s_vMgrRxDisassociation(
         //TODO: do something let upper layer know or
         //try to send associate packet again because of inactivity timeout
         if (pMgmt->eCurrState == WMAC_STATE_ASSOC) {
-                pDevice->bLinkPass = FALSE;
-                pMgmt->sNodeDBTable[0].bActive = FALSE;
+                pDevice->bLinkPass = false;
+                pMgmt->sNodeDBTable[0].bActive = false;
 	       pDevice->byReAssocCount = 0;
                 pMgmt->eCurrState = WMAC_STATE_AUTH;  // jump back to the auth state!
                 pDevice->eCommandState = WLAN_ASSOCIATE_WAIT;
@@ -1641,7 +1641,7 @@ s_vMgrRxDisassociation(
         };
 
    #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-  // if(pDevice->bWPASuppWextEnabled == TRUE)
+  // if(pDevice->bWPASuppWextEnabled == true)
       {
 	union iwreq_data  wrqu;
 	memset(&wrqu, 0, sizeof (wrqu));
@@ -1699,17 +1699,17 @@ s_vMgrRxDeauthentication(
             sFrame.len = pRxPacket->cbMPDULen;
             sFrame.pBuf = (PBYTE)pRxPacket->p80211Header;
             vMgrDecodeDeauthen(&sFrame);
-	   pDevice->fWPA_Authened = FALSE;
+	   pDevice->fWPA_Authened = false;
             DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO  "AP deauthed me, reason=%d.\n", cpu_to_le16((*(sFrame.pwReason))));
             // TODO: update BSS list for specific BSSID if pre-authentication case
 	    if (!compare_ether_addr(sFrame.pHdr->sA3.abyAddr3,
 				    pMgmt->abyCurrBSSID)) {
                 if (pMgmt->eCurrState >= WMAC_STATE_AUTHPENDING) {
-                    pMgmt->sNodeDBTable[0].bActive = FALSE;
+                    pMgmt->sNodeDBTable[0].bActive = false;
                     pMgmt->eCurrMode = WMAC_MODE_STANDBY;
                     pMgmt->eCurrState = WMAC_STATE_IDLE;
                     netif_stop_queue(pDevice->dev);
-                    pDevice->bLinkPass = FALSE;
+                    pDevice->bLinkPass = false;
                     ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
                 }
             };
@@ -1730,7 +1730,7 @@ s_vMgrRxDeauthentication(
            };
 
    #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-  // if(pDevice->bWPASuppWextEnabled == TRUE)
+  // if(pDevice->bWPASuppWextEnabled == true)
       {
 	union iwreq_data  wrqu;
 	memset(&wrqu, 0, sizeof (wrqu));
@@ -1765,17 +1765,17 @@ ChannelExceedZoneType(
      BYTE byCurrChannel
     )
 {
-  BOOL exceed=FALSE;
+  BOOL exceed=false;
 
   switch(pDevice->byZoneType) {
   	case 0x00:                  //USA:1~11
                      if((byCurrChannel<1) ||(byCurrChannel>11))
-	                exceed = TRUE;
+	                exceed = true;
 	         break;
 	case 0x01:                  //Japan:1~13
 	case 0x02:                  //Europe:1~13
                      if((byCurrChannel<1) ||(byCurrChannel>13))
-	                exceed = TRUE;
+	                exceed = true;
 	         break;
 	default:                    //reserve for other zonetype
 		break;
@@ -1808,13 +1808,13 @@ s_vMgrRxBeacon(
     PKnownBSS           pBSSList;
     WLAN_FR_BEACON      sFrame;
     QWORD               qwTSFOffset;
-    BOOL                bIsBSSIDEqual = FALSE;
-    BOOL                bIsSSIDEqual = FALSE;
-    BOOL                bTSFLargeDiff = FALSE;
-    BOOL                bTSFOffsetPostive = FALSE;
-    BOOL                bUpdateTSF = FALSE;
-    BOOL                bIsAPBeacon = FALSE;
-    BOOL                bIsChannelEqual = FALSE;
+    BOOL                bIsBSSIDEqual = false;
+    BOOL                bIsSSIDEqual = false;
+    BOOL                bTSFLargeDiff = false;
+    BOOL                bTSFOffsetPostive = false;
+    BOOL                bUpdateTSF = false;
+    BOOL                bIsAPBeacon = false;
+    BOOL                bIsChannelEqual = false;
     unsigned int                uLocateByteIndex;
     BYTE                byTIMBitOn = 0;
     WORD                wAIDNumber = 0;
@@ -1826,7 +1826,7 @@ s_vMgrRxBeacon(
     BYTE                byCurrChannel = pRxPacket->byRxChannel;
     ERPObject           sERP;
     unsigned int                uRateLen = WLAN_RATES_MAXLEN;
-    BOOL                bChannelHit = FALSE;
+    BOOL                bChannelHit = false;
     BYTE                byOldPreambleType;
 
 
@@ -1854,32 +1854,32 @@ s_vMgrRxBeacon(
     {
         if (sFrame.pDSParms != NULL) {
             if (byCurrChannel == RFaby11aChannelIndex[sFrame.pDSParms->byCurrChannel-1])
-                bChannelHit = TRUE;
+                bChannelHit = true;
             byCurrChannel = RFaby11aChannelIndex[sFrame.pDSParms->byCurrChannel-1];
         } else {
-            bChannelHit = TRUE;
+            bChannelHit = true;
         }
 
     } else {
         if (sFrame.pDSParms != NULL) {
             if (byCurrChannel == sFrame.pDSParms->byCurrChannel)
-                bChannelHit = TRUE;
+                bChannelHit = true;
             byCurrChannel = sFrame.pDSParms->byCurrChannel;
         } else {
-            bChannelHit = TRUE;
+            bChannelHit = true;
         }
     }
 
 //2008-0730-01<Add>by MikeLiu
-if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
+if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
       return;
 
     if (sFrame.pERP != NULL) {
         sERP.byERP = sFrame.pERP->byContext;
-        sERP.bERPExist = TRUE;
+        sERP.bERPExist = true;
 
     } else {
-        sERP.bERPExist = FALSE;
+        sERP.bERPExist = false;
         sERP.byERP = 0;
     }
 
@@ -1934,7 +1934,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
     }
 
     if(byCurrChannel == (BYTE)pMgmt->uCurrChannel)
-       bIsChannelEqual = TRUE;
+       bIsChannelEqual = true;
 
     if (bIsChannelEqual && (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)) {
 
@@ -1963,7 +1963,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                pMgmt->abyCurrBSSID,
                WLAN_BSSID_LEN) == 0) {
 
-        bIsBSSIDEqual = TRUE;
+        bIsBSSIDEqual = true;
         pDevice->uCurrRSSI = pRxPacket->uRSSI;
         pDevice->byCurrSQ = pRxPacket->bySQ;
         if (pMgmt->sNodeDBTable[0].uInActiveCount != 0) {
@@ -1977,22 +1977,22 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                    ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->abySSID,
                    sFrame.pSSID->len
                    ) == 0) {
-            bIsSSIDEqual = TRUE;
+            bIsSSIDEqual = true;
         };
     }
 
-    if ((WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)== TRUE) &&
-        (bIsBSSIDEqual == TRUE) &&
-        (bIsSSIDEqual == TRUE) &&
+    if ((WLAN_GET_CAP_INFO_ESS(*sFrame.pwCapInfo)== true) &&
+        (bIsBSSIDEqual == true) &&
+        (bIsSSIDEqual == true) &&
         (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
         (pMgmt->eCurrState == WMAC_STATE_ASSOC)) {
         // add state check to prevent reconnect fail since we'll receive Beacon
 
-        bIsAPBeacon = TRUE;
+        bIsAPBeacon = true;
         if (pBSSList != NULL) {
 
                 // Sync ERP field
-                if ((pBSSList->sERP.bERPExist == TRUE) && (pDevice->byBBType == BB_TYPE_11G)) {
+                if ((pBSSList->sERP.bERPExist == true) && (pDevice->byBBType == BB_TYPE_11G)) {
                     if ((pBSSList->sERP.byERP & WLAN_EID_ERP_USE_PROTECTION) != pDevice->bProtectMode) {//0000 0010
                         pDevice->bProtectMode = (pBSSList->sERP.byERP & WLAN_EID_ERP_USE_PROTECTION);
                         if (pDevice->bProtectMode) {
@@ -2023,10 +2023,10 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                     //DBG_PRN_WLAN05(("Set Short Slot Time: %d\n", pDevice->bShortSlotTime));
                     //Kyle check if it is OK to set G.
                     if (pDevice->byBBType == BB_TYPE_11A) {
-                        bShortSlotTime = TRUE;
+                        bShortSlotTime = true;
                     }
                     else if (pDevice->byBBType == BB_TYPE_11B) {
-                        bShortSlotTime = FALSE;
+                        bShortSlotTime = false;
                     }
                     if (bShortSlotTime != pDevice->bShortSlotTime) {
                         pDevice->bShortSlotTime = bShortSlotTime;
@@ -2062,7 +2062,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
 	    RATEvParseMaxRate((void *)pDevice,
                                (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
                                (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates,
-                               TRUE,
+                               true,
                                &(pMgmt->sNodeDBTable[0].wMaxBasicRate),
                                &(pMgmt->sNodeDBTable[0].wMaxSuppRate),
                                &(pMgmt->sNodeDBTable[0].wSuppRate),
@@ -2089,17 +2089,17 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
     // check if beacon TSF larger or small than our local TSF
     if (HIDWORD(qwTimestamp) == HIDWORD(qwLocalTSF)) {
         if (LODWORD(qwTimestamp) >= LODWORD(qwLocalTSF)) {
-            bTSFOffsetPostive = TRUE;
+            bTSFOffsetPostive = true;
         }
         else {
-            bTSFOffsetPostive = FALSE;
+            bTSFOffsetPostive = false;
         }
     }
     else if (HIDWORD(qwTimestamp) > HIDWORD(qwLocalTSF)) {
-        bTSFOffsetPostive = TRUE;
+        bTSFOffsetPostive = true;
     }
     else if (HIDWORD(qwTimestamp) < HIDWORD(qwLocalTSF)) {
-        bTSFOffsetPostive = FALSE;
+        bTSFOffsetPostive = false;
     };
 
     if (bTSFOffsetPostive) {
@@ -2111,21 +2111,21 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
 
     if (HIDWORD(qwTSFOffset) != 0 ||
         (LODWORD(qwTSFOffset) > TRIVIAL_SYNC_DIFFERENCE )) {
-         bTSFLargeDiff = TRUE;
+         bTSFLargeDiff = true;
     }
 
 
     // if infra mode
-    if (bIsAPBeacon == TRUE) {
+    if (bIsAPBeacon == true) {
 
         // Infra mode: Local TSF always follow AP's TSF if Difference huge.
         if (bTSFLargeDiff)
-            bUpdateTSF = TRUE;
+            bUpdateTSF = true;
 
-	if ((pDevice->bEnablePSMode == TRUE) && (sFrame.pTIM)) {
+	if ((pDevice->bEnablePSMode == true) && (sFrame.pTIM)) {
 
 		/* deal with DTIM, analysis TIM */
-            pMgmt->bMulticastTIM = WLAN_MGMT_IS_MULTICAST_TIM(sFrame.pTIM->byBitMapCtl) ? TRUE : FALSE ;
+            pMgmt->bMulticastTIM = WLAN_MGMT_IS_MULTICAST_TIM(sFrame.pTIM->byBitMapCtl) ? true : false ;
             pMgmt->byDTIMCount = sFrame.pTIM->byDTIMCount;
             pMgmt->byDTIMPeriod = sFrame.pTIM->byDTIMPeriod;
             wAIDNumber = pMgmt->wCurrAID & ~(BIT14|BIT15);
@@ -2140,19 +2140,19 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
                 // len = byDTIMCount + byDTIMPeriod + byDTIMPeriod + byVirtBitMap[0~250]
                 if (sFrame.pTIM->len >= (uLocateByteIndex + 4)) {
                     byTIMBitOn  = (0x01) << ((wAIDNumber) % 8);
-                    pMgmt->bInTIM = sFrame.pTIM->byVirtBitMap[uLocateByteIndex] & byTIMBitOn ? TRUE : FALSE;
+                    pMgmt->bInTIM = sFrame.pTIM->byVirtBitMap[uLocateByteIndex] & byTIMBitOn ? true : false;
                 }
                 else {
-                    pMgmt->bInTIM = FALSE;
+                    pMgmt->bInTIM = false;
                 };
             }
             else {
-                pMgmt->bInTIM = FALSE;
+                pMgmt->bInTIM = false;
             };
 
             if (pMgmt->bInTIM ||
                 (pMgmt->bMulticastTIM && (pMgmt->byDTIMCount == 0))) {
-                pMgmt->bInTIMWake = TRUE;
+                pMgmt->bInTIMWake = true;
                 // send out ps-poll packet
 //                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN:In TIM\n");
                 if (pMgmt->bInTIM) {
@@ -2162,14 +2162,14 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
 
             }
             else {
-                pMgmt->bInTIMWake = FALSE;
+                pMgmt->bInTIMWake = false;
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Not In TIM..\n");
-                if (pDevice->bPWBitOn == FALSE) {
+                if (pDevice->bPWBitOn == false) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Send Null Packet\n");
                     if (PSbSendNullPacket(pDevice))
-                        pDevice->bPWBitOn = TRUE;
+                        pDevice->bPWBitOn = true;
                 }
-                if(PSbConsiderPowerDown(pDevice, FALSE, FALSE)) {
+                if(PSbConsiderPowerDown(pDevice, false, false)) {
                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BCN: Power down now...\n");
                 };
             }
@@ -2187,7 +2187,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
             // adhoc mode:TSF updated only when beacon larger then local TSF
             if (bTSFLargeDiff && bTSFOffsetPostive &&
                 (pMgmt->eCurrState == WMAC_STATE_JOINTED))
-                bUpdateTSF = TRUE;
+                bUpdateTSF = true;
 
             // During dpc, already in spinlocked.
             if (BSSbIsSTAInNodeDB(pDevice, sFrame.pHdr->sA3.abyAddr2, &uNodeIndex)) {
@@ -2200,7 +2200,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
 		RATEvParseMaxRate((void *)pDevice,
                                    (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
                                    NULL,
-                                   TRUE,
+                                   true,
                                    &(pMgmt->sNodeDBTable[uNodeIndex].wMaxBasicRate),
                                    &(pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate),
                                    &(pMgmt->sNodeDBTable[uNodeIndex].wSuppRate),
@@ -2221,7 +2221,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
 		RATEvParseMaxRate((void *)pDevice,
                                    (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
                                    NULL,
-                                   TRUE,
+                                   true,
                                    &(pMgmt->sNodeDBTable[uNodeIndex].wMaxBasicRate),
                                    &(pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate),
                                    &(pMgmt->sNodeDBTable[uNodeIndex].wSuppRate),
@@ -2235,7 +2235,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
 /*
                 pMgmt->sNodeDBTable[uNodeIndex].bShortSlotTime = WLAN_GET_CAP_INFO_SHORTSLOTTIME(*sFrame.pwCapInfo);
                 if(pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate > RATE_11M)
-                       pMgmt->sNodeDBTable[uNodeIndex].bERPExist = TRUE;
+                       pMgmt->sNodeDBTable[uNodeIndex].bERPExist = true;
 */
             }
 
@@ -2243,12 +2243,12 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
             if (pMgmt->eCurrState == WMAC_STATE_STARTED) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Current IBSS State: [Started]........to: [Jointed] \n");
                 pMgmt->eCurrState = WMAC_STATE_JOINTED;
-                pDevice->bLinkPass = TRUE;
+                pDevice->bLinkPass = true;
                 ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
                 if (netif_queue_stopped(pDevice->dev)){
                     netif_wake_queue(pDevice->dev);
                 }
-                pMgmt->sNodeDBTable[0].bActive = TRUE;
+                pMgmt->sNodeDBTable[0].bActive = true;
                 pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 
             };
@@ -2434,16 +2434,16 @@ void vMgrCreateOwnIBSS(void *hDeviceContext,
 
     RATEvParseMaxRate((void *)pDevice,
 		      (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
-                      (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates, TRUE,
+                      (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrExtSuppRates, true,
                       &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
                       &byTopCCKBasicRate, &byTopOFDMBasicRate);
 
 
 
     if (pDevice->byBBType == BB_TYPE_11A) {
-        pDevice->bShortSlotTime = TRUE;
+        pDevice->bShortSlotTime = true;
     } else {
-        pDevice->bShortSlotTime = FALSE;
+        pDevice->bShortSlotTime = false;
     }
     BBvSetShortSlotTime(pDevice);
     // vUpdateIFS() use pDevice->bShortSlotTime as parameter so it must be called
@@ -2529,7 +2529,7 @@ void vMgrCreateOwnIBSS(void *hDeviceContext,
 
     MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
     pDevice->byRxMode |= RCR_BSSID;
-    pMgmt->bCurrBSSIDFilterOn = TRUE;
+    pMgmt->bCurrBSSIDFilterOn = true;
 
     // Set Capability Info
     pMgmt->wCurrCapInfo = 0;
@@ -2609,11 +2609,11 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
     WORD            wSuppRate;
     BYTE            byTopCCKBasicRate = RATE_1M;
     BYTE            byTopOFDMBasicRate = RATE_1M;
-    BOOL            bShortSlotTime = FALSE;
+    BOOL            bShortSlotTime = false;
 
 
     for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-        if (pMgmt->sBSSList[ii].bActive == TRUE)
+        if (pMgmt->sBSSList[ii].bActive == true)
             break;
     }
 
@@ -2646,14 +2646,14 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
         if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA)||(pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK)) {
 /*
             if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) {
-                if (WPA_SearchRSN(0, WPA_TKIP, pCurr) == FALSE) {
+                if (WPA_SearchRSN(0, WPA_TKIP, pCurr) == false) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"No match RSN info. ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
                     // encryption mode error
                     pMgmt->eCurrState = WMAC_STATE_IDLE;
                     return;
                 }
             } else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
-                if (WPA_SearchRSN(0, WPA_AESCCMP, pCurr) == FALSE) {
+                if (WPA_SearchRSN(0, WPA_AESCCMP, pCurr) == false) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"No match RSN info. ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
                     // encryption mode error
                     pMgmt->eCurrState = WMAC_STATE_IDLE;
@@ -2664,7 +2664,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
         }
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-	//if(pDevice->bWPASuppWextEnabled == TRUE)
+	//if(pDevice->bWPASuppWextEnabled == true)
             Encyption_Rebuild(pDevice, pCurr);
 #endif
 
@@ -2721,7 +2721,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
                 }
             }
 
-	    RATEvParseMaxRate((void *)pDevice, pItemRates, pItemExtRates, TRUE,
+	    RATEvParseMaxRate((void *)pDevice, pItemRates, pItemExtRates, true,
                               &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
                               &byTopCCKBasicRate, &byTopOFDMBasicRate);
             vUpdateIFS(pDevice);
@@ -2746,7 +2746,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
 						    pMgmt->abyCurrBSSID,
 						    &pCurr->sRSNCapObj);
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"bAdd_PMKID_Candidate: 1(%d)\n", bResult);
-                if (bResult == FALSE) {
+                if (bResult == false) {
 			vFlush_PMKID_Candidate((void *) pDevice);
 			DBG_PRT(MSG_LEVEL_DEBUG,
 				KERN_INFO "vFlush_PMKID_Candidate: 4\n");
@@ -2796,10 +2796,10 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
             //DBG_PRN_WLAN05(("wCapInfo: %X\n", pCurr->wCapInfo));
             if (WLAN_GET_CAP_INFO_SHORTSLOTTIME(pCurr->wCapInfo) != pDevice->bShortSlotTime) {
                 if (pDevice->byBBType == BB_TYPE_11A) {
-                    bShortSlotTime = TRUE;
+                    bShortSlotTime = true;
                 }
                 else if (pDevice->byBBType == BB_TYPE_11B) {
-                    bShortSlotTime = FALSE;
+                    bShortSlotTime = false;
                 }
                 else {
                     bShortSlotTime = WLAN_GET_CAP_INFO_SHORTSLOTTIME(pCurr->wCapInfo);
@@ -2826,7 +2826,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
 
             if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) {
 /*
-                if (WPA_SearchRSN(0, WPA_TKIP, pCurr) == FALSE) {
+                if (WPA_SearchRSN(0, WPA_TKIP, pCurr) == false) {
                     // encryption mode error
                     pMgmt->eCurrState = WMAC_STATE_IDLE;
                     return;
@@ -2834,7 +2834,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
 */
             } else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
 /*
-                if (WPA_SearchRSN(0, WPA_AESCCMP, pCurr) == FALSE) {
+                if (WPA_SearchRSN(0, WPA_AESCCMP, pCurr) == false) {
                     // encryption mode error
                     pMgmt->eCurrState = WMAC_STATE_IDLE;
                     return;
@@ -2867,7 +2867,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
             // set basic rate
 	    RATEvParseMaxRate((void *)pDevice,
 			      (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
-                              NULL, TRUE, &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
+                              NULL, true, &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
                               &byTopCCKBasicRate, &byTopOFDMBasicRate);
             vUpdateIFS(pDevice);
             pMgmt->wCurrCapInfo = pCurr->wCapInfo;
@@ -2880,7 +2880,7 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
             pMgmt->eCurrState = WMAC_STATE_STARTED;
             // Adopt BSS state in Adapter Device Object
             pDevice->eOPMode = OP_MODE_ADHOC;
-            pDevice->bLinkPass = TRUE;
+            pDevice->bLinkPass = true;
             ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
             memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 
@@ -2949,7 +2949,7 @@ s_vMgrSynchBSS (
     if (s_bCipherMatch(pCurr,
                        pDevice->eEncryptionStatus,
                        &(pMgmt->byCSSPK),
-                       &(pMgmt->byCSSGK)) == FALSE) {
+                       &(pMgmt->byCSSGK)) == false) {
         DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "s_bCipherMatch Fail .......\n");
         return;
     }
@@ -2962,12 +2962,12 @@ s_vMgrSynchBSS (
     }
 
     // Init the BSS informations
-    pDevice->bCCK = TRUE;
-    pDevice->bProtectMode = FALSE;
+    pDevice->bCCK = true;
+    pDevice->bProtectMode = false;
     MACvDisableProtectMD(pDevice);
-    pDevice->bBarkerPreambleMd = FALSE;
+    pDevice->bBarkerPreambleMd = false;
     MACvDisableBarkerPreambleMd(pDevice);
-    pDevice->bNonERPPresent = FALSE;
+    pDevice->bNonERPPresent = false;
     pDevice->byPreambleType = 0;
     pDevice->wBasicRate = 0;
     // Set Basic Rate
@@ -3002,7 +3002,7 @@ s_vMgrSynchBSS (
             (pDevice->eConfigPHYMode == PHY_TYPE_AUTO)) {
             pDevice->byBBType = BB_TYPE_11A;
             pMgmt->eCurrentPHYMode = PHY_TYPE_11A;
-            pDevice->bShortSlotTime = TRUE;
+            pDevice->bShortSlotTime = true;
             BBvSetShortSlotTime(pDevice);
             CARDvSetBSSMode(pDevice);
         } else {
@@ -3014,7 +3014,7 @@ s_vMgrSynchBSS (
             (pDevice->eConfigPHYMode == PHY_TYPE_AUTO)) {
             pDevice->byBBType = BB_TYPE_11B;
             pMgmt->eCurrentPHYMode = PHY_TYPE_11B;
-            pDevice->bShortSlotTime = FALSE;
+            pDevice->bShortSlotTime = false;
             BBvSetShortSlotTime(pDevice);
             CARDvSetBSSMode(pDevice);
         } else {
@@ -3025,12 +3025,12 @@ s_vMgrSynchBSS (
             (pDevice->eConfigPHYMode == PHY_TYPE_AUTO)) {
             pDevice->byBBType = BB_TYPE_11G;
             pMgmt->eCurrentPHYMode = PHY_TYPE_11G;
-            pDevice->bShortSlotTime = TRUE;
+            pDevice->bShortSlotTime = true;
             BBvSetShortSlotTime(pDevice);
             CARDvSetBSSMode(pDevice);
         } else if (pDevice->eConfigPHYMode == PHY_TYPE_11B) {
             pDevice->byBBType = BB_TYPE_11B;
-            pDevice->bShortSlotTime = FALSE;
+            pDevice->bShortSlotTime = false;
             BBvSetShortSlotTime(pDevice);
             CARDvSetBSSMode(pDevice);
         } else {
@@ -3042,7 +3042,7 @@ s_vMgrSynchBSS (
         MACvRegBitsOff(pDevice, MAC_REG_HOSTCR, HOSTCR_ADHOC);
         MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
         pDevice->byRxMode |= RCR_BSSID;
-        pMgmt->bCurrBSSIDFilterOn = TRUE;
+        pMgmt->bCurrBSSIDFilterOn = true;
     }
 
     // set channel and clear NAV
@@ -3066,7 +3066,7 @@ s_vMgrSynchBSS (
         MACvRegBitsOn(pDevice, MAC_REG_HOSTCR, HOSTCR_ADHOC);
         MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
         pDevice->byRxMode |= RCR_BSSID;
-        pMgmt->bCurrBSSIDFilterOn = TRUE;
+        pMgmt->bCurrBSSIDFilterOn = true;
     };
 
     if (pDevice->byBBType == BB_TYPE_11A) {
@@ -3100,7 +3100,7 @@ s_vMgrSynchBSS (
   //   if( uSameBssidNum>=2) {	 //we only check AP in hidden sssid  mode
         if ((pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK) ||           //networkmanager 0.7.0 does not give the pairwise-key selsection,
              (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {         // so we need re-selsect it according to real pairwise-key info.
-               if(pCurr->bWPAValid == TRUE)  {   //WPA-PSK
+               if(pCurr->bWPAValid == true)  {   //WPA-PSK
                           pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
 		    if(pCurr->abyPKType[0] == WPA_TKIP) {
      		        pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;    //TKIP
@@ -3111,7 +3111,7 @@ s_vMgrSynchBSS (
                           PRINT_K("Encyption_Rebuild--->ssid reset config to [WPAPSK-AES]\n");
      		     }
                	}
-               else if(pCurr->bWPA2Valid == TRUE) {  //WPA2-PSK
+               else if(pCurr->bWPA2Valid == true) {  //WPA2-PSK
                          pMgmt->eAuthenMode = WMAC_AUTH_WPA2PSK;
 		       if(pCurr->abyCSSPK[0] == WLAN_11i_CSS_TKIP) {
       		           pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;     //TKIP
@@ -3149,8 +3149,8 @@ s_vMgrFormatTIM(
     BYTE        byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
     BYTE        byMap;
     unsigned int        ii, jj;
-    BOOL        bStartFound = FALSE;
-    BOOL        bMulticast = FALSE;
+    BOOL        bStartFound = false;
+    BOOL        bMulticast = false;
     WORD        wStartIndex = 0;
     WORD        wEndIndex = 0;
 
@@ -3162,13 +3162,13 @@ s_vMgrFormatTIM(
             // Mask out the broadcast bit which is indicated separately.
             bMulticast = (byMap & byMask[0]) != 0;
             if(bMulticast) {
-               pMgmt->sNodeDBTable[0].bRxPSPoll = TRUE;
+               pMgmt->sNodeDBTable[0].bRxPSPoll = true;
             }
             byMap = 0;
         }
         if (byMap) {
             if (!bStartFound) {
-                bStartFound = TRUE;
+                bStartFound = true;
                 wStartIndex = (WORD)ii;
             }
             wEndIndex = (WORD)ii;
@@ -3338,11 +3338,11 @@ s_MgrMakeBeacon(
         sFrame.pERP->byElementID = WLAN_EID_ERP;
         sFrame.pERP->len = 1;
         sFrame.pERP->byContext = 0;
-        if (pDevice->bProtectMode == TRUE)
+        if (pDevice->bProtectMode == true)
             sFrame.pERP->byContext |= WLAN_EID_ERP_USE_PROTECTION;
-        if (pDevice->bNonERPPresent == TRUE)
+        if (pDevice->bNonERPPresent == true)
             sFrame.pERP->byContext |= WLAN_EID_ERP_NONERP_PRESENT;
-        if (pDevice->bBarkerPreambleMd == TRUE)
+        if (pDevice->bBarkerPreambleMd == true)
             sFrame.pERP->byContext |= WLAN_EID_ERP_BARKER_MODE;
     }
     if (((PWLAN_IE_SUPP_RATES)pCurrExtSuppRates)->len != 0) {
@@ -3354,7 +3354,7 @@ s_MgrMakeBeacon(
              );
     }
     // hostapd wpa/wpa2 IE
-    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnableHostapd == TRUE)) {
+    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnableHostapd == true)) {
          if (pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
              if (pMgmt->wWPAIELen != 0) {
                  sFrame.pRSN = (PWLAN_IE_RSN)(sFrame.pBuf + sFrame.len);
@@ -3472,11 +3472,11 @@ s_MgrMakeProbeResponse(
         sFrame.pERP->byElementID = WLAN_EID_ERP;
         sFrame.pERP->len = 1;
         sFrame.pERP->byContext = 0;
-        if (pDevice->bProtectMode == TRUE)
+        if (pDevice->bProtectMode == true)
             sFrame.pERP->byContext |= WLAN_EID_ERP_USE_PROTECTION;
-        if (pDevice->bNonERPPresent == TRUE)
+        if (pDevice->bNonERPPresent == true)
             sFrame.pERP->byContext |= WLAN_EID_ERP_NONERP_PRESENT;
-        if (pDevice->bBarkerPreambleMd == TRUE)
+        if (pDevice->bBarkerPreambleMd == true)
             sFrame.pERP->byContext |= WLAN_EID_ERP_BARKER_MODE;
     }
 
@@ -3490,7 +3490,7 @@ s_MgrMakeProbeResponse(
     }
 
     // hostapd wpa/wpa2 IE
-    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnableHostapd == TRUE)) {
+    if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnableHostapd == true)) {
          if (pMgmt->eAuthenMode == WMAC_AUTH_WPANONE) {
              if (pMgmt->wWPAIELen != 0) {
                  sFrame.pRSN = (PWLAN_IE_RSN)(sFrame.pBuf + sFrame.len);
@@ -3720,7 +3720,7 @@ s_MgrMakeAssocRequest(
         sFrame.pRSN->len +=6;
 
         // RSN Capabilites
-        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == TRUE) {
+        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == true) {
             memcpy(&sFrame.pRSN->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
         } else {
             sFrame.pRSN->abyRSN[16] = 0;
@@ -3728,7 +3728,7 @@ s_MgrMakeAssocRequest(
         }
         sFrame.pRSN->len +=2;
 
-        if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && (pDevice->bRoaming == TRUE) && (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)) {
+        if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && (pDevice->bRoaming == true) && (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)) {
             // RSN PMKID
             pbyRSN = &sFrame.pRSN->abyRSN[18];
             pwPMKID = (PWORD)pbyRSN; // Point to PMKID count
@@ -3980,7 +3980,7 @@ s_MgrMakeReAssocRequest(
         sFrame.pRSN->len +=6;
 
         // RSN Capabilites
-        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == TRUE) {
+        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == true) {
             memcpy(&sFrame.pRSN->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
         } else {
             sFrame.pRSN->abyRSN[16] = 0;
@@ -3988,7 +3988,7 @@ s_MgrMakeReAssocRequest(
         }
         sFrame.pRSN->len +=2;
 
-        if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && (pDevice->bRoaming == TRUE) && (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)) {
+        if ((pDevice->gsPMKID.BSSIDInfoCount > 0) && (pDevice->bRoaming == true) && (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)) {
             // RSN PMKID
             pbyRSN = &sFrame.pRSN->abyRSN[18];
             pwPMKID = (PWORD)pbyRSN; // Point to PMKID count
@@ -4196,7 +4196,7 @@ s_vMgrRxProbeResponse(
     WLAN_FR_PROBERESP   sFrame;
     BYTE                byCurrChannel = pRxPacket->byRxChannel;
     ERPObject           sERP;
-    BOOL                bChannelHit = TRUE;
+    BOOL                bChannelHit = true;
 
 
     memset(&sFrame, 0, sizeof(WLAN_FR_PROBERESP));
@@ -4227,32 +4227,32 @@ s_vMgrRxProbeResponse(
 	if (sFrame.pDSParms) {
 		if (byCurrChannel ==
 		    RFaby11aChannelIndex[sFrame.pDSParms->byCurrChannel-1])
-			bChannelHit = TRUE;
+			bChannelHit = true;
 		byCurrChannel =
 			RFaby11aChannelIndex[sFrame.pDSParms->byCurrChannel-1];
         } else {
-		bChannelHit = TRUE;
+		bChannelHit = true;
         }
     } else {
 	if (sFrame.pDSParms) {
 		if (byCurrChannel == sFrame.pDSParms->byCurrChannel)
-			bChannelHit = TRUE;
+			bChannelHit = true;
 		byCurrChannel = sFrame.pDSParms->byCurrChannel;
 	} else {
-		bChannelHit = TRUE;
+		bChannelHit = true;
 	}
     }
     //RobertYu:20050201
 
 //2008-0730-01<Add>by MikeLiu
-if(ChannelExceedZoneType(pDevice,byCurrChannel)==TRUE)
+if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
       return;
 
     if (sFrame.pERP) {
         sERP.byERP = sFrame.pERP->byContext;
-        sERP.bERPExist = TRUE;
+        sERP.bERPExist = true;
     } else {
-        sERP.bERPExist = FALSE;
+        sERP.bERPExist = false;
         sERP.byERP = 0;
     }
 
@@ -4414,7 +4414,7 @@ void vMgrRxManagePacket(void *hDeviceContext,
 			PSRxMgmtPacket pRxPacket)
 {
     PSDevice    pDevice = (PSDevice)hDeviceContext;
-    BOOL        bInScan = FALSE;
+    BOOL        bInScan = false;
     unsigned int        uNodeIndex = 0;
     NODE_STATE  eNodeState = 0;
     CMD_STATUS  Status;
@@ -4450,7 +4450,7 @@ void vMgrRxManagePacket(void *hDeviceContext,
         case WLAN_FSTYPE_ASSOCRESP:
             // Frame Clase = 2
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx assocresp1\n");
-            s_vMgrRxAssocResponse(pDevice, pMgmt, pRxPacket, FALSE);
+            s_vMgrRxAssocResponse(pDevice, pMgmt, pRxPacket, false);
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx assocresp2\n");
             break;
 
@@ -4477,7 +4477,7 @@ void vMgrRxManagePacket(void *hDeviceContext,
         case WLAN_FSTYPE_REASSOCRESP:
             // Frame Clase = 2
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx reassocresp\n");
-            s_vMgrRxAssocResponse(pDevice, pMgmt, pRxPacket, TRUE);
+            s_vMgrRxAssocResponse(pDevice, pMgmt, pRxPacket, true);
             break;
 
         case WLAN_FSTYPE_PROBEREQ:
@@ -4497,7 +4497,7 @@ void vMgrRxManagePacket(void *hDeviceContext,
             // Frame Clase = 0
             //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx beacon\n");
             if (pMgmt->eScanState != WMAC_NO_SCANNING) {
-                bInScan = TRUE;
+                bInScan = true;
             };
             s_vMgrRxBeacon(pDevice, pMgmt, pRxPacket, bInScan);
             break;
@@ -4552,7 +4552,7 @@ void vMgrRxManagePacket(void *hDeviceContext,
  *  Prepare beacon to send
  *
  * Return Value:
- *    TRUE if success; FALSE if failed.
+ *    true if success; false if failed.
  *
 -*/
 BOOL bMgrPrepareBeaconToSend(void *hDeviceContext, PSMgmtObject pMgmt)
@@ -4560,7 +4560,7 @@ BOOL bMgrPrepareBeaconToSend(void *hDeviceContext, PSMgmtObject pMgmt)
     PSDevice            pDevice = (PSDevice)hDeviceContext;
     PSTxMgmtPacket      pTxPacket;
 
-//    pDevice->bBeaconBufReady = FALSE;
+//    pDevice->bBeaconBufReady = false;
     if (pDevice->bEncryptionEnable || pDevice->bEnable8021x){
         pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
     }
@@ -4583,12 +4583,12 @@ BOOL bMgrPrepareBeaconToSend(void *hDeviceContext, PSMgmtObject pMgmt)
 
     if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) &&
         (pMgmt->abyCurrBSSID[0] == 0))
-        return FALSE;
+        return false;
 
     csBeacon_xmit(pDevice, pTxPacket);
     MACvRegBitsOn(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
 
-    return TRUE;
+    return true;
 }
 
 
@@ -4687,10 +4687,10 @@ BOOL bAdd_PMKID_Candidate(void *hDeviceContext,
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"bAdd_PMKID_Candidate START: (%d)\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
 
     if ((pDevice == NULL) || (pbyBSSID == NULL) || (psRSNCapObj == NULL))
-        return FALSE;
+        return false;
 
     if (pDevice->gsPMKIDCandidate.NumCandidates >= MAX_PMKIDLIST)
-        return FALSE;
+        return false;
 
 
 
@@ -4698,7 +4698,7 @@ BOOL bAdd_PMKID_Candidate(void *hDeviceContext,
     for (ii = 0; ii < pDevice->gsPMKIDCandidate.NumCandidates; ii++) {
 	pCandidateList = &pDevice->gsPMKIDCandidate.CandidateList[ii];
 	if (!memcmp(pCandidateList->BSSID, pbyBSSID, ETH_ALEN)) {
-		if ((psRSNCapObj->bRSNCapExist == TRUE)
+		if ((psRSNCapObj->bRSNCapExist == true)
 		    && (psRSNCapObj->wRSNCap & BIT0)) {
 			pCandidateList->Flags |=
 				NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED;
@@ -4706,13 +4706,13 @@ BOOL bAdd_PMKID_Candidate(void *hDeviceContext,
 			pCandidateList->Flags &=
 				~(NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED);
 		}
-            return TRUE;
+            return true;
         }
     }
 
     // New Candidate
     pCandidateList = &pDevice->gsPMKIDCandidate.CandidateList[pDevice->gsPMKIDCandidate.NumCandidates];
-    if ((psRSNCapObj->bRSNCapExist == TRUE) && (psRSNCapObj->wRSNCap & BIT0)) {
+    if ((psRSNCapObj->bRSNCapExist == true) && (psRSNCapObj->wRSNCap & BIT0)) {
         pCandidateList->Flags |= NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED;
     } else {
         pCandidateList->Flags &= ~(NDIS_802_11_PMKID_CANDIDATE_PREAUTH_ENABLED);
@@ -4720,7 +4720,7 @@ BOOL bAdd_PMKID_Candidate(void *hDeviceContext,
     memcpy(pCandidateList->BSSID, pbyBSSID, ETH_ALEN);
     pDevice->gsPMKIDCandidate.NumCandidates++;
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"NumCandidates:%d\n", (int)pDevice->gsPMKIDCandidate.NumCandidates);
-    return TRUE;
+    return true;
 }
 
 /*
@@ -4761,7 +4761,7 @@ s_bCipherMatch (
     int i;
 
     if (pBSSNode == NULL)
-        return FALSE;
+        return false;
 
     // check cap. of BSS
     if ((WLAN_GET_CAP_INFO_PRIVACY(pBSSNode->wCapInfo) != 0) &&
@@ -4771,7 +4771,7 @@ s_bCipherMatch (
     }
 
     if ((WLAN_GET_CAP_INFO_PRIVACY(pBSSNode->wCapInfo) != 0) &&
-        (pBSSNode->bWPA2Valid == TRUE) &&
+        (pBSSNode->bWPA2Valid == true) &&
           //20080123-01,<Add> by Einsn Liu
         ((EncStatus == Ndis802_11Encryption3Enabled)||(EncStatus == Ndis802_11Encryption2Enabled))) {
         //WPA2
@@ -4805,7 +4805,7 @@ s_bCipherMatch (
         }
 
     } else if ((WLAN_GET_CAP_INFO_PRIVACY(pBSSNode->wCapInfo) != 0) &&
-                (pBSSNode->bWPAValid == TRUE) &&
+                (pBSSNode->bWPAValid == true) &&
                 ((EncStatus == Ndis802_11Encryption2Enabled) || (EncStatus == Ndis802_11Encryption3Enabled))) {
         //WPA
         // check Group Key Cipher
@@ -4847,9 +4847,9 @@ s_bCipherMatch (
             (byCipherMask == 0)) {
             *pbyCCSGK = KEY_CTL_WEP;
             *pbyCCSPK = KEY_CTL_NONE;
-            return TRUE;
+            return true;
         } else {
-            return FALSE;
+            return false;
         }
 
     } else if (EncStatus == Ndis802_11Encryption2Enabled) {
@@ -4857,45 +4857,45 @@ s_bCipherMatch (
             (byCipherMask == 0)) {
             *pbyCCSGK = KEY_CTL_TKIP;
             *pbyCCSPK = KEY_CTL_NONE;
-            return TRUE;
+            return true;
         } else if ((byMulticastCipher == KEY_CTL_WEP) &&
                    ((byCipherMask & 0x02) != 0)) {
             *pbyCCSGK = KEY_CTL_WEP;
             *pbyCCSPK = KEY_CTL_TKIP;
-            return TRUE;
+            return true;
         } else if ((byMulticastCipher == KEY_CTL_TKIP) &&
                    ((byCipherMask & 0x02) != 0)) {
             *pbyCCSGK = KEY_CTL_TKIP;
             *pbyCCSPK = KEY_CTL_TKIP;
-            return TRUE;
+            return true;
         } else {
-            return FALSE;
+            return false;
         }
     } else if (EncStatus == Ndis802_11Encryption3Enabled) {
         if ((byMulticastCipher == KEY_CTL_CCMP) &&
             (byCipherMask == 0)) {
             // When CCMP is enable, "Use group cipher suite" shall not be a valid option.
-            return FALSE;
+            return false;
         } else if ((byMulticastCipher == KEY_CTL_WEP) &&
                    ((byCipherMask & 0x04) != 0)) {
             *pbyCCSGK = KEY_CTL_WEP;
             *pbyCCSPK = KEY_CTL_CCMP;
-            return TRUE;
+            return true;
         } else if ((byMulticastCipher == KEY_CTL_TKIP) &&
                    ((byCipherMask & 0x04) != 0)) {
             *pbyCCSGK = KEY_CTL_TKIP;
             *pbyCCSPK = KEY_CTL_CCMP;
-            return TRUE;
+            return true;
         } else if ((byMulticastCipher == KEY_CTL_CCMP) &&
                    ((byCipherMask & 0x04) != 0)) {
             *pbyCCSGK = KEY_CTL_CCMP;
             *pbyCCSPK = KEY_CTL_CCMP;
-            return TRUE;
+            return true;
         } else {
-            return FALSE;
+            return false;
         }
     }
-    return TRUE;
+    return true;
 }
 
 
diff --git a/drivers/staging/vt6656/wpa.c b/drivers/staging/vt6656/wpa.c
index f492778..60f5138 100644
--- a/drivers/staging/vt6656/wpa.c
+++ b/drivers/staging/vt6656/wpa.c
@@ -83,9 +83,9 @@ WPA_ClearRSN (
     pBSSList->wAuthCount = 0;
     pBSSList->byDefaultK_as_PK = 0;
     pBSSList->byReplayIdx = 0;
-    pBSSList->sRSNCapObj.bRSNCapExist = FALSE;
+    pBSSList->sRSNCapObj.bRSNCapExist = false;
     pBSSList->sRSNCapObj.wRSNCap = 0;
-    pBSSList->bWPAValid = FALSE;
+    pBSSList->bWPAValid = false;
 }
 
 
@@ -212,14 +212,14 @@ WPA_ParseRSN (
                 pbyCaps = (PBYTE)pIE_RSN_Auth->AuthKSList[n].abyOUI;
                 pBSSList->byDefaultK_as_PK = (*pbyCaps) & WPA_GROUPFLAG;
                 pBSSList->byReplayIdx = 2 << ((*pbyCaps >> WPA_REPLAYBITSSHIFT) & WPA_REPLAYBITS);
-                pBSSList->sRSNCapObj.bRSNCapExist = TRUE;
+                pBSSList->sRSNCapObj.bRSNCapExist = true;
                 pBSSList->sRSNCapObj.wRSNCap = *(PWORD)pbyCaps;
                 //DBG_PRN_GRP14(("pbyCaps: %X\n", *pbyCaps));
                 //DBG_PRN_GRP14(("byDefaultK_as_PK: %X\n", pBSSList->byDefaultK_as_PK));
                 //DBG_PRN_GRP14(("byReplayIdx: %X\n", pBSSList->byReplayIdx));
             }
         }
-        pBSSList->bWPAValid = TRUE;
+        pBSSList->bWPAValid = true;
     }
 }
 
@@ -249,14 +249,14 @@ WPA_SearchRSN (
     int ii;
     BYTE byPKType = WPA_NONE;
 
-    if (pBSSList->bWPAValid == FALSE)
-        return FALSE;
+    if (pBSSList->bWPAValid == false)
+        return false;
 
     switch(byCmd) {
     case 0:
 
         if (byEncrypt != pBSSList->byGKType)
-            return FALSE;
+            return false;
 
         if (pBSSList->wPKCount > 0) {
             for (ii = 0; ii < pBSSList->wPKCount; ii ++) {
@@ -270,9 +270,9 @@ WPA_SearchRSN (
                      byPKType = WPA_WEP104;
             }
             if (byEncrypt != byPKType)
-                return FALSE;
+                return false;
         }
-        return TRUE;
+        return true;
 //        if (pBSSList->wAuthCount > 0)
 //            for (ii=0; ii < pBSSList->wAuthCount; ii ++)
 //                if (byAuth == pBSSList->abyAuthType[ii])
@@ -282,7 +282,7 @@ WPA_SearchRSN (
     default:
         break;
     }
-    return FALSE;
+    return false;
 }
 
 /*+
@@ -305,14 +305,14 @@ WPAb_Is_RSN (
     )
 {
     if (pRSN == NULL)
-        return FALSE;
+        return false;
 
     if ((pRSN->len >= 6) && // oui1(4)+ver(2)
         (pRSN->byElementID == WLAN_EID_RSN_WPA) &&  !memcmp(pRSN->abyOUI, abyOUI01, 4) &&
         (pRSN->wVersion == 1)) {
-        return TRUE;
+        return true;
     }
     else
-        return FALSE;
+        return false;
 }
 
diff --git a/drivers/staging/vt6656/wpa2.c b/drivers/staging/vt6656/wpa2.c
index 6d13190..6ca481f 100644
--- a/drivers/staging/vt6656/wpa2.c
+++ b/drivers/staging/vt6656/wpa2.c
@@ -78,7 +78,7 @@ WPA2_ClearRSN (
 {
     int ii;
 
-    pBSSNode->bWPA2Valid = FALSE;
+    pBSSNode->bWPA2Valid = false;
 
     pBSSNode->byCSSGK = WLAN_11i_CSS_CCMP;
     for (ii=0; ii < 4; ii ++)
@@ -87,7 +87,7 @@ WPA2_ClearRSN (
     for (ii=0; ii < 4; ii ++)
         pBSSNode->abyAKMSSAuthType[ii] = WLAN_11i_AKMSS_802_1X;
     pBSSNode->wAKMSSAuthCount = 1;
-    pBSSNode->sRSNCapObj.bRSNCapExist = FALSE;
+    pBSSNode->sRSNCapObj.bRSNCapExist = false;
     pBSSNode->sRSNCapObj.wRSNCap = 0;
 }
 
@@ -115,7 +115,7 @@ WPA2vParseRSN (
     int                 i, j;
     WORD                m = 0, n = 0;
     PBYTE               pbyOUI;
-    BOOL                bUseGK = FALSE;
+    BOOL                bUseGK = false;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"WPA2_ParseRSN: [%d]\n", pRSN->len);
 
@@ -123,7 +123,7 @@ WPA2vParseRSN (
 
     if (pRSN->len == 2) { // ver(2)
         if ((pRSN->byElementID == WLAN_EID_RSN) && (pRSN->wVersion == 1)) {
-            pBSSNode->bWPA2Valid = TRUE;
+            pBSSNode->bWPA2Valid = true;
         }
         return;
     }
@@ -158,7 +158,7 @@ WPA2vParseRSN (
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"802.11i CSS: %X\n", pBSSNode->byCSSGK);
 
         if (pRSN->len == 6) {
-            pBSSNode->bWPA2Valid = TRUE;
+            pBSSNode->bWPA2Valid = true;
             return;
         }
 
@@ -172,7 +172,7 @@ WPA2vParseRSN (
                 if (pRSN->len >= 8+i*4+4) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*i)
                     if ( !memcmp(pbyOUI, abyOUIGK, 4)) {
                         pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_USE_GROUP;
-                        bUseGK = TRUE;
+                        bUseGK = true;
                     } else if ( !memcmp(pbyOUI, abyOUIWEP40, 4)) {
                         // Invialid CSS, continue to parsing
                     } else if ( !memcmp(pbyOUI, abyOUITKIP, 4)) {
@@ -194,7 +194,7 @@ WPA2vParseRSN (
                     break;
             } //for
 
-            if (bUseGK == TRUE) {
+            if (bUseGK == true) {
                 if (j != 1) {
                     // invalid CSS, This should be only PK CSS.
                     return;
@@ -236,12 +236,12 @@ WPA2vParseRSN (
 
             n = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
             if (pRSN->len >= 12+4*m+4*n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
-                pBSSNode->sRSNCapObj.bRSNCapExist = TRUE;
+                pBSSNode->sRSNCapObj.bRSNCapExist = true;
                 pBSSNode->sRSNCapObj.wRSNCap = *((PWORD) &(pRSN->abyRSN[8+4*m+4*n]));
             }
         }
         //ignore PMKID lists bcs only (Re)Assocrequest has this field
-        pBSSNode->bWPA2Valid = TRUE;
+        pBSSNode->bWPA2Valid = true;
     }
 }
 
@@ -328,7 +328,7 @@ WPA2uSetIEs(void *pMgmtHandle,
         pRSNIEs->len +=6;
 
         // RSN Capabilites
-        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == TRUE) {
+        if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == true) {
             memcpy(&pRSNIEs->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
         } else {
             pRSNIEs->abyRSN[16] = 0;
@@ -337,7 +337,7 @@ WPA2uSetIEs(void *pMgmtHandle,
         pRSNIEs->len +=2;
 
 	if ((pMgmt->gsPMKIDCache.BSSIDInfoCount > 0) &&
-	    (pMgmt->bRoaming == TRUE) &&
+	    (pMgmt->bRoaming == true) &&
             (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)) {
 		/* RSN PMKID, pointer to PMKID count */
 		pwPMKID = (PWORD)(&pRSNIEs->abyRSN[18]);
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index b407ae5..39361dd 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -220,9 +220,9 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "param->u.wpa_key.alg_name = %d \n", param->u.wpa_key.alg_name);
 	if (param->u.wpa_key.alg_name == WPA_ALG_NONE) {
         pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-        pDevice->bEncryptionEnable = FALSE;
+        pDevice->bEncryptionEnable = false;
         pDevice->byKeyIndex = 0;
-        pDevice->bTransmitKey = FALSE;
+        pDevice->bTransmitKey = false;
         for (uu=0; uu<MAX_KEY_TABLE; uu++) {
             MACvDisableKeyEntry(pDevice, uu);
         }
@@ -251,7 +251,7 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
         else {
             if (param->u.wpa_key.set_tx) {
                 pDevice->byKeyIndex = (BYTE)dwKeyIndex;
-                pDevice->bTransmitKey = TRUE;
+                pDevice->bTransmitKey = true;
 		        dwKeyIndex |= (1 << 31);
             }
             KeybSetDefaultKey(  pDevice,
@@ -265,7 +265,7 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
 
         }
         pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-        pDevice->bEncryptionEnable = TRUE;
+        pDevice->bEncryptionEnable = true;
         return ret;
 	}
 
@@ -359,7 +359,7 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
                             (PQWORD) &(KeyRSC),
                             (PBYTE)abyKey,
                             byKeyDecMode
-                            ) == TRUE) &&
+                            ) == true) &&
             (KeybSetDefaultKey(pDevice,
                             &(pDevice->sKey),
                             dwKeyIndex,
@@ -367,7 +367,7 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
                             (PQWORD) &(KeyRSC),
                             (PBYTE)abyKey,
                             byKeyDecMode
-                            ) == TRUE) ) {
+                            ) == true) ) {
              DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GROUP Key Assign.\n");
 
         } else {
@@ -397,7 +397,7 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
                        (PQWORD) &(KeyRSC),
                        (PBYTE)abyKey,
                         byKeyDecMode
-                       ) == TRUE) {
+                       ) == true) {
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Set\n");
 
         } else {
@@ -415,9 +415,9 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
     } // BSSID not 0xffffffffffff
     if ((ret == 0) && ((param->u.wpa_key.set_tx) != 0)) {
         pDevice->byKeyIndex = (BYTE)param->u.wpa_key.key_index;
-        pDevice->bTransmitKey = TRUE;
+        pDevice->bTransmitKey = true;
     }
-    pDevice->bEncryptionEnable = TRUE;
+    pDevice->bEncryptionEnable = true;
 
 /*
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx \n",
@@ -456,7 +456,7 @@ static int wpa_set_wpa(PSDevice pDevice,
 	int ret = 0;
 
     pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-    pMgmt->bShareKeyAlgorithm = FALSE;
+    pMgmt->bShareKeyAlgorithm = false;
 
     return ret;
 }
@@ -647,9 +647,9 @@ static int wpa_get_scan(PSDevice pDevice,
 
 	for (jj = 0; jj < MAX_BSS_NUM - ii - 1; jj++) {
 
-		if ((pMgmt->sBSSList[jj].bActive != TRUE) ||
+		if ((pMgmt->sBSSList[jj].bActive != true) ||
 
-                ((pMgmt->sBSSList[jj].uRSSI>pMgmt->sBSSList[jj+1].uRSSI) &&(pMgmt->sBSSList[jj+1].bActive!=FALSE))) {
+                ((pMgmt->sBSSList[jj].uRSSI>pMgmt->sBSSList[jj+1].uRSSI) &&(pMgmt->sBSSList[jj+1].bActive!=false))) {
 
                  memcpy(ptempBSS,&pMgmt->sBSSList[jj],sizeof(KnownBSS));
 
@@ -762,7 +762,7 @@ static int wpa_set_associate(PSDevice pDevice,
     BYTE    abyNullAddr[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
     BYTE    abyWPAIE[64];
     int ret = 0;
-    BOOL   bwepEnabled=FALSE;
+    BOOL   bwepEnabled=false;
 
 	// set key type & algorithm
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise_suite = %d\n", param->u.wpa_associate.pairwise_suite);
@@ -821,7 +821,7 @@ static int wpa_set_associate(PSDevice pDevice,
 	case CIPHER_WEP40:
 	case CIPHER_WEP104:
 		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		bwepEnabled = TRUE;
+		bwepEnabled = true;
 	//	printk("****************wpa_set_associate:set CIPHER_WEP40_104\n");
 		break;
 	case CIPHER_NONE:
@@ -836,14 +836,14 @@ static int wpa_set_associate(PSDevice pDevice,
 
            pMgmt->Roam_dbm = param->u.wpa_associate.roam_dbm;
          // if ((pMgmt->Roam_dbm > 40)&&(pMgmt->Roam_dbm<80))
-         //    pDevice->bEnableRoaming = TRUE;
+         //    pDevice->bEnableRoaming = true;
 
 	    if (pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) {   //@wep-sharekey
             pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-            pMgmt->bShareKeyAlgorithm = TRUE;
+            pMgmt->bShareKeyAlgorithm = true;
              }
 	    else if (pMgmt->eAuthenMode == WMAC_AUTH_OPEN) {
-	       if(bwepEnabled==TRUE) {                                                         //@open-wep
+	       if(bwepEnabled==true) {                                                         //@open-wep
                        pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 	   	}
 	      else {                                                                                                 //@only open
@@ -854,12 +854,12 @@ static int wpa_set_associate(PSDevice pDevice,
 	pDevice->eOldEncryptionStatus = pDevice->eEncryptionStatus;
 
     if (pDevice->eEncryptionStatus !=  Ndis802_11EncryptionDisabled)
-        pDevice->bEncryptionEnable = TRUE;
+        pDevice->bEncryptionEnable = true;
     else
-        pDevice->bEncryptionEnable = FALSE;
+        pDevice->bEncryptionEnable = false;
 
  if ((pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) ||
-      ((pMgmt->eAuthenMode == WMAC_AUTH_OPEN) && (bwepEnabled==TRUE)))  {
+      ((pMgmt->eAuthenMode == WMAC_AUTH_OPEN) && (bwepEnabled==true)))  {
  //mike re-comment:open-wep && sharekey-wep needn't do initial key!!
 
      }
@@ -867,7 +867,7 @@ static int wpa_set_associate(PSDevice pDevice,
     KeyvInitTable(pDevice,&pDevice->sKey);
 
     spin_lock_irq(&pDevice->lock);
-    pDevice->bLinkPass = FALSE;
+    pDevice->bLinkPass = false;
     ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
     memset(pMgmt->abyCurrBSSID, 0, 6);
     pMgmt->eCurrState = WMAC_STATE_IDLE;
@@ -941,7 +941,7 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	case VIAWGET_SET_KEY:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_KEY \n");
 	    spin_lock_irq(&pDevice->lock);
-        ret = wpa_set_keys(pDevice, param, FALSE);
+        ret = wpa_set_keys(pDevice, param, false);
         spin_unlock_irq(&pDevice->lock);
 		break;
 
-- 
1.7.0.4

