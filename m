Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0KPWAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:00:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44163 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab0KPWAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:00:18 -0500
Date: Tue, 16 Nov 2010 22:59:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101116215940.GA13912@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE2F747.4060406@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE2F747.4060406@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darren Hart <dvhart@linux.intel.com> wrote:

> On 11/16/2010 01:04 PM, Thomas Gleixner wrote:
> >We are pleased to announce a new tracing tool called 'trace'.
> >
> 
> Hi Thomas, Ingo - Congrats and Thanks!

You are welcome :)

> > At this point we'd like to ask for feedback from other users of tracing tools, 
> > which workflow components would you like to see in addition to what the 'trace' 
> > tool is offering?
> >
> > Comments, bug reports, suggestions welcome,
> 
> The first thing that comes to mind is trace_marker:
> 
>   echo "Test point A" > /sys/kernel/debug/tracing/trace_marker
> 
> I've found this sort of markup to be useful using ftrace (with C equivalents 
> embedded in the test case). Is this supported?

Yes, LatencyTop uses something similar IIRC, via a prctl() hack: it uses 
prctl(PR_SET_NAME) to inject up to 16 characters into the comm - and then every perf 
event gets that comm. You can utilize that straight away if you need a marker 
solution right now.

A cleaner, more generic approach would be a more free-form ASCII event facility for 
this: a generic 'user-space triggered event' with injection capabilities.

To inject it, we could put that into a prctl() as well, for easy, single-syscall 
access from C. We already have two perf prctls: PR_TASK_PERF_EVENTS_DISABLE, 
PR_TASK_PERF_EVENTS_ENABLE - and this would be a third one: PR_TASK_PERF_USER_EVENT.

This would, like the existing perf_event_task_enable()/disable() methods, loop 
through current events and inject a string into matching user events.

Ideally i'd like to see basically user-space access to trace_printk(), and proper 
integration into /debug/tracing/events/ enumeration and availability - not a 
ftrace-specific and admin-only hack like /sys/kernel/debug/tracing/trace_marker is 
today.

Would you be interested in helping out with (and testing) such a more generic 
approach?

Thanks,

	Ingo
