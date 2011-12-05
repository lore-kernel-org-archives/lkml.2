Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1LEBR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 20:17:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38478 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab1LEBR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 20:17:27 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 2/2] staging: vt6656: channel, datarate, device, dpc: Change BOOL to int
Date: Sun,  4 Dec 2011 23:16:16 -0200
Message-Id: <1323047776-12752-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change all variables of BOOL type for int. This change is
needed by the TODO file, asking to remove the ttype.h file. The BOOL
type is just a typedef of int type, so remove it.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/channel.c  |   13 ++--
 drivers/staging/vt6656/channel.h  |    6 +-
 drivers/staging/vt6656/datarate.c |    4 +-
 drivers/staging/vt6656/datarate.h |    2 +-
 drivers/staging/vt6656/device.h   |  138 ++++++++++++++++++------------------
 drivers/staging/vt6656/dpc.c      |   59 +++++++---------
 drivers/staging/vt6656/dpc.h      |    4 +-
 drivers/staging/vt6656/firmware.c |   10 +--
 drivers/staging/vt6656/firmware.h |    6 +-
 drivers/staging/vt6656/hostap.c   |    2 +-
 10 files changed, 116 insertions(+), 128 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 99e054d..69d3717 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -389,10 +389,9 @@ static  struct
 // 5G => Ch 7, 8, 9, 11, 12, 16, 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64,
 // 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 149, 153, 157, 161, 165 (Value 23 ~ 56)
  ************************************************************************/
-BOOL
-ChannelValid(unsigned int CountryCode, unsigned int ChannelIndex)
+int ChannelValid(unsigned int CountryCode, unsigned int ChannelIndex)
 {
-    BOOL    bValid;
+	int bValid;
 
     bValid = FALSE;
     /*
@@ -424,10 +423,8 @@ exit:
  *                          0x0000000000000003 means channel 1,2 are supported
  *                          0x000000000000000F means channel 1,2,..15 are supported
  ************************************************************************/
-BOOL
-CHvChannelGetList (
-      unsigned int       uCountryCodeIdx,
-     PBYTE      pbyChannelTable
+int CHvChannelGetList (unsigned int uCountryCodeIdx,
+		       PBYTE pbyChannelTable
     )
 {
     if (uCountryCodeIdx >= CCODE_MAX) {
@@ -441,7 +438,7 @@ CHvChannelGetList (
 void CHvInitChannelTable(void *pDeviceHandler)
 {
     PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    BOOL        bMultiBand = FALSE;
+	int bMultiBand = FALSE;
     unsigned int ii;
 
     for (ii = 1; ii <= CB_MAX_CHANNEL; ii++)
diff --git a/drivers/staging/vt6656/channel.h b/drivers/staging/vt6656/channel.h
index e7b3c12..dc5cf60 100644
--- a/drivers/staging/vt6656/channel.h
+++ b/drivers/staging/vt6656/channel.h
@@ -39,17 +39,17 @@
 typedef struct tagSChannelTblElement {
     BYTE    byChannelNumber;
     unsigned int    uFrequency;
-    BOOL    bValid;
+	int bValid;
 } SChannelTblElement, *PSChannelTblElement;
 
 /*---------------------  Export Variables  --------------------------*/
 
 /*---------------------  Export Functions  --------------------------*/
 
-BOOL    ChannelValid(unsigned int CountryCode, unsigned int ChannelNum);
+int ChannelValid(unsigned int CountryCode, unsigned int ChannelNum);
 void    CHvInitChannelTable(void *pDeviceHandler);
 BYTE    CHbyGetChannelMapping(BYTE byChannelNumber);
 
-BOOL CHvChannelGetList(unsigned int uCountryCodeIdx, PBYTE pbyChannelTable);
+int CHvChannelGetList(unsigned int uCountryCodeIdx, PBYTE pbyChannelTable);
 
 #endif  /* _CHANNEL_H_ */
diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index 5c2719f..8331060 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -192,7 +192,7 @@ void RATEvParseMaxRate(
      void *pDeviceHandler,
      PWLAN_IE_SUPP_RATES pItemRates,
      PWLAN_IE_SUPP_RATES pItemExtRates,
-     BOOL bUpdateBasicRate,
+	int bUpdateBasicRate,
      PWORD pwMaxBasicRate,
      PWORD pwMaxSuppRate,
      PWORD pwSuppRate,
@@ -311,7 +311,7 @@ PSDevice        pDevice = (PSDevice) pDeviceHandler;
 PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
 WORD            wIdxDownRate = 0;
 unsigned int            ii;
-BOOL            bAutoRate[MAX_RATE]    = {TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE};
+	int bAutoRate[MAX_RATE]    = {TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE};
 DWORD           dwThroughputTbl[MAX_RATE] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540};
 DWORD           dwThroughput = 0;
 WORD            wIdxUpRate = 0;
diff --git a/drivers/staging/vt6656/datarate.h b/drivers/staging/vt6656/datarate.h
index c6f5163..6b1222d 100644
--- a/drivers/staging/vt6656/datarate.h
+++ b/drivers/staging/vt6656/datarate.h
@@ -74,7 +74,7 @@ RATEvParseMaxRate(
      void *pDeviceHandler,
      PWLAN_IE_SUPP_RATES pItemRates,
      PWLAN_IE_SUPP_RATES pItemExtRates,
-     BOOL bUpdateBasicRate,
+	int bUpdateBasicRate,
      PWORD pwMaxBasicRate,
      PWORD pwMaxSuppRate,
      PWORD pwSuppRate,
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f1496ec..b9ef01f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -203,7 +203,7 @@ typedef struct _RCB
     struct urb              *pUrb;
     SRxMgmtPacket           sMngPacket;
     struct sk_buff*         skb;
-    BOOL                    bBoolInUse;
+	int bBoolInUse;
 
 } RCB, *PRCB;
 
@@ -216,7 +216,7 @@ typedef struct _USB_SEND_CONTEXT {
     CONTEXT_TYPE    Type;
     SEthernetHeader sEthHeader;
     void *Next;
-    BOOL            bBoolInUse;
+	int bBoolInUse;
     unsigned char           Data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
 } USB_SEND_CONTEXT, *PUSB_SEND_CONTEXT;
 
@@ -237,7 +237,7 @@ typedef struct {
     unsigned int            uDataLen;
     PBYTE           pDataBuf;
 //    struct urb      *pUrb;
-    BOOL            bInUse;
+	int bInUse;
 } INT_BUFFER, *PINT_BUFFER;
 
 //0:11A 1:11B 2:11G
@@ -333,7 +333,7 @@ typedef struct tagSPMKIDCandidateEvent {
 #define MAX_QUIET_COUNT     8
 
 typedef struct tagSQuietControl {
-    BOOL        bEnable;
+	int bEnable;
     DWORD       dwStartTime;
     BYTE        byPeriod;
     WORD        wDuration;
@@ -368,7 +368,7 @@ typedef struct tagSDeFragControlBlock
     struct sk_buff* skb;
     PBYTE           pbyRxBuffer;
     unsigned int            cbFrameLength;
-    BOOL            bInUse;
+	int bInUse;
 } SDeFragControlBlock, *PSDeFragControlBlock;
 
 
@@ -470,8 +470,8 @@ typedef struct __device_info {
     PRCB                        FirstRecvMngList;
     PRCB                        LastRecvMngList;
     unsigned int                        NumRecvMngList;
-    BOOL                        bIsRxWorkItemQueued;
-    BOOL                        bIsRxMngWorkItemQueued;
+	int bIsRxWorkItemQueued;
+	int bIsRxMngWorkItemQueued;
 	unsigned long ulRcvRefCount; /* packets that have not returned back */
 
     //
@@ -485,8 +485,8 @@ typedef struct __device_info {
     //  Variables to track resources for the Interript In Pipe
     //
     INT_BUFFER                  intBuf;
-    BOOL                        fKillEventPollingThread;
-    BOOL                        bEventAvailable;
+	int fKillEventPollingThread;
+	int bEventAvailable;
 
 
   //default config from file by user setting
@@ -520,16 +520,16 @@ typedef struct __device_info {
 
 
     BYTE                        byZoneType;
-    BOOL                        bZoneRegExist;
+	int bZoneRegExist;
 
     BYTE                        byOriginalZonetype;
 
-    BOOL                        bLinkPass;          // link status: OK or fail
+	int bLinkPass;          // link status: OK or fail
     BYTE                        abyCurrentNetAddr[ETH_ALEN];
     BYTE                        abyPermanentNetAddr[ETH_ALEN];
     // SW network address
 	/* u8 abySoftwareNetAddr[ETH_ALEN]; */
-    BOOL                        bExistSWNetAddr;
+	int bExistSWNetAddr;
 
     // Adapter statistics
     SStatCounter                scStatistic;
@@ -553,7 +553,7 @@ typedef struct __device_info {
 
     QWORD                       qwCurrTSF;
     unsigned int                        cbBulkInMax;
-    BOOL                        bPSRxBeacon;
+	int bPSRxBeacon;
 
     // 802.11 MAC specific
     unsigned int                        uCurrRSSI;
@@ -561,7 +561,7 @@ typedef struct __device_info {
 
 
     //Antenna Diversity
-    BOOL                        bTxRxAntInv;
+	int bTxRxAntInv;
     DWORD                       dwRxAntennaSel;
     DWORD                       dwTxAntennaSel;
     BYTE                        byAntennaCount;
@@ -575,8 +575,8 @@ typedef struct __device_info {
     struct timer_list           TimerSQ3Tmax2;
     struct timer_list           TimerSQ3Tmax3;
 
-    BOOL                        bDiversityRegCtlON;
-    BOOL                        bDiversityEnable;
+	int bDiversityRegCtlON;
+	int bDiversityEnable;
     unsigned long                       ulDiversityNValue;
     unsigned long                       ulDiversityMValue;
     BYTE                        byTMax;
@@ -648,7 +648,7 @@ typedef struct __device_info {
     BYTE                        byShortRetryLimit;
     BYTE                        byLongRetryLimit;
     CARD_OP_MODE                eOPMode;
-    BOOL                        bBSSIDFilter;
+	int bBSSIDFilter;
     WORD                        wMaxTransmitMSDULifetime;
     BYTE                        abyBSSID[ETH_ALEN];
     BYTE                        abyDesireBSSID[ETH_ALEN];
@@ -660,46 +660,46 @@ typedef struct __device_info {
 
     DWORD                       dwMaxReceiveLifetime;       // dot11MaxReceiveLifetime
 
-    BOOL                        bCCK;
-    BOOL                        bEncryptionEnable;
-    BOOL                        bLongHeader;
-    BOOL                        bSoftwareGenCrcErr;
-    BOOL                        bShortSlotTime;
-    BOOL                        bProtectMode;
-    BOOL                        bNonERPPresent;
-    BOOL                        bBarkerPreambleMd;
+	int bCCK;
+	int bEncryptionEnable;
+	int bLongHeader;
+	int bSoftwareGenCrcErr;
+	int bShortSlotTime;
+	int bProtectMode;
+	int bNonERPPresent;
+	int bBarkerPreambleMd;
 
     BYTE                        byERPFlag;
     WORD                        wUseProtectCntDown;
 
-    BOOL                        bRadioControlOff;
-    BOOL                        bRadioOff;
+	int bRadioControlOff;
+	int bRadioOff;
 
     // Power save
-    BOOL                        bEnablePSMode;
+	int bEnablePSMode;
     WORD                        wListenInterval;
-    BOOL                        bPWBitOn;
+	int bPWBitOn;
     WMAC_POWER_MODE             ePSMode;
     unsigned long                       ulPSModeWaitTx;
-    BOOL                        bPSModeTxBurst;
+	int bPSModeTxBurst;
 
     // Beacon releated
     WORD                    wSeqCounter;
-    BOOL                    bBeaconBufReady;
-    BOOL                    bBeaconSent;
-    BOOL                    bFixRate;
+	int bBeaconBufReady;
+	int bBeaconSent;
+	int bFixRate;
     BYTE                    byCurrentCh;
     unsigned int                    uScanTime;
 
     CMD_STATE               eCommandState;
 
     CMD_CODE                eCommand;
-    BOOL                    bBeaconTx;
+	int bBeaconTx;
     BYTE                    byScanBBType;
 
-    BOOL                    bStopBeacon;
-    BOOL                    bStopDataPkt;
-    BOOL                    bStopTx0Pkt;
+	int bStopBeacon;
+	int bStopDataPkt;
+	int bStopTx0Pkt;
     unsigned int                    uAutoReConnectTime;
     unsigned int                    uIsroamingTime;
 
@@ -709,22 +709,22 @@ typedef struct __device_info {
     unsigned int                    uCmdDequeueIdx;
     unsigned int                    uCmdEnqueueIdx;
     unsigned int                    cbFreeCmdQueue;
-    BOOL                    bCmdRunning;
-    BOOL                    bCmdClear;
-    BOOL                    bNeedRadioOFF;
+	int bCmdRunning;
+	int bCmdClear;
+	int bNeedRadioOFF;
 
-    BOOL                    bEnableRoaming;
-    BOOL                    bIsRoaming;
-    BOOL                    bFastRoaming;
+	int bEnableRoaming;
+	int bIsRoaming;
+	int bFastRoaming;
     BYTE                    bSameBSSMaxNum;
     BYTE                    bSameBSSCurNum;
-    BOOL                    bRoaming;
-    BOOL                    b11hEable;
+	int bRoaming;
+	int b11hEable;
     unsigned long                   ulTxPower;
 
     // Encryption
     NDIS_802_11_WEP_STATUS  eEncryptionStatus;
-    BOOL                    bTransmitKey;
+	int bTransmitKey;
 
 //mike add :save old Encryption
     NDIS_802_11_WEP_STATUS  eOldEncryptionStatus;
@@ -737,7 +737,7 @@ typedef struct __device_info {
     BYTE                    abyPRNG[WLAN_WEPMAX_KEYLEN+3];
     BYTE                    byKeyIndex;
 
-    BOOL                    bAES;
+	int bAES;
     BYTE                    byCntMeasure;
 
     unsigned int                    uKeyLength;
@@ -745,20 +745,20 @@ typedef struct __device_info {
 
     // for AP mode
     unsigned int                    uAssocCount;
-    BOOL                    bMoreData;
+	int bMoreData;
 
     // QoS
-    BOOL                    bGrpAckPolicy;
+	int bGrpAckPolicy;
 
 
     BYTE                    byAutoFBCtrl;
 
-    BOOL                    bTxMICFail;
-    BOOL                    bRxMICFail;
+	int bTxMICFail;
+	int bRxMICFail;
 
 
     // For Update BaseBand VGA Gain Offset
-    BOOL                    bUpdateBBVGA;
+	int bUpdateBBVGA;
     unsigned int                    uBBVGADiffCount;
     BYTE                    byBBVGANew;
     BYTE                    byBBVGACurrent;
@@ -769,7 +769,7 @@ typedef struct __device_info {
     BYTE                    byBBPreEDIndex;
 
 
-    BOOL                    bRadioCmd;
+	int bRadioCmd;
     DWORD                   dwDiagRefCount;
 
     // For FOE Tuning
@@ -790,10 +790,10 @@ typedef struct __device_info {
 
      struct timer_list       sTimerTxData;
      unsigned long                       nTxDataTimeCout;
-     BOOL  fTxDataInSleep;
-     BOOL  IsTxDataTrigger;
+	int fTxDataInSleep;
+	int IsTxDataTrigger;
 
-    BOOL  fWPA_Authened;           //is WPA/WPA-PSK or WPA2/WPA2-PSK authen??
+	int fWPA_Authened;           //is WPA/WPA-PSK or WPA2/WPA2-PSK authen??
     BYTE            byReAssocCount;   //mike add:re-association retry times!
     BYTE            byLinkWaitCount;
 
@@ -809,38 +809,38 @@ typedef struct __device_info {
 
 
     // for 802.11h
-    BOOL                    b11hEnable;
+	int b11hEnable;
 
-    BOOL                    bChannelSwitch;
+	int bChannelSwitch;
     BYTE                    byNewChannel;
     BYTE                    byChannelSwitchCount;
 
     //WPA supplicant daemon
 	struct net_device       *wpadev;
-	BOOL                    bWPADEVUp;
+	int bWPADEVUp;
     struct sk_buff          *skb;
     //--
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-        BOOL                 bwextstep0;
-        BOOL                 bwextstep1;
-        BOOL                 bwextstep2;
-        BOOL                 bwextstep3;
-        BOOL                 bWPASuppWextEnabled;
+	int bwextstep0;
+	int bwextstep1;
+	int bwextstep2;
+	int bwextstep3;
+	int bWPASuppWextEnabled;
 #endif
 
 #ifdef HOSTAP
     // user space daemon: hostapd, is used for HOSTAP
-	BOOL                    bEnableHostapd;
-	BOOL                    bEnable8021x;
-	BOOL                    bEnableHostWEP;
+	int bEnableHostapd;
+	int bEnable8021x;
+	int bEnableHostWEP;
 	struct net_device       *apdev;
 	int (*tx_80211)(struct sk_buff *skb, struct net_device *dev);
 #endif
     unsigned int                    uChannel;
 
 	struct iw_statistics	wstats;		// wireless stats
-    BOOL                    bCommit;
+	int bCommit;
 
 } DEVICE_INFO, *PSDevice;
 
@@ -902,6 +902,6 @@ typedef struct __device_info {
 /* BOOL device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb,
  *                       unsigned int uNodeIndex);
  */
-BOOL device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF);
+int device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF);
 
 #endif
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index c0edf97..f5bbb89 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -90,12 +90,12 @@ s_vProcessRxMACHeader (
       PSDevice pDevice,
       PBYTE pbyRxBufferAddr,
       unsigned int cbPacketSize,
-      BOOL bIsWEP,
-      BOOL bExtIV,
+	int bIsWEP,
+	int bExtIV,
      unsigned int *pcbHeadSize
     );
 
-static BOOL s_bAPModeRxCtl(
+static int s_bAPModeRxCtl(
      PSDevice pDevice,
      PBYTE    pbyFrame,
      signed int      iSANodeIndex
@@ -103,7 +103,7 @@ static BOOL s_bAPModeRxCtl(
 
 
 
-static BOOL s_bAPModeRxData (
+static int s_bAPModeRxData(
      PSDevice pDevice,
      struct sk_buff *skb,
      unsigned int     FrameSize,
@@ -113,7 +113,7 @@ static BOOL s_bAPModeRxData (
     );
 
 
-static BOOL s_bHandleRxEncryption(
+static int s_bHandleRxEncryption(
      PSDevice     pDevice,
      PBYTE        pbyFrame,
      unsigned int         FrameSize,
@@ -125,13 +125,13 @@ static BOOL s_bHandleRxEncryption(
      PDWORD      pdwRxTSC47_16
     );
 
-static BOOL s_bHostWepRxEncryption(
+static int s_bHostWepRxEncryption(
 
      PSDevice     pDevice,
      PBYTE        pbyFrame,
      unsigned int         FrameSize,
      PBYTE        pbyRsr,
-     BOOL         bOnFly,
+	int bOnFly,
      PSKeyItem    pKey,
      PBYTE       pbyNewRsr,
     int *       pbExtIV,
@@ -165,8 +165,8 @@ s_vProcessRxMACHeader (
       PSDevice pDevice,
       PBYTE pbyRxBufferAddr,
       unsigned int cbPacketSize,
-      BOOL bIsWEP,
-      BOOL bExtIV,
+	int bIsWEP,
+	int bExtIV,
      unsigned int *pcbHeadSize
     )
 {
@@ -309,17 +309,10 @@ s_vGetDASA (
     *pcbHeaderSize = cbHeaderSize;
 }
 
-
-
-
-BOOL
-RXbBulkInProcessData (
-     PSDevice         pDevice,
-     PRCB             pRCB,
-     unsigned long            BytesToIndicate
-    )
+int RXbBulkInProcessData(PSDevice pDevice,
+			  PRCB pRCB,
+			  unsigned long BytesToIndicate)
 {
-
     struct net_device_stats* pStats=&pDevice->stats;
     struct sk_buff* skb;
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
@@ -330,7 +323,7 @@ RXbBulkInProcessData (
     PBYTE           pbyRSSI;
     PQWORD          pqwTSFTime;
     PBYTE           pbyFrame;
-    BOOL            bDeFragRx = FALSE;
+	int bDeFragRx = FALSE;
     unsigned int            cbHeaderOffset;
     unsigned int            FrameSize;
     WORD            wEtherType = 0;
@@ -349,8 +342,8 @@ RXbBulkInProcessData (
     SKeyItem        STempKey;
     // 802.11h RPI
     /* signed long ldBm = 0; */
-    BOOL            bIsWEP = FALSE;
-    BOOL            bExtIV = FALSE;
+	int bIsWEP = FALSE;
+	int bExtIV = FALSE;
     DWORD           dwWbkStatus;
     PRCB            pRCBIndicate = pRCB;
     PBYTE           pbyDAddress;
@@ -358,7 +351,7 @@ RXbBulkInProcessData (
     BYTE            abyVaildRate[MAX_RATE] = {2,4,11,22,12,18,24,36,48,72,96,108};
     WORD            wPLCPwithPadding;
     PS802_11Header  pMACHeader;
-    BOOL            bRxeapol_key = FALSE;
+	int bRxeapol_key = FALSE;
 
 
 
@@ -491,7 +484,7 @@ RXbBulkInProcessData (
 
 
     if (IS_FC_WEP(pbyFrame)) {
-        BOOL     bRxDecryOK = FALSE;
+	int bRxDecryOK = FALSE;
 
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"rx WEP pkt\n");
         bIsWEP = TRUE;
@@ -1014,7 +1007,7 @@ RXbBulkInProcessData (
 }
 
 
-static BOOL s_bAPModeRxCtl (
+static int s_bAPModeRxCtl(
      PSDevice pDevice,
      PBYTE    pbyFrame,
      signed int      iSANodeIndex
@@ -1124,7 +1117,7 @@ static BOOL s_bAPModeRxCtl (
 
 }
 
-static BOOL s_bHandleRxEncryption (
+static int s_bHandleRxEncryption(
      PSDevice     pDevice,
      PBYTE        pbyFrame,
      unsigned int         FrameSize,
@@ -1270,12 +1263,12 @@ static BOOL s_bHandleRxEncryption (
 }
 
 
-static BOOL s_bHostWepRxEncryption (
+static int s_bHostWepRxEncryption(
      PSDevice     pDevice,
      PBYTE        pbyFrame,
      unsigned int         FrameSize,
      PBYTE        pbyRsr,
-     BOOL         bOnFly,
+	int bOnFly,
      PSKeyItem    pKey,
      PBYTE       pbyNewRsr,
     int *       pbExtIV,
@@ -1402,7 +1395,7 @@ static BOOL s_bHostWepRxEncryption (
 
 
 
-static BOOL s_bAPModeRxData (
+static int s_bAPModeRxData(
      PSDevice pDevice,
      struct sk_buff *skb,
      unsigned int     FrameSize,
@@ -1413,8 +1406,8 @@ static BOOL s_bAPModeRxData (
 
 {
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    BOOL                bRelayAndForward = FALSE;
-    BOOL                bRelayOnly = FALSE;
+	int bRelayAndForward = FALSE;
+	int bRelayOnly = FALSE;
     BYTE                byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
     WORD                wAID;
 
@@ -1523,7 +1516,7 @@ void RXvWorkItem(void *Context)
 void
 RXvFreeRCB(
      PRCB pRCB,
-     BOOL bReAllocSkb
+	int bReAllocSkb
     )
 {
     PSDevice pDevice = (PSDevice)pRCB->pDevice;
@@ -1565,7 +1558,7 @@ void RXvMngWorkItem(void *Context)
     PSDevice pDevice = (PSDevice) Context;
     PRCB            pRCB=NULL;
     PSRxMgmtPacket  pRxPacket;
-    BOOL            bReAllocSkb = FALSE;
+	int bReAllocSkb = FALSE;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Mng Thread\n");
 
diff --git a/drivers/staging/vt6656/dpc.h b/drivers/staging/vt6656/dpc.h
index d4fca43..499800d 100644
--- a/drivers/staging/vt6656/dpc.h
+++ b/drivers/staging/vt6656/dpc.h
@@ -48,10 +48,10 @@ void RXvMngWorkItem(void *Context);
 void
 RXvFreeRCB(
      PRCB pRCB,
-     BOOL bReAllocSkb
+	int bReAllocSkb
     );
 
-BOOL
+int
 RXbBulkInProcessData(
      PSDevice         pDevice,
      PRCB             pRCB,
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 8c8126a..47c92c7 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -55,8 +55,7 @@ static int          msglevel                =MSG_LEVEL_INFO;
 
 /*---------------------  Export Functions  --------------------------*/
 
-
-BOOL
+int
 FIRMWAREbDownload(
      PSDevice pDevice
     )
@@ -64,7 +63,7 @@ FIRMWAREbDownload(
 	const struct firmware *fw;
 	int NdisStatus;
 	void *pBuffer = NULL;
-	BOOL result = FALSE;
+	int result = FALSE;
 	u16 wLength;
 	int ii;
 
@@ -116,7 +115,7 @@ out:
 }
 MODULE_FIRMWARE(FIRMWARE_NAME);
 
-BOOL
+int
 FIRMWAREbBrach2Sram(
      PSDevice pDevice
     )
@@ -140,8 +139,7 @@ FIRMWAREbBrach2Sram(
     }
 }
 
-
-BOOL
+int
 FIRMWAREbCheckVersion(
      PSDevice pDevice
     )
diff --git a/drivers/staging/vt6656/firmware.h b/drivers/staging/vt6656/firmware.h
index b2f5b58..37a0e7c 100644
--- a/drivers/staging/vt6656/firmware.h
+++ b/drivers/staging/vt6656/firmware.h
@@ -41,17 +41,17 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-BOOL
+int
 FIRMWAREbDownload(
      PSDevice pDevice
     );
 
-BOOL
+int
 FIRMWAREbBrach2Sram(
      PSDevice pDevice
     );
 
-BOOL
+int
 FIRMWAREbCheckVersion(
      PSDevice pDevice
     );
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 51b5adf..97cb8da 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -474,7 +474,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 	int     ret = 0;
 	int     iNodeIndex = -1;
 	int     ii;
-	BOOL    bKeyTableFull = FALSE;
+	int bKeyTableFull = FALSE;
 	WORD    wKeyCtl = 0;
 
 
-- 
1.7.4.4

