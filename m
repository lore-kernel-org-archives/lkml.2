Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2IUPJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:09:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:24421 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960Ab2IUPJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:09:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,463,1344236400"; 
   d="scan'208";a="195851250"
Message-ID: <1348240166.13371.100.camel@smile>
Subject: Re: [PATCHv2 4/6] dw_dmac: autoconfigure block_size or use platform
 data
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Date: Fri, 21 Sep 2012 18:09:26 +0300
In-Reply-To: <CAOh2x=mTfy=LfFdB1UL-331b+Rqrxpa=D8rVZ7jaxJJiUT9_zw@mail.gmail.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348229149-29040-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=mTfy=LfFdB1UL-331b+Rqrxpa=D8rVZ7jaxJJiUT9_zw@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 19:30 +0530, viresh kumar wrote: 
> On Fri, Sep 21, 2012 at 5:35 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > @@ -1385,6 +1375,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
> 
> > +       /* get hardware configuration parameters */
> > +       if (autocfg)
> > +               max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
> > +
> 
> Why don't you do above with the below ++ code
> 
> >         /* Calculate all channel mask before DMA setup */
> >         dw->all_chan_mask = (1 << nr_channels) - 1;
> >
> > @@ -1470,6 +1465,16 @@ static int __devinit dw_probe(struct platform_device *pdev)
> >                 INIT_LIST_HEAD(&dwc->free_list);
> >
> >                 channel_clear_bit(dw, CH_EN, dwc->mask);
> > +
> > +               /* hardware configuration */
> > +               if (autocfg)
> > +                       /* Decode maximum block size for given channel. The
> > +                        * stored 4 bit value represents blocks from 0x00 for 3
> > +                        * up to 0x0a for 4095. */
> 
> i.e. here?
Because there is only one register, but we have loop for channels. Shall
we read the same register as many times as amount of channels we have?

> 
> > +                       dwc->block_size =
> > +                               (4 << ((max_blk_size >> 4 * i) & 0xf)) - 1;
> > +               else
> > +                       dwc->block_size = pdata->block_size;
> >         }

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
