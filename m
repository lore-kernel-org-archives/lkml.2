Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab1GZHgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:36:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:17578 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1GZHgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:36:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,268,1309762800"; 
   d="scan'208";a="31994251"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 2/2] staging: vt6656: use %pM for printing MACs
Date: Tue, 26 Jul 2011 10:35:31 +0300
Message-Id: <1ddf4a737c2c6485b61c3d94e07306b39e25dc1a.1311665655.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <f3732234b64aa8f5a7ac7992451d1c60c672c3b9.1311665655.git.andriy.shevchenko@linux.intel.com>
References: <1311258256.1663.35.camel@Joe-Laptop>
 <f3732234b64aa8f5a7ac7992451d1c60c672c3b9.1311665655.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <f3732234b64aa8f5a7ac7992451d1c60c672c3b9.1311665655.git.andriy.shevchenko@linux.intel.com>
References: <f3732234b64aa8f5a7ac7992451d1c60c672c3b9.1311665655.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/vt6656/dpc.c      |   30 ++++------------------
 drivers/staging/vt6656/main_usb.c |   11 +-------
 drivers/staging/vt6656/wmgr.c     |   49 +++++++-----------------------------
 3 files changed, 18 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index cb817ce..c0edf97 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1109,30 +1109,12 @@ static BOOL s_bAPModeRxCtl (
                                        &Status
                                        );
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDeAuthenBeginSta 3\n");
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BSSID:%02x-%02x-%02x=%02x-%02x-%02x \n",
-                                p802_11Header->abyAddr3[0],
-                                p802_11Header->abyAddr3[1],
-                                p802_11Header->abyAddr3[2],
-                                p802_11Header->abyAddr3[3],
-                                p802_11Header->abyAddr3[4],
-                                p802_11Header->abyAddr3[5]
-                               );
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR2:%02x-%02x-%02x=%02x-%02x-%02x \n",
-                                p802_11Header->abyAddr2[0],
-                                p802_11Header->abyAddr2[1],
-                                p802_11Header->abyAddr2[2],
-                                p802_11Header->abyAddr2[3],
-                                p802_11Header->abyAddr2[4],
-                                p802_11Header->abyAddr2[5]
-                               );
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR1:%02x-%02x-%02x=%02x-%02x-%02x \n",
-                                p802_11Header->abyAddr1[0],
-                                p802_11Header->abyAddr1[1],
-                                p802_11Header->abyAddr1[2],
-                                p802_11Header->abyAddr1[3],
-                                p802_11Header->abyAddr1[4],
-                                p802_11Header->abyAddr1[5]
-                               );
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BSSID:%pM\n",
+				p802_11Header->abyAddr3);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR2:%pM\n",
+				p802_11Header->abyAddr2);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR1:%pM\n",
+				p802_11Header->abyAddr1);
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: wFrameCtl= %x\n", p802_11Header->wFrameCtl );
                     return TRUE;
             }
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e18efd4..73a0838 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -611,17 +611,10 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
         // if exist SW network address, use SW network address.
 
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %02x-%02x-%02x=%02x-%02x-%02x\n",
-            pDevice->abyCurrentNetAddr[0],
-            pDevice->abyCurrentNetAddr[1],
-            pDevice->abyCurrentNetAddr[2],
-            pDevice->abyCurrentNetAddr[3],
-            pDevice->abyCurrentNetAddr[4],
-            pDevice->abyCurrentNetAddr[5]);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %pM\n",
+		pDevice->abyCurrentNetAddr);
     }
 
-
-
     // Set BB and packet type at the same time.
     // Set Short Slot Time, xIFS, and RSPINF.
     if (pDevice->byBBType == BB_TYPE_11A) {
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index d67748f..f08e2d1 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2477,14 +2477,8 @@ void vMgrCreateOwnIBSS(void *hDeviceContext,
     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
         // AP mode BSSID = MAC addr
         memcpy(pMgmt->abyCurrBSSID, pMgmt->abyMACAddr, WLAN_ADDR_LEN);
-        DBG_PRT(MSG_LEVEL_INFO, KERN_INFO"AP beacon created BSSID:%02x-%02x-%02x-%02x-%02x-%02x \n",
-                      pMgmt->abyCurrBSSID[0],
-                      pMgmt->abyCurrBSSID[1],
-                      pMgmt->abyCurrBSSID[2],
-                      pMgmt->abyCurrBSSID[3],
-                      pMgmt->abyCurrBSSID[4],
-                      pMgmt->abyCurrBSSID[5]
-                    );
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO"AP beacon created BSSID:"
+			"%pM\n", pMgmt->abyCurrBSSID);
     }
 
     if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
@@ -2506,14 +2500,8 @@ void vMgrCreateOwnIBSS(void *hDeviceContext,
         pMgmt->abyCurrBSSID[0] |= IEEE_ADDR_UNIVERSAL;
 
 
-        DBG_PRT(MSG_LEVEL_INFO, KERN_INFO"Adhoc beacon created bssid:%02x-%02x-%02x-%02x-%02x-%02x \n",
-                      pMgmt->abyCurrBSSID[0],
-                      pMgmt->abyCurrBSSID[1],
-                      pMgmt->abyCurrBSSID[2],
-                      pMgmt->abyCurrBSSID[3],
-                      pMgmt->abyCurrBSSID[4],
-                      pMgmt->abyCurrBSSID[5]
-                    );
+		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO"Adhoc beacon created bssid:"
+			"%pM\n", pMgmt->abyCurrBSSID);
     }
 
     // set BSSID filter
@@ -2878,14 +2866,8 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
             ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
             memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Join IBSS ok:%02x-%02x-%02x-%02x-%02x-%02x \n",
-                  pMgmt->abyCurrBSSID[0],
-                  pMgmt->abyCurrBSSID[1],
-                  pMgmt->abyCurrBSSID[2],
-                  pMgmt->abyCurrBSSID[3],
-                  pMgmt->abyCurrBSSID[4],
-                  pMgmt->abyCurrBSSID[5]
-                );
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Join IBSS ok:%pM\n",
+			pMgmt->abyCurrBSSID);
             // Preamble type auto-switch: if AP can receive short-preamble cap,
             // and if registry setting is short preamble we can turn on too.
 
@@ -2983,13 +2965,8 @@ s_vMgrSynchBSS (
 
     memcpy(pMgmt->abyCurrBSSID, pCurr->abyBSSID, 6);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Sync:set CurrBSSID address = %02x-%02x-%02x=%02x-%02x-%02x\n",
-        pMgmt->abyCurrBSSID[0],
-        pMgmt->abyCurrBSSID[1],
-        pMgmt->abyCurrBSSID[2],
-        pMgmt->abyCurrBSSID[3],
-        pMgmt->abyCurrBSSID[4],
-        pMgmt->abyCurrBSSID[5]);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Sync:set CurrBSSID address = "
+		"%pM\n", pMgmt->abyCurrBSSID);
 
     if (pCurr->eNetworkTypeInUse == PHY_TYPE_11A) {
         if ((pDevice->eConfigPHYMode == PHY_TYPE_11A) ||
@@ -4334,14 +4311,8 @@ s_vMgrRxProbeRequest(
         sFrame.pBuf = (PBYTE)pRxPacket->p80211Header;
         vMgrDecodeProbeRequest(&sFrame);
 /*
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request rx:MAC addr:%02x-%02x-%02x=%02x-%02x-%02x \n",
-                  sFrame.pHdr->sA3.abyAddr2[0],
-                  sFrame.pHdr->sA3.abyAddr2[1],
-                  sFrame.pHdr->sA3.abyAddr2[2],
-                  sFrame.pHdr->sA3.abyAddr2[3],
-                  sFrame.pHdr->sA3.abyAddr2[4],
-                  sFrame.pHdr->sA3.abyAddr2[5]
-                );
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request rx:MAC addr:%pM\n",
+		sFrame.pHdr->sA3.abyAddr2);
 */
         if (sFrame.pSSID->len != 0) {
             if (sFrame.pSSID->len != ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len)
-- 
1.7.5.4

