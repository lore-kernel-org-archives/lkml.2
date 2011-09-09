Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab1IIU5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:57:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34074 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1IIU5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:57:17 -0400
Date: Fri, 9 Sep 2011 21:56:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, linaro-dev@lists.linaro.org,
        linux-omap@vger.kernel.org, Mans Rullgard <mans.rullgard@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ASoC: omap: convert per-board modules to platform
	drivers
Message-ID: <20110909205645.GA16355@n2100.arm.linux.org.uk>
References: <3110288.bQbb0H2ME1@wuerfel> <1315520956.4126.3.camel@finisterre.wolfsonmicro.main> <20110908223720.GA21469@n2100.arm.linux.org.uk> <20110908224731.GB5201@opensource.wolfsonmicro.com> <20110908230102.GB21469@n2100.arm.linux.org.uk> <20110908235903.GA6370@opensource.wolfsonmicro.com> <20110909094156.GE6918@n2100.arm.linux.org.uk> <20110909161151.GA3515@opensource.wolfsonmicro.com> <20110909190134.GA14520@n2100.arm.linux.org.uk> <20110909193010.GA2993@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909193010.GA2993@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 12:30:11PM -0700, Mark Brown wrote:
> On Fri, Sep 09, 2011 at 08:01:35PM +0100, Russell King - ARM Linux wrote:
> 
> > Well, with DT, there won't be any 'board type' anymore.  There won't be
> > any 'machine_is_xxx()' to sort it out anymore.  Using DT, all that will
> > be history - it's all got to be sorted out by either devices or device
> > properties.
> 
> There is a board type - there's a root compatible property for the board
> which fulfils this purpose - so the situation with and without device
> tree is essentially the same.

So instead of a table of machine id numbers and soc device strings, you're
going to have a table of board 'compatible' strings and soc device strings,
and you're going to have to manually create the struct device with that
name.

That's just twisted and utterly insane - adding more code for precisely
zero benefit what so ever.  Think about it - the device tree is *already*
creating platform devices for entries in the device tree file.  What's
the point of having this special ASoC code look up the platform compatible
property in a table of strings to find a different string to manually
create a device with.  Why not just _add_ the bloody device to the DT
file in the first place?  That's partly what DT is there for - to create
platform specific struct devices.
