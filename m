Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab0LNAZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:25:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60479 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0LNAY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:24:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RJqhPiIurxY28LyNGI9XOkJDBX2WDqk/wTCw4frePOlyCx8gxBQ4TKbjkLukJnBrsv
         k4OCJ+yAgSk2zoO2OUrNd8e6Hqjz+u3XKTLosxeksw8c4f6MlsvgNdKQUIuFmpw0U0pG
         e6BHs9X3+oUHlQUOO06XzjaSsBt6/TrVvk+e4=
MIME-Version: 1.0
In-Reply-To: <20101213123058.GT15575@mail.wantstofly.org>
References: <cover.1292241952.git.buytenh@wantstofly.org>
	<20101213123058.GT15575@mail.wantstofly.org>
Date: Tue, 14 Dec 2010 09:24:57 +0900
X-Google-Sender-Auth: 8jBQBe_gCkD8SLWKLCdRd3Oj7PA
Message-ID: <AANLkTinJg-zNBjkRkGBnVgdvHaNw4VKV78KFNqZtC41V@mail.gmail.com>
Subject: Re: [PATCH 10/20] mfd: max8998: irq_data conversion.
From: Kyungmin Park <kmpark@infradead.org>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Mon, Dec 13, 2010 at 9:30 PM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
> ---
>  drivers/mfd/max8998-irq.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/mfd/max8998-irq.c b/drivers/mfd/max8998-irq.c
> index 45bfe77..dca3c65 100644
> --- a/drivers/mfd/max8998-irq.c
> +++ b/drivers/mfd/max8998-irq.c
> @@ -102,16 +102,16 @@ irq_to_max8998_irq(struct max8998_dev *max8998, int irq)
>        return &max8998_irqs[irq - max8998->irq_base];
>  }
>
> -static void max8998_irq_lock(unsigned int irq)
> +static void max8998_irq_lock(struct irq_data *d)
>  {
> -       struct max8998_dev *max8998 = get_irq_chip_data(irq);
> +       struct max8998_dev *max8998 = irq_data_get_irq_chip_data(d);
>
>        mutex_lock(&max8998->irqlock);
>  }
>
> -static void max8998_irq_sync_unlock(unsigned int irq)
> +static void max8998_irq_sync_unlock(struct irq_data *d)
>  {
> -       struct max8998_dev *max8998 = get_irq_chip_data(irq);
> +       struct max8998_dev *max8998 = irq_data_get_irq_chip_data(d);
>        int i;
>
>        for (i = 0; i < ARRAY_SIZE(max8998->irq_masks_cur); i++) {
> @@ -129,28 +129,28 @@ static void max8998_irq_sync_unlock(unsigned int irq)
>        mutex_unlock(&max8998->irqlock);
>  }
>
> -static void max8998_irq_unmask(unsigned int irq)
> +static void max8998_irq_unmask(struct irq_data *d)
>  {
> -       struct max8998_dev *max8998 = get_irq_chip_data(irq);
> -       struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, irq);
> +       struct max8998_dev *max8998 = irq_data_get_irq_chip_data(d);
> +       struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, d->irq);
>
>        max8998->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
>  }
>
> -static void max8998_irq_mask(unsigned int irq)
> +static void max8998_irq_mask(struct irq_data *d)
>  {
> -       struct max8998_dev *max8998 = get_irq_chip_data(irq);
> -       struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, irq);
> +       struct max8998_dev *max8998 = irq_data_get_irq_chip_data(d);
> +       struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, d->irq);
>
>        max8998->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
>  }
>
>  static struct irq_chip max8998_irq_chip = {
>        .name = "max8998",
> -       .bus_lock = max8998_irq_lock,
> -       .bus_sync_unlock = max8998_irq_sync_unlock,
> -       .mask = max8998_irq_mask,
> -       .unmask = max8998_irq_unmask,
> +       .irq_bus_lock = max8998_irq_lock,
> +       .irq_bus_sync_unlock = max8998_irq_sync_unlock,
> +       .irq_mask = max8998_irq_mask,
> +       .irq_unmask = max8998_irq_unmask,
>  };
>
>  static irqreturn_t max8998_irq_thread(int irq, void *data)
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
