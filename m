Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1DNGCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:02:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57618 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627Ab1DNGBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:01:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] sh: convert to asm-generic ptrace.h
Date: Thu, 14 Apr 2011 02:01:34 -0400
Message-Id: <1302760895-13459-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc1
In-Reply-To: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/sh/include/asm/ptrace.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/ptrace.h b/arch/sh/include/asm/ptrace.h
index b219a08..3f2a6e7 100644
--- a/arch/sh/include/asm/ptrace.h
+++ b/arch/sh/include/asm/ptrace.h
@@ -40,9 +40,8 @@
 #include <asm/system.h>
 
 #define user_mode(regs)			(((regs)->sr & 0x40000000)==0)
-#define user_stack_pointer(_regs)	((unsigned long)(_regs)->regs[15])
 #define kernel_stack_pointer(_regs)	((unsigned long)(_regs)->regs[15])
-#define instruction_pointer(regs)	((unsigned long)(regs)->pc)
+#define GET_USP(regs) ((regs)->regs[15])
 
 #define arch_has_single_step()	(1)
 
@@ -137,6 +136,9 @@ static inline unsigned long profile_pc(struct pt_regs *regs)
 
 	return pc;
 }
+#define profile_pc profile_pc
+
+#include <asm-generic/ptrace.h>
 #endif /* __KERNEL__ */
 
 #endif /* __ASM_SH_PTRACE_H */
-- 
1.7.5.rc1

