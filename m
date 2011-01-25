Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1AYX5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 18:57:12 -0500
Received: from smtp-out.google.com ([216.239.44.51]:25987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AYX5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 18:57:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:x-operating-system:user-agent;
        b=GnfVxcVW+aeYLyecl7CmSGV6GoNHWbvnAHBhaDBJNudfzisycIsWBUY+odXpZMbwf+
         4L/9KxRgdbF4FEf/syxA==
Date: Tue, 25 Jan 2011 15:57:00 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
Subject: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Message-ID: <20110125235700.GR8008@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux/2.6.32-gg298-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been burned by regressions/bugs which we later realized could
have been triaged quicker if only we'd paid closer attention to
dmesg. To make it easier to audit dmesg, we'd like to make
DEFAULT_MESSAGE_LEVEL Kconfig-settable. That way we can set it to
KERN_NOTICE and audit any messages <= KERN_WARNING.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
---
 kernel/printk.c   |    2 +-
 lib/Kconfig.debug |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 5ddd291..f91a7fd 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -59,7 +59,7 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 #define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
 
 /* printk's without a loglevel use this.. */
-#define DEFAULT_MESSAGE_LOGLEVEL 4 /* KERN_WARNING */
+#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
 /* We show everything that is MORE important than this.. */
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28b42b9..67b42fa 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -9,6 +9,18 @@ config PRINTK_TIME
 	  operations.  This is useful for identifying long delays
 	  in kernel startup.
 
+config DEFAULT_MESSAGE_LOGLEVEL
+	int "Default message log level (1-7)"
+	range 1 7
+	depends on PRINTK
+	default "4"
+	help
+	  Default log level for printk statements with no specified priority.
+
+	  This was hard-coded to KERN_WARNING since at least 2.6.10 but folks
+	  that are auditing their logs closely may want to set it to a lower
+	  priority.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
-- 
1.7.3.1

