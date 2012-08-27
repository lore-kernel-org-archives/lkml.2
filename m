Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2H0Mdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 08:33:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43894 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2H0Mdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 08:33:42 -0400
MIME-Version: 1.0
In-Reply-To: <1345996865-32082-8-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
	<1345996865-32082-8-git-send-email-Julia.Lawall@lip6.fr>
Date: Mon, 27 Aug 2012 14:33:40 +0200
Message-ID: <CAPDyKFpf+PzMspT7CECpd=ZVdmp=7i4-pr-6StK8N1aRczNryw@mail.gmail.com>
Subject: Re: [PATCH 7/13] drivers/mmc/host/mmci.c: use clk_prepare_enable and clk_disable_unprepare
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Chris Ball <cjb@laptop.org>, kernel-janitors@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

Patches for mmci should normally be sent on the arm list as well. mmci
is maintained by Russell King, even if the MAINTAINER file does not
say so.

Some minor comment below.

On 26 August 2012 18:00, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>

I think can simplify the commit msg a lot. Just say something with
"simplify clock code in probe".

> Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
> clk_enable, and clk_disable and clk_unprepare.  They make the code more
> concise, and ensure that clk_unprepare is called when clk_enable fails.
>
> A simplified version of the semantic patch that introduces calls to these
> functions is as follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression e;
> @@
>
> - clk_prepare(e);
> - clk_enable(e);
> + clk_prepare_enable(e);
>
> @@
> expression e;
> @@
>
> - clk_disable(e);
> - clk_unprepare(e);
> + clk_disable_unprepare(e);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/mmc/host/mmci.c |   13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index 50ff19a..edc3e9b 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -1309,14 +1309,10 @@ static int __devinit mmci_probe(struct amba_device *dev,
>                 goto host_free;
>         }
>
> -       ret = clk_prepare(host->clk);
> +       ret = clk_prepare_enable(host->clk);

white space? Did you run checkpatch?

>         if (ret)
>                 goto clk_free;
>
> -       ret = clk_enable(host->clk);
> -       if (ret)
> -               goto clk_unprep;
> -
>         host->plat = plat;
>         host->variant = variant;
>         host->mclk = clk_get_rate(host->clk);
> @@ -1515,9 +1511,7 @@ static int __devinit mmci_probe(struct amba_device *dev,
>   err_gpio_cd:
>         iounmap(host->base);
>   clk_disable:
> -       clk_disable(host->clk);
> - clk_unprep:
> -       clk_unprepare(host->clk);
> +       clk_disable_unprepare(host->clk);

white space? Did you run checkpatch?

>   clk_free:
>         clk_put(host->clk);
>   host_free:
> @@ -1564,8 +1558,7 @@ static int __devexit mmci_remove(struct amba_device *dev)
>                         gpio_free(host->gpio_cd);
>
>                 iounmap(host->base);
> -               clk_disable(host->clk);
> -               clk_unprepare(host->clk);
> +               clk_disable_unprepare(host->clk);

white space? Did you run checkpatch?

>                 clk_put(host->clk);
>
>                 if (host->vcc)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Kind regards
Ulf Hansson
