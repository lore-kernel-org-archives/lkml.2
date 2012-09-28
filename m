Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab2I1S4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:56:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964820Ab2I1S4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Dae S. Kim" <dae@velatum.com>
Subject: [ 049/262] Staging: Android alarm: IOCTL command encoding fix
Date: Fri, 28 Sep 2012 11:49:38 -0700
Message-Id: <20120928183003.710621171@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Dae S. Kim" <dae@velatum.com>

commit 6bd4a5d96c08dc2380f8053b1bd4f879f55cd3c9 upstream.

Fixed a bug. Data was being written to user space using an IOCTL
command encoded with _IOC_WRITE access mode.

Signed-off-by: Dae S. Kim <dae@velatum.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/android_alarm.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/android/android_alarm.h
+++ b/drivers/staging/android/android_alarm.h
@@ -51,10 +51,12 @@ enum android_alarm_return_flags {
 #define ANDROID_ALARM_WAIT                  _IO('a', 1)
 
 #define ALARM_IOW(c, type, size)            _IOW('a', (c) | ((type) << 4), size)
+#define ALARM_IOR(c, type, size)            _IOR('a', (c) | ((type) << 4), size)
+
 /* Set alarm */
 #define ANDROID_ALARM_SET(type)             ALARM_IOW(2, type, struct timespec)
 #define ANDROID_ALARM_SET_AND_WAIT(type)    ALARM_IOW(3, type, struct timespec)
-#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOW(4, type, struct timespec)
+#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOR(4, type, struct timespec)
 #define ANDROID_ALARM_SET_RTC               _IOW('a', 5, struct timespec)
 #define ANDROID_ALARM_BASE_CMD(cmd)         (cmd & ~(_IOC(0, 0, 0xf0, 0)))
 #define ANDROID_ALARM_IOCTL_TO_TYPE(cmd)    (_IOC_NR(cmd) >> 4)


