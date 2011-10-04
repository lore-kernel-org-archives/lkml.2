Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810Ab1JDVKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 17:10:20 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43873 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab1JDVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 17:10:19 -0400
Date: Tue, 4 Oct 2011 14:10:16 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>,
        container ML <containers@lists.linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Miao Xie <miaox@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <htejun@gmail.com>,
        stable@kernel.org
Subject: Re: [BUGFIX] cgroup: create a workqueue for cgroup
Message-Id: <20111004141016.af26219d.akpm00@gmail.com>
In-Reply-To: <20111003141911.b4ee7bca.nishimura@mxp.nes.nec.co.jp>
References: <20110930165452.19c0fdf4.nishimura@mxp.nes.nec.co.jp>
	<20110930153049.6719a14e.akpm00@gmail.com>
	<20111003092244.bcfde141.nishimura@mxp.nes.nec.co.jp>
	<20111003141911.b4ee7bca.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011 14:19:11 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Mon, 3 Oct 2011 09:22:44 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > On Fri, 30 Sep 2011 15:30:49 -0700
> > Andrew Morton <akpm00@gmail.com> wrote:
> > 
> > > On Fri, 30 Sep 2011 16:54:52 +0900
> > > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > 
> > > > In commit:f90d4118, cpuset_wq, a separate workqueue for cpuset, was introduced
> > > > to avoid a dead lock against cgroup_mutex between async_rebuild_sched_domains()
> > > > and cgroup_tasks_write().
> > > > 
> > > > But check_for_release() has a similar problem:
> > > > 
> > > >   check_for_release()
> > > >     schedule_work(release_agent_work)
> > > >       cgroup_release_agent()
> > > >         mutex_lock(&cgroup_mutex)
> > > > 
> > > > And I actually see a lockup which seems to be caused by this problem
> > > > on 2.6.32-131.0.15.el6.x86_64.
> > > 
> > > Are you sure the bug is still present in current kernels?  Perhaps
> > > Tejun's workqueue changes magically made it go away.
> > > 
> > Not yet, but I'll check it.
> > 
> As you said, I cannot repricate this issue on 3.1-rc8. But I've verified
> it happens on 2.6.32.46 and this patch fixes it, so I think this patch is
> necessary for stable at least.
> 

Getting the fix into -stable is a problem.

Firstly, the -stable maintainers only really take backports of fixes
which are already in mainline.  So to fix this bug one would need to
identify which upstream fix(es) did the work, and backport those.

Secondly, I'm not sure that kernels as old as 2.6.32.x are still being
maintained at kernel.org, at least.

So I'm not sure what to suggest.  Perhaps send the fix directly to
distro kernel maintainers?
