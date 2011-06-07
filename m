Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1FGWmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:42:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:39058 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab1FGWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:42:21 -0400
Date: Wed, 8 Jun 2011 00:42:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/5] Fix mismatched variable in rcutree_trace.c
In-Reply-To: <1307485593-27196-2-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1106080040320.11814@ionos>
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org> <1307485593-27196-2-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Jun 2011, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> rcutree.c defines rcu_cpu_kthread_cpu as int, not unsigned int,
> so the extern has to follow that.
> 
> Cc: paulmck@linux.vnet.ibm.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/rcutree_trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index 9678cc3..91c56e5 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -47,7 +47,7 @@
>  #include "rcutree.h"
>  
>  DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
> -DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
> +DECLARE_PER_CPU(int, rcu_cpu_kthread_cpu);

Can we rather fix the DEFINE to use unsigned int. Signed cpu numbers
are pointless in that context, right ?

>  DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
>  DECLARE_PER_CPU(char, rcu_cpu_has_work);
>  
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
