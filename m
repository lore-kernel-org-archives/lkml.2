Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2H2XcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:32:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35263 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2H2Xbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:31:35 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 3/8] KVM: x86: mark opcode tables const
Date: Thu, 30 Aug 2012 01:30:15 +0200
Message-Id: <1346283020-22385-4-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The opcode tables never change at runtime, therefor mark them const.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kvm/emulate.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5a0fee1..fd06f9d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -161,9 +161,9 @@ struct opcode {
 	u64 intercept : 8;
 	union {
 		int (*execute)(struct x86_emulate_ctxt *ctxt);
-		struct opcode *group;
-		struct group_dual *gdual;
-		struct gprefix *gprefix;
+		const struct opcode *group;
+		const struct group_dual *gdual;
+		const struct gprefix *gprefix;
 	} u;
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
 };
@@ -3574,13 +3574,13 @@ static int check_perm_out(struct x86_emulate_ctxt *ctxt)
 		I2bv(((_f) | DstReg | SrcMem | ModRM) & ~Lock, _e),	\
 		I2bv(((_f) & ~Lock) | DstAcc | SrcImm, _e)
 
-static struct opcode group7_rm1[] = {
+static const struct opcode group7_rm1[] = {
 	DI(SrcNone | Priv, monitor),
 	DI(SrcNone | Priv, mwait),
 	N, N, N, N, N, N,
 };
 
-static struct opcode group7_rm3[] = {
+static const struct opcode group7_rm3[] = {
 	DIP(SrcNone | Prot | Priv,		vmrun,		check_svme_pa),
 	II(SrcNone  | Prot | VendorSpecific,	em_vmmcall,	vmmcall),
 	DIP(SrcNone | Prot | Priv,		vmload,		check_svme_pa),
@@ -3591,13 +3591,13 @@ static struct opcode group7_rm3[] = {
 	DIP(SrcNone | Prot | Priv,		invlpga,	check_svme),
 };
 
-static struct opcode group7_rm7[] = {
+static const struct opcode group7_rm7[] = {
 	N,
 	DIP(SrcNone, rdtscp, check_rdtsc),
 	N, N, N, N, N, N,
 };
 
-static struct opcode group1[] = {
+static const struct opcode group1[] = {
 	I(Lock, em_add),
 	I(Lock | PageTable, em_or),
 	I(Lock, em_adc),
@@ -3608,11 +3608,11 @@ static struct opcode group1[] = {
 	I(0, em_cmp),
 };
 
-static struct opcode group1A[] = {
+static const struct opcode group1A[] = {
 	I(DstMem | SrcNone | Mov | Stack, em_pop), N, N, N, N, N, N, N,
 };
 
-static struct opcode group3[] = {
+static const struct opcode group3[] = {
 	I(DstMem | SrcImm, em_test),
 	I(DstMem | SrcImm, em_test),
 	I(DstMem | SrcNone | Lock, em_not),
@@ -3623,13 +3623,13 @@ static struct opcode group3[] = {
 	I(SrcMem, em_idiv_ex),
 };
 
-static struct opcode group4[] = {
+static const struct opcode group4[] = {
 	I(ByteOp | DstMem | SrcNone | Lock, em_grp45),
 	I(ByteOp | DstMem | SrcNone | Lock, em_grp45),
 	N, N, N, N, N, N,
 };
 
-static struct opcode group5[] = {
+static const struct opcode group5[] = {
 	I(DstMem | SrcNone | Lock,		em_grp45),
 	I(DstMem | SrcNone | Lock,		em_grp45),
 	I(SrcMem | Stack,			em_grp45),
@@ -3639,7 +3639,7 @@ static struct opcode group5[] = {
 	I(SrcMem | Stack,			em_grp45), N,
 };
 
-static struct opcode group6[] = {
+static const struct opcode group6[] = {
 	DI(Prot,	sldt),
 	DI(Prot,	str),
 	II(Prot | Priv | SrcMem16, em_lldt, lldt),
@@ -3647,7 +3647,7 @@ static struct opcode group6[] = {
 	N, N, N, N,
 };
 
-static struct group_dual group7 = { {
+static const struct group_dual group7 = { {
 	II(Mov | DstMem | Priv,			em_sgdt, sgdt),
 	II(Mov | DstMem | Priv,			em_sidt, sidt),
 	II(SrcMem | Priv,			em_lgdt, lgdt),
@@ -3664,7 +3664,7 @@ static struct group_dual group7 = { {
 	EXT(0, group7_rm7),
 } };
 
-static struct opcode group8[] = {
+static const struct opcode group8[] = {
 	N, N, N, N,
 	I(DstMem | SrcImmByte,				em_bt),
 	I(DstMem | SrcImmByte | Lock | PageTable,	em_bts),
@@ -3672,26 +3672,26 @@ static struct opcode group8[] = {
 	I(DstMem | SrcImmByte | Lock | PageTable,	em_btc),
 };
 
-static struct group_dual group9 = { {
+static const struct group_dual group9 = { {
 	N, I(DstMem64 | Lock | PageTable, em_cmpxchg8b), N, N, N, N, N, N,
 }, {
 	N, N, N, N, N, N, N, N,
 } };
 
-static struct opcode group11[] = {
+static const struct opcode group11[] = {
 	I(DstMem | SrcImm | Mov | PageTable, em_mov),
 	X7(D(Undefined)),
 };
 
-static struct gprefix pfx_0f_6f_0f_7f = {
+static const struct gprefix pfx_0f_6f_0f_7f = {
 	I(Mmx, em_mov), I(Sse | Aligned, em_mov), N, I(Sse | Unaligned, em_mov),
 };
 
-static struct gprefix pfx_vmovntpx = {
+static const struct gprefix pfx_vmovntpx = {
 	I(0, em_mov), N, N, N,
 };
 
-static struct opcode opcode_table[256] = {
+static const struct opcode opcode_table[256] = {
 	/* 0x00 - 0x07 */
 	I6ALU(Lock, em_add),
 	I(ImplicitOps | Stack | No64 | Src2ES, em_push_sreg),
@@ -3808,7 +3808,7 @@ static struct opcode opcode_table[256] = {
 	D(ImplicitOps), D(ImplicitOps), G(0, group4), G(0, group5),
 };
 
-static struct opcode twobyte_table[256] = {
+static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
 	N, I(ImplicitOps | VendorSpecific, em_syscall),
-- 
1.7.10.4

