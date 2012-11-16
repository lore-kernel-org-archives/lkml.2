Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005Ab2KPHGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:06:02 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36236 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2KPHGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:06:00 -0500
MIME-Version: 1.0
In-Reply-To: <1353048646-10935-8-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
	<1353048646-10935-8-git-send-email-tushar.behera@linaro.org>
Date: Fri, 16 Nov 2012 12:35:59 +0530
X-Google-Sender-Auth: nTE08kHwD77BVoDxsnSZuYCQvqw
Message-ID: <CAOh2x=ncbWYKjwKrtXAeRVBakHi1Heu41L_Ffu4=Q1v1KbEYfA@mail.gmail.com>
Subject: Re: [PATCH 07/14] pinctrl: SPEAr: Update error check for unsigned variables
From: viresh kumar <viresh.kumar@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 12:20 PM, Tushar Behera
<tushar.behera@linaro.org> wrote:
> Checking '< 0' for unsigned variables always returns false. For error
> codes, use IS_ERR_VALUE() instead.
>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/pinctrl/spear/pinctrl-plgpio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
> index 1044ad3..9e0c731 100644
> --- a/drivers/pinctrl/spear/pinctrl-plgpio.c
> +++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
> @@ -283,7 +283,7 @@ static int plgpio_to_irq(struct gpio_chip *chip, unsigned offset)
>  {
>         struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
>
> -       if (plgpio->irq_base < 0)
> +       if (IS_ERR_VALUE(plgpio->irq_base))
>                 return -EINVAL;
>
>         return irq_find_mapping(plgpio->irq_domain, offset);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
