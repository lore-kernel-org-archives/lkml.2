Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2ITJgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:36:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:65402 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab2ITJgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:36:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,453,1344236400"; 
   d="scan'208";a="194929883"
Message-ID: <1348133748.13371.33.camel@smile>
Subject: Re: [PATCH 3/7] dw_dmac: get number of channels from hardware if
 possible
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Date: Thu, 20 Sep 2012 12:35:48 +0300
In-Reply-To: <CAOh2x==MwD6RVnShoD0zJaAPZ814bAGDx6BEjGsK=9M+LxMxBA@mail.gmail.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1347867577-13170-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x==MwD6RVnShoD0zJaAPZ814bAGDx6BEjGsK=9M+LxMxBA@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 12:20 +0530, viresh kumar wrote: 
> On Mon, Sep 17, 2012 at 1:09 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > In case the controller has the encoded parameters feature enabled the driver
> > will use it to get the number of channels. In the future it will be used for
> > the other important parameters as well.

[snip]

> > @@ -1392,23 +1396,32 @@ static int __devinit dw_probe(struct platform_device *pdev)
> >         if (irq < 0)
> >                 return irq;
> >
> > -       size = sizeof(struct dw_dma);
> > -       size += pdata->nr_channels * sizeof(struct dw_dma_chan);
> > +       regs = devm_request_and_ioremap(&pdev->dev, io);
> > +       if (!regs)
> > +               return -EBUSY;
> > +
> > +       dw_params = dma_raw_readl(regs, DW_PARAMS);
> 
> Is this valid for every SoC implementation. What if this configuration
> is not valid
> for a particular SoC and it is invalid to access this address? Or this
> gives a invalid
> value instead of returning 0?
Actually I didn't get it clearly from the documentation. We have only
one test report from Hein until now.

> > diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> > index 4633d39..0f96965 100644
> > --- a/drivers/dma/dw_dmac_regs.h
> > +++ b/drivers/dma/dw_dmac_regs.h
> > @@ -104,6 +104,10 @@ struct dw_dma_regs {
> >  #define dma_raw_writel(addr, name, val) \
> >         writel((val), (addr) + offsetof(struct dw_dma_regs, name))
> >
> > +/* Bitfields in DW_PARAMS */
> > +#define DW_PARAMS_NR_CHAN      8               /* number of channels */
> > +#define DW_PARAMS_EN           28              /* encoded parameters */
> > +
> 
> Can you make this part of patch 2/7?
Do you mean to combine patch 2 and 3 together or only the parts related
to dw_dmac_regs.h?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
