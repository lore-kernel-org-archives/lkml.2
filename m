Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2JBGQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:16:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:32692 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab2JBGQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:16:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,521,1344236400"; 
   d="scan'208";a="229398787"
Date: Tue, 2 Oct 2012 09:19:08 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC PATCH 0/6] ACPI: ACPI 5.0 device enumeration proposal
Message-ID: <20121002061908.GP15548@intel.com>
References: <1348817863.10877.320.camel@rui.sh.intel.com>
 <20121001064433.GF15548@intel.com>
 <744357E9AAD1214791ACBA4B0B90926322D989@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926322D989@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:30:00PM +0000, Zhang, Rui wrote:
> 
> 
> > -----Original Message-----
> > From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> > Sent: Monday, October 01, 2012 2:45 PM
> > To: Zhang, Rui
> > Cc: LKML; linux-pm; linux-i2c; linux-acpi@vger.kernel.org; Len, Brown;
> > Rafael J. Wysocki; Grant Likely; Dirk Brandewie
> > Subject: Re: [RFC PATCH 0/6] ACPI: ACPI 5.0 device enumeration proposal
> > Importance: High
> > 
> > On Fri, Sep 28, 2012 at 03:37:43PM +0800, Zhang Rui wrote:
> > >
> > > the main idea is that, for Serial Buses like I2C and SPI, we
> > enumerate
> > > the controller as a platform device, and then enumerate the slaves
> > via
> > > i2c/spi_register_board_info. And then, when the controller is really
> > > probed and enabled in the platform driver, the SPI/I2C bus code will
> > > enumerate I2C/SPI slaves automatically.
> > > And for the other devices, we will enumerate all of them as platform
> > > devices, which is not covered in this patch set yet.
> > 
> > Can you show some example how we could use this new code for example
> > with an existing I2C/SPI slave driver?
> 
> This is just prototype patch set that I want to illustrate my idea
> on ACPI device enumeration, to get more thoughts on this.
> So no example driver so far.

But surely you have thought how this should be done? Otherwise we only see
a part of the solution here. What if this enumeration you introduce here
doesn't play well when I2C/SPI are added?

> 
> > Let's say the device uses few
> > GPIOs, one for interrupt and other for triggering firmware download. In
> > addition to that it needs a special parameters that can be extracted
> > running the "_DSM" method of the device.
> > 
> > Normally the driver would get this stuff from the platform data or from
> > Device Tree but how it is done with these patches?
> 
> Can you show me an example driver that gets the special parameters from Device Tree?

drivers/misc/eeprom/at25.c but there are much more if you search for DT
enabled drivers.

Now, I don't know what is the proper way to pass parameters in ACPI but
"_DSM" seems to be one that is being used.
