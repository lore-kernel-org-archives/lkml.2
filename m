Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1KBSCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:02:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:55909 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab1KBSCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:02:37 -0400
Date: Wed, 2 Nov 2011 19:02:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: edward.donovan@numble.net
cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com
Subject: Re: [PATCH] genirq: spurious.c: fix regression that broke
 irqfixup,irqpoll
In-Reply-To: <1320175784-6745-1-git-send-email-edward.donovan@numble.net>
Message-ID: <alpine.LFD.2.02.1111021901440.2829@ionos>
References: <1320175784-6745-1-git-send-email-edward.donovan@numble.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011, edward.donovan@numble.net wrote:

> From: Edward Donovan <edward.donovan@numble.net>
> 
> commit  d05c65fff0 ("genirq: spurious: Run only one poller at a time")
> introduced a regression, leaving the boot options 'irqfixup' and
> 'irqpoll' non-functional.  The patch placed tests in each function, to
> exit if the function is already running.  The test in 'misrouted_irq'
> exited when it should have proceeded, effectively disabling
> 'misrouted_irq' and 'poll_spurious_irqs'.  Reversing the "==" operator
> to "!=" fixes the regression.
> 
> Signed-off-by: Edward Donovan <edward.donovan@numble.net>

Good catch! I was staring at it with my conference and flu damaged
brain ....

Thanks,

	tglx

> ---
>  kernel/irq/spurious.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
> index aa57d5d..b5f4742 100644
> --- a/kernel/irq/spurious.c
> +++ b/kernel/irq/spurious.c
> @@ -115,7 +115,7 @@ static int misrouted_irq(int irq)
>  	struct irq_desc *desc;
>  	int i, ok = 0;
>  
> -	if (atomic_inc_return(&irq_poll_active) == 1)
> +	if (atomic_inc_return(&irq_poll_active) != 1)
>  		goto out;
>  
>  	irq_poll_cpu = smp_processor_id();
> -- 
> 1.7.5.4
> 
> 
