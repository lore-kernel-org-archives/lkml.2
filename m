Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab2GTVGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:06:35 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59647 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2GTVGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:06:33 -0400
MIME-Version: 1.0
In-Reply-To: <1342817939-7118-1-git-send-email-seanpaul@chromium.org>
References: <1342817939-7118-1-git-send-email-seanpaul@chromium.org>
Date: Fri, 20 Jul 2012 14:06:32 -0700
X-Google-Sender-Auth: QpNaundorC049cqWyxu0dUxpvlg
Message-ID: <CAD=FV=W8oqytNM0xSHbceTEy6gAdr_Lmm7zWqogcwAPJR6jKSg@mail.gmail.com>
Subject: Re: [PATCH] gpio: samsung: Fix off-by-one bug in gpio addresses
From: Doug Anderson <dianders@chromium.org>
To: Sean Paul <seanpaul@chromium.org>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, olofj@chromium.org,
        Sangsu Park <sangsu4u.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Doug Anderson <dianders@chromium.org>

---

On Fri, Jul 20, 2012 at 1:58 PM, Sean Paul <seanpaul@chromium.org> wrote:
>
> Move gpc4 to the end of the automatically processed gpio controllers so
> we don't taint the automatic offset calculation.
>
> This bug caused all controllers coming after gpc4 to map to the
> incorrect address. The result is <&gpd1 0 0 0 0> would actually map to
> GPIO 0 in gpd0.
>
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---
>  drivers/gpio/gpio-samsung.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index b6453d0..e4599b4 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -2454,12 +2454,6 @@ static struct samsung_gpio_chip exynos5_gpios_1[] = {
>                 },
>         }, {
>                 .chip   = {
> -                       .base   = EXYNOS5_GPC4(0),
> -                       .ngpio  = EXYNOS5_GPIO_C4_NR,
> -                       .label  = "GPC4",
> -               },
> -       }, {
> -               .chip   = {
>                         .base   = EXYNOS5_GPD0(0),
>                         .ngpio  = EXYNOS5_GPIO_D0_NR,
>                         .label  = "GPD0",
> @@ -2513,6 +2507,12 @@ static struct samsung_gpio_chip exynos5_gpios_1[] = {
>                         .label  = "GPY6",
>                 },
>         }, {
> +               .chip   = {
> +                       .base   = EXYNOS5_GPC4(0),
> +                       .ngpio  = EXYNOS5_GPIO_C4_NR,
> +                       .label  = "GPC4",
> +               },
> +       }, {
>                 .config = &samsung_gpio_cfgs[9],
>                 .irq_base = IRQ_EINT(0),
>                 .chip   = {
> @@ -2833,7 +2833,7 @@ static __init void exynos5_gpiolib_init(void)
>         }
>
>         /* need to set base address for gpc4 */
> -       exynos5_gpios_1[11].base = gpio_base1 + 0x2E0;
> +       exynos5_gpios_1[20].base = gpio_base1 + 0x2E0;
>
>         /* need to set base address for gpx */
>         chip = &exynos5_gpios_1[21];
> --
> 1.7.7.3
>
