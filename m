Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2GLFpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:45:14 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52457 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2GLFpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:45:12 -0400
Message-ID: <4FFE645F.40902@linux.vnet.ibm.com>
Date: Thu, 12 Jul 2012 13:45:03 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: remove useless code in yield_to
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com> <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com> <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop> <20120126100429.GA3853@elte.hu> <4F21FC69.6040402@linux.vnet.ibm.com> <4F222B2B.6010602@gmail.com> <4F24E804.5090808@linux.vnet.ibm.com> <20120129163328.GC23408@elte.hu> <4F260BFE.2070503@linux.vnet.ibm.com> <4F260DAE.4000008@gmail.com> <4F262ED9.7040003@linux.vnet.ibm.com> <4FF2925A.9060005@linux.vnet.ibm.com>
In-Reply-To: <4FF2925A.9060005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071119-7014-0000-0000-0000018BD098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 02:34 PM, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> it's impossible to enter else branch if we have set skip_clock_update
> in task_yield_fair(), as yield_to_task_fair() will directly return
> true after invoke task_yield_fair().
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/core.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9bb7d28..77c14aa 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4737,13 +4737,6 @@ again:
>  		 */
>  		if (preempt && rq != p_rq)
>  			resched_task(p_rq->curr);
> -	} else {
> -		/*
> -		 * We might have set it in task_yield_fair(), but are
> -		 * not going to schedule(), so don't want to skip
> -		 * the next update.
> -		 */
> -		rq->skip_clock_update = 0;
>  	}

Can I get some comments on this patch?

Regards,
Michael Wang

> 
>  out:
> 


