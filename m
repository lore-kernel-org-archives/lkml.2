Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1KQIqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:46:12 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35815 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab1KQIqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:46:11 -0500
MIME-Version: 1.0
In-Reply-To: <1321335378-29064-1-git-send-email-rnayak@ti.com>
References: <1321335378-29064-1-git-send-email-rnayak@ti.com>
Date: Thu, 17 Nov 2011 09:46:10 +0100
Message-ID: <CACRpkdadf9qqSy7sVk7w7zKZesNiefCWgag84NtjN=7bMuXSbg@mail.gmail.com>
Subject: Re: [PATCH] Documentation: Fix minor typos in pinctrl.txt
From: Linus Walleij <linus.walleij@linaro.org>
To: Rajendra Nayak <rnayak@ti.com>
Cc: linus.walleij@stericsson.com, rdunlap@xenotime.net,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 6:36 AM, Rajendra Nayak <rnayak@ti.com> wrote:

> Fix some minor typos in the pinctrl documentation.
(...)
> -the pins from 0 in the upper left corner to 63 in the lower right corner,
> +the pins from 0 in the lower left corner to 63 in the upper right corner,

It's the PINCTRL_PIN() defintions that are wrong, this text is correct.

So it should be:

const struct pinctrl_pin_desc foo_pins[] = {
      PINCTRL_PIN(0, "A8"),
      PINCTRL_PIN(1, "B8"),
      PINCTRL_PIN(2, "C8"),
      ...
      PINCTRL_PIN(61, "F1"),
      PINCTRL_PIN(62, "G1"),
      PINCTRL_PIN(63, "H1"),
};

Fixed this, will send another patch.

> -static struct pinctrl_gpio_range gpio_range_a = {
> +static struct pinctrl_gpio_range gpio_range_b = {

OK fixed this.

>        .name = "chip b",
>        .id = 0,
>        .base = 48,
> @@ -762,42 +762,42 @@ case), we define a mapping like this:
>        .name "2bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_0_grp",
> +       .group = "mmc0_1_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "4bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_0_grp",
> +       .group = "mmc0_1_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "4bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_1_grp",
> +       .group = "mmc0_2_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "8bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_0_grp",
> +       .group = "mmc0_1_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "8bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_1_grp",
> +       .group = "mmc0_2_grp",
>        .dev_name = "foo-mmc.0",
>  },
>  {
>        .name "8bit"
>        .ctrl_dev_name = "pinctrl.0",
>        .function = "mmc0",
> -       .group = "mmc0_2_grp",
> +       .group = "mmc0_3_grp",
>        .dev_name = "foo-mmc.0",
>  },


OK fixed this...

I'll submit a separate patch with your
Reported-by: and Randy's fixes folded in.

Thanks,
Linus Walleij
