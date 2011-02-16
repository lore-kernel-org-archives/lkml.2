Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1BPWEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:04:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63529 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1BPWEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:04:07 -0500
Date: Wed, 16 Feb 2011 15:04:01 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: sodaville@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 TIP 09/14] x86/dtb: Add generic bus probe
Message-ID: <20110216220401.GF22837@angua.secretlab.ca>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-10-git-send-email-bigeasy@linutronix.de>
 <20110204102152.GA7231@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204102152.GA7231@www.tglx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 11:21:52AM +0100, Sebastian Andrzej Siewior wrote:
> For now we probe these busses and we change is to board dependent probes
> once we have to.
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Historically for embedded platforms we leave calling
of_platform_bus_probe() to the bsp code so that weird boards can still
do weird stuff on the probe order.  However, I'm all for making more
code common, so we can start with this and switch to per-board (or
per-SoC) calls only if it becomes necessary.

g.


> ---
> 
>  renamed -immr to -cp
> 
>  arch/x86/kernel/prom.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
> index 8525ca0..3eaab43 100644
> --- a/arch/x86/kernel/prom.c
> +++ b/arch/x86/kernel/prom.c
> @@ -102,6 +102,25 @@ void __init add_dtb(u64 data)
>  	initial_dtb = data + offsetof(struct setup_data, data);
>  }
>  
> +/*
> + * CE4100 ids. Will be moved to machine_device_initcall() once we have it.
> + */
> +static struct of_device_id __initdata ce4100_ids[] = {
> +	{ .compatible = "intel,ce4100-cp", },
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
>  #ifdef CONFIG_PCI
>  static int x86_of_pci_irq_enable(struct pci_dev *dev)
>  {
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
