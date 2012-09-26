Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2IZGoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:44:21 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62175 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2IZGoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:44:19 -0400
MIME-Version: 1.0
In-Reply-To: <1348624007-16634-1-git-send-email-zhangwm@marvell.com>
References: <1348624007-16634-1-git-send-email-zhangwm@marvell.com>
Date: Wed, 26 Sep 2012 14:44:18 +0800
Message-ID: <CAN1soZzoCHwrDiQEW7sBL3Tj8fc=yqh2Sbi=eZeqi7iTJjAZsQ@mail.gmail.com>
Subject: Re: [PATCH V2] GPIO: gpio-pxa: fix bug when get gpio value
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 9:46 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> We need to return 0 or 1 when get gpio value.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  drivers/gpio/gpio-pxa.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
> index 9cac88a..3c9dc8c 100644
> --- a/drivers/gpio/gpio-pxa.c
> +++ b/drivers/gpio/gpio-pxa.c
> @@ -269,7 +269,9 @@ static int pxa_gpio_direction_output(struct gpio_chip *chip,
>
>  static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)
>  {
> -       return readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET) & (1 << offset);
> +       u32 gplr = readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET);
> +
> +       return (gplr & (1 << offset)) ? 1 : 0;
>  }
>
>  static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> --
> 1.7.4.1
>

gpio_get_value() is used to dump bits from GPLR register in mach-pxa directory.
Unless you update those code at the same time, this patch can't be merged.

Regards
Haojian
