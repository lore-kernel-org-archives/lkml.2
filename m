Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab2H3MPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 08:15:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59442 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2H3MPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:15:20 -0400
Date: Thu, 30 Aug 2012 05:12:53 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/8] lp8727_charger: make cosmetic code
Message-ID: <20120830121252.GB11289@lizard>
References: <A874F61F95741C4A9BA573A70FE3998F41EF1CD7@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF1CD7@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:41:01AM +0000, Kim, Milo wrote:
> (a) change the return type of lp8727_is_charger_attached()
> (b) remove unnecessary name comparison in lp8727_is_charger_attached()

This seems not too 'cosmetic'. Maybe a separate patch for this?
It looks trivial enough, but still, it's usually a good idea to
do one thing per patch.

> (c) return as the result of function in lp8727_init_device()
> (d) make inline function for lp8727_ctrl_switch()
> (e) use specific definition rather than magic number in lp8727_delayed_func()
> (f) make simple code in power_supply_get_properties
> (g) make simple code in lp8727_charger_changed()

Ditto for these two.

> (h) fix checkpatch warning on MODULE_AUTHOR
> (i) fit spaces for description in header
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/power/lp8727_charger.c       |   77 ++++++++++++++++++----------------
>  include/linux/platform_data/lp8727.h |    2 +-
>  2 files changed, 41 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
> index 610d286..41bc0f3 100644
> --- a/drivers/power/lp8727_charger.c
> +++ b/drivers/power/lp8727_charger.c
> @@ -121,14 +121,12 @@ static inline int lp8727_write_byte(struct lp8727_chg *pchg, u8 reg, u8 data)
>  	return i2c_smbus_write_byte_data(pchg->client, reg, data);
>  }
>  
> -static int lp8727_is_charger_attached(const char *name, int id)
> +static bool lp8727_is_charger_attached(const char *name, int id)
>  {
> -	if (name) {
> -		if (!strcmp(name, "ac"))
> -			return id == LP8727_CHG_TA || id == LP8727_CHG_DEDICATED;
> -		else if (!strcmp(name, "usb"))
> -			return id == LP8727_CHG_USB;
> -	}
> +	if (!strcmp(name, "ac"))
> +		return id == LP8727_CHG_TA || id == LP8727_CHG_DEDICATED;
> +	else if (!strcmp(name, "usb"))
> +		return id == LP8727_CHG_USB;
>  
>  	return id >= LP8727_CHG_TA && id <= LP8727_CHG_USB;
>  }
> @@ -150,16 +148,13 @@ static int lp8727_init_device(struct lp8727_chg *pchg)
>  		return ret;
>  
>  	val = LP8727_INT_EN | LP8727_CHGDET_EN;
> -	ret = lp8727_write_byte(pchg, LP8727_CTRL2, val);
> -	if (ret)
> -		return ret;
> -
> -	return 0;
> +	return lp8727_write_byte(pchg, LP8727_CTRL2, val);
>  }
>  
>  static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
>  {
>  	u8 val;
> +
>  	lp8727_read_byte(pchg, LP8727_STATUS1, &val);
>  	return val & LP8727_DCPORT;
>  }
> @@ -167,11 +162,12 @@ static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
>  static int lp8727_is_usb_charger(struct lp8727_chg *pchg)
>  {
>  	u8 val;
> +
>  	lp8727_read_byte(pchg, LP8727_STATUS1, &val);
>  	return val & LP8727_CHPORT;
>  }
>  
> -static void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
> +static inline void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
>  {
>  	lp8727_write_byte(pchg, LP8727_SWCTRL, sw);
>  }
> @@ -221,11 +217,13 @@ static void lp8727_enable_chgdet(struct lp8727_chg *pchg)
>  
>  static void lp8727_delayed_func(struct work_struct *_work)
>  {
> -	u8 intstat[2], idno, vbus;
> -	struct lp8727_chg *pchg =
> -	    container_of(_work, struct lp8727_chg, work.work);
> +	struct lp8727_chg *pchg = container_of(_work, struct lp8727_chg,
> +						work.work);
> +	u8 intstat[LP8788_NUM_INTREGS];
> +	u8 idno;
> +	u8 vbus;
>  
> -	if (lp8727_read_bytes(pchg, LP8727_INT1, intstat, 2)) {
> +	if (lp8727_read_bytes(pchg, LP8727_INT1, intstat, LP8788_NUM_INTREGS)) {
>  		dev_err(pchg->dev, "can not read INT registers\n");
>  		return;
>  	}
> @@ -308,9 +306,10 @@ static int lp8727_charger_get_property(struct power_supply *psy,
>  {
>  	struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
>  
> -	if (psp == POWER_SUPPLY_PROP_ONLINE)
> -		val->intval = lp8727_is_charger_attached(psy->name,
> -							 pchg->chg_type);
> +	if (psp != POWER_SUPPLY_PROP_ONLINE)
> +		return 0;
> +
> +	val->intval = lp8727_is_charger_attached(psy->name, pchg->chg_type);
>  
>  	return 0;
>  }
> @@ -338,15 +337,16 @@ static int lp8727_battery_get_property(struct power_supply *psy,
>  
>  	switch (psp) {
>  	case POWER_SUPPLY_PROP_STATUS:
> -		if (lp8727_is_charger_attached(psy->name, pchg->chg_type)) {
> -			lp8727_read_byte(pchg, LP8727_STATUS1, &read);
> +		if (!lp8727_is_charger_attached(psy->name, pchg->chg_type)) {
> +			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
> +			return 0;
> +		}
> +
> +		lp8727_read_byte(pchg, LP8727_STATUS1, &read);
>  
> -			val->intval = (read & LP8727_CHGSTAT) == LP8727_STAT_EOC ?
> +		val->intval = (read & LP8727_CHGSTAT) == LP8727_STAT_EOC ?
>  				POWER_SUPPLY_STATUS_FULL :
>  				POWER_SUPPLY_STATUS_CHARGING;
> -		} else {
> -			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
> -		}
>  		break;
>  	case POWER_SUPPLY_PROP_HEALTH:
>  		lp8727_read_byte(pchg, LP8727_STATUS2, &read);
> @@ -394,16 +394,20 @@ static int lp8727_battery_get_property(struct power_supply *psy,
>  static void lp8727_charger_changed(struct power_supply *psy)
>  {
>  	struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
> +	u8 eoc_level;
> +	u8 ichg;
>  	u8 val;
> -	u8 eoc_level, ichg;
> -
> -	if (lp8727_is_charger_attached(psy->name, pchg->chg_type)) {
> -		if (pchg->chg_param) {
> -			eoc_level = pchg->chg_param->eoc_level;
> -			ichg = pchg->chg_param->ichg;
> -			val = (ichg << LP8727_ICHG_SHIFT) | eoc_level;
> -			lp8727_write_byte(pchg, LP8727_CHGCTRL2, val);
> -		}
> +
> +	/* skip if no charger exists */
> +	if (!lp8727_is_charger_attached(psy->name, pchg->chg_type))
> +		return;
> +
> +	/* update charging parameters */
> +	if (pchg->chg_param) {
> +		eoc_level = pchg->chg_param->eoc_level;
> +		ichg = pchg->chg_param->ichg;
> +		val = (ichg << LP8727_ICHG_SHIFT) | eoc_level;
> +		lp8727_write_byte(pchg, LP8727_CHGCTRL2, val);
>  	}
>  }
>  
> @@ -538,6 +542,5 @@ static struct i2c_driver lp8727_driver = {
>  module_i2c_driver(lp8727_driver);
>  
>  MODULE_DESCRIPTION("TI/National Semiconductor LP8727 charger driver");
> -MODULE_AUTHOR("Woogyom Kim <milo.kim@ti.com>, "
> -	      "Daniel Jeong <daniel.jeong@ti.com>");
> +MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>");
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/platform_data/lp8727.h b/include/linux/platform_data/lp8727.h
> index 5b443a1..b564d02 100644
> --- a/include/linux/platform_data/lp8727.h
> +++ b/include/linux/platform_data/lp8727.h
> @@ -38,7 +38,7 @@ enum lp8727_ichg {
>  /**
>   * struct lp8727_chg_param
>   * @eoc_level : end of charge level setting
> - * @ichg : charging current
> + * @ichg      : charging current
>   */
>  struct lp8727_chg_param {
>  	enum lp8727_eoc_level eoc_level;
> -- 
> 1.7.9.5
