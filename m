Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041Ab2IHArA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:47:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64377 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759830Ab2IHAqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:46:54 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 08/12] perf tools: fix no return in non-void function
Date: Sat,  8 Sep 2012 03:43:20 +0300
Message-Id: <1347065004-15306-9-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

thread_func in builtin-sched.c has an internal loop and never returns.
The only return from this thread are BUG_ON calls in case return values
are not 0.

The compiler on Android complains that the function needs to return a
non-void value. Adding the noreturn function attribute to fix this error.

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
index a25a023..1fecc95 100644
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

