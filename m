Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2I1BAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:00:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51618 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2I1BAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:00:06 -0400
Date: Thu, 27 Sep 2012 17:57:13 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 40/57] power: ab8500: ADC for battery thermistor
Message-ID: <20120928005713.GB5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-41-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-41-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:37AM -0600, mathieu.poirier@linaro.org wrote:
> From: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> 
> When using ABx500_ADC_THERM_BATCTRL the battery ID resistor
> is combined with a NTC resistor to both identify the battery and
> to measure its temperature.
> 
> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
> Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
> Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
> Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
> ---
>  drivers/power/ab8500_btemp.c |    4 +++-
>  include/linux/mfd/abx500.h   |    2 ++
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
> index 506f124..56a3bb9 100644
> --- a/drivers/power/ab8500_btemp.c
> +++ b/drivers/power/ab8500_btemp.c
> @@ -557,7 +557,9 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
>  	/* BATTERY_UNKNOWN is defined on position 0, skip it! */
>  	for (i = BATTERY_UNKNOWN + 1; i < di->bat->n_btypes; i++) {
>  		if ((res <= di->bat->bat_type[i].resis_high) &&
> -			(res >= di->bat->bat_type[i].resis_low)) {
> +			(res >= di->bat->bat_type[i].resis_low) &&

I understand that you just change the already wrongly indentend code, so
just something to consider for the future: the driver needs lot's of
readability fixups, i.e. repeating di->bat, wrong indentation, too much
indentation (some things can be factored out to separate functions), etc.

> +			(di->bat->bat_type[i].adc_therm ==
> +							di->bat->adc_therm)) {
>  			dev_dbg(di->dev, "Battery detected on %s"
>  				" low %d < res %d < high: %d"
>  				" index: %d\n",
> diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
> index 97e918f..cb2b82a 100644
> --- a/include/linux/mfd/abx500.h
> +++ b/include/linux/mfd/abx500.h
> @@ -270,6 +270,7 @@ struct abx500_maxim_parameters {
>   * @low_high_cur_lvl:		charger current in temp low/high state in mA
>   * @low_high_vol_lvl:		charger voltage in temp low/high state in mV'
>   * @battery_resistance:		battery inner resistance in mOhm.
> + * @adc_therm:			battery uses controller or resistor for temp.
>   * @n_r_t_tbl_elements:		number of elements in r_to_t_tbl
>   * @r_to_t_tbl:			table containing resistance to temp points
>   * @n_v_cap_tbl_elements:	number of elements in v_to_cap_tbl
> @@ -297,6 +298,7 @@ struct abx500_battery_type {
>  	int low_high_cur_lvl;
>  	int low_high_vol_lvl;
>  	int battery_resistance;
> +	enum abx500_adc_therm adc_therm;
>  	int n_temp_tbl_elements;
>  	struct abx500_res_to_temp *r_to_t_tbl;
>  	int n_v_cap_tbl_elements;
> -- 
> 1.7.5.4
