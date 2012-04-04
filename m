Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab2DDLvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:51:07 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:63071 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2DDLvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:51:05 -0400
Message-ID: <4F7C34E5.1050309@snapgear.com>
Date: Wed, 4 Apr 2012 21:47:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        sparclinux <sparclinux@vger.kernel.org>
Subject: Re: [PATCH] irq: remove obsolete definitions in interrupt.h
References: <20120404074553.GA14959@merkur.ravnborg.org>
In-Reply-To: <20120404074553.GA14959@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 05:45 PM, Sam Ravnborg wrote:
> interrupt.h contained a small fixlet for the days when
> m68k and sparc32 did not use genirq.
> As they have both entered the modern world this
> fixlet can be dropped.
>
> Signed-off-by: Sam Ravnborg<sam@ravnborg.org>
> Cc: Geert Uytterhoeven<geert@linux-m68k.org>
> Cc: Greg Ungerer<gerg@uclinux.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> Cc: "David S. Miller"<davem@davemloft.net>
> ---
>
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 2aea5d2..3848176 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -122,7 +122,6 @@ struct irqaction {
>
>   extern irqreturn_t no_action(int cpl, void *dev_id);
>
> -#ifdef CONFIG_GENERIC_HARDIRQS
>   extern int __must_check
>   request_threaded_irq(unsigned int irq, irq_handler_t handler,
>   		     irq_handler_t thread_fn,
> @@ -144,42 +143,6 @@ request_percpu_irq(unsigned int irq, irq_handler_t handler,
>   		   const char *devname, void __percpu *percpu_dev_id);
>
>   extern void exit_irq_thread(void);
> -#else
> -
> -extern int __must_check
> -request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
> -	    const char *name, void *dev);
> -
> -/*
> - * Special function to avoid ifdeffery in kernel/irq/devres.c which
> - * gets magically built by GENERIC_HARDIRQS=n architectures (sparc,
> - * m68k). I really love these $@%#!* obvious Makefile references:
> - * ../../../kernel/irq/devres.o
> - */
> -static inline int __must_check
> -request_threaded_irq(unsigned int irq, irq_handler_t handler,
> -		     irq_handler_t thread_fn,
> -		     unsigned long flags, const char *name, void *dev)
> -{
> -	return request_irq(irq, handler, flags, name, dev);
> -}
> -
> -static inline int __must_check
> -request_any_context_irq(unsigned int irq, irq_handler_t handler,
> -			unsigned long flags, const char *name, void *dev_id)
> -{
> -	return request_irq(irq, handler, flags, name, dev_id);
> -}
> -
> -static inline int __must_check
> -request_percpu_irq(unsigned int irq, irq_handler_t handler,
> -		   const char *devname, void __percpu *percpu_dev_id)
> -{
> -	return request_irq(irq, handler, 0, devname, percpu_dev_id);
> -}
> -
> -static inline void exit_irq_thread(void) { }
> -#endif
>
>   extern void free_irq(unsigned int, void *);
>   extern void free_percpu_irq(unsigned int, void __percpu *);
>
>
>
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
