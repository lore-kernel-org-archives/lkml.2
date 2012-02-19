Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2BSIF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 03:05:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51868 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab2BSIFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 03:05:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.28.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329637811.11495.1.camel@phoenix>
References: <1329637811.11495.1.camel@phoenix>
Date: Sun, 19 Feb 2012 16:05:25 +0800
Message-ID: <CAJd=RBDodt3cDcwxy8q+ntF1QimNZULFT_9NpAVYi23paYeYPg@mail.gmail.com>
Subject: Re: [PATCH] mfd: tps65912: Initialize irq platform data properly
From: Hillf Danton <dhillf@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 3:50 PM, Axel Lin <axel.lin@gmail.com> wrote:
> irq_base of the tps65912 irq platform data should be
> initialized with the board provided irq_base data.
>

The description only tells what you did, but why?

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/tps65912-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
> index 5fec23a..74fd8cb 100644
> --- a/drivers/mfd/tps65912-core.c
> +++ b/drivers/mfd/tps65912-core.c
> @@ -151,7 +151,7 @@ int tps65912_device_init(struct tps65912 *tps65912)
>                goto err;
>
>        init_data->irq = pmic_plat_data->irq;
> -       init_data->irq_base = pmic_plat_data->irq;
> +       init_data->irq_base = pmic_plat_data->irq_base;
>        ret = tps65912_irq_init(tps65912, init_data->irq, init_data);
>        if (ret < 0)
>                goto err;
> --
> 1.7.5.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
