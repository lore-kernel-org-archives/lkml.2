Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2EYJkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:40:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:58190 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2EYJkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:40:11 -0400
Subject: Re: [PATCH 3/3] sched/rt: Remove redundant check before
 push_rt_task()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4FBF2A1D.2090302@ct.jp.nec.com>
References: <4FBF29B2.9030904@ct.jp.nec.com>
	 <4FBF2A1D.2090302@ct.jp.nec.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 11:39:58 +0200
Message-ID: <1337938798.9783.172.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 15:43 +0900, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Currently rq->rt.overloaded is checked twice in switched_to_rt().
> Remove the first one which out of push_rt_task().

Steven was this on purpose to avoid the call or can I apply this thing?

> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  kernel/sched/rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index c5565c3..a601a70 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1907,7 +1907,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
>  	 */
>  	if (p->on_rq && rq->curr != p) {
>  #ifdef CONFIG_SMP
> -		if (rq->rt.overloaded && push_rt_task(rq) &&
> +		if (push_rt_task(rq) &&
>  		    /* Don't resched if we changed runqueues */
>  		    rq != task_rq(p))
>  			check_resched = 0;



