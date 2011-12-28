Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab1L1XMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:12:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40144 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1L1XL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:11:58 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 5/7] staging: vt6656: iwctl.c: Remove return statement of iwctl_giwessid
Date: Wed, 28 Dec 2011 21:12:12 +0000
Message-Id: <1325106732-2843-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will always return 0, and this data is not used by who
calls this function.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    |    5 +----
 drivers/staging/vt6656/iwctl.h    |    2 +-
 drivers/staging/vt6656/main_usb.c |    4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index a3b2f1e..e61e116 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -856,8 +856,7 @@ int iwctl_siwessid(struct net_device *dev,
 /*
  * Wireless Handler : get essid
  */
-
-int iwctl_giwessid(struct net_device *dev,
+void iwctl_giwessid(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_point *wrq,
              char *extra)
@@ -879,8 +878,6 @@ int iwctl_giwessid(struct net_device *dev,
 
         wrq->length = pItemSSID->len;
 	wrq->flags = 1; // active
-
-	return 0;
 }
 
 /*
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index 22acf8b..0bab0d7 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -97,7 +97,7 @@ int iwctl_siwessid(struct net_device *dev,
              struct iw_point *wrq,
              char *extra);
 
-int iwctl_giwessid(struct net_device *dev,
+void iwctl_giwessid(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_point *wrq,
              char *extra);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 373df75..16c82d3 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1657,8 +1657,8 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		{
 			char essid[IW_ESSID_MAX_SIZE+1];
 			if (wrq->u.essid.pointer) {
-				rc = iwctl_giwessid(dev, NULL,
-						    &(wrq->u.essid), essid);
+				iwctl_giwessid(dev, NULL,
+					    &(wrq->u.essid), essid);
 				if (copy_to_user(wrq->u.essid.pointer,
 						         essid,
 						         wrq->u.essid.length) )
-- 
1.7.4.4

