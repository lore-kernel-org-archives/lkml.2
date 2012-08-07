Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2HGXgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:36:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2HGW3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Kerrisk <mtk.man-pages@gmail.com>
Subject: [ 042/122] PM / Sleep: Require CAP_BLOCK_SUSPEND to use wake_lock/wake_unlock
Date: Tue,  7 Aug 2012 15:25:30 -0700
Message-Id: <20120807221951.996747839@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 11388c87d2abca1f01975ced28ce9eacea239104 upstream.

Require processes wanting to use the wake_lock/wake_unlock sysfs
files to have the CAP_BLOCK_SUSPEND capability, which also is
required for the eventpoll EPOLLWAKEUP flag to be effective, so that
all interfaces related to blocking autosleep depend on the same
capability.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Michael Kerrisk <mtk.man-pages@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/wakelock.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -9,6 +9,7 @@
  * manipulate wakelocks on Android.
  */
 
+#include <linux/capability.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -188,6 +189,9 @@ int pm_wake_lock(const char *buf)
 	size_t len;
 	int ret = 0;
 
+	if (!capable(CAP_BLOCK_SUSPEND))
+		return -EPERM;
+
 	while (*str && !isspace(*str))
 		str++;
 
@@ -231,6 +235,9 @@ int pm_wake_unlock(const char *buf)
 	size_t len;
 	int ret = 0;
 
+	if (!capable(CAP_BLOCK_SUSPEND))
+		return -EPERM;
+
 	len = strlen(buf);
 	if (!len)
 		return -EINVAL;


