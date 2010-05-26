Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0EZOmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:42:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab0EZOmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:42:47 -0400
X-Authority-Analysis: v=1.1 cv=Pm0qIGCwx3bIEOZlSg1a56K3RSwKBTW9sPEb+DFvEKk= c=1 sm=0 a=Fogt7QVrsnkA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=QOK98sIafIcOtSQcZ58A:9 a=3orryk4UL8xHO3CCiYUgLzqTECwA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead
 local_irq_save/restore
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, michal.simek@petalogix.com, arnd@arndb.de,
       john.williams@petalogix.com, tglx@linutronix.de,
       akpm@linux-foundation.org, peter.fritzsche@gmx.de, anton@samba.org,
       mingo@elte.hu
In-Reply-To: <1274863724-14906-2-git-send-email-monstr@monstr.eu>
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu>
	 <1274863724-14906-2-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 26 May 2010 10:42:43 -0400
Message-ID: <1274884963.22648.245.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 10:48 +0200, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> start/stop_critical_timing function for preemptirqsoff, preemptoff
> and irqsoff tracers contains atomic_inc and atomic_dec operations.
> 
> Atomic operations used local_irq_save/restore macros to ensure
> atomic access but they are traced by the same function which is causing
> recursion problem.
> 
> The reason is when these tracers are turn ON then local_irq_save/restore
> macros are changed in include/linux/irqflags.h to call trace_hardirqs_on/off
> which call start/stop_critical_timing.
> 
> Microblaze was affected because use generic atomic implementation.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  include/asm-generic/atomic.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
> index 058129e..6c190fd 100644
> --- a/include/asm-generic/atomic.h
> +++ b/include/asm-generic/atomic.h
> @@ -57,11 +57,11 @@ static inline int atomic_add_return(int i, atomic_t *v)
>  	unsigned long flags;
>  	int temp;
>  
> -	local_irq_save(flags);
> +	raw_local_irq_save(flags);
>  	temp = v->counter;
>  	temp += i;
>  	v->counter = temp;
> -	local_irq_restore(flags);
> +	raw_local_irq_restore(flags);
>  
>  	return temp;
>  }
> @@ -78,11 +78,11 @@ static inline int atomic_sub_return(int i, atomic_t *v)
>  	unsigned long flags;
>  	int temp;
>  
> -	local_irq_save(flags);
> +	raw_local_irq_save(flags);
>  	temp = v->counter;
>  	temp -= i;
>  	v->counter = temp;
> -	local_irq_restore(flags);
> +	raw_local_irq_restore(flags);
>  
>  	return temp;
>  }
> @@ -135,9 +135,9 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
>  	unsigned long flags;
>  
>  	mask = ~mask;
> -	local_irq_save(flags);
> +	raw_local_irq_save(flags);
>  	*addr &= mask;
> -	local_irq_restore(flags);
> +	raw_local_irq_restore(flags);
>  }
>  
>  #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))


