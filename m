Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab0JLVxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:53:50 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62566 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0JLVxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:53:49 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/qy0kVR0aF2jQiveQ+xxhQ
Date: Tue, 12 Oct 2010 13:49:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCHv3 2/7] OMAP SSI: Introducing OMAP SSI driver
Message-ID: <20101012204927.GY25462@atomide.com>
References: <1286787988-29013-1-git-send-email-carlos.chinea@nokia.com>
 <1286787988-29013-3-git-send-email-carlos.chinea@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286787988-29013-3-git-send-email-carlos.chinea@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Carlos Chinea <carlos.chinea@nokia.com> [101011 01:58]:
> Introduces the OMAP SSI driver in the kernel.
> 
> The Synchronous Serial Interface (SSI) is a legacy version
> of HSI. As in the case of HSI, it is mainly used to connect
> Application engines (APE) with cellular modem engines (CMT)
> in cellular handsets.
> 
> It provides a multichannel, full-duplex, multi-core communication
> with no reference clock. The OMAP SSI block is capable of reaching
> speeds of 110 Mbit/s.
> 
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>

> --- /dev/null
> +++ b/arch/arm/mach-omap2/ssi.c

> +static struct resource ssi_resources[] = {
> +	/* SSI controller */
> +	[0] = {
> +		.start	= 0x48058000,
> +		.end	= 0x48058fff,
> +		.name	= "omap_ssi_sys",
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	/* GDD */
> +	[1] = {
> +		.start	= 0x48059000,
> +		.end	= 0x48059fff,
> +		.name	= "omap_ssi_gdd",
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[2] = {
> +		.start	= 71,
> +		.end	= 71,
> +		.name	= "ssi_gdd",
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	/* SSI port 1 */
> +	[3] = {
> +		.start	= 0x4805a000,
> +		.end	= 0x4805a7ff,
> +		.name	= "omap_ssi_sst1",
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[4] = {
> +		.start	= 0x4805a800,
> +		.end	= 0x4805afff,
> +		.name	= "omap_ssi_ssr1",
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[5] = {
> +		.start	= 67,
> +		.end	= 67,
> +		.name	= "ssi_p1_mpu_irq0",
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	[6] = {
> +		.start	= 69,
> +		.end	= 69,
> +		.name	= "ssi_p1_mpu_irq1",
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	[7] = {
> +		.start	= 0,
> +		.end	= 0,
> +		.name	= "ssi_p1_cawake",
> +		.flags	= IORESOURCE_IRQ | IORESOURCE_UNSET,
> +	},
> +};

Are these resources the same for omap2, 3 & 4?

> +static void ssi_pdev_release(struct device *dev)
> +{
> +}

Not needed.

> +static struct platform_device ssi_pdev = {
> +	.name		= "omap_ssi",
> +	.id		= 0,
> +	.num_resources	= ARRAY_SIZE(ssi_resources),
> +	.resource	= ssi_resources,
> +	.dev		= {
> +				.release	= ssi_pdev_release,
> +				.platform_data	= &ssi_pdata,
> +	},
> +};

Dummy release not needed here either.

> +static int __init ssi_init(void)
> +{
> +	return platform_device_register(&ssi_pdev);
> +}
> +subsys_initcall(ssi_init);

This will probably cause trouble on omap2 and 4?

To me it seems that you should at least return early on the unsupported
platforms.

You might want to consider updating this for omap hwmod as it will
automate the platform_device and PM related issues to some extent.

Regards,

Tony
