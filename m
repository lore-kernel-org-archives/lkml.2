Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab1EXSSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:18:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab1EXSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:17:24 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=ScTVB2pc0zAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Bt9n-Y5hIFqW04YhDGIA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110524181721.900585841@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 14:10:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/12] tracing: Have event with function tracer check error return
References: <20110524181032.382259739@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-Have-event-with-function-tracer-check-error-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The self tests for event tracer does not check if the function
tracing was successfully activated. It needs to before it continues
the tests, otherwise the wrong errors may be reported.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2fe1103..686ec39 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1657,7 +1657,12 @@ static struct ftrace_ops trace_ops __initdata  =
 
 static __init void event_trace_self_test_with_function(void)
 {
-	register_ftrace_function(&trace_ops);
+	int ret;
+	ret = register_ftrace_function(&trace_ops);
+	if (WARN_ON(ret < 0)) {
+		pr_info("Failed to enable function tracer for event tests\n");
+		return;
+	}
 	pr_info("Running tests again, along with the function tracer\n");
 	event_trace_self_tests();
 	unregister_ftrace_function(&trace_ops);
-- 
1.7.4.4


