Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1GBQam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:30:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52746 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1GBQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:29:58 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH 4/6] x86,64: Separate arg1 from rbp handling in SAVE_REGS_IRQ
Date: Sat,  2 Jul 2011 18:29:42 +0200
Message-Id: <1309624184-9790-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for clarity in the code. Have a first block that handles
the frame pointer and a separate one that handles pt_regs
pointer and its use.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>
---
 arch/x86/kernel/entry_64.S |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b6b2e85..20dc8e6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -310,9 +310,10 @@ ENDPROC(native_usergs_sysret64)
 	movq_cfi r10, R10-RBP
 	movq_cfi r11, R11-RBP
 
-	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
 	movq_cfi rbp, 0		/* push %rbp */
 	movq %rsp, %rbp
+
+	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
 	testl $3, CS(%rdi)
 	je 1f
 	SWAPGS
-- 
1.7.5.4

