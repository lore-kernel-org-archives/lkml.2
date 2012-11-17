Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2KQUbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 15:31:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54417 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2KQUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 15:31:44 -0500
MIME-Version: 1.0
In-Reply-To: <1353048646-10935-7-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
	<1353048646-10935-7-git-send-email-tushar.behera@linaro.org>
Date: Sat, 17 Nov 2012 21:31:43 +0100
Message-ID: <CACRpkdZ5EyiKrUDNaa4Rkn_cbJF1yD91CcpNfwxNXAd58FP8Aw@mail.gmail.com>
Subject: Re: [PATCH 06/14] pinctrl: samsung: Update error check for unsigned variables
From: Linus Walleij <linus.walleij@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 7:50 AM, Tushar Behera <tushar.behera@linaro.org> wrote:

> Checking '< 0' for unsigned variables always returns false. For error
> codes, use IS_ERR_VALUE() instead.
>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-samsung.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
> index 81c9896..3b52c17 100644
> --- a/drivers/pinctrl/pinctrl-samsung.c
> +++ b/drivers/pinctrl/pinctrl-samsung.c
> @@ -560,7 +560,7 @@ static int __devinit samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
>         const char *pin_name;
>
>         *npins = of_property_count_strings(cfg_np, "samsung,pins");
> -       if (*npins < 0) {
> +       if (IS_ERR_VALUE(*npins)) {
>                 dev_err(dev, "invalid pin list in %s node", cfg_np->name);
>                 return -EINVAL;
>         }

Acked-by: Linus Walleij <linus.walleij@linaro.org>

For this merge window Kukjin is handling the Samsung pinctrl patches,
Kukjin can you pick this to your tree to avoid any mess?

Yours,
Linus Walleij
