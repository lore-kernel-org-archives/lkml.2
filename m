Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0EGDJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 23:09:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33330 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab0EGDJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 23:09:30 -0400
X-Authority-Analysis: v=1.1 cv=GuuPm/R9MDBdMhOgsQZYzj+bBK5woo0X8cuc0sTVRtI= c=1 sm=0 a=9e0D-j7WXTsA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=E0p0_C1TF2Q-2w1mLXAA:9 a=S0-a06dq1Anix2E9jXu30_huvWYA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] perf: Fix check at end of event search
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 06 May 2010 23:09:27 -0400
Message-ID: <1273201767.22438.73.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I just notice that I had this patch laying around and never pushed it
out. I first had it in my ftrace branches but then realized that it was
a perf change. I moved it there, but got distracted and unfortunately,
forgot about it. I rebased it to the latest tip/perf/core.

The change is within a #ifdef CONFIG_PERF_EVENTS

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Dan Carpenter (1):
      perf: Fix check at end of event search

----
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit d9f599e1e6d019968b35d2dc63074b9e8964fa69
Author: Dan Carpenter <error27@gmail.com>
Date:   Sat Mar 20 17:39:11 2010 +0300

    perf: Fix check at end of event search
    
    The original code doesn't work because "call" is never NULL there.
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    LKML-Reference: <20100320143911.GF5331@bicker>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 88c0b6d..58092d8 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1398,7 +1398,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	}
 
 	err = -EINVAL;
-	if (!call)
+	if (&call->list == &ftrace_events)
 		goto out_unlock;
 
 	err = -EEXIST;


