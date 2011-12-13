Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1LMMmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:42:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:34064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1LMMmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:42:04 -0500
Message-ID: <1323780069.9082.15.camel@twins>
Subject: Re: [PATCH 1/3] sched: fix cgroup movement of newly created process
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Tue, 13 Dec 2011 13:41:09 +0100
In-Reply-To: <20111213155758.30d2787e.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
	 <20111213155758.30d2787e.nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 15:57 +0900, Daisuke Nishimura wrote:

>  kernel/sched_fair.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

you blink you loose, that file doesn't exist anymore.


> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5c9e679..df145a9 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -4922,10 +4922,10 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
>  	 * to another cgroup's rq. This does somewhat interfere with the
>  	 * fair sleeper stuff for the first placement, but who cares.
>  	 */
> -	if (!on_rq)
> +	if (!on_rq && p->state != TASK_RUNNING)
>  		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
>  	set_task_rq(p, task_cpu(p));
> -	if (!on_rq)
> +	if (!on_rq && p->state != TASK_RUNNING)
>  		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
>  }
>  #endif

The much saner way of writing that is something like:

 /*
  * Comment explaining stuff..
  */
 if (!on_rq && p->state == TASK_RUNNING)
	on_rq = 1;

 ...


