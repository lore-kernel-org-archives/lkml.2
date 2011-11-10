Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab1KJLGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 06:06:07 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38281 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab1KJLGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 06:06:05 -0500
Message-ID: <1320923106.2594.0.camel@anarsoul-laptop.Home>
Subject: Re: [PATCH] s3c-adc-battery: Add naive POWER_SUPPLY_PROP_PRESENT
 implementation
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Date: Thu, 10 Nov 2011 14:05:06 +0300
In-Reply-To: <201111100956.43979.heiko@sntech.de>
References: <201111100956.43979.heiko@sntech.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 09:56 +0100, Heiko Stübner wrote:
> Userspace programs like upower seem to depend on the presence of the
> POWER_SUPPLY_PROP_PRESENT property.
> 
> The real presence of the battery cannot be sensed and all other
> routines of s3c-adc-battery simply expect it to be present.
> 
> Therefore we simply return 1, unless the battery struct is not present at all.

Looks OK for me,

> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Vasily Khoruzhick <anarsoul@gmail.com>

> ---
>  drivers/power/s3c_adc_battery.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
> index d32d0d7..42d1f92 100644
> --- a/drivers/power/s3c_adc_battery.c
> +++ b/drivers/power/s3c_adc_battery.c
> @@ -51,6 +51,7 @@ static enum power_supply_property s3c_adc_backup_bat_props[] = {
>  	POWER_SUPPLY_PROP_VOLTAGE_NOW,
>  	POWER_SUPPLY_PROP_VOLTAGE_MIN,
>  	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
> +	POWER_SUPPLY_PROP_PRESENT,
>  };
>  
>  static int s3c_adc_backup_bat_get_property(struct power_supply *psy,
> @@ -60,6 +61,11 @@ static int s3c_adc_backup_bat_get_property(struct power_supply *psy,
>  	struct s3c_adc_bat *bat = container_of(psy, struct s3c_adc_bat, psy);
>  
>  	if (!bat) {
> +		if (psp == POWER_SUPPLY_PROP_PRESENT) {
> +			val->intval = 0;
> +			return 0;
> +		}
> +
>  		dev_err(psy->dev, "%s: no battery infos ?!\n", __func__);
>  		return -EINVAL;
>  	}
> @@ -83,6 +89,9 @@ static int s3c_adc_backup_bat_get_property(struct power_supply *psy,
>  	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
>  		val->intval = bat->pdata->backup_volt_max;
>  		return 0;
> +	case POWER_SUPPLY_PROP_PRESENT:
> +		val->intval = 1;
> +		return 0;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -106,6 +115,7 @@ static enum power_supply_property s3c_adc_main_bat_props[] = {
>  	POWER_SUPPLY_PROP_CHARGE_NOW,
>  	POWER_SUPPLY_PROP_VOLTAGE_NOW,
>  	POWER_SUPPLY_PROP_CURRENT_NOW,
> +	POWER_SUPPLY_PROP_PRESENT,
>  };
>  
>  static int calc_full_volt(int volt_val, int cur_val, int impedance)
> @@ -132,6 +142,11 @@ static int s3c_adc_bat_get_property(struct power_supply *psy,
>  	unsigned int lut_size = bat->pdata->lut_noac_cnt;
>  
>  	if (!bat) {
> +		if (psp == POWER_SUPPLY_PROP_PRESENT) {
> +			val->intval = 0;
> +			return 0;
> +		}
> +
>  		dev_err(psy->dev, "no battery infos ?!\n");
>  		return -EINVAL;
>  	}
> @@ -205,6 +220,9 @@ static int s3c_adc_bat_get_property(struct power_supply *psy,
>  	case POWER_SUPPLY_PROP_CURRENT_NOW:
>  		val->intval = bat->cur_value;
>  		return 0;
> +	case POWER_SUPPLY_PROP_PRESENT:
> +		val->intval = 1;
> +		return 0;
>  	default:
>  		return -EINVAL;
>  	}


