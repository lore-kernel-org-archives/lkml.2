Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab2AXRNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:13:34 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64112 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2AXRNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:13:33 -0500
Message-ID: <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [GIT PULL] RCU changes for v3.3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 24 Jan 2012 18:13:28 +0100
In-Reply-To: <20120124165312.GG2531@linux.vnet.ibm.com>
References: <20120105135432.GA31450@elte.hu>
	 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120124165312.GG2531@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 08:53 -0800, Paul E. McKenney a écrit :
> On Tue, Jan 24, 2012 at 05:25:12PM +0100, Eric Dumazet wrote:
> > Le jeudi 05 janvier 2012 à 14:54 +0100, Ingo Molnar a écrit :
> > > Linus,
> > > 
> > > Please pull the latest core-rcu-for-linus git tree from:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus
> > > 
> > >  Thanks,
> > 
> > Hi guys
> > 
> > New lockdep warning here :
> 
> Hmmm...  Looks like tracing from within the inner idle loop.
> 
> Because RCU ignores CPUs in the inner idle loop (after the call to
> rcu_idle_enter()), RCU read-side critical sections are not legal there.
> 
> One approach would be to delay the call to rcu_idle_enter() until after
> the tracing is done, and to ensure that the call to rcu_idle_exit() happens
> before any tracing.  I am not seeing perf_trace_power(), so need to
> update and look again.  Or are you looking at -next rather than mainline?
> 

I am using mainline, not -next

It seems "powertop" triggers the warnings.

Check include/trace/events/power.h line 75 :

DECLARE_EVENT_CLASS(power,

This declares perf_trace_power()...

include/trace/ftrace.h line 718

#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)  \
static notrace void							\
perf_trace_##call(void *__data, proto) ...


Thanks


