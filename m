Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2GBE0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:26:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37242 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2GBE0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:26:18 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1206271714270.24173@axis700.grange>
References: <Pine.LNX.4.64.1206271714270.24173@axis700.grange>
Date: Mon, 2 Jul 2012 09:56:17 +0530
Message-ID: <CADTbHxrQtkm_WyMfJvnKtNJi=sjgf46EmWOp6g8053C4R_v7hQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: always save error codes in mmc_regulator_get_supply()
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 27, 2012 at 8:48 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> If mmc_regulator_get_supply() fails to obtain any of the regulators, store
> the error codes in struct mmc_host to unify error reporting to the host
> driver.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Chris, if you don't mind rebasing your mmc-next branch, feel free to roll
> this patch into the original "mmc: add a function to get regulators,
> supplying card's power". Otherwise, committing it as an incremental patch
> is also ok.
>
>  drivers/mmc/core/core.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 385cadf..d0f17d8 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1020,13 +1020,12 @@ int mmc_regulator_get_supply(struct mmc_host *mmc)
>         int ret;
>
>         supply = devm_regulator_get(dev, "vmmc");
> +       mmc->supply.vmmc = supply;
> +       mmc->supply.vqmmc = devm_regulator_get(dev, "vqmmc");
>
>         if (IS_ERR(supply))
>                 return PTR_ERR(supply);
>
> -       mmc->supply.vmmc = supply;
> -       mmc->supply.vqmmc = devm_regulator_get(dev, "vqmmc");
> -

I have a doubt here. Though  i am not much know to mmc code, but could
you please explain what is the benefit of moving these
statements above the error checking. I mean if you are not able to get
"vmmc" supply then why do you care to get the supply "vqmmc"
while by this error check you want to bail out from here ASAP and also
by doing this you are unnecessarily increasing the consumer
for "vqmmc" supply.  Please let me know if i am missing something here.

Also if you want to save the error code only you may want to move the
statement "mmc->supply.vmmc = supply"  only above the error
checking right?

>         ret = mmc_regulator_get_ocrmask(supply);
>         if (ret > 0)
>                 mmc->ocr_avail = ret;
> --

Regards,
Pankaj Jangra
