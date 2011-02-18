Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1BRLKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 06:10:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57862 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750699Ab1BRLKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 06:10:05 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19whpxVcZBwap/MNCKmW9y5hs+manzoGfDsq+LS4A
	FHGYlccMxsOW/a
Date: Fri, 18 Feb 2011 12:09:55 +0100
From: torbenh <torbenh@gmx.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
Message-ID: <20110218110955.GA3124@siel.b>
Mail-Followup-To: Mike Galbraith <efault@gmx.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de
References: <1294657154.2016.459.camel@laptop>
 <1294677746.8345.4.camel@marge.simson.net>
 <20110111171046.GL4772@in.ibm.com>
 <1294771686.8006.15.camel@marge.simson.net>
 <1294810842.8370.7.camel@marge.simson.net>
 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
 <1294890890.8089.39.camel@marge.simson.net>
 <1295270160.30950.96.camel@laptop>
 <20110215154612.GI3055@siel.b>
 <1297788210.15382.51.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297788210.15382.51.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:43:30PM +0100, Mike Galbraith wrote:
> On Tue, 2011-02-15 at 16:46 +0100, torbenh wrote:
> > On Mon, Jan 17, 2011 at 02:16:00PM +0100, Peter Zijlstra wrote:
> > > On Thu, 2011-01-13 at 04:54 +0100, Mike Galbraith wrote:
> > > > sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
> > > > 
> > > > If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
> > > > not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
> > > > tasks to the root task group, and tell __sched_setscheduler() that it's ok.
> > > > 
> > > > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > > > Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > > 
> > > Thanks, applied!
> > 
> > while this behaviour is certeinly necessary, i think this is a hack.
> > it fixes the problem for autogroups.
> > But its not fixed for things which want to control the cfs shares via
> > normal cgroups.
> 
> You mean automated control ala systemd?  For a static set of groups, it
> works fine.  I was wondering how systemd would deal with it.

but i can not get the same behaviour as if CONFIG_RT_GROUP_SCHED was
off. iE N cgroups with different cpu.share values, but each with
rt_runtime_us=950000

if the rt_runtime_us was in a different subsystem, its my understanding
that i could leave rt_runtime_us alone, and have all tasks in the root
group in the rt_runtime subsystem.

> 
> > why isnt rt_runtime_us residing in a separate (new) subsystem ?
> 
> The allocation problem was shamelessly punted back to the user, where I
> think it truly belongs.

sure it belongs to the user. but what if user wants to have different
cpu.shares, but full rt_runtime_us for all tasks ?

i can not have 2 sibling cgroups, whose rt_runtime_us adds up to over
the rt_period ...



> 
> 	-Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
torben Hohn
