Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0EFG3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:29:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35264 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab0EFG3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:29:07 -0400
Date: Thu, 6 May 2010 08:28:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
       efault@gmx.de, avi@redhat.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
Message-ID: <20100506062855.GD1172@elte.hu>
References: <1273050400.1642.229.camel@laptop>
 <4BE13B33.3030709@kernel.org>
 <1273053073.1642.235.camel@laptop>
 <4BE1406C.2000400@kernel.org>
 <1273059488.1642.245.camel@laptop>
 <4BE1648B.1080709@kernel.org>
 <20100505165532.GC14323@elte.hu>
 <1273083173.1642.250.camel@laptop>
 <1273083396.1642.251.camel@laptop>
 <20100505183000.GF6320@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505183000.GF6320@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, May 05, 2010 at 08:16:36PM +0200, Peter Zijlstra wrote:
> > On Wed, 2010-05-05 at 20:15 +0200, Peter Zijlstra wrote:
> > > 
> > > Well, I'd much rather just see a direct call in the code than having to
> > > reverse engineer wth hangs onto that _EVENT() junk.
> > 
> > And again, I oppose mandating CONFIG_TRACEEVENT.
> 
> 
> And me too. But you don't need CONFIG_EVENT_TRACING for that. TRACE_EVENT() 
> with !CONFIG_EVENT_TRACING only produces tracepoints if CONFIG_TRACEPOINTS.
> 
> In fact, a first progress that would handle these compromizes would be to 
> have CONFIG_PERF_EVENT_SW.
> 
> For now perf_event_task_sched_in and perf_event_task_sched_out can stay as 
> is because they are perf core utils.
> 
> But all the rest (faults, migrations, etc..) could be tracepoints builtin 
> only if CONFIG_PERF_EVENT_SW. Which means CONFIG_PERF_EVENT_SW depends on 
> CONFIG_TRACEPOINTS.
> 
> But nobody is forced to build CONFIG_PERF_EVENT_SW, breakpoints don't need 
> it.

Yep. Also, most of the default distro kernels will have 3 sets of facilities:

 - preempt notifiers
 - tracepoints
 - sw events

which is crazy. We can just standardize on using the tracepoint interface 
definition methods - they are properly typed, widespread and well-known enough 
to be perfect for this.

( They are also under intense optimization - the jump-tracepoints patch makes 
  them probably even cheaper than preempt notifiers, in the off case. )

So lets get over this and consolidate our crazy hookery, and stand behind a 
single facility.

I'm also all for slimming down the trace events facilities by not requiring 
the /debug/tracing/ bits to be present.

	Ingo
