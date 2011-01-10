Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1AJKJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:09:23 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:44691 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab1AJKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:09:21 -0500
Date: Mon, 10 Jan 2011 15:39:17 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 2/2] sched: Display autogroup names in
 /proc/sched_debug.
Message-ID: <20110110100917.GH2772@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110110051445.GB2772@in.ibm.com>
 <20110110051643.GD2772@in.ibm.com>
 <1294652287.17357.14.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294652287.17357.14.camel@marge.simson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:38:07AM +0100, Mike Galbraith wrote:
> On Mon, 2011-01-10 at 10:46 +0530, Bharata B Rao wrote:
> > sched: Display autogroup names in /proc/sched_debug.
> > 
> > Add autogroup name to cfs_rq and tasks information in /proc/sched_debug.
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> >  kernel/sched_debug.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > --- a/kernel/sched_debug.c
> > +++ b/kernel/sched_debug.c
> > @@ -92,6 +92,14 @@ static void print_cfs_group_stats(struct
> >  #ifdef CONFIG_CGROUP_SCHED
> >  static char * task_group_path(struct task_group *tg)
> >  {
> > +#ifdef CONFIG_SCHED_AUTOGROUP
> > +	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
> > +
> > +	if (enabled && tg->autogroup) {
> > +		autogroup_path(tg, group_path, PATH_MAX);
> > +		return group_path;
> > +	}
> > +#endif
> >  	/*
> >  	 * May be NULL if the underlying cgroup isn't fully-created yet
> >  	 */
> 
> What prevents the task being moved, and the task group being freed under
> you?  Looks to me like task_group_path() needs rcu_read_lock().  It is
> locked in the other two instances.  How about the below?

You are right, we need rcu_read_lock() there. Let me spin out an other
version with the changes.

Thanks,
Bharata.
