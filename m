Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2ITSfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:35:31 -0400
Received: from londo.lunn.ch ([80.238.139.98]:38077 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab2ITSf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:35:29 -0400
Date: Thu, 20 Sep 2012 20:34:52 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lior Amsalem <alior@marvell.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
Message-ID: <20120920183452.GX28177@lunn.ch>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <50559737.8000705@gmail.com>
 <CACRpkdY-Nyn73EJLvE1RsL4hgMRm6hALtnS-eKAXU7edot2V9A@mail.gmail.com>
 <201209201530.40974.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209201530.40974.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 03:30:40PM +0000, Arnd Bergmann wrote:
> On Monday 17 September 2012, Linus Walleij wrote:
> > You found the weak spot between two consolidation tracks.
> > 
> > Getting rid of a broadcast autodetect functions from say
> > <mach/foo-id-probe.h> is nominally done by passing the data
> > to the driver as platform data instead, and only using
> > these functions in the mach-foo folder when populating
> > platform data, and thus it can be made into a local
> > header, say mach-foo/foo-id-probe.h
> > 
> > So the machine/arch code reads these registers to
> > populate the platform data and device drivers only
> > look at the platform data, which has some enum or
> > bool indicating what hardware it's running on, cool.
> > 
> > But according to the other consolidation track, platform
> > data should go into device tree bindings.
> > 
> > So the conclusion is that the DT must contain the data
> > about the platform, so it's not auto-probed by the kernel.
> > (I.e. the kernel reads no registers to figure out what hardware
> > this is, that stuff comes from the device tree.)
> > 
> > DT purists will say that the boot loader should ask the chipset
> > what it is with the same register writes and populate the
> > DT accordingly, instead of loading a precompiled blob.
> > Some may even ponder the crazy concept of amending the
> > DT in the kernel at early boot.
> > 
> > But in practice someone will give up, encode the stuff in
> > the static device tree and autoprobing of the platform
> > goes out the window.
> 
> In general, I would prefer probing hardware by asking the hardware itself
> rather than duplicating the information in the device tree. We do this
> whenever we can, e.g. on PCI or USB, but we cannot normally do the same
> on embedded buses like AHB, I2C or SPI, so we have to use the device
> tree to provide some or all of the information.
> 
> A corner case is the one where you have different versions of the same
> IP block (e.g. the pinctrl) and the kernel cannot find out which one it
> is by looking at registers inside it or on the parent bus, but only
> by looking at other hardware (CPU core revision, or PCI device ID of
> the root complex).

Hi Arnd

Even if we did look at the PCIe device IDs, we would still have one
odd-ball case to deal with. We have had an initial port to a Marvell
98DX4122 contributed. This chip is a Marvell Ethernet chip, with an
embedded Kirkwood SoC. The SoC is missing SATA, RTC, SDIO, I2S, TDM,
and TS which other kirkwoods have. So it will need a different pinctrl
table. However, looking at the PCIe device ID, it identifies itself as
a normal MV88F6281. So we would have to deal with this in DT with a
different compatibility string.

	  Andrew
