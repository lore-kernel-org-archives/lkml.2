Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3AGR0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:26:42 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:37030 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3AGR0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:26:40 -0500
Message-ID: <1357579019.2153.2.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI / scan: Treat power resources in a special way
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Date: Mon, 07 Jan 2013 10:16:59 -0700
In-Reply-To: <1565436.cOJ1sW4X70@vostro.rjw.lan>
References: <1565436.cOJ1sW4X70@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-31 at 00:46 +0000, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Commit 1d57433 (ACPI: Separate adding ACPI device objects from
> probing ACPI drivers) introduced an ACPI power resources management

I am seeing a different commit id for this.

commit 805d410fb0dbd65e1a57a810858fa2491e75822d
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Fri Dec 21 00:36:39 2012 +0100

    ACPI: Separate adding ACPI device objects from probing ACPI drivers

> regression, because it didn't ensure that the power resources
> driver bind to the struct acpi_device objects corresponding
> to power resources as soon as they were created.  As a result,
> ACPI power management routines may attempt to access power resource
> objects before they are ready to use.
> 
> To fix this problem, tell the acpi_add_single_object() in
> acpi_bus_check_add() to probe the driver for objects of type
> ACPI_BUS_TYPE_POWER.  This fix has been verified to work on
> HP nx6325 where the problem was first observed.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The change looks good.

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

> ---
> 
> The commit mentioned in the changelog is in linux-next only for now, but
> it's likely to go upstream in this form anyway and the fix on top of the
> whole ACPI scan series is trivial.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/acpi/scan.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/acpi/scan.c
> ===================================================================
> --- linux.orig/drivers/acpi/scan.c
> +++ linux/drivers/acpi/scan.c
> @@ -1606,7 +1606,8 @@ static acpi_status acpi_bus_check_add(ac
>  		return AE_CTRL_DEPTH;
>  	}
>  
> -	acpi_add_single_object(&device, handle, type, sta, false);
> +	acpi_add_single_object(&device, handle, type, sta,
> +			       type == ACPI_BUS_TYPE_POWER);
>  	if (!device)
>  		return AE_CTRL_DEPTH;
>  
> 


