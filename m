Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2FXX5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:57:20 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12320 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2FXX5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:57:14 -0400
Date: Mon, 25 Jun 2012 01:57:13 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] staging: vt6656: iwctl: remove spaces between casts
 and variables
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250151570.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not usually write a space between a cast and the variable being
converted. this patch removes such spaces where they occour in iwctl.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 148 ++++++++++++++++++++---------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 3249a01..9b7d752 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -70,7 +70,7 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	pDevice->wstats.status = pDevice->eOPMode;
 	if(pDevice->scStatistic.LinkQuality > 100)
 		pDevice->scStatistic.LinkQuality = 100;
-	pDevice->wstats.qual.qual =(BYTE) pDevice->scStatistic.LinkQuality;
+	pDevice->wstats.qual.qual =(BYTE)pDevice->scStatistic.LinkQuality;
 	RFvRSSITodBm(pDevice, (BYTE)(pDevice->uCurrRSSI), &ldBm);
 	pDevice->wstats.qual.level = ldBm;
 	pDevice->wstats.qual.noise = 0;
@@ -128,7 +128,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 
 	spin_lock_irq(&pDevice->lock);
 
-	BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
+	BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
 
 //mike add: active scan OR passive scan OR desire_ssid scan
 	if(wrq->length == sizeof(struct iw_scan_req)) {
@@ -146,7 +146,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 			pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 			PRINT_K("SIOCSIWSCAN:[desired_ssid=%s,len=%d]\n",((PWLAN_IE_SSID)abyScanSSID)->abySSID,
 				((PWLAN_IE_SSID)abyScanSSID)->len);
-			bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, abyScanSSID);
+			bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, abyScanSSID);
 			spin_unlock_irq(&pDevice->lock);
 
 			return 0;
@@ -160,7 +160,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 	}
 
 	pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-	bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
+	bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 	spin_unlock_irq(&pDevice->lock);
 
 	return 0;
@@ -330,8 +330,8 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 
 	// If setting by frequency, convert to a channel
 	if((wrq->e == 1) &&
-		(wrq->m >= (int) 2.412e8) &&
-		(wrq->m <= (int) 2.487e8)) {
+		(wrq->m >= (int)2.412e8) &&
+		(wrq->m <= (int)2.487e8)) {
 		int f = wrq->m / 100000;
 		int c = 0;
 		while((c < 14) && (f != frequency_list[c]))
@@ -483,7 +483,7 @@ void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
 void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	struct iw_range *range = (struct iw_range *) extra;
+	struct iw_range *range = (struct iw_range *)extra;
 	int i;
 	int k;
 	BYTE abySupportedRates[13] = {
@@ -761,12 +761,12 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 
 			if (pCurr == NULL){
 				PRINT_K("SIOCSIWESSID:hidden ssid site survey before associate.......\n");
-				vResetCommandTimer((void *) pDevice);
+				vResetCommandTimer((void *)pDevice);
 				pMgmt->eScanType = WMAC_SCAN_ACTIVE;
-				bScheduleCommand((void *) pDevice,
+				bScheduleCommand((void *)pDevice,
 						WLAN_CMD_BSSID_SCAN,
 						pMgmt->abyDesireSSID);
-				bScheduleCommand((void *) pDevice,
+				bScheduleCommand((void *)pDevice,
 						WLAN_CMD_SSID,
 						pMgmt->abyDesireSSID);
 			}
@@ -781,12 +781,12 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 				}
 				if(uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
 					PRINT_K("SIOCSIWESSID:hidden ssid directly associate.......\n");
-					vResetCommandTimer((void *) pDevice);
+					vResetCommandTimer((void *)pDevice);
 					pMgmt->eScanType = WMAC_SCAN_PASSIVE;          //this scan type,you'll submit scan result!
-					bScheduleCommand((void *) pDevice,
+					bScheduleCommand((void *)pDevice,
 							WLAN_CMD_BSSID_SCAN,
 							pMgmt->abyDesireSSID);
-					bScheduleCommand((void *) pDevice,
+					bScheduleCommand((void *)pDevice,
 							WLAN_CMD_SSID,
 							pMgmt->abyDesireSSID);
 				}
@@ -1272,11 +1272,11 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 	}
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
 		pDevice->ePSMode = WMAC_POWER_FAST;
-		PSvEnablePowerSaving((void *) pDevice, pMgmt->wListenInterval);
+		PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
 
 	} else if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_PERIOD) {
 		pDevice->ePSMode = WMAC_POWER_FAST;
-		PSvEnablePowerSaving((void *) pDevice, pMgmt->wListenInterval);
+		PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
 	}
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
@@ -1533,7 +1533,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	if (buf == NULL)
 		return -ENOMEM;
 	memset(buf, 0, blen);
-	param = (struct viawget_wpa_param *) buf;
+	param = (struct viawget_wpa_param *)buf;
 
 //recover alg_name
 	switch (ext->alg) {
@@ -1653,7 +1653,7 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 	case IW_MLME_DISASSOC:
 		if(pDevice->bLinkPass == TRUE){
 			PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
-			bScheduleCommand((void *) pDevice,
+			bScheduleCommand((void *)pDevice,
 					WLAN_CMD_DISASSOCIATE,
 					NULL);
 		}
@@ -1667,62 +1667,62 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 #endif
 
 static const iw_handler iwctl_handler[] = {
-	(iw_handler) NULL,      /* SIOCSIWCOMMIT */
-	(iw_handler) NULL,      // SIOCGIWNAME
-	(iw_handler) NULL,				// SIOCSIWNWID
-	(iw_handler) NULL,				// SIOCGIWNWID
-	(iw_handler) NULL,		// SIOCSIWFREQ
-	(iw_handler) NULL,		// SIOCGIWFREQ
-	(iw_handler) NULL,		// SIOCSIWMODE
-	(iw_handler) NULL,		// SIOCGIWMODE
-	(iw_handler) NULL,		        // SIOCSIWSENS
-	(iw_handler) NULL,		        // SIOCGIWSENS
-	(iw_handler) NULL, 		        // SIOCSIWRANGE
-	(iw_handler) iwctl_giwrange,		// SIOCGIWRANGE
-	(iw_handler) NULL,         		    // SIOCSIWPRIV
-	(iw_handler) NULL,             		// SIOCGIWPRIV
-	(iw_handler) NULL,             		// SIOCSIWSTATS
-	(iw_handler) NULL,                  // SIOCGIWSTATS
-	(iw_handler) NULL,                  // SIOCSIWSPY
-	(iw_handler) NULL,		            // SIOCGIWSPY
-	(iw_handler) NULL,				    // -- hole --
-	(iw_handler) NULL,				    // -- hole --
-	(iw_handler) NULL,		    // SIOCSIWAP
-	(iw_handler) NULL,		    // SIOCGIWAP
-	(iw_handler) NULL,				    // -- hole -- 0x16
-	(iw_handler) NULL,       // SIOCGIWAPLIST
-	(iw_handler) iwctl_siwscan,         // SIOCSIWSCAN
-	(iw_handler) iwctl_giwscan,         // SIOCGIWSCAN
-	(iw_handler) NULL,		// SIOCSIWESSID
-	(iw_handler) NULL,		// SIOCGIWESSID
-	(iw_handler) NULL,		// SIOCSIWNICKN
-	(iw_handler) NULL,		// SIOCGIWNICKN
-	(iw_handler) NULL,		// -- hole --
-	(iw_handler) NULL,		// -- hole --
-	(iw_handler) NULL,		// SIOCSIWRATE 0x20
-	(iw_handler) NULL,		// SIOCGIWRATE
-	(iw_handler) NULL,		// SIOCSIWRTS
-	(iw_handler) NULL,		// SIOCGIWRTS
-	(iw_handler) NULL,		// SIOCSIWFRAG
-	(iw_handler) NULL,		// SIOCGIWFRAG
-	(iw_handler) NULL,		// SIOCSIWTXPOW
-	(iw_handler) NULL,		// SIOCGIWTXPOW
-	(iw_handler) NULL,		// SIOCSIWRETRY
-	(iw_handler) NULL,		// SIOCGIWRETRY
-	(iw_handler) NULL,		// SIOCSIWENCODE
-	(iw_handler) NULL,		// SIOCGIWENCODE
-	(iw_handler) NULL,		// SIOCSIWPOWER
-	(iw_handler) NULL,		// SIOCGIWPOWER
-	(iw_handler) NULL,			// -- hole --
-	(iw_handler) NULL,			// -- hole --
-	(iw_handler) NULL,    // SIOCSIWGENIE
-	(iw_handler) NULL,    // SIOCGIWGENIE
-	(iw_handler) NULL,		// SIOCSIWAUTH
-	(iw_handler) NULL,		// SIOCGIWAUTH
-	(iw_handler) NULL,		// SIOCSIWENCODEEXT
-	(iw_handler) NULL,		// SIOCGIWENCODEEXT
-	(iw_handler) NULL,				// SIOCSIWPMKSA
-	(iw_handler) NULL,				// -- hole --
+	(iw_handler)NULL,      /* SIOCSIWCOMMIT */
+	(iw_handler)NULL,      // SIOCGIWNAME
+	(iw_handler)NULL,				// SIOCSIWNWID
+	(iw_handler)NULL,				// SIOCGIWNWID
+	(iw_handler)NULL,		// SIOCSIWFREQ
+	(iw_handler)NULL,		// SIOCGIWFREQ
+	(iw_handler)NULL,		// SIOCSIWMODE
+	(iw_handler)NULL,		// SIOCGIWMODE
+	(iw_handler)NULL,		        // SIOCSIWSENS
+	(iw_handler)NULL,		        // SIOCGIWSENS
+	(iw_handler)NULL, 		        // SIOCSIWRANGE
+	(iw_handler)iwctl_giwrange,		// SIOCGIWRANGE
+	(iw_handler)NULL,         		    // SIOCSIWPRIV
+	(iw_handler)NULL,             		// SIOCGIWPRIV
+	(iw_handler)NULL,             		// SIOCSIWSTATS
+	(iw_handler)NULL,                  // SIOCGIWSTATS
+	(iw_handler)NULL,                  // SIOCSIWSPY
+	(iw_handler)NULL,		            // SIOCGIWSPY
+	(iw_handler)NULL,				    // -- hole --
+	(iw_handler)NULL,				    // -- hole --
+	(iw_handler)NULL,		    // SIOCSIWAP
+	(iw_handler)NULL,		    // SIOCGIWAP
+	(iw_handler)NULL,				    // -- hole -- 0x16
+	(iw_handler)NULL,       // SIOCGIWAPLIST
+	(iw_handler)iwctl_siwscan,         // SIOCSIWSCAN
+	(iw_handler)iwctl_giwscan,         // SIOCGIWSCAN
+	(iw_handler)NULL,		// SIOCSIWESSID
+	(iw_handler)NULL,		// SIOCGIWESSID
+	(iw_handler)NULL,		// SIOCSIWNICKN
+	(iw_handler)NULL,		// SIOCGIWNICKN
+	(iw_handler)NULL,		// -- hole --
+	(iw_handler)NULL,		// -- hole --
+	(iw_handler)NULL,		// SIOCSIWRATE 0x20
+	(iw_handler)NULL,		// SIOCGIWRATE
+	(iw_handler)NULL,		// SIOCSIWRTS
+	(iw_handler)NULL,		// SIOCGIWRTS
+	(iw_handler)NULL,		// SIOCSIWFRAG
+	(iw_handler)NULL,		// SIOCGIWFRAG
+	(iw_handler)NULL,		// SIOCSIWTXPOW
+	(iw_handler)NULL,		// SIOCGIWTXPOW
+	(iw_handler)NULL,		// SIOCSIWRETRY
+	(iw_handler)NULL,		// SIOCGIWRETRY
+	(iw_handler)NULL,		// SIOCSIWENCODE
+	(iw_handler)NULL,		// SIOCGIWENCODE
+	(iw_handler)NULL,		// SIOCSIWPOWER
+	(iw_handler)NULL,		// SIOCGIWPOWER
+	(iw_handler)NULL,			// -- hole --
+	(iw_handler)NULL,			// -- hole --
+	(iw_handler)NULL,    // SIOCSIWGENIE
+	(iw_handler)NULL,    // SIOCGIWGENIE
+	(iw_handler)NULL,		// SIOCSIWAUTH
+	(iw_handler)NULL,		// SIOCGIWAUTH
+	(iw_handler)NULL,		// SIOCSIWENCODEEXT
+	(iw_handler)NULL,		// SIOCGIWENCODEEXT
+	(iw_handler)NULL,				// SIOCSIWPMKSA
+	(iw_handler)NULL,				// -- hole --
 };
 
 static const iw_handler iwctl_private_handler[] = {
@@ -1740,7 +1740,7 @@ const struct iw_handler_def iwctl_handler_def = {
 	.num_standard	= sizeof(iwctl_handler)/sizeof(iw_handler),
 	.num_private	= 0,
 	.num_private_args = 0,
-	.standard	= (iw_handler *) iwctl_handler,
+	.standard	= (iw_handler *)iwctl_handler,
 	.private	= NULL,
 	.private_args	= NULL,
 };
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

