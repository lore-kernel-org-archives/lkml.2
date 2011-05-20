Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab1ETTO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:14:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37031 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781Ab1ETTNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:13:46 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE... 
	,commit_signer:1/3=33%),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Pekka Paalanen <pq@iki.fi> (commit_signer:2/3=67%),
        "Gustavo F. Padovan" <padovan@profusion.mobi> (commit_signer:1/3=33%),
        Frederic Weisbecker <fweisbec@gmail.com> (commit_signer:1/3=33%),
        Marcin Slusarz <marcin.slusarz@gmail.com> (commit_signer:1/3=33%)
Subject: [PATCH 6/8] x86: Kill set but not used warnings in pf_in.c
Date: Fri, 20 May 2011 16:13:03 -0300
Message-Id: <1305918786-7239-6-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305918786-7239-5-git-send-email-padovan@profusion.mobi>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-4-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-5-git-send-email-padovan@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 arch/x86/mm/pf_in.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
index 38e6d17..9f0614d 100644
--- a/arch/x86/mm/pf_in.c
+++ b/arch/x86/mm/pf_in.c
@@ -414,22 +414,17 @@ unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
 	unsigned char *p;
 	struct prefix_bits prf;
 	int i;
-	unsigned long rv;
 
 	p = (unsigned char *)ins_addr;
 	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 	for (i = 0; i < ARRAY_SIZE(reg_rop); i++)
-		if (reg_rop[i] == opcode) {
-			rv = REG_READ;
+		if (reg_rop[i] == opcode)
 			goto do_work;
-		}
 
 	for (i = 0; i < ARRAY_SIZE(reg_wop); i++)
-		if (reg_wop[i] == opcode) {
-			rv = REG_WRITE;
+		if (reg_wop[i] == opcode)
 			goto do_work;
-		}
 
 	printk(KERN_ERR "mmiotrace: Not a register instruction, opcode "
 							"0x%02x\n", opcode);
@@ -474,16 +469,13 @@ unsigned long get_ins_imm_val(unsigned long ins_addr)
 	unsigned char *p;
 	struct prefix_bits prf;
 	int i;
-	unsigned long rv;
 
 	p = (unsigned char *)ins_addr;
 	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 	for (i = 0; i < ARRAY_SIZE(imm_wop); i++)
-		if (imm_wop[i] == opcode) {
-			rv = IMM_WRITE;
+		if (imm_wop[i] == opcode)
 			goto do_work;
-		}
 
 	printk(KERN_ERR "mmiotrace: Not an immediate instruction, opcode "
 							"0x%02x\n", opcode);
-- 
1.7.5.1

