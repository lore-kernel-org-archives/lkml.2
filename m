Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1HaN0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:26:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45714 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab1HaN0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:26:35 -0400
Message-ID: <4E5E3681.9040206@ti.com>
Date: Wed, 31 Aug 2011 14:26:25 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] regulator: tps65910: verify dcdc regulator ids
References: <1313405127-2724-3-git-send-email-jhovold@gmail.com> <1314720426-23007-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1314720426-23007-1-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/11 17:07, Johan Hovold wrote:
> Add default case to switches in dcdc voltage functions.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  drivers/regulator/tps65910-regulator.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
> index 66d2d60..633ecd4 100644
> --- a/drivers/regulator/tps65910-regulator.c
> +++ b/drivers/regulator/tps65910-regulator.c
> @@ -534,6 +534,8 @@ static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
>  		srvsel &= VDDCTRL_SR_SEL_MASK;
>  		vselmax = 64;
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	/* multiplier 0 == 1 but 2,3 normal */
> @@ -688,6 +690,9 @@ static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
>  	case TPS65911_REG_VDDCTRL:
>  		vsel = selector;
>  		tps65910_reg_write(pmic, TPS65911_VDDCTRL_OP, vsel);
> +		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	return 0;

Applied.

Thanks

Liam
