Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2APSVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:21:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59459 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2APSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:21:09 -0500
Message-ID: <4F146A76.2020908@gmail.com>
Date: Mon, 16 Jan 2012 23:50:38 +0530
From: mahendra singh meena <mahendra.devel@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: forest@alittletooquiet.net
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        joe@perches.com, xi.wang@gmail.com
Subject: [PATCH 2/2] Staging: vt6655: Fix brace coding style issues in ioctl.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes up unnecessary brace warnings found in ioctl.c
by checkpatch.pl .

Signed-off-by: Mahendra Singh Meena <mahendra.devel@gmail.com>
---
 drivers/staging/vt6655/ioctl.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index 7fd5cc5..ef197ef 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -324,16 +324,16 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 				pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
 				memset(pList->sBSSIDList[ii].abySSID, 0, WLAN_SSID_MAXLEN + 1);
 				memcpy(pList->sBSSIDList[ii].abySSID, pItemSSID->abySSID, pItemSSID->len);
-				if (WLAN_GET_CAP_INFO_ESS(pBSS->wCapInfo)) {
+				if (WLAN_GET_CAP_INFO_ESS(pBSS->wCapInfo))
 					pList->sBSSIDList[ii].byNetType = INFRA;
-				} else {
+				else
 					pList->sBSSIDList[ii].byNetType = ADHOC;
-				}
-				if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo)) {
+
+				if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo))
 					pList->sBSSIDList[ii].bWEPOn = true;
-				} else {
+				else
 					pList->sBSSIDList[ii].bWEPOn = false;
-				}
+
 				ii++;
 				if (ii >= pList->uItem)
 					break;
@@ -367,9 +367,9 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		netif_stop_queue(pDevice->dev);

 		spin_lock_irq(&pDevice->lock);
-		if (pDevice->bRadioOff == false) {
+		if (pDevice->bRadioOff == false)
 			CARDbRadioPowerOff(pDevice);
-		}
+
 		pDevice->bLinkPass = false;
 		memset(pMgmt->abyCurrBSSID, 0, 6);
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
@@ -489,13 +489,12 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			break;
 		}

-		if (sStartAPCmd.wBBPType == PHY80211g) {
+		if (sStartAPCmd.wBBPType == PHY80211g)
 			pMgmt->byAPBBType = PHY_TYPE_11G;
-		} else if (sStartAPCmd.wBBPType == PHY80211a) {
+		else if (sStartAPCmd.wBBPType == PHY80211a)
 			pMgmt->byAPBBType = PHY_TYPE_11A;
-		} else {
+		else
 			pMgmt->byAPBBType = PHY_TYPE_11B;
-		}

 		pItemSSID = (PWLAN_IE_SSID)sStartAPCmd.ssid;
 		if (pItemSSID->len > WLAN_SSID_MAXLEN + 1)
-- 
1.7.0.4

