Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0FWKGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:06:45 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37825 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab0FWKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:43 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Moyer <jmoyer@redhat.com>, David Howells <dhowells@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 34/40] trace syscalls: Convert generic syscalls without long return type
Date: Wed, 23 Jun 2010 20:03:15 +1000
Message-Id: <1277287401-28571-35-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch converts a number of syscalls from the generic code that had
return types other than long to use the new COMPAT_SYSCALL_DEFINEx_RET
macros so their metadata is recorded for tracing.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 fs/compat.c     |   24 ++++++++++++------------
 ipc/compat_mq.c |    8 ++++----
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 9897b7b..edfa4b5 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1224,9 +1224,9 @@ out:
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
-		 unsigned long vlen)
+COMPAT_SYSCALL_DEFINE3_RET(ssize_t, readv, unsigned long, fd,
+		const struct compat_iovec __user *, vec,
+		unsigned long, vlen)
 {
 	struct file *file;
 	int fput_needed;
@@ -1240,9 +1240,9 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
-		  unsigned long vlen, u32 pos_low, u32 pos_high)
+COMPAT_SYSCALL_DEFINE5_RET(ssize_t, preadv, unsigned long, fd,
+		const struct compat_iovec __user *, vec,
+		unsigned long, vlen, u32, pos_low, u32, pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
@@ -1281,9 +1281,9 @@ out:
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
-		  unsigned long vlen)
+COMPAT_SYSCALL_DEFINE3_RET(ssize_t, writev, unsigned long, fd,
+		const struct compat_iovec __user *, vec,
+		unsigned long, vlen)
 {
 	struct file *file;
 	int fput_needed;
@@ -1297,9 +1297,9 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
-		   unsigned long vlen, u32 pos_low, u32 pos_high)
+COMPAT_SYSCALL_DEFINE5_RET(ssize_t, pwritev, unsigned long, fd,
+		const struct compat_iovec __user *, vec,
+		unsigned long, vlen, u32, pos_low, u32, pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
diff --git a/ipc/compat_mq.c b/ipc/compat_mq.c
index 53593d3..22a394e 100644
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
@@ -89,10 +89,10 @@ COMPAT_SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes,
 			msg_prio, u_ts);
 }
 
-asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
-			char __user *u_msg_ptr,
-			size_t msg_len, unsigned int __user *u_msg_prio,
-			const struct compat_timespec __user *u_abs_timeout)
+COMPAT_SYSCALL_DEFINE5_RET(ssize_t, mq_timedreceive, mqd_t, mqdes,
+			char __user *, u_msg_ptr,
+			size_t, msg_len, unsigned int __user *, u_msg_prio,
+			const struct compat_timespec __user *, u_abs_timeout)
 {
 	struct timespec __user *u_ts;
 	if (compat_prepare_timeout(&u_ts, u_abs_timeout))
-- 
1.7.1

