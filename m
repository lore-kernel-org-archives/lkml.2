Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0IONMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:12:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59419 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752605Ab0IONMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:12:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19gR645ZQ5g36Pis/o8ehuPGiiKITZ5lu1esWCl0N
	ivjknt/jFr0B2C
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced
 forks) (v3)
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100915092205.GG16593@elte.hu>
References: <20100914202503.GA1496@Krystal>
	 <1284539831.21727.6.camel@marge.simson.net>
	 <1284541405.22863.8.camel@marge.simson.net>
	 <20100915092205.GG16593@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 15:12:46 +0200
Message-Id: <1284556366.22863.80.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 11:22 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > Tangent: cgroups with classification user/pgid
> >
> > taskset -c 3 ./wakeup-latency& sleep 30 && killall wakeup-latency
> > (taskset -c 3 make -j10 running)
> > 
> > maximum latency: 256.5 µs
> > average latency: 25.7 µs
> > missed timer events: 0
> > 
> > Rather spiffy for this case.
> 
> Ouch, nothing beats proper segregation of workloads.
> 
> It would be _really_ nice to get that automatically somehow, for make -j 
> jobs. Perhaps a per tty auto-cgroup-classification kernel feature?
> 
> We cannot really rely on distros to pull this off.

Dunno, wasn't hard.

I'm no good at scripting, but got mine cobbled together in fairly short
order.  With it all in userland, I can turn pgid classification on/off
at the drop of a hat, and/or launch self reaping cgroups with shares set
ala nice level with another script.  Easy and flexible.

(I usually don't have cgroups enabled, cobbled pgid thing together to
see if userland could deal with it easily enough.. seems so, if little
ole /me can do it, anybody can)

	-Mike

