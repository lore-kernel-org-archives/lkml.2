Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab0IMGmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:42:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45055 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab0IMGmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:42:07 -0400
Date: Mon, 13 Sep 2010 08:41:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
Message-ID: <20100913064153.GB14728@elte.hu>
References: <20100911173732.551632040@efficios.com>
 <20100911174003.051303123@efficios.com>
 <20100912061452.GA3383@elte.hu>
 <1284276098.9111.24.camel@marge.simson.net>
 <20100912181626.GB32327@Krystal>
 <1284351183.7321.36.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1284351183.7321.36.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0130]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Sun, 2010-09-12 at 14:16 -0400, Mathieu Desnoyers wrote:

> > Or am I missing your point ?
> 
> Yes and no.  I'm pondering the parent, but by the same token, the 
> vfork child shouldn't be penalized either.
> 
> Does your latency go down drastically if you turn START_DEBIT off? 
> Seems like it should.  Perhaps START_DEBIT should not start a task 
> further right than rightmost.  I've done that before.
> 
> maximum latency: 19221.5 탎
> average latency: 5159.0 탎
> missed timer events: 0
> 
> maximum latency: 43901.0 탎
> average latency: 8430.1 탎
> missed timer events: 0
> 
> Turning it off here cut latency roughly in half (i've piddled vfork 
> though, but not completely).  Limiting child placement to no further 
> right than rightmost should help quite a bit.

Very interesting observation. Mathieu, mind testing Mike's suggestion 
with wakeup-latency.c?

Thanks,

	Ingo
