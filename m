Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab2KENlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:41:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:59272 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab2KENlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:41:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,715,1344236400"; 
   d="scan'208";a="242677462"
Date: Mon, 5 Nov 2012 15:43:38 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jean Delvare <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105134338.GH24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121105120219.GF24532@intel.com>
 <20121105132350.59c6e4d9@endymion.delvare>
 <1983976.4JKTfcThF7@vostro.rjw.lan>
 <20121105131519.GG24532@intel.com>
 <CACRpkdaZqka7g2ECAyD_bKhnoULhCP6cTJwMyEsTuVxiUiHy+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaZqka7g2ECAyD_bKhnoULhCP6cTJwMyEsTuVxiUiHy+A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 02:20:52PM +0100, Linus Walleij wrote:
> >
> > It looks like some PMICs for example have two I2C control interfaces, like
> > TI's TWL6030 if I'm not mistaken. If both are put behind the same I2C
> > controller with different address, you have the situation like above.
> 
> This is quite common. So for example the AB8500 (drivers/mfd/ab8500-core.c)
> has this. The reason is usually that the device has more than 256 registers
> to the address space simply is not big enough.
> 
> What we do is refer to the subaddresses as "banks" and they happen
> to always be at the next consecutive address so n+1.
> 
> So the same device appear behind several addresses just to support
> a lot of registers.
> 
> So you're not actually modelling the devices on the other end but the
> multiple addresses of a single device.

That makes sense. Thanks for the explanation.

> If the addresses are consecutive like ours it makes sense
> to just instantiate one device and have the driver know that it will
> also be able to access address +1, +2 ... +n. So is it possible
> to group the consecutive related addresses after each other
> here at the acpi-spi level and just create a single device?

Not sure if it should be done there, unless we really can be sure that we
have a single device with multiple addresses (and that is usually something
that is only known by the actual driver) and not some device that has two
unrelated interfaces connecting the same controller.

> If the addresses are not consecutive I guess you need to have
> one device driver bind to several devices and return -EPROBE_DEFER
> until the driver has been probed for all of them or something like
> that, this is what multi-block GPIO drivers sometimes do.

The addresses in the DSDT table for this particular device are not
consecutive so we could do something like you propose above.
