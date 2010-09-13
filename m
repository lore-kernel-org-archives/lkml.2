Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab0IMKGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:06:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48099 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750871Ab0IMKF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:05:58 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18fhO9CflsfZLaMzTthdulPzlj1N6SX+CA5vLDXzT
	Q1SWyJBfD+qILw
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284371756.2275.108.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu>
	 <1284276098.9111.24.camel@marge.simson.net>
	 <20100912181626.GB32327@Krystal>
	 <1284351183.7321.36.camel@marge.simson.net>
	 <20100913064153.GB14728@elte.hu>
	 <1284361716.25120.19.camel@marge.simson.net>
	 <1284366936.2275.27.camel@laptop>
	 <1284369373.14710.11.camel@marge.simson.net>
	 <1284370660.2275.86.camel@laptop>
	 <1284371457.14888.9.camel@marge.simson.net>
	 <1284371756.2275.108.camel@laptop>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 12:06:18 +0200
Message-Id: <1284372378.14888.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 11:55 +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 11:50 +0200, Mike Galbraith wrote:
> > Perhaps lag should be negated if you've received a
> > reasonable chunk or something.. but what we really want is a service
> > deadline.
> 
> Hey, I've got a patch for that too :-)
> 
> Not rebased to anything current, but should be able to get frobbed onto
> the last zero-lag thingy without too much grief (I think).

A frobbing I shall go.

> +/*
> + * Entity is eligible once it received less service than it ought to have,
> + * eg. lag >= 0.
> + *
> + * lag_i = S_i - s_i = w_i*(V - w_i)
> + *
> + * lag_i >=0 -> V >= v_i
> + *
> + *     \Sum (v_i - v)*w_i
> + * V = ------------------ + v
> + *          \Sum w_i
> + *
> + * lag_i >= 0 -> \Sum (v_i - v)*w_i >= (v_i - v)*(\Sum w_i)
> + */

Ew, more of that icky stuff.

	-Mike

