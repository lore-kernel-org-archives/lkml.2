Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947Ab2C3Opo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:45:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50037 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2C3Opi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:45:38 -0400
Subject: Re: sched: WARNING: at include/linux/cpumask.h:108
 select_fallback_rq+0x241/0x280()
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, mingo@kernel.org,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>, vapier@gentoo.org,
        rusty@rustcorp.com.au
In-Reply-To: <4F75BED4.9050005@linux.vnet.ibm.com>
References: <CA+1xoqcf6qJOouKXGEHsjWSBJdA7qtMnuVopq+hoHS+TX8fvSg@mail.gmail.com>
	 <CA+1xoqcJAwgTgQG=nZPsH_SLkPFkGt2rUiVWGn5SO5JOAC1RAA@mail.gmail.com>
	 <4F75BED4.9050005@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Mar 2012 16:45:19 +0200
Message-ID: <1333118719.2960.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 19:40 +0530, Srivatsa S. Bhat wrote:

> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: sched: Fix incorrect usage of for_each_cpu_mask() in select_fallback_rq()
> 
> The function for_each_cpu_mask() expects a *pointer* to struct cpumask
> as its second argument, whereas select_fallback_rq() passes the value
> itself. And moreover, for_each_cpu_mask() has been marked as obselete
> in include/linux/cpumask.h. So move to the more appropriate for_each_cpu()
> variant.

Gah.. so why did it compile to begin with!?

> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index e3ed0ec..e85046d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1270,7 +1270,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
>  	int dest_cpu;
>  
>  	/* Look for allowed, online CPU in same node. */
> -	for_each_cpu_mask(dest_cpu, *nodemask) {
> +	for_each_cpu(dest_cpu, nodemask) {
>  		if (!cpu_online(dest_cpu))
>  			continue;
>  		if (!cpu_active(dest_cpu))
> @@ -1281,7 +1281,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
>  
>  	for (;;) {
>  		/* Any allowed, online CPU? */
> -		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
> +		for_each_cpu(dest_cpu, tsk_cpus_allowed(p)) {
>  			if (!cpu_online(dest_cpu))
>  				continue;
>  			if (!cpu_active(dest_cpu))
> 
> 



