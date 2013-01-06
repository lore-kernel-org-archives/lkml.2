Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3AFXzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 18:55:22 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42785 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751320Ab3AFXzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 18:55:20 -0500
Message-ID: <1357516522.4940.8.camel@joe-AO722>
Subject: Re: [PATCH 2/5 RESEND] thermal: exynos: Miscellaneous fixes to
 support falling threshold interrupt
From: Joe Perches <joe@perches.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@lists.linux-foundation.org, linux-pm@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2013 15:55:22 -0800
In-Reply-To: <1357516248-31350-1-git-send-email-amit.daniel@samsung.com>
References: <1353937640-9939-3-git-send-email-amit.kachhap@linaro.org>
	 <1357516248-31350-1-git-send-email-amit.daniel@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-06 at 15:50 -0800, Amit Daniel Kachhap wrote:
> Below fixes are done to support falling threshold interrupt,
> * Falling interrupt status macro corrected according to exynos5 data sheet.
> * The get trend function modified to calculate trip temperature correctly.
> * The clearing of interrupt status in the isr is now done after handling
>   the event that caused the interrupt.
[]
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
[]
> @@ -373,12 +373,19 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
>  static int exynos_get_trend(struct thermal_zone_device *thermal,
>  			int trip, enum thermal_trend *trend)
>  {
> -	if (thermal->temperature >= trip)
> +	int ret = 0;

Unnecessary initialization

> +	unsigned long trip_temp;
> +
> +	ret = exynos_get_trip_temp(thermal, trip, &trip_temp);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (thermal->temperature >= trip_temp)
>  		*trend = THERMAL_TREND_RAISING;
>  	else
>  		*trend = THERMAL_TREND_DROPPING;

THERMAL_TREND_STABLE ?

>  
> -	return 0;
> +	return ret;

return 0 is clearer.

