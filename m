Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2KREip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 23:38:45 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64874 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab2KREio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 23:38:44 -0500
Date: Sat, 17 Nov 2012 20:35:33 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org, Jenny TC <jenny.tc@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>
Subject: Re: [PATCH 2/2] power_supply: Register power supply for thermal
 cooling device
Message-ID: <20121118043533.GB18226@lizard.sbx05977.paloaca.wayport.net>
References: <1349801759-19647-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1349801759-19647-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:25:59PM +0530, Ramakrishna Pallala wrote:
> This patch registers the power supply as a cooling device if the
> power supply has support for charge throttling.
> 
> Now with this change low level drivers need not register with
> thermal framework as it is automatically done by power supply framework.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
>  drivers/power/power_supply_core.c |  100 +++++++++++++++++++++++++++++++++++++
>  include/linux/power_supply.h      |    1 +
>  2 files changed, 101 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index 08cc8a3..3338d49 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
[...]
> +static int ps_get_max_charge_cntl_limit(struct thermal_cooling_device *tcd,
> +						unsigned long *state)
> +{
> +	struct power_supply *psy;
> +	union power_supply_propval val;
> +	int ret;
> +
> +	WARN_ON(tcd == NULL);
> +	psy = tcd->devdata;
> +	ret = psy->get_property(psy,
> +		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX, &val);
> +	if (!ret)
> +		*state = val.intval;
> +
> +	return ret;
> +}
> +
> +static int ps_get_cur_chrage_cntl_limit(struct thermal_cooling_device *tcd,

Typo, "charge".

> +						unsigned long *state)
> +{
> +	struct power_supply *psy;
> +	union power_supply_propval val;
> +	int ret;
> +
> +	WARN_ON(tcd == NULL);

This is unneeded, we'll get oops anyway.

I fixed it up and applied, thank you!

Anton.
