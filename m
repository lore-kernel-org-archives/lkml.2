Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2DUIWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 04:22:35 -0400
Received: from 7.mo3.mail-out.ovh.net ([46.105.57.200]:52262 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750704Ab2DUIWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 04:22:33 -0400
X-Greylist: delayed 110666 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Apr 2012 04:22:33 EDT
Date: Sat, 21 Apr 2012 10:03:21 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH v5] gpio: Device tree support for LPC32xx
Message-ID: <20120421080321.GB9142@game.jcrosoft.org>
References: <1334994925-11842-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334994925-11842-1-git-send-email-stigge@antcom.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7944068267859422045
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegtddrtdefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegfedrgedtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:55 Sat 21 Apr     , Roland Stigge wrote:
> This patch adds device tree support for gpio-lpc32xx.c
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> ---
> 
>  Applies to v3.4-rc3
> 
>  Changes since last version:
>  * Typo fix in documentation
>  * Changed "compatible" strings to non-wildcard versions
>  * Removed Arnd Bergmann's "Reviewed-by:" due to above change
>  
>  Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt |   66 ++++++++++++++++
>  arch/arm/mach-lpc32xx/include/mach/gpio.h               |    9 +-
>  drivers/gpio/gpio-lpc32xx.c                             |   55 ++++++++++++-
>  3 files changed, 127 insertions(+), 3 deletions(-)
> 
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt
> @@ -0,0 +1,66 @@
> +NXP LPC32xx SoC GPIO controller
> +
> +Required properties:
> +- compatible: must be "nxp,lpc3220-gpio", "nxp,lpc3230-gpio", "nxp,lpc3240-gpio"
> +  or "nxp,lpc3250-gpio"
same comment as on the ADC you don't need to list all

just put the first soc where this IP was used
> +- reg: Physical base address and length of the controller's registers.
> +- #address-cells: Always 1, for indexing of the subnodes (GPIO groups of the
> +  SoC)
> +- #size-cells: Always 0
> +
> +Required properties of sub-nodes which describe the GPIO groups of LPC32xx:
> +- gpio-controller: Marks the device node as a GPIO controller.
> +- #gpio-cells: Should be two. The first cell is the pin number and the
> +  second cell is used to specify optional parameters:
> +  - bit 0 specifies polarity (0 for normal, 1 for inverted)
> +- reg: Index of the GPIO group
> +
> +Optional properties of sub-nodes which describe the GPIO groups of LPC32xx:
> +- status: Set to "disabled" if you don't use the respective GPIO group
> +  of the LPC32xx SoC
> +
> +Example:
> +
> +	gpio: gpio@40028000 {
> +		compatible = "nxp,lpc3250-gpio";
> +		reg = <0x40028000 0x1000>;
> +		/* create a private address space for enumeration */
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		gpio_p0: gpio-bank@0 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <0>;
> +		};
> +
> +		gpio_p1: gpio-bank@1 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <1>;
> +		};
> +
> +		gpio_p2: gpio-bank@2 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <2>;
> +		};
> +
> +		gpio_p3: gpio-bank@3 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <3>;
> +		};
> +
> +		gpi_p3: gpio-bank@4 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <4>;
> +		};
> +
> +		gpo_p3: gpio-bank@5 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <5>;
> +		};
> +	};
> --- linux-2.6.orig/arch/arm/mach-lpc32xx/include/mach/gpio.h
> +++ linux-2.6/arch/arm/mach-lpc32xx/include/mach/gpio.h
> @@ -1 +1,8 @@
> -/* empty */
> +#ifndef __MACH_GPIO_H
> +#define __MACH_GPIO_H
> +
> +#include "gpio-lpc32xx.h"
> +
> +#define ARCH_NR_GPIOS (LPC32XX_GPO_P3_GRP + LPC32XX_GPO_P3_MAX)
> +
> +#endif /* __MACH_GPIO_H */
> --- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
> +++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
> @@ -21,6 +21,9 @@
>  #include <linux/io.h>
>  #include <linux/errno.h>
>  #include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
>  
>  #include <mach/hardware.h>
>  #include <mach/platform.h>
> @@ -454,10 +457,58 @@ static struct lpc32xx_gpio_chip lpc32xx_
>  	},
>  };
>  
> +/* Empty now, can be removed later when mach-lpc32xx is finally switched over
> + * to DT support
> + */
>  void __init lpc32xx_gpio_init(void)
>  {
> +}
> +
> +static int __devinit lpc32xx_gpio_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node;
>  	int i;
>  
> -	for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++)
> -		gpiochip_add(&lpc32xx_gpiochip[i].chip);
> +	if (pdev->dev.of_node) {
> +		for_each_child_of_node(pdev->dev.of_node, node) {
> +			if (of_device_is_available(node)) {
> +				u32 index;
> +				struct gpio_chip *chip;
> +				if (of_property_read_u32(node,
> +							 "reg", &index) <  0)
> +					continue;
> +				if (index >= ARRAY_SIZE(lpc32xx_gpiochip))
> +					continue;
> +				chip = &lpc32xx_gpiochip[index].chip;
> +				chip->of_node = of_node_get(node);
> +				gpiochip_add(chip);
split this in an toher function so it's more readble

Best Regards,
J.
