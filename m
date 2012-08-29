Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab2H2XcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:32:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62670 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab2H2Xbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:31:34 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/8] KVM: x86 emulator: use aligned variants of SSE register ops
Date: Thu, 30 Aug 2012 01:30:14 +0200
Message-Id: <1346283020-22385-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the the compiler ensures that the memory operand is always aligned
to a 16 byte memory location, use the aligned variant of MOVDQ for
read_sse_reg() and write_sse_reg().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kvm/emulate.c |   64 ++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1451cff..5a0fee1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -909,23 +909,23 @@ static void read_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data, int reg)
 {
 	ctxt->ops->get_fpu(ctxt);
 	switch (reg) {
-	case 0: asm("movdqu %%xmm0, %0" : "=m"(*data)); break;
-	case 1: asm("movdqu %%xmm1, %0" : "=m"(*data)); break;
-	case 2: asm("movdqu %%xmm2, %0" : "=m"(*data)); break;
-	case 3: asm("movdqu %%xmm3, %0" : "=m"(*data)); break;
-	case 4: asm("movdqu %%xmm4, %0" : "=m"(*data)); break;
-	case 5: asm("movdqu %%xmm5, %0" : "=m"(*data)); break;
-	case 6: asm("movdqu %%xmm6, %0" : "=m"(*data)); break;
-	case 7: asm("movdqu %%xmm7, %0" : "=m"(*data)); break;
+	case 0: asm("movdqa %%xmm0, %0" : "=m"(*data)); break;
+	case 1: asm("movdqa %%xmm1, %0" : "=m"(*data)); break;
+	case 2: asm("movdqa %%xmm2, %0" : "=m"(*data)); break;
+	case 3: asm("movdqa %%xmm3, %0" : "=m"(*data)); break;
+	case 4: asm("movdqa %%xmm4, %0" : "=m"(*data)); break;
+	case 5: asm("movdqa %%xmm5, %0" : "=m"(*data)); break;
+	case 6: asm("movdqa %%xmm6, %0" : "=m"(*data)); break;
+	case 7: asm("movdqa %%xmm7, %0" : "=m"(*data)); break;
 #ifdef CONFIG_X86_64
-	case 8: asm("movdqu %%xmm8, %0" : "=m"(*data)); break;
-	case 9: asm("movdqu %%xmm9, %0" : "=m"(*data)); break;
-	case 10: asm("movdqu %%xmm10, %0" : "=m"(*data)); break;
-	case 11: asm("movdqu %%xmm11, %0" : "=m"(*data)); break;
-	case 12: asm("movdqu %%xmm12, %0" : "=m"(*data)); break;
-	case 13: asm("movdqu %%xmm13, %0" : "=m"(*data)); break;
-	case 14: asm("movdqu %%xmm14, %0" : "=m"(*data)); break;
-	case 15: asm("movdqu %%xmm15, %0" : "=m"(*data)); break;
+	case 8: asm("movdqa %%xmm8, %0" : "=m"(*data)); break;
+	case 9: asm("movdqa %%xmm9, %0" : "=m"(*data)); break;
+	case 10: asm("movdqa %%xmm10, %0" : "=m"(*data)); break;
+	case 11: asm("movdqa %%xmm11, %0" : "=m"(*data)); break;
+	case 12: asm("movdqa %%xmm12, %0" : "=m"(*data)); break;
+	case 13: asm("movdqa %%xmm13, %0" : "=m"(*data)); break;
+	case 14: asm("movdqa %%xmm14, %0" : "=m"(*data)); break;
+	case 15: asm("movdqa %%xmm15, %0" : "=m"(*data)); break;
 #endif
 	default: BUG();
 	}
@@ -937,23 +937,23 @@ static void write_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data,
 {
 	ctxt->ops->get_fpu(ctxt);
 	switch (reg) {
-	case 0: asm("movdqu %0, %%xmm0" : : "m"(*data)); break;
-	case 1: asm("movdqu %0, %%xmm1" : : "m"(*data)); break;
-	case 2: asm("movdqu %0, %%xmm2" : : "m"(*data)); break;
-	case 3: asm("movdqu %0, %%xmm3" : : "m"(*data)); break;
-	case 4: asm("movdqu %0, %%xmm4" : : "m"(*data)); break;
-	case 5: asm("movdqu %0, %%xmm5" : : "m"(*data)); break;
-	case 6: asm("movdqu %0, %%xmm6" : : "m"(*data)); break;
-	case 7: asm("movdqu %0, %%xmm7" : : "m"(*data)); break;
+	case 0: asm("movdqa %0, %%xmm0" : : "m"(*data)); break;
+	case 1: asm("movdqa %0, %%xmm1" : : "m"(*data)); break;
+	case 2: asm("movdqa %0, %%xmm2" : : "m"(*data)); break;
+	case 3: asm("movdqa %0, %%xmm3" : : "m"(*data)); break;
+	case 4: asm("movdqa %0, %%xmm4" : : "m"(*data)); break;
+	case 5: asm("movdqa %0, %%xmm5" : : "m"(*data)); break;
+	case 6: asm("movdqa %0, %%xmm6" : : "m"(*data)); break;
+	case 7: asm("movdqa %0, %%xmm7" : : "m"(*data)); break;
 #ifdef CONFIG_X86_64
-	case 8: asm("movdqu %0, %%xmm8" : : "m"(*data)); break;
-	case 9: asm("movdqu %0, %%xmm9" : : "m"(*data)); break;
-	case 10: asm("movdqu %0, %%xmm10" : : "m"(*data)); break;
-	case 11: asm("movdqu %0, %%xmm11" : : "m"(*data)); break;
-	case 12: asm("movdqu %0, %%xmm12" : : "m"(*data)); break;
-	case 13: asm("movdqu %0, %%xmm13" : : "m"(*data)); break;
-	case 14: asm("movdqu %0, %%xmm14" : : "m"(*data)); break;
-	case 15: asm("movdqu %0, %%xmm15" : : "m"(*data)); break;
+	case 8: asm("movdqa %0, %%xmm8" : : "m"(*data)); break;
+	case 9: asm("movdqa %0, %%xmm9" : : "m"(*data)); break;
+	case 10: asm("movdqa %0, %%xmm10" : : "m"(*data)); break;
+	case 11: asm("movdqa %0, %%xmm11" : : "m"(*data)); break;
+	case 12: asm("movdqa %0, %%xmm12" : : "m"(*data)); break;
+	case 13: asm("movdqa %0, %%xmm13" : : "m"(*data)); break;
+	case 14: asm("movdqa %0, %%xmm14" : : "m"(*data)); break;
+	case 15: asm("movdqa %0, %%xmm15" : : "m"(*data)); break;
 #endif
 	default: BUG();
 	}
-- 
1.7.10.4

