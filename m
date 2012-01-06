Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab2AFLKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:10:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:31664 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119Ab2AFLKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:10:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="53877100"
Subject: Re: [PATCH 1/2] dmaengine: Fix status handling in imx-dma.
From: Vinod Koul <vinod.koul@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: dan.j.williams@intel.com, Javier Martin <javier.martin@vista-silicon.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120106093752.GH5446@pengutronix.de>
References: <1325506706-10028-1-git-send-email-javier.martin@vista-silicon.com>
	 <1325829389.1540.95.camel@vkoul-udesk3>
	 <20120106093752.GH5446@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jan 2012 16:40:24 +0530
Message-ID: <1325848224.1540.102.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 10:37 +0100, Sascha Hauer wrote:
> On Fri, Jan 06, 2012 at 11:26:29AM +0530, Vinod Koul wrote:
> > On Mon, 2012-01-02 at 13:18 +0100, Javier Martin wrote:
> > > Status must only be changed to DMA_IN_PROGRESS
> > > when the DMA transfer has really begun.
> > > 
> > > However, since this driver lacks of support for
> > > multiple descriptors a new flag has to be introduced
> > > to avoid the prepare function be called multiple times.
> > Thanks this is the right approach to fix this driver
> > 
> > But this will obviously break any users of this driver as they need to
> > call the right APIs now :D
> > 
> > Sacha: can you check this patch and see which users of this driver will
> > break. we need those fixes to go along this patch as well
> 
> Which users should break? I just tried with the mxcmmc driver and this
> one does not break.
> 
> I do not really understand this patch anyway. It changes imxdmac->status
> to a write-only variable and introduces a imxdmac->prepared variable
> with the same meaning. This patch is a complicated no-op.
> 
> What was the original problem? The fact that we used a enum dma_status
> with the wrong semantics? In that case I suggest to simply replace this
> variable. All we need to track is that we do not enter
> imxdma_prep_slave_sg with an already running transfer.
the memcpy patch submitted earlier didn't use correct dmaengine API. a
descriptor is not supposed to be started in prepare. The reason given
was the driver already does so for all other prepares, so i suggested to
fix that. Descriptors should be started in issue_pending only.

I thought that change is done in this patch (looks like i didn't look
too carefully), so if prepare is used per API definition, clients which
dont call issue_pending would break...


-- 
~Vinod

