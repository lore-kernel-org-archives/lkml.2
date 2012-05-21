Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2EUMNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:13:43 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:39477 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab2EUMNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:13:40 -0400
Message-ID: <4FBA316E.9050005@slimlogic.co.uk>
Date: Mon, 21 May 2012 13:13:34 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: palmas: Use regulator_[list|map]_voltage_linear()
 for palmas_ops_smps10
References: <1337600801.2615.1.camel@phoenix>
In-Reply-To: <1337600801.2615.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a good improvement I missed.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

On 21/05/12 12:46, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/palmas-regulator.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 9b7ca90..4fd8333 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -400,19 +400,14 @@ static struct regulator_ops palmas_ops_smps = {
>  	.map_voltage		= palmas_map_voltage_smps,
>  };
>  
> -static int palmas_list_voltage_smps10(struct regulator_dev *dev,
> -					unsigned selector)
> -{
> -	return 3750000 + (selector * 1250000);
> -}
> -
>  static struct regulator_ops palmas_ops_smps10 = {
>  	.is_enabled		= regulator_is_enabled_regmap,
>  	.enable			= regulator_enable_regmap,
>  	.disable		= regulator_disable_regmap,
>  	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
>  	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
> -	.list_voltage		= palmas_list_voltage_smps10,
> +	.list_voltage		= regulator_list_voltage_linear;
> +	.map_voltage		= regulator_map_voltage_linear;
>  };
>  
>  static int palmas_is_enabled_ldo(struct regulator_dev *dev)
> @@ -675,6 +670,8 @@ static __devinit int palmas_probe(struct platform_device *pdev)
>  			pmic->desc[id].vsel_mask = SMPS10_VSEL;
>  			pmic->desc[id].enable_reg = PALMAS_SMPS10_STATUS;
>  			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
> +			pmic->desc[id].min_uV = 3750000;
> +			pmic->desc[id].uV_step = 1250000;
>  		}
>  
>  		pmic->desc[id].type = REGULATOR_VOLTAGE;

