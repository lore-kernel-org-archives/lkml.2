Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2AFMnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:43:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49860 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2AFMnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:43:19 -0500
Date: Fri, 6 Jan 2012 13:43:11 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, Javier Martin <javier.martin@vista-silicon.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dmaengine: Fix status handling in imx-dma.
Message-ID: <20120106124311.GJ5446@pengutronix.de>
References: <1325506706-10028-1-git-send-email-javier.martin@vista-silicon.com>
 <1325829389.1540.95.camel@vkoul-udesk3>
 <20120106093752.GH5446@pengutronix.de>
 <1325848224.1540.102.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325848224.1540.102.camel@vkoul-udesk3>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:41:17 up 54 days, 20:28, 31 users,  load average: 0.00, 0.01,
 0.08
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 04:40:24PM +0530, Vinod Koul wrote:
> On Fri, 2012-01-06 at 10:37 +0100, Sascha Hauer wrote:
> > On Fri, Jan 06, 2012 at 11:26:29AM +0530, Vinod Koul wrote:
> > > On Mon, 2012-01-02 at 13:18 +0100, Javier Martin wrote:
> > > > Status must only be changed to DMA_IN_PROGRESS
> > > > when the DMA transfer has really begun.
> > > > 
> > > > However, since this driver lacks of support for
> > > > multiple descriptors a new flag has to be introduced
> > > > to avoid the prepare function be called multiple times.
> > > Thanks this is the right approach to fix this driver
> > > 
> > > But this will obviously break any users of this driver as they need to
> > > call the right APIs now :D
> > > 
> > > Sacha: can you check this patch and see which users of this driver will
> > > break. we need those fixes to go along this patch as well
> > 
> > Which users should break? I just tried with the mxcmmc driver and this
> > one does not break.
> > 
> > I do not really understand this patch anyway. It changes imxdmac->status
> > to a write-only variable and introduces a imxdmac->prepared variable
> > with the same meaning. This patch is a complicated no-op.
> > 
> > What was the original problem? The fact that we used a enum dma_status
> > with the wrong semantics? In that case I suggest to simply replace this
> > variable. All we need to track is that we do not enter
> > imxdma_prep_slave_sg with an already running transfer.
> the memcpy patch submitted earlier didn't use correct dmaengine API. a
> descriptor is not supposed to be started in prepare. The reason given
> was the driver already does so for all other prepares, so i suggested to
> fix that. Descriptors should be started in issue_pending only.

The transfer is not started in prepare but in imxdmac->desc.tx_submit

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
