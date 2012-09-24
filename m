Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2IXTra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:47:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869Ab2IXTr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:47:28 -0400
From: Mark Salter <msalter@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] syscalls: add __NR_kcmp syscall to generic unistd.h
Date: Mon, 24 Sep 2012 15:47:04 -0400
Message-Id: <1348516024-4992-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d97b46a64 added a new syscall (__NR_kcmp) to support checkpoint
restore. It is currently x86-only, but that restriction will be removed
in a subsequent patch. Unfortunately, the kernel checksyscalls script
had a bug which suppressed any warning to other architectures that the
kcmp syscall was not implemented. A patch to checksyscalls is being
tested in linux-next and other architectures are seeing warnings about
kcmp being unimplemented.

This patch adds __NR_kcmp to <asm-generic/unistd.h> so that kcmp is
wired in for architectures using the generic syscall list.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 include/asm-generic/unistd.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 991ef01..3748ec9 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -691,9 +691,11 @@ __SC_COMP(__NR_process_vm_readv, sys_process_vm_readv, \
 #define __NR_process_vm_writev 271
 __SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
           compat_sys_process_vm_writev)
+#define __NR_kcmp 272
+__SYSCALL(__NR_kcmp, sys_kcmp)
 
 #undef __NR_syscalls
-#define __NR_syscalls 272
+#define __NR_syscalls 273
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.9.1

