Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1LEBOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 20:14:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56972 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab1LEBOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 20:14:53 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 1/2] staging: vt6656: aes_ccmp, baseband, bssdb, card: Change BOOL to int
Date: Sun,  4 Dec 2011 23:12:46 -0200
Message-Id: <1323047566-12650-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change all references of BOOL to int. As asked by the TODO
file of the driver, we need to remove the ttype.h, and this file do a
typedef of int to BOOL. We don't need this.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/aes_ccmp.c |    4 +-
 drivers/staging/vt6656/aes_ccmp.h |    2 +-
 drivers/staging/vt6656/baseband.c |   11 ++++-----
 drivers/staging/vt6656/baseband.h |    8 ++----
 drivers/staging/vt6656/bssdb.c    |   16 +++++++-------
 drivers/staging/vt6656/bssdb.h    |   42 ++++++++++++++++++------------------
 drivers/staging/vt6656/card.c     |   26 +++++++++++-----------
 drivers/staging/vt6656/card.h     |   16 +++++++-------
 8 files changed, 61 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/vt6656/aes_ccmp.c b/drivers/staging/vt6656/aes_ccmp.c
index f7a3b8f..1abda79 100644
--- a/drivers/staging/vt6656/aes_ccmp.c
+++ b/drivers/staging/vt6656/aes_ccmp.c
@@ -231,7 +231,7 @@ void AESv128(BYTE *key, BYTE *data, BYTE *ciphertext)
  *
  */
 
-BOOL AESbGenCCMP(PBYTE pbyRxKey, PBYTE pbyFrame, WORD wFrameSize)
+int AESbGenCCMP(PBYTE pbyRxKey, PBYTE pbyFrame, WORD wFrameSize)
 {
 	BYTE            abyNonce[13];
 	BYTE            MIC_IV[16];
@@ -249,7 +249,7 @@ BOOL AESbGenCCMP(PBYTE pbyRxKey, PBYTE pbyFrame, WORD wFrameSize)
 	WORD            wHLen = 22;
 	/* 8 is IV, 8 is MIC, 4 is CRC */
 	WORD            wPayloadSize = wFrameSize - 8 - 8 - 4 - WLAN_HDR_ADDR3_LEN;
-	BOOL            bA4 = FALSE;
+	int bA4 = FALSE;
 	BYTE            byTmp;
 	WORD            wCnt;
 	int             ii, jj, kk;
diff --git a/drivers/staging/vt6656/aes_ccmp.h b/drivers/staging/vt6656/aes_ccmp.h
index 353bd21..e4cb158 100644
--- a/drivers/staging/vt6656/aes_ccmp.h
+++ b/drivers/staging/vt6656/aes_ccmp.h
@@ -41,6 +41,6 @@
 /*---------------------  Export Variables  --------------------------*/
 
 /*---------------------  Export Functions  --------------------------*/
-BOOL AESbGenCCMP(PBYTE pbyRxKey, PBYTE pbyFrame, WORD wFrameSize);
+int AESbGenCCMP(PBYTE pbyRxKey, PBYTE pbyFrame, WORD wFrameSize);
 
 #endif /* __AES_CCMP_H__ */
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 0d11147..5fcd646 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -770,9 +770,9 @@ BBvCaculateParameter (
     unsigned int cbBitCount;
     unsigned int cbUsCount = 0;
     unsigned int cbTmp;
-    BOOL bExtBit;
+	int bExtBit;
     BYTE byPreambleType = pDevice->byPreambleType;
-    BOOL bCCK = pDevice->bCCK;
+	int bCCK = pDevice->bCCK;
 
     cbBitCount = cbFrameLength * 8;
     bExtBit = FALSE;
@@ -990,7 +990,7 @@ BBvSetAntennaMode (PSDevice pDevice, BYTE byAntennaMode)
  *
  */
 
-BOOL BBbVT3184Init(PSDevice pDevice)
+int BBbVT3184Init(PSDevice pDevice)
 {
 	int ntStatus;
     WORD                    wLength;
@@ -1641,9 +1641,8 @@ void TimerSQ3Tmax3CallBack(void *hDeviceContext)
 }
 
 void
-BBvUpdatePreEDThreshold(
-      PSDevice    pDevice,
-      BOOL        bScanning)
+BBvUpdatePreEDThreshold(PSDevice    pDevice,
+			int bScanning)
 {
 
 
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 8db8cd0..932beb8 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -125,12 +125,10 @@ void BBvSoftwareReset(PSDevice pDevice);
 void BBvSetShortSlotTime(PSDevice pDevice);
 void BBvSetVGAGainOffset(PSDevice pDevice, BYTE byData);
 void BBvSetAntennaMode(PSDevice pDevice, BYTE byAntennaMode);
-BOOL BBbVT3184Init(PSDevice pDevice);
+int BBbVT3184Init(PSDevice pDevice);
 void BBvSetDeepSleep(PSDevice pDevice);
 void BBvExitDeepSleep(PSDevice pDevice);
-void BBvUpdatePreEDThreshold(
-       PSDevice    pDevice,
-       BOOL        bScanning
-     );
+void BBvUpdatePreEDThreshold(PSDevice    pDevice,
+			     int bScanning);
 
 #endif /* __BASEBAND_H__ */
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index af006df..fdc0d34 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -282,7 +282,7 @@ pDevice->bSameBSSMaxNum = jj;
 -*/
 
 
-void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID)
+void BSSvClearBSSList(void *hDeviceContext, int bKeepCurrBSSID)
 {
     PSDevice     pDevice = (PSDevice)hDeviceContext;
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
@@ -363,7 +363,7 @@ PKnownBSS BSSpAddrIsInBSSList(void *hDeviceContext,
  *
 -*/
 
-BOOL BSSbInsertToBSSList(void *hDeviceContext,
+int BSSbInsertToBSSList(void *hDeviceContext,
 			 PBYTE abyBSSIDAddr,
 			 QWORD qwTimestamp,
 			 WORD wBeaconInterval,
@@ -387,7 +387,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
     PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
     PKnownBSS       pBSSList = NULL;
     unsigned int            ii;
-    BOOL            bParsingQuiet = FALSE;
+	int bParsingQuiet = FALSE;
 
 
 
@@ -487,7 +487,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
     if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) || (pBSSList->bWPA2Valid == TRUE)) {
 
         PSKeyItem  pTransmitKey = NULL;
-        BOOL       bIs802_1x = FALSE;
+	int bIs802_1x = FALSE;
 
         for (ii = 0; ii < pBSSList->wAKMSSAuthCount; ii ++) {
             if (pBSSList->abyAKMSSAuthType[ii] == WLAN_11i_AKMSS_802_1X) {
@@ -584,12 +584,12 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 -*/
 // TODO: input structure modify
 
-BOOL BSSbUpdateToBSSList(void *hDeviceContext,
+int BSSbUpdateToBSSList(void *hDeviceContext,
 			 QWORD qwTimestamp,
 			 WORD wBeaconInterval,
 			 WORD wCapInfo,
 			 BYTE byCurrChannel,
-			 BOOL bChannelHit,
+			 int bChannelHit,
 			 PWLAN_IE_SSID pSSID,
 			 PWLAN_IE_SUPP_RATES pSuppRates,
 			 PWLAN_IE_SUPP_RATES pExtSuppRates,
@@ -608,7 +608,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
     PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
     signed long            ldBm, ldBmSum;
-    BOOL            bParsingQuiet = FALSE;
+	int bParsingQuiet = FALSE;
   //  BYTE            abyTmpSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 
 
@@ -729,7 +729,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
  *
 -*/
 
-BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
+int BSSbIsSTAInNodeDB(void *hDeviceContext,
 		       PBYTE abyDstAddr,
 		       unsigned int *puNodeIndex)
 {
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index a8f97eb..7c9ec7d 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -81,21 +81,21 @@
 //
 
 typedef struct tagSERPObject {
-    BOOL    bERPExist;
-    BYTE    byERP;
+	int bERPExist;
+	BYTE byERP;
 } ERPObject, *PERPObject;
 
 
 typedef struct tagSRSNCapObject {
-    BOOL    bRSNCapExist;
-    WORD    wRSNCap;
+	int bRSNCapExist;
+	WORD wRSNCap;
 } SRSNCapObject, *PSRSNCapObject;
 
 // BSS info(AP)
 #pragma pack(1)
 typedef struct tagKnownBSS {
     // BSS info
-    BOOL            bActive;
+	int bActive;
     BYTE            abyBSSID[WLAN_BSSID_LEN];
     unsigned int            uChannel;
     BYTE            abySuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
@@ -113,10 +113,10 @@ typedef struct tagKnownBSS {
     signed long            ldBmAverage[RSSI_STAT_COUNT];
     signed long            ldBmAverRange;
     //For any BSSID selection improvment
-    BOOL            bSelected;
+	int bSelected;
 
     //++ WPA informations
-    BOOL            bWPAValid;
+	int bWPAValid;
     BYTE            byGKType;
     BYTE            abyPKType[4];
     WORD            wPKCount;
@@ -127,7 +127,7 @@ typedef struct tagKnownBSS {
     //--
 
     //++ WPA2 informations
-    BOOL            bWPA2Valid;
+	int bWPA2Valid;
     BYTE            byCSSGK;
     WORD            wCSSPKCount;
     BYTE            abyCSSPK[4];
@@ -170,14 +170,14 @@ typedef enum tagNODE_STATE {
 // STA node info
 typedef struct tagKnownNodeDB {
     // STA info
-    BOOL            bActive;
+	int bActive;
     BYTE            abyMACAddr[WLAN_ADDR_LEN];
     BYTE            abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
     BYTE            abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
     WORD            wTxDataRate;
-    BOOL            bShortPreamble;
-    BOOL            bERPExist;
-    BOOL            bShortSlotTime;
+	int bShortPreamble;
+	int bERPExist;
+	int bShortSlotTime;
     unsigned int            uInActiveCount;
     WORD            wMaxBasicRate;     //Get from byTopOFDMBasicRate or byTopCCKBasicRate which depends on packetTyp.
     WORD            wMaxSuppRate;      //Records the highest supported rate getting from SuppRates IE and ExtSuppRates IE in Beacon.
@@ -191,15 +191,15 @@ typedef struct tagKnownNodeDB {
     WORD            wListenInterval;
     WORD            wAID;
     NODE_STATE      eNodeState;
-    BOOL            bPSEnable;
-    BOOL            bRxPSPoll;
+	int bPSEnable;
+	int bRxPSPoll;
     BYTE            byAuthSequence;
     unsigned long           ulLastRxJiffer;
     BYTE            bySuppRate;
     DWORD           dwFlags;
     WORD            wEnQueueCnt;
 
-    BOOL            bOnFly;
+	int bOnFly;
     unsigned long long       KeyRSC;
     BYTE            byKeyIndex;
     DWORD           dwKeyIndex;
@@ -210,7 +210,7 @@ typedef struct tagKnownNodeDB {
     BYTE            abyWepKey[WLAN_WEPMAX_KEYLEN];
     //
     // Auto rate fallback vars
-    BOOL            bIsInFallback;
+	int bIsInFallback;
     unsigned int            uAverageRSSI;
     unsigned int            uRateRecoveryTimeout;
     unsigned int            uRatePollTimeout;
@@ -237,9 +237,9 @@ PKnownBSS BSSpAddrIsInBSSList(void *hDeviceContext,
 			      PBYTE abyBSSID,
 			      PWLAN_IE_SSID pSSID);
 
-void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID);
+void BSSvClearBSSList(void *hDeviceContext, int bKeepCurrBSSID);
 
-BOOL BSSbInsertToBSSList(void *hDeviceContext,
+int BSSbInsertToBSSList(void *hDeviceContext,
 			 PBYTE abyBSSIDAddr,
 			 QWORD qwTimestamp,
 			 WORD wBeaconInterval,
@@ -257,12 +257,12 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
 			 PBYTE pbyIEs,
 			 void *pRxPacketContext);
 
-BOOL BSSbUpdateToBSSList(void *hDeviceContext,
+int BSSbUpdateToBSSList(void *hDeviceContext,
 			 QWORD qwTimestamp,
 			 WORD wBeaconInterval,
 			 WORD wCapInfo,
 			 BYTE byCurrChannel,
-			 BOOL bChannelHit,
+			 int bChannelHit,
 			 PWLAN_IE_SSID pSSID,
 			 PWLAN_IE_SUPP_RATES pSuppRates,
 			 PWLAN_IE_SUPP_RATES pExtSuppRates,
@@ -276,7 +276,7 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
 			 PBYTE pbyIEs,
 			 void *pRxPacketContext);
 
-BOOL BSSbIsSTAInNodeDB(void *hDeviceContext,
+int BSSbIsSTAInNodeDB(void *hDeviceContext,
 		       PBYTE abyDstAddr,
 		       unsigned int *puNodeIndex);
 
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index a49053b..c13630d 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -95,10 +95,10 @@ const WORD cwRXBCNTSFOff[MAX_RATE] =
  * Return Value: TRUE if succeeded; FALSE if failed.
  *
  */
-BOOL CARDbSetMediaChannel(void *pDeviceHandler, unsigned int uConnectionChannel)
+int CARDbSetMediaChannel(void *pDeviceHandler, unsigned int uConnectionChannel)
 {
 PSDevice            pDevice = (PSDevice) pDeviceHandler;
-BOOL                bResult = TRUE;
+	int bResult = TRUE;
 
 
     if (pDevice->byBBType == BB_TYPE_11A) { // 15 ~ 38
@@ -506,7 +506,7 @@ void vUpdateIFS(void *pDeviceHandler)
     }
     else {// PK_TYPE_11GA & PK_TYPE_11GB
         BYTE byRate = 0;
-        BOOL bOFDMRate = FALSE;
+	int bOFDMRate = FALSE;
 	unsigned int ii = 0;
         PWLAN_IE_SUPP_RATES pItemRates = NULL;
 
@@ -607,7 +607,7 @@ BYTE ii;
  * Return Value: TRUE if succeeded; FALSE if failed.
  *
  */
-BOOL CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx)
+int CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx)
 {
 PSDevice    pDevice = (PSDevice) pDeviceHandler;
 WORD wRate = (WORD)(1<<wRateIdx);
@@ -620,7 +620,7 @@ WORD wRate = (WORD)(1<<wRateIdx);
     return(TRUE);
 }
 
-BOOL CARDbIsOFDMinBasicRate(void *pDeviceHandler)
+int CARDbIsOFDMinBasicRate(void *pDeviceHandler)
 {
 PSDevice    pDevice = (PSDevice) pDeviceHandler;
 int ii;
@@ -754,7 +754,7 @@ void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF)
+int CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF)
 {
     PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
@@ -776,7 +776,7 @@ BOOL CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF)
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL CARDbClearCurrentTSF(void *pDeviceHandler)
+int CARDbClearCurrentTSF(void *pDeviceHandler)
 {
     PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
@@ -944,10 +944,10 @@ void CARDvUpdateNextTBTT(void *pDeviceHandler, QWORD qwTSF,
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL CARDbRadioPowerOff(void *pDeviceHandler)
+int CARDbRadioPowerOff(void *pDeviceHandler)
 {
 PSDevice    pDevice = (PSDevice) pDeviceHandler;
-BOOL bResult = TRUE;
+	int bResult = TRUE;
 
     //if (pDevice->bRadioOff == TRUE)
     //    return TRUE;
@@ -985,10 +985,10 @@ BOOL bResult = TRUE;
  * Return Value: TRUE if success; otherwise FALSE
  *
  */
-BOOL CARDbRadioPowerOn(void *pDeviceHandler)
+int CARDbRadioPowerOn(void *pDeviceHandler)
 {
 PSDevice    pDevice = (PSDevice) pDeviceHandler;
-BOOL bResult = TRUE;
+	int bResult = TRUE;
 
 
     if ((pDevice->bHWRadioOff == TRUE) || (pDevice->bRadioControlOff == TRUE)) {
@@ -1077,7 +1077,7 @@ void CARDvSetBSSMode(void *pDeviceHandler)
  * Return Value: none.
  *
 -*/
-BOOL
+int
 CARDbChannelSwitch (
      void *pDeviceHandler,
      BYTE             byMode,
@@ -1086,7 +1086,7 @@ CARDbChannelSwitch (
     )
 {
     PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    BOOL        bResult = TRUE;
+	int bResult = TRUE;
 
     if (byCount == 0) {
         pDevice->sMgmtObj.uCurrChannel = byNewChannel;
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 6c91343..0d70e15 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -60,28 +60,28 @@ typedef enum _CARD_OP_MODE {
 
 /*---------------------  Export Functions  --------------------------*/
 
-BOOL CARDbSetMediaChannel(void *pDeviceHandler,
+int CARDbSetMediaChannel(void *pDeviceHandler,
 			  unsigned int uConnectionChannel);
 void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType);
 void vUpdateIFS(void *pDeviceHandler);
 void CARDvUpdateBasicTopRate(void *pDeviceHandler);
-BOOL CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx);
-BOOL CARDbIsOFDMinBasicRate(void *pDeviceHandler);
+int CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx);
+int CARDbIsOFDMinBasicRate(void *pDeviceHandler);
 void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
 		    QWORD qwBSSTimestamp, QWORD qwLocalTSF);
-BOOL CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF);
-BOOL CARDbClearCurrentTSF(void *pDeviceHandler);
+int CARDbGetCurrentTSF(void *pDeviceHandler, PQWORD pqwCurrTSF);
+int CARDbClearCurrentTSF(void *pDeviceHandler);
 void CARDvSetFirstNextTBTT(void *pDeviceHandler, WORD wBeaconInterval);
 void CARDvUpdateNextTBTT(void *pDeviceHandler, QWORD qwTSF,
 			 WORD wBeaconInterval);
 QWORD CARDqGetNextTBTT(QWORD qwTSF, WORD wBeaconInterval);
 QWORD CARDqGetTSFOffset(BYTE byRxRate, QWORD qwTSF1, QWORD qwTSF2);
-BOOL CARDbRadioPowerOff(void *pDeviceHandler);
-BOOL CARDbRadioPowerOn(void *pDeviceHandler);
+int CARDbRadioPowerOff(void *pDeviceHandler);
+int CARDbRadioPowerOn(void *pDeviceHandler);
 BYTE CARDbyGetPktType(void *pDeviceHandler);
 void CARDvSetBSSMode(void *pDeviceHandler);
 
-BOOL CARDbChannelSwitch(void *pDeviceHandler,
+int CARDbChannelSwitch(void *pDeviceHandler,
 			BYTE byMode,
 			BYTE byNewChannel,
 			BYTE byCount);
-- 
1.7.4.4

