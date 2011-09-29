Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1I2Uoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:44:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:3155 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab1I2Uon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,463,1312182000"; 
   d="scan'208";a="72280553"
Date: Thu, 29 Sep 2011 13:44:40 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: PME via interrupt or SCI mechanism?
Message-ID: <20110929204440.GA6043@xanatos>
References: <20110912171003.GA7939@xanatos>
 <201109290021.28407.rjw@sisk.pl>
 <20110929182327.GA4979@xanatos>
 <201109292139.56626.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109292139.56626.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 09:39:56PM +0200, Rafael J. Wysocki wrote:
> On Thursday, September 29, 2011, Sarah Sharp wrote:
> > On Thu, Sep 29, 2011 at 12:21:28AM +0200, Rafael J. Wysocki wrote:
> Please try the appended patch and check if you see the "Notification error
> for GPE" message (please keep your previous debug patches applied).

Do I need to have the ACPI debug_level or debug_layer set to anything in
particular to see this message?  I don't see this message in dmesg with
debug_level and debug_layer set to 0x0.

Sarah Sharp

> ---
>  drivers/acpi/acpica/evgpe.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/acpi/acpica/evgpe.c
> ===================================================================
> --- linux.orig/drivers/acpi/acpica/evgpe.c
> +++ linux/drivers/acpi/acpica/evgpe.c
> @@ -523,10 +523,14 @@ static void ACPI_SYSTEM_XFACE acpi_ev_as
>  				ACPI_NOTIFY_DEVICE_WAKE);
>  
>  		notify_object = local_gpe_event_info->dispatch.device.next;
> -		while (ACPI_SUCCESS(status) && notify_object) {
> +		while (notify_object) {
>  			status = acpi_ev_queue_notify_request(
>  					notify_object->node,
>  					ACPI_NOTIFY_DEVICE_WAKE);
> +			if (ACPI_FAILURE(status))
> +				ACPI_ERROR((AE_INFO,
> +					"Notification error for GPE 0x%X",
> +					local_gpe_event_info->gpe_number));
>  			notify_object = notify_object->next;
>  		}
>  
