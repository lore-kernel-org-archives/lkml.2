Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1AKXsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:48:17 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58013 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab1AKXsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:48:15 -0500
Date: Tue, 11 Jan 2011 16:48:08 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 09/15] x86/dtb: Add generic bus probe
Message-ID: <20110111234808.GF2131@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-10-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292600033-12271-10-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:33:47PM +0100, Sebastian Andrzej Siewior wrote:
> For now we probe these busses and we change is to board dependent probes
> once we have to.
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  arch/x86/kernel/prom.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
> index a449dc6..6eddafd 100644
> --- a/arch/x86/kernel/prom.c
> +++ b/arch/x86/kernel/prom.c
> @@ -105,6 +105,25 @@ void __init add_dtb(u64 data)
>  	initial_dtb = data + offsetof(struct setup_data, data);
>  }
>  
> +/*
> + * CE4100 ids. Will be moved to machine_device_initcall() once we have it.
> + */
> +static struct of_device_id __initdata ce4100_ids[] = {
> +	{ .type = "soc", },
> +	{ .compatible = "isa", },
> +	{ .compatible = "pci", },
> +	{},
> +};
> +
> +static int __init add_bus_probe(void)
> +{
> +	if (!initial_boot_params)
> +		return 0;
> +
> +	return of_platform_bus_probe(NULL, ce4100_ids, NULL);
> +}
> +module_init(add_bus_probe);
> +
>  static int x86_of_pci_irq_enable(struct pci_dev *dev)
>  {
>  	struct of_irq oirq;
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
