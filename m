Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1GBQaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:30:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39758 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1GBQaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:30:00 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH 5/6] x86: Remove useless unwinder backlink from irq regs saving
Date: Sat,  2 Jul 2011 18:29:43 +0200
Message-Id: <1309624184-9790-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unwinder backlink in interrupt entry is very useless.
It's actually not part of the stack frame chain and thus is
never used.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>
---
 arch/x86/kernel/entry_64.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 20dc8e6..6131432 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -327,7 +327,6 @@ ENDPROC(native_usergs_sysret64)
 	jne 2f
 	mov PER_CPU_VAR(irq_stack_ptr),%rsp
 	EMPTY_FRAME 0
-	pushq_cfi %rbp			/* backlink for unwinder */
 	/*
 	 * We entered an interrupt context - irqs are off:
 	 */
-- 
1.7.5.4

