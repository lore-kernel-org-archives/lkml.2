Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1K2G4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:56:06 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34837 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1K2G4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:56:04 -0500
Date: Tue, 29 Nov 2011 12:23:15 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Shan Hai <haishan.bai@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        tglx@linutronix.de
Subject: Re: [PATCH 1/1] sched/rt: code cleanup, remove a redundant function
 call
Message-ID: <20111129065315.GA15774@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1322535836-13590-1-git-send-email-haishan.bai@gmail.com>
 <1322535836-13590-2-git-send-email-haishan.bai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322535836-13590-2-git-send-email-haishan.bai@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11112906-3864-0000-0000-0000004AC94C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shan Hai <haishan.bai@gmail.com> [2011-11-29 11:03:56]:

> The second time call to sched_rt_period is redundant, because the value of the
> rt_runtime was already read and it was protected by the rurt_runtime_lock.
> 
> Signed-off-by: Shan Hai <haishan.bai@gmail.com>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

> ---
>  kernel/sched_rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 056cbd2..2171ac8 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -645,7 +645,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
>  	if (rt_rq->rt_throttled)
>  		return rt_rq_throttled(rt_rq);
> 
> -	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
> +	if (runtime >= sched_rt_period(rt_rq))
>  		return 0;
> 
>  	balance_runtime(rt_rq);
> -- 
> 1.7.4.1

