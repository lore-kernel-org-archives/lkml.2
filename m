Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0HZTBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:01:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42962 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab0HZTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:01:39 -0400
Message-ID: <4C76B9E1.4080500@mvista.com>
Date: Thu, 26 Aug 2010 23:00:49 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Adam Jiang <jiang.adam@gmail.com>
CC: ralf@linux-mips.org, dmitri.vorobiev@movial.com, wuzhangjin@gmail.com,
        ddaney@caviumnetworks.com, peterz@infradead.org, fweisbec@gmail.com,
        tj@kernel.org, linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: irq: add stackoverflow detection
References: <linux-mips@linux-mips.org> <1282828755-11953-1-git-send-email-jiang.adam@gmail.com>
In-Reply-To: <1282828755-11953-1-git-send-email-jiang.adam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adam Jiang wrote:

> Add stackoverflow detection to mips arch

[...]

> diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
> index c6345f5..8fdf79e 100644
> --- a/arch/mips/kernel/irq.c
> +++ b/arch/mips/kernel/irq.c
> @@ -151,6 +151,25 @@ void __init init_IRQ(void)
>  #endif
>  }
>  
> +#ifdef DEBUG_STACKOVERFLOW
> +static inline void check_stack_overflow(void)
> +{
> +	long sp;
> +
> +	asm volatile("move %0, $sp" : "=r" (sp));
> +	sp = sp & (THREAD_SIZE-1);
> +
> +	/* check for stack overflow: is there less than 2KB free? */
> +	if (unlikely(sp < (sizeof(struct thread_info) + 2048))) {
> +		printk("do_IRQ: stack overflow: %ld\n",
> +		       sp - sizeof(struct thread_info));
> +		dump_stack();
> +	}
> +}
> +#else
> +static inline void check_stack_overflow(void) {}
> +#endif
> +
>  /*
>   * do_IRQ handles all normal device IRQ's (the special
>   * SMP cross-CPU interrupts have their own specific

    You've dropped call check_stack_overflow() call in do_IRQ() -- was that 
intentional?

WBR, Sergei
