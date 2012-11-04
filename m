Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2KDKry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 05:47:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:49090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2KDKrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 05:47:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,710,1344236400"; 
   d="scan'208";a="236952757"
Date: Sun, 4 Nov 2012 12:50:07 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121104105007.GS16648@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-4-git-send-email-mika.westerberg@linux.intel.com>
 <20121103225246.66d4f094@endymion.delvare>
 <20121104072316.GR16648@intel.com>
 <20121104095031.5e6465ae@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121104095031.5e6465ae@endymion.delvare>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2012 at 09:50:31AM +0100, Jean Delvare wrote:
> On Sun, 4 Nov 2012 09:23:17 +0200, Mika Westerberg wrote:
> > On Sat, Nov 03, 2012 at 10:52:46PM +0100, Jean Delvare wrote:
> > > On Sat,  3 Nov 2012 09:46:33 +0200, Mika Westerberg wrote:
> > > > --- /dev/null
> > > > +++ b/drivers/acpi/acpi_i2c.c
> > > > @@ -0,0 +1,234 @@
> > > > +/*
> > > > + * ACPI I2C enumeration support
> > > > + *
> > > > + * Copyright (C) 2012, Intel Corporation
> > > > + * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or modify
> > > > + * it under the terms of the GNU General Public License version 2 as
> > > > + * published by the Free Software Foundation.
> > > > + */
> > > > +
> > > > +#include <linux/acpi.h>
> > > > +#include <linux/i2c.h>
> > > > +#include <linux/module.h>
> > > 
> > > You also need <linux/device.h> for dev_err() etc., and <linux/err.h> for
> > > ENODEV etc.
> > 
> > I think <acpi.h> already includes <device.h> but I'll double check. At
> > least this compiles without those headers in place :)
> 
> That's not really the point. You never know which header inclusions
> will be removed from other header files in the future, so you should
> include what you need explicitly. This avoids future build breakages as
> well as build breakages on other architectures.

Right. I've actually seen this problem few times before. I added the
inclusion of <devide.h> and <err.h> to the file.

Thanks.
