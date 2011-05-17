Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1EQRpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:45:32 -0400
Received: from [69.28.251.93] ([69.28.251.93]:37645 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab1EQRpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:45:30 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH resend] ipc: Add missing sys_ni entries for ipc/compat.c functions
Date: Tue, 17 May 2011 10:39:58 -0700
Message-Id: <5a124a3b070fd1dc1f28d72e78e72534@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building with:

CONFIG_64BIT=y
CONFIG_MIPS32_COMPAT=y
CONFIG_COMPAT=y
CONFIG_MIPS32_O32=y
CONFIG_MIPS32_N32=y
CONFIG_SYSVIPC is not set
(and implicitly: CONFIG_SYSVIPC_COMPAT is not set)

the final link fails with unresolved symbols for:

compat_sys_semctl, compat_sys_msgsnd, compat_sys_msgrcv,
compat_sys_shmctl, compat_sys_msgctl, compat_sys_semtimedop

The fix is to add cond_syscall declarations for all syscalls in
ipc/compat.c

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/sys_ni.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 25cc41c..1140c12 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -69,15 +69,22 @@ cond_syscall(compat_sys_epoll_pwait);
 cond_syscall(sys_semget);
 cond_syscall(sys_semop);
 cond_syscall(sys_semtimedop);
+cond_syscall(compat_sys_semtimedop);
 cond_syscall(sys_semctl);
+cond_syscall(compat_sys_semctl);
 cond_syscall(sys_msgget);
 cond_syscall(sys_msgsnd);
+cond_syscall(compat_sys_msgsnd);
 cond_syscall(sys_msgrcv);
+cond_syscall(compat_sys_msgrcv);
 cond_syscall(sys_msgctl);
+cond_syscall(compat_sys_msgctl);
 cond_syscall(sys_shmget);
 cond_syscall(sys_shmat);
+cond_syscall(compat_sys_shmat);
 cond_syscall(sys_shmdt);
 cond_syscall(sys_shmctl);
+cond_syscall(compat_sys_shmctl);
 cond_syscall(sys_mq_open);
 cond_syscall(sys_mq_unlink);
 cond_syscall(sys_mq_timedsend);
-- 
1.7.5

