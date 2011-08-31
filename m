Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1HaJpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:45:22 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57891 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1HaJpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:45:21 -0400
MIME-Version: 1.0
In-Reply-To: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
References: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 31 Aug 2011 17:45:20 +0800
Message-ID: <CAGsJ_4yc+chiSh0wf_5sZk-Eh0vm-HSDZv+gFQi86LhCAUXTvw@mail.gmail.com>
Subject: Re: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
From: Barry Song <21cnbao@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +Interaction with the GPIO subsystem
> +===================================
> +
> +The GPIO drivers may want to perform operations of various types on the
> same
> +physical pins that are also registered as GPIO pins.
> +
> +Since the pin controller subsystem have its pinspace local to the pin
> +controller we need a mapping so that the pin control subsystem can figure
> out
> +which pin controller handles control of a certain GPIO pin. Since a single
> +pin controller may be muxing several GPIO ranges (typically SoCs that have
> +one set of pins but internally several GPIO silicon blocks, each modeled as
> +a struct gpio_chip) any number of GPIO ranges can be added to a pin
> controller
> +instance like this:
> +
> +struct gpio_chip chip_a;
> +struct gpio_chip chip_b;
> +
> +static struct pinctrl_gpio_range gpio_range_a = {
> +	.name = "chip a",
> +	.id = 0,
> +	.base = 32,
> +	.npins = 16,
> +	.gc = &chip_a;
> +};
> +
> +static struct pinctrl_gpio_range gpio_range_a = {
> +	.name = "chip b",
> +	.id = 0,
> +	.base = 48,
> +	.npins = 8,
> +	.gc = &chip_b;
> +};
> +
> +
> +{
> +	struct pinctrl_dev *pctl;
> +	...
> +	pinctrl_add_gpio_range(pctl, &gpio_range_a);
> +	pinctrl_add_gpio_range(pctl, &gpio_range_b);

people might like a pinctrl_add_gpio_range*s* too.

-barry
