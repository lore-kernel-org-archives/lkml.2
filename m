Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2BPGDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 01:03:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50674 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2BPGDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 01:03:42 -0500
Date: Wed, 15 Feb 2012 22:03:35 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 24/25] irq_domain: remove "hint" when allocating irq
 numbers
Message-ID: <20120216060334.GA11758@r65073-Latitude-D630>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-25-git-send-email-grant.likely@secretlab.ca>
 <4F316848.4060100@atmel.com>
 <4F3BC97C.6030203@atmel.com>
 <20120215202145.GH25779@ponder.secretlab.ca>
 <20120215215001.GA30946@r65073-Latitude-D630>
 <20120216053243.GM25779@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216053243.GM25779@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 10:32:43PM -0700, Grant Likely wrote:
...
> That's a bug then.  The implementation should work without patch 24.  Does
> this patch fix it?
> 
Yes, it fixes the problem for me.

Regards,
Shawn

> ---
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 2c1d6f8..2d3dfff 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -516,8 +516,8 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>  		return irq_domain_legacy_revmap(domain, hwirq);
>  
>  	/* Slow path does a linear search of the map */
> -	if (hint < NUM_ISA_INTERRUPTS)
> -		hint = NUM_ISA_INTERRUPTS;
> +	if (hint == 0)
> +		hint = 1;
>  	i = hint;
>  	do {
>  		struct irq_data *data = irq_get_irq_data(i);
> @@ -525,7 +525,7 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>  			return i;
>  		i++;
>  		if (i >= irq_virq_count)
> -			i = NUM_ISA_INTERRUPTS;
> +			i = 1
>  	} while(i != hint);
>  	return 0;
>  }
> 
