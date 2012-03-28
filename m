Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2C1H6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:58:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:32867 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab2C1H6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:58:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="82486830"
Subject: Re: [PATCH v3 1/7] libata-acpi: set acpi state for SATA port
From: Lin Ming <ming.m.lin@intel.com>
To: Aaron Lu <aaron.lu@amd.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <20120328195509.GA1965@localhost.amd.com>
References: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
	 <1332915722-15963-2-git-send-email-ming.m.lin@intel.com>
	 <20120328195509.GA1965@localhost.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Mar 2012 15:57:59 +0800
Message-ID: <1332921479.3793.115.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 03:55 +0800, Aaron Lu wrote:
> Hi,
> 
> The patch does not apply, are you using libata-devel/ALL branch?

This patch set depends on below patches,

[PATCHv2 0/7] acpi/libata: Express dependencies for devices on dock
stations and bays

which were in github.com libata-dev tree.

But I didn't find these patches in git.kernel.org libata-dev tree.
http://marc.info/?l=linux-scsi&m=133283600431697&w=2

Lin Ming

> 
> -Aaron
> 
> On Wed, Mar 28, 2012 at 02:21:56PM +0800, Lin Ming wrote:
> > Currently, ata_acpi_set_state() only sets acpi sate for IDE port.
> > Remove this limitation.
> > 
> > Acked-by: Aaron Lu <aaron.lu@amd.com>
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  drivers/ata/libata-acpi.c |   21 ++++++++++++---------
> >  1 files changed, 12 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> > index b03e468..104c1d0 100644
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
> > @@ -841,23 +841,26 @@ void ata_acpi_on_resume(struct ata_port *ap)
> >  void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
> >  {
> >  	struct ata_device *dev;
> > -
> > -	if (!ata_ap_acpi_handle(ap) || (ap->flags & ATA_FLAG_ACPI_SATA))
> > -		return;
> > +	acpi_handle handle;
> > +	int acpi_state;
> >  
> >  	/* channel first and then drives for power on and vica versa
> >  	   for power off */
> > -	if (state.event == PM_EVENT_ON)
> > -		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D0);
> > +	handle = ata_ap_acpi_handle(ap);
> > +	if (handle && state.event == PM_EVENT_ON)
> > +		acpi_bus_set_power(handle, ACPI_STATE_D0);
> >  
> >  	ata_for_each_dev(dev, &ap->link, ENABLED) {
> > -		if (ata_dev_acpi_handle(dev))
> > -			acpi_bus_set_power(ata_dev_acpi_handle(dev),
> > +		handle = ata_dev_acpi_handle(dev);
> > +		if (handle)
> > +			acpi_bus_set_power(handle,
> >  				state.event == PM_EVENT_ON ?
> >  					ACPI_STATE_D0 : ACPI_STATE_D3);
> >  	}
> > -	if (state.event != PM_EVENT_ON)
> > -		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D3);
> > +
> > +	handle = ata_ap_acpi_handle(ap);
> > +	if (handle && state.event != PM_EVENT_ON)
> > +		acpi_bus_set_power(handle, ACPI_STATE_D3);
> >  }
> >  
> >  /**
> > -- 
> > 1.7.2.5
> > 
> > 
> 


