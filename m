Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2ITJiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:38:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:11385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab2ITJiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:38:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,453,1344236400"; 
   d="scan'208";a="147084889"
Message-ID: <1348133880.13371.35.camel@smile>
Subject: Re: [PATCH 4/7] dw_dmac: autoconfigure block_size or use platform
 data
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Date: Thu, 20 Sep 2012 12:38:00 +0300
In-Reply-To: <CAOh2x=noPEPNNEDJG7_BRV_eeY1PWxR=8EWpOCWLp_ohS-gpdw@mail.gmail.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1347867577-13170-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=noPEPNNEDJG7_BRV_eeY1PWxR=8EWpOCWLp_ohS-gpdw@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 12:27 +0530, viresh kumar wrote:

[snip]

> > @@ -1420,6 +1411,9 @@ static int __devinit dw_probe(struct platform_device *pdev)
> >
> >         dw->regs = regs;
> >
> > +       /* get hardware configuration parameters */
> > +       max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
> > +
> 
> Do this only for autocfg case.
Ok.

> > @@ -1465,6 +1459,14 @@ static int __devinit dw_probe(struct platform_device *pdev)
> >                 INIT_LIST_HEAD(&dwc->free_list);
> >
> >                 channel_clear_bit(dw, CH_EN, dwc->mask);
> > +
> > +               /* hardware configuration */
> > +               if (autocfg) {
> > +                       dwc->block_size =
> > +                               (4 << ((max_blk_size >> 4 * i) & 0xf)) - 1;
> 
> Put a comment on what are you doing here.
Ok.

> 
> > +               } else {
> > +                       dwc->block_size = pdata->block_size;
> > +               }
> 
> Don't need {} for single line statements.
Ok. By the way it comes by next patch anyway.

> > --- a/drivers/dma/dw_dmac_regs.h
> > +++ b/drivers/dma/dw_dmac_regs.h
> > @@ -186,6 +186,9 @@ struct dw_dma_chan {
> >
> >         unsigned int            descs_allocated;
> >
> > +       /* hardware configuration */
> > +       unsigned short          block_size;
> > +
> 
> You actually don't save any memory here with short and actually makes access
> to block_size more complex. keeping it int would be better i believe.
I rather agree with you. I'll change it.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
