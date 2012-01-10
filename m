Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2AJGeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 01:34:25 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:26151
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834Ab2AJGeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 01:34:23 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dhc1ahc1bh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Tue, 10 Jan 2012 14:34:15 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Richard Zhao <richard.zhao@linaro.org>, <patches@linaro.org>,
        <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <eric.miao@linaro.org>, <kernel@pengutronix.de>,
        <dan.j.williams@intel.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] dma/imx-sdma: call sdma_set_channel_priority after
 sdma_request_channel
Message-ID: <20120110063414.GZ2414@b20223-02.ap.freescale.net>
References: <1326098940-3697-1-git-send-email-richard.zhao@linaro.org>
 <20120110030220.GA23362@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120110030220.GA23362@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid merge conflicts, I'll send the patch series again with
other prior sdma patch.

Thanks
Richard

On Tue, Jan 10, 2012 at 11:02:25AM +0800, Shawn Guo wrote:
> On Mon, Jan 09, 2012 at 04:48:59PM +0800, Richard Zhao wrote:
> > sdma_request_channel sets the default priority. sdma_alloc_chan_resources
> > should call sdma_set_channel_priority thereafter to over write it.
> > 
> > Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> 
> Regards,
> Shawn
> 
> > ---
> >  drivers/dma/imx-sdma.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> > index 2cc96c4..6376009 100644
> > --- a/drivers/dma/imx-sdma.c
> > +++ b/drivers/dma/imx-sdma.c
> > @@ -875,11 +875,11 @@ static int sdma_alloc_chan_resources(struct dma_chan *chan)
> >  
> >  	sdmac->peripheral_type = data->peripheral_type;
> >  	sdmac->event_id0 = data->dma_request;
> > -	ret = sdma_set_channel_priority(sdmac, prio);
> > +	ret = sdma_request_channel(sdmac);
> >  	if (ret)
> >  		return ret;
> >  
> > -	ret = sdma_request_channel(sdmac);
> > +	ret = sdma_set_channel_priority(sdmac, prio);
> >  	if (ret)
> >  		return ret;
> >  
> > -- 
> > 1.7.5.4
> > 
> > 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

