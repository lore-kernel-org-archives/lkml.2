Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0IMSBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:01:19 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34835 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752508Ab0IMSBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:01:17 -0400
Date: Mon, 13 Sep 2010 14:01:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH] check_preempt_tick should not compare vruntime
	with wall time
Message-ID: <20100913180115.GC15653@Krystal>
References: <1284288072.2251.91.camel@laptop> <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop> <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop> <20100913161641.GA28707@Krystal> <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com> <20100913174533.GA15653@Krystal> <AANLkTi=8m4g01wZPacySoF7U0PevTNVgJoZZrHiUD-pN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=8m4g01wZPacySoF7U0PevTNVgJoZZrHiUD-pN@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:56:58 up 233 days, 20:33,  5 users,  load average: 0.02, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Mon, Sep 13, 2010 at 10:45 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > FWIW, Xorg and firefox feel _much more_ responsive with the fix I propose when
> > running with a make -j10. The system is even usable with a make -j20 on my UP
> > machine, even though I can start feeling a some lag. This is probably a more
> > important, yet less scientific, result.
> 
> I'll test that myself (but in a bit - I need to go do voter
> registration and socsec update first, though - I became a US citizen
> last week).

Congratulations!

> Because yes, that's the reason I'm personally interested in your
> scheduler latency work: I think our X behavior under load is pitiful
> (I do "make -j16" on my dual-core with HT Core i5, and web browsong
> shouldn't start to lag as much as it does just because I overcommit
> the CPU a bit). So if this makes a noticeable difference, I think it's
> very important.

Please make sure to include the "smaller min_granularity" patch in your test
too, because the "check_preempt_tick" fix seems to only affect threads with
non-zero nice value. I suspect that most of the responsiveness improvement I got
is mainly from lowering the min_granularity.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
