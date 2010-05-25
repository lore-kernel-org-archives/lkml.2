Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0EYNbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:31:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0EYNbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:31:33 -0400
X-Authority-Analysis: v=1.1 cv=Pm0qIGCwx3bIEOZlSg1a56K3RSwKBTW9sPEb+DFvEKk= c=1 sm=0 a=2AvjukvjyTwA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=RCKV_jubbbYVyT8zMFMA:9 a=EPVnLPeplNcYJ7_Gu3zqdaiCB-MA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] tracing: Add __used annotation to event variable
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 25 May 2010 09:31:30 -0400
Message-ID: <1274794290.22648.209.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This fixes the warning/error on PowerPC.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (1):
      tracing: Add __used annotation to event variable

----
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit 49c177461bfbedeccbab22bf3905db2f9da7f1c3
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue May 25 06:19:35 2010 -0700

    tracing: Add __used annotation to event variable
    
    The TRACE_EVENT() macros automate creation of trace events. To automate
    initialization, the set up variables are loaded in a special section
    that is read on boot up. GCC is not aware that these static variables
    are used and will complain about them if we do not inform GCC that
    they are indeed used.
    
    One of the declarations of the event element was missing a __used
    annotation. This patch adds it.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0152b86..34bead7 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -68,7 +68,7 @@
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
-	static struct ftrace_event_call			\
+	static struct ftrace_event_call	__used		\
 	__attribute__((__aligned__(4))) event_##name
 
 #undef DEFINE_EVENT_PRINT


