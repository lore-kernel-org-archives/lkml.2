Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2J2N2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:28:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42297 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab2J2N2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:28:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 5/9] x86: Implement arch_irq_work_has_ipi()
Date: Mon, 29 Oct 2012 14:28:12 +0100
Message-Id: <1351517296-9173-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
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

