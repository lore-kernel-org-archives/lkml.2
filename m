Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab0GZF4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 01:56:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33538 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0GZFz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 01:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VwU856WfObLbadUadw3bmmOGAGx+RJT5JsFz4/paJbJV9Q4wIY3L4YEqlZ+HRpc145
         WpMY1F7LZxOnJu2IB1G1o4j/X99k7d6zqYSUDq+EImWs7fegioNZPeCQR6SrZM8/oNoe
         aQrhcA55leBdm28u9twxCK3E8dETdfNs0n03g=
From: Michael Jensen <emjay1988@gmail.com>
To: avi@redhat.com
Cc: mtosatti@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, Michael Jensen <emjay1988@gmail.com>
Subject: [PATCH 1/2] x86: kvm: emulate.c: Fixed up all code-style ERRORs
Date: Mon, 26 Jul 2010 15:55:24 +1000
Message-Id: <1280123724-23226-1-git-send-email-emjay1988@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrapped lines and fixed indentation throughout emulate.c, now
passes checkpatch.pl with no ERRORs.

Signed-off-by: Michael Jensen <emjay1988@gmail.com>
---
 arch/x86/kvm/emulate.c |   66 +++++++++++++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5ac0bb4..2562ed8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -457,29 +457,35 @@ static u32 group2_table[] = {
 
 
 /* Raw emulation: instruction has two explicit operands. */
-#define __emulate_2op_nobyte(_op,_src,_dst,_eflags,_wx,_wy,_lx,_ly,_qx,_qy) \
+#define __emulate_2op_nobyte(_op, _src, _dst, _eflags,			\
+			     _wx, _wy, _lx, _ly, _qx, _qy)		\
 	do {								\
 		unsigned long _tmp;					\
 									\
 		switch ((_dst).bytes) {					\
 		case 2:							\
-			____emulate_2op(_op,_src,_dst,_eflags,_wx,_wy,"w"); \
+			____emulate_2op(_op, _src, _dst,		\
+					_eflags, _wx, _wy, "w");	\
 			break;						\
 		case 4:							\
-			____emulate_2op(_op,_src,_dst,_eflags,_lx,_ly,"l"); \
+			____emulate_2op(_op, _src, _dst,		\
+					_eflags, _lx, _ly, "l");	\
 			break;						\
 		case 8:							\
-			ON64(____emulate_2op(_op,_src,_dst,_eflags,_qx,_qy,"q")); \
+			ON64(____emulate_2op(_op, _src, _dst,		\
+					     _eflags, _qx, _qy, "q"));	\
 			break;						\
 		}							\
 	} while (0)
 
-#define __emulate_2op(_op,_src,_dst,_eflags,_bx,_by,_wx,_wy,_lx,_ly,_qx,_qy) \
+#define __emulate_2op(_op, _src, _dst, _eflags,				     \
+		      _bx, _by, _wx, _wy, _lx, _ly, _qx, _qy)		     \
 	do {								     \
 		unsigned long _tmp;					     \
 		switch ((_dst).bytes) {				             \
 		case 1:							     \
-			____emulate_2op(_op,_src,_dst,_eflags,_bx,_by,"b");  \
+			____emulate_2op(_op, _src, _dst,		     \
+					_eflags, _bx, _by, "b");	     \
 			break;						     \
 		default:						     \
 			__emulate_2op_nobyte(_op, _src, _dst, _eflags,	     \
@@ -556,13 +562,21 @@ static u32 group2_table[] = {
 	} while (0)
 
 /* Instruction has only one explicit operand (no source operand). */
-#define emulate_1op(_op, _dst, _eflags)                                    \
+#define emulate_1op(_op, _dst, _eflags)                                 \
 	do {								\
 		switch ((_dst).bytes) {				        \
-		case 1:	__emulate_1op(_op, _dst, _eflags, "b"); break;	\
-		case 2:	__emulate_1op(_op, _dst, _eflags, "w"); break;	\
-		case 4:	__emulate_1op(_op, _dst, _eflags, "l"); break;	\
-		case 8:	ON64(__emulate_1op(_op, _dst, _eflags, "q")); break; \
+		case 1:							\
+			__emulate_1op(_op, _dst, _eflags, "b");		\
+			break;						\
+		case 2:							\
+			__emulate_1op(_op, _dst, _eflags, "w");		\
+			break;						\
+		case 4:							\
+			__emulate_1op(_op, _dst, _eflags, "l");		\
+			break;						\
+		case 8:							\
+			ON64(__emulate_1op(_op, _dst, _eflags, "q"));	\
+			break;						\
 		}							\
 	} while (0)
 
@@ -749,7 +763,7 @@ static int test_cc(unsigned int condition, unsigned int flags)
 	}
 
 	/* Odd condition identifiers (lsb == 1) have inverted sense. */
-	return (!!rc ^ (condition & 1));
+	return !!rc ^ (condition & 1);
 }
 
 static void decode_register_operand(struct operand *op,
@@ -1234,18 +1248,18 @@ done_prefixes:
 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
 		c->dst.ptr = &c->regs[VCPU_REGS_RAX];
 		switch (c->dst.bytes) {
-			case 1:
-				c->dst.val = *(u8 *)c->dst.ptr;
-				break;
-			case 2:
-				c->dst.val = *(u16 *)c->dst.ptr;
-				break;
-			case 4:
-				c->dst.val = *(u32 *)c->dst.ptr;
-				break;
-			case 8:
-				c->dst.val = *(u64 *)c->dst.ptr;
-				break;
+		case 1:
+			c->dst.val = *(u8 *)c->dst.ptr;
+			break;
+		case 2:
+			c->dst.val = *(u16 *)c->dst.ptr;
+			break;
+		case 4:
+			c->dst.val = *(u32 *)c->dst.ptr;
+			break;
+		case 8:
+			c->dst.val = *(u64 *)c->dst.ptr;
+			break;
 		}
 		c->dst.orig_val = c->dst.val;
 		break;
@@ -1306,7 +1320,7 @@ static void get_descriptor_table_ptr(struct x86_emulate_ctxt *ctxt,
 {
 	if (selector & 1 << 2) {
 		struct desc_struct desc;
-		memset (dt, 0, sizeof *dt);
+		memset(dt, 0, sizeof *dt);
 		if (!ops->get_cached_descriptor(&desc, VCPU_SREG_LDTR, ctxt->vcpu))
 			return;
 
@@ -1530,7 +1544,7 @@ static int emulate_popf(struct x86_emulate_ctxt *ctxt,
 	change_mask = EFLG_CF | EFLG_PF | EFLG_AF | EFLG_ZF | EFLG_SF | EFLG_OF
 		| EFLG_TF | EFLG_DF | EFLG_NT | EFLG_RF | EFLG_AC | EFLG_ID;
 
-	switch(ctxt->mode) {
+	switch (ctxt->mode) {
 	case X86EMUL_MODE_PROT64:
 	case X86EMUL_MODE_PROT32:
 	case X86EMUL_MODE_PROT16:
-- 
1.7.0.4

