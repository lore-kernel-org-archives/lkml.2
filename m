Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1CCHKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:10:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33652 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab1CCHKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:10:48 -0500
Date: Thu, 3 Mar 2011 08:10:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracepoints filtering updates
Message-ID: <20110303071031.GA10935@elte.hu>
References: <1298693021-23500-1-git-send-email-fweisbec@gmail.com>
 <20110302084925.GA21204@elte.hu>
 <20110303035121.GA3456@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303035121.GA3456@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> l (fweisbec[at]gmail.com)
> 	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
> 	[score: 0.0000]
> Content-Length: 3017
> Lines: 76
> 
> On Wed, Mar 02, 2011 at 09:49:25AM +0100, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > We currently set the filters after we mmap the events, this is a
> > > race that let undesired events record themselves in the buffer before
> > > we had the time to set the filters.
> > > 
> > > So set the filters before they can be recorded. That also librarizes
> > > the filters setting so that filtering can be done more easily
> > > from other tools than perf record later.
> > > 
> > > (PS: This should fix most of the bugs Ingo has reported
> > > about filters that weren't working with perf).
> > 
> > Nice!
> > 
> > Mind pulling Steve's filter-enhancements branch and sending a pull request for the 
> > whole thing? Steve's branch was:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git tip/perf/filter
> > 
> > ( Or your fixes could be applied to Steve's branch as well - whichever direction you 
> >   guys prefer - the important thing is to have filtering tested and validated as a 
> >   whole. )
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Ok, I've merged Steve's branch and tested a few common filters with perf:
> 
> * irq numbers on irq tracepoints
> * fd on sys_enter_close
> * prev_comm on sched_switch (to test string)
> 
> they all work well.
> 
> You can pull the branch from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> --
> Frederic Weisbecker (2):
>       perf: Set filters before mmaping events
>       Merge branch '/tip/perf/filter' of git://git.kernel.org/.../rostedt/linux-2.6-trace.git into perf/core
> 
> Steven Rostedt (14):
>       tracing/filter: Have no filter return a match
>       tracing/filter: Move OR and AND logic out of fn() method
>       tracing/filter: Dynamically allocate preds
>       tracing/filter: Call synchronize_sched() just once for system filters
>       tracing/filter: Allocate the preds in an array
>       tracing/filter: Free pred array on disabling of filter
>       tracing/filter: Use a tree instead of stack for filter_match_preds()
>       tracing/filter: Optimize short ciruit check
>       tracing/filter: Check the created pred tree
>       tracing/filter: Optimize filter by folding the tree
>       tracing/filter: Move MAX_FILTER_PRED to local tracing directory
>       tracing/filter: Increase the max preds to 2^14
>       tracing/filter: Swap entire filter of events
>       tracing/filter: Remove synchronize_sched() from __alloc_preds()
> --
>  include/linux/ftrace_event.h       |    1 -
>  kernel/trace/trace.h               |   38 ++-
>  kernel/trace/trace_events_filter.c |  885 +++++++++++++++++++++++++++++-------
>  tools/perf/builtin-record.c        |   18 +-
>  tools/perf/util/evlist.c           |   28 ++
>  tools/perf/util/evlist.h           |    1 +
>  6 files changed, 789 insertions(+), 182 deletions(-)

Pulled, thanks a lot guys!

	Ingo
