Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3AFC4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 21:56:19 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:43399 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab3AFC4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 21:56:18 -0500
Date: Sat, 5 Jan 2013 18:52:47 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: add watchdog and safety timer expiries
 under PROP_HEALTH_*
Message-ID: <20130106025246.GD6919@lizard.sbx05280.losalca.wayport.net>
References: <1354264066-3523-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354264066-3523-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 01:57:46PM +0530, Ramakrishna Pallala wrote:
> As most of the charger chips come with two kinds of safety features
> related to timing.
> 1. Watchdog Timer (interms of seconds/mins)
> 2. Safety Timer (interms of hours)
> 
> This patch adds these to fault causes in POWER_SUPPLY_PROP_HEALTH_*
> enums so that whenever there is either watchdog timeout or safety timer
> timeout driver could notify the user space accurately about the fault
> and will also be helpful for debug.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>

Applied, thanks a lot!

> ---
>  drivers/power/power_supply_sysfs.c |    3 ++-
>  include/linux/power_supply.h       |    2 ++
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 40fa3b7..29178f7 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -55,7 +55,8 @@ static ssize_t power_supply_show_property(struct device *dev,
>  	};
>  	static char *health_text[] = {
>  		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
> -		"Unspecified failure", "Cold",
> +		"Unspecified failure", "Cold", "Watchdog timer expire",
> +		"Safety timer expire"
>  	};
>  	static char *technology_text[] = {
>  		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 35cdf2c..4e672e1 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -54,6 +54,8 @@ enum {
>  	POWER_SUPPLY_HEALTH_OVERVOLTAGE,
>  	POWER_SUPPLY_HEALTH_UNSPEC_FAILURE,
>  	POWER_SUPPLY_HEALTH_COLD,
> +	POWER_SUPPLY_HEALTH_WATCHDOG_TIMER_EXPIRE,
> +	POWER_SUPPLY_HEALTH_SAFETY_TIMER_EXPIRE,
>  };
>  
>  enum {
> -- 
> 1.7.0.4
