Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0H0Hng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:43:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:42600 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab0H0Hnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:43:33 -0400
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100826234910.GB4194@Krystal>
References: <20100826180908.648103531@efficios.com>
	 <1282849045.1975.1587.camel@laptop>  <20100826234910.GB4194@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 09:42:40 +0200
Message-ID: <1282894960.1975.1666.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 19:49 -0400, Mathieu Desnoyers wrote:
> AFAIK, I don't think we would end up starving the system in any possible way.

Correct, it does maintain fairness.

> So far I cannot see a situation where selecting the next buddy would _not_ make
> sense in any kind of input-driven wakeups (interactive, timer, disk, network,
> etc). But maybe it's just a lack of imagination on my part. 

The risk is that you end up with always using next-buddy, and we tried
that a while back and that didn't work well for some, Mike might
remember.

Also, when you use timers things like time-outs you really couldn't care
less if its handled sooner rather than later.

Disk is usually so slow you really don't want to consider it
interactive, but then sometimes you might,.. its a really hard problem.

The only clear situation is the direct input, that's a direct link
between the user and our wakeup chain and the user is always important.


