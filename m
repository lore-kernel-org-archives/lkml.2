Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2DRWXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:23:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:54236 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab2DRWXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:23:21 -0400
Message-ID: <1334787792.3143.19.camel@pasglop>
Subject: Re: [PATCH] irqdomain: print a warning if domains contain IRQ 0
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 19 Apr 2012 08:23:12 +1000
In-Reply-To: <1334756420-12019-1-git-send-email-linus.walleij@stericsson.com>
References: <1334756420-12019-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 15:40 +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Some of the clients using IRQ domains from the ARM VIC
> (arch/arm/common/vic.c) don't know that their (hardware) IRQ 0
> is silently ignored by the IRQ core, they will just notice
> that they're not getting this IRQ anymore. So print a warning
> if a domain contains IRQ 0 (NO_IRQ) so we get some noise about
> it atleast.

I don't understand. HW IRQ 0 is not ignored and works perfectly
fine on "normal" remapped domains. Or is this specific to "legacy
domains" ? In this case pls make it clear in the subject :-)

Cheers,
Ben.

> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  kernel/irq/irqdomain.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 0e0ba5f..1444454 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -136,8 +136,10 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
>  		int hwirq = first_hwirq + i;
>  
>  		/* IRQ0 gets ignored */
> -		if (!irq)
> +		if (!irq) {
> +			pr_warn("trying to register IRQ 0 (NO_IRQ) in an irq  domain\n");
>  			continue;
> +		}
>  
>  		/* Legacy flags are left to default at this point,
>  		 * one can then use irq_create_mapping() to


