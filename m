Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab2JRLKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:10:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:29135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab2JRLKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:10:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="229179379"
Message-ID: <1350558583.3568.9.camel@smile>
Subject: Re: [PATCHv2 3/4] dw_dmac: change {dev_}printk() to corresponding
 macros
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: balbi@ti.com
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Date: Thu, 18 Oct 2012 14:09:43 +0300
In-Reply-To: <20121018103413.GB1449@arwen.pp.htv.fi>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20121017130918.GD11394@arwen.pp.htv.fi> <1350481018.3568.3.camel@smile>
	 <20121017135306.GG11394@arwen.pp.htv.fi> <1350548131.3568.6.camel@smile>
	 <20121018103413.GB1449@arwen.pp.htv.fi>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 13:34 +0300, Felipe Balbi wrote: 
> On Thu, Oct 18, 2012 at 11:15:31AM +0300, Andy Shevchenko wrote:
> > On Wed, 2012-10-17 at 16:53 +0300, Felipe Balbi wrote: 
> > > On Wed, Oct 17, 2012 at 04:36:58PM +0300, Andy Shevchenko wrote:
> > > > On Wed, 2012-10-17 at 16:09 +0300, Felipe Balbi wrote: 

> > > > > > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c

> > > > > > @@ -492,10 +491,8 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
> > > > > >  	 * controller flagged an error instead of scribbling over
> > > > > >  	 * random memory locations.
> > > > > >  	 */
> > > > > > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > > > > > -			"Bad descriptor submitted for DMA!\n");
> > > > > > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > > > > > -			"  cookie: %d\n", bad_desc->txd.cookie);
> > > > > > +	dev_crit(chan2dev(&dwc->chan), "Bad descriptor submitted for DMA!\n");
> > > > > > +	dev_crit(chan2dev(&dwc->chan), "  cookie: %d\n", bad_desc->txd.cookie);
> > > > > 
> > > > > now this is critical, indeed. I would suggest using dev_WARN_ONCE() so
> > > > > that it's noisy enough to catch the failing user.
> > > > To this and upper comment, there is an explanation why it's critical. I
> > > > guess the WARN_ONCE is not good enough, for example if we have more than
> > > > one user making such noise.
> > > 
> > > then use dev_WARN()
> > I can't see how dev_WARN could be more useful here than the dev_crit. In
> > current message we have channel and cookie to link back to the user.
> > What does WARN add meaningful?
> 
> a dump_stack()

How could it be useful? The dwc_handle_error is called from a tasklet
that is called from scheduler asynchronously. The tasklet is queued in
interrupt handler.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
