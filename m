Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2KSAxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 19:53:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55933 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2KSAxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 19:53:31 -0500
Date: Sun, 18 Nov 2012 16:50:21 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com
Subject: Re: [PATCH 2/7] power_supply: Add charger control properties
Message-ID: <20121119005021.GM29066@lizard.sbx05977.paloaca.wayport.net>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
 <1350578646-3315-3-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350578646-3315-3-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 10:14:01PM +0530, Jenny TC wrote:
> The battery charger needs to have control path along
> with the reporting charger properties. In existing solutions
> this is implemented using regulator framework. A regulator
> framework doesn't fit a charger driver requirement because of the
> following reason
> Charger needs support two paths - charger path (charger to platform)
> and charging (charger to battery).Disabling the charging path alone
> (eg over battery temperature) will allow the platform to work with
> power from charger without discharging the battery. And the charger
> may need to be disabled completely based on the charger temperature
> or the platform temperature.
> Charger has more than one pair of voltage/current to control (CC,CV,INLMT)
> These features will not directly fit in the regulator framework
> 
> Since the charger driver sits in the power supply subsystem it make sense
> to add the properties to control the charger.
> 
> Also this patch adds/modify the power supply properties to meet the
> requirements for charger control
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
>  drivers/power/power_supply_sysfs.c |   16 ++++++++++++----
>  include/linux/power_supply.h       |   24 ++++++++++++++++--------
>  2 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 40fa3b7..3166d00 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -160,12 +160,13 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(charge_now),
>  	POWER_SUPPLY_ATTR(charge_avg),
>  	POWER_SUPPLY_ATTR(charge_counter),
> -	POWER_SUPPLY_ATTR(constant_charge_current),
> -	POWER_SUPPLY_ATTR(constant_charge_current_max),
> -	POWER_SUPPLY_ATTR(constant_charge_voltage),
> -	POWER_SUPPLY_ATTR(constant_charge_voltage_max),

Sorry, but you can't just remove properites like this. They're already
used by a lot of drivers.

Thanks,
Anton.
