Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab1KXVLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:11:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58718 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1KXVLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:11:15 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: devel@driverdev.osuosl.org
Cc: forest@alittletooquiet.net, greg@suse.de, linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH RESEND] drivers/staging/vt6656/iwctl.c: Remove unnecessary function
Date: Thu, 24 Nov 2011 19:09:40 +0000
Message-Id: <1322161780-3731-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the function iwctl_giwnwid, that was used once. Removed too a
switch/case statement that was ambiguous.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    |   11 -----------
 drivers/staging/vt6656/iwctl.h    |    5 -----
 drivers/staging/vt6656/main_usb.c |    9 +--------
 3 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 8c1ca49..a9110bf 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -127,17 +127,6 @@ int iwctl_giwname(struct net_device *dev,
 	return 0;
 }
 
-int iwctl_giwnwid(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-                   char *extra)
-{
- 	//wrq->value = 0x100;
-	//wrq->disabled = 0;
-	//wrq->fixed = 1;
-	//return 0;
-  return -EOPNOTSUPP;
-}
 /*
  * Wireless Handler : set scan
  */
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index cc48954..10a240e 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -77,11 +77,6 @@ int iwctl_giwname(struct net_device *dev,
 			 char *wrq,
 			 char *extra);
 
-int iwctl_giwnwid(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-                   char *extra) ;
-
 int iwctl_giwsens(struct net_device *dev,
 			 struct iw_request_info *info,
 			 struct iw_param *wrq,
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 27521b6..6f9930a 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1618,15 +1618,8 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		break;
 
 	case SIOCSIWNWID:
-        rc = -EOPNOTSUPP;
-		break;
-
 	case SIOCGIWNWID:     //0x8b03  support
-	#ifdef  WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-          rc = iwctl_giwnwid(dev, NULL, &(wrq->u.nwid), NULL);
-	#else
-        rc = -EOPNOTSUPP;
-	#endif
+		rc = -EOPNOTSUPP;
 		break;
 
 		// Set frequency/channel
-- 
1.7.4.4

