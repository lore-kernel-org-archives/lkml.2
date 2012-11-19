Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab2KSA4G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 19:56:06 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55149 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2KSA4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 19:56:04 -0500
Date: Sun, 18 Nov 2012 16:52:49 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com
Subject: Re: [PATCH 3/7] power_supply : add supported charger cable  feature
Message-ID: <20121119005249.GN29066@lizard.sbx05977.paloaca.wayport.net>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
 <1350578646-3315-4-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350578646-3315-4-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 10:14:02PM +0530, Jenny TC wrote:
> A charger can support different types of charger sources (cables).
> It make sense to define a field to inform the power supply subsystem
> what kind of cable  a charger driver supports. Since a bitmask would
> be the easy way to do define, it's good to have a enum which has
> the bitmask definition for each cable types
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
>  include/linux/power_supply.h |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 7c06956..eea1709 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -163,6 +163,21 @@ enum power_supply_type {
>  	POWER_SUPPLY_TYPE_USB_ACA,	/* Accessory Charger Adapters */
>  };
>  
> +enum power_supply_charger_cable_type {
> +	POWER_SUPPLY_CHARGER_TYPE_NONE = 0,
> +	POWER_SUPPLY_CHARGER_TYPE_USB_SDP = 1 << 0,
> +	POWER_SUPPLY_CHARGER_TYPE_USB_DCP = 1 << 1,
> +	POWER_SUPPLY_CHARGER_TYPE_USB_CDP = 1 << 2,
> +	POWER_SUPPLY_CHARGER_TYPE_USB_ACA = 1 << 3,
> +	POWER_SUPPLY_CHARGER_TYPE_AC = 1 << 4,
> +};
> +
> +#define POWER_SUPPLY_CHARGER_TYPE_USB \
> +	(POWER_SUPPLY_CHARGER_TYPE_USB_SDP | \
> +	POWER_SUPPLY_CHARGER_TYPE_USB_DCP | \
> +	POWER_SUPPLY_CHARGER_TYPE_USB_CDP | \
> +	POWER_SUPPLY_CHARGER_TYPE_USB_ACA)
> +
>  union power_supply_propval {
>  	int intval;
>  	const char *strval;
> @@ -175,6 +190,7 @@ struct power_supply {
>  	size_t num_properties;
>  
>  	char **supplied_to;
> +	unsigned long supported_cables;

Enums have an integer resolution. Why do we need long type here?..

Thanks.

>  	size_t num_supplicants;
>  
>  	int (*get_property)(struct power_supply *psy,
> -- 
> 1.7.9.5
