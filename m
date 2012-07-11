Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283Ab2GKVzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:55:38 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63991 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab2GKVzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <1341418663-24432-4-git-send-email-g.liakhovetski@gmx.de>
References: <1341418663-24432-1-git-send-email-g.liakhovetski@gmx.de>
	<1341418663-24432-4-git-send-email-g.liakhovetski@gmx.de>
Date: Thu, 12 Jul 2012 06:55:32 +0900
Message-ID: <CANqRtoRz2NF6BEEYcy_BwZ7Hm5EF9zP2Z0eoQcbxaSfUuc2i9Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] dma: sh: provide a migration path for slave drivers
 to stop using .private
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

[CC Paul]

On Thu, Jul 5, 2012 at 1:17 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> This patch extends the sh dmaengine driver to support the preferred channel
> selection and configuration method, instead of using the "private" field
> from struct dma_chan. We add a standard filter function to be used by
> slave drivers instead of implementing their own ones, and add support for
> the DMA_SLAVE_CONFIG control operation, which must accompany the new
> channel selection method. We still support the legacy .private channel
> allocation method to cater for a smooth driver migration.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---

Thanks for your efforts on this. Something that caught my eye in this
patch is this portion:

+bool shdma_chan_filter(struct dma_chan *chan, void *arg);

If we would use this function in our DMA Engine slave drivers (MMCIF,
SDHI, SCIF, FSI, SIU and so on) then wouldn't we add a strict
dependency on this symbol provided by this particular DMA Engine
driver implementation for the DMAC hardware (that your patch
modifies)?

And what do we do if we want to use the same DMA Engine slave driver
with a different DMA Engine driver implementation?

>From my point of view, there must be some better way to not have such
tight dependencies between the DMA Engine slave consumer and the DMA
Engine driver. Not sure what that looks like though. This symbol
dependency is pretty far from great IMO.

Thanks,

/ magnus
