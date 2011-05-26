Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab1EZPbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:31:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab1EZP37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:29:59 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=qEpSoWiKAZwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=dvi0TOhA59JgNhE5Rl8A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110526152958.050779429@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 11:25:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/12] ftrace: Set ops->flag to enabled even on static function tracing
References: <20110526152541.995963172@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-Set-ops-flag-to-enabled-even-on-static-functi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When dynamic ftrace is not configured, the ops->flags still needs
to have its FTRACE_OPS_FL_ENABLED bit set in ftrace_startup().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index bebbc95..25949b3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3468,7 +3468,11 @@ device_initcall(ftrace_nodyn_init);
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
 /* Keep as macros so we do not need to define the commands */
-# define ftrace_startup(ops, command)	({0;})
+# define ftrace_startup(ops, command)			\
+	({						\
+		(ops)->flags |= FTRACE_OPS_FL_ENABLED;	\
+		0;					\
+	})
 # define ftrace_shutdown(ops, command)	do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
-- 
1.7.4.4


