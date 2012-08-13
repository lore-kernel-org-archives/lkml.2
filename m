Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2HMNxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:53:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53653 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2HMNxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:53:09 -0400
Message-ID: <1344865977.31459.26.camel@twins>
Subject: Re: [RFC][PATCH 4/4] perf/events: Use helper functions in event
 assignment to shrink macro size
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 13 Aug 2012 15:52:57 +0200
In-Reply-To: <1344863027.6935.111.camel@gandalf.stny.rr.com>
References: <20120810034302.758092203@goodmis.org>
	 <20120810034708.589220175@goodmis.org> <1344845024.31459.9.camel@twins>
	 <1344863027.6935.111.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 09:03 -0400, Steven Rostedt wrote:
> On Mon, 2012-08-13 at 10:03 +0200, Peter Zijlstra wrote:
> 
> > > +void perf_trace_event_submit(void *raw_data, struct ftrace_event_call *event_call,
> > > +                            struct perf_trace_event *pe)
> > > +{
> > > +       struct hlist_head *head;
> > > +
> > > +       head = this_cpu_ptr(event_call->perf_events);
> > > +       perf_trace_buf_submit(raw_data, pe->entry_size, pe->rctx, pe->addr,
> > > +                             pe->count, &pe->regs, head);
> > > +}
> > 
> > Can you make perf_trace_buf_submit() go away? Its reduced to a simple
> > fwd function and layering another wrapper on top seems like pushing it.
> 
> You mean just have perf_trace_event_submit() call perf_tp_event()
> directly?
> 
> I have no problem with that. Although I may make that into a separate
> patch to keep this patch as a 'move' and the other patch as the change.
> 
> Looking at the history of perf_trace_buf_submit(), it use to be more
> than one function call. But when you inlined
> perf_swevent_put_recursion_context(), it became just a one2one mapping.

Right.

> I'm assuming that we want to convert all calls to
> perf_trace_buf_submit()s into perf_tp_event()?

Yeah.. I think you're referring to the {u,k}probes open-coded nonsense?
Should we make those use these new helpers you created as well?
