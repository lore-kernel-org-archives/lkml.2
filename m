Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab2KBWpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:45:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab2KBWpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:45:11 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BfT4GVQIg0UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uOX8jfoq8wsA:10 a=20KFwNOVAAAA:8 a=UzZgyjnE_CzGA0SsC-MA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102224509.942280970@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 18:38:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/8][RFC] ftrace: Fix function tracing recursion self test
References: <20121102223828.795874032@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Fix-function-tracing-recursion-self-test.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function tracing recursion self test should not crash
the machine if the resursion test fails. If it detects that
the function tracing is recursing when it should not be, then
bail, don't go into an infinite recursive loop.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_selftest.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 4762316..d1f98ab 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -415,7 +415,8 @@ static void trace_selftest_test_recursion_func(unsigned long ip,
 	 * The ftrace infrastructure should provide the recursion
 	 * protection. If not, this will crash the kernel!
 	 */
-	trace_selftest_recursion_cnt++;
+	if (trace_selftest_recursion_cnt++ > 10)
+		return;
 	DYN_FTRACE_TEST_NAME();
 }
 
-- 
1.7.10.4


