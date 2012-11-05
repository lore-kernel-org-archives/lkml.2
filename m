Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab2KEMzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:55:15 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:55760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab2KEMzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:55:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Delvare <khali@linux-fr.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Mon, 05 Nov 2012 13:59:23 +0100
Message-ID: <1983976.4JKTfcThF7@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121105132350.59c6e4d9@endymion.delvare>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <20121105120219.GF24532@intel.com> <20121105132350.59c6e4d9@endymion.delvare>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 05, 2012 01:23:50 PM Jean Delvare wrote:
> On Mon, 5 Nov 2012 14:02:19 +0200, Mika Westerberg wrote:
> > On Mon, Nov 05, 2012 at 11:56:39AM +0100, Mark Brown wrote:
> > > I've got practical systems where there are multiple buses physically
> > > connected, though in practice almost always only one is actually used at
> > > runtime when it's I2C and SPI there are some systems (usually with other
> > > buses) where you might want to use more than one bus.  Not sure those
> > > buses will fit in here though.
> > 
> > Yeah, I just went through DSDT table of one of our machines and found a
> > device that actually has two I2CSerialBus connectors (and those are to the
> > same controller). What I'm not sure is that is it used to select between
> > two different addresses or doest the device really have two physical I2C
> > connections.
> 
> Neither would make sense from a hardware perspective.

Well, interesting. :-)

I wonder what we're supposed to do with things like that?
It looks like our patch [3/3] will use the last one found, but is that
correct?  Should it use the first one instead, perhaps?

That little conundrum aside, the observations above seem to indicate
that we'd need a list of "serial" resources per struct acpi_device too.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
