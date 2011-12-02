Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1LBV5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 16:57:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53591 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab1LBV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 16:57:07 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 2/3] staging: vt6655: vntwifi.c: General cleanup
Date: Fri,  2 Dec 2011 19:56:49 +0000
Message-Id: <1322855809-6305-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes commented code, blank lines and fix coding style of
the headers of functions.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6655/vntwifi.c |  319 ++++----------------------------------
 1 files changed, 33 insertions(+), 286 deletions(-)

diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 0491d0b..8ab1aaa 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -38,37 +38,9 @@
 #include "wmgr.h"
 #include "datarate.h"
 
-//#define	PLICE_DEBUG
-
-/*---------------------  Static Definitions -------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-//static int          msglevel                =MSG_LEVEL_INFO;
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-/*+
- *
- * Description:
- *    Set Operation Mode
- *
- * Parameters:
- *  In:
- *      pMgmtHandle - pointer to management object
- *      eOPMode     - Opreation Mode
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
+/*
+ * Set Operation Mode
+ */
 void
 VNTWIFIvSetOPMode (
     void *pMgmtHandle,
@@ -80,24 +52,9 @@ VNTWIFIvSetOPMode (
     pMgmt->eConfigMode = eOPMode;
 }
 
-
-/*+
- *
- * Description:
- *    Set Operation Mode
- *
- * Parameters:
- *  In:
- *      pMgmtHandle - pointer to management object
- *      wBeaconPeriod - Beacon Period
- *      wATIMWindow - ATIM window
- *      uChannel - channel number
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
+/*
+ * Set Operation Mode
+ */
 void
 VNTWIFIvSetIBSSParameter (
     void *pMgmtHandle,
@@ -113,20 +70,9 @@ VNTWIFIvSetIBSSParameter (
     pMgmt->uIBSSChannel = uChannel;
 }
 
-/*+
- *
- * Description:
- *    Get current SSID
- *
- * Parameters:
- *  In:
- *      pMgmtHandle - pointer to management object
- *  Out:
- *      none
- *
- * Return Value: current SSID pointer.
- *
--*/
+/*
+ * Get current SSID
+ */
 PWLAN_IE_SSID
 VNTWIFIpGetCurrentSSID (
     void *pMgmtHandle
@@ -136,20 +82,9 @@ VNTWIFIpGetCurrentSSID (
     return((PWLAN_IE_SSID) pMgmt->abyCurrSSID);
 }
 
-/*+
- *
- * Description:
- *    Get current link channel
- *
- * Parameters:
- *  In:
- *      pMgmtHandle - pointer to management object
- *  Out:
- *      none
- *
- * Return Value: current Channel.
- *
--*/
+/*
+ * Get current link channel
+ */
 unsigned int
 VNTWIFIpGetCurrentChannel (
     void *pMgmtHandle
@@ -162,20 +97,9 @@ VNTWIFIpGetCurrentChannel (
     return 0;
 }
 
-/*+
- *
- * Description:
- *    Get current Assoc ID
- *
- * Parameters:
- *  In:
- *      pMgmtHandle - pointer to management object
- *  Out:
- *      none
- *
- * Return Value: current Assoc ID
- *
--*/
+/*
+ * Get current Assoc ID
+ */
 unsigned short
 VNTWIFIwGetAssocID (
     void *pMgmtHandle
@@ -185,23 +109,9 @@ VNTWIFIwGetAssocID (
     return(pMgmt->wCurrAID);
 }
 
-
-
-/*+
- *
- * Description:
- *    This routine return max support rate of IES
- *
- * Parameters:
- *  In:
- *      pSupportRateIEs
- *      pExtSupportRateIEs
- *
- *  Out:
- *
- * Return Value: max support rate
- *
--*/
+/*
+ * This routine return max support rate of IES
+ */
 unsigned char
 VNTWIFIbyGetMaxSupportRate (
     PWLAN_IE_SUPP_RATES pSupportRateIEs,
@@ -232,22 +142,9 @@ VNTWIFIbyGetMaxSupportRate (
     return byMaxSupportRate;
 }
 
-/*+
- *
- * Description:
- *    This routine return data rate of ACK packtet
- *
- * Parameters:
- *  In:
- *      byRxDataRate
- *      pSupportRateIEs
- *      pExtSupportRateIEs
- *
- *  Out:
- *
- * Return Value: max support rate
- *
--*/
+/*
+ * This routine return data rate of ACK packtet
+ */
 unsigned char
 VNTWIFIbyGetACKTxRate (
     unsigned char byRxDataRate,
@@ -291,21 +188,9 @@ VNTWIFIbyGetACKTxRate (
     return byMaxAckRate;
 }
 
-/*+
- *
- * Description:
- *    Set Authentication Mode
- *
- * Parameters:
- *  In:
- *      pMgmtHandle - pointer to management object
- *      eAuthMode   - Authentication mode
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
+/*
+ * Set Authentication Mode
+ */
 void
 VNTWIFIvSetAuthenticationMode (
     void *pMgmtHandle,
@@ -323,21 +208,9 @@ VNTWIFIvSetAuthenticationMode (
     }
 }
 
-/*+
- *
- * Description:
- *    Set Encryption Mode
- *
- * Parameters:
- *  In:
- *      pMgmtHandle - pointer to management object
- *      eAuthMode   - Authentication mode
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
+/*
+ * Set Encryption Mode
+ */
 void
 VNTWIFIvSetEncryptionMode (
     void *pMgmtHandle,
@@ -356,8 +229,6 @@ VNTWIFIvSetEncryptionMode (
     }
 }
 
-
-
 bool
 VNTWIFIbConfigPhyMode (
     void *pMgmtHandle,
@@ -378,7 +249,6 @@ VNTWIFIbConfigPhyMode (
     return(true);
 }
 
-
 void
 VNTWIFIbGetConfigPhyMode (
     void *pMgmtHandle,
@@ -392,38 +262,9 @@ VNTWIFIbGetConfigPhyMode (
     }
 }
 
-/*+
- *
- * Description:
- *      Clear BSS List Database except current assoc BSS
- *
- * Parameters:
- *  In:
- *      pMgmtHandle     - Management Object structure
- *      bLinkPass       - Current Link status
- *  Out:
- *
- * Return Value: None.
- *
--*/
-
-
-/*+
- *
- * Description:
- *      Query BSS List in management database
- *
- * Parameters:
- *  In:
- *      pMgmtHandle     - Management Object structure
- *  Out:
- *      puBSSCount      - BSS count
- *      pvFirstBSS      - pointer to first BSS
- *
- * Return Value: None.
- *
--*/
-
+/*
+ * Query BSS List in management database
+ */
 void
 VNTWIFIvQueryBSSList(void *pMgmtHandle, unsigned int *puBSSCount, void **pvFirstBSS)
 {
@@ -447,9 +288,6 @@ VNTWIFIvQueryBSSList(void *pMgmtHandle, unsigned int *puBSSCount, void **pvFirst
     *puBSSCount = uCount;
 }
 
-
-
-
 void
 VNTWIFIvGetNextBSS (
     void *pMgmtHandle,
@@ -474,22 +312,9 @@ VNTWIFIvGetNextBSS (
     }
 }
 
-
-
-
-
-/*+
- *
- * Description:
- *      Update Tx attemps, Tx failure counter in Node DB
- *
- *  In:
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
+/*
+ * Update Tx attemps, Tx failure counter in Node DB
+ */
 void
 VNTWIFIvUpdateNodeTxCounter(
     void *pMgmtHandle,
@@ -521,7 +346,6 @@ VNTWIFIvUpdateNodeTxCounter(
     for(ii=0;ii<MAX_RATE;ii++) {
         pMgmt->sNodeDBTable[uNodeIndex].uTxFail[ii] += pbyTxFailCount[ii];
     }
-    return;
 }
 
 
@@ -592,7 +416,6 @@ VNTWIFIvGetTxRate(
     *pbyACKRate = byACKRate;
     *pbyCCKBasicRate = byCCKBasicRate;
     *pbyOFDMBasicRate = byOFDMBasicRate;
-    return;
 }
 
 unsigned char
@@ -610,52 +433,6 @@ VNTWIFIbyGetKeyCypher(
     }
 }
 
-
-/*
-bool
-VNTWIFIbInit(
-    void *pAdapterHandler,
-    void **pMgmtHandler
-    )
-{
-
-    PSMgmtObject        pMgmt = NULL;
-    unsigned int ii;
-
-
-    pMgmt = (PSMgmtObject)kmalloc(sizeof(SMgmtObject), (int)GFP_ATOMIC);
-    if (pMgmt == NULL) {
-        *pMgmtHandler = NULL;
-        return false;
-    }
-
-    memset(pMgmt, 0, sizeof(SMgmtObject));
-    pMgmt->pAdapter = (void *) pAdapterHandler;
-
-    // should initial MAC address abyMACAddr
-    for(ii=0;ii<WLAN_BSSID_LEN;ii++) {
-        pMgmt->abyDesireBSSID[ii] = 0xFF;
-    }
-    pMgmt->pbyPSPacketPool = &pMgmt->byPSPacketPool[0];
-    pMgmt->pbyMgmtPacketPool = &pMgmt->byMgmtPacketPool[0];
-    pMgmt->byCSSPK = KEY_CTL_NONE;
-    pMgmt->byCSSGK = KEY_CTL_NONE;
-    pMgmt->wIBSSBeaconPeriod = DEFAULT_IBSS_BI;
-
-    pMgmt->cbFreeCmdQueue = CMD_Q_SIZE;
-    pMgmt->uCmdDequeueIdx = 0;
-    pMgmt->uCmdEnqueueIdx = 0;
-    pMgmt->eCommandState = WLAN_CMD_STATE_IDLE;
-    pMgmt->bCmdStop = false;
-    pMgmt->bCmdRunning = false;
-
-    *pMgmtHandler = pMgmt;
-    return true;
-}
-*/
-
-
-
 bool
 VNTWIFIbSetPMKIDCache (
     void *pMgmtObject,
@@ -673,8 +450,6 @@ VNTWIFIbSetPMKIDCache (
     return (true);
 }
 
-
-
 unsigned short
 VNTWIFIwGetMaxSupportRate(
     void *pMgmtObject
@@ -721,7 +496,6 @@ VNTWIFIbMeasureReport(
     PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtObject;
     unsigned char *pbyCurrentEID = (unsigned char *) (pMgmt->pCurrMeasureEIDRep);
 
-    //spin_lock_irq(&pDevice->lock);
     if ((pvMeasureEID != NULL) &&
         (pMgmt->uLengthOfRepEIDs < (WLAN_A3FR_MAXLEN - sizeof(MEASEURE_REP) - sizeof(WLAN_80211HDR_A3) - 3))
         ) {
@@ -762,7 +536,6 @@ VNTWIFIbMeasureReport(
     if (bEndOfReport == true) {
         IEEE11hbMSRRepTx(pMgmt);
     }
-    //spin_unlock_irq(&pDevice->lock);
     return (true);
 }
 
@@ -775,33 +548,7 @@ VNTWIFIbChannelSwitch(
 {
     PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtObject;
 
-    //spin_lock_irq(&pDevice->lock);
     pMgmt->uCurrChannel = byNewChannel;
     pMgmt->bSwitchChannel = false;
-    //spin_unlock_irq(&pDevice->lock);
     return true;
 }
-
-/*
-bool
-VNTWIFIbRadarPresent(
-    void *pMgmtObject,
-    unsigned char byChannel
-    )
-{
-    PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtObject;
-    if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) &&
-        (byChannel == (unsigned char) pMgmt->uCurrChannel) &&
-        (pMgmt->bSwitchChannel != true) &&
-        (pMgmt->b11hEnable == true)) {
-        if (!compare_ether_addr(pMgmt->abyIBSSDFSOwner, CARDpGetCurrentAddress(pMgmt->pAdapter))) {
-            pMgmt->byNewChannel = CARDbyAutoChannelSelect(pMgmt->pAdapter,(unsigned char) pMgmt->uCurrChannel);
-            pMgmt->bSwitchChannel = true;
-        }
-        BEACONbSendBeacon(pMgmt);
-        CARDbChannelSwitch(pMgmt->pAdapter, 0, pMgmt->byNewChannel, 10);
-    }
-    return true;
-}
-*/
-
-- 
1.7.4.4

