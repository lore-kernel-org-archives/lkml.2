Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1JCFXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:23:44 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56563 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1JCFXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:23:38 -0400
Date: Mon, 3 Oct 2011 14:19:11 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm00@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        container ML <containers@lists.linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Miao Xie <miaox@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <htejun@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX] cgroup: create a workqueue for cgroup
Message-Id: <20111003141911.b4ee7bca.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20111003092244.bcfde141.nishimura@mxp.nes.nec.co.jp>
References: <20110930165452.19c0fdf4.nishimura@mxp.nes.nec.co.jp>
	<20110930153049.6719a14e.akpm00@gmail.com>
	<20111003092244.bcfde141.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011 09:22:44 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Fri, 30 Sep 2011 15:30:49 -0700
> Andrew Morton <akpm00@gmail.com> wrote:
> 
> > On Fri, 30 Sep 2011 16:54:52 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > In commit:f90d4118, cpuset_wq, a separate workqueue for cpuset, was introduced
> > > to avoid a dead lock against cgroup_mutex between async_rebuild_sched_domains()
> > > and cgroup_tasks_write().
> > > 
> > > But check_for_release() has a similar problem:
> > > 
> > >   check_for_release()
> > >     schedule_work(release_agent_work)
> > >       cgroup_release_agent()
> > >         mutex_lock(&cgroup_mutex)
> > > 
> > > And I actually see a lockup which seems to be caused by this problem
> > > on 2.6.32-131.0.15.el6.x86_64.
> > 
> > Are you sure the bug is still present in current kernels?  Perhaps
> > Tejun's workqueue changes magically made it go away.
> > 
> Not yet, but I'll check it.
> 
As you said, I cannot repricate this issue on 3.1-rc8. But I've verified
it happens on 2.6.32.46 and this patch fixes it, so I think this patch is
necessary for stable at least.

Thanks,
Daisuke Nishimura.
