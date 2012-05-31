Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2EaJ2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:28:48 -0400
Received: from skyrme.org ([193.175.80.135]:50872 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2EaJ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:28:47 -0400
Date: 31 May 2012 09:28:43 +0000
Message-Id: <1338456523-12390-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: linux-kernel@vger.kernel.org
Cc: "Oskar Schirmer" <oskar@scara.com>, "Corey Minyard" <minyard@acm.org>,
        "Wim Van Sebroeck" <wim@iguana.be>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] char/ipmi: remove local ioctl defines replaced by generic ones
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This watchdog driver had ioctl defines introduced locally
for pre timeout handling, marked to be removed as soon as
a generic replacement would become available.

The latter has actually occurred in 2006, at e05b59fe.

Remove the local duplicates for pre timeout handling.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/char/ipmi/ipmi_watchdog.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 7ed356e..37b8be7 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -141,17 +141,6 @@
 
 #define IPMI_WDOG_TIMER_NOT_INIT_RESP	0x80
 
-/* These are here until the real ones get into the watchdog.h interface. */
-#ifndef WDIOC_GETTIMEOUT
-#define	WDIOC_GETTIMEOUT        _IOW(WATCHDOG_IOCTL_BASE, 20, int)
-#endif
-#ifndef WDIOC_SET_PRETIMEOUT
-#define	WDIOC_SET_PRETIMEOUT     _IOW(WATCHDOG_IOCTL_BASE, 21, int)
-#endif
-#ifndef WDIOC_GET_PRETIMEOUT
-#define	WDIOC_GET_PRETIMEOUT     _IOW(WATCHDOG_IOCTL_BASE, 22, int)
-#endif
-
 static DEFINE_MUTEX(ipmi_watchdog_mutex);
 static bool nowayout = WATCHDOG_NOWAYOUT;
 
@@ -732,7 +721,6 @@ static int ipmi_ioctl(struct file *file,
 			return -EFAULT;
 		return 0;
 
-	case WDIOC_SET_PRETIMEOUT:
 	case WDIOC_SETPRETIMEOUT:
 		i = copy_from_user(&val, argp, sizeof(int));
 		if (i)
@@ -740,7 +728,6 @@ static int ipmi_ioctl(struct file *file,
 		pretimeout = val;
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 
-	case WDIOC_GET_PRETIMEOUT:
 	case WDIOC_GETPRETIMEOUT:
 		i = copy_to_user(argp, &pretimeout, sizeof(pretimeout));
 		if (i)
-- 
1.7.5.4

