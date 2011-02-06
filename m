Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1BFQkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:40:40 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:37196 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1BFQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:40:39 -0500
Date: Sun, 6 Feb 2011 17:40:34 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20110206164034.GV3554@enneenne.com>
Mail-Followup-To: Lars-Peter Clausen <lars@metafoo.de>,
	Anton Vorontsov <cbouatmailru@gmail.com>,
	Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
 <1296953291-10373-5-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296953291-10373-5-git-send-email-lars@metafoo.de>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 04/14] POWER: bq27x00: Return -ENODEV for properties if
 the battery is not present
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 01:48:01AM +0100, Lars-Peter Clausen wrote:
> This patch changes get_property callback of the bq27x00 battery to return
> -ENODEV for properties other then the PROP_PRESENT if the battery is not
> present.
> The power subsystem core expects a driver to behave that way.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/power/bq27x00_battery.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 1b06134..9f16666 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -252,16 +252,21 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
>  {
>  	int ret = 0;
>  	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
> +	int voltage = bq27x00_battery_voltage(di);
> +
> +	if (psp != POWER_SUPPLY_PROP_PRESENT && voltage <= 0)
> +		return -ENODEV;
>  
>  	switch (psp) {
>  	case POWER_SUPPLY_PROP_STATUS:
>  		ret = bq27x00_battery_status(di, val);
>  		break;
>  	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +		val->intval = voltage;
> +		break;
>  	case POWER_SUPPLY_PROP_PRESENT:
> -		val->intval = bq27x00_battery_voltage(di);
>  		if (psp == POWER_SUPPLY_PROP_PRESENT)
> -			val->intval = val->intval <= 0 ? 0 : 1;
> +			val->intval = voltage <= 0 ? 0 : 1;
>  		break;
>  	case POWER_SUPPLY_PROP_CURRENT_NOW:
>  		val->intval = bq27x00_battery_current(di);
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
