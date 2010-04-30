Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab0D3SDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:03:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57154 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775Ab0D3SCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:02:54 -0400
Date: Fri, 30 Apr 2010 11:02:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent] fix several lockdep splats, allow
 multiple splats
Message-ID: <20100430180247.GA2482@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100421200150.GA3818@linux.vnet.ibm.com>
 <20100430100749.GC14202@elte.hu>
 <20100430153334.GA19672@Krystal>
 <10035.1272644205@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10035.1272644205@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 12:16:45PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 30 Apr 2010 11:33:34 EDT, Mathieu Desnoyers said:
> 
> > I recommend creating a kernel command line parameter that would tweak
> > the number of messages printed by lockdep. The default would indeed by 1
> > message, but people in a debugging marathon can specify a larger value
> > so they won't have to reboot between each individual lockdep error.
> 
> Yeah, that would rock for development kernels - playing whack-a-mole with
> a half-dozen new lockdep whinges can easily stretch out for quite some time.

The RCU-lockdep splats are a bit different in nature than the
deadlock-related splats that lockdep normally prints.  The RCU-lockdep
splats are transient in nature, and it is easy to apply WARN_ON_ONCE().
In contrast, if you permit multiple deadlock-related lockdep splats,
you tend to get lots of warnings about the same deadlock cycle.

So how about an additional kernel configuration variable, default
disabled, perhaps named CONFIG_PROVE_RCU_MULTIPLE, that allows a
single boot to see multiple messages?  Unlike the dyntick-idle
WARN_ON()s that generated multi-gigabyte console logs in a great
hurry, I haven't yet seen excessive quantities of RCU-lockdep splats,
so I don't see the need for an integer limit.

Thoughts?

							Thanx, Paul
