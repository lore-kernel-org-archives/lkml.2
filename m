Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1L1XNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:13:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55295 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1L1XNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:13:49 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 6/7] staging: vt6656: iwctl.c: Remove return statement of iwctl_giwrate
Date: Wed, 28 Dec 2011 21:13:39 +0000
Message-Id: <1325106819-2938-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will always return 0, and this data is not used by who
calls this function.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    |    6 +-----
 drivers/staging/vt6656/iwctl.h    |    2 +-
 drivers/staging/vt6656/main_usb.c |    3 +--
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index e61e116..2ad7428 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -965,8 +965,7 @@ int iwctl_siwrate(struct net_device *dev,
 /*
  * Wireless Handler : get data rate
  */
-
-int iwctl_giwrate(struct net_device *dev,
+void iwctl_giwrate(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_param *wrq,
              char *extra)
@@ -1004,9 +1003,6 @@ int iwctl_giwrate(struct net_device *dev,
 	    if (pDevice->bFixRate == TRUE)
 	        wrq->fixed = TRUE;
     }
-
-
-	return 0;
 }
 
 
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index 0bab0d7..bd38e9d 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -107,7 +107,7 @@ int iwctl_siwrate(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra);
 
-int iwctl_giwrate(struct net_device *dev,
+void iwctl_giwrate(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_param *wrq,
              char *extra);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 16c82d3..64d0653 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1698,8 +1698,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
 	// Get the current bit-rate
 	case SIOCGIWRATE:
-
-		rc = iwctl_giwrate(dev, NULL, &(wrq->u.bitrate), NULL);
+		iwctl_giwrate(dev, NULL, &(wrq->u.bitrate), NULL);
 		break;
 
 	// Set the desired RTS threshold
-- 
1.7.4.4

