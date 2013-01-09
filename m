Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3AIQDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:03:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:43999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab3AIQDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:03:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,438,1355126400"; 
   d="scan'208";a="270068694"
Date: Wed, 9 Jan 2013 07:38:48 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [resend][PATCH 01/16] dw_dmac: call .probe after we have a
 device in place
Message-ID: <20130109153848.GT19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1357719435-29955-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130109134757.GN19691@intel.com>
 <CAHp75VfFyX=Pz3xRt15n6ffP=v0pa413BFF2zHGoiQowG1kKVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfFyX=Pz3xRt15n6ffP=v0pa413BFF2zHGoiQowG1kKVg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 04:56:45PM +0200, Andy Shevchenko wrote:
> On Wed, Jan 9, 2013 at 3:47 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Wed, Jan 09, 2013 at 10:17:00AM +0200, Andy Shevchenko wrote:
> >> If we don't yet have the platform device for the driver when it is being loaded
> >> we fail to probe the driver. So instead of calling probe() directly we call
> >> platform_driver_register(). It will call the probe() immediately if we have the
> >> device but also makes the driver to work on platforms where the platform device
> >> is created later.
> > Why wont you have the platform device?
> 
> It's still the same device as before. The only difference is in
> boot/initialization sequence.
> 
> > Is this only due to your approach of
> > creating the device in PCI probe?
> 
> No. We had an issue when driver was initialized (and with old version
> immediately probed)
> just before it happened in the platform devices. In such case .probe() fails.
> Above patch makes sure that platform devices are already in the
> internal structures and we could match them safely.
hmmm, but that its still not clear why that would happen. Driver init is called
later when all device creation should already be done.

> >>  }
> >>  subsys_initcall(dw_init);
Viresh, Linus

We had this discussion sometime back. pl022 use dma and we need DMA before SPI.
So if we have pl022 as late_init and dma as device_init. If we have one  more
dependency then moving dw_dmac to fs_init should help too. But arch/subsys seems
overkill here?

--
~Vinod


why is dw_dmac a subsys init. One reason could be ensure these are before before
the client devices, but 
