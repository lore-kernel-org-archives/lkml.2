Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab2KUHmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:42:44 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34910 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2KUHmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:42:42 -0500
MIME-Version: 1.0
In-Reply-To: <1353483465-25961-1-git-send-email-linus.walleij@stericsson.com>
References: <1353483465-25961-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 21 Nov 2012 13:12:42 +0530
Message-ID: <CAKohpokYD7Cyv77p4MtmtJ+UJSfb3fjYWmjXkQV40Czbh7FOWw@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: fix bug and clarify OF use of ranges
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2012 13:07, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> In commit c905165f5946f56dca195871641bd4e488eca24a
> "gpiolib: let gpiochip_add_pin_range() specify offset"
> I forgot to update the OF use of the function
> gpiochip_add_pin_range().
>
> It turns out that this reveal a weakness in the
> OF range mappings: ranges cannot currently be sparse.
> So put in a comment so we can fix this later.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpiolib-of.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index a40cd84..d542a14 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -238,8 +238,20 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
>                 if (!pctldev)
>                         break;
>
> +               /*
> +                * This assumes that the n GPIO pins are consecutive in the
> +                * GPIO number space, and that the pins are also consecutive
> +                * in their local number space. Currently it is not possible
> +                * to add different ranges for one and the same GPIO chip,
> +                * as the code assumes that we have one consecutive range
> +                * on both, mapping 1-to-1.
> +                *
> +                * TODO: make the OF bindings handle multiple sparse ranges
> +                * on the same GPIO chip.
> +                */
>                 ret = gpiochip_add_pin_range(chip,
>                                              pinctrl_dev_get_name(pctldev),
> +                                            0, /* offset in gpiochip */
>                                              pinspec.args[0],
>                                              pinspec.args[1]);

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

This is what i was asking you earlier: "Doesn't gpiochip_add_pin_range
have any users?" and you said NO and i didn't cross checked :(
