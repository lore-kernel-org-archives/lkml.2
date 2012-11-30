Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2K3JCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:02:53 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36871 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab2K3JCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:02:50 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irqdomain: stop screaming about preallocated irqdescs
To: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1353975632-1327-1-git-send-email-linus.walleij@stericsson.com>
References: <1353975632-1327-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 30 Nov 2012 09:02:46 +0000
Message-Id: <20121130090246.59F733E070C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012 01:20:32 +0100, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> In the simple irqdomain: don't shout warnings to the user,
> there is no point. An informational print is sufficient.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.

> ---
>  kernel/irq/irqdomain.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 4e69e24..96f3a1d 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -177,8 +177,8 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
>  			irq_base = irq_alloc_descs(first_irq, first_irq, size,
>  						   of_node_to_nid(of_node));
>  			if (irq_base < 0) {
> -				WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
> -				     first_irq);
> +				pr_info("Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
> +					first_irq);
>  				irq_base = first_irq;
>  			}
>  		} else
> -- 
> 1.7.11.3
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
