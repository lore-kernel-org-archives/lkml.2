Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab2IQV6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:58:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34582 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab2IQV6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:58:10 -0400
Date: Mon, 17 Sep 2012 22:57:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Jon Hunter <jon-hunter@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Benoit Cousson <b-cousson@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] dmaengine: add dmanegine slave map api's
Message-ID: <20120917215753.GS12245@n2100.arm.linux.org.uk>
References: <1347615189-27052-1-git-send-email-vinod.koul@linux.intel.com> <20120914094155.GC12245@n2100.arm.linux.org.uk> <1347619868.1943.113.camel@vkoul-udesk3> <20120914111842.GD12245@n2100.arm.linux.org.uk> <1347853223.1943.136.camel@vkoul-udesk3> <20120917083654.GO12245@n2100.arm.linux.org.uk> <1347875429.1943.141.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347875429.1943.141.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 03:20:29PM +0530, Vinod Koul wrote:
> On Mon, 2012-09-17 at 09:36 +0100, Russell King - ARM Linux wrote:
> > > > I'm not saying take the slave_id out of the map.  I'm saying, let the
> > > > DMA engine driver itself figure out what dma_chan to return. 
> > > But wont that assume the dma controller knows which channel to allocate.
> > > And how would it know this information? This can be problematic for hard
> > > wired muxes, but can be easily done for controller which have
> > > programmable mux.
> > 
> > Well, as I have already said, at the moment you're returning the _first_
> > _free_ _channel_ on a DMA device, which almost certainly will always be
> > the wrong one. 
> Yes I overlooked, the continue is wrong. It needs to move to next
> available channel. I have fixed it.
> 
> Now on the question if we should allow dmaengine to select channel or
> let dma engine driver do that, I don't see how that helps for hard wired
> muxes where dma engine driver doesn't know anything of mapping.
> 
> For your OMAP dma this wont matter as I think you have a programmable
> mux so you maybe able to use any channel with rightly programmed mux,
> right?

Except that we expose one 'channel' per mux setting, so as far as DMA
engine goes, the mux number _is_ the channel number - which is the same
approach taken by the PL08x and sa11x0 DMA engine drivers.  It is the
only sane approach to dealing with N hardware channels vs >>N clients.
