Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab1INQo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:44:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:42343 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1INQo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:44:57 -0400
Date: Wed, 14 Sep 2011 18:44:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rob Herring <robherring2@gmail.com>
cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        marc.zyngier@arm.com, thomas.abraham@linaro.org, jamie@jamieiles.com,
        b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/5] irq: fix existing domain check in irq_domain_add
In-Reply-To: <1316017900-19918-3-git-send-email-robherring2@gmail.com>
Message-ID: <alpine.LFD.2.02.1109141838510.2723@ionos>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-3-git-send-email-robherring2@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011, Rob Herring wrote:

> From: Rob Herring <rob.herring@calxeda.com>
> 
> irq_data will normally exist, so the domain was prevented from being set.
> The simple domain code did not hit this as nr_irq is always 0.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Gleixner <tglx@linutronix.de>

I take this and 1/5 through irq/urgent

Thanks,

	tglx

> ---
>  kernel/irq/irqdomain.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index d5828da..84f4110 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -29,7 +29,7 @@ void irq_domain_add(struct irq_domain *domain)
>  	 */
>  	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
>  		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
> -		if (d || d->domain) {
> +		if (d && d->domain) {
>  			/* things are broken; just report, don't clean up */
>  			WARN(1, "error: irq_desc already assigned to a domain");
>  			return;
> -- 
> 1.7.5.4
> 
> 
