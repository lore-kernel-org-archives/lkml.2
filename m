Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1LBNpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:45:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35851 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab1LBNpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 08:45:03 -0500
Date: Fri, 2 Dec 2011 13:44:58 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] irqdomain: protect macro variable in domain iterators
Message-ID: <20111202134458.GD2892@localhost.localdomain>
References: <1322833997-32083-1-git-send-email-nicolas.ferre@atmel.com>
 <1322832609-24956-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322832609-24956-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 02:30:09PM +0100, Nicolas Ferre wrote:
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Looks OK to me:

Acked-by: Dave Martin <dave.martin@linaro.org>

> ---
> v2: add brackets to each macro variable.
> 
>  include/linux/irqdomain.h |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index bd4272b..e535063 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -82,12 +82,14 @@ static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
>  }
>  
>  #define irq_domain_for_each_hwirq(d, hw) \
> -	for (hw = d->hwirq_base; hw < d->hwirq_base + d->nr_irq; hw++)
> +	for ((hw) = (d)->hwirq_base; \
> +	     (hw) < (d)->hwirq_base + (d)->nr_irq; \
> +	     (hw)++)
>  
>  #define irq_domain_for_each_irq(d, hw, irq) \
> -	for (hw = d->hwirq_base, irq = irq_domain_to_irq(d, hw); \
> -	     hw < d->hwirq_base + d->nr_irq; \
> -	     hw++, irq = irq_domain_to_irq(d, hw))
> +	for ((hw) = (d)->hwirq_base, (irq) = irq_domain_to_irq((d), (hw)); \
> +	     (hw) < (d)->hwirq_base + (d)->nr_irq; \
> +	     (hw)++, (irq) = irq_domain_to_irq((d), (hw)))
>  
>  extern void irq_domain_add(struct irq_domain *domain);
>  extern void irq_domain_del(struct irq_domain *domain);
> -- 
> 1.7.5.4
> 
