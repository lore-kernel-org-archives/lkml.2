Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1BOPqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:46:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58304 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751198Ab1BOPqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:46:18 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18W1loPRwAW6szwtwJ1s1JNNJ4+rtY1t2csroDU0I
	JV4RdK6SeLgTCD
Date: Tue, 15 Feb 2011 16:46:12 +0100
From: torbenh <torbenh@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        bharata@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
Message-ID: <20110215154612.GI3055@siel.b>
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
	bharata@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <20110110091622.GF2772@in.ibm.com>
 <1294655388.8197.22.camel@marge.simson.net>
 <1294657154.2016.459.camel@laptop>
 <1294677746.8345.4.camel@marge.simson.net>
 <20110111171046.GL4772@in.ibm.com>
 <1294771686.8006.15.camel@marge.simson.net>
 <1294810842.8370.7.camel@marge.simson.net>
 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
 <1294890890.8089.39.camel@marge.simson.net>
 <1295270160.30950.96.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295270160.30950.96.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 02:16:00PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-01-13 at 04:54 +0100, Mike Galbraith wrote:
> > sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
> > 
> > If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
> > not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
> > tasks to the root task group, and tell __sched_setscheduler() that it's ok.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> Thanks, applied!

while this behaviour is certeinly necessary, i think this is a hack.
it fixes the problem for autogroups.
But its not fixed for things which want to control the cfs shares via
normal cgroups. 

why isnt rt_runtime_us residing in a separate (new) subsystem ?


-- 
torben Hohn
