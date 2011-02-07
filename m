Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1BGLvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:51:45 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:58205 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1BGLvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:51:44 -0500
Subject: [PATCH] Export linux/syslog.h
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <kees.cook@canonical.com>, David Woodhouse <dwmw2@infradead.org>
Date: Mon, 07 Feb 2011 12:51:36 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297079503.1741.10.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace programs (like util-linux' dmesg) still use magic numbers for
the klogctl function (glibc's interface to the syslog system call).
Exporting linux/syslog.h makes the more descriptive named constants
available as a single reference for these values.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 include/linux/Kbuild   |    1 +
 include/linux/syslog.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

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
index 3891139..75950af 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -44,9 +44,11 @@
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



