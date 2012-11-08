Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2KHGMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:12:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9043 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2KHGMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:12:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Nov 2012 21:59:26 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: How about a gpio_get(device *, char *) function?
Date: Thu, 8 Nov 2012 15:14:34 +0900
Message-ID: <1908355.tpLPJU8MKg@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.2 (Linux/3.6.4-1-ARCH; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CACRpkdYqCQc0Er1JR_eVzZPCycvKjd0Pph8Dcay0FbU3Q64D8A@mail.gmail.com>
References: <38620644.IyR5R8rjKP@percival> <1801189.6J3flQFRCq@percival> <CACRpkdYqCQc0Er1JR_eVzZPCycvKjd0Pph8Dcay0FbU3Q64D8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012 05:24:19 Linus Walleij wrote:
> I would prefer to create, e.g. in <linux/gpio/consumer.h>
> something like:
> 
> struct gpio;
> 
> struct gpio *gpio_get(struct device *dev, const char *name);
> 
> int gpio_get_value(struct gpio *g);
> 
> Nothing more! I.e. struct gpio is an opaque cookie, nothing to be known
> about it.
> 
> And then have the drivers using this *ONLY* include <linux/gpio/consumer.h>
> and not <linux/gpio.h>. So drivers have no clue what struct gpio is and
> will only operate on it using functions.
> 
> This follows the pattern set by Thomas Gleixner for e.g. IRQ descriptors,
> and the style was also used in the redesign of the struct clk *.

Also pretty similar to the regulator framework, which might itself have been 
inspired by IRQs and clocks.

> Of course the cross-referencing implementation can in e.g.
> drivers/gpio/gpiodev.c internally define that like this:
> 
> #include <linux/gpio.h>
> 
> /**
>   * @gpio: pointer to global GPIO number
>   */
> struct gpio {
>     int gpio;
> };
> 
> struct gpio *gpio_get(struct device *dev, const char *name)
> {
>    /* Lookup in cross-ref table etc */
> }
> 
> int gpioh_get_value(struct gpio *g)
> {
>    return gpio_get_value(g->gpio);
> }
> 
> (...)
> 
> Then we can work from there. I think it adds the proper
> opaqueness factor.

Looks nice, simple and to the point! Let's see if I can find the time to cook 
something based on this.

Thanks!
Alex.

