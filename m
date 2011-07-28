Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1G1PGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:06:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64612 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab1G1PGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:06:30 -0400
Date: Thu, 28 Jul 2011 17:06:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Menage <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 7/7] cgroups: Add a max number of tasks subsystem
Message-ID: <20110728150620.GJ11820@somewhere.redhat.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
 <1310393706-321-8-git-send-email-fweisbec@gmail.com>
 <CAJniumW7ZKLLDaXSZ4TZ_=PX0ARERTeEyL-iTir12hciOArJqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJniumW7ZKLLDaXSZ4TZ_=PX0ARERTeEyL-iTir12hciOArJqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 06:17:08PM -0700, Paul Menage wrote:
> On Mon, Jul 11, 2011 at 7:15 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >  /* */
> > +
> > +#ifdef CONFIG_CGROUP_MAX_TASKS
> > +SUBSYS(max_tasks)
> > +#endif
> 
> I think I'd be inclined to make the naming slightly (IMO) cleaner:
> call the subsystem 'tasks' and the files 'limit' and 'count' (or maybe
> 'usage' to be more in line with memcg).

Sure. Will rename.

> >
> > +config CGROUP_MAX_TASKS
> > +        bool "Control max number of tasks in a cgroup"
> > +       depends on RESOURCE_COUNTERS
> > +       help
> > +         This option let the user to set up an upper bound allowed number
> > +         of tasks.
> > +
> 
> Needs to depend on CGROUPS too?
> 
> > +
> > +
> > +struct task_counter {
> > +       struct res_counter              res;
> > +       struct cgroup_subsys_state      css;
> > +};
> 
> All other CSS structures put the "css" field as the first thing in the
> structure. Not sure that anything relies on that, but consistency
> can't hurt and it probably makes the code fractionally smaller since
> the translation between CSS and task_counter becomes a no-op.

I guess Li responded to the two above points.

> > +static void task_counter_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
> > +                             struct cgroup *old_cgrp, struct task_struct *task)
> > +{
> > +       struct task_counter *cnt = cgroup_task_counter(old_cgrp);
> > +
> > +       if (cnt != &root_counter)
> > +               res_counter_uncharge_until(&cnt->res, &root_counter.res, 1);
> > +}
> 
> Do we even need the root_counter to be exposed in any way? Why not
> make children of the root cgroup just have a NULL parent res_counter?
> 
> You'll still need a task_counter object so that the cgroups framework
> has a CSS object for cgroups housekeeping, but I don't think it needs
> to actually be used for anything.
> 
> Paul

Right, will try to get that.

Thanks.
