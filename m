Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2GHW6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:58:55 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:27048 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2GHW6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:58:53 -0400
Date: Mon, 9 Jul 2012 00:58:52 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: vt6656: iwctl: Fix up a few remaining brace
 issues
In-Reply-To: <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207090055480.15263@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net> <20120706230945.GA8835@kroah.com> <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net> <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My previous cleanup patches missed a few cases of
redundant/missing/replaced curly braces. This should fix up the last
ones.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index f8ea662..13ad62c 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
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
@@ -1205,7 +1204,7 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 	wrq->length = 0;
 
 	if ((index == 0) && (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled ||
-				pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)){ // get wpa pairwise  key
+				pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)) { // get wpa pairwise  key
 		if (KeybGetKey(&(pDevice->sKey), pMgmt->abyCurrBSSID, 0xffffffff, &pKey)) {
 			wrq->length = pKey->uKeyLength;
 			memcpy(abyKey, pKey->abyKey,	pKey->uKeyLength);
@@ -1360,11 +1359,10 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		if (wpa_version == IW_AUTH_WPA_VERSION_DISABLED)
 			break;
 		if (pairwise == IW_AUTH_CIPHER_NONE) {
-			if (wrq->value == IW_AUTH_CIPHER_CCMP) {
+			if (wrq->value == IW_AUTH_CIPHER_CCMP)
 				pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-			}else {
+			else
 				pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
-			}
 		}
 		break;
 	case IW_AUTH_KEY_MGMT:
@@ -1446,7 +1444,7 @@ int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 			goto out;
 		}
 		pMgmt->wWPAIELen = wrq->length;
-	}else {
+	} else {
 		memset(pMgmt->abyWPAIE, 0, MAX_WPA_IE_LEN);
 		pMgmt->wWPAIELen = 0;
 	}
@@ -1470,8 +1468,9 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
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
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

