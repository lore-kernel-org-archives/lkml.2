Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab2ITJsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:48:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:48562 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab2ITJsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:48:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,453,1344236400"; 
   d="scan'208";a="195234032"
Message-ID: <1348134509.13371.44.camel@smile>
Subject: Re: [PATCH 0/7] dw_dmac: introduce autoconfiguration
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Date: Thu, 20 Sep 2012 12:48:29 +0300
In-Reply-To: <50581084.2050007@yahoo.es>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <50581084.2050007@yahoo.es>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 14:11 +0800, Hein Tibosch wrote: 
> On 9/17/2012 3:39 PM, Andy Shevchenko wrote:
> > Here is a patchset that allows to adapt the driver to the hardware
> > configuration during probe time. The hardware should have the specific optional
> > parameters enabled. Otherwise the driver will consider values stored in the
> > platform data.
> >
> > Additionally it brings support of the software LLP transfers. It means that
> > normal linked list transfer is substituted by set of single block transfers
> > transparently to the user.
> >
> > Comments are welcome.
> >
> > Andy Shevchenko (7):
> >   dw_dmac: mark dwc_dump_chan_regs as inline
> >   dw_dmac: fill optional encoded parameters in register structure
> >   dw_dmac: get number of channels from hardware if possible
> >   dw_dmac: autoconfigure block_size or use platform data
> >   dw_dmac: autoconfigure data_width or get it via platform data
> >   dw_dmac: check if controller supports LLP
> >   dw_dmac: introduce software emulation of LLP transfers
> >
> >  arch/arm/mach-spear13xx/spear13xx.c |    3 +
> >  arch/avr32/mach-at32ap/at32ap700x.c |    3 +
> >  drivers/dma/dw_dmac.c               |  207 +++++++++++++++++++++++++++++------
> >  drivers/dma/dw_dmac_regs.h          |   48 ++++++++
> >  include/linux/dw_dmac.h             |    7 ++
> >  5 files changed, 235 insertions(+), 33 deletions(-)
> Andy,
> 
> The (embedded) dw dma on the AP7000 indeed does not support auto
> configuration (the register reads as zero)
Nice to have the test report. I have no devices around without auto
configuration block.

> and so it needs the platform data.
> 
> I tested the driver on AVR32 with the atmel-mci driver and it all
> worked well.

> I also tested the new software emulation of LLP mode by setting
> nollp for each channel to true. That also worked as expected.

Thanks!

> Tested-by: Hein Tibosch <hein_tibosch@yahoo.es>

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
