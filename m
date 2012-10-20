Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2JTQXD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:23:03 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36853 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2JTQW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:22:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 3/8] x86: Implement arch_irq_work_has_ipi()
Date: Sat, 20 Oct 2012 12:22:42 -0400
Message-Id: <1350750167-14263-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the time, x86 can trigger self-IPIs. Tell
irq work subsystem about it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/irq_work.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq_work.h b/arch/x86/include/asm/irq_work.h
index dad8266..c7489cd 100644
--- a/arch/x86/include/asm/irq_work.h
+++ b/arch/x86/include/asm/irq_work.h
@@ -2,8 +2,12 @@
 #define _ASM_X86_IRQ_WORK_H
 
 #ifdef CONFIG_X86_LOCAL_APIC
+#include <asm/cpufeature.h>
+
 extern void __arch_irq_work_raise(void);
 #define arch_irq_work_raise __arch_irq_work_raise
+
+#define arch_irq_work_has_ipi() (cpu_has_apic)
 #endif
 
 #include <asm-generic/irq_work.h>
-- 
1.7.5.4

