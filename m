Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0H0HjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:39:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:54075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0H0HjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:39:09 -0400
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100826233651.GB28177@Krystal>
References: <20100826180908.648103531@efficios.com>
	 <1282849045.1975.1587.camel@laptop>
	 <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain>
	 <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain>
	 <20100826230934.GA4194@Krystal>  <20100826233651.GB28177@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 09:38:38 +0200
Message-ID: <1282894718.1975.1654.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 19:36 -0400, Mathieu Desnoyers wrote:
> > The only thing we might have to be careful about is what happens if the timer
> > re-fires before the thread completes its execution. We might want to let the
> > signal handler detect these overruns somehow.
> 
> Hrm, thinking about it a little more, one of the "plus" sides of these
> SIGEV_THREAD timers is that a single timer can fork threads that will run on
> many cores on a multi-core system. If we go for preallocation of a single
> thread, we lose that. Maybe we could think of a way to preallocate a thread pool
> instead ? 

Why try and fix a broken thing, just let the app spawn threads and use
SIGEV_THREAD_ID itself, it knows its requirements and can do what suits
the situation best. No need to try and patch up braindead posix stuff.


