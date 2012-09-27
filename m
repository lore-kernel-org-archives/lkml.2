Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2I0NoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:44:11 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:56038 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2I0NoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:44:10 -0400
X-Auth-Info: 1kij2cmfyZHF/5XrX3aS1fgJ1wkO64TAskO6gjlvXFU=
From: Marek Vasut <marex@denx.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] mfd: da9052-core: Fix request_threaded_irq() parameter
Date: Thu, 27 Sep 2012 15:21:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1348718135-10300-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1348718135-10300-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209271521.07084.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Fabio Estevam,

> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> On a mx53qsb dt-kernel the da9052-core driver fails to probe:
> 
> da9052 1-0048: DA9052 ADC IRQ failed ret=-22
> 
> In request_threaded_irq() the first parameter is missing the
> da9052->irq_base.
> 
> Fix it and avoid the error.
> 
> Also define 'DA9052_IRQF' for improving readability.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Reviewed-by: Marek Vasut <marex@denx.de>

> ---
>  drivers/mfd/da9052-core.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
> index a0a62b2..a3450d2 100644
> --- a/drivers/mfd/da9052-core.c
> +++ b/drivers/mfd/da9052-core.c
> @@ -33,6 +33,7 @@
>  #define DA9052_IRQ_MASK_POS_6		0x20
>  #define DA9052_IRQ_MASK_POS_7		0x40
>  #define DA9052_IRQ_MASK_POS_8		0x80
> +#define DA9052_IRQF			(IRQF_TRIGGER_LOW | IRQF_ONESHOT)
> 
>  static bool da9052_reg_readable(struct device *dev, unsigned int reg)
>  {
> @@ -788,16 +789,15 @@ int __devinit da9052_device_init(struct da9052
> *da9052, u8 chip_id) da9052->irq_base = pdata->irq_base;
> 
>  	ret = regmap_add_irq_chip(da9052->regmap, da9052->chip_irq,
> -				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> -				  da9052->irq_base, &da9052_regmap_irq_chip,
> -				  &da9052->irq_data);
> +				  DA9052_IRQF, da9052->irq_base,
> +				  &da9052_regmap_irq_chip, &da9052->irq_data);
>  	if (ret < 0)
>  		goto regmap_err;
> 
>  	da9052->irq_base = regmap_irq_chip_get_base(da9052->irq_data);
> 
> -	ret = request_threaded_irq(DA9052_IRQ_ADC_EOM, NULL, da9052_auxadc_irq,
> -				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +	ret = request_threaded_irq(da9052->irq_base + DA9052_IRQ_ADC_EOM, NULL,
> +				   da9052_auxadc_irq, DA9052_IRQF,
>  				   "adc irq", da9052);
>  	if (ret != 0)
>  		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);

Best regards,
Marek Vasut
