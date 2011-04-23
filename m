Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1DWOMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 10:12:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65140 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab1DWOMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 10:12:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SmnTuKLo3AFQeB0rXXsHRFhKHf2pVexC/WgnD8q8rtdSvlugzcDpWxTFpprxXohaxo
         GF5gfeRbuSB1CgebBGyqXm/SSOL8+7zCgyZPBLoJZ862rykMOFknLbcd6zWS9VSlxwnR
         bPvbobvI86nrCEzq/v0kQjL2QCWR5cJM6cjxE=
Date: Sat, 23 Apr 2011 22:12:22 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: remove noop in alloc_rt_sched_group()
Message-ID: <20110423141222.GB7747@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <BANLkTin-FfQfqW5ym1iuEmrk8s777Y1LAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTin-FfQfqW5ym1iuEmrk8s777Y1LAg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 09:29:05PM +0800, Hillf Danton wrote:
> The rq varible, though computed for each possible cpu, has nothing to
> do in the function, so it could be removed.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Looks good.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

> ---
> 
> --- a/kernel/sched.c	2011-03-30 03:09:48.000000000 +0800
> +++ b/kernel/sched.c	2011-04-23 21:23:48.000000000 +0800
> @@ -8539,7 +8539,6 @@ int alloc_rt_sched_group(struct task_gro
>  {
>  	struct rt_rq *rt_rq;
>  	struct sched_rt_entity *rt_se;
> -	struct rq *rq;
>  	int i;
> 
>  	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
> @@ -8553,8 +8552,6 @@ int alloc_rt_sched_group(struct task_gro
>  			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
> 
>  	for_each_possible_cpu(i) {
> -		rq = cpu_rq(i);
> -
>  		rt_rq = kzalloc_node(sizeof(struct rt_rq),
>  				     GFP_KERNEL, cpu_to_node(i));
>  		if (!rt_rq)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
