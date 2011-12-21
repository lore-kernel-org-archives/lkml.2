Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1LUEgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:36:15 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:35216
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab1LUEgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:36:13 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 21 Dec 2011 12:45:18 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: Chris Ball <cjb@laptop.org>, Artem Bityutskiy <artem.bityutskiy@intel.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>, <linux-mtd@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/4] Fix the left DMA_NONE from dma_transfer_direction
 migration
Message-ID: <20111221044517.GD5983@S2101-09.ap.freescale.net>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
 <1324373044.1641.10096.camel@vkoul-udesk3>
 <20111220125401.GA5129@S2101-09.ap.freescale.net>
 <1324440424.1641.10104.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1324440424.1641.10104.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 09:37:04AM +0530, Vinod Koul wrote:
> On Tue, 2011-12-20 at 20:54 +0800, Shawn Guo wrote:
> > On Tue, Dec 20, 2011 at 02:54:04PM +0530, Vinod Koul wrote:
> > > On Tue, 2011-12-13 at 23:48 +0800, Shawn Guo wrote:
> > > > I have been working on -rc recently, and have not noticed the failure
> > > > until I ran next tree today.  The mxs-mmc driver is broken on next
> > > > tree because the DMA_NONE was left over from the dma_transfer_direction
> > > > migration for mxs-dma and its client drivers.
> > > > 
> > > For DMA transfer, the NONE direction makes no sense?
> > > 
> > > In your conetext, what are you trying to achieve?
> > > 
> > The mxs-dma controller has a feature to program peripheral registers
> > with given values (mxs-dma PIO mode).  This is designed to pipeline
> > the operations.  For example, we can put mxs-mmc controller register
> > values into scatter list as one element together with actual data.
> > Triggering the mxs-dma, the dma will program the values into mxs-mmc
> > controller register to set up and enable mxs-mmc, and then dma
> > continue transfer data from/to mxs-mmc.  All these get done in one
> > dmaengine_submit().
> > 
> > And DMA_NONE was used to let mxs-dma know this is a PIO operation.
> Sorry am little lost here. Why would DMA driver bother with a PIO mode,
> that is something only peripheral driver would know about, mmc in your
> case.
> 
The term PIO here may not the one on your mind.  I call it 'mxs-dma
pio'.  In this mode, mxs-dma hardware can write values into mmc
controller register without cpu involved.

> So what you are saying is the your dma has the capability to program the
> peripheral registers in case of PIO mode, but why wouldn't the
> peripheral driver do that instead? 
> 
Yes, I'm saying mxs-dma has the capability to program the peripheral
registers, and that's called 'mxs-dma pio' mode.

-- 
Regards,
Shawn

