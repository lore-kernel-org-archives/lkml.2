Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2KTMyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:54:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:38776 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab2KTMyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:54:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,285,1352102400"; 
   d="scan'208";a="244805062"
Date: Tue, 20 Nov 2012 14:57:22 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [Update 2][PATCH 2/3] ACPI / driver core: Introduce struct
 acpi_dev_node and related macros
Message-ID: <20121120125722.GT17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <6570191.KCDMiILtRE@vostro.rjw.lan>
 <20121120091007.GN17774@intel.com>
 <2800515.q4oG7o9rEp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2800515.q4oG7o9rEp@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:34:04AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 20, 2012 11:10:07 AM Mika Westerberg wrote:
> > On Tue, Nov 20, 2012 at 01:59:23AM +0100, Rafael J. Wysocki wrote:
> > > Index: linux/include/linux/device.h
> > > ===================================================================
> > > --- linux.orig/include/linux/device.h
> > > +++ linux/include/linux/device.h
> > > @@ -578,6 +578,12 @@ struct device_dma_parameters {
> > >  	unsigned long segment_boundary_mask;
> > >  };
> > >  
> > > +struct acpi_dev_node {
> > > +#ifdef CONFIG_ACPI
> > > +	void	*handle;
> > > +#endif
> > > +};
> > > +
> > >  /**
> > >   * struct device - The basic device structure
> > >   * @parent:	The device's "parent" device, the device to which it is attached.
> > > @@ -683,7 +689,7 @@ struct device {
> > >  	struct dev_archdata	archdata;
> > >  
> > >  	struct device_node	*of_node; /* associated device tree node */
> > > -	void			*acpi_handle; /* associated ACPI device node */
> > > +	struct acpi_dev_node	acpi_node; /* associated ACPI device node */
> > 
> > Please update the kerneldoc comment as well.
> 
> Right, thanks for the reminder. :-)
> 
> Updated patch is appended.
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / driver core: Introduce struct acpi_dev_node and related macros
> 
> To avoid adding an ACPI handle pointer to struct device on
> architectures that don't use ACPI, or generally when CONFIG_ACPI is
> not set, in which cases that pointer is useless, define struct
> acpi_dev_node that will contain the handle pointer if CONFIG_ACPI is
> set and will be empty otherwise and use it to represent the ACPI
> device node field in struct device.
> 
> In addition to that define macros for reading and setting the ACPI
> handle of a device that don't generate code when CONFIG_ACPI is
> unset.  Modify the ACPI subsystem to use those macros instead of
> referring to the given device's ACPI handle directly.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
