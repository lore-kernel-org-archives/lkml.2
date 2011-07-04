Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1GDB6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 21:58:15 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:40838 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab1GDB6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 21:58:14 -0400
Subject: Re: [patch 10/11] sh/unicore32/irqs: Do not trace
 arch_local_{*,irq_*} functions
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20110702033854.432833160@goodmis.org>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033854.432833160@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Mon, 04 Jul 2011 09:56:39 +0800
Message-ID: <1309744599.2291.1.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks good to me.

Thanks & Regards.

Guan Xuetao

On Fri, 2011-07-01 at 23:04 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0010-sh-unicore32-irqs-Do-not-trace-arch_local_-irq_-func.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
> Although they are marked inline, gcc may still make a function out of
> them and add it to the pool of functions that are traced by the function
> tracer. This can cause undesirable results (kernel panic, triple faults,
> etc).
> 
> Add the notrace notation to prevent them from ever being traced.
> 
> This patch only updates include/asm-generic/irqflags.h, but the only archs
> to use it is superH and unicore32.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/asm-generic/irqflags.h |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/irqflags.h b/include/asm-generic/irqflags.h
> index 1f40d002..092b27e 100644
> --- a/include/asm-generic/irqflags.h
> +++ b/include/asm-generic/irqflags.h
> @@ -1,6 +1,8 @@
>  #ifndef __ASM_GENERIC_IRQFLAGS_H
>  #define __ASM_GENERIC_IRQFLAGS_H
>  
> +#include <linux/types.h>
> +
>  /*
>   * All architectures should implement at least the first two functions,
>   * usually inline assembly will be the best way.
> @@ -22,7 +24,7 @@ void arch_local_irq_restore(unsigned long flags);
>  
>  /* get status and disable interrupts */
>  #ifndef arch_local_irq_save
> -static inline unsigned long arch_local_irq_save(void)
> +static inline notrace unsigned long arch_local_irq_save(void)
>  {
>  	unsigned long flags;
>  	flags = arch_local_save_flags();
> @@ -33,7 +35,7 @@ static inline unsigned long arch_local_irq_save(void)
>  
>  /* test flags */
>  #ifndef arch_irqs_disabled_flags
> -static inline int arch_irqs_disabled_flags(unsigned long flags)
> +static inline notrace int arch_irqs_disabled_flags(unsigned long flags)
>  {
>  	return flags == ARCH_IRQ_DISABLED;
>  }
> @@ -41,7 +43,7 @@ static inline int arch_irqs_disabled_flags(unsigned long flags)
>  
>  /* unconditionally enable interrupts */
>  #ifndef arch_local_irq_enable
> -static inline void arch_local_irq_enable(void)
> +static inline notrace void arch_local_irq_enable(void)
>  {
>  	arch_local_irq_restore(ARCH_IRQ_ENABLED);
>  }
> @@ -49,7 +51,7 @@ static inline void arch_local_irq_enable(void)
>  
>  /* unconditionally disable interrupts */
>  #ifndef arch_local_irq_disable
> -static inline void arch_local_irq_disable(void)
> +static inline notrace void arch_local_irq_disable(void)
>  {
>  	arch_local_irq_restore(ARCH_IRQ_DISABLED);
>  }
> @@ -57,7 +59,7 @@ static inline void arch_local_irq_disable(void)
>  
>  /* test hardware interrupt enable bit */
>  #ifndef arch_irqs_disabled
> -static inline int arch_irqs_disabled(void)
> +static inline notrace int arch_irqs_disabled(void)
>  {
>  	return arch_irqs_disabled_flags(arch_local_save_flags());
>  }


