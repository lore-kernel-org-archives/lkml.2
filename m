Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2LXB5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 20:57:21 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:37711 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2LXB5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 20:57:18 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] linux/audit.h: move ptrace.h include to kernel header
Date: Sun, 23 Dec 2012 20:57:48 -0500
Message-Id: <1356314268-15193-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the kernel internals want pt_regs (and so it includes
linux/ptrace.h), the user version of audit.h does not need
it.  So move the include out of the uapi version.

This avoids issues where people want the audit defines and
userland ptrace api.  Including both the kernel ptrace and
the userland ptrace headers can easily lead to failure.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/audit.h      | 1 +
 include/uapi/linux/audit.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index bce729a..9929785 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -24,6 +24,7 @@
 #define _LINUX_AUDIT_H_
 
 #include <linux/sched.h>
+#include <linux/ptrace.h>
 #include <uapi/linux/audit.h>
 
 struct audit_sig_info {
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 76352ac..ab8663f 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -26,7 +26,6 @@
 
 #include <linux/types.h>
 #include <linux/elf-em.h>
-#include <linux/ptrace.h>
 
 /* The netlink messages for the audit system is divided into blocks:
  * 1000 - 1099 are for commanding the audit system
-- 
1.8.0

