Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0LTNpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:45:55 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:61396 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab0LTNpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:45:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJPmDk1GNBQZ/2dsb2JhbACkInS9VYVKBIRlizw
Date: Mon, 20 Dec 2010 08:40:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 13/20] rcu: increase
	synchronize_sched_expedited() batching
Message-ID: <20101220134051.GA29577@Krystal>
References: <20101217205433.GA10199@linux.vnet.ibm.com> <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com> <4D0CDD93.7040907@kernel.org> <20101218201419.GD2143@linux.vnet.ibm.com> <4D0DD3D2.4030606@kernel.org> <20101219163552.GF2143@linux.vnet.ibm.com> <1292841231.2708.136.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1292841231.2708.136.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:36:16 up 256 days, 23:26,  4 users,  load average: 0.42, 0.19,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Sun, 2010-12-19 at 08:35 -0800, Paul E. McKenney wrote:
> > >  (int)((unsigned)(a) - (unsigned)(b)) < 0
> > 
> > Unfortunately, no.  :-(
> > 
> > The (int) converts from unsigned to signed, and if the upper bit of
> > the unsigned difference is non-zero, then the paragraph I quoted above
> > applies, and the standard allows the compiler to do whatever it wants.
> > 
> As noted in the previous reply, that would render quite a lot of our
> time-keeping code broken. I think its safe to assume this works.
> 
> Look at time_after() for example:
> 
> #define time_after(a,b)		\
> 	(typecheck(unsigned long, a) && \
> 	 typecheck(unsigned long, b) && \
> 	 ((long)(b) - (long)(a) < 0))

I agree with Peter: as long as the difference value is expected not to
overflow a signed long, the time_after() approach should be safe.

Now it depends if the usage Paul spotted is expected to have a
difference that overflows a signed int. It's not clear to me that it's
realistically possible from reading the patch, but I might be missing
something.

And by the way, if the difference is expected to overflow a signed int,
then we're only a factor two away from overflowing an unsigned int, so
the whole approach would be fragile.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
