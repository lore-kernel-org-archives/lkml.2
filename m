Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2H2Xc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:32:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62670 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab2H2Xbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:31:37 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 4/8] KVM: x86: constify emulate_ops
Date: Thu, 30 Aug 2012 01:30:16 +0200
Message-Id: <1346283020-22385-5-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never change emulate_ops[] at runtime so it should be r/o.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/include/asm/kvm_emulate.h |    2 +-
 arch/x86/kvm/emulate.c             |   22 +++++++++++-----------
 arch/x86/kvm/x86.c                 |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 282aee5..b5bb73a 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -250,7 +250,7 @@ struct read_cache {
 };
 
 struct x86_emulate_ctxt {
-	struct x86_emulate_ops *ops;
+	const struct x86_emulate_ops *ops;
 
 	/* Register state before/after emulation. */
 	unsigned long eflags;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index fd06f9d..663e958 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1325,7 +1325,7 @@ static int read_interrupt_descriptor(struct x86_emulate_ctxt *ctxt,
 static void get_descriptor_table_ptr(struct x86_emulate_ctxt *ctxt,
 				     u16 selector, struct desc_ptr *dt)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 
 	if (selector & 1 << 2) {
 		struct desc_struct desc;
@@ -1747,7 +1747,7 @@ static int em_popa(struct x86_emulate_ctxt *ctxt)
 
 static int __emulate_int_real(struct x86_emulate_ctxt *ctxt, int irq)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	int rc;
 	struct desc_ptr dt;
 	gva_t cs_addr;
@@ -2129,7 +2129,7 @@ static bool vendor_intel(struct x86_emulate_ctxt *ctxt)
 
 static bool em_syscall_is_enabled(struct x86_emulate_ctxt *ctxt)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	u32 eax, ebx, ecx, edx;
 
 	/*
@@ -2173,7 +2173,7 @@ static bool em_syscall_is_enabled(struct x86_emulate_ctxt *ctxt)
 
 static int em_syscall(struct x86_emulate_ctxt *ctxt)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	struct desc_struct cs, ss;
 	u64 msr_data;
 	u16 cs_sel, ss_sel;
@@ -2231,7 +2231,7 @@ static int em_syscall(struct x86_emulate_ctxt *ctxt)
 
 static int em_sysenter(struct x86_emulate_ctxt *ctxt)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	struct desc_struct cs, ss;
 	u64 msr_data;
 	u16 cs_sel, ss_sel;
@@ -2294,7 +2294,7 @@ static int em_sysenter(struct x86_emulate_ctxt *ctxt)
 
 static int em_sysexit(struct x86_emulate_ctxt *ctxt)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	struct desc_struct cs, ss;
 	u64 msr_data;
 	int usermode;
@@ -2357,7 +2357,7 @@ static bool emulator_bad_iopl(struct x86_emulate_ctxt *ctxt)
 static bool emulator_io_port_access_allowed(struct x86_emulate_ctxt *ctxt,
 					    u16 port, u16 len)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	struct desc_struct tr_seg;
 	u32 base3;
 	int r;
@@ -2476,7 +2476,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 			  u16 tss_selector, u16 old_tss_sel,
 			  ulong old_tss_base, struct desc_struct *new_desc)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	struct tss_segment_16 tss_seg;
 	int ret;
 	u32 new_tss_base = get_desc_base(new_desc);
@@ -2623,7 +2623,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 			  u16 tss_selector, u16 old_tss_sel,
 			  ulong old_tss_base, struct desc_struct *new_desc)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	struct tss_segment_32 tss_seg;
 	int ret;
 	u32 new_tss_base = get_desc_base(new_desc);
@@ -2667,7 +2667,7 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
 				   u16 tss_selector, int idt_index, int reason,
 				   bool has_error_code, u32 error_code)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	struct desc_struct curr_tss_desc, next_tss_desc;
 	int ret;
 	u16 old_tss_sel = get_segment_selector(ctxt, VCPU_SREG_TR);
@@ -4339,7 +4339,7 @@ static void fetch_possible_mmx_operand(struct x86_emulate_ctxt *ctxt,
 
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 {
-	struct x86_emulate_ops *ops = ctxt->ops;
+	const struct x86_emulate_ops *ops = ctxt->ops;
 	int rc = X86EMUL_CONTINUE;
 	int saved_dst_type = ctxt->dst.type;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e00050c..f8b0148 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4323,7 +4323,7 @@ static void emulator_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg, ulon
 	kvm_register_write(emul_to_vcpu(ctxt), reg, val);
 }
 
-static struct x86_emulate_ops emulate_ops = {
+static const struct x86_emulate_ops emulate_ops = {
 	.read_gpr            = emulator_read_gpr,
 	.write_gpr           = emulator_write_gpr,
 	.read_std            = kvm_read_guest_virt_system,
-- 
1.7.10.4

