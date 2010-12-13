Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0LMUqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:46:09 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:63095 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676Ab0LMUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:46:07 -0500
Message-ID: <4D068600.4030405@metafoo.de>
Date: Mon, 13 Dec 2010 21:45:52 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/20] mfd: jz4740-adc: irq_data conversion.
References: <cover.1292241952.git.buytenh@wantstofly.org> <20101213123043.GR15575@mail.wantstofly.org>
In-Reply-To: <20101213123043.GR15575@mail.wantstofly.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi

There was already a similar patch yesterday:
https://lkml.org/lkml/2010/12/12/111

Thanks,
- - Lars


On 12/13/2010 01:30 PM, Lennert Buytenhek wrote:
> Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
> ---
>  drivers/mfd/jz4740-adc.c |   25 +++++++++++++------------
>  1 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
> index 9dd1b33..955b0d0 100644
> --- a/drivers/mfd/jz4740-adc.c
> +++ b/drivers/mfd/jz4740-adc.c
> @@ -84,31 +84,32 @@ static inline void jz4740_adc_irq_set_masked(struct jz4740_adc *adc, int irq,
>  	spin_unlock_irqrestore(&adc->lock, flags);
>  }
>  
> -static void jz4740_adc_irq_mask(unsigned int irq)
> +static void jz4740_adc_irq_mask(struct irq_data *d)
>  {
> -	struct jz4740_adc *adc = get_irq_chip_data(irq);
> -	jz4740_adc_irq_set_masked(adc, irq, true);
> +	struct jz4740_adc *adc = irq_data_get_irq_chip_data(d);
> +	jz4740_adc_irq_set_masked(adc, d->irq, true);
>  }
>  
> -static void jz4740_adc_irq_unmask(unsigned int irq)
> +static void jz4740_adc_irq_unmask(struct irq_data *d)
>  {
> -	struct jz4740_adc *adc = get_irq_chip_data(irq);
> -	jz4740_adc_irq_set_masked(adc, irq, false);
> +	struct jz4740_adc *adc = irq_data_get_irq_chip_data(d);
> +	jz4740_adc_irq_set_masked(adc, d->irq, false);
>  }
>  
> -static void jz4740_adc_irq_ack(unsigned int irq)
> +static void jz4740_adc_irq_ack(struct irq_data *d)
>  {
> -	struct jz4740_adc *adc = get_irq_chip_data(irq);
> +	struct jz4740_adc *adc = irq_data_get_irq_chip_data(d);
> +	unsigned int irq;
>  
> -	irq -= adc->irq_base;
> +	irq = d->irq - adc->irq_base;
>  	writeb(BIT(irq), adc->base + JZ_REG_ADC_STATUS);
>  }
>  
>  static struct irq_chip jz4740_adc_irq_chip = {
>  	.name = "jz4740-adc",
> -	.mask = jz4740_adc_irq_mask,
> -	.unmask = jz4740_adc_irq_unmask,
> -	.ack = jz4740_adc_irq_ack,
> +	.irq_mask = jz4740_adc_irq_mask,
> +	.irq_unmask = jz4740_adc_irq_unmask,
> +	.irq_ack = jz4740_adc_irq_ack,
>  };
>  
>  static void jz4740_adc_irq_demux(unsigned int irq, struct irq_desc *desc)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0Ghf8ACgkQBX4mSR26RiMr4ACeJpqumfCY2TOrQQRTNVW7atwn
yJAAn37a/pAJl/Gih1quoNuI+tgtje9z
=QOer
-----END PGP SIGNATURE-----
