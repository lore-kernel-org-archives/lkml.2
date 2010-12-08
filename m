Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0LHG43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 01:56:29 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34246 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab0LHG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 01:56:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/4] tracing: Add TRACE_EVENT_CONDITIONAL()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101204023141.552849493@goodmis.org>
References: <20101204021744.521599148@goodmis.org> <20101204023141.552849493@goodmis.org>
Message-Id: <20101208155703.173C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  8 Dec 2010 15:56:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Steven Rostedt <srostedt@redhat.com>
> 
> There are instances in the kernel that we only want to trace
> a tracepoint when a certain condition is set. But we do not
> want to test for that condition in the core kernel.
> If we test for that condition before calling the tracepoin, then
> we will be performing that test even when tracing is not enabled.
> This is 99.99% of the time.
> 
> We currently can just filter out on that condition, but that happens
> after we write to the trace buffer. We just wasted time writing to
> the ring buffer for an event we never cared about.
> 
> This patch adds:
> 
>    TRACE_EVENT_CONDITION() and DEFINE_EVENT_CONDITION()
> 
> These have a new TP_CONDITION() argument that comes right after
> the TP_ARGS().  This condition can use the parameters of TP_ARGS()
> in the TRACE_EVENT() to determine if the tracepoint should be traced
> or not. The TP_CONDITION() will be placed in a if (cond) trace;
> 
> For example, for the tracepoint sched_wakeup, it is useless to
> trace a wakeup event where the caller never actually wakes
> anything up (where success == 0). So adding:
> 
> 	TP_CONDITION(success),
> 
> which uses the "success" parameter of the wakeup tracepoint
> will have it only trace when we have successfully woken up a
> task.
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Arjan van de Ven <arjan@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

I love this patch. thanks, Steven :)



