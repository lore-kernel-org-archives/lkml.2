Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2FXX5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:57:43 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12457 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2FXX5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:57:41 -0400
Date: Mon, 25 Jun 2012 01:57:39 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] staging: vt6656: iwctl: Cleanup spacing around operators
 (mostly)
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250153550.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up spacing around operators according to CodingStyle.
(A few deletions of empty lines that were missed by a previous patch are also included.
 A few bits and pieces broken on multiple lines were put one one line as well).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 168 +++++++++++++++++++----------------------
 1 file changed, 79 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index dd3c1ac..6307c6a 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -138,13 +138,13 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 			pItemSSID->byElementID = WLAN_EID_SSID;
 			memcpy(pItemSSID->abySSID, req->essid, (int)req->essid_len);
 			if (pItemSSID->abySSID[req->essid_len - 1] == '\0') {
-				if (req->essid_len>0)
+				if (req->essid_len > 0)
 					pItemSSID->len = req->essid_len - 1;
 			}
 			else
 				pItemSSID->len = req->essid_len;
 			pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-			PRINT_K("SIOCSIWSCAN:[desired_ssid=%s,len=%d]\n",((PWLAN_IE_SSID)abyScanSSID)->abySSID,
+			PRINT_K("SIOCSIWSCAN:[desired_ssid=%s,len=%d]\n", ((PWLAN_IE_SSID)abyScanSSID)->abySSID,
 				((PWLAN_IE_SSID)abyScanSSID)->len);
 			bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, abyScanSSID);
 			spin_unlock_irq(&pDevice->lock);
@@ -212,7 +212,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
 			iwe.u.data.length = pItemSSID->len;
 			iwe.u.data.flags = 1;
-			current_ev = iwe_stream_add_point(info,current_ev,end_buf, &iwe, pItemSSID->abySSID);
+			current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, pItemSSID->abySSID);
 			// ADD mode
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWMODE;
@@ -223,7 +223,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 				iwe.u.mode = IW_MODE_ADHOC;
 			}
 			iwe.len = IW_EV_UINT_LEN;
-			current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe,  IW_EV_UINT_LEN);
+			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_UINT_LEN);
 			// ADD frequency
 			pSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abySuppRates;
 			pExtSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abyExtSuppRates;
@@ -232,7 +232,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			iwe.u.freq.m = pBSS->uChannel;
 			iwe.u.freq.e = 0;
 			iwe.u.freq.i = 0;
-			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
+			current_ev = iwe_stream_add_event(info, current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
 			{
 				int f = (int)pBSS->uChannel - 1;
 				if (f < 0)
@@ -240,7 +240,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 				iwe.u.freq.m = frequency_list[f] * 100000;
 				iwe.u.freq.e = 1;
 			}
-			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
+			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_FREQ_LEN);
 			// ADD quality
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVQUAL;
@@ -253,40 +253,40 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			}else  if (-ldBm > 90) {
 				iwe.u.qual.qual = 0;
 			}else {
-				iwe.u.qual.qual=(40-(-ldBm-50))*100/40;
+				iwe.u.qual.qual = (40 - (-ldBm - 50)) * 100 / 40;
 			}
-			iwe.u.qual.updated=7;
+			iwe.u.qual.updated = 7;
 
-			current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
+			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
 			// ADD encryption
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWENCODE;
 			iwe.u.data.length = 0;
 			if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo)) {
-				iwe.u.data.flags =IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
+				iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
 			}else {
 				iwe.u.data.flags = IW_ENCODE_DISABLED;
 			}
-			current_ev = iwe_stream_add_point(info,current_ev,end_buf, &iwe, pItemSSID->abySSID);
+			current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, pItemSSID->abySSID);
 
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWRATE;
 			iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
 			current_val = current_ev + IW_EV_LCP_LEN;
 
-			for (kk = 0 ; kk < 12 ; kk++) {
+			for (kk = 0; kk < 12; kk++) {
 				if (pSuppRates->abyRates[kk] == 0)
 					break;
 				// Bit rate given in 500 kb/s units (+ 0x80)
 				iwe.u.bitrate.value = ((pSuppRates->abyRates[kk] & 0x7f) * 500000);
-				current_val = iwe_stream_add_value(info,current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
+				current_val = iwe_stream_add_value(info, current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
 			}
-			for (kk = 0 ; kk < 8 ; kk++) {
+			for (kk = 0; kk < 8; kk++) {
 				if (pExtSuppRates->abyRates[kk] == 0)
 					break;
 				// Bit rate given in 500 kb/s units (+ 0x80)
 				iwe.u.bitrate.value = ((pExtSuppRates->abyRates[kk] & 0x7f) * 500000);
-				current_val = iwe_stream_add_value(info,current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
+				current_val = iwe_stream_add_value(info, current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
 			}
 
 			if ((current_val - current_ev) > IW_EV_LCP_LEN)
@@ -296,22 +296,21 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			iwe.cmd = IWEVCUSTOM;
 			sprintf(buf, "bcn_int=%d", pBSS->wBeaconInterval);
 			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, buf);
+			current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, buf);
 
 			if ((pBSS->wWPALen > 0) && (pBSS->wWPALen <= MAX_WPA_IE_LEN)) {
 				memset(&iwe, 0, sizeof(iwe));
 				iwe.cmd = IWEVGENIE;
 				iwe.u.data.length = pBSS->wWPALen;
-				current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, pBSS->byWPAIE);
+				current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, pBSS->byWPAIE);
 			}
 
 			if ((pBSS->wRSNLen > 0) && (pBSS->wRSNLen <= MAX_WPA_IE_LEN)) {
 				memset(&iwe, 0, sizeof(iwe));
 				iwe.cmd = IWEVGENIE;
 				iwe.u.data.length = pBSS->wRSNLen;
-				current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, pBSS->byRSNIE);
+				current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, pBSS->byRSNIE);
 			}
-
 		}
 	} // for
 	wrq->length = current_ev - extra;
@@ -402,7 +401,6 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 	}
 
 	switch (*wmode) {
-
 	case IW_MODE_ADHOC:
 		if (pMgmt->eConfigMode != WMAC_CONFIG_IBSS_STA) {
 			pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
@@ -457,7 +455,6 @@ void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
-
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE \n");
 	// If not managed, assume it's ad-hoc
 	switch (pMgmt->eConfigMode) {
@@ -514,7 +511,7 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		range->max_qual.noise = 0;
 		range->sensitivity = 255;
 
-		for (i = 0 ; i < 13 ; i++) {
+		for (i = 0; i < 13; i++) {
 			range->bitrate[i] = abySupportedRates[i] * 500000;
 			if (range->bitrate[i] == 0)
 				break;
@@ -597,7 +594,7 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 		memcpy(pMgmt->abyDesireBSSID, wrq->sa_data, 6);
 		// mike: add
 		if ((is_broadcast_ether_addr(pMgmt->abyDesireBSSID)) ||
-			(memcmp(pMgmt->abyDesireBSSID, ZeroBSSID, 6) == 0)){
+			(memcmp(pMgmt->abyDesireBSSID, ZeroBSSID, 6) == 0)) {
 			PRINT_K("SIOCSIWAP:invalid desired BSSID return!\n");
 			return rc;
 		}
@@ -680,7 +677,7 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 			pBSS = &(pMgmt->sBSSList[ii]);
 			if (!pBSS->bActive)
 				continue;
-			if ( jj >= IW_MAX_AP)
+			if (jj >= IW_MAX_AP)
 				break;
 			memcpy(sock[jj].sa_data, pBSS->abyBSSID, 6);
 			sock[jj].sa_family = ARPHRD_ETHER;
@@ -692,8 +689,8 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 
 		wrq->flags = 1; // Should be define'd
 		wrq->length = jj;
-		memcpy(extra, sock, sizeof(struct sockaddr)*jj);
-		memcpy(extra + sizeof(struct sockaddr)*jj, qual, sizeof(struct iw_quality)*jj);
+		memcpy(extra, sock, sizeof(struct sockaddr) * jj);
+		memcpy(extra + sizeof(struct sockaddr) * jj, qual, sizeof(struct iw_quality) * jj);
 	}
 	return rc;
 }
@@ -721,7 +718,7 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		memset(pMgmt->abyDesireBSSID, 0xFF,6);
 		PRINT_K("set essid to 'any' \n");
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-		//Unknown desired AP,so here need not associate??
+		// Unknown desired AP, so here need not associate??
 		return 0;
 #endif
 	} else {
@@ -737,11 +734,11 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		}
 		else
 			pItemSSID->len = wrq->length;
-		PRINT_K("set essid to %s \n",pItemSSID->abySSID);
+		PRINT_K("set essid to %s \n", pItemSSID->abySSID);
 
 		// mike: need clear desiredBSSID
 		if (pItemSSID->len==0) {
-			memset(pMgmt->abyDesireBSSID, 0xFF,6);
+			memset(pMgmt->abyDesireBSSID, 0xFF, 6);
 			return 0;
 		}
 
@@ -755,13 +752,12 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 			unsigned ii;
 			unsigned uSameBssidNum = 0;
 
-			memcpy(abyTmpDesireSSID,pMgmt->abyDesireSSID,sizeof(abyTmpDesireSSID));
+			memcpy(abyTmpDesireSSID, pMgmt->abyDesireSSID, sizeof(abyTmpDesireSSID));
 			pCurr = BSSpSearchBSSList(pDevice, NULL,
 						abyTmpDesireSSID,
-						pDevice->eConfigPHYMode
-				);
+						pDevice->eConfigPHYMode);
 
-			if (pCurr == NULL){
+			if (pCurr == NULL) {
 				PRINT_K("SIOCSIWESSID:hidden ssid site survey before associate.......\n");
 				vResetCommandTimer((void *)pDevice);
 				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
@@ -824,7 +820,7 @@ void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 
 	// Get the current SSID
 	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
-	memcpy(extra, pItemSSID->abySSID , pItemSSID->len);
+	memcpy(extra, pItemSSID->abySSID, pItemSSID->len);
 	extra[pItemSSID->len] = '\0';
 
         wrq->length = pItemSSID->len;
@@ -855,17 +851,16 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 	// First: get a valid bit rate value
 
 	// Which type of value
-	if ((wrq->value < 13) &&
-		(wrq->value >= 0)) {
+	if ((wrq->value < 13) && (wrq->value >= 0)) {
 		// Setting by rate index
 		// Find value in the magic rate table
 		brate = wrq->value;
 	} else {
 		// Setting by frequency value
-		u8 normvalue = (u8) (wrq->value/500000);
+		u8 normvalue = (u8)(wrq->value/500000);
 
 		// Check if rate is valid
-		for (i = 0 ; i < 13 ; i++) {
+		for (i = 0; i < 13; i++) {
 			if (normvalue == abySupportedRates[i]) {
 				brate = i;
 				break;
@@ -875,7 +870,7 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 	// -1 designed the max rate (mostly auto mode)
 	if (wrq->value == -1) {
 		// Get the highest available rate
-		for (i = 0 ; i < 13 ; i++) {
+		for (i = 0; i < 13; i++) {
 			if (abySupportedRates[i] == 0)
 				break;
 		}
@@ -895,14 +890,13 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		// Fixed mode
 		// One rate, fixed
 		pDevice->bFixRate = TRUE;
-		if ((pDevice->byBBType == BB_TYPE_11B)&& (brate > 3)) {
+		if ((pDevice->byBBType == BB_TYPE_11B) && (brate > 3)) {
 			pDevice->uConnectionRate = 3;
 		}
 		else {
 			pDevice->uConnectionRate = brate;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fixed to Rate %d \n", pDevice->uConnectionRate);
 		}
-
 	}
 	else {
 		pDevice->bFixRate = FALSE;
@@ -1086,7 +1080,6 @@ int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 		if ((int)pDevice->byShortRetryLimit != (int)pDevice->byLongRetryLimit)
 			wrq->flags |= IW_RETRY_MIN;
 	}
-
 	return 0;
 }
 
@@ -1142,11 +1135,10 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 
 		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
 			spin_lock_irq(&pDevice->lock);
-			KeybSetDefaultKey(  pDevice,
+			KeybSetDefaultKey(pDevice,
 					&(pDevice->sKey),
 					dwKeyIndex | (1 << 31),
-					wrq->length,
-					NULL,
+					wrq->length, NULL,
 					pDevice->abyKey,
 					KEY_CTL_WEP
 				);
@@ -1190,7 +1182,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 	}
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-	memset(pMgmt->abyDesireBSSID, 0xFF,6);
+	memset(pMgmt->abyDesireBSSID, 0xFF, 6);
 #endif
 	return rc;
 }
@@ -1210,11 +1202,11 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 	if (index > WLAN_WEP_NKEYS) {
 		return	-EINVAL;
 	}
-	if (index<1){ // get default key
-		if (pDevice->byKeyIndex<WLAN_WEP_NKEYS){
-			index=pDevice->byKeyIndex;
+	if (index < 1) { // get default key
+		if (pDevice->byKeyIndex < WLAN_WEP_NKEYS){
+			index = pDevice->byKeyIndex;
          	} else
-			index=0;
+			index = 0;
 	}else
 		index--;
 
@@ -1223,30 +1215,30 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 	wrq->flags = IW_ENCODE_NOKEY;
 	// Is WEP enabled ???
 	if (pDevice->bEncryptionEnable)
-		wrq->flags |=  IW_ENCODE_ENABLED;
+		wrq->flags |= IW_ENCODE_ENABLED;
 	else
-		wrq->flags |=  IW_ENCODE_DISABLED;
+		wrq->flags |= IW_ENCODE_DISABLED;
 
 	if (pMgmt->bShareKeyAlgorithm)
-		wrq->flags |=  IW_ENCODE_RESTRICTED;
+		wrq->flags |= IW_ENCODE_RESTRICTED;
 	else
-		wrq->flags |=  IW_ENCODE_OPEN;
-	wrq->length=0;
+		wrq->flags |= IW_ENCODE_OPEN;
+	wrq->length = 0;
 
-	if ((index==0)&&(pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled||
+	if ((index == 0) && (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled ||
 				pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)){ // get wpa pairwise  key
-		if (KeybGetKey(&(pDevice->sKey),pMgmt->abyCurrBSSID, 0xffffffff, &pKey)){
+		if (KeybGetKey(&(pDevice->sKey), pMgmt->abyCurrBSSID, 0xffffffff, &pKey)) {
 			wrq->length = pKey->uKeyLength;
 			memcpy(abyKey, pKey->abyKey,	pKey->uKeyLength);
 			memcpy(extra,  abyKey, WLAN_WEP232_KEYLEN);
 		}
-	}else if (KeybGetKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, (BYTE)index , &pKey)){
+	} else if (KeybGetKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, (BYTE)index, &pKey)){
 		wrq->length = pKey->uKeyLength;
-		memcpy(abyKey, pKey->abyKey,  pKey->uKeyLength);
-		memcpy(extra,  abyKey, WLAN_WEP232_KEYLEN);
+		memcpy(abyKey, pKey->abyKey, pKey->uKeyLength);
+		memcpy(extra, abyKey, WLAN_WEP232_KEYLEN);
 	}
 
-	wrq->flags |= index+1;
+	wrq->flags |= index + 1;
 	return 0;
 }
 
@@ -1373,7 +1365,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		break;
 	case IW_AUTH_CIPHER_PAIRWISE:
 		pairwise = wrq->value;
-		PRINT_K("iwctl_siwauth:set pairwise=%d\n",pairwise);
+		PRINT_K("iwctl_siwauth:set pairwise=%d\n", pairwise);
 		if (pairwise == IW_AUTH_CIPHER_CCMP){
 			pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
 		}else if (pairwise == IW_AUTH_CIPHER_TKIP){
@@ -1383,11 +1375,11 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 			pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 		}else if (pairwise == IW_AUTH_CIPHER_NONE){
 			// do nothing, einsn liu
-		}else pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
+		} else pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
 		break;
 	case IW_AUTH_CIPHER_GROUP:
-		PRINT_K("iwctl_siwauth:set GROUP=%d\n",wrq->value);
+		PRINT_K("iwctl_siwauth:set GROUP=%d\n", wrq->value);
 		if (wpa_version == IW_AUTH_WPA_VERSION_DISABLED)
 			break;
 		if (pairwise == IW_AUTH_CIPHER_NONE){
@@ -1399,12 +1391,12 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		}
 		break;
 	case IW_AUTH_KEY_MGMT:
-		PRINT_K("iwctl_siwauth(wpa_version=%d):set KEY_MGMT=%d\n",wpa_version,wrq->value);
+		PRINT_K("iwctl_siwauth(wpa_version=%d):set KEY_MGMT=%d\n", wpa_version,wrq->value);
 		if (wpa_version == IW_AUTH_WPA_VERSION_WPA2){
 			if (wrq->value == IW_AUTH_KEY_MGMT_PSK)
 				pMgmt->eAuthenMode = WMAC_AUTH_WPA2PSK;
 			else pMgmt->eAuthenMode = WMAC_AUTH_WPA2;
-		}else if (wpa_version == IW_AUTH_WPA_VERSION_WPA){
+		} else if (wpa_version == IW_AUTH_WPA_VERSION_WPA) {
 			if (wrq->value == 0){
 				pMgmt->eAuthenMode = WMAC_AUTH_WPANONE;
 			}else if (wrq->value == IW_AUTH_KEY_MGMT_PSK)
@@ -1417,10 +1409,10 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 	case IW_AUTH_DROP_UNENCRYPTED:
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
-		PRINT_K("iwctl_siwauth:set AUTH_ALG=%d\n",wrq->value);
+		PRINT_K("iwctl_siwauth:set AUTH_ALG=%d\n", wrq->value);
 		if (wrq->value==IW_AUTH_ALG_OPEN_SYSTEM){
-			pMgmt->bShareKeyAlgorithm=FALSE;
-		}else if (wrq->value==IW_AUTH_ALG_SHARED_KEY){
+			pMgmt->bShareKeyAlgorithm = FALSE;
+		} else if (wrq->value==IW_AUTH_ALG_SHARED_KEY) {
 			pMgmt->bShareKeyAlgorithm=TRUE;
 		}
 		break;
@@ -1463,7 +1455,7 @@ int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 	int ret = 0;
 
 	if (wrq->length){
-		if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
+		if ((wrq->length < 2) || (extra[1] + 2 != wrq->length)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1497,11 +1489,11 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 	wrq->length = 0;
 	if (pMgmt->wWPAIELen > 0){
 		wrq->length = pMgmt->wWPAIELen;
-		if (pMgmt->wWPAIELen <= space){
-			if (copy_to_user(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen)){
+		if (pMgmt->wWPAIELen <= space) {
+			if (copy_to_user(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen)) {
 				ret = -EFAULT;
 			}
-		}else
+		} else
 			ret = -E2BIG;
 	}
 	return ret;
@@ -1518,7 +1510,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	wpa_alg alg_name;
 	u8 addr[6];
 	int key_idx;
-	int set_tx=0;
+	int set_tx = 0;
 	u8 seq[IW_ENCODE_SEQ_MAX_SIZE];
 	u8 key[64];
 	size_t seq_len = 0;
@@ -1570,11 +1562,11 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	}
 // recover key,key_len
 	if (ext->key_len) {
-		key_len=ext->key_len;
+		key_len = ext->key_len;
 		memcpy(key, &ext->key[0], key_len);
 	}
 	memset(key_array, 0, 64);
-	if ( key_len > 0) {
+	if (key_len > 0) {
 		memcpy(key_array, key, key_len);
 		if (key_len == 32) {
 			// notice ! the oder
@@ -1607,7 +1599,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 			pDevice->bwextstep1 = FALSE;
 			pDevice->bwextstep2 = TRUE;
 		}
-		if ((pDevice->bwextstep2 == TRUE)&&(param->u.wpa_key.key_index == 3)) {
+		if ((pDevice->bwextstep2 == TRUE) && (param->u.wpa_key.key_index == 3)) {
 			pDevice->bwextstep2 = FALSE;
 			pDevice->bwextstep3 = TRUE;
 		}
@@ -1619,8 +1611,8 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 		pDevice->bwextstep2 = FALSE;
 		pDevice->bwextstep3 = FALSE;
 		pDevice->bWPASuppWextEnabled = TRUE;
-		memset(pMgmt->abyDesireBSSID, 0xFF,6);
-		KeyvInitTable(pDevice,&pDevice->sKey);
+		memset(pMgmt->abyDesireBSSID, 0xFF, 6);
+		KeyvInitTable(pDevice, &pDevice->sKey);
 	}
 /*******/
 	spin_lock_irq(&pDevice->lock);
@@ -1732,17 +1724,15 @@ static const iw_handler iwctl_private_handler[] = {
 };
 
 struct iw_priv_args iwctl_private_args[] = {
-	{ IOCTL_CMD_SET,
-	  IW_PRIV_TYPE_CHAR | 1024, 0,
-	  "set"},
+	{ IOCTL_CMD_SET, IW_PRIV_TYPE_CHAR | 1024, 0, "set" },
 };
 
 const struct iw_handler_def iwctl_handler_def = {
-	.get_wireless_stats = &iwctl_get_wireless_stats,
-	.num_standard	= sizeof(iwctl_handler)/sizeof(iw_handler),
-	.num_private	= 0,
-	.num_private_args = 0,
-	.standard	= (iw_handler *)iwctl_handler,
-	.private	= NULL,
-	.private_args	= NULL,
+	.get_wireless_stats	= &iwctl_get_wireless_stats,
+	.num_standard		= sizeof(iwctl_handler) / sizeof(iw_handler),
+	.num_private		= 0,
+	.num_private_args	= 0,
+	.standard		= (iw_handler *)iwctl_handler,
+	.private		= NULL,
+	.private_args		= NULL,
 };
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

