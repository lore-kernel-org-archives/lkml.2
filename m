Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0ILFNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:13:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1745 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab0ILFLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:11:06 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] arch/microblaze: Remove pr_<level> uses of KERN_<level>
Date: Sat, 11 Sep 2010 22:10:51 -0700
Message-Id: <72545a9af0fc4392d473e87b9e9120ba62eb3c87.1284267142.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/microblaze/kernel/exceptions.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/microblaze/kernel/exceptions.c b/arch/microblaze/kernel/exceptions.c
index b98ee8d..7dd4d12 100644
--- a/arch/microblaze/kernel/exceptions.c
+++ b/arch/microblaze/kernel/exceptions.c
@@ -86,8 +86,7 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 	switch (type & 0x1F) {
 	case MICROBLAZE_ILL_OPCODE_EXCEPTION:
 		if (user_mode(regs)) {
-			pr_debug(KERN_WARNING "Illegal opcode exception " \
-							"in user mode.\n");
+			pr_debug("Illegal opcode exception in user mode\n");
 			_exception(SIGILL, regs, ILL_ILLOPC, addr);
 			return;
 		}
@@ -97,8 +96,7 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 		break;
 	case MICROBLAZE_IBUS_EXCEPTION:
 		if (user_mode(regs)) {
-			pr_debug(KERN_WARNING "Instruction bus error " \
-						"exception in user mode.\n");
+			pr_debug("Instruction bus error exception in user mode\n");
 			_exception(SIGBUS, regs, BUS_ADRERR, addr);
 			return;
 		}
@@ -108,8 +106,7 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 		break;
 	case MICROBLAZE_DBUS_EXCEPTION:
 		if (user_mode(regs)) {
-			pr_debug(KERN_WARNING "Data bus error exception " \
-							"in user mode.\n");
+			pr_debug("Data bus error exception in user mode\n");
 			_exception(SIGBUS, regs, BUS_ADRERR, addr);
 			return;
 		}
@@ -119,8 +116,7 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 		break;
 	case MICROBLAZE_DIV_ZERO_EXCEPTION:
 		if (user_mode(regs)) {
-			pr_debug(KERN_WARNING "Divide by zero exception " \
-							"in user mode\n");
+			pr_debug("Divide by zero exception in user mode\n");
 			_exception(SIGILL, regs, FPE_INTDIV, addr);
 			return;
 		}
@@ -129,7 +125,7 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 		die("Divide by zero exception", regs, SIGBUS);
 		break;
 	case MICROBLAZE_FPU_EXCEPTION:
-		pr_debug(KERN_WARNING "FPU exception\n");
+		pr_debug("FPU exception\n");
 		/* IEEE FP exception */
 		/* I removed fsr variable and use code var for storing fsr */
 		if (fsr & FSR_IO)
@@ -147,7 +143,7 @@ asmlinkage void full_exception(struct pt_regs *regs, unsigned int type,
 
 #ifdef CONFIG_MMU
 	case MICROBLAZE_PRIVILEGED_EXCEPTION:
-		pr_debug(KERN_WARNING "Privileged exception\n");
+		pr_debug("Privileged exception\n");
 		/* "brk r0,r0" - used as debug breakpoint - old toolchain */
 		if (get_user(code, (unsigned long *)regs->pc) == 0
 			&& code == 0x980c0000) {
-- 
1.7.3.rc1

