Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1LTTUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:20:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1LTTT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:19:58 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=-kHMGH7muIIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=tDg02Hdxs7GPy_NaAjoA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324408795.5916.73.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/2] tracing, sched: Add a new tracepoint for sleeptime
From: Steven Rostedt <rostedt@goodmis.org>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Dec 2011 14:19:55 -0500
In-Reply-To: <4EF0D262.5000405@fb.com>
References: <1324404558-353-1-git-send-email-asharma@fb.com>
	  <1324404558-353-3-git-send-email-asharma@fb.com>
	 <1324404995.5916.66.camel@gandalf.stny.rr.com> <4EF0D262.5000405@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 10:22 -0800, Arun Sharma wrote:
> On 12/20/11 10:16 AM, Steven Rostedt wrote:
> 
> >> +#ifdef CREATE_TRACE_POINTS
> >
> > Why the #ifdef? a static inline is fine to keep in the open. If nothing
> > uses it, then it just wont be used or defined.
> >
> 
> Without the ifdef I get:
> 
> In file included from include/trace/define_trace.h:80,
>                   from include/trace/events/sched.h:445,
>                   from kernel/sched/core.c:86:
> include/trace/events/sched.h:366: error: redefinition of 
> ‘trace_get_sleeptime’
> include/trace/events/sched.h:366: note: previous definition of 
> ‘trace_get_sleeptime’ was here
> 
> So I shamelessly copied what the other static inline function in the 
> file does.

Ah, OK, it's because of the duplicate includes. Still ugly though. But
we can clean that up later.


> 
> I also noticed that sched_stat_sleeptime() is very similar to 
> sched_stat_sleep(). The latter covers sleeps but not iowait and doesn't 
> include the scheduler latency. Let me know if you think this is a show 
> stopper that needs a rename.

what about sched_stat_iowait() too. As for latency, I don't know. That's
more Peter's decision.

-- Steve


