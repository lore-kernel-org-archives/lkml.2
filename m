Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3AJK5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:57:12 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53018 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3AJK5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:57:10 -0500
MIME-Version: 1.0
In-Reply-To: <1357210020-19876-4-git-send-email-ldewangan@nvidia.com>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
	<1357210020-19876-4-git-send-email-ldewangan@nvidia.com>
Date: Thu, 10 Jan 2013 11:57:10 +0100
Message-ID: <CACRpkdbSW+aj9RSedsAMyF3UtSL+w=0KM+pxc2bGdceSy+rXaw@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: palmas: Add support for Palams GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca,
        akpm@linux-foundation.org, a.zummo@towertech.it,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 11:46 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Add gpio driver for TI Palmas series PMIC. This has 8 gpio which can
> work as input/output.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

This driver seems unnecessary. Can't you just use
drivers/gpio/gpio-generic.c ?

> +static int palmas_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +       struct palmas_gpio *pg = to_palmas_gpio(gc);
> +       struct palmas *palmas = pg->palmas;
> +
> +       return palmas_irq_get_virq(palmas, PALMAS_GPIO_0_IRQ + offset);
> +}

Why are you implementing this for a driver which does not even expose
the ability to trigger IRQs? If it's supposed to support IRQs it should
register a struct irq_chip.

Yours,
Linus Walleij
