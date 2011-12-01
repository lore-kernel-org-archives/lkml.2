Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1LASPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:15:16 -0500
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:14924 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab1LASPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:15:13 -0500
Message-Id: <201112011815.pB1IFACw004908@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Dec 2011 12:54:31 -0500
Subject: [PATCH] asm-generic/unistd.h: support new process_vm_{readv,write} syscalls
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@redhat.com>, NeilBrown <neilb@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-arch@vger.kernel.org
X-OriginalArrivalTime: 01 Dec 2011 18:15:12.0347 (UTC) FILETIME=[2AC9AAB0:01CCB055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also prototype the "compat" functions so they can be referenced
from C code.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 include/asm-generic/unistd.h |    8 +++++++-
 include/linux/compat.h       |    9 +++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index f4c38d8..2292d1a 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -685,9 +685,15 @@ __SYSCALL(__NR_syncfs, sys_syncfs)
 __SYSCALL(__NR_setns, sys_setns)
 #define __NR_sendmmsg 269
 __SC_COMP(__NR_sendmmsg, sys_sendmmsg, compat_sys_sendmmsg)
+#define __NR_process_vm_readv 270
+__SC_COMP(__NR_process_vm_readv, sys_process_vm_readv, \
+          compat_sys_process_vm_readv)
+#define __NR_process_vm_writev 271
+__SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
+          compat_sys_process_vm_writev)
 
 #undef __NR_syscalls
-#define __NR_syscalls 270
+#define __NR_syscalls 272
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 154bf56..66ed067 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -552,5 +552,14 @@ extern ssize_t compat_rw_copy_check_uvector(int type,
 
 extern void __user *compat_alloc_user_space(unsigned long len);
 
+asmlinkage ssize_t compat_sys_process_vm_readv(compat_pid_t pid,
+		const struct compat_iovec __user *lvec,
+		unsigned long liovcnt, const struct compat_iovec __user *rvec,
+		unsigned long riovcnt, unsigned long flags);
+asmlinkage ssize_t compat_sys_process_vm_writev(compat_pid_t pid,
+		const struct compat_iovec __user *lvec,
+		unsigned long liovcnt, const struct compat_iovec __user *rvec,
+		unsigned long riovcnt, unsigned long flags);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
-- 
1.6.5.2

