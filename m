Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab0LYTds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 14:33:48 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47713 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0LYTdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 14:33:46 -0500
Date: Sun, 26 Dec 2010 00:35:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, torbenh <torbenh@gmx.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Gregory Haskins <ghaskins@novell.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>, vatsa@in.ibm.com
Subject: Re: Sending some form of notifaction when sched_fifo throttling
 kicks in...
Message-ID: <20101225190504.GB3393@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101223113926.GH14960@siel.b>
 <1293110258.3390.41.camel@Palantir>
 <AANLkTi=1v6YG-Vc7uZFvqO6K0fAuZ-o9A7hxeZVVAHm3@mail.gmail.com>
 <1293115496.3390.49.camel@Palantir>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1293115496.3390.49.camel@Palantir>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dario Faggioli <raistlin@linux.it> [2010-12-23 15:44:56]:

> On Thu, 2010-12-23 at 15:04 +0100, Dhaval Giani wrote: 
> > > ... If you think you're fine with some /proc (and perhaps cpuacct, if
> > > cgroups are being used) readable, I can try to come up with something.
> > >
> > 
> > There is no point in putting it in cpuacct since cpuacct can be used
> > separately from cpu.
> > 
> Which would mean that you'd need both for having such stat. Anyway, I'm
> fine with putting this in 'cpu' as well, just trying to find a consensus
> on what the right place is.
> 
> > > Do others have some idea and/or comments about that? This is
> > > ABI/interface, and that really scares me! :-P
> > 
> > IIRC, your patchset had something like this for getting the
> > statistics? Starting fromt hre, would schedstats be the right place?
> > 
> SCHED_DEADLINE patchset has both signaling capabilities and some
> statistic reporting, bat it's a different thing.
> 
> I think schedstat could be the right place for _this_ thing here, but
> since each cgroup could be throttled, we also need something which is
> per-cgroup... Don't you agree?
>

You definitely need something per cgroup, have you looked at the
events framework in cgroups and its implementation in memcgroup?



-- 
	Three Cheers,
	Balbir
