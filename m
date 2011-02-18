Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1BRMuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 07:50:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50835 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750775Ab1BRMuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 07:50:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19MDzcnHTtM81Rkyy5D+k7vv9Eq5jamA+md+xe54N
	CuBzVrXpIveerG
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: torbenh <torbenh@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20110218110955.GA3124@siel.b>
References: <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <20110111171046.GL4772@in.ibm.com>
	 <1294771686.8006.15.camel@marge.simson.net>
	 <1294810842.8370.7.camel@marge.simson.net>
	 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
	 <1294890890.8089.39.camel@marge.simson.net>
	 <1295270160.30950.96.camel@laptop> <20110215154612.GI3055@siel.b>
	 <1297788210.15382.51.camel@marge.simson.net> <20110218110955.GA3124@siel.b>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 13:50:12 +0100
Message-ID: <1298033412.8735.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 12:09 +0100, torbenh wrote:
> On Tue, Feb 15, 2011 at 05:43:30PM +0100, Mike Galbraith wrote:
> > On Tue, 2011-02-15 at 16:46 +0100, torbenh wrote:
> > > On Mon, Jan 17, 2011 at 02:16:00PM +0100, Peter Zijlstra wrote:
> > > > On Thu, 2011-01-13 at 04:54 +0100, Mike Galbraith wrote:
> > > > > sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
> > > > > 
> > > > > If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
> > > > > not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
> > > > > tasks to the root task group, and tell __sched_setscheduler() that it's ok.
> > > > > 
> > > > > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > > > > Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > > > 
> > > > Thanks, applied!
> > > 
> > > while this behaviour is certeinly necessary, i think this is a hack.
> > > it fixes the problem for autogroups.
> > > But its not fixed for things which want to control the cfs shares via
> > > normal cgroups.
> > 
> > You mean automated control ala systemd?  For a static set of groups, it
> > works fine.  I was wondering how systemd would deal with it.
> 
> but i can not get the same behaviour as if CONFIG_RT_GROUP_SCHED was
> off. iE N cgroups with different cpu.share values, but each with
> rt_runtime_us=950000

? if CONFIG_RT_GROUP_SCHED was a noop, it wouldn't exist.

> if the rt_runtime_us was in a different subsystem, its my understanding
> that i could leave rt_runtime_us alone, and have all tasks in the root
> group in the rt_runtime subsystem.
 
Sounds like you just want to turn CONFIG_RT_GROUP_SCHED off.

> > The allocation problem was shamelessly punted back to the user, where I
> > think it truly belongs.
> 
> sure it belongs to the user. but what if user wants to have different
> cpu.shares, but full rt_runtime_us for all tasks ?

Then the user doesn't want CONFIG_RT_GROUP_SCHED set.

	-Mike

