Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1LAPSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:18:50 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61487 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1LAPSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:18:49 -0500
Message-ID: <4ED79AD6.2000103@gmail.com>
Date: Thu, 01 Dec 2011 09:18:46 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irqdomain: export irq_domain_simple_ops for !CONFIG_OF
References: <1322734529-30018-1-git-send-email-jamie@jamieiles.com>
In-Reply-To: <1322734529-30018-1-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 04:15 AM, Jamie Iles wrote:
> irqdomain support is used in interrupt controller drivers that may not
> have device tree support but only need the basic HW->Linux irq
> translation.  Rather than having each of these implement their own IRQ
> domain, allow them to use the simple ops.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rob Herring <robherring2@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---

Acked-by: Rob Herring <robherring2@gmail.com>

>  include/linux/irqdomain.h |    3 ++-
>  kernel/irq/irqdomain.c    |   12 +++++++-----
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 99834e58..bd4272b 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -91,10 +91,11 @@ static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
>  
>  extern void irq_domain_add(struct irq_domain *domain);
>  extern void irq_domain_del(struct irq_domain *domain);
> +
> +extern struct irq_domain_ops irq_domain_simple_ops;
>  #endif /* CONFIG_IRQ_DOMAIN */
>  
>  #if defined(CONFIG_IRQ_DOMAIN) && defined(CONFIG_OF_IRQ)
> -extern struct irq_domain_ops irq_domain_simple_ops;
>  extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
>  extern void irq_domain_generate_simple(const struct of_device_id *match,
>  					u64 phys_base, unsigned int irq_start);
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 200ce83..7ca523b 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -143,11 +143,6 @@ int irq_domain_simple_dt_translate(struct irq_domain *d,
>  	return 0;
>  }
>  
> -struct irq_domain_ops irq_domain_simple_ops = {
> -	.dt_translate = irq_domain_simple_dt_translate,
> -};
> -EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
> -
>  /**
>   * irq_domain_create_simple() - Set up a 'simple' translation range
>   */
> @@ -182,3 +177,10 @@ void irq_domain_generate_simple(const struct of_device_id *match,
>  }
>  EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
>  #endif /* CONFIG_OF_IRQ */
> +
> +struct irq_domain_ops irq_domain_simple_ops = {
> +#ifdef CONFIG_OF_IRQ
> +	.dt_translate = irq_domain_simple_dt_translate,
> +#endif /* CONFIG_OF_IRQ */
> +};
> +EXPORT_SYMBOL_GPL(irq_domain_simple_ops);

