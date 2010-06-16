Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab0FPQBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:01:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:32963 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759167Ab0FPQBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:01:02 -0400
Date: Wed, 16 Jun 2010 18:00:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Gilles Espinasse <g.esp@free.fr>,
       Tejun Heo <tj@kernel.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 3/9] Removing dead CONFIG_SIBYTE_BCM1480_PROF
In-Reply-To: <c217f4530c057f4b8030bd14459a0cb2856decde.1275925108.git.siccegge@cs.fau.de>
Message-ID: <alpine.LNX.2.00.1006161800290.12271@pobox.suse.cz>
References: <cover.1275925108.git.siccegge@cs.fau.de> <c217f4530c057f4b8030bd14459a0cb2856decde.1275925108.git.siccegge@cs.fau.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010, Christoph Egger wrote:

> CONFIG_SIBYTE_BCM1480_PROF doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

The patch isn't present in linux-next as of today. I have applied it to my 
tree, thanks.

> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/mips/sibyte/bcm1480/irq.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
> index 044bbe4..919d2d5 100644
> --- a/arch/mips/sibyte/bcm1480/irq.c
> +++ b/arch/mips/sibyte/bcm1480/irq.c
> @@ -362,19 +362,8 @@ asmlinkage void plat_irq_dispatch(void)
>  	unsigned int cpu = smp_processor_id();
>  	unsigned int pending;
>  
> -#ifdef CONFIG_SIBYTE_BCM1480_PROF
> -	/* Set compare to count to silence count/compare timer interrupts */
> -	write_c0_compare(read_c0_count());
> -#endif
> -
>  	pending = read_c0_cause() & read_c0_status();
>  
> -#ifdef CONFIG_SIBYTE_BCM1480_PROF
> -	if (pending & CAUSEF_IP7)	/* Cpu performance counter interrupt */
> -		sbprof_cpu_intr();
> -	else
> -#endif
> -
>  	if (pending & CAUSEF_IP4)
>  		do_IRQ(K_BCM1480_INT_TIMER_0 + cpu);
>  #ifdef CONFIG_SMP
> -- 
> 1.6.3.3
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
