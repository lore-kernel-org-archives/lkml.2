Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1LBV63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 16:58:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37657 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab1LBV62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 16:58:28 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 3/3] staging: vt6655: card.c, srom.c, vntwifi.c: Code cleanup
Date: Fri,  2 Dec 2011 19:58:12 +0000
Message-Id: <1322855892-6400-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes commented code, useless comments, blank lines and fix
coding style of the headers of functions.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6655/card.c    |  115 +---------------------
 drivers/staging/vt6655/srom.c    |  198 ++++++--------------------------------
 drivers/staging/vt6655/vntwifi.h |   35 -------
 3 files changed, 36 insertions(+), 312 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 2721e07..d289975 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -58,9 +58,6 @@
 #include "country.h"
 #include "channel.h"
 
-/*---------------------  Static Definitions -------------------------*/
-
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =MSG_LEVEL_INFO;
 
 #define C_SIFS_A        16      // micro sec.
@@ -88,16 +85,9 @@ static unsigned char abyDefaultSuppRatesA[] = {WLAN_EID_SUPP_RATES, 8, 0x0C, 0x1
                                                               //1M,   2M,   5M,  11M,
 static unsigned char abyDefaultSuppRatesB[] = {WLAN_EID_SUPP_RATES, 4, 0x02, 0x04, 0x0B, 0x16};
 
-
-/*---------------------  Static Variables  --------------------------*/
-
-
 const unsigned short cwRXBCNTSFOff[MAX_RATE] =
 {17, 17, 17, 17, 34, 23, 17, 11, 8, 5, 4, 3};
 
-
-/*---------------------  Static Functions  --------------------------*/
-
 static
 void
 s_vCaculateOFDMRParameter(
@@ -107,22 +97,8 @@ s_vCaculateOFDMRParameter(
     unsigned char *pbyRsvTime
     );
 
-
-/*---------------------  Export Functions  --------------------------*/
-
 /*
- * Description: Caculate TxRate and RsvTime fields for RSPINF in OFDM mode.
- *
- * Parameters:
- *  In:
- *      wRate           - Tx Rate
- *      byPktType       - Tx Packet type
- *  Out:
- *      pbyTxRate       - pointer to RSPINF TxRate field
- *      pbyRsvTime      - pointer to RSPINF RsvTime field
- *
- * Return Value: none
- *
+ * Caculate TxRate and RsvTime fields for RSPINF in OFDM mode
  */
 static
 void
@@ -225,19 +201,8 @@ s_vCaculateOFDMRParameter (
     }
 }
 
-
-
 /*
- * Description: Set RSPINF
- *
- * Parameters:
- *  In:
- *      pDevice             - The adapter to be set
- *  Out:
- *      none
- *
- * Return Value: None.
- *
+ * Set RSPINF
  */
 static
 void
@@ -351,51 +316,8 @@ s_vSetRSPINF (PSDevice pDevice, CARD_PHY_TYPE ePHYType, void *pvSupportRateIEs,
     MACvSelectPage0(pDevice->PortOffset);
 }
 
-/*---------------------  Export Functions  --------------------------*/
-
 /*
- * Description: Card Send packet function
- *
- * Parameters:
- *  In:
- *      pDeviceHandler      - The adapter to be set
- *      pPacket             - Packet buffer pointer
- *      ePktType            - Packet type
- *      uLength             - Packet length
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-/*
-bool CARDbSendPacket (void *pDeviceHandler, void *pPacket, CARD_PKT_TYPE ePktType, unsigned int uLength)
-{
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    if (ePktType == PKT_TYPE_802_11_MNG) {
-        return TXbTD0Send(pDevice, pPacket, uLength);
-    } else if (ePktType == PKT_TYPE_802_11_BCN) {
-        return TXbBeaconSend(pDevice, pPacket, uLength);
-    } if (ePktType == PKT_TYPE_802_11_DATA) {
-        return TXbTD1Send(pDevice, pPacket, uLength);
-    }
-
-    return (true);
-}
-*/
-
-
-/*
- * Description: Get Card short preamble option value
- *
- * Parameters:
- *  In:
- *      pDevice             - The adapter to be set
- *  Out:
- *      none
- *
- * Return Value: true if short preamble; otherwise false
- *
+ * Get Card short preamble option value
  */
 bool CARDbIsShortPreamble (void *pDeviceHandler)
 {
@@ -407,16 +329,7 @@ bool CARDbIsShortPreamble (void *pDeviceHandler)
 }
 
 /*
- * Description: Get Card short slot time option value
- *
- * Parameters:
- *  In:
- *      pDevice             - The adapter to be set
- *  Out:
- *      none
- *
- * Return Value: true if short slot time; otherwise false
- *
+ * Get Card short slot time option value
  */
 bool CARDbIsShorSlotTime (void *pDeviceHandler)
 {
@@ -424,7 +337,6 @@ bool CARDbIsShorSlotTime (void *pDeviceHandler)
     return(pDevice->bShortSlotTime);
 }
 
-
 /*
  * Description: Update IFS
  *
@@ -445,11 +357,9 @@ bool CARDbSetPhyParameter (void *pDeviceHandler, CARD_PHY_TYPE ePHYType, unsigne
     unsigned char bySIFS = 0;
     unsigned char byDIFS = 0;
     unsigned char byData;
-//    PWLAN_IE_SUPP_RATES pRates = NULL;
     PWLAN_IE_SUPP_RATES pSupportRates = (PWLAN_IE_SUPP_RATES) pvSupportRateIEs;
     PWLAN_IE_SUPP_RATES pExtSupportRates = (PWLAN_IE_SUPP_RATES) pvExtSupportRateIEs;
 
-
     //Set SIFS, DIFS, EIFS, SlotTime, CwMin
     if (ePHYType == PHY_TYPE_11A) {
         if (pSupportRates == NULL) {
@@ -644,20 +554,9 @@ bool CARDbUpdateTSF (void *pDeviceHandler, unsigned char byRxRate, QWORD qwBSSTi
     return(true);
 }
 
-
 /*
- * Description: Set NIC TSF counter for first Beacon time
- *              Get NEXTTBTT from adjusted TSF and Beacon Interval
- *
- * Parameters:
- *  In:
- *      pDevice         - The adapter to be set.
- *      wBeaconInterval - Beacon Interval
- *  Out:
- *      none
- *
- * Return Value: true if succeed; otherwise false
- *
+ * Set NIC TSF counter for first Beacon time
+ * Get NEXTTBTT from adjusted TSF and Beacon Interval
  */
 bool CARDbSetBeaconPeriod (void *pDeviceHandler, unsigned short wBeaconInterval)
 {
@@ -698,8 +597,6 @@ bool CARDbSetBeaconPeriod (void *pDeviceHandler, unsigned short wBeaconInterval)
     return(true);
 }
 
-
-
 /*
  * Description: Card Stop Hardware Tx
  *
diff --git a/drivers/staging/vt6655/srom.c b/drivers/staging/vt6655/srom.c
index 6a0a232..e973d4d 100644
--- a/drivers/staging/vt6655/srom.c
+++ b/drivers/staging/vt6655/srom.c
@@ -48,35 +48,11 @@
 #include "mac.h"
 #include "srom.h"
 
-/*---------------------  Static Definitions -------------------------*/
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
-
-
-
 /*
- * Description: Read a byte from EEPROM, by MAC I2C
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *  Out:
- *      none
- *
- * Return Value: data read
- *
+ * Read a byte from EEPROM, by MAC I2C
  */
-unsigned char SROMbyReadEmbedded(unsigned long dwIoBase, unsigned char byContntOffset)
+unsigned char SROMbyReadEmbedded(unsigned long dwIoBase,
+				 unsigned char byContntOffset)
 {
     unsigned short wDelay, wNoACK;
     unsigned char byWait;
@@ -110,22 +86,11 @@ unsigned char SROMbyReadEmbedded(unsigned long dwIoBase, unsigned char byContntO
     return byData;
 }
 
-
 /*
- * Description: Write a byte to EEPROM, by MAC I2C
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      wData           - data to write
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
+ * Write a byte to EEPROM, by MAC I2C
  */
-bool SROMbWriteEmbedded(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byData)
+bool SROMbWriteEmbedded(unsigned long dwIoBase, unsigned char byContntOffset,
+			unsigned char byData)
 {
     unsigned short wDelay, wNoACK;
     unsigned char byWait;
@@ -163,22 +128,11 @@ bool SROMbWriteEmbedded(unsigned long dwIoBase, unsigned char byContntOffset, un
     return true;
 }
 
-
 /*
- * Description: Turn bits on in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byBits          - bits to turn on
- *  Out:
- *      none
- *
- * Return Value: none
- *
+ * Turn bits on in eeprom
  */
-void SROMvRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byBits)
+void SROMvRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset,
+		    unsigned char byBits)
 {
     unsigned char byOrgData;
 
@@ -186,20 +140,11 @@ void SROMvRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsign
     SROMbWriteEmbedded(dwIoBase, byContntOffset,(unsigned char)(byOrgData | byBits));
 }
 
-
 /*
- * Description: Turn bits off in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byBits          - bits to turn off
- *  Out:
- *      none
- *
+ * Turn bits off in eeprom
  */
-void SROMvRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byBits)
+void SROMvRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset,
+		     unsigned char byBits)
 {
     unsigned char byOrgData;
 
@@ -207,22 +152,11 @@ void SROMvRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, unsig
     SROMbWriteEmbedded(dwIoBase, byContntOffset,(unsigned char)(byOrgData & (~byBits)));
 }
 
-
 /*
- * Description: Test if bits on in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byTestBits      - bits to test
- *  Out:
- *      none
- *
- * Return Value: true if all test bits on; otherwise false
- *
+ * Test if bits on in eeprom
  */
-bool SROMbIsRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
+bool SROMbIsRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset,
+		      unsigned char byTestBits)
 {
     unsigned char byOrgData;
 
@@ -230,22 +164,11 @@ bool SROMbIsRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsi
     return (byOrgData & byTestBits) == byTestBits;
 }
 
-
 /*
- * Description: Test if bits off in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byTestBits      - bits to test
- *  Out:
- *      none
- *
- * Return Value: true if all test bits off; otherwise false
- *
+ * Test if bits off in eeprom
  */
-bool SROMbIsRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
+bool SROMbIsRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset,
+		       unsigned char byTestBits)
 {
     unsigned char byOrgData;
 
@@ -253,18 +176,8 @@ bool SROMbIsRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, uns
     return !(byOrgData & byTestBits);
 }
 
-
 /*
- * Description: Read all contents of eeprom to buffer
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *  Out:
- *      pbyEepromRegs   - EEPROM content Buffer
- *
- * Return Value: none
- *
+ * Read all contents of eeprom to buffer
  */
 void SROMvReadAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs)
 {
@@ -277,21 +190,11 @@ void SROMvReadAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs)
     }
 }
 
-
 /*
- * Description: Write all contents of buffer to eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      pbyEepromRegs   - EEPROM content Buffer
- *  Out:
- *      none
- *
- * Return Value: none
- *
+ * Write all contents of buffer to eeprom
  */
-void SROMvWriteAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs)
+void SROMvWriteAllContents(unsigned long dwIoBase,
+			   unsigned char *pbyEepromRegs)
 {
     int     ii;
 
@@ -302,20 +205,11 @@ void SROMvWriteAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs)
     }
 }
 
-
 /*
- * Description: Read Ethernet Address from eeprom to buffer
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *  Out:
- *      pbyEtherAddress - Ethernet Address buffer
- *
- * Return Value: none
- *
+ * Read Ethernet Address from eeprom to buffer
  */
-void SROMvReadEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddress)
+void SROMvReadEtherAddress(unsigned long dwIoBase,
+			   unsigned char *pbyEtherAddress)
 {
     unsigned char ii;
 
@@ -326,21 +220,11 @@ void SROMvReadEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddres
     }
 }
 
-
 /*
- * Description: Write Ethernet Address from buffer to eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      pbyEtherAddress - Ethernet Address buffer
- *  Out:
- *      none
- *
- * Return Value: none
- *
+ * Write Ethernet Address from buffer to eeprom
  */
-void SROMvWriteEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddress)
+void SROMvWriteEtherAddress(unsigned long dwIoBase,
+			    unsigned char *pbyEtherAddress)
 {
     unsigned char ii;
 
@@ -351,18 +235,8 @@ void SROMvWriteEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddre
     }
 }
 
-
 /*
- * Description: Read Sub_VID and Sub_SysId from eeprom to buffer
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *  Out:
- *      pdwSubSysVenId  - Sub_VID and Sub_SysId read
- *
- * Return Value: none
- *
+ * Read Sub_VID and Sub_SysId from eeprom to buffer
  */
 void SROMvReadSubSysVenId(unsigned long dwIoBase, unsigned long *pdwSubSysVenId)
 {
@@ -378,22 +252,12 @@ void SROMvReadSubSysVenId(unsigned long dwIoBase, unsigned long *pdwSubSysVenId)
 }
 
 /*
- * Description: Auto Load EEPROM to MAC register
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *  Out:
- *      none
- *
- * Return Value: true if success; otherwise false
- *
+ * Auto Load EEPROM to MAC register
  */
 bool SROMbAutoLoad(unsigned long dwIoBase)
 {
     unsigned char byWait;
     int     ii;
-
     unsigned char byOrg;
 
     VNSvInPortB(dwIoBase + MAC_REG_I2MCFG, &byOrg);
@@ -416,5 +280,3 @@ bool SROMbAutoLoad(unsigned long dwIoBase)
         return false;
     return true;
 }
-
-
diff --git a/drivers/staging/vt6655/vntwifi.h b/drivers/staging/vt6655/vntwifi.h
index f4327ab..efd1785 100644
--- a/drivers/staging/vt6655/vntwifi.h
+++ b/drivers/staging/vt6655/vntwifi.h
@@ -35,7 +35,6 @@
 #include "card.h"
 #include "wpa2.h"
 
-/*---------------------  Export Definitions -------------------------*/
 #define RATE_1M         0
 #define RATE_2M         1
 #define RATE_5M         2
@@ -91,7 +90,6 @@ typedef enum tagWMAC_ENCRYPTION_MODE {
 } WMAC_ENCRYPTION_MODE, *PWMAC_ENCRYPTION_MODE;
 
 // Pre-configured Mode (from XP)
-
 typedef enum tagWMAC_CONFIG_MODE {
 
     WMAC_CONFIG_ESS_STA = 0,
@@ -101,8 +99,6 @@ typedef enum tagWMAC_CONFIG_MODE {
 
 } WMAC_CONFIG_MODE, *PWMAC_CONFIG_MODE;
 
-
-
 typedef enum tagWMAC_POWER_MODE {
 
     WMAC_POWER_CAM,
@@ -129,17 +125,6 @@ typedef enum tagWMAC_POWER_MODE {
 #define VNTWIFIbIsESS(wCapInfo)                         \
         WLAN_GET_CAP_INFO_ESS(wCapInfo)                 \
 
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-
-/*---------------------  Export Types  ------------------------------*/
-
-
-/*---------------------  Export Functions  --------------------------*/
-
 void
 VNTWIFIvSetIBSSParameter (
     void *pMgmtHandle,
@@ -218,8 +203,6 @@ VNTWIFIvGetNextBSS (
     void **pvNextBSS
     );
 
-
-
 void
 VNTWIFIvUpdateNodeTxCounter(
     void *pMgmtHandle,
@@ -229,7 +212,6 @@ VNTWIFIvUpdateNodeTxCounter(
     unsigned char *pbyTxFailCount
     );
 
-
 void
 VNTWIFIvGetTxRate(
     void *pMgmtHandle,
@@ -239,13 +221,6 @@ VNTWIFIvGetTxRate(
     unsigned char *pbyCCKBasicRate,
     unsigned char *pbyOFDMBasicRate
     );
-/*
-bool
-VNTWIFIbInit(
-    void *pAdapterHandler,
-    void **pMgmtHandler
-    );
-*/
 
 unsigned char
 VNTWIFIbyGetKeyCypher(
@@ -253,9 +228,6 @@ VNTWIFIbyGetKeyCypher(
     bool bGroupKey
     );
 
-
-
-
 bool
 VNTWIFIbSetPMKIDCache (
     void *pMgmtObject,
@@ -296,12 +268,5 @@ VNTWIFIbChannelSwitch(
     void *pMgmtObject,
     unsigned char byNewChannel
     );
-/*
-bool
-VNTWIFIbRadarPresent(
-    void *pMgmtObject,
-    unsigned char byChannel
-    );
-*/
 
 #endif //__VNTWIFI_H__
-- 
1.7.4.4

