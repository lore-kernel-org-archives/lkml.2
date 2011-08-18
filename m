Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1HRTBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:01:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44220 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1HRTBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:01:09 -0400
Date: Thu, 18 Aug 2011 20:01:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 13/91] um: kill skas_ptregs.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7q1-0007Vf-7b@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's a plain include of user_constants.h and all (2) users are
including user_constants.h directly prior to that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/skas_ptregs.h      |    6 ------
 arch/um/sys-i386/shared/sysdep/ptrace.h   |    2 --
 arch/um/sys-x86_64/shared/sysdep/ptrace.h |    2 --
 3 files changed, 0 insertions(+), 10 deletions(-)
 delete mode 100644 arch/um/include/shared/skas_ptregs.h

diff --git a/arch/um/include/shared/skas_ptregs.h b/arch/um/include/shared/skas_ptregs.h
deleted file mode 100644
index 73db19e..0000000
--- a/arch/um/include/shared/skas_ptregs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __SKAS_PT_REGS_
-#define __SKAS_PT_REGS_
-
-#include <user_constants.h>
-
-#endif
diff --git a/arch/um/sys-i386/shared/sysdep/ptrace.h b/arch/um/sys-i386/shared/sysdep/ptrace.h
index d50e62e..06e03b8 100644
--- a/arch/um/sys-i386/shared/sysdep/ptrace.h
+++ b/arch/um/sys-i386/shared/sysdep/ptrace.h
@@ -24,8 +24,6 @@ void set_using_sysemu(int value);
 int get_using_sysemu(void);
 extern int sysemu_supported;
 
-#include "skas_ptregs.h"
-
 #define REGS_IP(r) ((r)[HOST_IP])
 #define REGS_SP(r) ((r)[HOST_SP])
 #define REGS_EFLAGS(r) ((r)[HOST_EFLAGS])
diff --git a/arch/um/sys-x86_64/shared/sysdep/ptrace.h b/arch/um/sys-x86_64/shared/sysdep/ptrace.h
index fdba545..096547b 100644
--- a/arch/um/sys-x86_64/shared/sysdep/ptrace.h
+++ b/arch/um/sys-x86_64/shared/sysdep/ptrace.h
@@ -14,8 +14,6 @@
 #define MAX_REG_OFFSET (UM_FRAME_SIZE)
 #define MAX_REG_NR ((MAX_REG_OFFSET) / sizeof(unsigned long))
 
-#include "skas_ptregs.h"
-
 #define REGS_IP(r) ((r)[HOST_IP])
 #define REGS_SP(r) ((r)[HOST_SP])
 
-- 
1.7.2.5


