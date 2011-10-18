Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1JRJXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:23:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40031 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752690Ab1JRJXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:23:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/xnwU0HhjxO0lJAGmEYZ2/waQ9s5wCvxBdM6Q52u
	Bz+TSVgOzV7aA7
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <1318928763.21167.5.camel@twins>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <1318925436.9641.23.camel@marge.simson.net>
	 <1318927355.21167.3.camel@twins>
	 <1318927629.9641.27.camel@marge.simson.net>
	 <1318928763.21167.5.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 11:23:45 +0200
Message-ID: <1318929825.9641.32.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 11:06 +0200, Peter Zijlstra wrote:
> On Tue, 2011-10-18 at 10:47 +0200, Mike Galbraith wrote:
> > On Tue, 2011-10-18 at 10:42 +0200, Peter Zijlstra wrote:
> > 
> > > Why special case these two, why not simply disallow moving kthreadd into
> > > _any_ cgroup what so ever and be done with it?
> > 
> > These were the cases where it hurt, and cpusets don't have to be a
> > component of a cgroup.  So we'd still need the cpuset bit.
> 
> but but but,, cpusetes are a cgroup thingy?!

By golly, mount -t cpuset and the thing does say type cgroup.  How 'bout
that, learn something new every day.  Dinkier is better.

> > > ---
> > > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > > index 453100a..18eed58 100644
> > > --- a/kernel/cgroup.c
> > > +++ b/kernel/cgroup.c
> > > @@ -1824,6 +1824,9 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
> > >  	struct cgroup *oldcgrp;
> > >  	struct cgroupfs_root *root = cgrp->root;
> > >  
> > > +	if (tsk == kthreadd_task)
> > > +		return -EINVAL;
> > > +
> > >  	/* Nothing to do if the task is already in that cgroup */
> > >  	oldcgrp = task_cgroup_from_root(tsk, root);
> > >  	if (cgrp == oldcgrp)
> > > 
> > 
> > 
> 


