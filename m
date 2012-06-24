Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab2FXX4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:56:10 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12075 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2FXX4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:56:07 -0400
Date: Mon, 25 Jun 2012 01:56:05 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] staging: vt6656: iwctl: fix up function
 declarations/prototypes
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250148250.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way function prototypes/declarations are written in iwctl.[ch] is
an inconsistent mess.

This patch makes the whole thing consistent by putting the first
function arguments (op to a column width of at most 80) on the same
line as the function name and the remaining ones on the following line
indented by two tabs.

Besides getting rid of the current tabs vs spaces mess it also
shortens the files quite a bit and puts them more in line with most
other kernel files.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 197 +++++++++++--------------------
 drivers/staging/vt6656/iwctl.h | 258 +++++++++++++++--------------------------
 2 files changed, 161 insertions(+), 294 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 9a49fa9..3ac41bb 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -87,10 +87,8 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 /*
  * Wireless Handler : get protocol name
  */
-int iwctl_giwname(struct net_device *dev,
-			 struct iw_request_info *info,
-			 char *wrq,
-			 char *extra)
+int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
+		char *wrq, char *extra)
 {
 	strcpy(wrq, "802.11-a/b/g");
 	return 0;
@@ -99,10 +97,8 @@ int iwctl_giwname(struct net_device *dev,
 /*
  * Wireless Handler : set scan
  */
-int iwctl_siwscan(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_point *wrq,
-             char *extra)
+int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	 PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -173,10 +169,8 @@ if(pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
 /*
  * Wireless Handler : get scan results
  */
-int iwctl_giwscan(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_point *wrq,
-             char *extra)
+int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
     int ii, jj, kk;
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
@@ -323,10 +317,8 @@ int iwctl_giwscan(struct net_device *dev,
 /*
  * Wireless Handler : set frequence or channel
  */
-int iwctl_siwfreq(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_freq *wrq,
-             char *extra)
+int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
+		struct iw_freq *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 	int rc = 0;
@@ -365,10 +357,8 @@ int iwctl_siwfreq(struct net_device *dev,
 /*
  * Wireless Handler : get frequence or channel
  */
-int iwctl_giwfreq(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_freq *wrq,
-             char *extra)
+int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
+		struct iw_freq *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -393,10 +383,8 @@ int iwctl_giwfreq(struct net_device *dev,
 /*
  * Wireless Handler : set operation mode
  */
-int iwctl_siwmode(struct net_device *dev,
-             struct iw_request_info *info,
-             __u32 *wmode,
-             char *extra)
+int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
+		__u32 *wmode, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -459,10 +447,8 @@ int iwctl_siwmode(struct net_device *dev,
 /*
  * Wireless Handler : get operation mode
  */
-void iwctl_giwmode(struct net_device *dev,
-             struct iw_request_info *info,
-             __u32 *wmode,
-             char *extra)
+void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
+		__u32 *wmode, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -491,10 +477,8 @@ void iwctl_giwmode(struct net_device *dev,
 /*
  * Wireless Handler : get capability range
  */
-void iwctl_giwrange(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra)
+void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
 	struct iw_range *range = (struct iw_range *) extra;
 	int		i,k;
@@ -589,10 +573,8 @@ void iwctl_giwrange(struct net_device *dev,
 /*
  * Wireless Handler : set ap mac address
  */
-int iwctl_siwap(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct sockaddr *wrq,
-             char *extra)
+int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
+		struct sockaddr *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -638,10 +620,8 @@ int iwctl_siwap(struct net_device *dev,
 /*
  * Wireless Handler : get ap mac address
  */
-int iwctl_giwap(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct sockaddr *wrq,
-             char *extra)
+int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
+		struct sockaddr *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -664,10 +644,8 @@ int iwctl_giwap(struct net_device *dev,
 /*
  * Wireless Handler : get ap list
  */
-int iwctl_giwaplist(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra)
+int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
 	int ii,jj, rc = 0;
 	struct sockaddr sock[IW_MAX_AP];
@@ -711,11 +689,8 @@ int iwctl_giwaplist(struct net_device *dev,
 /*
  * Wireless Handler : set essid
  */
-
-int iwctl_siwessid(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra)
+int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -824,10 +799,8 @@ int iwctl_siwessid(struct net_device *dev,
 /*
  * Wireless Handler : get essid
  */
-void iwctl_giwessid(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra)
+void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -850,10 +823,8 @@ void iwctl_giwessid(struct net_device *dev,
 /*
  * Wireless Handler : set data rate
  */
-int iwctl_siwrate(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra)
+int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     int rc = 0;
@@ -931,10 +902,8 @@ int iwctl_siwrate(struct net_device *dev,
 /*
  * Wireless Handler : get data rate
  */
-void iwctl_giwrate(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_param *wrq,
-             char *extra)
+void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -974,8 +943,7 @@ void iwctl_giwrate(struct net_device *dev,
 /*
  * Wireless Handler : set rts threshold
  */
-int iwctl_siwrts(struct net_device *dev,
-		 struct iw_param *wrq)
+int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq)
 {
 	PSDevice pDevice = (PSDevice)netdev_priv(dev);
 
@@ -993,10 +961,8 @@ int iwctl_siwrts(struct net_device *dev,
 /*
  * Wireless Handler : get rts
  */
-int iwctl_giwrts(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra)
+int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
 	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 
@@ -1011,10 +977,8 @@ int iwctl_giwrts(struct net_device *dev,
 /*
  * Wireless Handler : set fragment threshold
  */
-int iwctl_siwfrag(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra)
+int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
     PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     int rc = 0;
@@ -1036,11 +1000,8 @@ int iwctl_siwfrag(struct net_device *dev,
 /*
  * Wireless Handler : get fragment threshold
  */
-
-int iwctl_giwfrag(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra)
+int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
     PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
 
@@ -1055,10 +1016,8 @@ int iwctl_giwfrag(struct net_device *dev,
 /*
  * Wireless Handler : set retry threshold
  */
-int iwctl_siwretry(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra)
+int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
     PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     int rc = 0;
@@ -1090,10 +1049,8 @@ int iwctl_siwretry(struct net_device *dev,
 /*
  * Wireless Handler : get retry threshold
  */
-int iwctl_giwretry(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra)
+int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
     PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");
@@ -1119,10 +1076,8 @@ int iwctl_giwretry(struct net_device *dev,
 /*
  * Wireless Handler : set encode mode
  */
-int iwctl_siwencode(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra)
+int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
     PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -1221,10 +1176,8 @@ int iwctl_siwencode(struct net_device *dev,
 	return rc;
 }
 
-int iwctl_giwencode(struct net_device *dev,
-			struct iw_request_info *info,
-			struct iw_point *wrq,
-			char *extra)
+int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject		pMgmt = &(pDevice->sMgmtObj);
@@ -1281,10 +1234,8 @@ int iwctl_giwencode(struct net_device *dev,
 /*
  * Wireless Handler : set power mode
  */
-int iwctl_siwpower(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra)
+int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
     PSDevice            pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -1331,10 +1282,8 @@ int iwctl_siwpower(struct net_device *dev,
 /*
  * Wireless Handler : get power mode
  */
-int iwctl_giwpower(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra)
+int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
     PSDevice            pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -1359,10 +1308,8 @@ int iwctl_giwpower(struct net_device *dev,
 /*
  * Wireless Handler : get Sensitivity
  */
-int iwctl_giwsens(struct net_device *dev,
-			 struct iw_request_info *info,
-			 struct iw_param *wrq,
-			 char *extra)
+int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
     PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     long ldBm;
@@ -1382,10 +1329,8 @@ int iwctl_giwsens(struct net_device *dev,
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 
-int iwctl_siwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *wrq,
-			  char *extra)
+int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
@@ -1485,18 +1430,14 @@ int iwctl_siwauth(struct net_device *dev,
    return ret;
 }
 
-int iwctl_giwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *wrq,
-			  char *extra)
+int iwctl_giwauth(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra)
 {
 	return -EOPNOTSUPP;
 }
 
-int iwctl_siwgenie(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *wrq,
-			  char *extra)
+int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
@@ -1526,10 +1467,8 @@ int iwctl_siwgenie(struct net_device *dev,
 	return ret;
 }
 
-int iwctl_giwgenie(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *wrq,
-			  char *extra)
+int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
+			  struct iw_point *wrq, char *extra)
 {
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
@@ -1549,10 +1488,8 @@ int iwctl_giwgenie(struct net_device *dev,
 	return ret;
 }
 
-int iwctl_siwencodeext(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra)
+int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
+             struct iw_point *wrq, char *extra)
 {
     PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
     PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
@@ -1674,18 +1611,14 @@ kfree(param);
 	return ret;
 }
 
-int iwctl_giwencodeext(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra)
+int iwctl_giwencodeext(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
 		return -EOPNOTSUPP;
 }
 
-int iwctl_siwmlme(struct net_device *dev,
-				struct iw_request_info * info,
-				struct iw_point *wrq,
-				char *extra)
+int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra)
 {
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index 0c6e049..96fd043 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -41,170 +41,104 @@
 
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev);
 
-int iwctl_siwap(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct sockaddr *wrq,
-             char *extra);
-
-void iwctl_giwrange(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra);
-
-
-void iwctl_giwmode(struct net_device *dev,
-             struct iw_request_info *info,
-             __u32 *wmode,
-             char *extra);
-
-int iwctl_siwmode(struct net_device *dev,
-             struct iw_request_info *info,
-             __u32 *wmode,
-             char *extra);
-
-int iwctl_giwfreq(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_freq *wrq,
-             char *extra);
-
-int iwctl_siwfreq(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_freq *wrq,
-             char *extra);
-
-int iwctl_giwname(struct net_device *dev,
-			 struct iw_request_info *info,
-			 char *wrq,
-			 char *extra);
-
-int iwctl_giwsens(struct net_device *dev,
-			 struct iw_request_info *info,
-			 struct iw_param *wrq,
-			 char *extra);
-
-int iwctl_giwap(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct sockaddr *wrq,
-             char *extra);
-
-int iwctl_giwaplist(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra);
-
-int iwctl_siwessid(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra);
-
-void iwctl_giwessid(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra);
-
-int iwctl_siwrate(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
-
-void iwctl_giwrate(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_param *wrq,
-             char *extra);
-
-int iwctl_siwrts(struct net_device *dev,
-		 struct iw_param *wrq);
-
-int iwctl_giwrts(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
-
-int iwctl_siwfrag(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
-
-int iwctl_giwfrag(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
-
-int iwctl_siwretry(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
-
-int iwctl_giwretry(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
-
-int iwctl_siwencode(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra);
-
-int iwctl_giwencode(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra);
-
-int iwctl_siwpower(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
-
-int iwctl_giwpower(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
-
-int iwctl_giwscan(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_point *wrq,
-             char *extra);
-
-int iwctl_siwscan(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
+int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
+		struct sockaddr *wrq, char *extra);
+
+void iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+void iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
+		__u32 *wmode, char *extra);
+
+int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
+		__u32 *wmode, char *extra);
+
+int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
+		struct iw_freq *wrq, char *extra);
+
+int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
+		struct iw_freq *wrq, char *extra);
+
+int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
+		char *wrq, char *extra);
+
+int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
+		struct sockaddr *wrq, char *extra);
+
+int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+void iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+void iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_siwrts(struct net_device *dev, struct iw_param *wrq);
+
+int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
 
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-int iwctl_siwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *wrq,
-			  char *extra);
-
-int iwctl_giwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *wrq,
-			  char *extra);
-
-int iwctl_siwgenie(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *wrq,
-			  char *extra);
-
-int iwctl_giwgenie(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *wrq,
-			  char *extra);
-
-int iwctl_siwencodeext(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra);
-
-int iwctl_giwencodeext(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra);
-
-int iwctl_siwmlme(struct net_device *dev,
-			struct iw_request_info * info,
-			struct iw_point *wrq,
-			char *extra);
+int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_giwauth(struct net_device *dev, struct iw_request_info *info,
+		struct iw_param *wrq, char *extra);
+
+int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+int iwctl_giwencodeext(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
+
+int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
+		struct iw_point *wrq, char *extra);
 #endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 
 extern const struct iw_handler_def	iwctl_handler_def;
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

