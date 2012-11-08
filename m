Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2KHCWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:22:03 -0500
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50525 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2KHCWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:22:00 -0500
From: Colin Cross <ccross@android.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, stable <stable@vger.kernel.org>,
        "Dae S. Kim" <dae@velatum.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] Revert "Staging: Android alarm: IOCTL command encoding fix"
Date: Wed,  7 Nov 2012 18:21:51 -0800
Message-Id: <1352341313-1274-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6bd4a5d96c08dc2380f8053b1bd4f879f55cd3c9 changed the
ANDROID_ALARM_GET_TIME ioctls from IOW to IOR.  While technically
correct, the _IOC_DIR bits are ignored by alarm_ioctl, so the
commit breaks a userspace ABI used by all existing Android devices
for a purely cosmetic reason.  Revert it.

Cc: stable <stable@vger.kernel.org>
Cc: Dae S. Kim <dae@velatum.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/staging/android/android_alarm.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

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
1.7.7.3

