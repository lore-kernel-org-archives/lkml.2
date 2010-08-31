Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0HaLrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:47:20 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:64686 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab0HaLrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:47:19 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: lkml@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christoph Hellwig <hch@lst.de>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] wire up sys_time_change_notify() on s390
Date: Tue, 31 Aug 2010 14:45:51 +0300
Message-Id: <1283255151-6364-7-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283255151-6364-1-git-send-email-virtuoso@slind.org>
References: <1283255151-6364-1-git-send-email-virtuoso@slind.org>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux390@de.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: David Howells <dhowells@redhat.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Christoph Hellwig <hch@lst.de>
CC: linux-s390@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 arch/s390/include/asm/unistd.h    |    3 ++-
 arch/s390/kernel/compat_wrapper.S |    6 ++++++
 arch/s390/kernel/syscalls.S       |    1 +
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index 1049ef2..f815a2d 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -272,7 +272,8 @@
 #define __NR_fanotify_init	332
 #define __NR_fanotify_mark	333
 #define __NR_prlimit64		334
-#define NR_syscalls 335
+#define __NR_time_change_notify	335
+#define NR_syscalls 336
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 8e60fb2..4570418 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1877,3 +1877,9 @@ sys_prlimit64_wrapper:
 	llgtr	%r4,%r4			# const struct rlimit64 __user *
 	llgtr	%r5,%r5			# struct rlimit64 __user *
 	jg	sys_prlimit64		# branch to system call
+
+	.globl sys_time_change_notify_wrapper
+sys_time_change_notify_wrapper:
+	lgfr	%r2,%r2			# int
+	llgfr	%r3,%r3			# unsigned int
+	jg	sys_time_change_notify	# branch to system call
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index a8fee1b..b242383 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -343,3 +343,4 @@ SYSCALL(sys_perf_event_open,sys_perf_event_open,sys_perf_event_open_wrapper)
 SYSCALL(sys_fanotify_init,sys_fanotify_init,sys_fanotify_init_wrapper)
 SYSCALL(sys_fanotify_mark,sys_fanotify_mark,sys_fanotify_mark_wrapper)
 SYSCALL(sys_prlimit64,sys_prlimit64,sys_prlimit64_wrapper)
+SYSCALL(sys_time_change_notify,sys_time_change_notify,sys_time_change_notify_wrapper) /* 335 */
\ No newline at end of file
-- 
1.7.1

