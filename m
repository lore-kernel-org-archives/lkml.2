Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0LOT6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:58:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11360 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab0LOT6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:58:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66760943"
Message-ID: <4D091DD2.3070300@codeaurora.org>
Date: Wed, 15 Dec 2010 11:58:10 -0800
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: Gregory Bean <gbean@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] gpio: sx150x: irq_data conversion.
References: <cover.1292240053.git.buytenh@wantstofly.org> <20101213120302.GF15575@mail.wantstofly.org>
In-Reply-To: <20101213120302.GF15575@mail.wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 4:03 AM, Lennert Buytenhek wrote:
> Signed-off-by: Lennert Buytenhek<buytenh@secretlab.ca>
Tested-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>   drivers/gpio/sx150x.c |   46 +++++++++++++++++++++++-----------------------
>   1 files changed, 23 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/gpio/sx150x.c b/drivers/gpio/sx150x.c
> index 823559a..e60be00 100644
> --- a/drivers/gpio/sx150x.c
> +++ b/drivers/gpio/sx150x.c
> @@ -304,36 +304,36 @@ static int sx150x_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
>   	return chip->irq_base + offset;
>   }
>
> -static void sx150x_irq_mask(unsigned int irq)
> +static void sx150x_irq_mask(struct irq_data *d)
>   {
> -	struct irq_chip *ic = get_irq_chip(irq);
> +	struct irq_chip *ic = irq_data_get_irq_chip(d);
>   	struct sx150x_chip *chip;
>   	unsigned n;
>
>   	chip = container_of(ic, struct sx150x_chip, irq_chip);
> -	n = irq - chip->irq_base;
> +	n = d->irq - chip->irq_base;
>
>   	sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 1);
>   	sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense, 0);
>   }
>
> -static void sx150x_irq_unmask(unsigned int irq)
> +static void sx150x_irq_unmask(struct irq_data *d)
>   {
> -	struct irq_chip *ic = get_irq_chip(irq);
> +	struct irq_chip *ic = irq_data_get_irq_chip(d);
>   	struct sx150x_chip *chip;
>   	unsigned n;
>
>   	chip = container_of(ic, struct sx150x_chip, irq_chip);
> -	n = irq - chip->irq_base;
> +	n = d->irq - chip->irq_base;
>
>   	sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 0);
>   	sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense,
>   			 chip->irq_sense>>  (n * 2));
>   }
>
> -static int sx150x_irq_set_type(unsigned int irq, unsigned int flow_type)
> +static int sx150x_irq_set_type(struct irq_data *d, unsigned int flow_type)
>   {
> -	struct irq_chip *ic = get_irq_chip(irq);
> +	struct irq_chip *ic = irq_data_get_irq_chip(d);
>   	struct sx150x_chip *chip;
>   	unsigned n, val = 0;
>
> @@ -341,7 +341,7 @@ static int sx150x_irq_set_type(unsigned int irq, unsigned int flow_type)
>   		return -EINVAL;
>
>   	chip = container_of(ic, struct sx150x_chip, irq_chip);
> -	n = irq - chip->irq_base;
> +	n = d->irq - chip->irq_base;
>
>   	if (flow_type&  IRQ_TYPE_EDGE_RISING)
>   		val |= 0x1;
> @@ -386,9 +386,9 @@ static irqreturn_t sx150x_irq_thread_fn(int irq, void *dev_id)
>   	return (nhandled>  0 ? IRQ_HANDLED : IRQ_NONE);
>   }
>
> -static void sx150x_irq_bus_lock(unsigned int irq)
> +static void sx150x_irq_bus_lock(struct irq_data *d)
>   {
> -	struct irq_chip *ic = get_irq_chip(irq);
> +	struct irq_chip *ic = irq_data_get_irq_chip(d);
>   	struct sx150x_chip *chip;
>
>   	chip = container_of(ic, struct sx150x_chip, irq_chip);
> @@ -396,9 +396,9 @@ static void sx150x_irq_bus_lock(unsigned int irq)
>   	mutex_lock(&chip->lock);
>   }
>
> -static void sx150x_irq_bus_sync_unlock(unsigned int irq)
> +static void sx150x_irq_bus_sync_unlock(struct irq_data *d)
>   {
> -	struct irq_chip *ic = get_irq_chip(irq);
> +	struct irq_chip *ic = irq_data_get_irq_chip(d);
>   	struct sx150x_chip *chip;
>   	unsigned n;
>
> @@ -437,16 +437,16 @@ static void sx150x_init_chip(struct sx150x_chip *chip,
>   	if (pdata->oscio_is_gpo)
>   		++chip->gpio_chip.ngpio;
>
> -	chip->irq_chip.name            = client->name;
> -	chip->irq_chip.mask            = sx150x_irq_mask;
> -	chip->irq_chip.unmask          = sx150x_irq_unmask;
> -	chip->irq_chip.set_type        = sx150x_irq_set_type;
> -	chip->irq_chip.bus_lock        = sx150x_irq_bus_lock;
> -	chip->irq_chip.bus_sync_unlock = sx150x_irq_bus_sync_unlock;
> -	chip->irq_summary              = -1;
> -	chip->irq_base                 = -1;
> -	chip->irq_sense                = 0;
> -	chip->irq_set_type_pending     = 0;
> +	chip->irq_chip.name                = client->name;
> +	chip->irq_chip.irq_mask            = sx150x_irq_mask;
> +	chip->irq_chip.irq_unmask          = sx150x_irq_unmask;
> +	chip->irq_chip.irq_set_type        = sx150x_irq_set_type;
> +	chip->irq_chip.irq_bus_lock        = sx150x_irq_bus_lock;
> +	chip->irq_chip.irq_bus_sync_unlock = sx150x_irq_bus_sync_unlock;
> +	chip->irq_summary                  = -1;
> +	chip->irq_base                     = -1;
> +	chip->irq_sense                    = 0;
> +	chip->irq_set_type_pending         = 0;
>   }
>
>   static int sx150x_init_io(struct sx150x_chip *chip, u8 base, u16 cfg)


Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

