Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1C2OKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:10:21 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:38888 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab1C2OKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:10:20 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>
References: <20110325142344.058372664@linutronix.de> <20110325142511.735713243@linutronix.de>
In-Reply-To: <20110325142511.735713243@linutronix.de>
Subject: RE: [patch 2/2] unicore32: Use generic show_interrupts()
Date: Tue, 29 Mar 2011 22:10:08 +0800
Message-ID: <019601cbee1b$028920a0$079b61e0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEqwHQoTzbgKMZbeAtd7l1GSN8fHQEJzmBAlX5mkmA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thx.

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, March 25, 2011 10:27 PM
> To: LKML
> Cc: Guan Xuetao
> Subject: [patch 2/2] unicore32: Use generic show_interrupts()
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/unicore32/Kconfig      |    1 +
>  arch/unicore32/kernel/irq.c |   42 ------------------------------------------
>  2 files changed, 1 insertion(+), 42 deletions(-)
> 
> Index: linux-2.6-tip/arch/unicore32/Kconfig
> ===================================================================
> --- linux-2.6-tip.orig/arch/unicore32/Kconfig
> +++ linux-2.6-tip/arch/unicore32/Kconfig
> @@ -11,6 +11,7 @@ config UNICORE32
>  	select GENERIC_FIND_FIRST_BIT
>  	select GENERIC_IRQ_PROBE
>  	select GENERIC_HARDIRQS_NO_DEPRECATED
> +	select GENERIC_IRQ_SHOW
>  	select ARCH_WANT_FRAME_POINTERS
>  	help
>  	  UniCore-32 is 32-bit Instruction Set Architecture,
> Index: linux-2.6-tip/arch/unicore32/kernel/irq.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/unicore32/kernel/irq.c
> +++ linux-2.6-tip/arch/unicore32/kernel/irq.c
> @@ -355,48 +355,6 @@ void __init init_IRQ(void)
>  #endif
>  }
> 
> -int show_interrupts(struct seq_file *p, void *v)
> -{
> -	int i = *(loff_t *) v, cpu;
> -	struct irq_desc *desc;
> -	struct irqaction *action;
> -	unsigned long flags;
> -
> -	if (i == 0) {
> -		char cpuname[12];
> -
> -		seq_printf(p, "    ");
> -		for_each_present_cpu(cpu) {
> -			sprintf(cpuname, "CPU%d", cpu);
> -			seq_printf(p, " %10s", cpuname);
> -		}
> -		seq_putc(p, '\n');
> -	}
> -
> -	if (i < nr_irqs) {
> -		desc = irq_to_desc(i);
> -		raw_spin_lock_irqsave(&desc->lock, flags);
> -		action = desc->action;
> -		if (!action)
> -			goto unlock;
> -
> -		seq_printf(p, "%3d: ", i);
> -		for_each_present_cpu(cpu)
> -			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
> -		seq_printf(p, " %10s", desc->irq_data.chip->name ? : "-");
> -		seq_printf(p, "  %s", action->name);
> -		for (action = action->next; action; action = action->next)
> -			seq_printf(p, ", %s", action->name);
> -
> -		seq_putc(p, '\n');
> -unlock:
> -		raw_spin_unlock_irqrestore(&desc->lock, flags);
> -	} else if (i == nr_irqs) {
> -		seq_printf(p, "Error in interrupt!\n");
> -	}
> -	return 0;
> -}
> -
>  /*
>   * do_IRQ handles all hardware IRQ's.  Decoded IRQs should not
>   * come via this function.  Instead, they should provide their

