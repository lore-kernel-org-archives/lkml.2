Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2FXX5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:57:33 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12387 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2FXX52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:57:28 -0400
Date: Mon, 25 Jun 2012 01:57:27 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] staging: vt6656: iwctl: comment cleanup
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250152590.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All comments now have one space between the code they follow and the
comment start chars and one space after the comment start chars and
the comment text.
Also cleaned up some spacing within comments - mostly removed space
before ':' and added space after ',' etc.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 265 +++++++++++++++++++++--------------------
 1 file changed, 133 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 4254455..c639a3c 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -85,7 +85,7 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 }
 
 /*
- * Wireless Handler : get protocol name
+ * Wireless Handler: get protocol name
  */
 int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
 		char *wrq, char *extra)
@@ -95,7 +95,7 @@ int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : set scan
+ * Wireless Handler: set scan
  */
 int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
@@ -117,8 +117,8 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 		return -EAGAIN;
 	}
 
-	if (pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
-//send scan event to wpa_Supplicant
+	if (pDevice->byReAssocCount > 0) { // reject scan when re-associating!
+		// send scan event to wpa_Supplicant
 		union iwreq_data wrqu;
 		PRINT_K("wireless_send_event--->SIOCGIWSCAN(scan done)\n");
 		memset(&wrqu, 0, sizeof(wrqu));
@@ -130,9 +130,9 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 
 	BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
 
-//mike add: active scan OR passive scan OR desire_ssid scan
+	// mike add: active scan OR passive scan OR desire_ssid scan
 	if (wrq->length == sizeof(struct iw_scan_req)) {
-		if (wrq->flags & IW_SCAN_THIS_ESSID)  {                               //desire_ssid scan
+		if (wrq->flags & IW_SCAN_THIS_ESSID)  { // desire_ssid scan
 			memset(abyScanSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 			pItemSSID = (PWLAN_IE_SSID)abyScanSSID;
 			pItemSSID->byElementID = WLAN_EID_SSID;
@@ -151,11 +151,11 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 
 			return 0;
 		}
-		else if (req->scan_type == IW_SCAN_TYPE_PASSIVE) {          //passive scan
+		else if (req->scan_type == IW_SCAN_TYPE_PASSIVE) { // passive scan
 			pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 		}
 	}
-	else {           //active scan
+	else { // active scan
 		pMgmt->eScanType = WMAC_SCAN_ACTIVE;
 	}
 
@@ -200,20 +200,20 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			break;
 		pBSS = &(pMgmt->sBSSList[jj]);
 		if (pBSS->bActive) {
-			//ADD mac address
+			// ADD mac address
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWAP;
 			iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
 			memcpy(iwe.u.ap_addr.sa_data, pBSS->abyBSSID, WLAN_BSSID_LEN);
 			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
-			//ADD ssid
+			// ADD ssid
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWESSID;
 			pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
 			iwe.u.data.length = pItemSSID->len;
 			iwe.u.data.flags = 1;
 			current_ev = iwe_stream_add_point(info,current_ev,end_buf, &iwe, pItemSSID->abySSID);
-			//ADD mode
+			// ADD mode
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWMODE;
 			if (WLAN_GET_CAP_INFO_ESS(pBSS->wCapInfo)) {
@@ -224,7 +224,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			}
 			iwe.len = IW_EV_UINT_LEN;
 			current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe,  IW_EV_UINT_LEN);
-			//ADD frequency
+			// ADD frequency
 			pSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abySuppRates;
 			pExtSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abyExtSuppRates;
 			memset(&iwe, 0, sizeof(iwe));
@@ -240,7 +240,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 				iwe.u.freq.e = 1;
 			}
 			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
-			//ADD quality
+			// ADD quality
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVQUAL;
 			RFvRSSITodBm(pDevice, (BYTE)(pBSS->uRSSI), &ldBm);
@@ -257,7 +257,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			iwe.u.qual.updated=7;
 
 			current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
-			//ADD encryption
+			// ADD encryption
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWENCODE;
 			iwe.u.data.length = 0;
@@ -312,13 +312,13 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			}
 
 		}
-	}// for
+	} // for
 	wrq->length = current_ev - extra;
 	return 0;
 }
 
 /*
- * Wireless Handler : set frequence or channel
+ * Wireless Handler: set frequence or channel
  */
 int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 		struct iw_freq *wrq, char *extra)
@@ -358,7 +358,7 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get frequence or channel
+ * Wireless Handler: get frequence or channel
  */
 int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 		struct iw_freq *wrq, char *extra)
@@ -384,7 +384,7 @@ int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : set operation mode
+ * Wireless Handler: set operation mode
  */
 int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 		__u32 *wmode, char *extra)
@@ -448,7 +448,7 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get operation mode
+ * Wireless Handler: get operation mode
  */
 void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
 		__u32 *wmode, char *extra)
@@ -478,7 +478,7 @@ void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get capability range
+ * Wireless Handler: get capability range
  */
 void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
@@ -499,7 +499,7 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		range->max_nwid = 0x0000;
 		range->num_channels = 14;
 		// Should be based on cap_rid.country to give only
-		//  what the current card support
+		// what the current card support
 		k = 0;
 		for (i = 0; i < 14; i++) {
 			range->freq[k].i = i + 1; // List index
@@ -548,9 +548,9 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 			IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
 		range->min_pmp = 0;
-		range->max_pmp = 1000000;// 1 secs
+		range->max_pmp = 1000000; // 1 secs
 		range->min_pmt = 0;
-		range->max_pmt = 1000000;// 1 secs
+		range->max_pmt = 1000000; // 1 secs
 		range->pmp_flags = IW_POWER_PERIOD;
 		range->pmt_flags = IW_POWER_TIMEOUT;
 		range->pm_capa = IW_POWER_PERIOD | IW_POWER_TIMEOUT | IW_POWER_ALL_R;
@@ -572,7 +572,7 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		// Note : with or without the (local->rssi), results
 		//  are somewhat different. - Jean II
 		range->avg_qual.qual = 6;
-		range->avg_qual.level = 176;	// -80 dBm
+		range->avg_qual.level = 176; // -80 dBm
 		range->avg_qual.noise = 0;
 	}
 }
@@ -594,14 +594,15 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 		rc = -EINVAL;
 	else {
 		memcpy(pMgmt->abyDesireBSSID, wrq->sa_data, 6);
-		//mike :add
+		// mike: add
 		if ((is_broadcast_ether_addr(pMgmt->abyDesireBSSID)) ||
 			(memcmp(pMgmt->abyDesireBSSID, ZeroBSSID, 6) == 0)){
 			PRINT_K("SIOCSIWAP:invalid desired BSSID return!\n");
 			return rc;
 		}
-		//mike add: if desired AP is hidden ssid(there are two same BSSID in list),
-		//                  then ignore,because you don't known which one to be connect with??
+		// mike add: if desired AP is hidden ssid(there are
+		// two same BSSID in list), then ignore,because you
+		// don't known which one to be connect with??
 		{
 			unsigned ii;
 			unsigned uSameBssidNum = 0;
@@ -626,7 +627,7 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get ap mac address
+ * Wireless Handler: get ap mac address
  */
 int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
 		struct sockaddr *wrq, char *extra)
@@ -650,7 +651,7 @@ int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get ap list
+ * Wireless Handler: get ap list
  */
 int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
@@ -697,7 +698,7 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : set essid
+ * Wireless Handler: set essid
  */
 int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
@@ -737,15 +738,15 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 			pItemSSID->len = wrq->length;
 		PRINT_K("set essid to %s \n",pItemSSID->abySSID);
 
-		//mike:need clear desiredBSSID
+		// mike: need clear desiredBSSID
 		if (pItemSSID->len==0) {
 			memset(pMgmt->abyDesireBSSID, 0xFF,6);
 			return 0;
 		}
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-		//Wext wil order another command of siwap to link with desired AP,
-		//so here need not associate??
+		// Wext wil order another command of siwap to link
+		// with desired AP, so here need not associate??
 		if (pDevice->bWPASuppWextEnabled == TRUE)  {
 			/*******search if  in hidden ssid mode ****/
 			PKnownBSS pCurr = NULL;
@@ -770,8 +771,9 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 						WLAN_CMD_SSID,
 						pMgmt->abyDesireSSID);
 			}
-			else {  //mike:to find out if that desired SSID is a hidden-ssid AP ,
-				//         by means of judging if there are two same BSSID exist in list ?
+			else {  // mike: to find out if that desired SSID is a
+				// hidden-ssid AP, by means of judging if there
+				// are two same BSSID exist in list ?
 				for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 					if (pMgmt->sBSSList[ii].bActive &&
 						!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
@@ -779,10 +781,10 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 						uSameBssidNum++;
 					}
 				}
-				if (uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
+				if (uSameBssidNum >= 2) { // hit: desired AP is in hidden ssid mode!!!
 					PRINT_K("SIOCSIWESSID:hidden ssid directly associate.......\n");
 					vResetCommandTimer((void *)pDevice);
-					pMgmt->eScanType = WMAC_SCAN_PASSIVE;          //this scan type,you'll submit scan result!
+					pMgmt->eScanType = WMAC_SCAN_PASSIVE; // this scan type, you'll submit scan result!
 					bScheduleCommand((void *)pDevice,
 							WLAN_CMD_BSSID_SCAN,
 							pMgmt->abyDesireSSID);
@@ -805,7 +807,7 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get essid
+ * Wireless Handler: get essid
  */
 void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
@@ -816,8 +818,8 @@ void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID \n");
 
-	// Note : if wrq->u.data.flags != 0, we should
-	// get the relevant SSID from the SSID list...
+	// Note: if wrq->u.data.flags != 0, we should get the relevant
+	// SSID from the SSID list...
 
 	// Get the current SSID
 	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
@@ -829,7 +831,7 @@ void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : set data rate
+ * Wireless Handler: set data rate
  */
 int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
@@ -843,14 +845,13 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		0x60, 0x6C, 0x90
 	};
 
-
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRATE \n");
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
 		rc = -EINVAL;
 		return rc;
 	}
 
-	// First : get a valid bit rate value
+	// First: get a valid bit rate value
 
 	// Which type of value
 	if ((wrq->value < 13) &&
@@ -911,7 +912,7 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get data rate
+ * Wireless Handler: get data rate
  */
 void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
@@ -956,7 +957,7 @@ void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : set rts threshold
+ * Wireless Handler: set rts threshold
  */
 int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq)
 {
@@ -974,7 +975,7 @@ int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq)
 }
 
 /*
- * Wireless Handler : get rts
+ * Wireless Handler: get rts
  */
 int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
@@ -990,7 +991,7 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : set fragment threshold
+ * Wireless Handler: set fragment threshold
  */
 int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
@@ -1006,14 +1007,14 @@ int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 	if ((fthr < 256) || (fthr > 2312)) {
 		rc = -EINVAL;
 	}else {
-		fthr &= ~0x1;	// Get an even value
+		fthr &= ~0x1; // Get an even value
 		pDevice->wFragmentationThreshold = (u16)fthr;
 	}
 	return rc;
 }
 
 /*
- * Wireless Handler : get fragment threshold
+ * Wireless Handler: get fragment threshold
  */
 int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
@@ -1029,7 +1030,7 @@ int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : set retry threshold
+ * Wireless Handler: set retry threshold
  */
 int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
@@ -1062,19 +1063,19 @@ int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get retry threshold
+ * Wireless Handler: get retry threshold
  */
 int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
 	PSDevice pDevice = netdev_priv(dev);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");
-	wrq->disabled = 0;      // Can't be disabled
+	wrq->disabled = 0; // Can't be disabled
 
-	// Note : by default, display the min retry number
+	// Note: by default, display the min retry number
 	if ((wrq->flags & IW_RETRY_TYPE) == IW_RETRY_LIFETIME) {
 		wrq->flags = IW_RETRY_LIFETIME;
-		wrq->value = (int)pDevice->wMaxTransmitMSDULifetime; //ms
+		wrq->value = (int)pDevice->wMaxTransmitMSDULifetime; // ms
 	} else if ((wrq->flags & IW_RETRY_MAX)) {
 		wrq->flags = IW_RETRY_LIMIT | IW_RETRY_MAX;
 		wrq->value = (int)pDevice->byLongRetryLimit;
@@ -1089,7 +1090,7 @@ int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : set encode mode
+ * Wireless Handler: set encode mode
  */
 int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
@@ -1156,7 +1157,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		pDevice->bEncryptionEnable = TRUE;
 		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 
-		// Do we want to just set the transmit key index ?
+		// Do we want to just set the transmit key index?
 		if ( index < 4 ) {
 			pDevice->byKeyIndex = index;
 		} else if (!(wrq->flags & IW_ENCODE_MODE)) {
@@ -1208,7 +1209,7 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 	if (index > WLAN_WEP_NKEYS) {
 		return	-EINVAL;
 	}
-	if (index<1){//get default key
+	if (index<1){ // get default key
 		if (pDevice->byKeyIndex<WLAN_WEP_NKEYS){
 			index=pDevice->byKeyIndex;
          	} else
@@ -1232,7 +1233,7 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 	wrq->length=0;
 
 	if ((index==0)&&(pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled||
-				pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)){//get wpa pairwise  key
+				pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)){ // get wpa pairwise  key
 		if (KeybGetKey(&(pDevice->sKey),pMgmt->abyCurrBSSID, 0xffffffff, &pKey)){
 			wrq->length = pKey->uKeyLength;
 			memcpy(abyKey, pKey->abyKey,	pKey->uKeyLength);
@@ -1249,7 +1250,7 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : set power mode
+ * Wireless Handler: set power mode
  */
 int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
@@ -1297,7 +1298,7 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get power mode
+ * Wireless Handler: get power mode
  */
 int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
@@ -1323,7 +1324,7 @@ int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 }
 
 /*
- * Wireless Handler : get Sensitivity
+ * Wireless Handler: get Sensitivity
  */
 int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
@@ -1352,7 +1353,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int ret = 0;
-	static int wpa_version = 0;  //must be static to save the last value,einsn liu
+	static int wpa_version = 0; // must be static to save the last value, einsn liu
 	static int pairwise = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH \n");
@@ -1380,7 +1381,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 			pairwise == IW_AUTH_CIPHER_WEP104) {
 			pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 		}else if (pairwise == IW_AUTH_CIPHER_NONE){
-			//do nothing,einsn liu
+			// do nothing, einsn liu
 		}else pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
 		break;
@@ -1411,7 +1412,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		}
 		break;
 	case IW_AUTH_TKIP_COUNTERMEASURES:
-		break;		/* FIXME */
+		break; /* FIXME */
 	case IW_AUTH_DROP_UNENCRYPTED:
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
@@ -1480,7 +1481,7 @@ int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 		pMgmt->wWPAIELen = 0;
 	}
 
-out://not completely ...not necessary in wpa_supplicant 0.5.8
+out: // not completely ...not necessary in wpa_supplicant 0.5.8
 	return ret;
 }
 
@@ -1512,7 +1513,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_encode_ext *ext = (struct iw_encode_ext*)extra;
 	struct viawget_wpa_param *param=NULL;
-//original member
+// original member
 	wpa_alg alg_name;
 	u8 addr[6];
 	int key_idx;
@@ -1535,7 +1536,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	memset(buf, 0, blen);
 	param = (struct viawget_wpa_param *)buf;
 
-//recover alg_name
+// recover alg_name
 	switch (ext->alg) {
 	case IW_ENCODE_ALG_NONE:
 		alg_name = WPA_ALG_NONE;
@@ -1554,19 +1555,19 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 		ret= -ENOMEM;
 		goto error;
 	}
-//recover addr
+// recover addr
 	memcpy(addr, ext->addr.sa_data, ETH_ALEN);
-//recover key_idx
+// recover key_idx
 	key_idx = (wrq->flags&IW_ENCODE_INDEX) - 1;
-//recover set_tx
+// recover set_tx
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
 		set_tx = 1;
-//recover seq,seq_len
+// recover seq,seq_len
 	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
 		seq_len=IW_ENCODE_SEQ_MAX_SIZE;
 		memcpy(seq, ext->rx_seq, seq_len);
 	}
-//recover key,key_len
+// recover key,key_len
 	if (ext->key_len) {
 		key_len=ext->key_len;
 		memcpy(key, &ext->key[0], key_len);
@@ -1591,8 +1592,8 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	param->u.wpa_key.seq = (u8 *)seq;
 	param->u.wpa_key.seq_len = seq_len;
 
-//****set if current action is Network Manager count??
-//****this method is so foolish,but there is no other way???
+/****set if current action is Network Manager count?? */
+/****this method is so foolish,but there is no other way??? */
 	if (param->u.wpa_key.alg_name == WPA_ALG_NONE) {
 		if (param->u.wpa_key.key_index ==0) {
 			pDevice->bwextstep0 = TRUE;
@@ -1620,7 +1621,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 		memset(pMgmt->abyDesireBSSID, 0xFF,6);
 		KeyvInitTable(pDevice,&pDevice->sKey);
 	}
-//******
+/*******/
 	spin_lock_irq(&pDevice->lock);
 	ret = wpa_set_keys(pDevice, param, TRUE);
 	spin_unlock_irq(&pDevice->lock);
@@ -1667,66 +1668,66 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 #endif
 
 static const iw_handler iwctl_handler[] = {
-	(iw_handler)NULL,      /* SIOCSIWCOMMIT */
-	(iw_handler)NULL,      // SIOCGIWNAME
-	(iw_handler)NULL,				// SIOCSIWNWID
-	(iw_handler)NULL,				// SIOCGIWNWID
-	(iw_handler)NULL,		// SIOCSIWFREQ
-	(iw_handler)NULL,		// SIOCGIWFREQ
-	(iw_handler)NULL,		// SIOCSIWMODE
-	(iw_handler)NULL,		// SIOCGIWMODE
-	(iw_handler)NULL,		        // SIOCSIWSENS
-	(iw_handler)NULL,		        // SIOCGIWSENS
-	(iw_handler)NULL, 		        // SIOCSIWRANGE
-	(iw_handler)iwctl_giwrange,		// SIOCGIWRANGE
-	(iw_handler)NULL,         		    // SIOCSIWPRIV
-	(iw_handler)NULL,             		// SIOCGIWPRIV
-	(iw_handler)NULL,             		// SIOCSIWSTATS
-	(iw_handler)NULL,                  // SIOCGIWSTATS
-	(iw_handler)NULL,                  // SIOCSIWSPY
-	(iw_handler)NULL,		            // SIOCGIWSPY
-	(iw_handler)NULL,				    // -- hole --
-	(iw_handler)NULL,				    // -- hole --
-	(iw_handler)NULL,		    // SIOCSIWAP
-	(iw_handler)NULL,		    // SIOCGIWAP
-	(iw_handler)NULL,				    // -- hole -- 0x16
-	(iw_handler)NULL,       // SIOCGIWAPLIST
-	(iw_handler)iwctl_siwscan,         // SIOCSIWSCAN
-	(iw_handler)iwctl_giwscan,         // SIOCGIWSCAN
-	(iw_handler)NULL,		// SIOCSIWESSID
-	(iw_handler)NULL,		// SIOCGIWESSID
-	(iw_handler)NULL,		// SIOCSIWNICKN
-	(iw_handler)NULL,		// SIOCGIWNICKN
-	(iw_handler)NULL,		// -- hole --
-	(iw_handler)NULL,		// -- hole --
-	(iw_handler)NULL,		// SIOCSIWRATE 0x20
-	(iw_handler)NULL,		// SIOCGIWRATE
-	(iw_handler)NULL,		// SIOCSIWRTS
-	(iw_handler)NULL,		// SIOCGIWRTS
-	(iw_handler)NULL,		// SIOCSIWFRAG
-	(iw_handler)NULL,		// SIOCGIWFRAG
-	(iw_handler)NULL,		// SIOCSIWTXPOW
-	(iw_handler)NULL,		// SIOCGIWTXPOW
-	(iw_handler)NULL,		// SIOCSIWRETRY
-	(iw_handler)NULL,		// SIOCGIWRETRY
-	(iw_handler)NULL,		// SIOCSIWENCODE
-	(iw_handler)NULL,		// SIOCGIWENCODE
-	(iw_handler)NULL,		// SIOCSIWPOWER
-	(iw_handler)NULL,		// SIOCGIWPOWER
-	(iw_handler)NULL,			// -- hole --
-	(iw_handler)NULL,			// -- hole --
-	(iw_handler)NULL,    // SIOCSIWGENIE
-	(iw_handler)NULL,    // SIOCGIWGENIE
-	(iw_handler)NULL,		// SIOCSIWAUTH
-	(iw_handler)NULL,		// SIOCGIWAUTH
-	(iw_handler)NULL,		// SIOCSIWENCODEEXT
-	(iw_handler)NULL,		// SIOCGIWENCODEEXT
-	(iw_handler)NULL,				// SIOCSIWPMKSA
-	(iw_handler)NULL,				// -- hole --
+	(iw_handler)NULL, // SIOCSIWCOMMIT
+	(iw_handler)NULL, // SIOCGIWNAME
+	(iw_handler)NULL, // SIOCSIWNWID
+	(iw_handler)NULL, // SIOCGIWNWID
+	(iw_handler)NULL, // SIOCSIWFREQ
+	(iw_handler)NULL, // SIOCGIWFREQ
+	(iw_handler)NULL, // SIOCSIWMODE
+	(iw_handler)NULL, // SIOCGIWMODE
+	(iw_handler)NULL, // SIOCSIWSENS
+	(iw_handler)NULL, // SIOCGIWSENS
+	(iw_handler)NULL, // SIOCSIWRANGE
+	(iw_handler)iwctl_giwrange, // SIOCGIWRANGE
+	(iw_handler)NULL, // SIOCSIWPRIV
+	(iw_handler)NULL, // SIOCGIWPRIV
+	(iw_handler)NULL, // SIOCSIWSTATS
+	(iw_handler)NULL, // SIOCGIWSTATS
+	(iw_handler)NULL, // SIOCSIWSPY
+	(iw_handler)NULL, // SIOCGIWSPY
+	(iw_handler)NULL, // -- hole --
+	(iw_handler)NULL, // -- hole --
+	(iw_handler)NULL, // SIOCSIWAP
+	(iw_handler)NULL, // SIOCGIWAP
+	(iw_handler)NULL, // -- hole -- 0x16
+	(iw_handler)NULL, // SIOCGIWAPLIST
+	(iw_handler)iwctl_siwscan, // SIOCSIWSCAN
+	(iw_handler)iwctl_giwscan, // SIOCGIWSCAN
+	(iw_handler)NULL, // SIOCSIWESSID
+	(iw_handler)NULL, // SIOCGIWESSID
+	(iw_handler)NULL, // SIOCSIWNICKN
+	(iw_handler)NULL, // SIOCGIWNICKN
+	(iw_handler)NULL, // -- hole --
+	(iw_handler)NULL, // -- hole --
+	(iw_handler)NULL, // SIOCSIWRATE 0x20
+	(iw_handler)NULL, // SIOCGIWRATE
+	(iw_handler)NULL, // SIOCSIWRTS
+	(iw_handler)NULL, // SIOCGIWRTS
+	(iw_handler)NULL, // SIOCSIWFRAG
+	(iw_handler)NULL, // SIOCGIWFRAG
+	(iw_handler)NULL, // SIOCSIWTXPOW
+	(iw_handler)NULL, // SIOCGIWTXPOW
+	(iw_handler)NULL, // SIOCSIWRETRY
+	(iw_handler)NULL, // SIOCGIWRETRY
+	(iw_handler)NULL, // SIOCSIWENCODE
+	(iw_handler)NULL, // SIOCGIWENCODE
+	(iw_handler)NULL, // SIOCSIWPOWER
+	(iw_handler)NULL, // SIOCGIWPOWER
+	(iw_handler)NULL, // -- hole --
+	(iw_handler)NULL, // -- hole --
+	(iw_handler)NULL, // SIOCSIWGENIE
+	(iw_handler)NULL, // SIOCGIWGENIE
+	(iw_handler)NULL, // SIOCSIWAUTH
+	(iw_handler)NULL, // SIOCGIWAUTH
+	(iw_handler)NULL, // SIOCSIWENCODEEXT
+	(iw_handler)NULL, // SIOCGIWENCODEEXT
+	(iw_handler)NULL, // SIOCSIWPMKSA
+	(iw_handler)NULL, // -- hole --
 };
 
 static const iw_handler iwctl_private_handler[] = {
-	NULL,				// SIOCIWFIRSTPRIV
+	NULL, // SIOCIWFIRSTPRIV
 };
 
 struct iw_priv_args iwctl_private_args[] = {
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

