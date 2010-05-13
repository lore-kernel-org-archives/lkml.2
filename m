Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab0EMAcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 20:32:51 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:13445 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757384Ab0EMAct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 20:32:49 -0400
Message-ID: <4BEB48AC.9070609@bluewatersys.com>
Date: Thu, 13 May 2010 12:32:44 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Peter Huewe <PeterHuewe@gmx.de>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>,
       Wolfram Sang <w.sang@pengutronix.de>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: Rename get_current to fix build failure / name
 conflict
References: <201005130154.58459.PeterHuewe@gmx.de>
In-Reply-To: <201005130154.58459.PeterHuewe@gmx.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch changes the name of get_current function pointer to
> get_battery_current to resolve a name conflict with the get_current
> macro defined in current.h.
> 
> This conflict resulted in a build-failure[1] for the sh4 arch
> allyesconfig which is resolved by this patch.

Ah, didn't think of that. Thanks.
Acked-by: Ryan Mallon <ryan@bluewatersys.com>

> To be consistent the other function pointers (_voltage,_capacity) were
> renamed too.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> KernelVersion: linux-next 20100512
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2572665/
> 
>  drivers/power/ds2782_battery.c |   29 ++++++++++++++---------------
>  1 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> index d762a0c..9b3b4b7 100644
> --- a/drivers/power/ds2782_battery.c
> +++ b/drivers/power/ds2782_battery.c
> @@ -43,10 +43,9 @@
>  struct ds278x_info;
>  
>  struct ds278x_battery_ops {
> -	int	(*get_current)(struct ds278x_info *info, int *current_uA);
> -	int	(*get_voltage)(struct ds278x_info *info, int *voltage_uA);
> -	int	(*get_capacity)(struct ds278x_info *info, int *capacity_uA);
> -
> +	int (*get_battery_current)(struct ds278x_info *info, int *current_uA);
> +	int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uA);
> +	int (*get_battery_capacity)(struct ds278x_info *info, int *capacity_uA);
>  };
>  
>  #define to_ds278x_info(x) container_of(x, struct ds278x_info, battery)
> @@ -213,11 +212,11 @@ static int ds278x_get_status(struct ds278x_info *info, int *status)
>  	int current_uA;
>  	int capacity;
>  
> -	err = info->ops->get_current(info, &current_uA);
> +	err = info->ops->get_battery_current(info, &current_uA);
>  	if (err)
>  		return err;
>  
> -	err = info->ops->get_capacity(info, &capacity);
> +	err = info->ops->get_battery_capacity(info, &capacity);
>  	if (err)
>  		return err;
>  
> @@ -246,15 +245,15 @@ static int ds278x_battery_get_property(struct power_supply *psy,
>  		break;
>  
>  	case POWER_SUPPLY_PROP_CAPACITY:
> -		ret = info->ops->get_capacity(info, &val->intval);
> +		ret = info->ops->get_battery_capacity(info, &val->intval);
>  		break;
>  
>  	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> -		ret = info->ops->get_voltage(info, &val->intval);
> +		ret = info->ops->get_battery_voltage(info, &val->intval);
>  		break;
>  
>  	case POWER_SUPPLY_PROP_CURRENT_NOW:
> -		ret = info->ops->get_current(info, &val->intval);
> +		ret = info->ops->get_battery_current(info, &val->intval);
>  		break;
>  
>  	case POWER_SUPPLY_PROP_TEMP:
> @@ -307,14 +306,14 @@ enum ds278x_num_id {
>  
>  static struct ds278x_battery_ops ds278x_ops[] = {
>  	[DS2782] = {
> -		.get_current  = ds2782_get_current,
> -		.get_voltage  = ds2782_get_voltage,
> -		.get_capacity = ds2782_get_capacity,
> +		.get_battery_current  = ds2782_get_current,
> +		.get_battery_voltage  = ds2782_get_voltage,
> +		.get_battery_capacity = ds2782_get_capacity,
>  	},
>  	[DS2786] = {
> -		.get_current  = ds2786_get_current,
> -		.get_voltage  = ds2786_get_voltage,
> -		.get_capacity = ds2786_get_capacity,
> +		.get_battery_current  = ds2786_get_current,
> +		.get_battery_voltage  = ds2786_get_voltage,
> +		.get_battery_capacity = ds2786_get_capacity,
>  	}
>  };
>  


-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
