Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1IHDR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 23:17:56 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:28084 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab1IHDRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 23:17:54 -0400
Message-ID: <4E683413.6010009@snapgear.com>
Date: Thu, 8 Sep 2011 13:18:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@elte.hu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sam Creasey <sammy@sammy.net>, Greg Ungerer <gerg@uclinux.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 12/62] m64k: irq: Remove IRQF_DISABLED
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-13-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1315383059-3673-13-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/11 18:10, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
>
> Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>

Looks ok to me:

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


> ---
>   arch/m68k/include/asm/floppy.h         |    2 +-
>   arch/m68k/include/asm/irq.h            |    4 ++--
>   arch/m68k/include/asm/sun3xflop.h      |    2 +-
>   arch/m68k/platform/68328/timers.c      |    2 +-
>   arch/m68k/platform/68360/config.c      |    2 +-
>   arch/m68k/platform/coldfire/pit.c      |    2 +-
>   arch/m68k/platform/coldfire/sltimers.c |    4 ++--
>   arch/m68k/platform/coldfire/timers.c   |    4 ++--
>   8 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/arch/m68k/include/asm/floppy.h b/arch/m68k/include/asm/floppy.h
> index 697d503..47365b1 100644
> --- a/arch/m68k/include/asm/floppy.h
> +++ b/arch/m68k/include/asm/floppy.h
> @@ -85,7 +85,7 @@ static int fd_request_irq(void)
>   {
>   	if(MACH_IS_Q40)
>   		return request_irq(FLOPPY_IRQ, floppy_hardint,
> -				   IRQF_DISABLED, "floppy", floppy_hardint);
> +				   0, "floppy", floppy_hardint);
>   	else if(MACH_IS_SUN3X)
>   		return sun3xflop_request_irq();
>   	return -ENXIO;
> diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
> index 69ed0d74..35de598 100644
> --- a/arch/m68k/include/asm/irq.h
> +++ b/arch/m68k/include/asm/irq.h
> @@ -60,8 +60,8 @@ struct pt_regs;
>
>   /*
>    * various flags for request_irq() - the Amiga now uses the standard
> - * mechanism like all other architectures - IRQF_DISABLED and
> - * IRQF_SHARED are your friends.
> + * mechanism like all other architectures - IRQF_SHARED etc.
> + * are your friends.
>    */
>   #ifndef MACH_AMIGA_ONLY
>   #define IRQ_FLG_LOCK	(0x0001)	/* handler is not replaceable	*/
> diff --git a/arch/m68k/include/asm/sun3xflop.h b/arch/m68k/include/asm/sun3xflop.h
> index 32c45f8..80f8f9f 100644
> --- a/arch/m68k/include/asm/sun3xflop.h
> +++ b/arch/m68k/include/asm/sun3xflop.h
> @@ -208,7 +208,7 @@ static int sun3xflop_request_irq(void)
>   	if(!once) {
>   		once = 1;
>   		error = request_irq(FLOPPY_IRQ, sun3xflop_hardint,
> -				    IRQF_DISABLED, "floppy", NULL);
> +				    0, "floppy", NULL);
>   		return ((error == 0) ? 0 : -1);
>   	} else return 0;
>   }
> diff --git a/arch/m68k/platform/68328/timers.c b/arch/m68k/platform/68328/timers.c
> index 309f725..d135b26 100644
> --- a/arch/m68k/platform/68328/timers.c
> +++ b/arch/m68k/platform/68328/timers.c
> @@ -69,7 +69,7 @@ static irqreturn_t hw_tick(int irq, void *dummy)
>
>   static struct irqaction m68328_timer_irq = {
>   	.name	 = "timer",
> -	.flags	 = IRQF_DISABLED | IRQF_TIMER,
> +	.flags	 = IRQF_TIMER,
>   	.handler = hw_tick,
>   };
>
> diff --git a/arch/m68k/platform/68360/config.c b/arch/m68k/platform/68360/config.c
> index 9dd5bca..c67f1c3 100644
> --- a/arch/m68k/platform/68360/config.c
> +++ b/arch/m68k/platform/68360/config.c
> @@ -58,7 +58,7 @@ static irqreturn_t hw_tick(int irq, void *dummy)
>
>   static struct irqaction m68360_timer_irq = {
>   	.name	 = "timer",
> -	.flags	 = IRQF_DISABLED | IRQF_TIMER,
> +	.flags	 = IRQF_TIMER,
>   	.handler = hw_tick,
>   };
>
> diff --git a/arch/m68k/platform/coldfire/pit.c b/arch/m68k/platform/coldfire/pit.c
> index c2b9809..c69b71a 100644
> --- a/arch/m68k/platform/coldfire/pit.c
> +++ b/arch/m68k/platform/coldfire/pit.c
> @@ -118,7 +118,7 @@ static irqreturn_t pit_tick(int irq, void *dummy)
>
>   static struct irqaction pit_irq = {
>   	.name	 = "timer",
> -	.flags	 = IRQF_DISABLED | IRQF_TIMER,
> +	.flags	 = IRQF_TIMER,
>   	.handler = pit_tick,
>   };
>
> diff --git a/arch/m68k/platform/coldfire/sltimers.c b/arch/m68k/platform/coldfire/sltimers.c
> index 6a85daf..2168dda 100644
> --- a/arch/m68k/platform/coldfire/sltimers.c
> +++ b/arch/m68k/platform/coldfire/sltimers.c
> @@ -51,7 +51,7 @@ irqreturn_t mcfslt_profile_tick(int irq, void *dummy)
>
>   static struct irqaction mcfslt_profile_irq = {
>   	.name	 = "profile timer",
> -	.flags	 = IRQF_DISABLED | IRQF_TIMER,
> +	.flags	 = IRQF_TIMER,
>   	.handler = mcfslt_profile_tick,
>   };
>
> @@ -91,7 +91,7 @@ static irqreturn_t mcfslt_tick(int irq, void *dummy)
>
>   static struct irqaction mcfslt_timer_irq = {
>   	.name	 = "timer",
> -	.flags	 = IRQF_DISABLED | IRQF_TIMER,
> +	.flags	 = IRQF_TIMER,
>   	.handler = mcfslt_tick,
>   };
>
> diff --git a/arch/m68k/platform/coldfire/timers.c b/arch/m68k/platform/coldfire/timers.c
> index 60242f6..687a38f 100644
> --- a/arch/m68k/platform/coldfire/timers.c
> +++ b/arch/m68k/platform/coldfire/timers.c
> @@ -62,7 +62,7 @@ static irqreturn_t mcftmr_tick(int irq, void *dummy)
>
>   static struct irqaction mcftmr_timer_irq = {
>   	.name	 = "timer",
> -	.flags	 = IRQF_DISABLED | IRQF_TIMER,
> +	.flags	 = IRQF_TIMER,
>   	.handler = mcftmr_tick,
>   };
>
> @@ -150,7 +150,7 @@ irqreturn_t coldfire_profile_tick(int irq, void *dummy)
>
>   static struct irqaction coldfire_profile_irq = {
>   	.name	 = "profile timer",
> -	.flags	 = IRQF_DISABLED | IRQF_TIMER,
> +	.flags	 = IRQF_TIMER,
>   	.handler = coldfire_profile_tick,
>   };
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
