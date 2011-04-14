Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab1DNGB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:01:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57553 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410Ab1DNGBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:01:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] asm-generic/ptrace.h: start a common low level ptrace helper
Date: Thu, 14 Apr 2011 02:01:31 -0400
Message-Id: <1302760895-13459-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc1
In-Reply-To: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a bunch of helper funcs for poking the registers of a
ptrace structure.  Now common code should be able to portably update
specific registers (like kgdb updating the PC).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/ptrace.h |   74 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/ptrace.h

diff --git a/include/asm-generic/ptrace.h b/include/asm-generic/ptrace.h
new file mode 100644
index 0000000..82e674f
--- /dev/null
+++ b/include/asm-generic/ptrace.h
@@ -0,0 +1,74 @@
+/*
+ * Common low level (register) ptrace helpers
+ *
+ * Copyright 2004-2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __ASM_GENERIC_PTRACE_H__
+#define __ASM_GENERIC_PTRACE_H__
+
+#ifndef __ASSEMBLY__
+
+/* Helpers for working with the instruction pointer */
+#ifndef GET_IP
+#define GET_IP(regs) ((regs)->pc)
+#endif
+#ifndef SET_IP
+#define SET_IP(regs, val) (GET_IP(regs) = (val))
+#endif
+
+static inline unsigned long instruction_pointer(struct pt_regs *regs)
+{
+	return GET_IP(regs);
+}
+static inline void instruction_pointer_set(struct pt_regs *regs,
+                                           unsigned long val)
+{
+	SET_IP(regs, val);
+}
+
+#ifndef profile_pc
+#define profile_pc(regs) instruction_pointer(regs)
+#endif
+
+/* Helpers for working with the user stack pointer */
+#ifndef GET_USP
+#define GET_USP(regs) ((regs)->usp)
+#endif
+#ifndef SET_USP
+#define SET_USP(regs, val) (GET_USP(regs) = (val))
+#endif
+
+static inline unsigned long user_stack_pointer(struct pt_regs *regs)
+{
+	return GET_USP(regs);
+}
+static inline void user_stack_pointer_set(struct pt_regs *regs,
+                                          unsigned long val)
+{
+	SET_USP(regs, val);
+}
+
+/* Helpers for working with the frame pointer */
+#ifndef GET_FP
+#define GET_FP(regs) ((regs)->fp)
+#endif
+#ifndef SET_FP
+#define SET_FP(regs, val) (GET_FP(regs) = (val))
+#endif
+
+static inline unsigned long frame_pointer(struct pt_regs *regs)
+{
+	return GET_FP(regs);
+}
+static inline void frame_pointer_set(struct pt_regs *regs,
+                                     unsigned long val)
+{
+	SET_FP(regs, val);
+}
+
+#endif /* __ASSEMBLY__ */
+
+#endif
-- 
1.7.5.rc1

