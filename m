Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2AAOWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:22:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64383 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2AAOWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:22:08 -0500
MIME-Version: 1.0
In-Reply-To: <1324541855-19911-4-git-send-email-haojian.zhuang@marvell.com>
References: <1324541855-19911-1-git-send-email-haojian.zhuang@marvell.com>
	<1324541855-19911-4-git-send-email-haojian.zhuang@marvell.com>
Date: Sun, 1 Jan 2012 15:22:07 +0100
Message-ID: <CACRpkda_0ECowDhg2wWx9wLHgVVcRKycLYR=AgNrHVBum2ibLw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] gpio: pxa: request pinmux function for gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 9:17 AM, Haojian Zhuang
<haojian.zhuang@marvell.com> wrote:

> While gpio is requested for pxa, gpio driver will request function ready
> on pin.
(...)

> +#ifdef CONFIG_PINMUX
> +static int pxa_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +       return pinmux_request_gpio(chip->base + offset);
> +}
> +
> +static void pxa_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +       pinmux_free_gpio(chip->base + offset);
> +}
> +#else
> +static int pxa_gpio_request(struct gpio_chip *chip, unsigned offset) {return 0;}
> +static void pxa_gpio_free(struct gpio_chip *chip, unsigned offset) {}
> +#endif
> +

Skip the #ifdef, the pinmux portion of pinctrl already provides stubs if
CONFIG_PINMUX is not selected. See <linux/pinctrl/pinmux.h>

Yours,
Linus Walleij
