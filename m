Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0IMNyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:54:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48912 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0IMNyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:54:51 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284385967.17152.13.camel@gandalf.stny.rr.com>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
	 <1284237380.2251.56.camel@laptop>
	 <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
	 <1284282392.2251.81.camel@laptop>
	 <1284352547.7321.51.camel@marge.simson.net>
	 <1284367295.2275.31.camel@laptop>
	 <1284385967.17152.13.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 15:54:39 +0200
Message-ID: <1284386079.2275.290.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 09:52 -0400, Steven Rostedt wrote:
> On Mon, 2010-09-13 at 10:41 +0200, Peter Zijlstra wrote:
> 
> > Yeah, without it you can starve the already running task on massive
> > forks.
> > 
> > Still, I'm not quite sure why people really care about fork() on time
> > sensitive paths, its a very expensive thing to do, pre-fork() and wake
> > when you need it, is what I would say.
> 
> Fork is used all over the place in Linux. Every shell script uses it to
> execute commands. Bad fork behavior shows up in just doing a build of
> the kernel.

Sure, but there's a difference between bad fork behaviour and the lowest
possible latency. But maybe I'm too paranoid from doing -rt, but the
first thing I'd do is get all resource allocations out from your fast
path.
