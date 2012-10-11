Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2JKFhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:37:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:43600 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab2JKFhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:37:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,570,1344236400"; 
   d="scan'208";a="154921627"
Date: Thu, 11 Oct 2012 08:39:47 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCH 1/4] dmaengine: dw_dmac: use helper macro
 module_platform_driver()
Message-ID: <20121011053947.GE7771@intel.com>
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1349178121-9105-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <1349859841.10584.122.camel@smile>
 <CAOh2x=mNiL4k=v3YGexq7YMZUx131QWBpm11QXupnWLUPuKU4Q@mail.gmail.com>
 <CAHp75VePqj3FViNrOcicHXhv9BzhJQgSg6KvA31HmdEFf7BXOg@mail.gmail.com>
 <20121010124002.GF3197@arwen.pp.htv.fi>
 <CAHp75VdprTQBsmEJudGExceFRRjXiN_xFGaMtU+mcw+vzM1oVg@mail.gmail.com>
 <20121010134159.GA4114@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010134159.GA4114@arwen.pp.htv.fi>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 04:42:00PM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Oct 10, 2012 at 03:52:40PM +0300, Andy Shevchenko wrote:
> > On Wed, Oct 10, 2012 at 3:40 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > On Wed, Oct 10, 2012 at 12:21:04PM +0300, Andy Shevchenko wrote:
> > >> On Wed, Oct 10, 2012 at 12:08 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
> > >> > On Wed, Oct 10, 2012 at 2:34 PM, Andy Shevchenko
> > >> > <andriy.shevchenko@linux.intel.com> wrote:
> > >> >> On Tue, 2012-10-02 at 14:41 +0300, Andy Shevchenko wrote:
> > >> >>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > >> >>>
> > >> >>> Since v3.2 we have nice macro to define the platform driver's init and exit
> > >> >>> calls. This patch simplifies the dw_dmac driver by using that macro.
> > >> >>
> > >> >> Actually we can't do this. It will break initialization of some other
> > >> >> drivers.
> > >> >
> > >> > why?
> > >>
> > >> We have spi, i2c and hsuart devices connected to the DMA controller.
> > >> In case we would like to use DMA we have to have the dw_dmac loaded
> > >> before them. Currently we have spi driver on subsys_initcall level,
> > >> and Mika, who is developing it, will change to module_init_call level.
> > >> However, it will just hide the potential issue. He also tried to use
> > >> deferred module loading, but we don't know if it's good solution or
> > >> not, and that solution requires something to stop deferring at some
> > >> moment.
> > >>
> > >> Might be we missed something and there is a better solution.
> > >
> > > if they can only work with DMA, they should return -EPROBE_DEFER so
> > > their probe() function can be called after DMA driver has finished
> > > probing.
> > 
> > They could work either with DMA or via PIO mode.
> > How does the driver know when to stop to return -EPROBE_DEFER?
> 
> Why would you even allow to work as PIO-only ? Who would even want to
> use the driver as PIO only ?

Think about SPI or I2C, if we don't have DMA available we are still able to
use the driver (and the bus) instead of just failing.

> In any case, you can add a Kconfig choice like WHATEVER_PIO_ONLY and
> only return -EPROBE_DEFER ifndef WHATEVER_PIO_ONLY.

Why would we add more Kconfig options for things that can be checked
runtime? Distro makers need to select that option anyway so it doesn't gain
anything, except confuses users.
