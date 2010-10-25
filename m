Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab0JYNRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:17:55 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53405 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753436Ab0JYNRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:17:53 -0400
Date: Mon, 25 Oct 2010 15:17:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in
 get_property()
Message-ID: <20101025131728.GC2162@ucw.cz>
References: <20101016141321.GA11054@sucs.org>
 <20101017131016.GB13015@khazad-dum.debian.net>
 <20101017145025.GA32599@sucs.org>
 <201010172032.43206.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010172032.43206.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> That's why I suggested to use -ENODATA. :-)
> 
> Still, if user space has problems with failing reads from the sysfs attributes,
> it may be better to simply put -1 in there.  Patch is appended, please test.

I'd say that reporting -1 for unknown is ugly. You can have -1A
current easily (charging at 1A), and I've seen machines reporting <0
current -- when charging. Logical and well-defined.

								Pavel


>  	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
> -		val->intval = battery->design_voltage * 1000;
> +		if (battery->design_voltage != ACPI_BATTERY_VALUE_UNKNOWN)
> +			val->intval = battery->design_voltage * 1000;
>  		break;
>  	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> -		val->intval = battery->voltage_now * 1000;
> +		if (battery->voltage_now != ACPI_BATTERY_VALUE_UNKNOWN)
> +			val->intval = battery->voltage_now * 1000;
>  		break;
>  	case POWER_SUPPLY_PROP_CURRENT_NOW:
>  	case POWER_SUPPLY_PROP_POWER_NOW:
> -		val->intval = battery->rate_now * 1000;
> +		if (battery->rate_now != ACPI_BATTERY_VALUE_UNKNOWN)
> +			val->intval = battery->rate_now * 1000;
>  		break;
>  	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
>  	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
> -		val->intval = battery->design_capacity * 1000;
> +		if (battery->design_capacity != ACPI_BATTERY_VALUE_UNKNOWN)
> +			val->intval = battery->design_capacity * 1000;
>  		break;
>  	case POWER_SUPPLY_PROP_CHARGE_FULL:
>  	case POWER_SUPPLY_PROP_ENERGY_FULL:
> -		val->intval = battery->full_charge_capacity * 1000;
> +		if (battery->full_charge_capacity != ACPI_BATTERY_VALUE_UNKNOWN)
> +			val->intval = battery->full_charge_capacity * 1000;
>  		break;
>  	case POWER_SUPPLY_PROP_CHARGE_NOW:
>  	case POWER_SUPPLY_PROP_ENERGY_NOW:
> -		val->intval = battery->capacity_now * 1000;
> +		if (battery->capacity_now != ACPI_BATTERY_VALUE_UNKNOWN)
> +			val->intval = battery->capacity_now * 1000;
>  		break;
>  	case POWER_SUPPLY_PROP_MODEL_NAME:
>  		val->strval = battery->model_number;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
