Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1JaQXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 12:23:52 -0400
Received: from portal.weinmann.de ([62.8.140.122]:17182 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1JaQXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 12:23:51 -0400
X-Greylist: delayed 796 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Oct 2011 12:23:50 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'lkml'" <linux-kernel@vger.kernel.org>
CC: "'John Stultz'" <john.stultz@linaro.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>
Date: Mon, 31 Oct 2011 17:23:40 +0100
Subject: RE: [PATCH 1/8] clocksource: Convert tcb_clksrc to use
 clocksource_register_hz/khz
Thread-Topic: [PATCH 1/8] clocksource: Convert tcb_clksrc to use
 clocksource_register_hz/khz
Thread-Index: AcyTQU65THLzLSqFQhuPCqXIYWtWyQEp47Pw
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B34BE57@wm021.weinmann.com>
References: <1319566096-3222-1-git-send-email-y>
In-Reply-To: <1319566096-3222-1-git-send-email-y>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: y@kernel.beaverton.ibm.com [mailto:y@kernel.beaverton.ibm.com]
> Sent: Tuesday, October 25, 2011 8:08 PM
> To: lkml
> Cc: John Stultz; Voss, Nikolaus; Thomas Gleixner
> Subject: [PATCH 1/8] clocksource: Convert tcb_clksrc to use
> clocksource_register_hz/khz
> 
> From: John Stultz <john.stultz@linaro.org>
> 
> Convert tcb_clksrc to use clocksource_register_hz.
> 
> Untested. Help from maintainers would be appreciated.
> 
> CC: Nikolaus Voss <n.voss@weinmann.de>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/clocksource/tcb_clksrc.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clocksource/tcb_clksrc.c
> b/drivers/clocksource/tcb_clksrc.c
> index 79c47e8..55d0f95 100644
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -59,7 +59,6 @@ static struct clocksource clksrc = {
>  	.rating         = 200,
>  	.read           = tc_get_cycles,
>  	.mask           = CLOCKSOURCE_MASK(32),
> -	.shift          = 18,
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
> 
> @@ -256,7 +255,6 @@ static int __init tcb_clksrc_init(void)
>  		best_divisor_idx = i;
>  	}
> 
> -	clksrc.mult = clocksource_hz2mult(divided_rate, clksrc.shift);
> 
>  	printk(bootinfo, clksrc.name, CONFIG_ATMEL_TCB_CLKSRC_BLOCK,
>  			divided_rate / 1000000,
> @@ -292,7 +290,7 @@ static int __init tcb_clksrc_init(void)
>  	__raw_writel(ATMEL_TC_SYNC, tcaddr + ATMEL_TC_BCR);
> 
>  	/* and away we go! */
> -	clocksource_register(&clksrc);
> +	clocksource_register_hz(&clksrc, divided_rate);
> 
>  	/* channel 2:  periodic and oneshot timer support */
>  	setup_clkevents(tc, clk32k_divisor_idx);
> --
> 1.7.3.2.146.gca209

This works on my G45 system.

Acked-by: Nikolaus Voss <n.voss@weinmann.de>

