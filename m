Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0KSMzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:55:53 -0500
Received: from mail.openrapids.net ([64.15.138.104]:60483 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753327Ab0KSMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:55:52 -0500
Date: Fri, 19 Nov 2010 07:55:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101119125548.GC24411@Krystal>
References: <1289916171.5169.117.camel@maggy.simson.net> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com> <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net> <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net> <20101118234339.GA6024@const.famille.thibault.fr> <1290167376.2109.1553.camel@laptop> <1290169178.2109.1573.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290169178.2109.1573.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:53:01 up 57 days, 16:55,  3 users,  load average: 1.19, 1.25,
	1.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2010-11-19 at 12:49 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-11-19 at 00:43 +0100, Samuel Thibault wrote:
> > > What overhead? The implementation of cgroups is actually already
> > > hierarchical. 
> > 
> > It must be nice to be that ignorant ;-) Speaking for the scheduler
> > cgroup controller (that being the only one I actually know), most all
> > the load-balance operations are O(n) in the number of active cgroups,
> > and a lot of the cpu local schedule operations are O(d) where d is the
> > depth of the cgroup tree.
> > 
> > [ and that's with the .38 targeted code, current mainline is O(n ln(n))
> > for load balancing and truly sucks on multi-socket ]
> > 
> > You add a lot of pointer chasing to all the scheduler fast paths and
> > there is quite significant data size bloat for even compiling with the
> > controller enabled, let alone actually using the stuff.
> > 
> > But sure, treat them as if they were free to use, I guess your machine
> > is fast enough.
> 
> In general though, I think you can say that: cgroups ass overhead.

I really think you meant "add" here ? (Hey! The keys were next to each other!)
;)

> Simply because you add constraints, this means you need to 1) account
> more, 2) enforce constraints. Both have definite non-zero cost in both
> data and time.

Yep, this looks like one of these perpetual throughput vs latency trade-offs.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
