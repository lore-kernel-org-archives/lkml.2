Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2GHW6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:58:38 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:27012 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2GHW6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:58:37 -0400
Date: Mon, 9 Jul 2012 00:58:36 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: vt6656: iwctl: fix up spacing around
 operators
In-Reply-To: <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207090054270.15263@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net> <20120706230945.GA8835@kroah.com> <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net> <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few cases were missed in my previous cleanup, this takes care of the
last cases of missing space (or too much space (as in a newline))
around operators ('=', '==', ',', '<').

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index dc24096..f8ea662 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -104,7 +104,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct iw_scan_req *req = (struct iw_scan_req *)extra;
 	BYTE abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-	PWLAN_IE_SSID pItemSSID=NULL;
+	PWLAN_IE_SSID pItemSSID = NULL;
 
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
 		return -EINVAL;
@@ -203,7 +203,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			iwe.cmd = SIOCGIWAP;
 			iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
 			memcpy(iwe.u.ap_addr.sa_data, pBSS->abyBSSID, WLAN_BSSID_LEN);
-			current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
+			current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_ADDR_LEN);
 			// ADD ssid
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = SIOCGIWESSID;
@@ -244,7 +244,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			iwe.u.qual.level = ldBm;
 			iwe.u.qual.noise = 0;
 
-			if (-ldBm<50)
+			if (-ldBm < 50)
 				iwe.u.qual.qual = 100;
 			else  if (-ldBm > 90)
 				iwe.u.qual.qual = 0;
@@ -1099,9 +1099,9 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 	// Send the key to the card
 	if (wrq->length > 0) {
 
-		if (wrq->length ==  WLAN_WEP232_KEYLEN) {
+		if (wrq->length == WLAN_WEP232_KEYLEN) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 232 bit wep key\n");
-		} else if (wrq->length ==  WLAN_WEP104_KEYLEN) {
+		} else if (wrq->length == WLAN_WEP104_KEYLEN) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 104 bit wep key\n");
 		} else if (wrq->length == WLAN_WEP40_KEYLEN) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Set 40 bit wep key, index= %d\n", (int)dwKeyIndex);
@@ -1624,8 +1624,7 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 	case IW_MLME_DISASSOC:
 		if (pDevice->bLinkPass == TRUE) {
 			PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
-			bScheduleCommand((void *)pDevice,
-					WLAN_CMD_DISASSOCIATE,
+			bScheduleCommand((void *)pDevice, WLAN_CMD_DISASSOCIATE,
 					NULL);
 		}
 		break;
-- 
1.7.11.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

