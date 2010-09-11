Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0IKUxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 16:53:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab0IKUx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 16:53:29 -0400
MIME-Version: 1.0
In-Reply-To: <1284237950.2251.59.camel@laptop>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com>
 <1284231470.2251.52.camel@laptop> <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
 <1284237380.2251.56.camel@laptop> <1284237950.2251.59.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 11 Sep 2010 13:52:40 -0700
Message-ID: <AANLkTimmkmeyFg6wSw4Ej=gqLAHgcB5puRxvAa_14eZp@mail.gmail.com>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with nr_running
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 1:45 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2010-09-11 at 22:36 +0200, Peter Zijlstra wrote:
>>
>> But if you want us to change the scheduler to be more latency sensitive
>> and trade in throughput for other benchmarks, we can do that.
>
> Really, just say "latency trumps throughput" and we'll make it so.

Nothing is ever that black-and-white.

But latency really _is_ important. And it's often overlooked, because
few benchmarks actually test it. So when somebody sends you actual
measured latency numbers, you shouldn't be so cavalier. And you
shouldn't say "trumps throughput", since it's clearly a matter of
balancing, and quite frankly, Mathieu's patch does seem to try to
balance things.

As mentioned, it does seem to make tons of conceptual sense to take
the number of running threads into account for the whole scheduling
granularity decision. After all, we already do that for the other
important numbers (the scheduling period and time slice).

So to me it looks like you're just being negative, without actually
looking at the patch and giving it some fair thought. That's what I'm
objecting to.

                              Linus
