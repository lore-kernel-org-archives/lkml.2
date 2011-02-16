Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab1BPJZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:25:43 -0500
Received: from www.tglx.de ([62.245.132.106]:32890 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab1BPJZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:25:39 -0500
Date: Wed, 16 Feb 2011 10:25:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: Re: [PATCHv2 10/11] unicore32 core architecture: interrupts ang gpio
 handling
In-Reply-To: <02f501cbcb49$015b8fa0$0412aee0$@mprc.pku.edu.cn>
Message-ID: <alpine.LFD.2.00.1102161020470.26192@localhost6.localdomain6>
References: <02f501cbcb49$015b8fa0$0412aee0$@mprc.pku.edu.cn>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Feb 2011, Guan Xuetao wrote:
> +
> +#ifndef __ASSEMBLY__
> +struct irqaction;

Why do you need that ?

> +struct pt_regs;
> +extern void migrate_irqs(void);

What's that for ? Used nowhere AFAICT

> +extern void asm_do_IRQ(unsigned int, struct pt_regs *);
> +
> +#endif

> +static struct irq_chip puv3_low_gpio_chip = {
> +	.name		= "GPIO-low",
> +	.ack		= puv3_low_gpio_ack,

Please use irq_* functions. These are deprecated and going away soon.

> +	.mask		= puv3_low_gpio_mask,
> +	.unmask		= puv3_low_gpio_unmask,
> +	.set_type	= puv3_gpio_type,
> +	.set_wake	= puv3_low_gpio_wake,
> +};
> +
> +static struct irq_chip puv3_normal_chip = {
> +	.name		= "PKUnity-v3",
> +	.ack		= puv3_mask_irq,
> +	.mask		= puv3_mask_irq,
> +	.unmask		= puv3_unmask_irq,
> +	.set_wake	= puv3_set_wake,
> +};

  Ditto

Thanks,

	tglx
