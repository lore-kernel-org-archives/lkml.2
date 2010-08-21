Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0HUNKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 09:10:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65102 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0HUNKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 09:10:01 -0400
Message-ID: <4C6FCFC7.7020903@mvista.com>
Date: Sat, 21 Aug 2010 17:08:23 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: jiang.adam@gmail.com
CC: ralf@linux-mips.org, dmitri.vorobiev@movial.com, wuzhangjin@gmail.com,
        ddaney@caviumnetworks.com, peterz@infradead.org, fweisbec@gmail.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: irq: add statckoverflow detection
References: <1282372293-30211-1-git-send-email-jiang.adam@gmail.com>
In-Reply-To: <1282372293-30211-1-git-send-email-jiang.adam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

jiang.adam@gmail.com wrote:

> From: Adam Jiang <jiang.adam@gmail.com>

> Add stackoverflow detection to mips arch

> Signed-off-by: Adam Jiang <jiang.adam@gmail.com>
[...]
> diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
> index c6345f5..6334037 100644
> --- a/arch/mips/kernel/irq.c
> +++ b/arch/mips/kernel/irq.c
> @@ -151,6 +151,22 @@ void __init init_IRQ(void)
>  #endif
>  }
>  
> +static inline void check_stack_overflow(void)
> +{
> +#ifdef CONFIG_DEBUG_STACKOVERFLOW

    #ifdef within function is considered bad style. Better do it this way:

#ifdef CONFIG_DEBUG_STACKOVERFLOW
static inline void check_stack_overflow(void)
{
[...]
}
#else
static inline void check_stack_overflow(void) {}
#endif

> +	long sp;
> +
> +	asm volatile("move %0, $sp" : "=r" (sp));
> +	sp = sp & (THREAD_SIZE-1);
> +
> +	/* check for stack overflow: is there less then 2KB free? */

    Hm, 2KB seems pretty large margin...

WBR, Sergei
