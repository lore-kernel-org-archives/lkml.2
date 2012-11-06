Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2KFJDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:03:47 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40400 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2KFJDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:03:44 -0500
MIME-Version: 1.0
In-Reply-To: <1352185470.3088.1.camel@phoenix>
References: <1352185470.3088.1.camel@phoenix>
Date: Tue, 6 Nov 2012 10:03:43 +0100
Message-ID: <CACRpkdYTY6C0KkE=y2RPOnyjGhwMZOihQ=nyO7Sr-V29GT9yaQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: PINCTRL_SAMSUNG and PINCTRL_EXYNOS4 need to
 depend on OF && GPIOLIB
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 8:04 AM, Axel Lin <axel.lin@ingics.com> wrote:

> This patch fixes below build error when !CONFIG_OF_GPIO.
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
> The samsung pinctrl driver supports only device tree enabled platforms.
> Thus make PINCTRL_SAMSUNG depend on OF && GPIOLIB.
>
> The reason to depend on GPIOLIB is CONFIG_OF_GPIO only available when GPIOLIB
> is selected.
> Since PINCTRL_EXYNOS4 select PINCTRL_SAMSUNG, thus also make PINCTRL_EXYNOS4
> depend on OF && GPIOLIB.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

This looks good (maybe it should depend on OF_GPIO but who cares).

Patch applied to my fixes branch after som patch -p1 < foo.patch
mockery.

Yours,
Linus Walleij
