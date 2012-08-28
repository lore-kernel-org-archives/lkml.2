Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2H1WFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:05:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54398 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2H1WFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:05:01 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 01:04:40 +0300
Message-ID: <CANg8OWL8sBQZ-45kikoUEPniosOhay_dxOCCPBXSG+ME05aLqw@mail.gmail.com>
Subject: [PATCH 10/13] perf tools: fix non-void function without return statement
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thread_func in builtin-sched.c has an internal loop and
never returns. The only return from this thread are
BUG_ON calls in case return values are not 0.

The compiler on Android complains that the function
needs to return a non-void value. Adding the noreturn
function attribute to fix this error.

Error in Android:
target C: perf <= builtin-sched.c
hardware/intel/linu/tools/perf/builtin-sched.c: In function 'thread_func':
hardware/intel/linux/tools/perf/builtin-sched.c:476: error: no return
statement in function returning non-void

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/builtin-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 3d3cab46..da293b8 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -439,7 +439,7 @@ static u64 get_cpu_usage_nsec_self(int fd)
     return runtime;
 }

-static void *thread_func(void *ctx)
+static __attribute__ ((noreturn)) void *thread_func(void *ctx)
 {
     struct task_desc *this_task = ctx;
     u64 cpu_usage_0, cpu_usage_1;
--
1.7.9.5
