Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab0HZEup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:50:45 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40684 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab0HZEul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:50:41 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Schwab <schwab@linux-m68k.org>, Christoph Hellwig <hch@lst.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc: Wire up direct socket system calls
Date: Thu, 26 Aug 2010 14:50:28 +1000
Message-Id: <1282798228-340-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch wires up the various socket system calls on PowerPC so that
userspace can call them directly, rather than by going through the
multiplexed socketcall system call.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/systbl.h |   19 +++++++++++++++++++
 arch/powerpc/include/asm/unistd.h |   21 ++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 3d21266..aa0f1eb 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -329,3 +329,22 @@ COMPAT_SYS(rt_tgsigqueueinfo)
 SYSCALL(fanotify_init)
 COMPAT_SYS(fanotify_mark)
 SYSCALL_SPU(prlimit64)
+SYSCALL_SPU(socket)
+SYSCALL_SPU(bind)
+SYSCALL_SPU(connect)
+SYSCALL_SPU(listen)
+SYSCALL_SPU(accept)
+SYSCALL_SPU(getsockname)
+SYSCALL_SPU(getpeername)
+SYSCALL_SPU(socketpair)
+SYSCALL_SPU(send)
+SYSCALL_SPU(sendto)
+COMPAT_SYS_SPU(recv)
+COMPAT_SYS_SPU(recvfrom)
+SYSCALL_SPU(shutdown)
+COMPAT_SYS_SPU(setsockopt)
+COMPAT_SYS_SPU(getsockopt)
+COMPAT_SYS_SPU(sendmsg)
+COMPAT_SYS_SPU(recvmsg)
+COMPAT_SYS_SPU(recvmmsg)
+SYSCALL_SPU(accept4)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 597e6f9..6151937 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -348,10 +348,29 @@
 #define __NR_fanotify_init	323
 #define __NR_fanotify_mark	324
 #define __NR_prlimit64		325
+#define __NR_socket		326
+#define __NR_bind		327
+#define __NR_connect		328
+#define __NR_listen		329
+#define __NR_accept		330
+#define __NR_getsockname	331
+#define __NR_getpeername	332
+#define __NR_socketpair		333
+#define __NR_send		334
+#define __NR_sendto		335
+#define __NR_recv		336
+#define __NR_recvfrom		337
+#define __NR_shutdown		338
+#define __NR_setsockopt		339
+#define __NR_getsockopt		340
+#define __NR_sendmsg		341
+#define __NR_recvmsg		342
+#define __NR_recvmmsg		343
+#define __NR_accept4		344
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		326
+#define __NR_syscalls		345
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
-- 
1.7.1

