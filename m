Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2KVWCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:02:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:49630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab2KVSkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Dae S. Kim" <dae@velatum.com>, Colin Cross <ccross@android.com>
Subject: [ 023/171] Revert "Staging: Android alarm: IOCTL command encoding fix"
Date: Wed, 21 Nov 2012 16:39:29 -0800
Message-Id: <20121122004035.687907655@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/android/android_alarm.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/staging/android/android_alarm.h
+++ b/drivers/staging/android/android_alarm.h
@@ -110,12 +110,10 @@ enum android_alarm_return_flags {
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


