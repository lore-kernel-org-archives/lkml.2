Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab1L1XIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:08:52 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61465 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1L1XIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:08:49 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 3/7] staging: vt6656: Remove return statement of iwctl_giwmode
Date: Wed, 28 Dec 2011 21:09:13 +0000
Message-Id: <1325106553-2651-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will always return 0, and this data is not used by who
calls this function.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    |    4 +---
 drivers/staging/vt6656/iwctl.h    |    2 +-
 drivers/staging/vt6656/main_usb.c |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 0b28d0f..5c5770d 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -471,7 +471,7 @@ int iwctl_siwmode(struct net_device *dev,
  * Wireless Handler : get operation mode
  */
 
-int iwctl_giwmode(struct net_device *dev,
+void iwctl_giwmode(struct net_device *dev,
              struct iw_request_info *info,
              __u32 *wmode,
              char *extra)
@@ -498,8 +498,6 @@ int iwctl_giwmode(struct net_device *dev,
 	default:
 		*wmode = IW_MODE_ADHOC;
 	}
-
-	return 0;
 }
 
 
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index 10a240e..60180a7 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -52,7 +52,7 @@ int iwctl_giwrange(struct net_device *dev,
              char *extra);
 
 
-int iwctl_giwmode(struct net_device *dev,
+void iwctl_giwmode(struct net_device *dev,
              struct iw_request_info *info,
              __u32 *wmode,
              char *extra);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 173217b..c19eb1e 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1733,7 +1733,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 
 		// Get mode of operation
 	case SIOCGIWMODE:
-		rc = iwctl_giwmode(dev, NULL, &(wrq->u.mode), NULL);
+		iwctl_giwmode(dev, NULL, &(wrq->u.mode), NULL);
 		break;
 
 		// Set WEP keys and mode
-- 
1.7.4.4

