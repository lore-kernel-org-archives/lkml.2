Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab1BPHrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:47:33 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:57502 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab1BPHr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:47:29 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 03/12] unicore32 additional architecture files: ptrace handling
Date: Wed, 16 Feb 2011 15:47:24 +0800
Message-ID: <014701cbcdad$bfd95a00$3f8c0e00$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrbOVX9rlgb5KSY+uSOjbgkCfgw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <441707e0fa10fd1572f6fabfb7b0bd852e5c34c1.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 15 Jan 2011 18:21:56 +0800

This patch adds ptrace support.

Changed from previous version:
    1. disable arch_has_single_step and remove single-step instruction handler
    2. add 'Ross Biro 1/23/92' contributor information
    3. clean unused codes

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/unicore32/include/asm/ptrace.h |  133 +++++++++++++++++++++++++++++++
 arch/unicore32/kernel/ptrace.c      |  149 +++++++++++++++++++++++++++++++++++
 2 files changed, 282 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/ptrace.h
 create mode 100644 arch/unicore32/kernel/ptrace.c

diff --git a/arch/unicore32/include/asm/ptrace.h b/arch/unicore32/include/asm/ptrace.h
new file mode 100644
index 0000000..b9caf9b
--- /dev/null
+++ b/arch/unicore32/include/asm/ptrace.h
@@ -0,0 +1,133 @@
+/*
+ * linux/arch/unicore32/include/asm/ptrace.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_PTRACE_H__
+#define __UNICORE_PTRACE_H__
+
+#define PTRACE_GET_THREAD_AREA	22
+
+/*
+ * PSR bits
+ */
+#define USER_MODE	0x00000010
+#define REAL_MODE	0x00000011
+#define INTR_MODE	0x00000012
+#define PRIV_MODE	0x00000013
+#define ABRT_MODE	0x00000017
+#define EXTN_MODE	0x0000001b
+#define SUSR_MODE	0x0000001f
+#define MODE_MASK	0x0000001f
+#define PSR_R_BIT	0x00000040
+#define PSR_I_BIT	0x00000080
+#define PSR_V_BIT	0x10000000
+#define PSR_C_BIT	0x20000000
+#define PSR_Z_BIT	0x40000000
+#define PSR_S_BIT	0x80000000
+
+/*
+ * Groups of PSR bits
+ */
+#define PSR_f		0xff000000	/* Flags		*/
+#define PSR_c		0x000000ff	/* Control		*/
+
+#ifndef __ASSEMBLY__
+
+/*
+ * This struct defines the way the registers are stored on the
+ * stack during a system call.  Note that sizeof(struct pt_regs)
+ * has to be a multiple of 8.
+ */
+struct pt_regs {
+	unsigned long uregs[34];
+};
+
+#define UCreg_asr		uregs[32]
+#define UCreg_pc		uregs[31]
+#define UCreg_lr		uregs[30]
+#define UCreg_sp		uregs[29]
+#define UCreg_ip		uregs[28]
+#define UCreg_fp		uregs[27]
+#define UCreg_26		uregs[26]
+#define UCreg_25		uregs[25]
+#define UCreg_24		uregs[24]
+#define UCreg_23		uregs[23]
+#define UCreg_22		uregs[22]
+#define UCreg_21		uregs[21]
+#define UCreg_20		uregs[20]
+#define UCreg_19		uregs[19]
+#define UCreg_18		uregs[18]
+#define UCreg_17		uregs[17]
+#define UCreg_16		uregs[16]
+#define UCreg_15		uregs[15]
+#define UCreg_14		uregs[14]
+#define UCreg_13		uregs[13]
+#define UCreg_12		uregs[12]
+#define UCreg_11		uregs[11]
+#define UCreg_10		uregs[10]
+#define UCreg_09		uregs[9]
+#define UCreg_08		uregs[8]
+#define UCreg_07		uregs[7]
+#define UCreg_06		uregs[6]
+#define UCreg_05		uregs[5]
+#define UCreg_04		uregs[4]
+#define UCreg_03		uregs[3]
+#define UCreg_02		uregs[2]
+#define UCreg_01		uregs[1]
+#define UCreg_00		uregs[0]
+#define UCreg_ORIG_00		uregs[33]
+
+#ifdef __KERNEL__
+
+#define user_mode(regs)	\
+	(processor_mode(regs) == USER_MODE)
+
+#define processor_mode(regs) \
+	((regs)->UCreg_asr & MODE_MASK)
+
+#define interrupts_enabled(regs) \
+	(!((regs)->UCreg_asr & PSR_I_BIT))
+
+#define fast_interrupts_enabled(regs) \
+	(!((regs)->UCreg_asr & PSR_R_BIT))
+
+/* Are the current registers suitable for user mode?
+ * (used to maintain security in signal handlers)
+ */
+static inline int valid_user_regs(struct pt_regs *regs)
+{
+	unsigned long mode = regs->UCreg_asr & MODE_MASK;
+
+	/*
+	 * Always clear the R (REAL) bits
+	 */
+	regs->UCreg_asr &= ~(PSR_R_BIT);
+
+	if ((regs->UCreg_asr & PSR_I_BIT) == 0) {
+		if (mode == USER_MODE)
+			return 1;
+	}
+
+	/*
+	 * Force ASR to something logical...
+	 */
+	regs->UCreg_asr &= PSR_f | USER_MODE;
+
+	return 0;
+}
+
+#define instruction_pointer(regs)	((regs)->UCreg_pc)
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASSEMBLY__ */
+
+#endif
+
diff --git a/arch/unicore32/kernel/ptrace.c b/arch/unicore32/kernel/ptrace.c
new file mode 100644
index 0000000..9f07c08
--- /dev/null
+++ b/arch/unicore32/kernel/ptrace.c
@@ -0,0 +1,149 @@
+/*
+ * linux/arch/unicore32/kernel/ptrace.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * By Ross Biro 1/23/92
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/ptrace.h>
+#include <linux/signal.h>
+#include <linux/uaccess.h>
+
+/*
+ * this routine will get a word off of the processes privileged stack.
+ * the offset is how far from the base addr as stored in the THREAD.
+ * this routine assumes that all the privileged stacks are in our
+ * data space.
+ */
+static inline long get_user_reg(struct task_struct *task, int offset)
+{
+	return task_pt_regs(task)->uregs[offset];
+}
+
+/*
+ * this routine will put a word on the processes privileged stack.
+ * the offset is how far from the base addr as stored in the THREAD.
+ * this routine assumes that all the privileged stacks are in our
+ * data space.
+ */
+static inline int
+put_user_reg(struct task_struct *task, int offset, long data)
+{
+	struct pt_regs newregs, *regs = task_pt_regs(task);
+	int ret = -EINVAL;
+
+	newregs = *regs;
+	newregs.uregs[offset] = data;
+
+	if (valid_user_regs(&newregs)) {
+		regs->uregs[offset] = data;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+/*
+ * Called by kernel/ptrace.c when detaching..
+ */
+void ptrace_disable(struct task_struct *child)
+{
+}
+
+/*
+ * We actually access the pt_regs stored on the kernel stack.
+ */
+static int ptrace_read_user(struct task_struct *tsk, unsigned long off,
+			    unsigned long __user *ret)
+{
+	unsigned long tmp;
+
+	tmp = 0;
+	if (off < sizeof(struct pt_regs))
+		tmp = get_user_reg(tsk, off >> 2);
+
+	return put_user(tmp, ret);
+}
+
+/*
+ * We actually access the pt_regs stored on the kernel stack.
+ */
+static int ptrace_write_user(struct task_struct *tsk, unsigned long off,
+			     unsigned long val)
+{
+	if (off >= sizeof(struct pt_regs))
+		return 0;
+
+	return put_user_reg(tsk, off >> 2, val);
+}
+
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
+{
+	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
+
+	switch (request) {
+	case PTRACE_PEEKUSR:
+		ret = ptrace_read_user(child, addr, datap);
+		break;
+
+	case PTRACE_POKEUSR:
+		ret = ptrace_write_user(child, addr, data);
+		break;
+
+	case PTRACE_GET_THREAD_AREA:
+		ret = put_user(task_pt_regs(child)->UCreg_16,
+			       datap);
+		break;
+
+	default:
+		ret = ptrace_request(child, request, addr, data);
+		break;
+	}
+
+	return ret;
+}
+
+asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
+{
+	unsigned long ip;
+
+	if (!test_thread_flag(TIF_SYSCALL_TRACE))
+		return scno;
+	if (!(current->ptrace & PT_PTRACED))
+		return scno;
+
+	/*
+	 * Save IP.  IP is used to denote syscall entry/exit:
+	 *  IP = 0 -> entry, = 1 -> exit
+	 */
+	ip = regs->UCreg_ip;
+	regs->UCreg_ip = why;
+
+	current_thread_info()->syscall = scno;
+
+	/* the 0x80 provides a way for the tracing parent to distinguish
+	   between a syscall stop and SIGTRAP delivery */
+	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
+				 ? 0x80 : 0));
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+	regs->UCreg_ip = ip;
+
+	return current_thread_info()->syscall;
+}
-- 
1.6.2.2


