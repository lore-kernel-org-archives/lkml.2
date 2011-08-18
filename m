Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1HRTAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:00:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49914 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1HRTAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:00:39 -0400
Date: Thu, 18 Aug 2011 20:00:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 10/91] um: make copy_sc() static
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7pX-0007Tv-6v@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... and kill it in amd64 - not used.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/shared/kern_util.h |    1 -
 arch/um/sys-i386/signal.c          |    2 +-
 arch/um/sys-x86_64/signal.c        |   30 ------------------------------
 3 files changed, 1 insertions(+), 32 deletions(-)

diff --git a/arch/um/include/shared/kern_util.h b/arch/um/include/shared/kern_util.h
index 3c34122..0f14838 100644
--- a/arch/um/include/shared/kern_util.h
+++ b/arch/um/include/shared/kern_util.h
@@ -21,7 +21,6 @@ extern unsigned long alloc_stack(int order, int atomic);
 extern void free_stack(unsigned long stack, int order);
 
 extern int do_signal(void);
-extern void copy_sc(struct uml_pt_regs *regs, void *from);
 extern void interrupt_end(void);
 extern void relay_signal(int sig, struct uml_pt_regs *regs);
 
diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
index 4403b48..b87195b 100644
--- a/arch/um/sys-i386/signal.c
+++ b/arch/um/sys-i386/signal.c
@@ -10,7 +10,7 @@
 #include "frame_kern.h"
 #include "skas.h"
 
-void copy_sc(struct uml_pt_regs *regs, void *from)
+static void copy_sc(struct uml_pt_regs *regs, void *from)
 {
 	struct sigcontext *sc = from;
 
diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
index ccfa554..61ad980 100644
--- a/arch/um/sys-x86_64/signal.c
+++ b/arch/um/sys-x86_64/signal.c
@@ -13,36 +13,6 @@
 #include "frame_kern.h"
 #include "skas.h"
 
-void copy_sc(struct uml_pt_regs *regs, void *from)
-{
-	struct sigcontext *sc = from;
-
-#define GETREG(regs, regno, sc, regname)				\
-	(regs)->gp[(regno) / sizeof(unsigned long)] = (sc)->regname
-
-	GETREG(regs, R8, sc, r8);
-	GETREG(regs, R9, sc, r9);
-	GETREG(regs, R10, sc, r10);
-	GETREG(regs, R11, sc, r11);
-	GETREG(regs, R12, sc, r12);
-	GETREG(regs, R13, sc, r13);
-	GETREG(regs, R14, sc, r14);
-	GETREG(regs, R15, sc, r15);
-	GETREG(regs, RDI, sc, di);
-	GETREG(regs, RSI, sc, si);
-	GETREG(regs, RBP, sc, bp);
-	GETREG(regs, RBX, sc, bx);
-	GETREG(regs, RDX, sc, dx);
-	GETREG(regs, RAX, sc, ax);
-	GETREG(regs, RCX, sc, cx);
-	GETREG(regs, RSP, sc, sp);
-	GETREG(regs, RIP, sc, ip);
-	GETREG(regs, EFLAGS, sc, flags);
-	GETREG(regs, CS, sc, cs);
-
-#undef GETREG
-}
-
 static int copy_sc_from_user(struct pt_regs *regs,
 			     struct sigcontext __user *from)
 {
-- 
1.7.2.5


