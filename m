Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2F0TTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:19:18 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19643 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2F0TTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:19:17 -0400
Date: Wed, 27 Jun 2012 21:19:15 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] staging: vt6656: iwctl: mop up a few remaining obvious style
 issues
Message-ID: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My previous 14 patch series to vt6656 missed a few bits and
pieces. This mops up the last few obvious style issues.
It is quite short and completely trivial - simply deletes a few blank
lines, does some whitespace cleanup around operators and adds a few
curly braces.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index dc24096..a5eeb4f 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -104,7 +104,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_scan_req *req = (struct iw_scan_req *)extra;
 	BYTE abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-	PWLAN_IE_SSID pItemSSID=NULL;
+	PWLAN_IE_SSID pItemSSID = NULL;
 
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
 		return -EINVAL;
@@ -140,9 +140,9 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 			if (pItemSSID->abySSID[req->essid_len - 1] == '\0') {
 				if (req->essid_len > 0)
 					pItemSSID->len = req->essid_len - 1;
-			}
-			else
+			} else {
 				pItemSSID->len = req->essid_len;
+			}
 			pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 			PRINT_K("SIOCSIWSCAN:[desired_ssid=%s,len=%d]\n", ((PWLAN_IE_SSID)abyScanSSID)->abySSID,
 				((PWLAN_IE_SSID)abyScanSSID)->len);
@@ -203,7 +203,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			iwe.cmd = SIOCGIWAP;
 			iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
 			memcpy(iwe.u.ap_addr.sa_data, pBSS->abyBSSID, WLAN_BSSID_LEN);
-			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
+			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_ADDR_LEN);
 			// ADD ssid
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWESSID;
@@ -244,7 +244,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			iwe.u.qual.level = ldBm;
 			iwe.u.qual.noise = 0;
 
-			if (-ldBm<50)
+			if (-ldBm < 50)
 				iwe.u.qual.qual = 100;
 			else  if (-ldBm > 90)
 				iwe.u.qual.qual = 0;
@@ -577,9 +577,9 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 
 	PRINT_K(" SIOCSIWAP \n");
 
-	if (wrq->sa_family != ARPHRD_ETHER)
+	if (wrq->sa_family != ARPHRD_ETHER) {
 		rc = -EINVAL;
-	else {
+	} else {
 		memcpy(pMgmt->abyDesireBSSID, wrq->sa_data, 6);
 		// mike: add
 		if ((is_broadcast_ether_addr(pMgmt->abyDesireBSSID)) ||
@@ -882,8 +882,7 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 			pDevice->uConnectionRate = brate;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fixed to Rate %d \n", pDevice->uConnectionRate);
 		}
-	}
-	else {
+	} else {
 		pDevice->bFixRate = FALSE;
 		pDevice->uConnectionRate = 13;
 	}
@@ -965,7 +964,6 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 	wrq->value = pDevice->wRTSThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
-
 	return 0;
 }
 
@@ -1004,7 +1002,6 @@ int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 	wrq->value = pDevice->wFragmentationThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
-
 	return 0;
 }
 
@@ -1098,7 +1095,6 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 
 	// Send the key to the card
 	if (wrq->length > 0) {
-
 		if (wrq->length ==  WLAN_WEP232_KEYLEN) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 232 bit wep key\n");
 		} else if (wrq->length ==  WLAN_WEP104_KEYLEN) {
@@ -1120,8 +1116,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 					dwKeyIndex | (1 << 31),
 					wrq->length, NULL,
 					pDevice->abyKey,
-					KEY_CTL_WEP
-				);
+					KEY_CTL_WEP);
 			spin_unlock_irq(&pDevice->lock);
 		}
 		pDevice->byKeyIndex = (BYTE)dwKeyIndex;
@@ -1205,7 +1200,7 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 	wrq->length = 0;
 
 	if ((index == 0) && (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled ||
-				pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)){ // get wpa pairwise  key
+				pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)) { // get wpa pairwise key
 		if (KeybGetKey(&(pDevice->sKey), pMgmt->abyCurrBSSID, 0xffffffff, &pKey)) {
 			wrq->length = pKey->uKeyLength;
 			memcpy(abyKey, pKey->abyKey,	pKey->uKeyLength);
@@ -1362,7 +1357,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		if (pairwise == IW_AUTH_CIPHER_NONE) {
 			if (wrq->value == IW_AUTH_CIPHER_CCMP) {
 				pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-			}else {
+			} else {
 				pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
 			}
 		}
@@ -1446,7 +1441,7 @@ int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 			goto out;
 		}
 		pMgmt->wWPAIELen = wrq->length;
-	}else {
+	} else {
 		memset(pMgmt->abyWPAIE, 0, MAX_WPA_IE_LEN);
 		pMgmt->wWPAIELen = 0;
 	}
@@ -1470,8 +1465,9 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 			if (copy_to_user(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen)) {
 				ret = -EFAULT;
 			}
-		} else
+		} else {
 			ret = -E2BIG;
+		}
 	}
 	return ret;
 }
@@ -1624,8 +1620,7 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 	case IW_MLME_DISASSOC:
 		if (pDevice->bLinkPass == TRUE) {
 			PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
-			bScheduleCommand((void *)pDevice,
-					WLAN_CMD_DISASSOCIATE,
+			bScheduleCommand((void *)pDevice, WLAN_CMD_DISASSOCIATE,
 					NULL);
 		}
 		break;
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

