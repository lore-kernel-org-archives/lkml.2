Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1LUEHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:07:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:24329 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1LUEHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:07:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98627977"
Subject: Re: [PATCH 0/4] Fix the left DMA_NONE from dma_transfer_direction
 migration
From: Vinod Koul <vinod.koul@intel.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Chris Ball <cjb@laptop.org>, Artem Bityutskiy <artem.bityutskiy@intel.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20111220125401.GA5129@S2101-09.ap.freescale.net>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
	 <1324373044.1641.10096.camel@vkoul-udesk3>
	 <20111220125401.GA5129@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 09:37:04 +0530
Message-ID: <1324440424.1641.10104.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 20:54 +0800, Shawn Guo wrote:
> On Tue, Dec 20, 2011 at 02:54:04PM +0530, Vinod Koul wrote:
> > On Tue, 2011-12-13 at 23:48 +0800, Shawn Guo wrote:
> > > I have been working on -rc recently, and have not noticed the failure
> > > until I ran next tree today.  The mxs-mmc driver is broken on next
> > > tree because the DMA_NONE was left over from the dma_transfer_direction
> > > migration for mxs-dma and its client drivers.
> > > 
> > For DMA transfer, the NONE direction makes no sense?
> > 
> > In your conetext, what are you trying to achieve?
> > 
> The mxs-dma controller has a feature to program peripheral registers
> with given values (mxs-dma PIO mode).  This is designed to pipeline
> the operations.  For example, we can put mxs-mmc controller register
> values into scatter list as one element together with actual data.
> Triggering the mxs-dma, the dma will program the values into mxs-mmc
> controller register to set up and enable mxs-mmc, and then dma
> continue transfer data from/to mxs-mmc.  All these get done in one
> dmaengine_submit().
> 
> And DMA_NONE was used to let mxs-dma know this is a PIO operation.
Sorry am little lost here. Why would DMA driver bother with a PIO mode,
that is something only peripheral driver would know about, mmc in your
case.

So what you are saying is the your dma has the capability to program the
peripheral registers in case of PIO mode, but why wouldn't the
peripheral driver do that instead? 

-- 
~Vinod

