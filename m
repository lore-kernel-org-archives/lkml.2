Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab0KQNYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:24:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43255 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488Ab0KQNYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:24:32 -0500
Date: Wed, 17 Nov 2010 14:24:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20101117132404.GF27063@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <20101117013700.GA3290@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117013700.GA3290@thunk.org>
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


* Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, Nov 16, 2010 at 10:04:40PM +0100, Thomas Gleixner wrote:
> > If you've booted the new kernel you can run 'trace check' to double
> > check that all events used by the tool are available:
> > 
> >  $ trace check
> > 
> >  Checking whether the kernel has all required events ...
> >   ... Checking event  raw_syscalls:sys_enter:r      : ok
> >   ...
> >   ... Checking event  sched:sched_stat_runtime:r    : ok
> >  Good: all required event types are supported by this kernel.
> >  The 'trace' utility will be fully functional.
> 
> For the benefit of people who create tracepoints, what restrictions
> does trace have with respect to event types, and is this anticipated
> to change in the future?

There are no conceptual restrictions - this v1 version of the tool uses a (small) 
subset of tracepoints right now.

ext4 tracepoints will be used once someone writes a trace code (or plugin) for it - 
i think beyond simply displaying that trace data it would also be useful to 
interpret it to a certain degree? They could also interact with the block events: so 
we could track which inode (or other ext4 data structure) generates what IO, what 
the latencies are and which task originated things. We could track what the wait 
reasons are.

At that point (when ext4 event support is added) we'd add 'trace check' test as 
well, and would generally try to make sure that if distros enable events that all 
commonly used tracepoints are available as well.

I.e. the long term goal would be to create a widely available tool, which, amongst 
other things, can be used to record and report ext4 events as well - with no kernel 
reboots or tool rebuilds required.

> > The combo diffstat of the tool is appended at the end of the mail. The
> > overwhelming majority of changes is on the tooling side - it uses
> > existing perf events facilities and features to implement the tool.
> 
> What about the filtering and other general features/functionality of
> ftrace?  Is the anticipation that this will be ported over to perf?
> What about things like blktrace?

Yeah, i'd love to see all that available. Filtering is available already on the 
kernel perf event side and could be added as an option.

> Not that I expect all of this will be working with this initial
> release, but I'm curious about the long-term roadmap of this
> interface.  (Obviously subject to change as we learn more, etc.  But
> I'd love to hear what your current thoughts and plans are.)
>
> P.S.  What about sysrq-z?  Is that going to stay with ftrace side of
> the tracing architecture?

What we are working towards is to unify the whole tracing infrastructure. IMHO it's 
not really acceptable that there is an 'ftrace side' and a 'perf side', with feature 
overlap and feature mismatch and general confusion.

Thanks,

	Ingo
