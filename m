Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab1IZW33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:29:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1IZW32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:29:28 -0400
Date: Mon, 26 Sep 2011 23:29:18 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        marc.zyngier@arm.com, thomas.abraham@linaro.org, jamie@jamieiles.com,
        b-cousson@ti.com, shawn.guo@linaro.org, dave.martin@linaro.org,
        linux@arm.linux.org.uk, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] ARM: gic: add OF based initialization
Message-ID: <20110926222918.GG9194@gallagher>
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com>
 <1316550244-3655-4-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316550244-3655-4-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Apologies for the noise!  One minor comment below.

Jamie

On Tue, Sep 20, 2011 at 03:24:04PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This adds ARM gic interrupt controller initialization using device tree
> data.
> 
> The initialization function is intended to be called by of_irq_init
> function like this:
> 
> const static struct of_device_id irq_match[] = {
>         { .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
>         {}
> };
> 
> static void __init init_irqs(void)
> {
>         of_irq_init(irq_match);
> }
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
[...]
> diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
> index 435d3f8..2862d0e 100644
> --- a/arch/arm/include/asm/hardware/gic.h
> +++ b/arch/arm/include/asm/hardware/gic.h
> @@ -33,10 +33,21 @@
>  #define GIC_DIST_SOFTINT		0xf00
>  
>  #ifndef __ASSEMBLY__
> +#include <linux/irqdomain.h>
> +
>  extern void __iomem *gic_cpu_base_addr;
>  extern struct irq_chip gic_arch_extn;
>  
>  void gic_init(unsigned int, unsigned int, void __iomem *, void __iomem *);
> +#ifdef CONFIG_OF
> +int gic_of_init(struct device_node *node, struct device_node *parent);
> +#else
> +static inline void gic_of_init(struct device_node *node,
> +			       struct device_node *parent)

This should return int?

> +{
> +	return -ENODEV;
> +}
> +#endif
