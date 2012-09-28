Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2I1CXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:23:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47269 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab2I1CXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:23:50 -0400
Date: Thu, 27 Sep 2012 19:21:07 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 50/57] power: ab8500-chargalg: update battery health on
 safety timer exp
Message-ID: <20120928022107.GI5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-51-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-51-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:47AM -0600, mathieu.poirier@linaro.org wrote:
> From: Hakan Berg <hakan.berg@stericsson.com>
> 
> When the charging safety timer is elapsed the battery health is shown as "Good".
> This is misleading and also hard to distingiush problems reported on "phone
> discharges although charger is attached".
> 
> When safety timer elapses that is an indication of a fault in the battery of
> some kind. Hence report as POWER_SUPPLY_HEALTH_UNSPEC_FAILURE.
> 
> Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Arun MURTHY <arun.murthy@stericsson.com>
> Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
> ---
>  drivers/power/abx500_chargalg.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
> index 4db0ef0..1df238f 100644
> --- a/drivers/power/abx500_chargalg.c
> +++ b/drivers/power/abx500_chargalg.c
> @@ -1711,6 +1711,10 @@ static int abx500_chargalg_get_property(struct power_supply *psy,
>  				val->intval = POWER_SUPPLY_HEALTH_COLD;
>  			else
>  				val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
> +		} else if (di->charge_state == STATE_SAFETY_TIMER_EXPIRED ||
> +			di->charge_state ==
> +			STATE_SAFETY_TIMER_EXPIRED_INIT) {

Wrong indentation, no need to wrap lines. (You could align to
di->change_state, and thus it'll look prettier and there still wouldn't
need for line wrapping.)

> +			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
>  		} else {
>  			val->intval = POWER_SUPPLY_HEALTH_GOOD;
>  		}
> -- 
> 1.7.5.4
