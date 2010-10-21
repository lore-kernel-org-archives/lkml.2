Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0JUXAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:00:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab0JUXAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:00:13 -0400
Date: Thu, 21 Oct 2010 15:59:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Cyril Chemparathy <cyril@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Subject: Re: [PATCH v3 00/12] tnetv107x ssp driver stack
Message-Id: <20101021155902.b9702f72.akpm@linux-foundation.org>
In-Reply-To: <87mxq7p4hv.fsf@deeprootsystems.com>
References: <1287694873-12904-1-git-send-email-cyril@ti.com>
	<87mxq7p4hv.fsf@deeprootsystems.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 15:26:04 -0700
Kevin Hilman <khilman@deeprootsystems.com> wrote:

> Cyril Chemparathy <cyril@ti.com> writes:
> 
> > TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
> > device.  It has a built-in programmable execution engine that can be programmed
> > to operate as almost any serial bus (I2C, SPI, EasyScale, and others).
> 
> Andrew, looking for some advice here...
> 
> This is a piece of davinci hardware, but introduces drivers in various
> subsystems.  I'm willing to merge this series via the davinci tree after
> getting acks from the various subsystem maintainers.  Is this an OK
> approach?  It seems best to me to merge this all together.

Yes, that's the best approach.

Some of the desired acks may not be forthcoming.  In which case the
best you can do is to review the code yourself, make the maintainer(s)
aware of what's going on and just go ahead and merge it.  If people are
too busy to look at the code then so be it - we can't really permit
that problem to permanently block new drivers.

> We already have acks for the regulator and gpio driver parts, and the
> backlight driver has a clear owner in MAINTAINERS.  However, who should
> be doing the final review/ack of the drivers/misc and drivers/gpio
> changes is less clear to me.  
> 

I'll go and have a look at drivers/misc/ti_ssp.c.

> 
> Thanks,
> 
> Kevin
> 
> >  arch/arm/mach-davinci/board-tnetv107x-evm.c    |  199 +++++++
> >  arch/arm/mach-davinci/devices-tnetv107x.c      |   25 +
> >  arch/arm/mach-davinci/include/mach/ti_ssp.h    |   98 ++++
> >  arch/arm/mach-davinci/include/mach/tnetv107x.h |    2 +
> >  arch/arm/mach-davinci/tnetv107x.c              |    2 +-
> >  drivers/gpio/Kconfig                           |   10 +
> >  drivers/gpio/Makefile                          |    1 +
> >  drivers/gpio/ti-ssp-gpio.c                     |  200 +++++++
> >  drivers/misc/Kconfig                           |   11 +
> >  drivers/misc/Makefile                          |    1 +
> >  drivers/misc/ti_ssp.c                          |  436 +++++++++++++++
> >  drivers/regulator/Kconfig                      |   10 +
> >  drivers/regulator/Makefile                     |    1 +
> >  drivers/regulator/tps6524x-regulator.c         |  692 ++++++++++++++++++++++++
> >  drivers/spi/Kconfig                            |    7 +
> >  drivers/spi/Makefile                           |    1 +
> >  drivers/spi/spi_ti_ssp.c                       |  397 ++++++++++++++
> >  drivers/video/backlight/Kconfig                |    7 +
> >  drivers/video/backlight/Makefile               |    2 +-
> >  drivers/video/backlight/tps6116x.c             |  340 ++++++++++++
