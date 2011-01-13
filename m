Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab1AMIq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 03:46:56 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58915 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab1AMIqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 03:46:53 -0500
Date: Thu, 13 Jan 2011 14:16:48 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
Message-ID: <20110113084648.GA2982@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110110091622.GF2772@in.ibm.com>
 <1294655388.8197.22.camel@marge.simson.net>
 <1294657154.2016.459.camel@laptop>
 <1294677746.8345.4.camel@marge.simson.net>
 <20110111171046.GL4772@in.ibm.com>
 <1294771686.8006.15.camel@marge.simson.net>
 <1294810842.8370.7.camel@marge.simson.net>
 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
 <1294890890.8089.39.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294890890.8089.39.camel@marge.simson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 04:54:50AM +0100, Mike Galbraith wrote:
> (mailer switched me to work account again.  grrrr, switch yet again:)
> 
> On Wed, 2011-01-12 at 14:32 +0800, Yong Zhang wrote:
> 
> > Setting rt_runtime both in this patch and the previous one will make tune
> > other's rt_runtime/rt_period trouble, I guess.
> 
> Yeah, as in making it impossible to allocate even 1 usec :)  We need
> zero bandwidth though, so tell  __sched_setscheduler() that autogroups
> having zero allocated is perfectly fine.
> 
> sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
> 
> If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
> not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
> tasks to the root task group, and tell __sched_setscheduler() that it's ok.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> ---
>  kernel/sched.c           |    3 ++-
>  kernel/sched_autogroup.c |   27 +++++++++++++++++++++++++++
>  kernel/sched_autogroup.h |    4 ++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 

Works fine here.

Thanks,
Bharata.
