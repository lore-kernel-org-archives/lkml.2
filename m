Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2K2TTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:19:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9836 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2K2TTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:19:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 29 Nov 2012 11:18:50 -0800
Message-ID: <50B7B52A.30005@nvidia.com>
Date: Fri, 30 Nov 2012 00:49:06 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: tps65910: remove unused data
References: <A874F61F95741C4A9BA573A70FE3998F6418F1BB@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6418F1BB@DQHE02.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2012 02:18 PM, Kim, Milo wrote:
>   The 'io_mutex' is not used anywhere.
>   The regmap API supports the mutex internally, so no additional mutex required.
>
>   And 'domain' private data is unnecessary because the irq domain is
>   already registered by using regmap_add_irq_chip().
>
> Signed-off-by: Milo(Woogyom) Kim<milo.kim@ti.com>
> ---

Thanks, I missed on my cleanups.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
>   drivers/mfd/tps65910.c       |    1 -
>   include/linux/mfd/tps65910.h |    2 --
>   2 files changed, 3 deletions(-)
>
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index fdb3027..d5ef3a5 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -486,7 +486,6 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
>   	tps65910->dev =&i2c->dev;
>   	tps65910->i2c_client = i2c;
>   	tps65910->id = chip_id;
> -	mutex_init(&tps65910->io_mutex);
>
>   	tps65910->regmap = devm_regmap_init_i2c(i2c,&tps65910_regmap_config);
>   	if (IS_ERR(tps65910->regmap)) {
> diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
> index 0b16903..20e433e 100644
> --- a/include/linux/mfd/tps65910.h
> +++ b/include/linux/mfd/tps65910.h
> @@ -893,7 +893,6 @@ struct tps65910 {
>   	struct device *dev;
>   	struct i2c_client *i2c_client;
>   	struct regmap *regmap;
> -	struct mutex io_mutex;
>   	unsigned int id;
>
>   	/* Client devices */
> @@ -907,7 +906,6 @@ struct tps65910 {
>   	/* IRQ Handling */
>   	int chip_irq;
>   	struct regmap_irq_chip_data *irq_data;
> -	struct irq_domain *domain;
>   };
>
>   struct tps65910_platform_data {

