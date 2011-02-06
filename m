Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1BFQi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:38:28 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:37182 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1BFQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:38:27 -0500
Date: Sun, 6 Feb 2011 17:38:19 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20110206163818.GU3554@enneenne.com>
Mail-Followup-To: Lars-Peter Clausen <lars@metafoo.de>,
	Anton Vorontsov <cbouatmailru@gmail.com>,
	Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
 <1296953291-10373-12-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296953291-10373-12-git-send-email-lars@metafoo.de>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 11/14] POWER: bq27x00: Give more specific reports on
 battery status
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 01:48:08AM +0100, Lars-Peter Clausen wrote:
> The current code only reports whether the battery is charging or discharging.
> But the battery also reports whether it is fully charged, furthermore by look at
> if the battery is supplied we can tell whether it is discharging or not
> charging.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/power/bq27x00_battery.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 7540364..961238f 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -54,6 +54,7 @@
>  #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
>  #define BQ27000_REG_ILMD		0x76 /* Initial last measured discharge */
>  #define BQ27000_FLAG_CHGS		BIT(7)
> +#define BQ27000_FLAG_FC			BIT(5)
>  
>  #define BQ27500_REG_SOC			0x2c
>  #define BQ27500_REG_DCAP		0x3C /* Design capacity */
> @@ -395,8 +396,12 @@ static int bq27x00_battery_status(struct bq27x00_device_info *di,
>  		else
>  			status = POWER_SUPPLY_STATUS_CHARGING;
>  	} else {
> -		if (di->cache.flags & BQ27000_FLAG_CHGS)
> +		if (di->cache.flags & BQ27000_FLAG_FC)
> +			status = POWER_SUPPLY_STATUS_FULL;
> +		else if (di->cache.flags & BQ27000_FLAG_CHGS)
>  			status = POWER_SUPPLY_STATUS_CHARGING;
> +		else if (power_supply_am_i_supplied(&di->bat))
> +			status = POWER_SUPPLY_STATUS_NOT_CHARGING;
>  		else
>  			status = POWER_SUPPLY_STATUS_DISCHARGING;
>  	}
> -- 
> 1.7.2.3
> 

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
