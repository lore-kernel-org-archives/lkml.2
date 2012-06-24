Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2FXX5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:57:24 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12356 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2FXX5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:57:22 -0400
Date: Mon, 25 Jun 2012 01:57:20 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] staging: vt6656: iwctl: space after
 if/for/while/switch
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250152290.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our coding style dictates a space after if/for/while/switch and the
opening parenthesis.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 144 ++++++++++++++++++++---------------------
 1 file changed, 72 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 9b7d752..4254455 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -68,7 +68,7 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	long ldBm;
 
 	pDevice->wstats.status = pDevice->eOPMode;
-	if(pDevice->scStatistic.LinkQuality > 100)
+	if (pDevice->scStatistic.LinkQuality > 100)
 		pDevice->scStatistic.LinkQuality = 100;
 	pDevice->wstats.qual.qual =(BYTE)pDevice->scStatistic.LinkQuality;
 	RFvRSSITodBm(pDevice, (BYTE)(pDevice->uCurrRSSI), &ldBm);
@@ -117,7 +117,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 		return -EAGAIN;
 	}
 
-	if(pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
+	if (pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
 //send scan event to wpa_Supplicant
 		union iwreq_data wrqu;
 		PRINT_K("wireless_send_event--->SIOCGIWSCAN(scan done)\n");
@@ -131,14 +131,14 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 	BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
 
 //mike add: active scan OR passive scan OR desire_ssid scan
-	if(wrq->length == sizeof(struct iw_scan_req)) {
+	if (wrq->length == sizeof(struct iw_scan_req)) {
 		if (wrq->flags & IW_SCAN_THIS_ESSID)  {                               //desire_ssid scan
 			memset(abyScanSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 			pItemSSID = (PWLAN_IE_SSID)abyScanSSID;
 			pItemSSID->byElementID = WLAN_EID_SSID;
 			memcpy(pItemSSID->abySSID, req->essid, (int)req->essid_len);
 			if (pItemSSID->abySSID[req->essid_len - 1] == '\0') {
-				if(req->essid_len>0)
+				if (req->essid_len>0)
 					pItemSSID->len = req->essid_len - 1;
 			}
 			else
@@ -151,7 +151,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 
 			return 0;
 		}
-		else if(req->scan_type == IW_SCAN_TYPE_PASSIVE) {          //passive scan
+		else if (req->scan_type == IW_SCAN_TYPE_PASSIVE) {          //passive scan
 			pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 		}
 	}
@@ -235,7 +235,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
 			{
 				int f = (int)pBSS->uChannel - 1;
-				if(f < 0)f = 0;
+				if (f < 0)f = 0;
 				iwe.u.freq.m = frequency_list[f] * 100000;
 				iwe.u.freq.e = 1;
 			}
@@ -247,9 +247,9 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			iwe.u.qual.level = ldBm;
 			iwe.u.qual.noise = 0;
 
-			if(-ldBm<50){
+			if (-ldBm<50){
 				iwe.u.qual.qual = 100;
-			}else  if(-ldBm > 90) {
+			}else  if (-ldBm > 90) {
 				iwe.u.qual.qual = 0;
 			}else {
 				iwe.u.qual.qual=(40-(-ldBm-50))*100/40;
@@ -288,7 +288,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 				current_val = iwe_stream_add_value(info,current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
 			}
 
-			if((current_val - current_ev) > IW_EV_LCP_LEN)
+			if ((current_val - current_ev) > IW_EV_LCP_LEN)
 				current_ev = current_val;
 
 			memset(&iwe, 0, sizeof(iwe));
@@ -329,22 +329,22 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");
 
 	// If setting by frequency, convert to a channel
-	if((wrq->e == 1) &&
+	if ((wrq->e == 1) &&
 		(wrq->m >= (int)2.412e8) &&
 		(wrq->m <= (int)2.487e8)) {
 		int f = wrq->m / 100000;
 		int c = 0;
-		while((c < 14) && (f != frequency_list[c]))
+		while ((c < 14) && (f != frequency_list[c]))
 			c++;
 		wrq->e = 0;
 		wrq->m = c + 1;
 	}
 	// Setting by channel number
-	if((wrq->m > 14) || (wrq->e > 0))
+	if ((wrq->m > 14) || (wrq->e > 0))
 		rc = -EOPNOTSUPP;
 	else {
 		int channel = wrq->m;
-		if((channel < 1) || (channel > 14)) {
+		if ((channel < 1) || (channel > 14)) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: New channel value of %d is invalid!\n", dev->name, wrq->m);
 			rc = -EINVAL;
 		} else {
@@ -374,7 +374,7 @@ int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 #else
 	{
 		int f = (int)pMgmt->uCurrChannel - 1;
-		if(f < 0)
+		if (f < 0)
 			f = 0;
 		wrq->m = frequency_list[f] * 100000;
 		wrq->e = 1;
@@ -400,7 +400,7 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 		return rc;
 	}
 
-	switch(*wmode) {
+	switch (*wmode) {
 
 	case IW_MODE_ADHOC:
 		if (pMgmt->eConfigMode != WMAC_CONFIG_IBSS_STA) {
@@ -515,7 +515,7 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 
 		for (i = 0 ; i < 13 ; i++) {
 			range->bitrate[i] = abySupportedRates[i] * 500000;
-			if(range->bitrate[i] == 0)
+			if (range->bitrate[i] == 0)
 				break;
 		}
 		range->num_bitrates = i;
@@ -523,7 +523,7 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		// Set an indication of the max TCP throughput
 		// in bit/s that we can expect using this interface.
 		//  May be use for QoS stuff... Jean II
-		if(i > 2)
+		if (i > 2)
 			range->throughput = 5 * 1000 * 1000;
 		else
 			range->throughput = 1.5 * 1000 * 1000;
@@ -612,7 +612,7 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 					uSameBssidNum++;
 				}
 			}
-			if(uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
+			if (uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
 				PRINT_K("SIOCSIWAP:ignore for desired AP in hidden mode\n");
 				return rc;
 			}
@@ -713,7 +713,7 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 
 	pDevice->fWPA_Authened = FALSE;
 	// Check if we asked for `any'
-	if(wrq->flags == 0) {
+	if (wrq->flags == 0) {
 		// Just send an empty SSID list
 		memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 		memset(pMgmt->abyDesireBSSID, 0xFF,6);
@@ -730,7 +730,7 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 
 		memcpy(pItemSSID->abySSID, extra, wrq->length);
 		if (pItemSSID->abySSID[wrq->length - 1] == '\0') {
-			if(wrq->length>0)
+			if (wrq->length>0)
 				pItemSSID->len = wrq->length - 1;
 		}
 		else
@@ -738,7 +738,7 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		PRINT_K("set essid to %s \n",pItemSSID->abySSID);
 
 		//mike:need clear desiredBSSID
-		if(pItemSSID->len==0) {
+		if (pItemSSID->len==0) {
 			memset(pMgmt->abyDesireBSSID, 0xFF,6);
 			return 0;
 		}
@@ -746,7 +746,7 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 		//Wext wil order another command of siwap to link with desired AP,
 		//so here need not associate??
-		if(pDevice->bWPASuppWextEnabled == TRUE)  {
+		if (pDevice->bWPASuppWextEnabled == TRUE)  {
 			/*******search if  in hidden ssid mode ****/
 			PKnownBSS pCurr = NULL;
 			BYTE abyTmpDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
@@ -779,7 +779,7 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 						uSameBssidNum++;
 					}
 				}
-				if(uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
+				if (uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
 					PRINT_K("SIOCSIWESSID:hidden ssid directly associate.......\n");
 					vResetCommandTimer((void *)pDevice);
 					pMgmt->eScanType = WMAC_SCAN_PASSIVE;          //this scan type,you'll submit scan result!
@@ -853,7 +853,7 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 	// First : get a valid bit rate value
 
 	// Which type of value
-	if((wrq->value < 13) &&
+	if ((wrq->value < 13) &&
 		(wrq->value >= 0)) {
 		// Setting by rate index
 		// Find value in the magic rate table
@@ -864,32 +864,32 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 
 		// Check if rate is valid
 		for (i = 0 ; i < 13 ; i++) {
-			if(normvalue == abySupportedRates[i]) {
+			if (normvalue == abySupportedRates[i]) {
 				brate = i;
 				break;
 			}
 		}
 	}
 	// -1 designed the max rate (mostly auto mode)
-	if(wrq->value == -1) {
+	if (wrq->value == -1) {
 		// Get the highest available rate
 		for (i = 0 ; i < 13 ; i++) {
-			if(abySupportedRates[i] == 0)
+			if (abySupportedRates[i] == 0)
 				break;
 		}
-		if(i != 0)
+		if (i != 0)
 			brate = i - 1;
 
 	}
 	// Check that it is valid
 	// brate is index of abySupportedRates[]
-	if(brate > 13 ) {
+	if (brate > 13 ) {
 		rc = -EINVAL;
 		return rc;
 	}
 
 	// Now, check if we want a fixed or auto value
-	if(wrq->fixed != 0) {
+	if (wrq->fixed != 0) {
 		// Fixed mode
 		// One rate, fixed
 		pDevice->bFixRate = TRUE;
@@ -1003,7 +1003,7 @@ int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 
 	if (wrq->disabled)
 		fthr = 2312;
-	if((fthr < 256) || (fthr > 2312)) {
+	if ((fthr < 256) || (fthr > 2312)) {
 		rc = -EINVAL;
 	}else {
 		fthr &= ~0x1;	// Get an even value
@@ -1045,7 +1045,7 @@ int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 	}
 
 	if (wrq->flags & IW_RETRY_LIMIT) {
-		if(wrq->flags & IW_RETRY_MAX)
+		if (wrq->flags & IW_RETRY_MAX)
 			pDevice->byLongRetryLimit = wrq->value;
 		else if (wrq->flags & IW_RETRY_MIN)
 			pDevice->byShortRetryLimit = wrq->value;
@@ -1072,16 +1072,16 @@ int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 	wrq->disabled = 0;      // Can't be disabled
 
 	// Note : by default, display the min retry number
-	if((wrq->flags & IW_RETRY_TYPE) == IW_RETRY_LIFETIME) {
+	if ((wrq->flags & IW_RETRY_TYPE) == IW_RETRY_LIFETIME) {
 		wrq->flags = IW_RETRY_LIFETIME;
 		wrq->value = (int)pDevice->wMaxTransmitMSDULifetime; //ms
-	} else if((wrq->flags & IW_RETRY_MAX)) {
+	} else if ((wrq->flags & IW_RETRY_MAX)) {
 		wrq->flags = IW_RETRY_LIMIT | IW_RETRY_MAX;
 		wrq->value = (int)pDevice->byLongRetryLimit;
 	} else {
 		wrq->flags = IW_RETRY_LIMIT;
 		wrq->value = (int)pDevice->byShortRetryLimit;
-		if((int)pDevice->byShortRetryLimit != (int)pDevice->byLongRetryLimit)
+		if ((int)pDevice->byShortRetryLimit != (int)pDevice->byLongRetryLimit)
 			wrq->flags |= IW_RETRY_MIN;
 	}
 
@@ -1165,7 +1165,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		}
 	}
 	// Read the flags
-	if(wrq->flags & IW_ENCODE_DISABLED){
+	if (wrq->flags & IW_ENCODE_DISABLED){
 
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable WEP function\n");
 		pMgmt->bShareKeyAlgorithm = FALSE;
@@ -1178,11 +1178,11 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 			spin_unlock_irq(&pDevice->lock);
 		}
 	}
-	if(wrq->flags & IW_ENCODE_RESTRICTED) {
+	if (wrq->flags & IW_ENCODE_RESTRICTED) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & ShareKey System\n");
 		pMgmt->bShareKeyAlgorithm = TRUE;
 	}
-	if(wrq->flags & IW_ENCODE_OPEN) {
+	if (wrq->flags & IW_ENCODE_OPEN) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & Open System\n");
 		pMgmt->bShareKeyAlgorithm = FALSE;
 	}
@@ -1208,8 +1208,8 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 	if (index > WLAN_WEP_NKEYS) {
 		return	-EINVAL;
 	}
-	if(index<1){//get default key
-		if(pDevice->byKeyIndex<WLAN_WEP_NKEYS){
+	if (index<1){//get default key
+		if (pDevice->byKeyIndex<WLAN_WEP_NKEYS){
 			index=pDevice->byKeyIndex;
          	} else
 			index=0;
@@ -1231,7 +1231,7 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 		wrq->flags |=  IW_ENCODE_OPEN;
 	wrq->length=0;
 
-	if((index==0)&&(pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled||
+	if ((index==0)&&(pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled||
 				pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)){//get wpa pairwise  key
 		if (KeybGetKey(&(pDevice->sKey),pMgmt->abyCurrBSSID, 0xffffffff, &pKey)){
 			wrq->length = pKey->uKeyLength;
@@ -1359,10 +1359,10 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 	switch (wrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
 		wpa_version = wrq->value;
-		if(wrq->value == IW_AUTH_WPA_VERSION_DISABLED) {
+		if (wrq->value == IW_AUTH_WPA_VERSION_DISABLED) {
 			PRINT_K("iwctl_siwauth:set WPADEV to disable at 1??????\n");
 		}
-		else if(wrq->value == IW_AUTH_WPA_VERSION_WPA) {
+		else if (wrq->value == IW_AUTH_WPA_VERSION_WPA) {
 			PRINT_K("iwctl_siwauth:set WPADEV to WPA1******\n");
 		}
 		else {
@@ -1372,24 +1372,24 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 	case IW_AUTH_CIPHER_PAIRWISE:
 		pairwise = wrq->value;
 		PRINT_K("iwctl_siwauth:set pairwise=%d\n",pairwise);
-		if(pairwise == IW_AUTH_CIPHER_CCMP){
+		if (pairwise == IW_AUTH_CIPHER_CCMP){
 			pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-		}else if(pairwise == IW_AUTH_CIPHER_TKIP){
+		}else if (pairwise == IW_AUTH_CIPHER_TKIP){
 			pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
 		} else if (pairwise == IW_AUTH_CIPHER_WEP40 ||
 			pairwise == IW_AUTH_CIPHER_WEP104) {
 			pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		}else if(pairwise == IW_AUTH_CIPHER_NONE){
+		}else if (pairwise == IW_AUTH_CIPHER_NONE){
 			//do nothing,einsn liu
 		}else pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
 		break;
 	case IW_AUTH_CIPHER_GROUP:
 		PRINT_K("iwctl_siwauth:set GROUP=%d\n",wrq->value);
-		if(wpa_version == IW_AUTH_WPA_VERSION_DISABLED)
+		if (wpa_version == IW_AUTH_WPA_VERSION_DISABLED)
 			break;
-		if(pairwise == IW_AUTH_CIPHER_NONE){
-			if(wrq->value == IW_AUTH_CIPHER_CCMP){
+		if (pairwise == IW_AUTH_CIPHER_NONE){
+			if (wrq->value == IW_AUTH_CIPHER_CCMP){
 				pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
 			}else {
 				pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
@@ -1398,14 +1398,14 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		break;
 	case IW_AUTH_KEY_MGMT:
 		PRINT_K("iwctl_siwauth(wpa_version=%d):set KEY_MGMT=%d\n",wpa_version,wrq->value);
-		if(wpa_version == IW_AUTH_WPA_VERSION_WPA2){
-			if(wrq->value == IW_AUTH_KEY_MGMT_PSK)
+		if (wpa_version == IW_AUTH_WPA_VERSION_WPA2){
+			if (wrq->value == IW_AUTH_KEY_MGMT_PSK)
 				pMgmt->eAuthenMode = WMAC_AUTH_WPA2PSK;
 			else pMgmt->eAuthenMode = WMAC_AUTH_WPA2;
-		}else if(wpa_version == IW_AUTH_WPA_VERSION_WPA){
-			if(wrq->value == 0){
+		}else if (wpa_version == IW_AUTH_WPA_VERSION_WPA){
+			if (wrq->value == 0){
 				pMgmt->eAuthenMode = WMAC_AUTH_WPANONE;
-			}else if(wrq->value == IW_AUTH_KEY_MGMT_PSK)
+			}else if (wrq->value == IW_AUTH_KEY_MGMT_PSK)
 				pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
 			else pMgmt->eAuthenMode = WMAC_AUTH_WPA;
 		}
@@ -1416,9 +1416,9 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
 		PRINT_K("iwctl_siwauth:set AUTH_ALG=%d\n",wrq->value);
-		if(wrq->value==IW_AUTH_ALG_OPEN_SYSTEM){
+		if (wrq->value==IW_AUTH_ALG_OPEN_SYSTEM){
 			pMgmt->bShareKeyAlgorithm=FALSE;
-		}else if(wrq->value==IW_AUTH_ALG_SHARED_KEY){
+		}else if (wrq->value==IW_AUTH_ALG_SHARED_KEY){
 			pMgmt->bShareKeyAlgorithm=TRUE;
 		}
 		break;
@@ -1431,7 +1431,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		break;
 	case IW_AUTH_PRIVACY_INVOKED:
 		pDevice->bEncryptionEnable = !!wrq->value;
-		if(pDevice->bEncryptionEnable == FALSE){
+		if (pDevice->bEncryptionEnable == FALSE){
 			wpa_version = 0;
 			pairwise = 0;
 			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
@@ -1460,17 +1460,17 @@ int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int ret = 0;
 
-	if(wrq->length){
+	if (wrq->length){
 		if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
 			ret = -EINVAL;
 			goto out;
 		}
-		if(wrq->length > MAX_WPA_IE_LEN){
+		if (wrq->length > MAX_WPA_IE_LEN){
 			ret = -ENOMEM;
 			goto out;
 		}
 		memset(pMgmt->abyWPAIE, 0, MAX_WPA_IE_LEN);
-		if(copy_from_user(pMgmt->abyWPAIE, extra, wrq->length)){
+		if (copy_from_user(pMgmt->abyWPAIE, extra, wrq->length)){
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1493,10 +1493,10 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 	int space = wrq->length;
 
 	wrq->length = 0;
-	if(pMgmt->wWPAIELen > 0){
+	if (pMgmt->wWPAIELen > 0){
 		wrq->length = pMgmt->wWPAIELen;
-		if(pMgmt->wWPAIELen <= space){
-			if(copy_to_user(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen)){
+		if (pMgmt->wWPAIELen <= space){
+			if (copy_to_user(extra, pMgmt->abyWPAIE, pMgmt->wWPAIELen)){
 				ret = -EFAULT;
 			}
 		}else
@@ -1559,15 +1559,15 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 //recover key_idx
 	key_idx = (wrq->flags&IW_ENCODE_INDEX) - 1;
 //recover set_tx
-	if(ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
+	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
 		set_tx = 1;
 //recover seq,seq_len
-	if(ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
+	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
 		seq_len=IW_ENCODE_SEQ_MAX_SIZE;
 		memcpy(seq, ext->rx_seq, seq_len);
 	}
 //recover key,key_len
-	if(ext->key_len) {
+	if (ext->key_len) {
 		key_len=ext->key_len;
 		memcpy(key, &ext->key[0], key_len);
 	}
@@ -1593,8 +1593,8 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 
 //****set if current action is Network Manager count??
 //****this method is so foolish,but there is no other way???
-	if(param->u.wpa_key.alg_name == WPA_ALG_NONE) {
-		if(param->u.wpa_key.key_index ==0) {
+	if (param->u.wpa_key.alg_name == WPA_ALG_NONE) {
+		if (param->u.wpa_key.key_index ==0) {
 			pDevice->bwextstep0 = TRUE;
 		}
 		if ((pDevice->bwextstep0 == TRUE) && (param->u.wpa_key.key_index == 1)) {
@@ -1610,7 +1610,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 			pDevice->bwextstep3 = TRUE;
 		}
 	}
-	if(pDevice->bwextstep3 == TRUE) {
+	if (pDevice->bwextstep3 == TRUE) {
 		PRINT_K("SIOCSIWENCODEEXT:Enable WPA WEXT SUPPORT!!!!!\n");
 		pDevice->bwextstep0 = FALSE;
 		pDevice->bwextstep1 = FALSE;
@@ -1644,14 +1644,14 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	int ret = 0;
 
-	if(memcmp(pMgmt->abyCurrBSSID, mlme->addr.sa_data, ETH_ALEN)){
+	if (memcmp(pMgmt->abyCurrBSSID, mlme->addr.sa_data, ETH_ALEN)){
 		ret = -EINVAL;
 		return ret;
 	}
-	switch(mlme->cmd){
+	switch (mlme->cmd){
 	case IW_MLME_DEAUTH:
 	case IW_MLME_DISASSOC:
-		if(pDevice->bLinkPass == TRUE){
+		if (pDevice->bLinkPass == TRUE){
 			PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
 			bScheduleCommand((void *)pDevice,
 					WLAN_CMD_DISASSOCIATE,
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

