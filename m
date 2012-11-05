Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2KEMAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:00:02 -0500
Received: from mga03.intel.com ([143.182.124.21]:49936 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2KEMAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:00:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,714,1344236400"; 
   d="scan'208";a="213554457"
Date: Mon, 5 Nov 2012 14:02:19 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105120219.GF24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121103201310.GQ16648@intel.com>
 <1535917.BaYBBNgGy0@vostro.rjw.lan>
 <4052192.ry8JrGTr6H@vostro.rjw.lan>
 <20121105105602.GC24532@intel.com>
 <20121105105639.GE1385@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105105639.GE1385@opensource.wolfsonmicro.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 11:56:39AM +0100, Mark Brown wrote:
> On Mon, Nov 05, 2012 at 12:56:02PM +0200, Mika Westerberg wrote:
> 
> > > struct acpi_device {
> > > 	...
> > > 	union acpi_resource_serial_bus *serial;
> > > 	...
> > > };
> 
> > It is also possible to have several serial bus connectors on a single
> > device (although we've seen only one connector per device but it should not
> > be limited to that).
> 
> I've got practical systems where there are multiple buses physically
> connected, though in practice almost always only one is actually used at
> runtime when it's I2C and SPI there are some systems (usually with other
> buses) where you might want to use more than one bus.  Not sure those
> buses will fit in here though.

Yeah, I just went through DSDT table of one of our machines and found a
device that actually has two I2CSerialBus connectors (and those are to the
same controller). What I'm not sure is that is it used to select between
two different addresses or doest the device really have two physical I2C
connections.
