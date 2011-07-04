Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab1GDQF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:05:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60026 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab1GDQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:05:55 -0400
Subject: Re: [PATCH] regulator: MAX8997: Fix for divide by zero error
From: Liam Girdwood <lrg@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1308627539-8980-1-git-send-email-tushar.behera@linaro.org>
References: <1308627539-8980-1-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 17:05:50 +0100
Message-ID: <1309795550.3272.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 09:08 +0530, Tushar Behera wrote:
> Currently, ramp_delay variable is used uninitialzed in
> max8997_set_voltage_ldobuck which gets called through
> regulator_register calls.
> 
> To fix the problem, in max8997_pmic_probe, ramp_delay initialization
> code is moved before calls to regulator_register.
> 
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/regulator/max8997.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index 10d5a1d..0fc7b8c 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -1124,6 +1124,10 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
>  				0x3f);
>  	}
>  
> +	/* Misc Settings */
> +	max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
> +	max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
> +
>  	for (i = 0; i < pdata->num_regulators; i++) {
>  		const struct voltage_map_desc *desc;
>  		int id = pdata->regulators[i].id;
> @@ -1148,10 +1152,6 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> -	/* Misc Settings */
> -	max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
> -	max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
> -
>  	return 0;
>  err:
>  	for (i = 0; i < max8997->num_regulators; i++)

Applied.

Thanks

Liam


