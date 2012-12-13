Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2LMOGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:06:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab2LMOG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Dae S. Kim" <dae@velatum.com>, Colin Cross <ccross@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 093/241] Revert "Staging: Android alarm: IOCTL command encoding fix"
Date: Thu, 13 Dec 2012 11:57:38 -0200
Message-Id: <1355407206-17100-94-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit d38e0e3fed4f58bcddef4dc93a591dfe2f651cb0 upstream.

Commit 6bd4a5d96c08dc2380f8053b1bd4f879f55cd3c9 changed the
ANDROID_ALARM_GET_TIME ioctls from IOW to IOR.  While technically
correct, the _IOC_DIR bits are ignored by alarm_ioctl, so the
commit breaks a userspace ABI used by all existing Android devices
for a purely cosmetic reason.  Revert it.

Cc: Dae S. Kim <dae@velatum.com>
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/android/android_alarm.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/android/android_alarm.h b/drivers/staging/android/android_alarm.h
index f2ffd96..d0cafd6 100644
--- a/drivers/staging/android/android_alarm.h
+++ b/drivers/staging/android/android_alarm.h
@@ -51,12 +51,10 @@ enum android_alarm_return_flags {
 #define ANDROID_ALARM_WAIT                  _IO('a', 1)
 
 #define ALARM_IOW(c, type, size)            _IOW('a', (c) | ((type) << 4), size)
-#define ALARM_IOR(c, type, size)            _IOR('a', (c) | ((type) << 4), size)
-
 /* Set alarm */
 #define ANDROID_ALARM_SET(type)             ALARM_IOW(2, type, struct timespec)
 #define ANDROID_ALARM_SET_AND_WAIT(type)    ALARM_IOW(3, type, struct timespec)
-#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOR(4, type, struct timespec)
+#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOW(4, type, struct timespec)
 #define ANDROID_ALARM_SET_RTC               _IOW('a', 5, struct timespec)
 #define ANDROID_ALARM_BASE_CMD(cmd)         (cmd & ~(_IOC(0, 0, 0xf0, 0)))
 #define ANDROID_ALARM_IOCTL_TO_TYPE(cmd)    (_IOC_NR(cmd) >> 4)
-- 
1.7.9.5

