Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2IJNUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:20:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57114 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2IJNUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-20-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-20-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 06:20:52 -0700
Message-ID: <CACRpkdZ4-_dqoNoCa_vRq04Or-8PjWz-bgHrvsLJFs8pOAE9xQ@mail.gmail.com>
Subject: Re: [PATCH 19/19] gpio: Enable the tc3298x GPIO expander driver for
 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we provide a means to probe and extract vital information
> from Device Tree when booting with it enabled. Without this
> patch sub-devices wouldn't be able to reference the tc3589x-gpio
> expander from Device Tree.
>
> CC: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Basically this looks very good, but:

> @@ -337,9 +343,11 @@ static int __devinit tc3589x_gpio_probe(struct platform_device *pdev)
>         tc3589x_gpio->chip = template_chip;
>         tc3589x_gpio->chip.ngpio = tc3589x->num_gpio;
>         tc3589x_gpio->chip.dev = &pdev->dev;
> -       tc3589x_gpio->chip.base = pdata->gpio_base;
> +       tc3589x_gpio->chip.base = (pdata) ? pdata->gpio_base : -1;
>
> -       tc3589x_gpio->irq_base = tc3589x->irq_base + TC3589x_INT_GPIO(0);
> +#ifdef CONFIG_OF_GPIO
> +        tc3589x_gpio->chip.of_node = np;
> +#endif

Isn't the newstyle way of doing this something like:

if (IS_ENABLED(CONFIG_OF_GPIO))
  tc3589x_gpio->chip.of_node = np;

I'm a bit uncertain about this since I never quite used
it myself, test it with OF disabled and see if it works.

This construct also accepts modules using OF, see
include/linux/kconfig.h, somebody might be using this as
a module.

Yours,
Linus Walleij
