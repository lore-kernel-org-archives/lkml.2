Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab2AXVim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:38:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54827 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab2AXVik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:38:40 -0500
Message-ID: <4F1F24DD.5030904@gmail.com>
Date: Tue, 24 Jan 2012 15:38:37 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFCv2 03/14] irq_domain: Make irq_domain structure match powerpc's
 irq_host
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca> <1327352870-14687-4-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327352870-14687-4-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 03:07 PM, Grant Likely wrote:
> Part of the series to unify the irq remapping mechanisms in the
> kernel.  A follow up patch will copy the powerpc implementation into
> kernel/irq/irqdomain.c, which will be a lot easier if the structures
> are identical.
> 
> Where they differ, I've chose to use the powerpc names since there is
> a lot more code using those names.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/common/gic.c     |   14 ++++----
>  include/linux/irqdomain.h |   84 ++++++++++++++++++++++++++++++++++-----------
>  kernel/irq/irqdomain.c    |   14 ++++----
>  3 files changed, 78 insertions(+), 34 deletions(-)
> 

snip...

> @@ -126,7 +126,7 @@ void irq_dispose_mapping(unsigned int irq)
>  }
>  EXPORT_SYMBOL_GPL(irq_dispose_mapping);
>  
> -int irq_domain_simple_dt_translate(struct irq_domain *d,
> +int irq_domain_simple_xlate(struct irq_domain *d,
>  			    struct device_node *controller,
>  			    const u32 *intspec, unsigned int intsize,
>  			    unsigned long *out_hwirq, unsigned int *out_type)

This needs a declaration in irqdomain.h (as well as EXPORT?). There
could be others as well, but this is the one I'm using for generic irq chip.

Rob

> @@ -181,7 +181,7 @@ EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
>  
>  struct irq_domain_ops irq_domain_simple_ops = {
>  #ifdef CONFIG_OF_IRQ
> -	.dt_translate = irq_domain_simple_dt_translate,
> +	.xlate = irq_domain_simple_xlate,
>  #endif /* CONFIG_OF_IRQ */
>  };
>  EXPORT_SYMBOL_GPL(irq_domain_simple_ops);

