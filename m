Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab3AGU5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:57:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34336 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab3AGU5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:57:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH] ACPI / scan: Treat power resources in a special way
Date: Mon, 07 Jan 2013 22:02:59 +0100
Message-ID: <1458998.lg5S0BfPCV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357579019.2153.2.camel@misato.fc.hp.com>
References: <1565436.cOJ1sW4X70@vostro.rjw.lan> <1357579019.2153.2.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 07, 2013 10:16:59 AM Toshi Kani wrote:
> On Mon, 2012-12-31 at 00:46 +0000, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Commit 1d57433 (ACPI: Separate adding ACPI device objects from
> > probing ACPI drivers) introduced an ACPI power resources management
> 
> I am seeing a different commit id for this.
> 
> commit 805d410fb0dbd65e1a57a810858fa2491e75822d
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Fri Dec 21 00:36:39 2012 +0100
> 
>     ACPI: Separate adding ACPI device objects from probing ACPI drivers
> 

My bad, sorry.

I rebased the branch without modifying the changelog of this patch.  It should
be fixed now, but please note that the acpi-scan branch has changed.

> > regression, because it didn't ensure that the power resources
> > driver bind to the struct acpi_device objects corresponding
> > to power resources as soon as they were created.  As a result,
> > ACPI power management routines may attempt to access power resource
> > objects before they are ready to use.
> > 
> > To fix this problem, tell the acpi_add_single_object() in
> > acpi_bus_check_add() to probe the driver for objects of type
> > ACPI_BUS_TYPE_POWER.  This fix has been verified to work on
> > HP nx6325 where the problem was first observed.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The change looks good.
> 
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks a lot,
Rafael


> > ---
> > 
> > The commit mentioned in the changelog is in linux-next only for now, but
> > it's likely to go upstream in this form anyway and the fix on top of the
> > whole ACPI scan series is trivial.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  drivers/acpi/scan.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux/drivers/acpi/scan.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/scan.c
> > +++ linux/drivers/acpi/scan.c
> > @@ -1606,7 +1606,8 @@ static acpi_status acpi_bus_check_add(ac
> >  		return AE_CTRL_DEPTH;
> >  	}
> >  
> > -	acpi_add_single_object(&device, handle, type, sta, false);
> > +	acpi_add_single_object(&device, handle, type, sta,
> > +			       type == ACPI_BUS_TYPE_POWER);
> >  	if (!device)
> >  		return AE_CTRL_DEPTH;
> >  
> > 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
