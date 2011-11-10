Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab1KJLOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 06:14:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33109 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab1KJLOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 06:14:49 -0500
Date: Thu, 10 Nov 2011 11:14:46 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] irq: fix possible null-pointer deref irq_domain_to_irq
Message-ID: <20111110111446.GB16018@totoro>
References: <1320922383-15312-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320922383-15312-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:53:03AM +0000, Jamie Iles wrote:
> It is optional for an irqdomain to have a to_irq() method, and for
> simple domains they often don't require any operations at all - just
> hwirq to Linux irq translation.  Check we have valid ops before
> dereferencing them.
> 
> Patch originally by Rob Herring.
> 
> Suggested-by: Rob Herring <robherring2@gmail.com>

Naturally git send-email doesn't know how to convert this into a CC, so 
Rob is now CC'd!

Jamie

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
> 
> Rob, I can't see that you've already posted this but I didn't want to
> hold Marc's GIC patches up.
> 
>  include/linux/irqdomain.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 99834e58..78a1e66 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -74,7 +74,7 @@ struct irq_domain {
>  static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
>  					     unsigned long hwirq)
>  {
> -	if (d->ops->to_irq)
> +	if (d->ops && d->ops->to_irq)
>  		return d->ops->to_irq(d, hwirq);
>  	if (WARN_ON(hwirq < d->hwirq_base))
>  		return 0;
> -- 
> 1.7.4.1
> 
