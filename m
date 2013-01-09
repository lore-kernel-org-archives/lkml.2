Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab3AIXKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:10:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31016 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab3AIXKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:10:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, rusty@rustcorp.com.au, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        jbaron@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 3/5] kprobes: constify check_kprobe_address_safe and friends
Date: Wed,  9 Jan 2013 18:09:18 -0500
Message-Id: <1357772960-4436-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
References: <1357772960-4436-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constify the parameters of lookup functions.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/kernel/kprobes-opt.c | 8 ++++----
 kernel/kprobes.c              | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kprobes-opt.c b/arch/x86/kernel/kprobes-opt.c
index c5e410e..5876966 100644
--- a/arch/x86/kernel/kprobes-opt.c
+++ b/arch/x86/kernel/kprobes-opt.c
@@ -192,7 +192,7 @@ static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
 }
 
 /* Check whether insn is indirect jump */
-static int __kprobes insn_is_indirect_jump(struct insn *insn)
+static int __kprobes insn_is_indirect_jump(const struct insn *insn)
 {
 	return ((insn->opcode.bytes[0] == 0xff &&
 		(X86_MODRM_REG(insn->modrm.value) & 6) == 4) || /* Jump */
@@ -200,7 +200,7 @@ static int __kprobes insn_is_indirect_jump(struct insn *insn)
 }
 
 /* Check whether insn jumps into specified address range */
-static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
+static int insn_jump_into_range(const struct insn *insn, unsigned long start, int len)
 {
 	unsigned long target = 0;
 
@@ -278,7 +278,7 @@ static int __kprobes can_optimize(unsigned long paddr)
 }
 
 /* Check optimized_kprobe can actually be optimized. */
-int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
+int __kprobes arch_check_optimized_kprobe(const struct optimized_kprobe *op)
 {
 	int i;
 	struct kprobe *p;
@@ -294,7 +294,7 @@ int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
 
 /* Check the addr is within the optimized instructions. */
 int __kprobes
-arch_within_optimized_kprobe(struct optimized_kprobe *op, unsigned long addr)
+arch_within_optimized_kprobe(const struct optimized_kprobe *op, unsigned long addr)
 {
 	return ((unsigned long)op->kp.addr <= addr &&
 		(unsigned long)op->kp.addr + op->optinsn.size > addr);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 098f396..7daddb0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1402,7 +1402,7 @@ static inline int check_kprobe_rereg(struct kprobe *p)
 	return ret;
 }
 
-static __kprobes int check_kprobe_address_safe(struct kprobe *p,
+static __kprobes int check_kprobe_address_safe(const struct kprobe *p,
 					       struct module **probed_mod)
 {
 	int ret = 0;
-- 
1.8.1

