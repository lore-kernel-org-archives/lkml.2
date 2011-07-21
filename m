Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1GUMms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:42:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:50182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab1GUMmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:42:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,240,1309762800"; 
   d="scan'208";a="32967950"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] staging: vt6655: simplify MAC printing by using %pMF
Date: Thu, 21 Jul 2011 15:42:15 +0300
Message-Id: <c8400fbc4ad3a91885fcda0e080be0ae80fcf077.1311252059.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/vt6655/device_main.c |   10 +-----
 drivers/staging/vt6655/dpc.c         |   30 ++++----------------
 drivers/staging/vt6655/wmgr.c        |   49 +++++++---------------------------
 3 files changed, 18 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 3d2a9ba..0a1aa03 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -815,14 +815,8 @@ else  CARDbRadioPowerOn(pDevice);
             pMgmt->eScanType = WMAC_SCAN_PASSIVE;
     // get Permanent network address
     SROMvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %02x-%02x-%02x=%02x-%02x-%02x\n",
-        pDevice->abyCurrentNetAddr[0],
-        pDevice->abyCurrentNetAddr[1],
-        pDevice->abyCurrentNetAddr[2],
-        pDevice->abyCurrentNetAddr[3],
-        pDevice->abyCurrentNetAddr[4],
-        pDevice->abyCurrentNetAddr[5]);
-
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %pMF\n",
+		pDevice->abyCurrentNetAddr);
 
     // reset Tx pointer
     CARDvSafeResetRx(pDevice);
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index cf0deac..8ebbdbc 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -1107,30 +1107,12 @@ static bool s_bAPModeRxCtl (
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
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BSSID:%pMF\n",
+				p802_11Header->abyAddr3);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR2:%pMF\n",
+				p802_11Header->abyAddr2);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR1:%pMF\n",
+				p802_11Header->abyAddr1);
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: wFrameCtl= %x\n", p802_11Header->wFrameCtl );
                     VNSvInPortB(pDevice->PortOffset + MAC_REG_RCR, &(pDevice->byRxMode));
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc:pDevice->byRxMode = %x\n", pDevice->byRxMode );
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index ab289c3..96cafd3 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -2521,14 +2521,8 @@ vMgrCreateOwnIBSS(
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
+	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO"AP beacon created BSSID:%pMF\n",
+		pMgmt->abyCurrBSSID);
     }
 
     if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
@@ -2550,14 +2544,8 @@ vMgrCreateOwnIBSS(
         pMgmt->abyCurrBSSID[0] |= IEEE_ADDR_UNIVERSAL;
 
 
-        DBG_PRT(MSG_LEVEL_INFO, KERN_INFO"Adhoc beacon created bssid:%02x-%02x-%02x-%02x-%02x-%02x \n",
-                      pMgmt->abyCurrBSSID[0],
-                      pMgmt->abyCurrBSSID[1],
-                      pMgmt->abyCurrBSSID[2],
-                      pMgmt->abyCurrBSSID[3],
-                      pMgmt->abyCurrBSSID[4],
-                      pMgmt->abyCurrBSSID[5]
-                    );
+	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO"Adhoc beacon created bssid:%pMF\n",
+		pMgmt->abyCurrBSSID);
     }
 
     // Set Capability Info
@@ -2887,14 +2875,8 @@ vMgrJoinBSSBegin(
 //            pDevice->bLinkPass = true;
 //            memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Join IBSS ok:%02x-%02x-%02x-%02x-%02x-%02x \n",
-                  pMgmt->abyCurrBSSID[0],
-                  pMgmt->abyCurrBSSID[1],
-                  pMgmt->abyCurrBSSID[2],
-                  pMgmt->abyCurrBSSID[3],
-                  pMgmt->abyCurrBSSID[4],
-                  pMgmt->abyCurrBSSID[5]
-                );
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Join IBSS ok:%pMF\n",
+			pMgmt->abyCurrBSSID);
             // Preamble type auto-switch: if AP can receive short-preamble cap,
             // and if registry setting is short preamble we can turn on too.
 
@@ -2984,13 +2966,8 @@ s_vMgrSynchBSS (
 
     MACvReadBSSIDAddress(pDevice->PortOffset, pMgmt->abyCurrBSSID);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Sync:set CurrBSSID address = %02x-%02x-%02x=%02x-%02x-%02x\n",
-        pMgmt->abyCurrBSSID[0],
-        pMgmt->abyCurrBSSID[1],
-        pMgmt->abyCurrBSSID[2],
-        pMgmt->abyCurrBSSID[3],
-        pMgmt->abyCurrBSSID[4],
-        pMgmt->abyCurrBSSID[5]);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Sync:set CurrBSSID address = "
+		"%pMF\n", pMgmt->abyCurrBSSID);
 
     if (pCurr->eNetworkTypeInUse == PHY_TYPE_11A) {
         if ((pMgmt->eConfigPHYMode == PHY_TYPE_11A) ||
@@ -4462,14 +4439,8 @@ s_vMgrRxProbeRequest(
         sFrame.pBuf = (unsigned char *)pRxPacket->p80211Header;
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
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Probe request rx:MAC addr:%pMF\n",
+		sFrame.pHdr->sA3.abyAddr2);
 */
         if (sFrame.pSSID->len != 0) {
             if (sFrame.pSSID->len != ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len)
-- 
1.7.5.4

