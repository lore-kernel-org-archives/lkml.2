Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966095Ab0CPJe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:34:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966075Ab0CPJez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:34:55 -0400
Date: Tue, 16 Mar 2010 10:34:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
Message-ID: <20100316093440.GE7961@elte.hu>
References: <4B8F1B58.5000702@linux.vnet.ibm.com>
 <4B8FFE55.5070008@linux.vnet.ibm.com>
 <20100311124608.GG31354@elte.hu>
 <20100312024100.GA2734@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312024100.GA2734@brick.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> On Thu, Mar 11, 2010 at 01:46:08PM +0100, Ingo Molnar wrote:
> > 
> > * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> > 
> > > On 3/3/2010 6:30 PM, Corey Ashford wrote:
> > > >For your review, this patch adds support for arch-dependent symbolic
> > > >event names to the "perf stat" tool, and could be expanded to other
> > > >"perf *" commands fairly easily, I suspect.
> 
> > I'm quite much against stop-gap measures like this - they tend to become 
> > tomorrow's impossible-to-remove quirk.
> > 
> > If you want extensible events you can already do it by providing an ftrace 
> > tracepoint event via TRACE_EVENT. They are easy to add and ad-hoc, and are 
> > supported throughout by perf.
> 
> If I've understood correctly what Corey is doing, I think you're missing the 
> point.  The idea, I thought, was to provide a way to be able to use symbolic 
> names for raw hardware events rather than just numbers.  I don't see how 
> ftrace tracepoint events are relevant to that.

tracepoints are relevant because they are the currently best way of how we 
assign symbolic names to various kernel-internal events. For ad-hoc usecases 
like this:

   http://dri.freedesktop.org/wiki/IntelPerformanceTuning

I'd much rather see that facility used (and, to the extent needed, extended) 
to provide support for rare arch events that we dont want to enumerate in a 
generic way.

Or, if the events are important enough to be hardcoded into the perf ABI 
itself, they should be generalized in a meaningful way - even if you dont 
expect them to show up on other CPUs.

	Ingo
