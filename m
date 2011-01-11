Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab1AKW0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:26:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42434 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab1AKW0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:26:10 -0500
Date: Tue, 11 Jan 2011 15:26:07 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 06/15] x86/dtb: add support hpet
Message-ID: <20110111222607.GC2131@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-7-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292600033-12271-7-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:33:44PM +0100, Sebastian Andrzej Siewior wrote:
> Set hpet_address based on information provied form DTB
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  arch/x86/kernel/prom.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
> index 9cbb52b..40ad8c0 100644
> --- a/arch/x86/kernel/prom.c
> +++ b/arch/x86/kernel/prom.c
> @@ -10,6 +10,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/slab.h>
>  
> +#include <asm/hpet.h>
>  #include <asm/irq_controller.h>
>  #include <asm/io_apic.h>
>  
> @@ -101,6 +102,23 @@ void __init add_dtb(u64 data)
>  	initial_dtb = data + offsetof(struct setup_data, data);
>  }
>  
> +static void __init dtb_setup_hpet(void)
> +{
> +	struct device_node *dn;
> +	struct resource r;
> +	int ret;
> +
> +	dn = of_find_compatible_node(NULL, NULL, "intel,hpet");
> +	if (!dn)
> +		return;
> +	ret = of_address_to_resource(dn, 0, &r);
> +	if (ret) {
> +		WARN_ON(1);
> +		return;
> +	}
> +	hpet_address = r.start;
> +}
> +
>  static void __init dtb_lapic_setup(void)
>  {
>  #ifdef CONFIG_X86_LOCAL_APIC
> @@ -212,5 +230,6 @@ void __init x86_dtb_get_config(unsigned int unused)
>  	of_scan_flat_dt(early_init_dt_scan_root, NULL);
>  
>  	unflatten_device_tree();
> +	dtb_setup_hpet();
>  	dtb_apic_setup();
>  }
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
