Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0IKUsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 16:48:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab0IKUsw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 16:48:52 -0400
MIME-Version: 1.0
In-Reply-To: <1284237380.2251.56.camel@laptop>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com>
 <1284231470.2251.52.camel@laptop> <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
 <1284237380.2251.56.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 11 Sep 2010 13:48:29 -0700
Message-ID: <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with nr_running
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 1:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
>From what I can make up:
>
>  LAT=`cat /proc/sys/kernel/sched_latency_ns`;
>  echo $((LAT/8)) > /proc/sys/kernel/sched_min_granularity_ns
>
> will give you pretty much the same result as Mathieu's patch.

Or perhaps not. The point being that Mathieu's patch seems to do this
dynamically based on number of runnable threads per cpu. Which seems
to be a good idea.

IOW, this part:

-       if (delta_exec < sysctl_sched_min_granularity)
+       if (delta_exec < __sched_gran(cfs_rq->nr_running))

seems to be a rather fundamental change, and looks at least
potentially interesting. It seems to make conceptual sense to take the
number of running tasks into account at that point, no?

And I don't like how you dismissed the measured latency improvement.
And yes, I do think latency matters. A _lot_.

And no, I'm not saying that Mathieu's patch is necessarily good. I
haven't tried it myself. I don't have _that_ kind of opinion. The
opinion I do have is that I think it's sad how you dismissed things
out of hand - and seem to _continue_ to dismiss them without
apparently actually having looked at the patch at all.

                                    Linus
