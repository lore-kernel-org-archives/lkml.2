Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2FXX4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:56:47 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12182 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab2FXX4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:56:45 -0400
Date: Mon, 25 Jun 2012 01:56:43 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] staging: vt6656: iwctl: Fix up variable declarations
 (whitespace and 'one-per-line')
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250149530.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that we have only one variable declaration per line and for
each of those lines we have one space between type and variable name
and if there's assignment, then we have one space on each side of the
equals sign (and no more than 80 characters per line).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 199 ++++++++++++++++++++++-------------------
 drivers/staging/vt6656/iwctl.h |   4 +-
 2 files changed, 111 insertions(+), 92 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index ca4e7f0..9fc9059 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -60,7 +60,7 @@ static const long frequency_list[] = {
 	5700, 5745, 5765, 5785, 5805, 5825
 };
 
-static int          msglevel                =MSG_LEVEL_INFO;
+static int msglevel = MSG_LEVEL_INFO;
 
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 {
@@ -100,11 +100,11 @@ int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-	struct iw_scan_req  *req = (struct iw_scan_req *)extra;
-	BYTE                abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-	PWLAN_IE_SSID       pItemSSID=NULL;
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct iw_scan_req *req = (struct iw_scan_req *)extra;
+	BYTE abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+	PWLAN_IE_SSID pItemSSID=NULL;
 
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
 		return -EINVAL;
@@ -172,12 +172,15 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	int ii, jj, kk;
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-	PKnownBSS           pBSS;
-	PWLAN_IE_SSID       pItemSSID;
-	PWLAN_IE_SUPP_RATES pSuppRates, pExtSuppRates;
+	int ii;
+	int jj;
+	int kk;
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	PKnownBSS pBSS;
+	PWLAN_IE_SSID pItemSSID;
+	PWLAN_IE_SUPP_RATES pSuppRates;
+	PWLAN_IE_SUPP_RATES pExtSuppRates;
 	char *current_ev = extra;
 	char *end_buf = extra + IW_SCAN_MAX_DATA;
 	char *current_val = NULL;
@@ -320,7 +323,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 		struct iw_freq *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");
@@ -360,8 +363,8 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 		struct iw_freq *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ \n");
 
@@ -386,8 +389,8 @@ int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 		__u32 *wmode, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE \n");
@@ -450,8 +453,8 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
 		__u32 *wmode, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE \n");
@@ -481,8 +484,12 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
 	struct iw_range *range = (struct iw_range *) extra;
-	int		i,k;
-	BYTE abySupportedRates[13]= {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
+	int i;
+	int k;
+	BYTE abySupportedRates[13] = {
+		0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48,
+		0x60, 0x6C, 0x90
+	};
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRANGE\n");
 	if (wrq->pointer) {
@@ -576,10 +583,10 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 		struct sockaddr *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
-	BYTE                 ZeroBSSID[WLAN_BSSID_LEN]={0x00,0x00,0x00,0x00,0x00,0x00};
+	BYTE ZeroBSSID[WLAN_BSSID_LEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
 	PRINT_K(" SIOCSIWAP \n");
 
@@ -596,7 +603,8 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 		//mike add: if desired AP is hidden ssid(there are two same BSSID in list),
 		//                  then ignore,because you don't known which one to be connect with??
 		{
-			unsigned int ii, uSameBssidNum = 0;
+			unsigned ii;
+			unsigned uSameBssidNum = 0;
 			for (ii = 0; ii < MAX_BSS_NUM; ii++) {
 				if (pMgmt->sBSSList[ii].bActive &&
 					!compare_ether_addr(pMgmt->sBSSList[ii].abyBSSID,
@@ -623,8 +631,8 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
 		struct sockaddr *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP \n");
 
@@ -647,11 +655,13 @@ int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	int ii,jj, rc = 0;
+	int ii;
+	int jj;
+	int rc = 0;
 	struct sockaddr sock[IW_MAX_AP];
 	struct iw_quality qual[IW_MAX_AP];
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAPLIST \n");
 	// Only super-user can see AP list
@@ -692,9 +702,9 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-	PWLAN_IE_SSID       pItemSSID;
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	PWLAN_IE_SSID pItemSSID;
 
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
 		return -EINVAL;
@@ -739,9 +749,10 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		if(pDevice->bWPASuppWextEnabled == TRUE)  {
 			/*******search if  in hidden ssid mode ****/
 			{
-				PKnownBSS       pCurr = NULL;
-				BYTE                   abyTmpDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-				unsigned int ii, uSameBssidNum = 0;
+				PKnownBSS pCurr = NULL;
+				BYTE abyTmpDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
+				unsigned ii;
+				unsigned uSameBssidNum = 0;
 
 				memcpy(abyTmpDesireSSID,pMgmt->abyDesireSSID,sizeof(abyTmpDesireSSID));
 				pCurr = BSSpSearchBSSList(pDevice,
@@ -802,9 +813,9 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-	PWLAN_IE_SSID       pItemSSID;
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	PWLAN_IE_SSID pItemSSID;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID \n");
 
@@ -826,11 +837,14 @@ void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 	int rc = 0;
-	u8	brate = 0;
-	int	i;
-	BYTE abySupportedRates[13]= {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
+	u8 brate = 0;
+	int i;
+	BYTE abySupportedRates[13] = {
+		0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48,
+		0x60, 0x6C, 0x90
+	};
 
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRATE \n");
@@ -849,7 +863,7 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		brate = wrq->value;
 	} else {
 		// Setting by frequency value
-		u8	normvalue = (u8) (wrq->value/500000);
+		u8 normvalue = (u8) (wrq->value/500000);
 
 		// Check if rate is valid
 		for (i = 0 ; i < 13 ; i++) {
@@ -905,13 +919,17 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE \n");
 	{
-		BYTE abySupportedRates[13]= {0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C, 0x90};
+		BYTE abySupportedRates[13] = {
+			0x02, 0x04, 0x0B, 0x16, 0x0c, 0x12, 0x18, 0x24, 0x30,
+			0x48, 0x60, 0x6C, 0x90
+		};
 		int brate = 0;
+
 		if (pDevice->uConnectionRate < 13) {
 			brate = abySupportedRates[pDevice->uConnectionRate];
 		}else {
@@ -964,7 +982,7 @@ int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq)
 int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS \n");
 	wrq->value = pDevice->wRTSThreshold;
@@ -980,7 +998,7 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 	int rc = 0;
 	int fthr = wrq->value;
 
@@ -1003,7 +1021,7 @@ int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG \n");
 	wrq->value = pDevice->wFragmentationThreshold;
@@ -1019,7 +1037,7 @@ int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY \n");
@@ -1052,7 +1070,7 @@ int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");
 	wrq->disabled = 0;      // Can't be disabled
 
@@ -1079,10 +1097,12 @@ int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	DWORD dwKeyIndex = (DWORD)(wrq->flags & IW_ENCODE_INDEX);
-	int ii,uu, rc = 0;
+	int ii;
+	int uu;
+	int rc = 0;
 	int index = (wrq->flags & IW_ENCODE_INDEX);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWENCODE \n");
@@ -1179,12 +1199,12 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject		pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	char abyKey[WLAN_WEP232_KEYLEN];
 
-	unsigned int index = (unsigned int)(wrq->flags & IW_ENCODE_INDEX);
-	PSKeyItem	pKey = NULL;
+	unsigned index = (unsigned)(wrq->flags & IW_ENCODE_INDEX);
+	PSKeyItem pKey = NULL;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODE\n");
 
@@ -1237,8 +1257,8 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice            pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER \n");
@@ -1285,8 +1305,8 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice            pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int mode = pDevice->ePSMode;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWPOWER \n");
@@ -1311,7 +1331,7 @@ int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 	long ldBm;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS \n");
@@ -1332,11 +1352,11 @@ int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
-	int ret=0;
-	static int wpa_version=0;  //must be static to save the last value,einsn liu
-	static int pairwise=0;
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	int ret = 0;
+	static int wpa_version = 0;  //must be static to save the last value,einsn liu
+	static int pairwise = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH \n");
 	switch (wrq->flags & IW_AUTH_INDEX) {
@@ -1439,9 +1459,9 @@ int iwctl_giwauth(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
-	int ret=0;
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	int ret = 0;
 
 	if(wrq->length){
 		if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
@@ -1470,9 +1490,9 @@ out://not completely ...not necessary in wpa_supplicant 0.5.8
 int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
-	int ret=0;
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	int ret = 0;
 	int space = wrq->length;
 
 	wrq->length = 0;
@@ -1491,21 +1511,23 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_encode_ext *ext = (struct iw_encode_ext*)extra;
 	struct viawget_wpa_param *param=NULL;
 //original member
 	wpa_alg alg_name;
-	u8  addr[6];
-	int key_idx, set_tx=0;
-	u8  seq[IW_ENCODE_SEQ_MAX_SIZE];
+	u8 addr[6];
+	int key_idx;
+	int set_tx=0;
+	u8 seq[IW_ENCODE_SEQ_MAX_SIZE];
 	u8 key[64];
-	size_t seq_len=0,key_len=0;
+	size_t seq_len = 0;
+	size_t key_len = 0;
 	u8 *buf;
 	size_t blen;
 	u8 key_array[64];
-	int ret=0;
+	int ret = 0;
 
 	PRINT_K("SIOCSIWENCODEEXT...... \n");
 
@@ -1620,8 +1642,8 @@ int iwctl_giwencodeext(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	int ret = 0;
 
@@ -1647,8 +1669,7 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 
 #endif
 
-static const iw_handler		iwctl_handler[] =
-{
+static const iw_handler iwctl_handler[] = {
 	(iw_handler) NULL,      /* SIOCSIWCOMMIT */
 	(iw_handler) NULL,      // SIOCGIWNAME
 	(iw_handler) NULL,				// SIOCSIWNWID
@@ -1707,8 +1728,7 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) NULL,				// -- hole --
 };
 
-static const iw_handler		iwctl_private_handler[] =
-{
+static const iw_handler iwctl_private_handler[] = {
 	NULL,				// SIOCIWFIRSTPRIV
 };
 
@@ -1718,8 +1738,7 @@ struct iw_priv_args iwctl_private_args[] = {
 	  "set"},
 };
 
-const struct iw_handler_def	iwctl_handler_def =
-{
+const struct iw_handler_def iwctl_handler_def = {
 	.get_wireless_stats = &iwctl_get_wireless_stats,
 	.num_standard	= sizeof(iwctl_handler)/sizeof(iw_handler),
 	.num_private	= 0,
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index 96fd043..d056f83 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -141,7 +141,7 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra);
 #endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 
-extern const struct iw_handler_def	iwctl_handler_def;
-extern const struct iw_priv_args	iwctl_private_args;
+extern const struct iw_handler_def iwctl_handler_def;
+extern const struct iw_priv_args iwctl_private_args;
 
 #endif /* __IWCTL_H__ */
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

