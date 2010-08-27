Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0H0R2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:28:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab0H0R2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:28:02 -0400
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100827160946.GG14926@Krystal>
References: <20100826180908.648103531@efficios.com>
	 <1282849045.1975.1587.camel@laptop>
	 <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain>
	 <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain>
	 <20100826230934.GA4194@Krystal> <1282894655.1975.1650.camel@laptop>
	 <20100827152125.GB14926@Krystal> <1282923686.1975.2780.camel@laptop>
	 <20100827160946.GG14926@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 19:27:52 +0200
Message-ID: <1282930072.1975.2962.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 12:09 -0400, Mathieu Desnoyers wrote:
> > The specification also doesn't cover the case where the handler takes
> > more time to execute than the timer interval.
> 
> Why should it ? It seems valid for a workload to result in spawning many threads
> bound to more than a single core on a multi-core system. So concurrency
> management should be performed by the application. 

The problem with allowing concurrency is that the moment you want to do
that you get the spawner context and error propagation problems.

Thus we're limited to spawning a single thread at timer_create() and
handling expirations in there. At that point you have to specify what
happens to an expiration while the handler is running, will it queue
handlers or will you have to carefully craft your handler using
timer_getoverrun().

But I really don't understand why POSIX would provide this composite
functionality instead of providing the separate bits to implement this,
which I think is only SIGEV_THREAD_ID which is missing.


