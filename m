Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2KLN6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:58:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:7004 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab2KLN6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:58:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,762,1344236400"; 
   d="scan'208";a="247605502"
Message-ID: <1352728712.11158.291.camel@smile>
Subject: Re: [PATCH] dw_dmac: absence of pdata isn't critical when autocfg
 is set
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Mon, 12 Nov 2012 15:58:32 +0200
In-Reply-To: <CAOh2x=m9TyMOhh=nCD0nznEBy6jN7eUddp7hLT7TnCf0xM07dA@mail.gmail.com>
References: <1352719406-26405-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=m9TyMOhh=nCD0nznEBy6jN7eUddp7hLT7TnCf0xM07dA@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 19:24 +0530, viresh kumar wrote: 
> On Mon, Nov 12, 2012 at 4:53 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> 
> >  static int __devinit dw_probe(struct platform_device *pdev)
> >  {
> >         struct dw_dma_platform_data *pdata;
> > @@ -1604,9 +1610,6 @@ static int __devinit dw_probe(struct platform_device *pdev)
> >         if (!pdata)
> >                 pdata = dw_dma_parse_dt(pdev);
> >
> > -       if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
> > -               return -EINVAL;
> > -
> >         io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >         if (!io)
> >                 return -EINVAL;
> > @@ -1622,6 +1625,12 @@ static int __devinit dw_probe(struct platform_device *pdev)
> >         dw_params = dma_read_byaddr(regs, DW_PARAMS);
> >         autocfg = dw_params >> DW_PARAMS_EN & 0x1;
> >
> > +       if (!pdata && autocfg)
> > +               pdata = &dw_dma_pdata;
> 
> Allocate it dynamically to support multiple controllers with different
> configuration
> in a SoC.

Like you did for device tree? No problem, but here is the question: what
the default values should be and where we can get them?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
