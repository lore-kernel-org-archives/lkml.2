Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1BHWPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:15:22 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:39986 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1BHWPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:15:21 -0500
Subject: [PATCH v2 1/2] Export linux/syslog.h
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <kees.cook@canonical.com>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, mtk.manpages@gmail.com
Date: Tue, 08 Feb 2011 23:15:08 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297203320.1748.14.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace programs (like util-linux' dmesg) still use magic numbers for
the klogctl function (glibc's interface to the syslog system call).
Exporting linux/syslog.h makes the more descriptive named constants
available as a single reference for these values.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Changes in v2:
- dropped the "Syslog internals" comment;
- dropped Kees' Singed-off-by, since the patch has changed.

 include/linux/Kbuild   |    1 +
 include/linux/syslog.h |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b0ada6f..c80f55f 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -347,6 +347,7 @@ header-y += suspend_ioctls.h
 header-y += swab.h
 header-y += synclink.h
 header-y += sysctl.h
+header-y += syslog.h
 header-y += taskstats.h
 header-y += tcp.h
 header-y += telephony.h
diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 3891139..69b85e6 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -1,6 +1,4 @@
-/*  Syslog internals
- *
- *  Copyright 2010 Canonical, Ltd.
+/*  Copyright 2010 Canonical, Ltd.
  *  Author: Kees Cook <kees.cook@canonical.com>
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -44,9 +42,11 @@
 /* Return size of the log buffer */
 #define SYSLOG_ACTION_SIZE_BUFFER   10
 
+#ifdef __KERNEL__
 #define SYSLOG_FROM_CALL 0
 #define SYSLOG_FROM_FILE 1
 
 int do_syslog(int type, char __user *buf, int count, bool from_file);
+#endif
 
 #endif /* _LINUX_SYSLOG_H */
-- 
1.7.4

