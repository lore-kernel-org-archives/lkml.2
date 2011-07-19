Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1GSU6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:58:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:37828 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1GSU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:58:52 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <davem@davemloft.net>
CC: <kgdb-bugreport@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, <vapier@gentoo.org>
Subject: [PATCH] sparc,kgdbts: fix compile regression with kgdb test suite
Date: Tue, 19 Jul 2011 15:58:32 -0500
Message-ID: <1311109112-12909-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 63ab25ebbc (kgdbts: unify/generalize gdb breakpoint adjustment)
introduced a compile regression on sparc.

kgdbts.c: In function 'check_and_rewind_pc':
kgdbts.c:307: error: implicit declaration of function 'instruction_pointer_set'

Simply add the correct macro definition for instruction pointer on the
Sparc architecture.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/sparc/include/asm/ptrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/include/asm/ptrace.h b/arch/sparc/include/asm/ptrace.h
index c7ad3fe..b928b31 100644
--- a/arch/sparc/include/asm/ptrace.h
+++ b/arch/sparc/include/asm/ptrace.h
@@ -205,6 +205,7 @@ do {	current_thread_info()->syscall_noerror = 1; \
 } while (0)
 #define user_mode(regs) (!((regs)->tstate & TSTATE_PRIV))
 #define instruction_pointer(regs) ((regs)->tpc)
+#define instruction_pointer_set(regs, val) ((regs)->tpc = (val))
 #define user_stack_pointer(regs) ((regs)->u_regs[UREG_FP])
 #define regs_return_value(regs) ((regs)->u_regs[UREG_I0])
 #ifdef CONFIG_SMP
-- 
1.7.1

