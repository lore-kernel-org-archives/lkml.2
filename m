Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2FXX5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:57:03 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12249 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2FXX5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:57:00 -0400
Date: Mon, 25 Jun 2012 01:56:59 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] staging: vt6656: iwctl: remove redundant cast (to
 PSDevice)
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250150560.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netdev_priv() returns a void*, so there is no reason to explicitly
cast to (PSDevice) when assigning to a variable of type PSDevice. The
cast is done implicitly.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 58 +++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 218e146..eeaee59 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -100,7 +100,7 @@ int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_scan_req *req = (struct iw_scan_req *)extra;
 	BYTE abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
@@ -175,7 +175,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 	int ii;
 	int jj;
 	int kk;
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	PKnownBSS pBSS;
 	PWLAN_IE_SSID pItemSSID;
@@ -323,7 +323,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 		struct iw_freq *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");
@@ -363,7 +363,7 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 		struct iw_freq *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ \n");
@@ -389,7 +389,7 @@ int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 		__u32 *wmode, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
@@ -453,7 +453,7 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
 		__u32 *wmode, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 
@@ -583,7 +583,7 @@ void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 		struct sockaddr *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 	BYTE ZeroBSSID[WLAN_BSSID_LEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
@@ -631,7 +631,7 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
 		struct sockaddr *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP \n");
@@ -660,7 +660,7 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 	int rc = 0;
 	struct sockaddr sock[IW_MAX_AP];
 	struct iw_quality qual[IW_MAX_AP];
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAPLIST \n");
@@ -702,7 +702,7 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID pItemSSID;
 
@@ -813,7 +813,7 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID pItemSSID;
 
@@ -837,7 +837,7 @@ void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	int rc = 0;
 	u8 brate = 0;
 	int i;
@@ -919,7 +919,7 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE \n");
@@ -963,7 +963,7 @@ void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
  */
 int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 
 	if ((wrq->value < 0 || wrq->value > 2312) && !wrq->disabled)
 		return -EINVAL;
@@ -982,7 +982,7 @@ int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq)
 int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS \n");
 	wrq->value = pDevice->wRTSThreshold;
@@ -998,7 +998,7 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	int rc = 0;
 	int fthr = wrq->value;
 
@@ -1021,7 +1021,7 @@ int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG \n");
 	wrq->value = pDevice->wFragmentationThreshold;
@@ -1037,7 +1037,7 @@ int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY \n");
@@ -1070,7 +1070,7 @@ int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");
 	wrq->disabled = 0;      // Can't be disabled
 
@@ -1097,7 +1097,7 @@ int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	DWORD dwKeyIndex = (DWORD)(wrq->flags & IW_ENCODE_INDEX);
 	int ii;
@@ -1199,7 +1199,7 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	char abyKey[WLAN_WEP232_KEYLEN];
 
@@ -1257,7 +1257,7 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
@@ -1305,7 +1305,7 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int mode = pDevice->ePSMode;
 
@@ -1331,7 +1331,7 @@ int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	long ldBm;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS \n");
@@ -1352,7 +1352,7 @@ int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int ret = 0;
 	static int wpa_version = 0;  //must be static to save the last value,einsn liu
@@ -1459,7 +1459,7 @@ int iwctl_giwauth(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int ret = 0;
 
@@ -1490,7 +1490,7 @@ out://not completely ...not necessary in wpa_supplicant 0.5.8
 int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	int ret = 0;
 	int space = wrq->length;
@@ -1511,7 +1511,7 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_encode_ext *ext = (struct iw_encode_ext*)extra;
 	struct viawget_wpa_param *param=NULL;
@@ -1642,7 +1642,7 @@ int iwctl_giwencodeext(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSDevice pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	int ret = 0;
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

