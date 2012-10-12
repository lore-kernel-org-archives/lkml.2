Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074Ab2JLSJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:09:52 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760046Ab2JLSJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:09:48 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH 3/5] x86: Implement arch_irq_work_use_tick
Date: Fri, 12 Oct 2012 20:09:34 +0200
Message-Id: <1350065376-23353-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
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
---
 arch/x86/include/asm/irq_work.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq_work.h b/arch/x86/include/asm/irq_work.h
index dad8266..fc62b60 100644
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
+#define arch_irq_work_use_tick() (!cpu_has_apic)
 #endif
 
 #include <asm-generic/irq_work.h>
-- 
1.7.5.4

