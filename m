Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2EAX0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:26:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52956 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab2EAX0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <1335768768-10231-1-git-send-email-sachin.kamat@linaro.org>
References: <1335768768-10231-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 2 May 2012 01:26:12 +0200
Message-ID: <CACRpkdYHKR+oOD36RCUMobEwJj_Y9WDHTUY+UaHAx0YegMhXyg@mail.gmail.com>
Subject: Re: [PATCH] gpio/exynos: Fix compiler warnings when non-exynos
 machines are selected
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 8:52 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> +#if defined(CONFIG_ARCH_EXYNOS4) || defined(CONFIG_ARCH_EXYNOS5)
> +#endif
> -static struct samsung_gpio_chip exynos4_gpios_1[] = {
>  #ifdef CONFIG_ARCH_EXYNOS4
> +static struct samsung_gpio_chip exynos4_gpios_1[] = {
> -#endif
> +#endif
> -static struct samsung_gpio_chip exynos4_gpios_2[] = {
>  #ifdef CONFIG_ARCH_EXYNOS4
> +static struct samsung_gpio_chip exynos4_gpios_2[] = {
> -#endif
> +#endif
> -static struct samsung_gpio_chip exynos4_gpios_3[] = {
>  #ifdef CONFIG_ARCH_EXYNOS4
> +static struct samsung_gpio_chip exynos4_gpios_3[] = {
> -#endif
> +#endif
>  #ifdef CONFIG_ARCH_EXYNOS5
> +#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
> +#endif
> +#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
> +#endif

We really want to get rid of this kind of stuff from all drivers, #ifdefs are
declared ugly already in Documentation/CodingStyle.

Any chance you could solve this problem by reworking the driver to
pass some flag in platform data tell which exynos it's for
and jist adapt at runtime instead of the compile-time quirkiness?

Besides looking better, it helps us to get to a single zImage for the
exynoses too..

Yours,
Linus Walleij
