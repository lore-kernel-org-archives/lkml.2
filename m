Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab0HSCbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 22:31:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46592 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0HSCbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 22:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Wdf108LsgPeHEVsUzBljWbY28D03h2EUm5S2e+hIZacbj12Z0/gQBBrK8cquWK3+19
         nykHKouXoyFwIoAu00myHVjuD6wrRiQVaHt8+oyAMCN9+FeZDEu/zyRDb+H4W2zztPvL
         MA4hmuRsJT3yvDasZijyNVwm2vrkEyghW3BvA=
MIME-Version: 1.0
In-Reply-To: <1282184959.17508.3.camel@mola>
References: <1282184959.17508.3.camel@mola>
Date: Thu, 19 Aug 2010 11:30:59 +0900
X-Google-Sender-Auth: t27JlW4rza86vWvRbDN9BitR7YU
Message-ID: <AANLkTik0V38bCEsd5n5q9bMftbrTdKmebrVHg=uErKUT@mail.gmail.com>
Subject: Re: [PATCH RESEND] regulator: max8998 - fix memory allocation size
 for max8998->rdev
From: Kyungmin Park <kmpark@infradead.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Thu, Aug 19, 2010 at 11:29 AM, Axel Lin <axel.lin@gmail.com> wrote:
> We only use max8998->rdev[0] .. max8998->rdev[pdata->num_regulators-1],
> max8998->rdev[pdata->num_regulators] is not used.
> Thus fix the memory allocation size.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> Looks like this patch is missing. So here is a resend for Liam.
>
>  drivers/regulator/max8998.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
> index ab67298..fbcb385 100644
> --- a/drivers/regulator/max8998.c
> +++ b/drivers/regulator/max8998.c
> @@ -549,7 +549,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
>        if (!max8998)
>                return -ENOMEM;
>
> -       size = sizeof(struct regulator_dev *) * (pdata->num_regulators + 1);
> +       size = sizeof(struct regulator_dev *) * pdata->num_regulators;
>        max8998->rdev = kzalloc(size, GFP_KERNEL);
>        if (!max8998->rdev) {
>                kfree(max8998);
> @@ -583,7 +583,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
>
>        return 0;
>  err:
> -       for (i = 0; i <= max8998->num_regulators; i++)
> +       for (i = 0; i < max8998->num_regulators; i++)
>                if (rdev[i])
>                        regulator_unregister(rdev[i]);
>
> @@ -599,7 +599,7 @@ static int __devexit max8998_pmic_remove(struct platform_device *pdev)
>        struct regulator_dev **rdev = max8998->rdev;
>        int i;
>
> -       for (i = 0; i <= max8998->num_regulators; i++)
> +       for (i = 0; i < max8998->num_regulators; i++)
>                if (rdev[i])
>                        regulator_unregister(rdev[i]);
>
> --
> 1.7.2
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
