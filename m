Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2ESGe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:34:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58304 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750827Ab2ESGe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:34:56 -0400
Message-ID: <1337409295.10521.4.camel@joe2Laptop>
Subject: Re: [PATCH 7/8] irqdomain: trivial pr_fmt conversion.
From: Joe Perches <joe@perches.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 May 2012 23:34:55 -0700
In-Reply-To: <1337407908-7421-8-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
	 <1337407908-7421-8-git-send-email-lethal@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-19 at 15:11 +0900, Paul Mundt wrote:
> Convert to pr_fmt before things start to get out of hand and some
> janitors start getting overly excited.

;)  OK then, here's some trivia:

> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
[]
> @@ -1,3 +1,5 @@
> +#define pr_fmt(fmt)  "irq: " fmt

"irqdomain: " (KBUILD_MODNAME) may be more sensible

[]
> @@ -410,23 +412,23 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
>  	unsigned int hint;
>  	int virq;
>  
> -	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
> +	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);

"%s: ...", __func__, etc...

>  	if (domain == NULL) {
> -		printk(KERN_WARNING "irq_create_mapping called for"
> -		       " NULL domain, hwirq=%lx\n", hwirq);
> +		pr_warning("irq_create_mapping called for"
> +			   " NULL domain, hwirq=%lx\n", hwirq);

		pr_warn("%s: called with NULL domain, hwirq=%lx\n", hwirq);

> @@ -522,8 +524,8 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
>  		if (intsize > 0)
>  			return intspec[0];
>  #endif
> -		printk(KERN_WARNING "irq: no irq domain found for %s !\n",
> -		       controller->full_name);
> +		pr_warning("no irq domain found for %s !\n",
> +			   controller->full_name);

		pr_warn(...)

