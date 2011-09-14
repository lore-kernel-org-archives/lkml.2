Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1INTO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:14:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46580 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab1INTO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <1316023462-3287-1-git-send-email-rklein@nvidia.com>
References: <1316023462-3287-1-git-send-email-rklein@nvidia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Sep 2011 13:14:08 -0600
X-Google-Sender-Auth: 46ZEL5zDx2vHahX-yfZWcVLQnuQ
Message-ID: <CACxGe6uWvWz-8rFVv4HPs_DgoJabV2N0aUQTx7xJ8Zr6thkSMA@mail.gmail.com>
Subject: Re: [PATCH v4] power: bq20z75: devicetree init support
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 12:04 PM, Rhyland Klein <rklein@nvidia.com> wrote:
> Adding support to generate platform data when kernel is configured
> through device tree.
>
> Also adding the binding for the TI bq20z75 fuel gadge and the
> bq20z75 driver.
>
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>        v2: Fixed typo in binding description
>        v3: Changed to use "ti," for properties
>            Changed to use single gpio entry for battery detect info.
>            Removed unnecessary call to of_match_device.
>        v4: squashed bindings and drivers changes together.
>            fixed case where CONFIG_OF is not selected, to return existing
>            pdata pointer if it exists.

Nit: Personally, I'm much happier when the revision list is above the
--- line so it appears in the linux commit text.  That helps when
trying to figure out exactly which posting of a patch got merged.

>
> diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
> index 9c5e5be..4c4669e 100644
> --- a/drivers/power/bq20z75.c
> +++ b/drivers/power/bq20z75.c
> @@ -613,6 +613,78 @@ static void bq20z75_delayed_work(struct work_struct *work)
>        }
>  }
>
> +#if defined(CONFIG_OF)
> +#include <linux/of_device.h>
> +static const struct of_device_id bq20z75_dt_ids[] = {
> +       { .compatible = "ti,bq20z75" },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(platform, bq20z75_dt_ids);

MODULE_DEVICE_TABLE(of, ...)

It's not a platform_device_id table.

Otherwise:

Acked-by: Grant Likely <grant.likely@secretlab.ca>
