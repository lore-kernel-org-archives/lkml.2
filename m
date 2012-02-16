Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2BPTYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:24:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53783 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab2BPTYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:24:48 -0500
MIME-Version: 1.0
In-Reply-To: <5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
References: <cover.1329396583.git.rubini@gnudd.com>
	<5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
Date: Thu, 16 Feb 2012 20:24:47 +0100
Message-ID: <CACRpkdY-U8FgYFkVcbQg57XF7BhsjBcJDopPTLhgRMRLHv7LZA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] gpio: add STA2X11 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 2:00 PM, Alessandro Rubini <rubini@gnudd.com> wrote:

> +static void gsta_gpio_setup(struct gsta_gpio *chip) /* called from probe */
> +{
> +       struct gpio_chip *gpio = &chip->gpio;
> +
> +       /*
> +        * ARCH_NR_GPIOS is currently 256 and dynamic allocation starts
> +        * from the end. However, for compatiility, we need the first

[Nitpick: spelling]

> +        * ConneXt device to start from gpio 0: it's the main chipset
> +        * on most boards so documents and drivers assume gpio0..gpio127
> +        */
> +       static int gpio_base;
> +
> +       gpio->label = dev_name(chip->dev);
> +       gpio->owner = THIS_MODULE;
> +       gpio->direction_input = gsta_gpio_direction_input;
> +       gpio->get = gsta_gpio_get;
> +       gpio->direction_output = gsta_gpio_direction_output;
> +       gpio->set = gsta_gpio_set;
> +       gpio->dbg_show = NULL;
> +       gpio->base = gpio_base;
> +       gpio->base = 0;

What are you doing here?

It seems like you first use the provided base, then hard code it
to zero.

The GPIO pin number space is global and you need to be able to
handle the case where several controllers of this kind are plugged
in, will you not?

This looks like it assumes you only ever have one card on the
system.

Make sure that the global GPIO numberspace is properly
handled on these systems, alas I am a bit worried that this
may not be that very easy.

Yours,
Linus Walleij
