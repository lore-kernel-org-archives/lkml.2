Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab2KFFDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 00:03:25 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64193 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab2KFFDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 00:03:24 -0500
MIME-Version: 1.0
In-Reply-To: <1352130296.13561.1.camel@phoenix>
References: <1352130296.13561.1.camel@phoenix>
Date: Tue, 6 Nov 2012 10:33:22 +0530
Message-ID: <CAJuYYwTg0V3sn0YW-bJV9T9EZ91dF7wjX9UmeBwtxMZzJMwwjg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: samsung: Add ifdef CONFIG_OF_GPIO guard for gc->of_node
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 November 2012 21:14, Axel Lin <axel.lin@ingics.com> wrote:
> This fixes below build error when !CONFIG_OF_GPIO.
>
>   CC      drivers/pinctrl/pinctrl-samsung.o
> drivers/pinctrl/pinctrl-samsung.c: In function 'samsung_pinctrl_parse_dt_pins':
> drivers/pinctrl/pinctrl-samsung.c:557:19: warning: unused variable 'prop' [-Wunused-variable]
> drivers/pinctrl/pinctrl-samsung.c: In function 'samsung_gpiolib_register':
> drivers/pinctrl/pinctrl-samsung.c:797:5: error: 'struct gpio_chip' has no member named 'of_node'
> make[2]: *** [drivers/pinctrl/pinctrl-samsung.o] Error 1
> make[1]: *** [drivers/pinctrl] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> v2:
> Don't remove the prop variable.
> It is used in of_property_for_each_string() when CONFIG_OF_GPIO is enabled.
>
>  drivers/pinctrl/pinctrl-samsung.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
> index fc34cac..f798b4d 100644
> --- a/drivers/pinctrl/pinctrl-samsung.c
> +++ b/drivers/pinctrl/pinctrl-samsung.c
> @@ -794,7 +794,9 @@ static int __devinit samsung_gpiolib_register(struct platform_device *pdev,
>                 gc->base = ctrl->base + bank->pin_base;
>                 gc->ngpio = bank->nr_pins;
>                 gc->dev = &pdev->dev;
> +#if defined(CONFIG_OF_GPIO)
>                 gc->of_node = bank->of_node;
> +#endif
>                 gc->label = bank->name;
>
>                 ret = gpiochip_add(gc);

The samsung pinctrl driver supports only device tree enabled
platforms. So instead of adding the above #if, would it not be better
to add 'select OF_GPIO' for Samsung pinctrl driver in
drivers/pinctrl/Kconfig. ?

Thanks,
Thomas.

> --
> 1.7.9.5
>
>
>
