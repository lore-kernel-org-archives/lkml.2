Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2I1BWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:22:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55460 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab2I1BWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:22:11 -0400
Date: Thu, 27 Sep 2012 18:19:30 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 48/57] power: ab8500 : quick re-attach for ext charger
Message-ID: <20120928011930.GG5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-49-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-49-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:45AM -0600, mathieu.poirier@linaro.org wrote:
> From: Rupesh Kumar <rupesh.kumar@stericsson.com>
> 
> Quick re-attach charging behaviour is not required
> for external ac charger. Internal AC/USB Charger removal
> detection problem is due to a bug in AB8500 ASICs.
> 
> Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
> Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
> ---
>  drivers/power/abx500_chargalg.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
> index 180deab..ce58f20 100644
> --- a/drivers/power/abx500_chargalg.c
> +++ b/drivers/power/abx500_chargalg.c
> @@ -330,12 +330,13 @@ static int abx500_chargalg_check_charger_enable(struct abx500_chargalg *di)
>  		return di->usb_chg->ops.check_enable(di->usb_chg,
>  			di->bat->bat_type[di->bat->batt_id].normal_vol_lvl,
>  			di->bat->bat_type[di->bat->batt_id].normal_cur_lvl);
> -	} else if (di->chg_info.charger_type & AC_CHG) {
> +	} else if ((di->chg_info.charger_type & AC_CHG) &&
> +					!(di->ac_chg->external)) {
>  		return di->ac_chg->ops.check_enable(di->ac_chg,
>  			di->bat->bat_type[di->bat->batt_id].normal_vol_lvl,
>  			di->bat->bat_type[di->bat->batt_id].normal_cur_lvl);
>  	}
> -	return -ENXIO;
> +	return 0;

I'm not sure about this logic, but I guess it should be

	} else {
		return 0;
	}
	return -ENXIO;

>  }
>  
>  /**
> -- 
> 1.7.5.4
