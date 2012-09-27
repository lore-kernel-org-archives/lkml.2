Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2I0HaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:30:17 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:60050 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2I0HaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:30:15 -0400
Date: Thu, 27 Sep 2012 00:27:31 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 31/57] power: ab8500_fg: fix to use correct battery
 charge full design
Message-ID: <20120927072731.GM8836@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-32-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-32-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:28AM -0600, mathieu.poirier@linaro.org wrote:
> From: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
> 
> If battery is not identified while fg probe, mah_max_design gets
> initialized with unknown battery's charge full design. Reinitialize
> mah_max_design if battery is identified after fg probe.
> 
> Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> Reviewed-by: Vijaya Kumar K-1 <vijay.kilari@stericsson.com>
> Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
> Reviewed-by: Olivier CLERGEAUD <olivier.clergeaud@stericsson.com>
> Reviewed-by: Arun MURTHY <arun.murthy@stericsson.com>
> Reviewed-by: Rupesh KUMAR <rupesh.kumar@stericsson.com>
> Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
> ---
>  drivers/power/ab8500_fg.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index 0e71e7e..5e4a46b 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -2258,9 +2258,9 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
>  		case POWER_SUPPLY_PROP_TECHNOLOGY:
>  			switch (ext->type) {
>  			case POWER_SUPPLY_TYPE_BATTERY:
> -				if (!di->flags.batt_id_received) {
> +				if (!di->flags.batt_id_received &&
> +					di->bat->batt_id != BATTERY_UNKNOWN) {

Wrong indentation...

Yes, it will no longer fit into 80 columns, which probably means that the
code gone out of control, and need some refactorings before adding new
stuff.

>  					const struct abx500_battery_type *b;
> -
>  					b = &(di->bat->bat_type[di->bat->batt_id]);
>  
>  					di->flags.batt_id_received = true;
> -- 
> 1.7.5.4
