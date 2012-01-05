Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab2AEJTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:19:35 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:23782
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab2AEJTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:19:15 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 5 Jan 2012 17:19:05 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Richard Zhao <richard.zhao@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        <patches@linaro.org>, <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, <eric.miao@linaro.org>,
        <kernel@pengutronix.de>, <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/2] dma/imx-sdma: use writel to write register when
 enable a channel
Message-ID: <20120105091904.GO2414@b20223-02.ap.freescale.net>
References: <1325750362-22598-1-git-send-email-richard.zhao@linaro.org>
 <1325750362-22598-3-git-send-email-richard.zhao@linaro.org>
 <20120105092316.GB1729@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120105092316.GB1729@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Thu, Jan 05, 2012 at 05:23:17PM +0800, Shawn Guo wrote:
> On Thu, Jan 05, 2012 at 03:59:22PM +0800, Richard Zhao wrote:
> > dma_alloc_coherent memory may be bufferable when set
> > CONFIG_ARM_DMA_MEM_BUFFERABLE. We need to add nececcary
> > memory barrier. writel implicitly call wmb in such case.
> > 
> > Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> > ---
> >  drivers/dma/imx-sdma.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> > index c2bc4f1..e987468 100644
> > --- a/drivers/dma/imx-sdma.c
> > +++ b/drivers/dma/imx-sdma.c
> > @@ -396,7 +396,7 @@ static int sdma_config_ownership(struct sdma_channel *sdmac,
> >  
> >  static void sdma_enable_channel(struct sdma_engine *sdma, int channel)
> >  {
> > -	__raw_writel(1 << channel, sdma->regs + SDMA_H_START);
> > +	writel(1 << channel, sdma->regs + SDMA_H_START);
> >  }
> >  
> 
> As educated by Arnd, generally it's safer to use pair of readl/writel
> than __raw_readl/__raw_writel in driver.  I'm wondering if it's a good
> opportunity for us to change the pair all over this driver.
Russel mentioned that too. But I cannot understand.
If CONFIG_ARM_DMA_MEM_BUFFERABLE, readl/writel always call rmb/wmb. Do
we realy need it? It might affect performance.

Du to the concern, I didn't convert all the readl/writel.

Thanks
Richard
> 
> -- 
> Regards,
> Shawn
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

