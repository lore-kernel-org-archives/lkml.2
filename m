Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1K1VR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:17:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55001 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1K1VRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:17:25 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH] staging:vt6656: iwctl.c: Removed unneeded function
Date: Mon, 28 Nov 2011 19:16:37 +0000
Message-Id: <1322507797-2781-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the function iwctl_giwnwid, that just return a error code.

Changes v1 to v2:
	Removed same functions of vt6655 and vt6656.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6655/device_main.c |    6 +-----
 drivers/staging/vt6655/iwctl.c       |   12 ------------
 drivers/staging/vt6655/iwctl.h       |    5 -----
 drivers/staging/vt6656/iwctl.c       |   12 ------------
 drivers/staging/vt6656/iwctl.h       |    5 -----
 drivers/staging/vt6656/main_usb.c    |    9 +--------
 6 files changed, 2 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index d8dd784..3e8283c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3153,11 +3153,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		break;
 
 	case SIOCGIWNWID:     //0x8b03  support
-	#ifdef  WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-          rc = iwctl_giwnwid(dev, NULL, &(wrq->u.nwid), NULL);
-	#else
-        rc = -EOPNOTSUPP;
-	#endif
+		rc = -EOPNOTSUPP;
 		break;
 
 		// Set frequency/channel
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 5e425d1..87288db 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -151,18 +151,6 @@ int iwctl_giwname(struct net_device *dev,
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
-
 /*
  * Wireless Handler : set scan
  */
diff --git a/drivers/staging/vt6655/iwctl.h b/drivers/staging/vt6655/iwctl.h
index 3096de0..d224f91 100644
--- a/drivers/staging/vt6655/iwctl.h
+++ b/drivers/staging/vt6655/iwctl.h
@@ -79,11 +79,6 @@ int iwctl_giwname(struct net_device *dev,
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
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 2121205..ecfda52 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -128,17 +128,6 @@ int iwctl_giwname(struct net_device *dev,
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
@@ -1939,7 +1928,6 @@ static const iw_handler		iwctl_handler[] =
 	(iw_handler) iwctl_commit,      // SIOCSIWCOMMIT
 	(iw_handler) iwctl_giwname,     // SIOCGIWNAME
 	(iw_handler) NULL,				// SIOCSIWNWID
-	(iw_handler) NULL,				// SIOCGIWNWID
 	(iw_handler) iwctl_siwfreq,		// SIOCSIWFREQ
 	(iw_handler) iwctl_giwfreq,		// SIOCGIWFREQ
 	(iw_handler) iwctl_siwmode,		// SIOCSIWMODE
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

