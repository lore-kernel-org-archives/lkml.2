Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab1ITVlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:41:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:46519 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1ITVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:41:04 -0400
Date: Tue, 20 Sep 2011 23:41:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irq/irqdomain: change bail out condition for
 irq_domain_add()
In-Reply-To: <1316554589-24393-1-git-send-email-bigeasy@linutronix.de>
Message-ID: <alpine.LFD.2.02.1109202340060.2723@ionos>
References: <1316554589-24393-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Sebastian Andrzej Siewior wrote:

> I tried to convert x86 to this infrastructure and I run into
> |BUG: unable to handle kernel NULL pointer dereference at 00000014
> 
> (d || d->domain) is kinda bogus because if d is NULL it will check for
> d->domain which should fail. It seems that the code needs the irq_data
> to be present and there should be no irq_domain set yet. This patch does
> this.
> 
> My convert to this infrastructure still does not work with this patch
> but I have enough for today.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  kernel/irq/irqdomain.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index d5828da..213089b 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -29,7 +29,7 @@ void irq_domain_add(struct irq_domain *domain)
>  	 */
>  	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
>  		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
> -		if (d || d->domain) {
> +		if (!d || d->domain) {
>  			/* things are broken; just report, don't clean up */
>  			WARN(1, "error: irq_desc already assigned to a domain");
>  			return;

I've already queued a similar fix in tip/irq/urgent

Thanks,

	tglx
