Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2H3VUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:20:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52409 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2H3VOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/26] x86: Use the new schedule_user API on userspace preemption
Date: Thu, 30 Aug 2012 14:05:29 -0700
Message-Id: <1346360743-3628-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-6148-0000-0000-000009175F52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

This way we can exit the RCU extended quiescent state before
we schedule a new task from irq/exception exit.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/x86/kernel/entry_64.S |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 69babd8..6230487 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -565,7 +565,7 @@ sysret_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call schedule
+	call schedule_user
 	popq_cfi %rdi
 	jmp sysret_check
 
@@ -678,7 +678,7 @@ int_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call schedule
+	call schedule_user
 	popq_cfi %rdi
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
@@ -974,7 +974,7 @@ retint_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	call  schedule
+	call  schedule_user
 	popq_cfi %rdi
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -1449,7 +1449,7 @@ paranoid_userspace:
 paranoid_schedule:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
+	call schedule_user
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	jmp paranoid_userspace
-- 
1.7.8

