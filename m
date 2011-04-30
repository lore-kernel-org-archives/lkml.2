Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1D3PcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:32:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab1D3PcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:32:13 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=vhdKIqpQuCYA:10 a=oSJyiHWPDtwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=9RuzRkLMMCLOn-ioYjwA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110430153210.291807363@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:30:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/8] ftrace: Make FTRACE_WARN_ON() work in if condition
References: <20110430153040.354378898@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Make-FTRACE_WARN_ON-work-in-if-condition.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Let FTRACE_WARN_ON() be used as a stand alone statement or
inside a conditional: if (FTRACE_WARN_ON(x))

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ee24fa1..4ff6559 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -39,16 +39,20 @@
 #include "trace_stat.h"
 
 #define FTRACE_WARN_ON(cond)			\
-	do {					\
-		if (WARN_ON(cond))		\
+	({					\
+		int ___r = cond;		\
+		if (WARN_ON(___r))		\
 			ftrace_kill();		\
-	} while (0)
+		___r;				\
+	})
 
 #define FTRACE_WARN_ON_ONCE(cond)		\
-	do {					\
-		if (WARN_ON_ONCE(cond))		\
+	({					\
+		int ___r = cond;		\
+		if (WARN_ON_ONCE(___r))		\
 			ftrace_kill();		\
-	} while (0)
+		___r;				\
+	})
 
 /* hash bits for specific function selection */
 #define FTRACE_HASH_BITS 7
-- 
1.7.2.3


