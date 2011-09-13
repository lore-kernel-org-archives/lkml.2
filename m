Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1IMGbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 02:31:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44505 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab1IMGbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 02:31:31 -0400
MIME-Version: 1.0
In-Reply-To: <1314185188-6151-1-git-send-email-jason.hui@linaro.org>
References: <1314185188-6151-1-git-send-email-jason.hui@linaro.org>
Date: Tue, 13 Sep 2011 14:31:30 +0800
Message-ID: <CAB4PhKd_=KjNGJ+3TL5tqPqoetcD28oaWC55UqNRqFGZ7gmYHw@mail.gmail.com>
Subject: Re: [[PATCH v2] mtd: check parts pointer before using it
From: Jason Liu <liu.h.jason@gmail.com>
To: Jason Liu <jason.hui@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, dedekind1@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, David.Woodhouse@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Artem,

2011/8/24 Jason Liu <jason.hui@linaro.org>:
> The code has the check for parts but it called after kmemdup,
> kmemdup(parts, sizeof(*parts) * nr_parts,...)
> if (!parts)
>        return -ENOMEM
>
> In fact, we need check parts before safely using it.
> and we also need check the real_parts to make sure kmemdup
> allocation sucessfully.
>
> Signed-off-by: Jason Liu <jason.hui@linaro.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: Artem Bityutskiy <artem.bityutskiy@intel.com>
> ---
> V2: Fix one error condition check and add real_parts check too.
> ---
> This patch is based on git://git.infradead.org/users/dedekind/l2-mtd-2.6.git
> ---
>  drivers/mtd/mtdcore.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 09bdbac..b01993e 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -465,12 +465,13 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char **types,
>        struct mtd_partition *real_parts;
>
>        err = parse_mtd_partitions(mtd, types, &real_parts, parser_data);
> -       if (err <= 0 && nr_parts) {
> +       if (err <= 0 && nr_parts && parts) {
>                real_parts = kmemdup(parts, sizeof(*parts) * nr_parts,
>                                     GFP_KERNEL);
> -               err = nr_parts;
> -               if (!parts)
> +               if (!real_parts)
>                        err = -ENOMEM;
> +               else
> +                       err = nr_parts;
>        }
>
>        if (err > 0) {
> --
> 1.7.4.1

Ping, any comments about it? Thanks,

Jason

>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
