Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1ELO44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:56:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64290 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1ELO4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:56:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U0vjqq9PDOngOJoRgcfKZwcZqlMOK4gesvcnZSv1oqvsjJh7mUPdyfZp+Ph5UDNA19
         5cIJyxUqFL84UbGxuL/eYPNbnKtnSqRJ/qkC8l0iCx1E4Kub4/3gY7Z6aZ1i5ok4cbGq
         zEWPsV7ECQ0MjXYXYETaNJgOGdp9nEjVzEvaQ=
Date: Thu, 12 May 2011 22:56:41 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: mingo@elte.hu, Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: remove unused variable
Message-ID: <20110512145641.GA4475@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1305210516-1653-1-git-send-email-lucas.demarchi@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1305210516-1653-1-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:28:36AM -0300, Lucas De Marchi wrote:
> Remove variable that is set but not used, cleaning GCC warning.
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>

This has been on -tip tree: commit 1437f5bca3c2d162f058cba37dfbeb20f619040d

Thanks,
Yong

> ---
>  kernel/sched.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 312f8b9..66319fd 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8553,7 +8553,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
>  {
>  	struct rt_rq *rt_rq;
>  	struct sched_rt_entity *rt_se;
> -	struct rq *rq;
>  	int i;
>  
>  	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
> @@ -8567,8 +8566,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
>  			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
>  
>  	for_each_possible_cpu(i) {
> -		rq = cpu_rq(i);
> -
>  		rt_rq = kzalloc_node(sizeof(struct rt_rq),
>  				     GFP_KERNEL, cpu_to_node(i));
>  		if (!rt_rq)
> -- 
> 1.7.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
