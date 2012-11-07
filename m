Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2KGLKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:10:22 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:60262 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab2KGLKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:10:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Wed, 07 Nov 2012 12:14:31 +0100
Message-ID: <1493573.krE1QVlUux@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121107095842.GY24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <2584820.Vd5p0uzRAK@vostro.rjw.lan> <20121107095842.GY24532@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 07, 2012 11:58:42 AM Mika Westerberg wrote:
> On Tue, Nov 06, 2012 at 11:36:08PM +0100, Rafael J. Wysocki wrote:
> > > 
> > > OK, but then we need to pass the information obtained from _CRS
> > > (presumably after some adjustments through _SRS) to drivers, or rather to
> > > things like the SPI core, I2C core etc. so that they can create device
> > > objects for drivers to bind to and quite frankly I don't see why not to use
> > > ACPI resources for that.
> > 
> > Nevertheless, the routines for parsing those resources should belong
> > to the ACPI core, mostly to avoid code duplication.
> 
> Rafael,
> 
> So is the idea now that the ACPI core parses the resources and passes them
> forward via struct acpi_device? I'm just wondering how to proceed with
> these I2C and SPI enumeration patches.

Well, we definitely don't want to duplicate what drivers/pnp/pnpacpi/rsparser.c
does, so the idea is to move the code from there to the core in such a way that
both the SPI/I2C patches and the PNP layer can use it.

I'll have some prototype code ready shortly, hopefully, and I'll post it
in that form for comments (and so that you know what to expect).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
