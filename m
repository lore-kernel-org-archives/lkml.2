Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1GSVMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:12:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49016 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1GSVMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:12:40 -0400
Subject: Re: [PATCH 1/2] sched: Fix "divide error: 0000" in
 find_busiest_group
From: Peter Zijlstra <peterz@infradead.org>
To: Terry Loftin <terry.loftin@hp.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Bob Montgomery <bob.montgomery@hp.com>
In-Reply-To: <4E25F006.2010205@hp.com>
References: <4E25F006.2010205@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 23:17:04 +0200
Message-ID: <1311110224.2617.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 14:58 -0600, Terry Loftin wrote:
> Correct the protection expression in update_cpu_power() to avoid setting
> rq->cpu_power to zero.

Firstly you fail to mention what kernel this is again, secondly this
should never happen in the first place, so this fix is wrong. At best it
papers over another bug.

> Signed-off-by: Terry Loftin <terry.loftin@hp.com>
> Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>
> ---
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 0c26e2d..9c50020 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -2549,7 +2549,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
>  	power *= scale_rt_power(cpu);
>  	power >>= SCHED_LOAD_SHIFT;
> 
> -	if (!power)
> +	if ((u32)power == 0)
>  		power = 1;
> 
>  	cpu_rq(cpu)->cpu_power = power;



