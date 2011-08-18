Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1HRTHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:07:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47493 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1HRTHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:07:40 -0400
Date: Thu, 18 Aug 2011 20:07:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 52/91] um: kill shared/task.h and HOST_TASK_REGS
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7wJ-0007oZ-NP@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/common-offsets.h |    1 -
 arch/um/include/shared/task.h           |    9 ---------
 arch/x86/um/bugs_32.c                   |    4 +++-
 3 files changed, 3 insertions(+), 11 deletions(-)
 delete mode 100644 arch/um/include/shared/task.h

diff --git a/arch/um/include/shared/common-offsets.h b/arch/um/include/shared/common-offsets.h
index 72009c7..d7fe563 100644
--- a/arch/um/include/shared/common-offsets.h
+++ b/arch/um/include/shared/common-offsets.h
@@ -2,7 +2,6 @@
 
 DEFINE(KERNEL_MADV_REMOVE, MADV_REMOVE);
 
-OFFSET(HOST_TASK_REGS, task_struct, thread.regs);
 OFFSET(HOST_TASK_PID, task_struct, pid);
 
 DEFINE(UM_KERN_PAGE_SIZE, PAGE_SIZE);
diff --git a/arch/um/include/shared/task.h b/arch/um/include/shared/task.h
deleted file mode 100644
index 3db6b58..0000000
--- a/arch/um/include/shared/task.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __TASK_H
-#define __TASK_H
-
-#include <generated/asm-offsets.h>
-
-#define TASK_REGS(task) ((struct uml_pt_regs *) &(((char *) (task))[HOST_TASK_REGS]))
-#define TASK_PID(task) *((int *) &(((char *) (task))[HOST_TASK_PID]))
-
-#endif
diff --git a/arch/x86/um/bugs_32.c b/arch/x86/um/bugs_32.c
index 7058e1f..a1fba5f 100644
--- a/arch/x86/um/bugs_32.c
+++ b/arch/x86/um/bugs_32.c
@@ -6,13 +6,15 @@
 #include <signal.h>
 #include "kern_util.h"
 #include "longjmp.h"
-#include "task.h"
 #include "sysdep/ptrace.h"
+#include <generated/asm-offsets.h>
 
 /* Set during early boot */
 static int host_has_cmov = 1;
 static jmp_buf cmov_test_return;
 
+#define TASK_PID(task) *((int *) &(((char *) (task))[HOST_TASK_PID]))
+
 static void cmov_sigill_test_handler(int sig)
 {
 	host_has_cmov = 0;
-- 
1.7.2.5


