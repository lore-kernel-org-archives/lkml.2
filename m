Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2LPP4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 10:56:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:5083 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab2LPP4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 10:56:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,294,1355126400"; 
   d="scan'208";a="258036096"
Date: Sun, 16 Dec 2012 17:59:53 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] ACPI / PM: Do not apply ACPI_SUCCESS() to
 acpi_bus_get_device() result
Message-ID: <20121216155953.GN2261@intel.com>
References: <1432424.eSUdEQ1VBT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1432424.eSUdEQ1VBT@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 02:32:06PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since the return value of acpi_bus_get_device() is not of type
> acpi_status, ACPI_SUCCESS() should not be used for checking its
> return value.  Fix that.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

> ---
>  drivers/acpi/device_pm.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux/drivers/acpi/device_pm.c
> ===================================================================
> --- linux.orig/drivers/acpi/device_pm.c
> +++ linux/drivers/acpi/device_pm.c
> @@ -358,8 +358,7 @@ static struct acpi_device *acpi_dev_pm_g
>  	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
>  	struct acpi_device *adev;
>  
> -	return handle && ACPI_SUCCESS(acpi_bus_get_device(handle, &adev)) ?
> -		adev : NULL;
> +	return handle && !acpi_bus_get_device(handle, &adev) ? adev : NULL;
>  }
>  
>  /**
