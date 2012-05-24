Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab2EXU4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:56:22 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:29893 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2EXU4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:56:21 -0400
Message-ID: <1337892811.16730.419.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4 6/6] ACPI: Set hotplug _OST support bit to _OSC
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        liuj97@gmail.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 14:53:31 -0600
In-Reply-To: <1337884020.2718.89.camel@lorien2>
References: <1337826324-16802-1-git-send-email-toshi.kani@hp.com>
	 <1337826324-16802-7-git-send-email-toshi.kani@hp.com>
	 <1337884020.2718.89.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 12:27 -0600, Shuah Khan wrote:
> On Wed, 2012-05-23 at 20:25 -0600, Toshi Kani wrote:
> > When ACPI_HOTPLUG_OST is defined, set hotplug _OST support bit
> > OSC_SB_HOTPLUG_OST_SUPPORT to indicate that the OS supports hotplug
> > _OST by calling the platform-wide ACPI Operating System Capabilities
> > (_OSC).
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >  drivers/acpi/bus.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> > index 3188da3..3d4fc7a 100644
> > --- a/drivers/acpi/bus.c
> > +++ b/drivers/acpi/bus.c
> > @@ -548,6 +548,10 @@ static void acpi_bus_osc_support(void)
> >  	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PPC_OST_SUPPORT;
> >  #endif
> >  
> > +#ifdef ACPI_HOTPLUG_OST
> > +	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_HOTPLUG_OST_SUPPORT;
> > +#endif
> 
> Why isn't firmware response to _OSC checked to make sure firmware also
> supports _OST? My general comments about compile time switch that is
> enabled only a few cases _OST Ejection/Insertion is intended to be used
> are applicable here.

This is because when FW does not support _OST, it does not implement
_OST method.  acpi_evaluate_hotplug_opt() simply returns with
AE_NOT_FOUND when _OST method does not exist.


Thanks for all good questions and thorough review!  Please let me know
if I did not address any of your comments properly.

Thanks,
-Toshi



> 
> -- Shuah
> 
> 
> 
> 
> > +
> >  	if (!ghes_disable)
> >  		capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_APEI_SUPPORT;
> >  	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
> 
> 


