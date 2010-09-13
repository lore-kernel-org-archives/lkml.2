Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0IMIlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:41:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0IMIln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:41:43 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284352547.7321.51.camel@marge.simson.net>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
	 <1284237380.2251.56.camel@laptop>
	 <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
	 <1284282392.2251.81.camel@laptop>
	 <1284352547.7321.51.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 10:41:35 +0200
Message-ID: <1284367295.2275.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 06:35 +0200, Mike Galbraith wrote:
> On Sun, 2010-09-12 at 11:06 +0200, Peter Zijlstra wrote:
> > On Sat, 2010-09-11 at 13:48 -0700, Linus Torvalds wrote:
> 
> > > And I don't like how you dismissed the measured latency improvement.
> > > And yes, I do think latency matters. A _lot_.
> > 
> > OK, we'll make it better and sacrifice some throughput, can do, no
> > problem.
> 
> I'm not seeing high wakeup latencies, even under hefty load.  Mathieu's
> testcase is bad, but apparently solely due to START_DEBIT placement.
> That's kind of a sticky wicket.  I've shot it in the heart before, but
> regretted doing so when I looked at kbuild vs static load fairness.

Yeah, without it you can starve the already running task on massive
forks.

Still, I'm not quite sure why people really care about fork() on time
sensitive paths, its a very expensive thing to do, pre-fork() and wake
when you need it, is what I would say.


