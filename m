Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2JKOWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:22:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42622 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2JKOWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:22:09 -0400
MIME-Version: 1.0
In-Reply-To: <1349964927-18619-2-git-send-email-lee.jones@linaro.org>
References: <1349964927-18619-1-git-send-email-lee.jones@linaro.org>
	<1349964927-18619-2-git-send-email-lee.jones@linaro.org>
Date: Thu, 11 Oct 2012 19:52:07 +0530
Message-ID: <CAM=Q2ctwTBAvKs401GgrGfz9NvaLspquje-6YfnuS5TZYeqY4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: gpio-keys: Add runtime support
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org,
        Philippe Langlais <philippe.langlais@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 7:45 PM, Lee Jones <lee.jones@linaro.org> wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
Some change logs would have helped.

>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
> Reviewed-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>  drivers/input/keyboard/gpio_keys.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> index 7947315..78de557 100644
> --- a/drivers/input/keyboard/gpio_keys.c
> +++ b/drivers/input/keyboard/gpio_keys.c
> @@ -29,6 +29,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/of_gpio.h>
>  #include <linux/spinlock.h>
> +#include <linux/pm_runtime.h>
>
>  struct gpio_button_data {
>         const struct gpio_keys_button *button;
> @@ -526,6 +527,7 @@ static int gpio_keys_open(struct input_dev *input)
>  {
>         struct gpio_keys_drvdata *ddata = input_get_drvdata(input);
>
> +       pm_runtime_get_sync(input->dev.parent);
I am not an expert of the runtime.

However would be grateful if you explain me what it actually do.

Also I did not see any runtime suspend/ resume handlers populated.
