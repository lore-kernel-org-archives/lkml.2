Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2FTDoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:44:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53411 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2FTDoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <1340141912-13111-1-git-send-email-linus.walleij@stericsson.com>
References: <1340141912-13111-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 20 Jun 2012 09:14:00 +0530
Message-ID: <CADTbHxrmDQZ8UpSVwDPXiD21SrqUmid-fQ_9+eVBVaAk08MaDQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/coh901: use clk_prepare_enable()
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 3:08 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> The COH901 GPIO driver did not prepare its clock, so let us
> fix it to do so.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-coh901.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
> index 55697a5..1b5d232a 100644
> --- a/drivers/pinctrl/pinctrl-coh901.c
> +++ b/drivers/pinctrl/pinctrl-coh901.c
> @@ -770,7 +770,7 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
>                dev_err(gpio->dev, "could not get GPIO clock\n");
>                goto err_no_clk;
>        }
> -       err = clk_enable(gpio->clk);
> +       err = clk_prepare_enable(gpio->clk);
>        if (err) {
>                dev_err(gpio->dev, "could not enable GPIO clock\n");
>                goto err_no_clk_enable;

What about clk_disable_unprepare() in error path?

Regards,
Pankaj Jangra
