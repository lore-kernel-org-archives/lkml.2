Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0H0Hhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:37:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53734 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0H0Hhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:37:50 -0400
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100826230934.GA4194@Krystal>
References: <20100826180908.648103531@efficios.com>
	 <1282849045.1975.1587.camel@laptop>
	 <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain>
	 <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain>
	 <20100826230934.GA4194@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 09:37:35 +0200
Message-ID: <1282894655.1975.1650.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 19:09 -0400, Mathieu Desnoyers wrote:
> > WTF can't the damned delivery thread not be created when timer_create
> > is called and the signal be delivered to that very thread directly via
> > SIGEV_THREAD_ID ?
> 
> Yeah, that sounds exactly like what I proposed about an hour ago on IRC ;) I'm
> pretty sure that would work.
> 
> The only thing we might have to be careful about is what happens if the timer
> re-fires before the thread completes its execution. We might want to let the
> signal handler detect these overruns somehow.

Simply don't use SIGEV_THREAD and spawn you own thread and use
SIGEV_THREAD_ID yourself, the programmer knows the semantics and knows
if he cares about overlapping timers etc.


