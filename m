Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1CJP7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:59:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab1CJP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:14 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=K9ZRnwLxKhgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=A_1-25FYo7uxwaDcdhUA:9 a=aZEHNfzcP2qKNQQW2iXRql2xVV4A:4 a=DHQQ7jDAcw4A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155912.280799175@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 13/15] tracing: Export trace_set_clr_event()
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-Export-trace_set_clr_event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuanhan Liu <yuanhan.liu@linux.intel.com>

Trace events belonging to a module only exists when the module is
loaded. Well, we can use trace_set_clr_event funtion to enable some
trace event at the module init routine, so that we will not miss
something while loading then module.

So, Export the trace_set_clr_event function so that module can use it.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
LKML-Reference: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e1d579b..e88f74f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -325,6 +325,7 @@ int trace_set_clr_event(const char *system, const char *event, int set)
 {
 	return __ftrace_set_clr_event(NULL, system, event, set);
 }
+EXPORT_SYMBOL_GPL(trace_set_clr_event);
 
 /* 128 should be much more than enough */
 #define EVENT_BUF_SIZE		127
-- 
1.7.2.3


