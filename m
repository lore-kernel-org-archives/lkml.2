Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2KBWqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:46:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab2KBWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:45:13 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pjrLXQYRMJEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=9bpXDdg-t38A:10 a=20KFwNOVAAAA:8 a=hMWwCaFSMhjnoNobKxUA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102224510.396218176@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 18:38:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/8][RFC] tracing: Make the trace recursion bits into enums
References: <20121102223828.795874032@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Make-the-trace-recursion-bits-into-enums.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Convert the bits into enums which makes the code a little easier
to maintain.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 15717a0..7e325b6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -298,15 +298,18 @@ struct tracer {
 #define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
 
 /* for function tracing recursion */
-#define TRACE_INTERNAL_BIT		(1<<11)
-#define TRACE_INTERNAL_NMI_BIT		(1<<12)
-#define TRACE_INTERNAL_IRQ_BIT		(1<<13)
-#define TRACE_INTERNAL_SIRQ_BIT		(1<<14)
-#define TRACE_GLOBAL_BIT		(1<<15)
-#define TRACE_GLOBAL_NMI_BIT		(1<<16)
-#define TRACE_GLOBAL_IRQ_BIT		(1<<17)
-#define TRACE_GLOBAL_SIRQ_BIT		(1<<18)
-#define TRACE_CONTROL_BIT		(1<<19)
+enum {
+	TRACE_INTERNAL_BIT = 11,
+	TRACE_INTERNAL_NMI_BIT,
+	TRACE_INTERNAL_IRQ_BIT,
+	TRACE_INTERNAL_SIRQ_BIT,
+
+	TRACE_GLOBAL_BIT,
+	TRACE_GLOBAL_NMI_BIT,
+	TRACE_GLOBAL_IRQ_BIT,
+	TRACE_GLOBAL_SIRQ_BIT,
+
+	TRACE_CONTROL_BIT,
 
 /*
  * Abuse of the trace_recursion.
@@ -315,11 +318,12 @@ struct tracer {
  * was called in irq context but we have irq tracing off. Since this
  * can only be modified by current, we can reuse trace_recursion.
  */
-#define TRACE_IRQ_BIT			(1<<20)
+	TRACE_IRQ_BIT,
+};
 
-#define trace_recursion_set(bit)	do { (current)->trace_recursion |= (bit); } while (0)
-#define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(bit); } while (0)
-#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
+#define trace_recursion_set(bit)	do { (current)->trace_recursion |= (1<<(bit)); } while (0)
+#define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(1<<(bit)); } while (0)
+#define trace_recursion_test(bit)	((current)->trace_recursion & (1<<(bit)))
 
 #define TRACE_PIPE_ALL_CPU	-1
 
-- 
1.7.10.4


