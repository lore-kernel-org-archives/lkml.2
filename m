Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2FXX5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:57:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12492 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2FXX5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:57:50 -0400
Date: Mon, 25 Jun 2012 01:57:48 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] staging: vt6656: iwctl: Clean up braces on 'if'
 statements
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250154310.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up braces on 'if' statements to (mostly) match coding style.
A few other bits, like removing a few blank lines and such may have snug in.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 145 +++++++++++++++++------------------------
 1 file changed, 61 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 6307c6a..dc24096 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -132,7 +132,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 
 	// mike add: active scan OR passive scan OR desire_ssid scan
 	if (wrq->length == sizeof(struct iw_scan_req)) {
-		if (wrq->flags & IW_SCAN_THIS_ESSID)  { // desire_ssid scan
+		if (wrq->flags & IW_SCAN_THIS_ESSID) { // desire_ssid scan
 			memset(abyScanSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 			pItemSSID = (PWLAN_IE_SSID)abyScanSSID;
 			pItemSSID->byElementID = WLAN_EID_SSID;
@@ -150,12 +150,10 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 			spin_unlock_irq(&pDevice->lock);
 
 			return 0;
-		}
-		else if (req->scan_type == IW_SCAN_TYPE_PASSIVE) { // passive scan
+		} else if (req->scan_type == IW_SCAN_TYPE_PASSIVE) { // passive scan
 			pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 		}
-	}
-	else { // active scan
+	} else { // active scan
 		pMgmt->eScanType = WMAC_SCAN_ACTIVE;
 	}
 
@@ -216,12 +214,10 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			// ADD mode
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWMODE;
-			if (WLAN_GET_CAP_INFO_ESS(pBSS->wCapInfo)) {
+			if (WLAN_GET_CAP_INFO_ESS(pBSS->wCapInfo))
 				iwe.u.mode = IW_MODE_INFRA;
-			}
-			else {
+			else
 				iwe.u.mode = IW_MODE_ADHOC;
-			}
 			iwe.len = IW_EV_UINT_LEN;
 			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_UINT_LEN);
 			// ADD frequency
@@ -248,13 +244,12 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			iwe.u.qual.level = ldBm;
 			iwe.u.qual.noise = 0;
 
-			if (-ldBm<50){
+			if (-ldBm<50)
 				iwe.u.qual.qual = 100;
-			}else  if (-ldBm > 90) {
+			else  if (-ldBm > 90)
 				iwe.u.qual.qual = 0;
-			}else {
+			else
 				iwe.u.qual.qual = (40 - (-ldBm - 50)) * 100 / 40;
-			}
 			iwe.u.qual.updated = 7;
 
 			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
@@ -262,11 +257,10 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWENCODE;
 			iwe.u.data.length = 0;
-			if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo)) {
+			if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo))
 				iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-			}else {
+			else
 				iwe.u.data.flags = IW_ENCODE_DISABLED;
-			}
 			current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, pItemSSID->abySSID);
 
 			memset(&iwe, 0, sizeof(iwe));
@@ -329,8 +323,7 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");
 
 	// If setting by frequency, convert to a channel
-	if ((wrq->e == 1) &&
-		(wrq->m >= (int)2.412e8) &&
+	if ((wrq->e == 1) && (wrq->m >= (int)2.412e8) &&
 		(wrq->m <= (int)2.487e8)) {
 		int f = wrq->m / 100000;
 		int c = 0;
@@ -340,9 +333,9 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 		wrq->m = c + 1;
 	}
 	// Setting by channel number
-	if ((wrq->m > 14) || (wrq->e > 0))
+	if ((wrq->m > 14) || (wrq->e > 0)) {
 		rc = -EOPNOTSUPP;
-	else {
+	} else {
 		int channel = wrq->m;
 		if ((channel < 1) || (channel > 14)) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: New channel value of %d is invalid!\n", dev->name, wrq->m);
@@ -353,7 +346,6 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 			pDevice->uChannel = channel;
 		}
 	}
-
 	return rc;
 }
 
@@ -404,9 +396,8 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 	case IW_MODE_ADHOC:
 		if (pMgmt->eConfigMode != WMAC_CONFIG_IBSS_STA) {
 			pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
-			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+			if (pDevice->flags & DEVICE_FLAGS_OPENED)
 				pDevice->bCommit = TRUE;
-			}
 		}
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to ad-hoc \n");
 		break;
@@ -414,9 +405,8 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 	case IW_MODE_INFRA:
 		if (pMgmt->eConfigMode != WMAC_CONFIG_ESS_STA) {
 			pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
-			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+			if (pDevice->flags & DEVICE_FLAGS_OPENED)
 				pDevice->bCommit = TRUE;
-			}
 		}
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to infrastructure \n");
 		break;
@@ -428,9 +418,8 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 
 		if (pMgmt->eConfigMode != WMAC_CONFIG_AP) {
 			pMgmt->eConfigMode = WMAC_CONFIG_AP;
-			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+			if (pDevice->flags & DEVICE_FLAGS_OPENED)
 				pDevice->bCommit = TRUE;
-			}
 		}
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to Access Point \n");
 		break;
@@ -617,9 +606,8 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 			}
 		}
 
-		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+		if (pDevice->flags & DEVICE_FLAGS_OPENED)
 			pDevice->bCommit = TRUE;
-   		}
 	}
 	return rc;
 }
@@ -640,9 +628,8 @@ int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
 	if ((pDevice->bLinkPass == FALSE) && (pMgmt->eCurrMode != WMAC_MODE_ESS_AP))
 		memset(wrq->sa_data, 0, 6);
 
-	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
+	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)
 		memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
-	}
 
 	wrq->sa_family = ARPHRD_ETHER;
 	return 0;
@@ -731,9 +718,9 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		if (pItemSSID->abySSID[wrq->length - 1] == '\0') {
 			if (wrq->length>0)
 				pItemSSID->len = wrq->length - 1;
-		}
-		else
+		} else {
 			pItemSSID->len = wrq->length;
+		}
 		PRINT_K("set essid to %s \n", pItemSSID->abySSID);
 
 		// mike: need clear desiredBSSID
@@ -767,8 +754,7 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 				bScheduleCommand((void *)pDevice,
 						WLAN_CMD_SSID,
 						pMgmt->abyDesireSSID);
-			}
-			else {  // mike: to find out if that desired SSID is a
+			} else {  // mike: to find out if that desired SSID is a
 				// hidden-ssid AP, by means of judging if there
 				// are two same BSSID exist in list ?
 				for (ii = 0; ii < MAX_BSS_NUM; ii++) {
@@ -797,9 +783,9 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set essid = %s \n", pItemSSID->abySSID);
 	}
 
-	if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+	if (pDevice->flags & DEVICE_FLAGS_OPENED)
 		pDevice->bCommit = TRUE;
-	}
+
 	return 0;
 }
 
@@ -892,8 +878,7 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		pDevice->bFixRate = TRUE;
 		if ((pDevice->byBBType == BB_TYPE_11B) && (brate > 3)) {
 			pDevice->uConnectionRate = 3;
-		}
-		else {
+		} else {
 			pDevice->uConnectionRate = brate;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fixed to Rate %d \n", pDevice->uConnectionRate);
 		}
@@ -925,7 +910,7 @@ void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 
 		if (pDevice->uConnectionRate < 13) {
 			brate = abySupportedRates[pDevice->uConnectionRate];
-		}else {
+		} else {
 			if (pDevice->byBBType == BB_TYPE_11B)
 				brate = 0x16;
 			if (pDevice->byBBType == BB_TYPE_11G)
@@ -933,7 +918,6 @@ void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 			if (pDevice->byBBType == BB_TYPE_11A)
 				brate = 0x6C;
 		}
-
 		if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
 			if (pDevice->byBBType == BB_TYPE_11B)
 				brate = 0x16;
@@ -1001,7 +985,7 @@ int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 		fthr = 2312;
 	if ((fthr < 256) || (fthr > 2312)) {
 		rc = -EINVAL;
-	}else {
+	} else {
 		fthr &= ~0x1; // Get an even value
 		pDevice->wFragmentationThreshold = (u16)fthr;
 	}
@@ -1041,19 +1025,18 @@ int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 	}
 
 	if (wrq->flags & IW_RETRY_LIMIT) {
-		if (wrq->flags & IW_RETRY_MAX)
+		if (wrq->flags & IW_RETRY_MAX) {
 			pDevice->byLongRetryLimit = wrq->value;
-		else if (wrq->flags & IW_RETRY_MIN)
+		} else if (wrq->flags & IW_RETRY_MIN) {
 			pDevice->byShortRetryLimit = wrq->value;
-		else {
+		} else {
 			// No modifier : set both
 			pDevice->byShortRetryLimit = wrq->value;
 			pDevice->byLongRetryLimit = wrq->value;
 		}
 	}
-	if (wrq->flags & IW_RETRY_LIFETIME) {
+	if (wrq->flags & IW_RETRY_LIFETIME)
 		pDevice->wMaxTransmitMSDULifetime = wrq->value;
-	}
 	return rc;
 }
 
@@ -1118,20 +1101,17 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 
 		if (wrq->length ==  WLAN_WEP232_KEYLEN) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 232 bit wep key\n");
-		}
-		else if (wrq->length ==  WLAN_WEP104_KEYLEN) {
+		} else if (wrq->length ==  WLAN_WEP104_KEYLEN) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 104 bit wep key\n");
-		}
-		else if (wrq->length == WLAN_WEP40_KEYLEN) {
+		} else if (wrq->length == WLAN_WEP40_KEYLEN) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 40 bit wep key, index= %d\n", (int)dwKeyIndex);
 		}
 		memset(pDevice->abyKey, 0, WLAN_WEP232_KEYLEN);
 		memcpy(pDevice->abyKey, extra, wrq->length);
 
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"abyKey: ");
-		for (ii = 0; ii < wrq->length; ii++) {
+		for (ii = 0; ii < wrq->length; ii++)
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pDevice->abyKey[ii]);
-		}
 
 		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
 			spin_lock_irq(&pDevice->lock);
@@ -1151,7 +1131,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 
 		// Do we want to just set the transmit key index?
-		if ( index < 4 ) {
+		if (index < 4) {
 			pDevice->byKeyIndex = index;
 		} else if (!(wrq->flags & IW_ENCODE_MODE)) {
 			rc = -EINVAL;
@@ -1159,8 +1139,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		}
 	}
 	// Read the flags
-	if (wrq->flags & IW_ENCODE_DISABLED){
-
+	if (wrq->flags & IW_ENCODE_DISABLED) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable WEP function\n");
 		pMgmt->bShareKeyAlgorithm = FALSE;
 		pDevice->bEncryptionEnable = FALSE;
@@ -1199,16 +1178,16 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODE\n");
 
-	if (index > WLAN_WEP_NKEYS) {
+	if (index > WLAN_WEP_NKEYS)
 		return	-EINVAL;
-	}
 	if (index < 1) { // get default key
-		if (pDevice->byKeyIndex < WLAN_WEP_NKEYS){
+		if (pDevice->byKeyIndex < WLAN_WEP_NKEYS)
 			index = pDevice->byKeyIndex;
-         	} else
+         	else
 			index = 0;
-	}else
+	} else {
 		index--;
+	}
 
 	memset(abyKey, 0, WLAN_WEP232_KEYLEN);
 	// Check encryption mode
@@ -1232,7 +1211,7 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 			memcpy(abyKey, pKey->abyKey,	pKey->uKeyLength);
 			memcpy(extra,  abyKey, WLAN_WEP232_KEYLEN);
 		}
-	} else if (KeybGetKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, (BYTE)index, &pKey)){
+	} else if (KeybGetKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, (BYTE)index, &pKey)) {
 		wrq->length = pKey->uKeyLength;
 		memcpy(abyKey, pKey->abyKey, pKey->uKeyLength);
 		memcpy(extra, abyKey, WLAN_WEP232_KEYLEN);
@@ -1329,8 +1308,7 @@ int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 	if (pDevice->bLinkPass == TRUE) {
 		RFvRSSITodBm(pDevice, (BYTE)(pDevice->uCurrRSSI), &ldBm);
 		wrq->value = ldBm;
-	}
-	else {
+	} else {
 		wrq->value = 0;
 	}
 	wrq->disabled = (wrq->value == 0);
@@ -1355,11 +1333,9 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		wpa_version = wrq->value;
 		if (wrq->value == IW_AUTH_WPA_VERSION_DISABLED) {
 			PRINT_K("iwctl_siwauth:set WPADEV to disable at 1??????\n");
-		}
-		else if (wrq->value == IW_AUTH_WPA_VERSION_WPA) {
+		} else if (wrq->value == IW_AUTH_WPA_VERSION_WPA) {
 			PRINT_K("iwctl_siwauth:set WPADEV to WPA1******\n");
-		}
-		else {
+		} else {
 			PRINT_K("iwctl_siwauth:set WPADEV to WPA2******\n");
 		}
 		break;
@@ -1368,22 +1344,23 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		PRINT_K("iwctl_siwauth:set pairwise=%d\n", pairwise);
 		if (pairwise == IW_AUTH_CIPHER_CCMP){
 			pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-		}else if (pairwise == IW_AUTH_CIPHER_TKIP){
+		} else if (pairwise == IW_AUTH_CIPHER_TKIP) {
 			pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
 		} else if (pairwise == IW_AUTH_CIPHER_WEP40 ||
 			pairwise == IW_AUTH_CIPHER_WEP104) {
 			pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		}else if (pairwise == IW_AUTH_CIPHER_NONE){
+		} else if (pairwise == IW_AUTH_CIPHER_NONE) {
 			// do nothing, einsn liu
-		} else pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-
+		} else {
+			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
+		}
 		break;
 	case IW_AUTH_CIPHER_GROUP:
 		PRINT_K("iwctl_siwauth:set GROUP=%d\n", wrq->value);
 		if (wpa_version == IW_AUTH_WPA_VERSION_DISABLED)
 			break;
-		if (pairwise == IW_AUTH_CIPHER_NONE){
-			if (wrq->value == IW_AUTH_CIPHER_CCMP){
+		if (pairwise == IW_AUTH_CIPHER_NONE) {
+			if (wrq->value == IW_AUTH_CIPHER_CCMP) {
 				pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
 			}else {
 				pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
@@ -1399,9 +1376,10 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		} else if (wpa_version == IW_AUTH_WPA_VERSION_WPA) {
 			if (wrq->value == 0){
 				pMgmt->eAuthenMode = WMAC_AUTH_WPANONE;
-			}else if (wrq->value == IW_AUTH_KEY_MGMT_PSK)
+			} else if (wrq->value == IW_AUTH_KEY_MGMT_PSK)
 				pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
-			else pMgmt->eAuthenMode = WMAC_AUTH_WPA;
+		} else {
+			pMgmt->eAuthenMode = WMAC_AUTH_WPA;
 		}
 		break;
 	case IW_AUTH_TKIP_COUNTERMEASURES:
@@ -1410,11 +1388,10 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
 		PRINT_K("iwctl_siwauth:set AUTH_ALG=%d\n", wrq->value);
-		if (wrq->value==IW_AUTH_ALG_OPEN_SYSTEM){
+		if (wrq->value == IW_AUTH_ALG_OPEN_SYSTEM)
 			pMgmt->bShareKeyAlgorithm = FALSE;
-		} else if (wrq->value==IW_AUTH_ALG_SHARED_KEY) {
-			pMgmt->bShareKeyAlgorithm=TRUE;
-		}
+		else if (wrq->value == IW_AUTH_ALG_SHARED_KEY)
+			pMgmt->bShareKeyAlgorithm = TRUE;
 		break;
 	case IW_AUTH_WPA_ENABLED:
 		break;
@@ -1425,7 +1402,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		break;
 	case IW_AUTH_PRIVACY_INVOKED:
 		pDevice->bEncryptionEnable = !!wrq->value;
-		if (pDevice->bEncryptionEnable == FALSE){
+		if (pDevice->bEncryptionEnable == FALSE) {
 			wpa_version = 0;
 			pairwise = 0;
 			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
@@ -1487,7 +1464,7 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 	int space = wrq->length;
 
 	wrq->length = 0;
-	if (pMgmt->wWPAIELen > 0){
+	if (pMgmt->wWPAIELen > 0) {
 		wrq->length = pMgmt->wWPAIELen;
 		if (pMgmt->wWPAIELen <= space) {
 			if (copy_to_user(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen)) {
@@ -1638,14 +1615,14 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	int ret = 0;
 
-	if (memcmp(pMgmt->abyCurrBSSID, mlme->addr.sa_data, ETH_ALEN)){
+	if (memcmp(pMgmt->abyCurrBSSID, mlme->addr.sa_data, ETH_ALEN)) {
 		ret = -EINVAL;
 		return ret;
 	}
 	switch (mlme->cmd){
 	case IW_MLME_DEAUTH:
 	case IW_MLME_DISASSOC:
-		if (pDevice->bLinkPass == TRUE){
+		if (pDevice->bLinkPass == TRUE) {
 			PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
 			bScheduleCommand((void *)pDevice,
 					WLAN_CMD_DISASSOCIATE,
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

