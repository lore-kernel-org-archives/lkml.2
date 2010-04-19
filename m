Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0DSOsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:48:21 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:33254 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0DSOsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:48:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv4 2.6.34-rc4 2/7] mx5: Add USB device definitions for Freescale MX51 Babbage HW
Date: Mon, 19 Apr 2010 07:48:17 -0700
Message-ID: <86A0E76937111F4C92FABEC0A209885104733901@az33exm21>
In-Reply-To: <20100419003252.GA15308@matterhorn.verdurent.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv4 2.6.34-rc4 2/7] mx5: Add USB device definitions for Freescale MX51 Babbage HW
Thread-Index: AcrfV/TAFVOmOiMYRXqVx2LZuass0wAdu1EQ
References: <1271445371-18501-1-git-send-email-Dinh.Nguyen@freescale.com> <1271445371-18501-2-git-send-email-Dinh.Nguyen@freescale.com> <20100419003252.GA15308@matterhorn.verdurent.com>
From: "Nguyen Dinh-R00091" <R00091@freescale.com>
To: "Amit Kucheria" <amit.kucheria@canonical.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
       <linux@arm.linux.org.uk>, <s.hauer@pengutronix.de>,
       <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
       <grant.likely@secretlab.ca>, <bryan.wu@canonical.com>,
       "Herring Robert-RA7055" <RA7055@freescale.com>,
       "Li Jun-R65092" <R65092@freescale.com>,
       "Zhang Lily-R58066" <R58066@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: Amit Kucheria [mailto:amit.kucheria@canonical.com] 
Sent: Sunday, April 18, 2010 7:33 PM
To: Nguyen Dinh-R00091
Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
linux@arm.linux.org.uk; s.hauer@pengutronix.de;
valentin.longchamp@epfl.ch; daniel@caiaq.de; grant.likely@secretlab.ca;
bryan.wu@canonical.com; Herring Robert-RA7055; Li Jun-R65092; Zhang
Lily-R58066
Subject: Re: [PATCHv4 2.6.34-rc4 2/7] mx5: Add USB device definitions
for Freescale MX51 Babbage HW

On 10 Apr 16, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> This patch is part of enabling USB for Freescale MX51 Babbage HW. This

> patch adds device structures for USB Host1 and OTG port, and adds 
> clocking information for USB HW.
> 
> This patch applies to 2.6.34-rc4.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/clock-mx51.c |    8 ++++++
>  arch/arm/mach-mx5/devices.c    |   49
++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-mx5/devices.h    |    2 +
>  3 files changed, 59 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/clock-mx51.c 
> b/arch/arm/mach-mx5/clock-mx51.c index 1ee6ce4..1fe40e1 100644
> --- a/arch/arm/mach-mx5/clock-mx51.c
> +++ b/arch/arm/mach-mx5/clock-mx51.c
> @@ -762,6 +762,10 @@ DEFINE_CLOCK(gpt_clk, 0, MXC_CCM_CCGR2, 
> MXC_CCM_CCGRx_CG9_OFFSET,  DEFINE_CLOCK(gpt_ipg_clk, 0, MXC_CCM_CCGR2,
MXC_CCM_CCGRx_CG10_OFFSET,
>  	NULL,  NULL, &ipg_clk, NULL);
>  
> +/* USB */
> +DEFINE_CLOCK(usboh3_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG14_OFFSET,
> +	NULL, NULL, &pll3_sw_clk, NULL);
> +
>  /* FEC */
>  DEFINE_CLOCK(fec_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG12_OFFSET,
>  	NULL,  NULL, &ipg_clk, NULL);
> @@ -779,6 +783,10 @@ static struct clk_lookup lookups[] = {
>  	_REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
>  	_REGISTER_CLOCK(NULL, "gpt", gpt_clk)
>  	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
> +	_REGISTER_CLOCK("mxc-ehci.0", "usb", usboh3_clk)
> +	_REGISTER_CLOCK("mxc-ehci.0", "usb_ahb", ahb_clk)
> +	_REGISTER_CLOCK("mxc-ehci.1", "usb", usboh3_clk)
> +	_REGISTER_CLOCK("mxc-ehci.1", "usb_ahb", ahb_clk)
>  };
>  
>  static void clk_tree_init(void)
> diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c

> index 5070ae1..4b456d5 100644

This part of the patch doesn't apply anymore. Please fix. Also, run
scripts/checkpatch.pl on the series to catch some standard whitespace
errors (like no new line at the end of this file)

[Dinh] I'm not sure I know what you mean Amit? The mxc-ehci makes calls
in the driver probe function to get the usb and usb_ahb clock. I have
ran checkpatch.pl on all of the patches in Bryan Wu made that comment.
There are only warnings for 80 characters on all of the patches. 

> --- a/arch/arm/mach-mx5/devices.c
> +++ b/arch/arm/mach-mx5/devices.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/platform_device.h>
>  #include <linux/gpio.h>
> +#include <linux/dma-mapping.h>
>  #include <mach/hardware.h>
>  #include <mach/imx-uart.h>
>  #include <mach/irqs.h>
> @@ -92,6 +93,54 @@ struct platform_device mxc_fec_device = {
>  	.resource = mxc_fec_resources,
>  };
>  
> +static u64 usb_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct resource usbotg_resources[] = {
> +	{
> +		.start = MX51_OTG_BASE_ADDR,
> +		.end = MX51_OTG_BASE_ADDR + 0x1ff,
> +		.flags = IORESOURCE_MEM,
> +	},
> +	{
> +		.start = MX51_MXC_INT_USB_OTG,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +struct platform_device mxc_usbdr_host_device = {
> +	.name = "mxc-ehci",
> +	.id = 0,
> +	.num_resources = ARRAY_SIZE(usbotg_resources),
> +	.resource = usbotg_resources,
> +	.dev = {
> +		.dma_mask = &usb_dma_mask,
> +		.coherent_dma_mask = DMA_BIT_MASK(32),
> +	},
> +};
> +
> +static struct resource usbh1_resources[] = {
> +	{
> +		.start = MX51_OTG_BASE_ADDR + 0x200,
> +		.end = MX51_OTG_BASE_ADDR + 0x200 + 0x1ff,
> +		.flags = IORESOURCE_MEM,
> +	},
> +	{
> +		.start = MX51_MXC_INT_USB_H1,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +struct platform_device mxc_usbh1_device = {
> +	.name = "mxc-ehci",
> +	.id = 1,
> +	.num_resources = ARRAY_SIZE(usbh1_resources),
> +	.resource = usbh1_resources,
> +	.dev = {
> +		.dma_mask = &usb_dma_mask,
> +		.coherent_dma_mask = DMA_BIT_MASK(32),
> +	},
> +};
> +
>  static struct mxc_gpio_port mxc_gpio_ports[] = {
>  	{
>  		.chip.label = "gpio-0",
> diff --git a/arch/arm/mach-mx5/devices.h b/arch/arm/mach-mx5/devices.h

> index f339ab8..6497764 100644
> --- a/arch/arm/mach-mx5/devices.h
> +++ b/arch/arm/mach-mx5/devices.h
> @@ -2,3 +2,5 @@ extern struct platform_device mxc_uart_device0;  
> extern struct platform_device mxc_uart_device1;  extern struct 
> platform_device mxc_uart_device2;  extern struct platform_device 
> mxc_fec_device;
> +extern struct platform_device mxc_usbdr_host_device; extern struct 
> +platform_device mxc_usbh1_device;
> \ No newline at end of file



> --
> 1.6.0.4
> 

-- 
----------------------------------------------------------------------
Amit Kucheria, Kernel Engineer || amit.kucheria@canonical.com
----------------------------------------------------------------------

