Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2KENND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:13:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:51987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab2KENNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:13:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,714,1344236400"; 
   d="scan'208";a="242668985"
Date: Mon, 5 Nov 2012 15:15:19 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jean Delvare <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105131519.GG24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121105120219.GF24532@intel.com>
 <20121105132350.59c6e4d9@endymion.delvare>
 <1983976.4JKTfcThF7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1983976.4JKTfcThF7@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 01:59:23PM +0100, Rafael J. Wysocki wrote:
> On Monday, November 05, 2012 01:23:50 PM Jean Delvare wrote:
> > On Mon, 5 Nov 2012 14:02:19 +0200, Mika Westerberg wrote:
> > > On Mon, Nov 05, 2012 at 11:56:39AM +0100, Mark Brown wrote:
> > > > I've got practical systems where there are multiple buses physically
> > > > connected, though in practice almost always only one is actually used at
> > > > runtime when it's I2C and SPI there are some systems (usually with other
> > > > buses) where you might want to use more than one bus.  Not sure those
> > > > buses will fit in here though.
> > > 
> > > Yeah, I just went through DSDT table of one of our machines and found a
> > > device that actually has two I2CSerialBus connectors (and those are to the
> > > same controller). What I'm not sure is that is it used to select between
> > > two different addresses or doest the device really have two physical I2C
> > > connections.
> > 
> > Neither would make sense from a hardware perspective.
> 
> Well, interesting. :-)

It looks like some PMICs for example have two I2C control interfaces, like
TI's TWL6030 if I'm not mistaken. If both are put behind the same I2C
controller with different address, you have the situation like above.
