Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2HGHWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:22:36 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36140 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab2HGHWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:22:35 -0400
MIME-Version: 1.0
In-Reply-To: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
References: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
Date: Tue, 7 Aug 2012 12:52:33 +0530
Message-ID: <CAJuYYwS6YX4-nrtMKNEF6O9n4xDRzoorAgrem+VTVQLdEpTOUA@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Add gpio functions for Exynos4412
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <dongjin.kim@agreeyamobility.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 August 2012 19:27, Dongjin Kim <tobetter@gmail.com> wrote:
> GPIO functions are not registered for Exynos4412 yet,
> therefore exynos4_gpiolib_init() is added to initialize Exynos4412 SoC.
>
> Change-Id: I5945d94c6fbfc309ccf882eba067864a338c04ca
> Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
> ---
>  drivers/gpio/gpio-samsung.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index 92f7b2b..6b312a9 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -2727,7 +2727,7 @@ static __init void exynos_gpiolib_attach_ofnode(struct samsung_gpio_chip *chip,
>
>  static __init void exynos4_gpiolib_init(void)
>  {
> -#ifdef CONFIG_CPU_EXYNOS4210
> +#ifdef CONFIG_ARCH_EXYNOS4
>         struct samsung_gpio_chip *chip;
>         int i, nr_chips;
>         void __iomem *gpio_base1, *gpio_base2, *gpio_base3;
> @@ -2816,7 +2816,7 @@ err_ioremap2:
>         iounmap(gpio_base1);
>  err_ioremap1:
>         return;
> -#endif /* CONFIG_CPU_EXYNOS4210 */
> +#endif /* CONFIG_ARCH_EXYNOS4 */
>  }
>
>  static __init void exynos5_gpiolib_init(void)
> @@ -3014,6 +3014,8 @@ static __init int samsung_gpiolib_init(void)
>                 exynos4_gpiolib_init();
>         } else if (soc_is_exynos5250()) {
>                 exynos5_gpiolib_init();
> +       } else if (soc_is_exynos4212() || soc_is_exynos4412()) {
> +               exynos4_gpiolib_init();
>         } else {
>                 WARN(1, "Unknown SoC in gpio-samsung, no GPIOs added\n");
>                 return -ENODEV;
> --
> 1.7.9.5

Dear Mr. Dongjin Kim,

There are differences between Exynos4210 and Exynos4412 in terms of in
gpio banks and number of gpio banks per gpio block. So this patch
needs to consider those differences and handle them appropriately.

Thanks,
Thomas.
