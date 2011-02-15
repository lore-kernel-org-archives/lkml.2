Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1BOQnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:43:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:39085 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754721Ab1BOQng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:43:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+yrmliDUeygkLRtcHc7N7xtR5gdXOpsjFmZqG6c/
	XEta/ttiDmyxHX
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: torbenh <torbenh@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110215154612.GI3055@siel.b>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <20110111171046.GL4772@in.ibm.com>
	 <1294771686.8006.15.camel@marge.simson.net>
	 <1294810842.8370.7.camel@marge.simson.net>
	 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
	 <1294890890.8089.39.camel@marge.simson.net>
	 <1295270160.30950.96.camel@laptop>  <20110215154612.GI3055@siel.b>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 17:43:30 +0100
Message-ID: <1297788210.15382.51.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 16:46 +0100, torbenh wrote:
> On Mon, Jan 17, 2011 at 02:16:00PM +0100, Peter Zijlstra wrote:
> > On Thu, 2011-01-13 at 04:54 +0100, Mike Galbraith wrote:
> > > sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
> > > 
> > > If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
> > > not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
> > > tasks to the root task group, and tell __sched_setscheduler() that it's ok.
> > > 
> > > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > > Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > 
> > Thanks, applied!
> 
> while this behaviour is certeinly necessary, i think this is a hack.
> it fixes the problem for autogroups.
> But its not fixed for things which want to control the cfs shares via
> normal cgroups.

You mean automated control ala systemd?  For a static set of groups, it
works fine.  I was wondering how systemd would deal with it.

> why isnt rt_runtime_us residing in a separate (new) subsystem ?

The allocation problem was shamelessly punted back to the user, where I
think it truly belongs.

	-Mike

