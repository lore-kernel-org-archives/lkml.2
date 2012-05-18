Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753Ab2ERWke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:40:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46434 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab2ERWkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:40:32 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: mpc8xxx: Prevent NULL pointer deref in demux handler
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Felix Radensky <felix@embedded-sol.com>,
        Thomas Wucher <thwucher@linutronix.de>,
        Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <alpine.LFD.2.02.1205031219320.6271@ionos>
References: <alpine.LFD.2.02.1205031207050.6271@ionos> <alpine.LFD.2.02.1205031219320.6271@ionos>
Date: Fri, 18 May 2012 16:40:29 -0600
Message-Id: <20120518224029.321113E07C8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012 12:22:06 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> This time with the correct CC of the reporter :)

Applied, thanks.

g.

> 
> -------------->
> Subject: gpio: mpc8xxx: Prevent NULL pointer deref in demux handler
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Thu, 03 May 2012 11:58:09 +0200
> 
> commit cfadd838(powerpc/8xxx: Fix interrupt handling in MPC8xxx GPIO
> driver) added an unconditional call of chip->irq_eoi() to the demux
> handler.
> 
> This leads to a NULL pointer derefernce on MPC512x platforms which use
> this driver as well.
> 
> Make it conditional.
> 
> Reported-by: Thomas Wucher <thwucher@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Felix Radensky <felix@embedded-sol.com>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpio/gpio-mpc8xxx.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/gpio/gpio-mpc8xxx.c
> ===================================================================
> --- linux-2.6.orig/drivers/gpio/gpio-mpc8xxx.c
> +++ linux-2.6/drivers/gpio/gpio-mpc8xxx.c
> @@ -163,7 +163,8 @@ static void mpc8xxx_gpio_irq_cascade(uns
>  	if (mask)
>  		generic_handle_irq(irq_linear_revmap(mpc8xxx_gc->irq,
>  						     32 - ffs(mask)));
> -	chip->irq_eoi(&desc->irq_data);
> +	if (chip->irq_eoi)
> +		chip->irq_eoi(&desc->irq_data);
>  }
>  
>  static void mpc8xxx_irq_unmask(struct irq_data *d)

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
