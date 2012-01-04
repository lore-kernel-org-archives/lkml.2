Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2ADEv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 23:51:56 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55623 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab2ADEvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 23:51:55 -0500
Date: Wed, 4 Jan 2012 08:51:50 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH] power_supply: add "unknown" in power supply type
Message-ID: <20120104045150.GA1039@oksana.dev.rtsoft.ru>
References: <B567DBAB974C0544994013492B949F8E38125B223C@EXMAIL03.scwf.nsc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B567DBAB974C0544994013492B949F8E38125B223C@EXMAIL03.scwf.nsc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 11:08:33PM -0800, Kim, Milo wrote:
> Hi, Anton
> 
> For the default value of power supply type, "unknown" is added.
> With default prop value, supply type property can be displayed as default - "Unknown".

Applied, thanks!

> And union propval is set to zero.
> Then no data abort exception even if the propval is not updated by xxx_get_property().

Why it is not updated in the first place (assuming get_property() returned
success)?.. Driver should be fixed then... I dropped this change.

In any case, if we want this change, it should be a separate patch.

Thanks!

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/power/power_supply_sysfs.c |    4 +++-
>  include/linux/power_supply.h       |    3 ++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 58cc490..6250686 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -42,7 +42,7 @@ static ssize_t power_supply_show_property(struct device *dev,
>  					  struct device_attribute *attr,
>  					  char *buf) {
>  	static char *type_text[] = {
> -		"Battery", "UPS", "Mains", "USB",
> +		"Unknown", "Battery", "UPS", "Mains", "USB",
>  		"USB_DCP", "USB_CDP", "USB_ACA"
>  	};
>  	static char *status_text[] = {
> @@ -67,6 +67,8 @@ static ssize_t power_supply_show_property(struct device *dev,
>  	const ptrdiff_t off = attr - power_supply_attrs;
>  	union power_supply_propval value;
>  
> +	memset(&value, 0, sizeof(value));
> +
>  	if (off == POWER_SUPPLY_PROP_TYPE)
>  		value.intval = psy->type;
>  	else
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 204c18d..9c83e04 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -123,7 +123,8 @@ enum power_supply_property {
>  };
>  
>  enum power_supply_type {
> -	POWER_SUPPLY_TYPE_BATTERY = 0,
> +	POWER_SUPPLY_TYPE_UNKNOWN = 0,
> +	POWER_SUPPLY_TYPE_BATTERY,
>  	POWER_SUPPLY_TYPE_UPS,
>  	POWER_SUPPLY_TYPE_MAINS,
>  	POWER_SUPPLY_TYPE_USB,		/* Standard Downstream Port */
> -- 
> 1.7.4.1
> 
> 
> Best Regards
> 
> Milo (Woogyom) Kim
> Texas Instruments Incorporated

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
