Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030296Ab2EPNog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:44:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13223 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab2EPNoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:44:32 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=NRStNP9rnvMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_29K2rxri5JJTCjIUycA:9 a=gx_9CJTqFcD1WgcztsAA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=XvyPQ2VBjatiNL0O:21 a=uOF3JSrUyJ5lcKgg:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337175871.6724.46.camel@gandalf.stny.rr.com>
Subject: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from every
 event
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 May 2012 09:44:31 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that PowerTop v2 is out, which uses the parse-event library, it no
longer is broken by the removal of the lock-depth field from every
event. Currently we add 4 bytes of empty space to every event. If we
have 1 million events, 4 million bytes are wasted in the ring buffers
(for both ftrace and perf).

But this change will break PowerTop v1. Thus my question is, how long do
we need to keep this wasted space in the ring buffers to satisfy an out
of date tool?

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5f3f3be..f96dfef 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -49,7 +49,6 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			padding;
 };
 
 #define FTRACE_MAX_EVENT						\


