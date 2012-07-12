Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab2GLEAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 00:00:45 -0400
Received: from linux-sh.org ([111.68.239.195]:57315 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab2GLEAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 00:00:42 -0400
Date: Thu, 12 Jul 2012 13:00:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] dma: sh: provide a migration path for slave drivers
 to stop using .private
Message-ID: <20120712040018.GB11440@linux-sh.org>
References: <1341418663-24432-1-git-send-email-g.liakhovetski@gmx.de>
 <1341418663-24432-4-git-send-email-g.liakhovetski@gmx.de>
 <CANqRtoRz2NF6BEEYcy_BwZ7Hm5EF9zP2Z0eoQcbxaSfUuc2i9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoRz2NF6BEEYcy_BwZ7Hm5EF9zP2Z0eoQcbxaSfUuc2i9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 06:55:32AM +0900, Magnus Damm wrote:
> Hi Guennadi,
> 
> [CC Paul]
> 
> On Thu, Jul 5, 2012 at 1:17 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > This patch extends the sh dmaengine driver to support the preferred channel
> > selection and configuration method, instead of using the "private" field
> > from struct dma_chan. We add a standard filter function to be used by
> > slave drivers instead of implementing their own ones, and add support for
> > the DMA_SLAVE_CONFIG control operation, which must accompany the new
> > channel selection method. We still support the legacy .private channel
> > allocation method to cater for a smooth driver migration.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> 
> Thanks for your efforts on this. Something that caught my eye in this
> patch is this portion:
> 
> +bool shdma_chan_filter(struct dma_chan *chan, void *arg);
> 
> If we would use this function in our DMA Engine slave drivers (MMCIF,
> SDHI, SCIF, FSI, SIU and so on) then wouldn't we add a strict
> dependency on this symbol provided by this particular DMA Engine
> driver implementation for the DMAC hardware (that your patch
> modifies)?
> 
> And what do we do if we want to use the same DMA Engine slave driver
> with a different DMA Engine driver implementation?
> 
> From my point of view, there must be some better way to not have such
> tight dependencies between the DMA Engine slave consumer and the DMA
> Engine driver. Not sure what that looks like though. This symbol
> dependency is pretty far from great IMO.
> 
I vaguely recall this coming up before, and it wasn't acceptable then
either.

We will by no means be adding driver-specific hooks in to other drivers
that really couldn't care less what the underlying DMA engine driving
them is.

We already have CPUs with different DMA engines that can be used by the
same drivers. As I said the last time, this needs to be fixed in the
dmaengine framework, period.
