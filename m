Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab2EVK1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:27:33 -0400
Received: from smtp-out-056.synserver.de ([212.40.185.56]:1051 "EHLO
	smtp-out-051.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751871Ab2EVK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:27:32 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25475
Message-ID: <4FBB6AC7.8040303@metafoo.de>
Date: Tue, 22 May 2012 12:30:31 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Pritesh Raithatha <praithatha@nvidia.com>
CC: cbouatmailru@gmail.com, axel.lin@gmail.com, cabarnes@indesign-llc.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-charger: use cansleep version of gpio_set_value
References: <1337676604-22836-1-git-send-email-praithatha@nvidia.com>
In-Reply-To: <1337676604-22836-1-git-send-email-praithatha@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 10:50 AM, Pritesh Raithatha wrote:
> Context of gpio_charger_get_property is sleepable so we should
> use gpio_set_value_cansleep instead of gpio_set_value.
> 
> It will remove WARN_ON incase of using gpio from i2c-to-gpio
> expander like pca953x.
> 
> Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>

Looks good,

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>  drivers/power/gpio-charger.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index 8672c91..cb2aa31 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -54,7 +54,7 @@ static int gpio_charger_get_property(struct power_supply *psy,
>  
>  	switch (psp) {
>  	case POWER_SUPPLY_PROP_ONLINE:
> -		val->intval = gpio_get_value(pdata->gpio);
> +		val->intval = gpio_get_value_cansleep(pdata->gpio);
>  		val->intval ^= pdata->gpio_active_low;
>  		break;
>  	default:

