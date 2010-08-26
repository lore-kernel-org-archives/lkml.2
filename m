Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0HZI3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 04:29:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35767 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0HZI3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 04:29:09 -0400
Message-ID: <4C762572.4070509@mvista.com>
Date: Thu, 26 Aug 2010 12:27:30 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Adam Jiang <jiang.adam@gmail.com>
CC: ralf@linux-mips.org, dmitri.vorobiev@movial.com, wuzhangjin@gmail.com,
        ddaney@caviumnetworks.com, peterz@infradead.org, fweisbec@gmail.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mips: irq: add stackoverflow detection
References: <linux-kernel@vger.kernel.org> <1282794933-20639-1-git-send-email-jiang.adam@gmail.com>
In-Reply-To: <1282794933-20639-1-git-send-email-jiang.adam@gmail.com>
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
> index c6345f5..75c584d 100644
> --- a/arch/mips/kernel/irq.c
> +++ b/arch/mips/kernel/irq.c
> @@ -151,6 +151,25 @@ void __init init_IRQ(void)
>  #endif
>  }
>  
> +#ifdef CONFIG_DEBUG_STACKOVERFLOW
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
> +static inline void check_stack_overflow(void)

    You didn't even try to compile with the option disabled -- you've missed {}.

> +#endif
> +
>  /*
>   * do_IRQ handles all normal device IRQ's (the special
>   * SMP cross-CPU interrupts have their own specific

WBR, Sergei
