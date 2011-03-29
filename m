Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1C2OJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:09:55 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:38885 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab1C2OJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:09:54 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>
References: <20110325142344.058372664@linutronix.de> <20110325142511.639954930@linutronix.de>
In-Reply-To: <20110325142511.639954930@linutronix.de>
Subject: RE: [patch 1/2] unicore32: Convert to new irq function names
Date: Tue, 29 Mar 2011 22:09:44 +0800
Message-ID: <019501cbee1a$f4868c90$dd93a5b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEqwHQoTzbgKMZbeAtd7l1GSN8fHQHmWU/7lXeCD5A=
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
> Subject: [patch 1/2] unicore32: Convert to new irq function names
> 
> Scripted with coccinelle.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/unicore32/kernel/irq.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6-tip/arch/unicore32/kernel/irq.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/unicore32/kernel/irq.c
> +++ linux-2.6-tip/arch/unicore32/kernel/irq.c
> @@ -321,24 +321,24 @@ void __init init_IRQ(void)
>  	writel(1, INTC_ICCR);
> 
>  	for (irq = 0; irq < IRQ_GPIOHIGH; irq++) {
> -		set_irq_chip(irq, &puv3_low_gpio_chip);
> -		set_irq_handler(irq, handle_edge_irq);
> +		irq_set_chip(irq, &puv3_low_gpio_chip);
> +		irq_set_handler(irq, handle_edge_irq);
>  		irq_modify_status(irq,
>  			IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN,
>  			0);
>  	}
> 
>  	for (irq = IRQ_GPIOHIGH + 1; irq < IRQ_GPIO0; irq++) {
> -		set_irq_chip(irq, &puv3_normal_chip);
> -		set_irq_handler(irq, handle_level_irq);
> +		irq_set_chip(irq, &puv3_normal_chip);
> +		irq_set_handler(irq, handle_level_irq);
>  		irq_modify_status(irq,
>  			IRQ_NOREQUEST | IRQ_NOAUTOEN,
>  			IRQ_NOPROBE);
>  	}
> 
>  	for (irq = IRQ_GPIO0; irq <= IRQ_GPIO27; irq++) {
> -		set_irq_chip(irq, &puv3_high_gpio_chip);
> -		set_irq_handler(irq, handle_edge_irq);
> +		irq_set_chip(irq, &puv3_high_gpio_chip);
> +		irq_set_handler(irq, handle_edge_irq);
>  		irq_modify_status(irq,
>  			IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN,
>  			0);
> @@ -347,8 +347,8 @@ void __init init_IRQ(void)
>  	/*
>  	 * Install handler for GPIO 0-27 edge detect interrupts
>  	 */
> -	set_irq_chip(IRQ_GPIOHIGH, &puv3_normal_chip);
> -	set_irq_chained_handler(IRQ_GPIOHIGH, puv3_gpio_handler);
> +	irq_set_chip(IRQ_GPIOHIGH, &puv3_normal_chip);
> +	irq_set_chained_handler(IRQ_GPIOHIGH, puv3_gpio_handler);
> 
>  #ifdef CONFIG_PUV3_GPIO
>  	puv3_init_gpio();

