Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0IMSUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:20:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab0IMSUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:20:13 -0400
Date: Mon, 13 Sep 2010 20:19:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH] check_preempt_tick should not compare vruntime with
 wall time
Message-ID: <20100913181959.GB20171@elte.hu>
References: <20100911195708.GA9273@Krystal>
 <1284288072.2251.91.camel@laptop>
 <20100912203712.GD32327@Krystal>
 <1284382387.2275.265.camel@laptop>
 <1284383758.2275.283.camel@laptop>
 <20100913135621.GA13442@Krystal>
 <1284387398.2275.311.camel@laptop>
 <20100913161641.GA28707@Krystal>
 <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
 <20100913174533.GA15653@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100913174533.GA15653@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0166]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> 2.0GHz Pentium M
> 
> * wakeup-latency.c (SIGEV_THREAD) with make -j10 
> 
> - Mainline 2.6.35.2 kernel
> 
> maximum latency: 45762.1 탎
> average latency: 7348.6 탎
> missed timer events: 0
> 
> - check_preempt fix
> 
> maximum latency: 39858.9 탎
> average latency: 7728.1 탎
> missed timer events: 0

Note that the check_preempt fix, as i mentioned it in the previous mail, 
has no effect on this workload - so any effect you see is pure noise.

> - With only Peter's smaller min_gran (shown below):
> 
> maximum latency: 29100.6 탎
> average latency: 6684.1 탎
> missed timer events: 0

That's the real improvement.

> - check_preempt fix + Peter's smaller min_gran:
> maximum latency: 20433.0 탎
> average latency: 5112.5 탎
> missed timer events: 0

Again, pure noise effect.

	Ingo
