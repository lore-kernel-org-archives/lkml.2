Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0IMPjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:39:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0IMPjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:39:31 -0400
X-Authority-Analysis: v=1.1 cv=2ipXt8Ao/PPbK329gQN1nC6XU/V8QMABDttguNTIlb0= c=1 sm=0 a=mn088iM2194A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=H_w1km2cK86m2wSpQ7wA:9 a=V7e0wAUPtCgh4lfNTAUYVuMGZZQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100913152514.GA8771@Krystal>
References: <20100911174003.051303123@efficios.com>
	 <1284231470.2251.52.camel@laptop> <20100911195708.GA9273@Krystal>
	 <1284288072.2251.91.camel@laptop> <20100912203712.GD32327@Krystal>
	 <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop>
	 <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop>
	 <1284388990.17152.19.camel@gandalf.stny.rr.com>
	 <20100913152514.GA8771@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Sep 2010 11:39:28 -0400
Message-ID: <1284392368.17152.44.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 11:25 -0400, Mathieu Desnoyers wrote:

> > > The more divs we put it, the more expensive it all becomes.
> > > 
> > 
> > What about:
> > 
> > 	if (delta_exec < sysctl_sched_min_granularity ||
> > 	    delta_exec < __sched_gran(cfs_rq->nr_running))
> > 
> > This way we avoid the div when delta_exec is less than the
> > min_granularity, and then we can do the div to perhaps avoid a needless
> > resched?
> 
> Please note that my patch does not even take the 32-bit div when there are less
> than 4 threads running on the system.
> 
> So I'm not at all sure we're trying to optimize an important case here.

If we have 5 threads running and hit this where delta_exec is <
sched_min_granularity, then we do have that div, right? Question is, how
often do we hit this condition where delta_exec is less while running
more that 4 threads?

-- Steve


