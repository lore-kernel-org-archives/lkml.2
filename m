Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0IMJuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 05:50:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48391 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750920Ab0IMJue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 05:50:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Heh5j5/rHHuDHXdRRLIzfVMizwxYrQW/K25sFXy
	oHyPpATUPYR/xP
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
In-Reply-To: <1284370660.2275.86.camel@laptop>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 11:50:57 +0200
Message-Id: <1284371457.14888.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 11:37 +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 11:16 +0200, Mike Galbraith wrote:
> > On Mon, 2010-09-13 at 10:35 +0200, Peter Zijlstra wrote:
> > > On Mon, 2010-09-13 at 09:08 +0200, Mike Galbraith wrote:
> > > > We need a better fork fairness gizmo.
> > > 
> > > Proper zero-lag insertion would do. Much sadness in that tracking that
> > > costs a u64 mult per enqueu/dequeue and using it adds a s64 div.
> > 
> > (math _sucks_:)
> > 
> > > But if you want, have a play with:
> > 
> > maximum latency: 48475.3 µs
> > average latency: 6881.4 µs
> > missed timer events: 0
> > 
> > Darn.
> > 
> > make -j3 is gaining a tad over a hog as well, roughly the same as
> > turning START_DEBIT off.
> 
> 
> Hrmm,. could it be fair_sleeper muck placing too many tasks too far left
> on wakeup starving others?

Yeah, pretty much has to be fair_sleepers holding others off for too
long.  (A shiny new preemption model is about the only thing that can
make that go away)  Perhaps lag should be negated if you've received a
reasonable chunk or something.. but what we really want is a service
deadline.

	-Mike

