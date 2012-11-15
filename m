Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993475Ab2KOOm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:42:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40109 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993283Ab2KOOm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:42:57 -0500
MIME-Version: 1.0
In-Reply-To: <1352955365.6793.6.camel@phoenix>
References: <1352955096.6793.1.camel@phoenix>
	<1352955365.6793.6.camel@phoenix>
Date: Thu, 15 Nov 2012 15:42:56 +0100
Message-ID: <CACRpkdbWqFrP7RvXbaR5Bcz1htCL_wSqwUvOi67LmoF_PBjvhg@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: nomadik: Prevent NULL dereference if
 of_match_device returns NULL
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>, Lee Jones <lee.jones@linaro.org>
Cc: Patrice Chotard <patrice.chotard@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 5:56 AM, Axel Lin <axel.lin@ingics.com> wrote:

> of_match_device() may return NULL.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pinctrl/pinctrl-nomadik.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
> index 238060e..40bd1b3 100644
> --- a/drivers/pinctrl/pinctrl-nomadik.c
> +++ b/drivers/pinctrl/pinctrl-nomadik.c
> @@ -1863,9 +1863,14 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
>
>         if (platid)
>                 version = platid->driver_data;
> -       else if (np)
> -               version = (unsigned int)
> -                       of_match_device(nmk_pinctrl_match, &pdev->dev)->data;
> +       else if (np) {
> +               const struct of_device_id *match;
> +
> +               match = of_match_device(nmk_pinctrl_match, &pdev->dev);
> +               if (!match)
> +                       return -ENODEV;
> +               version = (unsigned int) match->data;
> +       }

AFAICT this can actually happen so patch applied, unless Lee
speaks against it.

Patches 1-3/4 are dropped though, as the maintainers didn't seem
to like them.

Yours,
Linus Walleij
