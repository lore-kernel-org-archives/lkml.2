Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934802Ab0KQMbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:31:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51877 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291Ab0KQMbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:31:25 -0500
Date: Wed, 17 Nov 2010 13:30:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] trace: Add user-space event tracing/injection
Message-ID: <20101117123055.GA27063@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE38C53.8090606@kernel.org>
 <20101117120740.GA24972@elte.hu>
 <4CE3C7C2.7000200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE3C7C2.7000200@kernel.org>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> >  $ trace report
> >  #
> >  # trace events of 'sleep 1':
> >  #
> >         testit/ 6006 ( 0.002 ms):<"Hello World!">
> >         testit/ 6006 ( 0.002 ms):<"Hello World!">
> 
> Wow! This looks really nice!
> 
> What does the duration in milliseconds mean there? For things like
> GC and JIT, I want something like:
> 
> void gc(void)
> {
>         prctl(PR_TASK_PERF_USER_TRACE_START, ...)
> 
>         collect();
> 
>         prctl(PR_TASK_PERF_USER_TRACE_END, ...)
> }
> 
> So that it's clear from the tracing output that the VM was busy
> doing GC for n milliseconds. Barring background JIT'ing and
> pauseless GC, I'd also be interested in showing how much time the VM
> was actually _blocking_ the running application (which can happen
> with signals too, btw, for things like accessing data that's lazily
> initialized).

We can add two events: user_event_entry/user_event_exit - or we could use the string 
to differentiate, and start it with:

  "entry: ..."
  "exit: ..."

And then the event timestamps (which are absolute and are available) could be used 
to calculate the duration of this period.

'trace' could even be taught to treat such entry:/exit: strings in a special way, so 
that you dont have to write Jato specific trace decoding bits?

Thanks,

	Ingo
