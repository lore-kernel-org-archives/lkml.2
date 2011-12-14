Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1LNBRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:17:36 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52988 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab1LNBRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:17:34 -0500
Date: Wed, 14 Dec 2011 10:05:24 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 1/3] sched: fix cgroup movement of newly created process
Message-Id: <20111214100524.3f42de16.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <1323780069.9082.15.camel@twins>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
	<20111213155758.30d2787e.nishimura@mxp.nes.nec.co.jp>
	<1323780069.9082.15.camel@twins>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011 13:41:09 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-12-13 at 15:57 +0900, Daisuke Nishimura wrote:
> 
> >  kernel/sched_fair.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> you blink you loose, that file doesn't exist anymore.
> 
hmm, indeed.
I'll rebase these patches onto the tip.

> 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 5c9e679..df145a9 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -4922,10 +4922,10 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
> >  	 * to another cgroup's rq. This does somewhat interfere with the
> >  	 * fair sleeper stuff for the first placement, but who cares.
> >  	 */
> > -	if (!on_rq)
> > +	if (!on_rq && p->state != TASK_RUNNING)
> >  		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
> >  	set_task_rq(p, task_cpu(p));
> > -	if (!on_rq)
> > +	if (!on_rq && p->state != TASK_RUNNING)
> >  		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
> >  }
> >  #endif
> 
> The much saner way of writing that is something like:
> 
>  /*
>   * Comment explaining stuff..
>   */
>  if (!on_rq && p->state == TASK_RUNNING)
> 	on_rq = 1;
> 
>  ...
> 
will do in the next post.

Thanks,
Daisuke Nishimura.
