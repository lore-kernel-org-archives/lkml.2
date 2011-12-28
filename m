Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab1L1XKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:10:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38530 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1L1XKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:10:31 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 4/7] staging: vt6656: Remove return statement of iwctl_giwrange
Date: Wed, 28 Dec 2011 21:10:50 +0000
Message-Id: <1325106650-2751-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function iwctl_giwrange will always return 0, and this data is not
used by who calls this function.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    |    5 +----
 drivers/staging/vt6656/iwctl.h    |    2 +-
 drivers/staging/vt6656/main_usb.c |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 5c5770d..a3b2f1e 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -505,7 +505,7 @@ void iwctl_giwmode(struct net_device *dev,
  * Wireless Handler : get capability range
  */
 
-int iwctl_giwrange(struct net_device *dev,
+void iwctl_giwrange(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_point *wrq,
              char *extra)
@@ -600,9 +600,6 @@ int iwctl_giwrange(struct net_device *dev,
 		range->avg_qual.level = 176;	// -80 dBm
 		range->avg_qual.noise = 0;
 	}
-
-
-	return 0;
 }
 
 
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index 60180a7..22acf8b 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -46,7 +46,7 @@ int iwctl_siwap(struct net_device *dev,
 			 struct sockaddr *wrq,
              char *extra);
 
-int iwctl_giwrange(struct net_device *dev,
+void iwctl_giwrange(struct net_device *dev,
              struct iw_request_info *info,
              struct iw_point *wrq,
              char *extra);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c19eb1e..373df75 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1811,7 +1811,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		{
 			struct iw_range range;
 
-			rc = iwctl_giwrange(dev, NULL, &(wrq->u.data), (char *) &range);
+			iwctl_giwrange(dev, NULL, &(wrq->u.data), (char *) &range);
 			if (copy_to_user(wrq->u.data.pointer, &range, sizeof(struct iw_range)))
 				rc = -EFAULT;
 		}
-- 
1.7.4.4

