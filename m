Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3AFDCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 22:02:53 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47096 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3AFDCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 22:02:49 -0500
Date: Sat, 5 Jan 2013 18:59:16 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: NeilBrown <neilb@suse.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Saranya Gopal <saranya.gopal@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bq27x00_battery: fix bugs introduced with BQ27425 support
Message-ID: <20130106025916.GE6919@lizard.sbx05280.losalca.wayport.net>
References: <20121202203421.1ad1f6dc@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121202203421.1ad1f6dc@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2012 at 08:34:21PM +1100, NeilBrown wrote:
> commit a66f59ba2e994bf70274ef0513e24e0e7ae20c63
>     bq27x00_battery: Add support for BQ27425 chip
> 
> introduced 2 bug.
> 
> 1/ 'chip' was set to BQ27425 unconditionally - breaking support for
>    other devices.
> 2/ BQ27425 does not support cycle count, how the code still tries to
>    get the cycle count for BQ27425, and now does it twice for other chips.
> 
> Cc: Saranya Gopal <saranya.gopal@intel.com>
> Signed-off-by: NeilBrown <neilb@suse.de>

Applied, thanks!

> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index e2659f1..51d4017 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -445,7 +445,6 @@ static void bq27x00_update(struct bq27x00_device_info *di)
>  		cache.temperature = bq27x00_battery_read_temperature(di);
>  		if (!is_bq27425)
>  			cache.cycle_count = bq27x00_battery_read_cyct(di);
> -		cache.cycle_count = bq27x00_battery_read_cyct(di);
>  		cache.power_avg =
>  			bq27x00_battery_read_pwr_avg(di, BQ27x00_POWER_AVG);
>  
> @@ -697,7 +696,6 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
>  	int ret;
>  
>  	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
> -	di->chip = BQ27425;
>  	if (di->chip == BQ27425) {
>  		di->bat.properties = bq27425_battery_props;
>  		di->bat.num_properties = ARRAY_SIZE(bq27425_battery_props);
