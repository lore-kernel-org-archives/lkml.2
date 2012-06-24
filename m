Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2FXX4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:56:21 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:57050 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2FXX4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:56:18 -0400
Date: Mon, 25 Jun 2012 01:56:15 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] staging: vt6656: iwctl: Fix indentation
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250148580.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix indentation for the entire files to use tabs rather than spaces
and also make sure everything is indented to the proper depth
according to context.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 1240 ++++++++++++++++++++--------------------
 1 file changed, 620 insertions(+), 620 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 3ac41bb..7618fb9 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -53,12 +53,12 @@
 #endif
 
 static const long frequency_list[] = {
-    2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
-    4915, 4920, 4925, 4935, 4940, 4945, 4960, 4980,
-    5035, 5040, 5045, 5055, 5060, 5080, 5170, 5180, 5190, 5200, 5210, 5220, 5230, 5240,
-    5260, 5280, 5300, 5320, 5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640, 5660, 5680,
-    5700, 5745, 5765, 5785, 5805, 5825
-	};
+	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
+	4915, 4920, 4925, 4935, 4940, 4945, 4960, 4980,
+	5035, 5040, 5045, 5055, 5060, 5080, 5170, 5180, 5190, 5200, 5210, 5220, 5230, 5240,
+	5260, 5280, 5300, 5320, 5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640, 5660, 5680,
+	5700, 5745, 5765, 5785, 5805, 5825
+};
 
 static int          msglevel                =MSG_LEVEL_INFO;
 
@@ -68,9 +68,9 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	long ldBm;
 
 	pDevice->wstats.status = pDevice->eOPMode;
-	   if(pDevice->scStatistic.LinkQuality > 100)
-   	       pDevice->scStatistic.LinkQuality = 100;
-               pDevice->wstats.qual.qual =(BYTE) pDevice->scStatistic.LinkQuality;
+	if(pDevice->scStatistic.LinkQuality > 100)
+		pDevice->scStatistic.LinkQuality = 100;
+	pDevice->wstats.qual.qual =(BYTE) pDevice->scStatistic.LinkQuality;
 	RFvRSSITodBm(pDevice, (BYTE)(pDevice->uCurrRSSI), &ldBm);
 	pDevice->wstats.qual.level = ldBm;
 	pDevice->wstats.qual.noise = 0;
@@ -101,65 +101,65 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	 PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	struct iw_scan_req  *req = (struct iw_scan_req *)extra;
 	BYTE                abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	PWLAN_IE_SSID       pItemSSID=NULL;
 
-  if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
-        return -EINVAL;
+	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
+		return -EINVAL;
 
-    PRINT_K(" SIOCSIWSCAN \n");
+	PRINT_K(" SIOCSIWSCAN \n");
 
-if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
-        // In scanning..
-     PRINT_K("SIOCSIWSCAN(overlap??)-->In scanning...\n");
-     return -EAGAIN;
-  }
+	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
+		// In scanning..
+		PRINT_K("SIOCSIWSCAN(overlap??)-->In scanning...\n");
+		return -EAGAIN;
+	}
 
-if(pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
+	if(pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
 //send scan event to wpa_Supplicant
-  union iwreq_data wrqu;
- PRINT_K("wireless_send_event--->SIOCGIWSCAN(scan done)\n");
- memset(&wrqu, 0, sizeof(wrqu));
- wireless_send_event(pDevice->dev, SIOCGIWSCAN, &wrqu, NULL);
-  return 0;
-}
+		union iwreq_data wrqu;
+		PRINT_K("wireless_send_event--->SIOCGIWSCAN(scan done)\n");
+		memset(&wrqu, 0, sizeof(wrqu));
+		wireless_send_event(pDevice->dev, SIOCGIWSCAN, &wrqu, NULL);
+		return 0;
+	}
 
 	spin_lock_irq(&pDevice->lock);
 
 	BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
 
 //mike add: active scan OR passive scan OR desire_ssid scan
- if(wrq->length == sizeof(struct iw_scan_req)) {
-   if (wrq->flags & IW_SCAN_THIS_ESSID)  {                               //desire_ssid scan
-       memset(abyScanSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-       pItemSSID = (PWLAN_IE_SSID)abyScanSSID;
-       pItemSSID->byElementID = WLAN_EID_SSID;
-       memcpy(pItemSSID->abySSID, req->essid, (int)req->essid_len);
-         if (pItemSSID->abySSID[req->essid_len - 1] == '\0') {
-           if(req->essid_len>0)
-		pItemSSID->len = req->essid_len - 1;
-         }
-	else
-	  pItemSSID->len = req->essid_len;
-	  pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-         PRINT_K("SIOCSIWSCAN:[desired_ssid=%s,len=%d]\n",((PWLAN_IE_SSID)abyScanSSID)->abySSID,
-		 	                                                                                ((PWLAN_IE_SSID)abyScanSSID)->len);
-	bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, abyScanSSID);
-	spin_unlock_irq(&pDevice->lock);
+	if(wrq->length == sizeof(struct iw_scan_req)) {
+		if (wrq->flags & IW_SCAN_THIS_ESSID)  {                               //desire_ssid scan
+			memset(abyScanSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
+			pItemSSID = (PWLAN_IE_SSID)abyScanSSID;
+			pItemSSID->byElementID = WLAN_EID_SSID;
+			memcpy(pItemSSID->abySSID, req->essid, (int)req->essid_len);
+			if (pItemSSID->abySSID[req->essid_len - 1] == '\0') {
+				if(req->essid_len>0)
+					pItemSSID->len = req->essid_len - 1;
+			}
+			else
+				pItemSSID->len = req->essid_len;
+			pMgmt->eScanType = WMAC_SCAN_PASSIVE;
+			PRINT_K("SIOCSIWSCAN:[desired_ssid=%s,len=%d]\n",((PWLAN_IE_SSID)abyScanSSID)->abySSID,
+				((PWLAN_IE_SSID)abyScanSSID)->len);
+			bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, abyScanSSID);
+			spin_unlock_irq(&pDevice->lock);
+
+			return 0;
+		}
+		else if(req->scan_type == IW_SCAN_TYPE_PASSIVE) {          //passive scan
+			pMgmt->eScanType = WMAC_SCAN_PASSIVE;
+		}
+	}
+	else {           //active scan
+		pMgmt->eScanType = WMAC_SCAN_ACTIVE;
+	}
 
-	return 0;
-   }
-   else if(req->scan_type == IW_SCAN_TYPE_PASSIVE) {          //passive scan
-       pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-   }
- }
- else {           //active scan
-     pMgmt->eScanType = WMAC_SCAN_ACTIVE;
- }
-
-	 pMgmt->eScanType = WMAC_SCAN_PASSIVE;
+	pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 	bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 	spin_unlock_irq(&pDevice->lock);
 
@@ -172,12 +172,12 @@ if(pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
 int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-    int ii, jj, kk;
+	int ii, jj, kk;
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    PKnownBSS           pBSS;
-    PWLAN_IE_SSID       pItemSSID;
-    PWLAN_IE_SUPP_RATES pSuppRates, pExtSuppRates;
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PKnownBSS           pBSS;
+	PWLAN_IE_SSID       pItemSSID;
+	PWLAN_IE_SUPP_RATES pSuppRates, pExtSuppRates;
 	char *current_ev = extra;
 	char *end_buf = extra + IW_SCAN_MAX_DATA;
 	char *current_val = NULL;
@@ -185,131 +185,131 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 	long ldBm;
 	char buf[MAX_WPA_IE_LEN * 2 + 30];
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSCAN\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSCAN\n");
 
-    if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
-        // In scanning..
+	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
+		// In scanning..
 		return -EAGAIN;
 	}
 	pBSS = &(pMgmt->sBSSList[0]);
-    for (ii = 0, jj = 0; jj < MAX_BSS_NUM ; jj++) {
+	for (ii = 0, jj = 0; jj < MAX_BSS_NUM ; jj++) {
 		if (current_ev >= end_buf)
 			break;
-        pBSS = &(pMgmt->sBSSList[jj]);
-        if (pBSS->bActive) {
-		//ADD mac address
-		    memset(&iwe, 0, sizeof(iwe));
-		    iwe.cmd = SIOCGIWAP;
-		    iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
+		pBSS = &(pMgmt->sBSSList[jj]);
+		if (pBSS->bActive) {
+			//ADD mac address
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = SIOCGIWAP;
+			iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
 			memcpy(iwe.u.ap_addr.sa_data, pBSS->abyBSSID, WLAN_BSSID_LEN);
-                           current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
-                 //ADD ssid
-	             memset(&iwe, 0, sizeof(iwe));
-                      iwe.cmd = SIOCGIWESSID;
-                      pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
-                       iwe.u.data.length = pItemSSID->len;
-                       iwe.u.data.flags = 1;
-                      current_ev = iwe_stream_add_point(info,current_ev,end_buf, &iwe, pItemSSID->abySSID);
-		//ADD mode
-		    memset(&iwe, 0, sizeof(iwe));
-		    iwe.cmd = SIOCGIWMODE;
-            if (WLAN_GET_CAP_INFO_ESS(pBSS->wCapInfo)) {
-		        iwe.u.mode = IW_MODE_INFRA;
-            }
-            else {
-                iwe.u.mode = IW_MODE_ADHOC;
-		    }
-	        iwe.len = IW_EV_UINT_LEN;
-                      current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe,  IW_EV_UINT_LEN);
-           //ADD frequency
-            pSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abySuppRates;
-            pExtSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abyExtSuppRates;
-            memset(&iwe, 0, sizeof(iwe));
-           	iwe.cmd = SIOCGIWFREQ;
-           	iwe.u.freq.m = pBSS->uChannel;
-           	iwe.u.freq.e = 0;
-           	iwe.u.freq.i = 0;
-                  current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
+			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
+			//ADD ssid
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = SIOCGIWESSID;
+			pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
+			iwe.u.data.length = pItemSSID->len;
+			iwe.u.data.flags = 1;
+			current_ev = iwe_stream_add_point(info,current_ev,end_buf, &iwe, pItemSSID->abySSID);
+			//ADD mode
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = SIOCGIWMODE;
+			if (WLAN_GET_CAP_INFO_ESS(pBSS->wCapInfo)) {
+				iwe.u.mode = IW_MODE_INFRA;
+			}
+			else {
+				iwe.u.mode = IW_MODE_ADHOC;
+			}
+			iwe.len = IW_EV_UINT_LEN;
+			current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe,  IW_EV_UINT_LEN);
+			//ADD frequency
+			pSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abySuppRates;
+			pExtSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abyExtSuppRates;
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = SIOCGIWFREQ;
+			iwe.u.freq.m = pBSS->uChannel;
+			iwe.u.freq.e = 0;
+			iwe.u.freq.i = 0;
+			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
 			{
-			int f = (int)pBSS->uChannel - 1;
-			if(f < 0)f = 0;
-			iwe.u.freq.m = frequency_list[f] * 100000;
-			iwe.u.freq.e = 1;
+				int f = (int)pBSS->uChannel - 1;
+				if(f < 0)f = 0;
+				iwe.u.freq.m = frequency_list[f] * 100000;
+				iwe.u.freq.e = 1;
 			}
-                  current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
-       		//ADD quality
-            memset(&iwe, 0, sizeof(iwe));
-	        iwe.cmd = IWEVQUAL;
-	        RFvRSSITodBm(pDevice, (BYTE)(pBSS->uRSSI), &ldBm);
-		    iwe.u.qual.level = ldBm;
-	        iwe.u.qual.noise = 0;
+			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
+			//ADD quality
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = IWEVQUAL;
+			RFvRSSITodBm(pDevice, (BYTE)(pBSS->uRSSI), &ldBm);
+			iwe.u.qual.level = ldBm;
+			iwe.u.qual.noise = 0;
 
 			if(-ldBm<50){
 				iwe.u.qual.qual = 100;
 			}else  if(-ldBm > 90) {
-				 iwe.u.qual.qual = 0;
+				iwe.u.qual.qual = 0;
 			}else {
 				iwe.u.qual.qual=(40-(-ldBm-50))*100/40;
 			}
 			iwe.u.qual.updated=7;
 
-                 current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
-       	//ADD encryption
-            memset(&iwe, 0, sizeof(iwe));
-            iwe.cmd = SIOCGIWENCODE;
-            iwe.u.data.length = 0;
-            if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo)) {
-                iwe.u.data.flags =IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-            }else {
-                iwe.u.data.flags = IW_ENCODE_DISABLED;
-            }
-            current_ev = iwe_stream_add_point(info,current_ev,end_buf, &iwe, pItemSSID->abySSID);
-
-            memset(&iwe, 0, sizeof(iwe));
-            iwe.cmd = SIOCGIWRATE;
-           	iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
-      		current_val = current_ev + IW_EV_LCP_LEN;
-
-       		for (kk = 0 ; kk < 12 ; kk++) {
-		        if (pSuppRates->abyRates[kk] == 0)
-			        break;
-		        // Bit rate given in 500 kb/s units (+ 0x80)
-		        iwe.u.bitrate.value = ((pSuppRates->abyRates[kk] & 0x7f) * 500000);
-                          current_val = iwe_stream_add_value(info,current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
-	        }
-       		for (kk = 0 ; kk < 8 ; kk++) {
-		        if (pExtSuppRates->abyRates[kk] == 0)
-			        break;
-		        // Bit rate given in 500 kb/s units (+ 0x80)
-		        iwe.u.bitrate.value = ((pExtSuppRates->abyRates[kk] & 0x7f) * 500000);
-                         current_val = iwe_stream_add_value(info,current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
-	        }
-
-	        if((current_val - current_ev) > IW_EV_LCP_LEN)
-		        current_ev = current_val;
-
-            memset(&iwe, 0, sizeof(iwe));
-            iwe.cmd = IWEVCUSTOM;
-            sprintf(buf, "bcn_int=%d", pBSS->wBeaconInterval);
-            iwe.u.data.length = strlen(buf);
-             current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, buf);
-
-            if ((pBSS->wWPALen > 0) && (pBSS->wWPALen <= MAX_WPA_IE_LEN)) {
-                memset(&iwe, 0, sizeof(iwe));
-                iwe.cmd = IWEVGENIE;
-                iwe.u.data.length = pBSS->wWPALen;
-                current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, pBSS->byWPAIE);
-            }
-
-            if ((pBSS->wRSNLen > 0) && (pBSS->wRSNLen <= MAX_WPA_IE_LEN)) {
-                memset(&iwe, 0, sizeof(iwe));
-                iwe.cmd = IWEVGENIE;
-                iwe.u.data.length = pBSS->wRSNLen;
-                current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, pBSS->byRSNIE);
-            }
-
-        }
-    }// for
+			current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
+			//ADD encryption
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = SIOCGIWENCODE;
+			iwe.u.data.length = 0;
+			if (WLAN_GET_CAP_INFO_PRIVACY(pBSS->wCapInfo)) {
+				iwe.u.data.flags =IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
+			}else {
+				iwe.u.data.flags = IW_ENCODE_DISABLED;
+			}
+			current_ev = iwe_stream_add_point(info,current_ev,end_buf, &iwe, pItemSSID->abySSID);
+
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = SIOCGIWRATE;
+			iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
+			current_val = current_ev + IW_EV_LCP_LEN;
+
+			for (kk = 0 ; kk < 12 ; kk++) {
+				if (pSuppRates->abyRates[kk] == 0)
+					break;
+				// Bit rate given in 500 kb/s units (+ 0x80)
+				iwe.u.bitrate.value = ((pSuppRates->abyRates[kk] & 0x7f) * 500000);
+				current_val = iwe_stream_add_value(info,current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
+			}
+			for (kk = 0 ; kk < 8 ; kk++) {
+				if (pExtSuppRates->abyRates[kk] == 0)
+					break;
+				// Bit rate given in 500 kb/s units (+ 0x80)
+				iwe.u.bitrate.value = ((pExtSuppRates->abyRates[kk] & 0x7f) * 500000);
+				current_val = iwe_stream_add_value(info,current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
+			}
+
+			if((current_val - current_ev) > IW_EV_LCP_LEN)
+				current_ev = current_val;
+
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = IWEVCUSTOM;
+			sprintf(buf, "bcn_int=%d", pBSS->wBeaconInterval);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, buf);
+
+			if ((pBSS->wWPALen > 0) && (pBSS->wWPALen <= MAX_WPA_IE_LEN)) {
+				memset(&iwe, 0, sizeof(iwe));
+				iwe.cmd = IWEVGENIE;
+				iwe.u.data.length = pBSS->wWPALen;
+				current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, pBSS->byWPAIE);
+			}
+
+			if ((pBSS->wRSNLen > 0) && (pBSS->wRSNLen <= MAX_WPA_IE_LEN)) {
+				memset(&iwe, 0, sizeof(iwe));
+				iwe.cmd = IWEVGENIE;
+				iwe.u.data.length = pBSS->wRSNLen;
+				current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, pBSS->byRSNIE);
+			}
+
+		}
+	}// for
 	wrq->length = current_ev - extra;
 	return 0;
 }
@@ -323,12 +323,12 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	int rc = 0;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");
 
 	// If setting by frequency, convert to a channel
 	if((wrq->e == 1) &&
-	   (wrq->m >= (int) 2.412e8) &&
-	   (wrq->m <= (int) 2.487e8)) {
+		(wrq->m >= (int) 2.412e8) &&
+		(wrq->m <= (int) 2.487e8)) {
 		int f = wrq->m / 100000;
 		int c = 0;
 		while((c < 14) && (f != frequency_list[c]))
@@ -345,9 +345,9 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: New channel value of %d is invalid!\n", dev->name, wrq->m);
 			rc = -EINVAL;
 		} else {
-			  // Yes ! We can set it !!!
-              DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Set to channel = %d\n", channel);
-			  pDevice->uChannel = channel;
+			// Yes ! We can set it !!!
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " Set to channel = %d\n", channel);
+			pDevice->uChannel = channel;
 		}
 	}
 
@@ -361,9 +361,9 @@ int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 		struct iw_freq *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ \n");
 
 #ifdef WEXT_USECHANNELS
 	wrq->m = (int)pMgmt->uCurrChannel;
@@ -372,7 +372,7 @@ int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 	{
 		int f = (int)pMgmt->uCurrChannel - 1;
 		if(f < 0)
-		   f = 0;
+			f = 0;
 		wrq->m = frequency_list[f] * 100000;
 		wrq->e = 1;
 	}
@@ -387,54 +387,54 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 		__u32 *wmode, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    int rc = 0;
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	int rc = 0;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE \n");
 
-    if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP && pDevice->bEnableHostapd) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Can't set operation mode, hostapd is running \n");
-        return rc;
-    }
+	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP && pDevice->bEnableHostapd) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Can't set operation mode, hostapd is running \n");
+		return rc;
+	}
 
 	switch(*wmode) {
 
 	case IW_MODE_ADHOC:
-	    if (pMgmt->eConfigMode != WMAC_CONFIG_IBSS_STA) {
-            pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
-            if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-		        pDevice->bCommit = TRUE;
-   		    }
+		if (pMgmt->eConfigMode != WMAC_CONFIG_IBSS_STA) {
+			pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
+			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+				pDevice->bCommit = TRUE;
+			}
 		}
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to ad-hoc \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to ad-hoc \n");
 		break;
 	case IW_MODE_AUTO:
 	case IW_MODE_INFRA:
-	    if (pMgmt->eConfigMode != WMAC_CONFIG_ESS_STA) {
-            pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
-            if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-		        pDevice->bCommit = TRUE;
-   		    }
+		if (pMgmt->eConfigMode != WMAC_CONFIG_ESS_STA) {
+			pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
+			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+				pDevice->bCommit = TRUE;
+			}
 		}
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to infrastructure \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to infrastructure \n");
 		break;
 	case IW_MODE_MASTER:
 
-        pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
+		pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
 		rc = -EOPNOTSUPP;
 		break;
 
-	    if (pMgmt->eConfigMode != WMAC_CONFIG_AP) {
-            pMgmt->eConfigMode = WMAC_CONFIG_AP;
-            if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-		        pDevice->bCommit = TRUE;
-   		    }
+		if (pMgmt->eConfigMode != WMAC_CONFIG_AP) {
+			pMgmt->eConfigMode = WMAC_CONFIG_AP;
+			if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+				pDevice->bCommit = TRUE;
+			}
 		}
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to Access Point \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set mode to Access Point \n");
 		break;
 
 	case IW_MODE_REPEAT:
-        pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
+		pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
 		rc = -EOPNOTSUPP;
 		break;
 	default:
@@ -451,17 +451,17 @@ void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
 		__u32 *wmode, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE \n");
 	// If not managed, assume it's ad-hoc
 	switch (pMgmt->eConfigMode) {
 	case WMAC_CONFIG_ESS_STA:
 		*wmode = IW_MODE_INFRA;
 		break;
 	case WMAC_CONFIG_IBSS_STA:
-        *wmode = IW_MODE_ADHOC;
+		*wmode = IW_MODE_ADHOC;
 		break;
 	case WMAC_CONFIG_AUTO:
 		*wmode = IW_MODE_INFRA;
@@ -482,9 +482,9 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 {
 	struct iw_range *range = (struct iw_range *) extra;
 	int		i,k;
-    BYTE abySupportedRates[13]= {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
+	BYTE abySupportedRates[13]= {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRANGE\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRANGE\n");
 	if (wrq->pointer) {
 		wrq->length = sizeof(struct iw_range);
 		memset(range, 0, sizeof(struct iw_range));
@@ -501,7 +501,7 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		}
 		range->num_frequency = k;
 		// Hum... Should put the right values there
-                 range->max_qual.qual = 100;
+		range->max_qual.qual = 100;
 		range->max_qual.level = 0;
 		range->max_qual.noise = 0;
 		range->sensitivity = 255;
@@ -526,19 +526,19 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		range->min_frag = 256;
 		range->max_frag = 2312;
 
-	    // the encoding capabilities
-	    range->num_encoding_sizes = 3;
-	    // 64(40) bits WEP
-	    range->encoding_size[0] = 5;
-	    // 128(104) bits WEP
-	    range->encoding_size[1] = 13;
-	    // 256 bits for WPA-PSK
-	    range->encoding_size[2] = 32;
-	    // 4 keys are allowed
-	    range->max_encoding_tokens = 4;
+		// the encoding capabilities
+		range->num_encoding_sizes = 3;
+		// 64(40) bits WEP
+		range->encoding_size[0] = 5;
+		// 128(104) bits WEP
+		range->encoding_size[1] = 13;
+		// 256 bits for WPA-PSK
+		range->encoding_size[2] = 32;
+		// 4 keys are allowed
+		range->max_encoding_tokens = 4;
 
-	    range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
-		    IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
+		range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
+			IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
 		range->min_pmp = 0;
 		range->max_pmp = 1000000;// 1 secs
@@ -549,7 +549,7 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		range->pm_capa = IW_POWER_PERIOD | IW_POWER_TIMEOUT | IW_POWER_ALL_R;
 
 		// Transmit Power - values are in mW
-        range->txpower[0] = 100;
+		range->txpower[0] = 100;
 		range->num_txpower = 1;
 		range->txpower_capa = IW_TXPOW_MWATT;
 		range->we_version_source = SUPPORTED_WIRELESS_EXT;
@@ -577,41 +577,41 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 		struct sockaddr *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    int rc = 0;
-    BYTE                 ZeroBSSID[WLAN_BSSID_LEN]={0x00,0x00,0x00,0x00,0x00,0x00};
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	int rc = 0;
+	BYTE                 ZeroBSSID[WLAN_BSSID_LEN]={0x00,0x00,0x00,0x00,0x00,0x00};
 
-   PRINT_K(" SIOCSIWAP \n");
+	PRINT_K(" SIOCSIWAP \n");
 
 	if (wrq->sa_family != ARPHRD_ETHER)
 		rc = -EINVAL;
 	else {
 		memcpy(pMgmt->abyDesireBSSID, wrq->sa_data, 6);
-	//mike :add
-	 if ((is_broadcast_ether_addr(pMgmt->abyDesireBSSID)) ||
-	     (memcmp(pMgmt->abyDesireBSSID, ZeroBSSID, 6) == 0)){
-	      PRINT_K("SIOCSIWAP:invalid desired BSSID return!\n");
-               return rc;
-         }
-       //mike add: if desired AP is hidden ssid(there are two same BSSID in list),
-       //                  then ignore,because you don't known which one to be connect with??
-       	{
-		unsigned int ii, uSameBssidNum = 0;
-                  for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-                     if (pMgmt->sBSSList[ii].bActive &&
-			 !compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
-					     pMgmt->abyDesireBSSID)) {
-                        uSameBssidNum++;
-                     }
-                  }
-	     if(uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
-                 PRINT_K("SIOCSIWAP:ignore for desired AP in hidden mode\n");
-	        return rc;
-	     }
-       	}
-
-        if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-		    pDevice->bCommit = TRUE;
+		//mike :add
+		if ((is_broadcast_ether_addr(pMgmt->abyDesireBSSID)) ||
+			(memcmp(pMgmt->abyDesireBSSID, ZeroBSSID, 6) == 0)){
+			PRINT_K("SIOCSIWAP:invalid desired BSSID return!\n");
+			return rc;
+		}
+		//mike add: if desired AP is hidden ssid(there are two same BSSID in list),
+		//                  then ignore,because you don't known which one to be connect with??
+		{
+			unsigned int ii, uSameBssidNum = 0;
+			for (ii = 0; ii < MAX_BSS_NUM; ii++) {
+				if (pMgmt->sBSSList[ii].bActive &&
+					!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
+							pMgmt->abyDesireBSSID)) {
+					uSameBssidNum++;
+				}
+			}
+			if(uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
+				PRINT_K("SIOCSIWAP:ignore for desired AP in hidden mode\n");
+				return rc;
+			}
+		}
+
+		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+			pDevice->bCommit = TRUE;
    		}
 	}
 	return rc;
@@ -624,18 +624,18 @@ int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
 		struct sockaddr *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP \n");
 
-    memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
+	memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
 
- if ((pDevice->bLinkPass == FALSE) && (pMgmt->eCurrMode != WMAC_MODE_ESS_AP))
-        memset(wrq->sa_data, 0, 6);
+	if ((pDevice->bLinkPass == FALSE) && (pMgmt->eCurrMode != WMAC_MODE_ESS_AP))
+		memset(wrq->sa_data, 0, 6);
 
-    if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-        memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
-    }
+	if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
+		memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
+	}
 
 	wrq->sa_family = ARPHRD_ETHER;
 	return 0;
@@ -651,9 +651,9 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 	struct sockaddr sock[IW_MAX_AP];
 	struct iw_quality qual[IW_MAX_AP];
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAPLIST \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAPLIST \n");
 	// Only super-user can see AP list
 
 	if (!capable(CAP_NET_ADMIN)) {
@@ -665,11 +665,11 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 		PKnownBSS pBSS = &(pMgmt->sBSSList[0]);
 
 		for (ii = 0, jj= 0; ii < MAX_BSS_NUM; ii++) {
-		    pBSS = &(pMgmt->sBSSList[ii]);
-            if (!pBSS->bActive)
-                continue;
-            if ( jj >= IW_MAX_AP)
-                break;
+			pBSS = &(pMgmt->sBSSList[ii]);
+			if (!pBSS->bActive)
+				continue;
+			if ( jj >= IW_MAX_AP)
+				break;
 			memcpy(sock[jj].sa_data, pBSS->abyBSSID, 6);
 			sock[jj].sa_family = ARPHRD_ETHER;
 			qual[jj].level = pBSS->uRSSI;
@@ -693,105 +693,105 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    PWLAN_IE_SSID       pItemSSID;
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PWLAN_IE_SSID       pItemSSID;
 
-  if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
-        return -EINVAL;
+	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
+		return -EINVAL;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWESSID :\n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWESSID :\n");
 
-         pDevice->fWPA_Authened = FALSE;
+	pDevice->fWPA_Authened = FALSE;
 	// Check if we asked for `any'
 	if(wrq->flags == 0) {
 		// Just send an empty SSID list
 		memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-                  memset(pMgmt->abyDesireBSSID, 0xFF,6);
-	    PRINT_K("set essid to 'any' \n");
-           #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-             //Unknown desired AP,so here need not associate??
-                  return 0;
-            #endif
+		memset(pMgmt->abyDesireBSSID, 0xFF,6);
+		PRINT_K("set essid to 'any' \n");
+#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
+		//Unknown desired AP,so here need not associate??
+		return 0;
+#endif
 	} else {
 		// Set the SSID
 		memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-        pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
-        pItemSSID->byElementID = WLAN_EID_SSID;
+		pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
+		pItemSSID->byElementID = WLAN_EID_SSID;
 
 		memcpy(pItemSSID->abySSID, extra, wrq->length);
-         if (pItemSSID->abySSID[wrq->length - 1] == '\0') {
-           if(wrq->length>0)
-		pItemSSID->len = wrq->length - 1;
-         }
-	else
-	  pItemSSID->len = wrq->length;
-	PRINT_K("set essid to %s \n",pItemSSID->abySSID);
+		if (pItemSSID->abySSID[wrq->length - 1] == '\0') {
+			if(wrq->length>0)
+				pItemSSID->len = wrq->length - 1;
+		}
+		else
+			pItemSSID->len = wrq->length;
+		PRINT_K("set essid to %s \n",pItemSSID->abySSID);
 
-     //mike:need clear desiredBSSID
-     if(pItemSSID->len==0) {
-        memset(pMgmt->abyDesireBSSID, 0xFF,6);
-        return 0;
-     }
+		//mike:need clear desiredBSSID
+		if(pItemSSID->len==0) {
+			memset(pMgmt->abyDesireBSSID, 0xFF,6);
+			return 0;
+		}
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
- //Wext wil order another command of siwap to link with desired AP,
- //so here need not associate??
-  if(pDevice->bWPASuppWextEnabled == TRUE)  {
-        /*******search if  in hidden ssid mode ****/
-        {
-           PKnownBSS       pCurr = NULL;
-           BYTE                   abyTmpDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-	  unsigned int ii, uSameBssidNum = 0;
-
-	  memcpy(abyTmpDesireSSID,pMgmt->abyDesireSSID,sizeof(abyTmpDesireSSID));
-            pCurr = BSSpSearchBSSList(pDevice,
-                                      NULL,
-                                      abyTmpDesireSSID,
-                                      pDevice->eConfigPHYMode
-                                      );
-
-            if (pCurr == NULL){
-               PRINT_K("SIOCSIWESSID:hidden ssid site survey before associate.......\n");
-	      vResetCommandTimer((void *) pDevice);
-	      pMgmt->eScanType = WMAC_SCAN_ACTIVE;
-	      bScheduleCommand((void *) pDevice,
-			       WLAN_CMD_BSSID_SCAN,
-			       pMgmt->abyDesireSSID);
-	      bScheduleCommand((void *) pDevice,
-			       WLAN_CMD_SSID,
-			       pMgmt->abyDesireSSID);
-          }
-	 else {  //mike:to find out if that desired SSID is a hidden-ssid AP ,
-                     //         by means of judging if there are two same BSSID exist in list ?
-                  for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-                     if (pMgmt->sBSSList[ii].bActive &&
-			 !compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
-					     pCurr->abyBSSID)) {
-                        uSameBssidNum++;
-                     }
-                  }
-	     if(uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
-                 PRINT_K("SIOCSIWESSID:hidden ssid directly associate.......\n");
-		 vResetCommandTimer((void *) pDevice);
-	        pMgmt->eScanType = WMAC_SCAN_PASSIVE;          //this scan type,you'll submit scan result!
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_BSSID_SCAN,
-				 pMgmt->abyDesireSSID);
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_SSID,
-				 pMgmt->abyDesireSSID);
-	     }
-	 }
-        }
-     return 0;
-  }
-	     #endif
-
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set essid = %s \n", pItemSSID->abySSID);
+		//Wext wil order another command of siwap to link with desired AP,
+		//so here need not associate??
+		if(pDevice->bWPASuppWextEnabled == TRUE)  {
+			/*******search if  in hidden ssid mode ****/
+			{
+				PKnownBSS       pCurr = NULL;
+				BYTE                   abyTmpDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+				unsigned int ii, uSameBssidNum = 0;
+
+				memcpy(abyTmpDesireSSID,pMgmt->abyDesireSSID,sizeof(abyTmpDesireSSID));
+				pCurr = BSSpSearchBSSList(pDevice,
+							NULL,
+							abyTmpDesireSSID,
+							pDevice->eConfigPHYMode
+					);
+
+				if (pCurr == NULL){
+					PRINT_K("SIOCSIWESSID:hidden ssid site survey before associate.......\n");
+					vResetCommandTimer((void *) pDevice);
+					pMgmt->eScanType = WMAC_SCAN_ACTIVE;
+					bScheduleCommand((void *) pDevice,
+							WLAN_CMD_BSSID_SCAN,
+							pMgmt->abyDesireSSID);
+					bScheduleCommand((void *) pDevice,
+							WLAN_CMD_SSID,
+							pMgmt->abyDesireSSID);
+				}
+				else {  //mike:to find out if that desired SSID is a hidden-ssid AP ,
+					//         by means of judging if there are two same BSSID exist in list ?
+					for (ii = 0; ii < MAX_BSS_NUM; ii++) {
+						if (pMgmt->sBSSList[ii].bActive &&
+							!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
+									pCurr->abyBSSID)) {
+							uSameBssidNum++;
+						}
+					}
+					if(uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
+						PRINT_K("SIOCSIWESSID:hidden ssid directly associate.......\n");
+						vResetCommandTimer((void *) pDevice);
+						pMgmt->eScanType = WMAC_SCAN_PASSIVE;          //this scan type,you'll submit scan result!
+						bScheduleCommand((void *) pDevice,
+								WLAN_CMD_BSSID_SCAN,
+								pMgmt->abyDesireSSID);
+						bScheduleCommand((void *) pDevice,
+								WLAN_CMD_SSID,
+								pMgmt->abyDesireSSID);
+					}
+				}
+			}
+			return 0;
+		}
+#endif
+
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set essid = %s \n", pItemSSID->abySSID);
 	}
 
-    if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-	    pDevice->bCommit = TRUE;
+	if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+		pDevice->bCommit = TRUE;
 	}
 	return 0;
 }
@@ -803,16 +803,16 @@ void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID       pItemSSID;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID \n");
 
 	// Note : if wrq->u.data.flags != 0, we should
 	// get the relevant SSID from the SSID list...
 
 	// Get the current SSID
-    pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
+	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
 	memcpy(extra, pItemSSID->abySSID , pItemSSID->len);
 	extra[pItemSSID->len] = '\0';
 
@@ -827,23 +827,23 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    int rc = 0;
+	int rc = 0;
 	u8	brate = 0;
 	int	i;
 	BYTE abySupportedRates[13]= {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
 
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRATE \n");
-    if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
-        rc = -EINVAL;
-        return rc;
-    }
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRATE \n");
+	if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
+		rc = -EINVAL;
+		return rc;
+	}
 
 	// First : get a valid bit rate value
 
 	// Which type of value
 	if((wrq->value < 13) &&
-	   (wrq->value >= 0)) {
+		(wrq->value >= 0)) {
 		// Setting by rate index
 		// Find value in the magic rate table
 		brate = wrq->value;
@@ -882,19 +882,19 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		// Fixed mode
 		// One rate, fixed
 		pDevice->bFixRate = TRUE;
-        if ((pDevice->byBBType == BB_TYPE_11B)&& (brate > 3)) {
-            pDevice->uConnectionRate = 3;
-        }
-        else {
-            pDevice->uConnectionRate = brate;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fixed to Rate %d \n", pDevice->uConnectionRate);
-        }
+		if ((pDevice->byBBType == BB_TYPE_11B)&& (brate > 3)) {
+			pDevice->uConnectionRate = 3;
+		}
+		else {
+			pDevice->uConnectionRate = brate;
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Fixed to Rate %d \n", pDevice->uConnectionRate);
+		}
 
 	}
 	else {
-        pDevice->bFixRate = FALSE;
-        pDevice->uConnectionRate = 13;
-    }
+		pDevice->bFixRate = FALSE;
+		pDevice->uConnectionRate = 13;
+	}
 
 	return rc;
 }
@@ -906,38 +906,38 @@ void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE \n");
-    {
-        BYTE abySupportedRates[13]= {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
-	    int brate = 0;
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE \n");
+	{
+		BYTE abySupportedRates[13]= {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
+		int brate = 0;
 		if (pDevice->uConnectionRate < 13) {
-	        brate = abySupportedRates[pDevice->uConnectionRate];
-	    }else {
-            if (pDevice->byBBType == BB_TYPE_11B)
-	            brate = 0x16;
-            if (pDevice->byBBType == BB_TYPE_11G)
-	            brate = 0x6C;
-            if (pDevice->byBBType == BB_TYPE_11A)
-	            brate = 0x6C;
-	    }
-
-	    if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-            if (pDevice->byBBType == BB_TYPE_11B)
-	            brate = 0x16;
-            if (pDevice->byBBType == BB_TYPE_11G)
-	            brate = 0x6C;
-            if (pDevice->byBBType == BB_TYPE_11A)
-	            brate = 0x6C;
-	    }
+			brate = abySupportedRates[pDevice->uConnectionRate];
+		}else {
+			if (pDevice->byBBType == BB_TYPE_11B)
+				brate = 0x16;
+			if (pDevice->byBBType == BB_TYPE_11G)
+				brate = 0x6C;
+			if (pDevice->byBBType == BB_TYPE_11A)
+				brate = 0x6C;
+		}
+
+		if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
+			if (pDevice->byBBType == BB_TYPE_11B)
+				brate = 0x16;
+			if (pDevice->byBBType == BB_TYPE_11G)
+				brate = 0x6C;
+			if (pDevice->byBBType == BB_TYPE_11A)
+				brate = 0x6C;
+		}
     		if (pDevice->uConnectionRate == 13)
-                brate = abySupportedRates[pDevice->wCurrentRate];
-	    wrq->value = brate * 500000;
-	    // If more than one rate, set auto
-	    if (pDevice->bFixRate == TRUE)
-	        wrq->fixed = TRUE;
-    }
+			brate = abySupportedRates[pDevice->wCurrentRate];
+		wrq->value = brate * 500000;
+		// If more than one rate, set auto
+		if (pDevice->bFixRate == TRUE)
+			wrq->fixed = TRUE;
+	}
 }
 
 /*
@@ -966,7 +966,7 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS \n");
 	wrq->value = pDevice->wRTSThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
@@ -980,20 +980,20 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-    PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    int rc = 0;
-    int fthr = wrq->value;
+	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	int rc = 0;
+	int fthr = wrq->value;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFRAG \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFRAG \n");
 
-    if (wrq->disabled)
+	if (wrq->disabled)
 		fthr = 2312;
-    if((fthr < 256) || (fthr > 2312)) {
+	if((fthr < 256) || (fthr > 2312)) {
 		rc = -EINVAL;
-    }else {
-		 fthr &= ~0x1;	// Get an even value
-	     pDevice->wFragmentationThreshold = (u16)fthr;
-    }
+	}else {
+		fthr &= ~0x1;	// Get an even value
+		pDevice->wFragmentationThreshold = (u16)fthr;
+	}
 	return rc;
 }
 
@@ -1003,9 +1003,9 @@ int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-    PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG \n");
 	wrq->value = pDevice->wFragmentationThreshold;
 	wrq->disabled = (wrq->value >= 2312);
 	wrq->fixed = 1;
@@ -1019,10 +1019,10 @@ int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-    PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    int rc = 0;
+	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	int rc = 0;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY \n");
 
 	if (wrq->disabled) {
 		rc = -EINVAL;
@@ -1052,8 +1052,8 @@ int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-    PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");
+	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");
 	wrq->disabled = 0;      // Can't be disabled
 
 	// Note : by default, display the min retry number
@@ -1079,99 +1079,99 @@ int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-    PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	DWORD dwKeyIndex = (DWORD)(wrq->flags & IW_ENCODE_INDEX);
 	int ii,uu, rc = 0;
 	int index = (wrq->flags & IW_ENCODE_INDEX);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE \n");
 
 	// Check the size of the key
 	if (wrq->length > WLAN_WEP232_KEYLEN) {
 		rc = -EINVAL;
-        return rc;
+		return rc;
 	}
 
 	if (dwKeyIndex > WLAN_WEP_NKEYS) {
 		rc = -EINVAL;
-        return rc;
-    }
+		return rc;
+	}
 
-    if (dwKeyIndex > 0)
+	if (dwKeyIndex > 0)
 		dwKeyIndex--;
 
 	// Send the key to the card
 	if (wrq->length > 0) {
 
-        if (wrq->length ==  WLAN_WEP232_KEYLEN) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 232 bit wep key\n");
-        }
-        else if (wrq->length ==  WLAN_WEP104_KEYLEN) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 104 bit wep key\n");
-        }
-        else if (wrq->length == WLAN_WEP40_KEYLEN) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 40 bit wep key, index= %d\n", (int)dwKeyIndex);
-        }
-        memset(pDevice->abyKey, 0, WLAN_WEP232_KEYLEN);
-        memcpy(pDevice->abyKey, extra, wrq->length);
-
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"abyKey: ");
-        for (ii = 0; ii < wrq->length; ii++) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pDevice->abyKey[ii]);
-        }
-
-        if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-            spin_lock_irq(&pDevice->lock);
-            KeybSetDefaultKey(  pDevice,
-                                &(pDevice->sKey),
-                                dwKeyIndex | (1 << 31),
-                                wrq->length,
-                                NULL,
-                                pDevice->abyKey,
-                                KEY_CTL_WEP
-                              );
-            spin_unlock_irq(&pDevice->lock);
-        }
-        pDevice->byKeyIndex = (BYTE)dwKeyIndex;
-        pDevice->uKeyLength = wrq->length;
-        pDevice->bTransmitKey = TRUE;
-        pDevice->bEncryptionEnable = TRUE;
-        pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
+		if (wrq->length ==  WLAN_WEP232_KEYLEN) {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 232 bit wep key\n");
+		}
+		else if (wrq->length ==  WLAN_WEP104_KEYLEN) {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 104 bit wep key\n");
+		}
+		else if (wrq->length == WLAN_WEP40_KEYLEN) {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 40 bit wep key, index= %d\n", (int)dwKeyIndex);
+		}
+		memset(pDevice->abyKey, 0, WLAN_WEP232_KEYLEN);
+		memcpy(pDevice->abyKey, extra, wrq->length);
+
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"abyKey: ");
+		for (ii = 0; ii < wrq->length; ii++) {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%02x ", pDevice->abyKey[ii]);
+		}
+
+		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+			spin_lock_irq(&pDevice->lock);
+			KeybSetDefaultKey(  pDevice,
+					&(pDevice->sKey),
+					dwKeyIndex | (1 << 31),
+					wrq->length,
+					NULL,
+					pDevice->abyKey,
+					KEY_CTL_WEP
+				);
+			spin_unlock_irq(&pDevice->lock);
+		}
+		pDevice->byKeyIndex = (BYTE)dwKeyIndex;
+		pDevice->uKeyLength = wrq->length;
+		pDevice->bTransmitKey = TRUE;
+		pDevice->bEncryptionEnable = TRUE;
+		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 
 		// Do we want to just set the transmit key index ?
 		if ( index < 4 ) {
-		    pDevice->byKeyIndex = index;
+			pDevice->byKeyIndex = index;
 		} else if (!(wrq->flags & IW_ENCODE_MODE)) {
-				rc = -EINVAL;
-				return rc;
-	    }
+			rc = -EINVAL;
+			return rc;
+		}
 	}
 	// Read the flags
 	if(wrq->flags & IW_ENCODE_DISABLED){
 
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable WEP function\n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disable WEP function\n");
 		pMgmt->bShareKeyAlgorithm = FALSE;
-        pDevice->bEncryptionEnable = FALSE;
-        pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-        if (pDevice->flags & DEVICE_FLAGS_OPENED) {
-            spin_lock_irq(&pDevice->lock);
-	    for (uu = 0; uu < MAX_KEY_TABLE; uu++)
-		MACvDisableKeyEntry(pDevice, uu);
-            spin_unlock_irq(&pDevice->lock);
-        }
+		pDevice->bEncryptionEnable = FALSE;
+		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
+		if (pDevice->flags & DEVICE_FLAGS_OPENED) {
+			spin_lock_irq(&pDevice->lock);
+			for (uu = 0; uu < MAX_KEY_TABLE; uu++)
+				MACvDisableKeyEntry(pDevice, uu);
+			spin_unlock_irq(&pDevice->lock);
+		}
 	}
 	if(wrq->flags & IW_ENCODE_RESTRICTED) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & ShareKey System\n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & ShareKey System\n");
 		pMgmt->bShareKeyAlgorithm = TRUE;
 	}
 	if(wrq->flags & IW_ENCODE_OPEN) {
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & Open System\n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enable WEP & Open System\n");
 		pMgmt->bShareKeyAlgorithm = FALSE;
 	}
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-	   memset(pMgmt->abyDesireBSSID, 0xFF,6);
+	memset(pMgmt->abyDesireBSSID, 0xFF,6);
 #endif
 	return rc;
 }
@@ -1195,9 +1195,9 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 		if(pDevice->byKeyIndex<WLAN_WEP_NKEYS){
 			index=pDevice->byKeyIndex;
          	} else
-                      index=0;
+			index=0;
 	}else
-             index--;
+		index--;
 
 	memset(abyKey, 0, WLAN_WEP232_KEYLEN);
 	// Check encryption mode
@@ -1212,18 +1212,18 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 		wrq->flags |=  IW_ENCODE_RESTRICTED;
 	else
 		wrq->flags |=  IW_ENCODE_OPEN;
-		wrq->length=0;
+	wrq->length=0;
 
 	if((index==0)&&(pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled||
-		pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)){//get wpa pairwise  key
-			if (KeybGetKey(&(pDevice->sKey),pMgmt->abyCurrBSSID, 0xffffffff, &pKey)){
-			   wrq->length = pKey->uKeyLength;
-				  memcpy(abyKey, pKey->abyKey,	pKey->uKeyLength);
-				  memcpy(extra,  abyKey, WLAN_WEP232_KEYLEN);
-			   }
-	}else if (KeybGetKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, (BYTE)index , &pKey)){
+				pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)){//get wpa pairwise  key
+		if (KeybGetKey(&(pDevice->sKey),pMgmt->abyCurrBSSID, 0xffffffff, &pKey)){
 			wrq->length = pKey->uKeyLength;
-			memcpy(abyKey, pKey->abyKey,  pKey->uKeyLength);
+			memcpy(abyKey, pKey->abyKey,	pKey->uKeyLength);
+			memcpy(extra,  abyKey, WLAN_WEP232_KEYLEN);
+		}
+	}else if (KeybGetKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, (BYTE)index , &pKey)){
+		wrq->length = pKey->uKeyLength;
+		memcpy(abyKey, pKey->abyKey,  pKey->uKeyLength);
 		memcpy(extra,  abyKey, WLAN_WEP232_KEYLEN);
 	}
 
@@ -1237,15 +1237,15 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-    PSDevice            pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    int rc = 0;
+	PSDevice            pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	int rc = 0;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER \n");
 
-    if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
-		 rc = -EINVAL;
-		 return rc;
+	if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
+		rc = -EINVAL;
+		return rc;
 	}
 
 	if (wrq->disabled) {
@@ -1254,23 +1254,23 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		return rc;
 	}
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
-         pDevice->ePSMode = WMAC_POWER_FAST;
-	 PSvEnablePowerSaving((void *) pDevice, pMgmt->wListenInterval);
+		pDevice->ePSMode = WMAC_POWER_FAST;
+		PSvEnablePowerSaving((void *) pDevice, pMgmt->wListenInterval);
 
 	} else if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_PERIOD) {
-	     pDevice->ePSMode = WMAC_POWER_FAST;
-	     PSvEnablePowerSaving((void *) pDevice, pMgmt->wListenInterval);
+		pDevice->ePSMode = WMAC_POWER_FAST;
+		PSvEnablePowerSaving((void *) pDevice, pMgmt->wListenInterval);
 	}
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R \n");
 		rc = -EINVAL;
 		break;
 	case IW_POWER_ALL_R:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ALL_R \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ALL_R \n");
 		rc = -EINVAL;
 	case IW_POWER_ON:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ON \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_ON \n");
 		break;
 	default:
 		rc = -EINVAL;
@@ -1285,14 +1285,14 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-    PSDevice            pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    int mode = pDevice->ePSMode;
+	PSDevice            pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	int mode = pDevice->ePSMode;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER \n");
 
 	if ((wrq->disabled = (mode == WMAC_POWER_CAM)))
-	    return 0;
+		return 0;
 
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
 		wrq->value = (int)((pMgmt->wListenInterval * pMgmt->wCurrBeaconPeriod) << 10);
@@ -1311,17 +1311,17 @@ int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-    PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    long ldBm;
+	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	long ldBm;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS \n");
-    if (pDevice->bLinkPass == TRUE) {
-        RFvRSSITodBm(pDevice, (BYTE)(pDevice->uCurrRSSI), &ldBm);
-	    wrq->value = ldBm;
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS \n");
+	if (pDevice->bLinkPass == TRUE) {
+		RFvRSSITodBm(pDevice, (BYTE)(pDevice->uCurrRSSI), &ldBm);
+		wrq->value = ldBm;
 	}
 	else {
-	    wrq->value = 0;
-    };
+		wrq->value = 0;
+	};
 	wrq->disabled = (wrq->value == 0);
 	wrq->fixed = 1;
 	return 0;
@@ -1338,29 +1338,29 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 	static int wpa_version=0;  //must be static to save the last value,einsn liu
 	static int pairwise=0;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH \n");
 	switch (wrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
 		wpa_version = wrq->value;
 		if(wrq->value == IW_AUTH_WPA_VERSION_DISABLED) {
-		       PRINT_K("iwctl_siwauth:set WPADEV to disable at 1??????\n");
+			PRINT_K("iwctl_siwauth:set WPADEV to disable at 1??????\n");
 		}
 		else if(wrq->value == IW_AUTH_WPA_VERSION_WPA) {
-                          PRINT_K("iwctl_siwauth:set WPADEV to WPA1******\n");
+			PRINT_K("iwctl_siwauth:set WPADEV to WPA1******\n");
 		}
 		else {
-                          PRINT_K("iwctl_siwauth:set WPADEV to WPA2******\n");
+			PRINT_K("iwctl_siwauth:set WPADEV to WPA2******\n");
 		}
 		break;
 	case IW_AUTH_CIPHER_PAIRWISE:
 		pairwise = wrq->value;
-                   PRINT_K("iwctl_siwauth:set pairwise=%d\n",pairwise);
+		PRINT_K("iwctl_siwauth:set pairwise=%d\n",pairwise);
 		if(pairwise == IW_AUTH_CIPHER_CCMP){
 			pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
 		}else if(pairwise == IW_AUTH_CIPHER_TKIP){
 			pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
 		} else if (pairwise == IW_AUTH_CIPHER_WEP40 ||
-			   pairwise == IW_AUTH_CIPHER_WEP104) {
+			pairwise == IW_AUTH_CIPHER_WEP104) {
 			pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 		}else if(pairwise == IW_AUTH_CIPHER_NONE){
 			//do nothing,einsn liu
@@ -1368,7 +1368,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 
 		break;
 	case IW_AUTH_CIPHER_GROUP:
-		 PRINT_K("iwctl_siwauth:set GROUP=%d\n",wrq->value);
+		PRINT_K("iwctl_siwauth:set GROUP=%d\n",wrq->value);
 		if(wpa_version == IW_AUTH_WPA_VERSION_DISABLED)
 			break;
 		if(pairwise == IW_AUTH_CIPHER_NONE){
@@ -1380,7 +1380,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		}
 		break;
 	case IW_AUTH_KEY_MGMT:
-                    PRINT_K("iwctl_siwauth(wpa_version=%d):set KEY_MGMT=%d\n",wpa_version,wrq->value);
+		PRINT_K("iwctl_siwauth(wpa_version=%d):set KEY_MGMT=%d\n",wpa_version,wrq->value);
 		if(wpa_version == IW_AUTH_WPA_VERSION_WPA2){
 			if(wrq->value == IW_AUTH_KEY_MGMT_PSK)
 				pMgmt->eAuthenMode = WMAC_AUTH_WPA2PSK;
@@ -1398,7 +1398,7 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 	case IW_AUTH_DROP_UNENCRYPTED:
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
-		 PRINT_K("iwctl_siwauth:set AUTH_ALG=%d\n",wrq->value);
+		PRINT_K("iwctl_siwauth:set AUTH_ALG=%d\n",wrq->value);
 		if(wrq->value==IW_AUTH_ALG_OPEN_SYSTEM){
 			pMgmt->bShareKeyAlgorithm=FALSE;
 		}else if(wrq->value==IW_AUTH_ALG_SHARED_KEY){
@@ -1420,14 +1420,14 @@ int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 			pMgmt->bShareKeyAlgorithm = FALSE;
 			pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-			 PRINT_K("iwctl_siwauth:set WPADEV to disaable at 2?????\n");
+			PRINT_K("iwctl_siwauth:set WPADEV to disaable at 2?????\n");
 		}
 		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
 	}
-   return ret;
+	return ret;
 }
 
 int iwctl_giwauth(struct net_device *dev, struct iw_request_info *info,
@@ -1463,12 +1463,12 @@ int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 		pMgmt->wWPAIELen = 0;
 	}
 
-	out://not completely ...not necessary in wpa_supplicant 0.5.8
+out://not completely ...not necessary in wpa_supplicant 0.5.8
 	return ret;
 }
 
 int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
-			  struct iw_point *wrq, char *extra)
+		struct iw_point *wrq, char *extra)
 {
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
@@ -1489,132 +1489,132 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 }
 
 int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
-             struct iw_point *wrq, char *extra)
+		struct iw_point *wrq, char *extra)
 {
-    PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
+	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
 	struct iw_encode_ext *ext = (struct iw_encode_ext*)extra;
-    struct viawget_wpa_param *param=NULL;
+	struct viawget_wpa_param *param=NULL;
 //original member
-    wpa_alg alg_name;
-    u8  addr[6];
-    int key_idx, set_tx=0;
-    u8  seq[IW_ENCODE_SEQ_MAX_SIZE];
-    u8 key[64];
-    size_t seq_len=0,key_len=0;
-    u8 *buf;
-    size_t blen;
-    u8 key_array[64];
-    int ret=0;
-
-PRINT_K("SIOCSIWENCODEEXT...... \n");
-
-blen = sizeof(*param);
-buf = kmalloc((int)blen, (int)GFP_KERNEL);
-if (buf == NULL)
-    return -ENOMEM;
-memset(buf, 0, blen);
-param = (struct viawget_wpa_param *) buf;
+	wpa_alg alg_name;
+	u8  addr[6];
+	int key_idx, set_tx=0;
+	u8  seq[IW_ENCODE_SEQ_MAX_SIZE];
+	u8 key[64];
+	size_t seq_len=0,key_len=0;
+	u8 *buf;
+	size_t blen;
+	u8 key_array[64];
+	int ret=0;
+
+	PRINT_K("SIOCSIWENCODEEXT...... \n");
+
+	blen = sizeof(*param);
+	buf = kmalloc((int)blen, (int)GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+	memset(buf, 0, blen);
+	param = (struct viawget_wpa_param *) buf;
 
 //recover alg_name
-switch (ext->alg) {
-    case IW_ENCODE_ALG_NONE:
-                  alg_name = WPA_ALG_NONE;
+	switch (ext->alg) {
+	case IW_ENCODE_ALG_NONE:
+		alg_name = WPA_ALG_NONE;
 		break;
-    case IW_ENCODE_ALG_WEP:
-                  alg_name = WPA_ALG_WEP;
+	case IW_ENCODE_ALG_WEP:
+		alg_name = WPA_ALG_WEP;
 		break;
-    case IW_ENCODE_ALG_TKIP:
-                  alg_name = WPA_ALG_TKIP;
+	case IW_ENCODE_ALG_TKIP:
+		alg_name = WPA_ALG_TKIP;
 		break;
-    case IW_ENCODE_ALG_CCMP:
-                  alg_name = WPA_ALG_CCMP;
+	case IW_ENCODE_ALG_CCMP:
+		alg_name = WPA_ALG_CCMP;
 		break;
-    default:
+	default:
 		PRINT_K("Unknown alg = %d\n",ext->alg);
 		ret= -ENOMEM;
 		goto error;
-		}
+	}
 //recover addr
- memcpy(addr, ext->addr.sa_data, ETH_ALEN);
+	memcpy(addr, ext->addr.sa_data, ETH_ALEN);
 //recover key_idx
-  key_idx = (wrq->flags&IW_ENCODE_INDEX) - 1;
+	key_idx = (wrq->flags&IW_ENCODE_INDEX) - 1;
 //recover set_tx
-if(ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
-   set_tx = 1;
+	if(ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
+		set_tx = 1;
 //recover seq,seq_len
 	if(ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
-   seq_len=IW_ENCODE_SEQ_MAX_SIZE;
-   memcpy(seq, ext->rx_seq, seq_len);
-		}
-//recover key,key_len
-if(ext->key_len) {
-  key_len=ext->key_len;
-  memcpy(key, &ext->key[0], key_len);
+		seq_len=IW_ENCODE_SEQ_MAX_SIZE;
+		memcpy(seq, ext->rx_seq, seq_len);
 	}
-memset(key_array, 0, 64);
-if ( key_len > 0) {
-     memcpy(key_array, key, key_len);
-    if (key_len == 32) {
-          // notice ! the oder
-	  memcpy(&key_array[16], &key[24], 8);
-	  memcpy(&key_array[24], &key[16], 8);
+//recover key,key_len
+	if(ext->key_len) {
+		key_len=ext->key_len;
+		memcpy(key, &ext->key[0], key_len);
 	}
+	memset(key_array, 0, 64);
+	if ( key_len > 0) {
+		memcpy(key_array, key, key_len);
+		if (key_len == 32) {
+			// notice ! the oder
+			memcpy(&key_array[16], &key[24], 8);
+			memcpy(&key_array[24], &key[16], 8);
+		}
 	}
 
 /**************Translate iw_encode_ext to viawget_wpa_param****************/
-memcpy(param->addr, addr, ETH_ALEN);
-param->u.wpa_key.alg_name = (int)alg_name;
-param->u.wpa_key.set_tx = set_tx;
-param->u.wpa_key.key_index = key_idx;
-param->u.wpa_key.key_len = key_len;
-param->u.wpa_key.key = (u8 *)key_array;
-param->u.wpa_key.seq = (u8 *)seq;
-param->u.wpa_key.seq_len = seq_len;
+	memcpy(param->addr, addr, ETH_ALEN);
+	param->u.wpa_key.alg_name = (int)alg_name;
+	param->u.wpa_key.set_tx = set_tx;
+	param->u.wpa_key.key_index = key_idx;
+	param->u.wpa_key.key_len = key_len;
+	param->u.wpa_key.key = (u8 *)key_array;
+	param->u.wpa_key.seq = (u8 *)seq;
+	param->u.wpa_key.seq_len = seq_len;
 
 //****set if current action is Network Manager count??
 //****this method is so foolish,but there is no other way???
-if(param->u.wpa_key.alg_name == WPA_ALG_NONE) {
-   if(param->u.wpa_key.key_index ==0) {
-     pDevice->bwextstep0 = TRUE;
-    }
-   if ((pDevice->bwextstep0 == TRUE) && (param->u.wpa_key.key_index == 1)) {
-     pDevice->bwextstep0 = FALSE;
-     pDevice->bwextstep1 = TRUE;
-    }
-   if ((pDevice->bwextstep1 == TRUE) && (param->u.wpa_key.key_index == 2)) {
-     pDevice->bwextstep1 = FALSE;
-     pDevice->bwextstep2 = TRUE;
+	if(param->u.wpa_key.alg_name == WPA_ALG_NONE) {
+		if(param->u.wpa_key.key_index ==0) {
+			pDevice->bwextstep0 = TRUE;
+		}
+		if ((pDevice->bwextstep0 == TRUE) && (param->u.wpa_key.key_index == 1)) {
+			pDevice->bwextstep0 = FALSE;
+			pDevice->bwextstep1 = TRUE;
+		}
+		if ((pDevice->bwextstep1 == TRUE) && (param->u.wpa_key.key_index == 2)) {
+			pDevice->bwextstep1 = FALSE;
+			pDevice->bwextstep2 = TRUE;
+		}
+		if ((pDevice->bwextstep2 == TRUE)&&(param->u.wpa_key.key_index == 3)) {
+			pDevice->bwextstep2 = FALSE;
+			pDevice->bwextstep3 = TRUE;
+		}
+	}
+	if(pDevice->bwextstep3 == TRUE) {
+		PRINT_K("SIOCSIWENCODEEXT:Enable WPA WEXT SUPPORT!!!!!\n");
+		pDevice->bwextstep0 = FALSE;
+		pDevice->bwextstep1 = FALSE;
+		pDevice->bwextstep2 = FALSE;
+		pDevice->bwextstep3 = FALSE;
+		pDevice->bWPASuppWextEnabled = TRUE;
+		memset(pMgmt->abyDesireBSSID, 0xFF,6);
+		KeyvInitTable(pDevice,&pDevice->sKey);
 	}
-   if ((pDevice->bwextstep2 == TRUE)&&(param->u.wpa_key.key_index == 3)) {
-     pDevice->bwextstep2 = FALSE;
-     pDevice->bwextstep3 = TRUE;
-        }
-		 }
-if(pDevice->bwextstep3 == TRUE) {
-    PRINT_K("SIOCSIWENCODEEXT:Enable WPA WEXT SUPPORT!!!!!\n");
-     pDevice->bwextstep0 = FALSE;
-     pDevice->bwextstep1 = FALSE;
-     pDevice->bwextstep2 = FALSE;
-     pDevice->bwextstep3 = FALSE;
-     pDevice->bWPASuppWextEnabled = TRUE;
-     memset(pMgmt->abyDesireBSSID, 0xFF,6);
-     KeyvInitTable(pDevice,&pDevice->sKey);
-		 }
 //******
-		spin_lock_irq(&pDevice->lock);
- ret = wpa_set_keys(pDevice, param, TRUE);
-		spin_unlock_irq(&pDevice->lock);
+	spin_lock_irq(&pDevice->lock);
+	ret = wpa_set_keys(pDevice, param, TRUE);
+	spin_unlock_irq(&pDevice->lock);
 
 error:
-kfree(param);
+	kfree(param);
 	return ret;
 }
 
 int iwctl_giwencodeext(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-		return -EOPNOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
@@ -1633,10 +1633,10 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 	case IW_MLME_DEAUTH:
 	case IW_MLME_DISASSOC:
 		if(pDevice->bLinkPass == TRUE){
-		  PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
-		  bScheduleCommand((void *) pDevice,
-				   WLAN_CMD_DISASSOCIATE,
-				   NULL);
+			PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
+			bScheduleCommand((void *) pDevice,
+					WLAN_CMD_DISASSOCIATE,
+					NULL);
 		}
 		break;
 	default:
@@ -1665,7 +1665,7 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) NULL,             		// SIOCGIWPRIV
 	(iw_handler) NULL,             		// SIOCSIWSTATS
 	(iw_handler) NULL,                  // SIOCGIWSTATS
-    (iw_handler) NULL,                  // SIOCSIWSPY
+	(iw_handler) NULL,                  // SIOCSIWSPY
 	(iw_handler) NULL,		            // SIOCGIWSPY
 	(iw_handler) NULL,				    // -- hole --
 	(iw_handler) NULL,				    // -- hole --
@@ -1713,9 +1713,9 @@ static const iw_handler		iwctl_private_handler[] =
 };
 
 struct iw_priv_args iwctl_private_args[] = {
-{ IOCTL_CMD_SET,
-  IW_PRIV_TYPE_CHAR | 1024, 0,
-  "set"},
+	{ IOCTL_CMD_SET,
+	  IW_PRIV_TYPE_CHAR | 1024, 0,
+	  "set"},
 };
 
 const struct iw_handler_def	iwctl_handler_def =
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

