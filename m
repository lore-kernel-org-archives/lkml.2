Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2DQUYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:24:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48975 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab2DQUYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:24:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/6] ACPI: D3cold state is always valid
Date: Tue, 17 Apr 2012 22:29:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.og>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>, Aaron Lu <aaron.lu@amd.com>
References: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com> <1334641676-14566-2-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1334641676-14566-2-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201204172229.18203.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 17, 2012, Lin Ming wrote:
> ACPI_STATE_D3 actually means ACPI D3hot which is not always valid.
> Instead, ACPI D3cold is always valid.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Can you just introduce ACPI_STATE_D3_HOT and redefine D3_COLD so that
it's the same as D3, as I said?

Rafael


> ---
>  drivers/acpi/scan.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 767e2dc..fb56388 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -884,13 +884,6 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>  				acpi_bus_add_power_resource(ps->resources.handles[j]);
>  		}
>  
> -		/* The exist of _PR3 indicates D3Cold support */
> -		if (i == ACPI_STATE_D3) {
> -			status = acpi_get_handle(device->handle, object_name, &handle);
> -			if (ACPI_SUCCESS(status))
> -				device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> -		}
> -
>  		/* Evaluate "_PSx" to see if we can do explicit sets */
>  		object_name[2] = 'S';
>  		status = acpi_get_handle(device->handle, object_name, &handle);
> @@ -908,8 +901,8 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>  	/* Set defaults for D0 and D3 states (always valid) */
>  	device->power.states[ACPI_STATE_D0].flags.valid = 1;
>  	device->power.states[ACPI_STATE_D0].power = 100;
> -	device->power.states[ACPI_STATE_D3].flags.valid = 1;
> -	device->power.states[ACPI_STATE_D3].power = 0;
> +	device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> +	device->power.states[ACPI_STATE_D3_COLD].power = 0;
>  
>  	acpi_bus_init_power(device);
>  
> 

