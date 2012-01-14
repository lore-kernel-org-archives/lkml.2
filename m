Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2ANSef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 13:34:35 -0500
Received: from mailgw12.technion.ac.il ([132.68.225.12]:48031 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab2ANSee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 13:34:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAK/JEU+ERM5e/2dsb2JhbABCrTaBBYIgUoECPBO9d4wXBKAMh0g
X-IronPort-AV: E=Sophos;i="4.71,510,1320616800"; 
   d="scan'208";a="74537795"
From: Nadav Amit <namit@cs.technion.ac.il>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH] KVM: Fix MOVSX emulation
Date: Sat, 14 Jan 2012 20:34:08 +0200
Message-Id: <1326566048-6756-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The destination register of MOVSX should be decoded similarily to MOVZX.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 arch/x86/kvm/emulate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 05a562b..7644a83 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3553,7 +3553,8 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 	case OpReg:
 		decode_register_operand(ctxt, op,
 			 op == &ctxt->dst &&
-			 ctxt->twobyte && (ctxt->b == 0xb6 || ctxt->b == 0xb7));
+			 ctxt->twobyte && ((ctxt->b & 0xfe) == 0xb6 ||
+				(ctxt->b & 0xfe) == 0xbe));
 		break;
 	case OpImmUByte:
 		rc = decode_imm(ctxt, op, 1, false);
-- 
1.7.4.1

