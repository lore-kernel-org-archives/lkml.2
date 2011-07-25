Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1GYOZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:25:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:42262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1GYOZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:25:12 -0400
Subject: Re: [PATCH] dmaengine: imx-sdma: return proper error if kzalloc
 fails
From: Vinod Koul <vkoul@infradead.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: vinod.koul@intel.com, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <20110712135128.GV6069@pengutronix.de>
References: <1310475613.2618.0.camel@phoenix>
	 <20110712135128.GV6069@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Mon, 25 Jul 2011 19:54:07 +0530
Message-ID: <1311603847.8206.14.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 15:51 +0200, Sascha Hauer wrote:
> On Tue, Jul 12, 2011 at 09:00:13PM +0800, Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/dma/imx-sdma.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Applied, Thanks

> 
> > 
> > diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> > index 1ea47db..f96d038 100644
> > --- a/drivers/dma/imx-sdma.c
> > +++ b/drivers/dma/imx-sdma.c
> > @@ -1281,8 +1281,10 @@ static int __init sdma_probe(struct platform_device *pdev)
> >  		goto err_request_irq;
> >  
> >  	sdma->script_addrs = kzalloc(sizeof(*sdma->script_addrs), GFP_KERNEL);
> > -	if (!sdma->script_addrs)
> > +	if (!sdma->script_addrs) {
> > +		ret = -ENOMEM;
> >  		goto err_alloc;
> > +	}
> >  
> >  	sdma->version = pdata->sdma_version;
> >  
> > -- 
> > 1.7.4.1
> > 
> > 
> > 
> > 
> 

-- 
~Vinod Koul
Intel Corp.

