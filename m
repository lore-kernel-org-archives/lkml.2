Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768051Ab2KOP2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:28:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:53257 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767654Ab2KOP17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:27:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,258,1352102400"; 
   d="scan'208";a="242713505"
Message-ID: <1352993269.11158.340.camel@smile>
Subject: Re: [PATCH 2/2] dw_dmac: make usage of dw_dma_slave optional
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Nov 2012 17:27:49 +0200
In-Reply-To: <CAKohpo=F1SmD0qCn9ybOOQ9VXWFQ-BY=udPgrWYPa23M2PuU_g@mail.gmail.com>
References: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1352989248-28913-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=mpzinz4xr4poNtX0Mom65kfptGM047-hu+XDLTS7m2rw@mail.gmail.com>
	 <1352992898.11158.338.camel@smile>
	 <CAKohpo=F1SmD0qCn9ybOOQ9VXWFQ-BY=udPgrWYPa23M2PuU_g@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 20:54 +0530, Viresh Kumar wrote: 
> On 15 November 2012 20:51, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Thu, 2012-11-15 at 20:28 +0530, viresh kumar wrote:
> >> On Thu, Nov 15, 2012 at 7:50 PM, Andy Shevchenko
> >> <andriy.shevchenko@linux.intel.com> wrote:
> >> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> >>
> >> > +static inline bool dwc_is_slave(struct dma_slave_config *sconfig)
> >> > +{
> >> > +       return is_slave_direction(sconfig->direction);
> >> > +}
> >>
> >> I will not buy this one. Why hide the real implementation, call
> >> is_slave_direction()
> >> directly.
> >
> > There is no strong reason to keep it so.
> >
> >> > @@ -1344,6 +1352,8 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
> >> > +       sconfig->direction = direction;
> >> > +
> >>
> >> > @@ -1718,6 +1728,7 @@ static int __devinit dw_probe(struct platform_device *pdev)
> >> > +               dwc->dma_sconfig.direction = DMA_TRANS_NONE;
> >>
> >> Why do you need above changes??
> >
> > This one is not needed indeed. But we have to look after default (0)
> > enum value.
> 
> I am asking about all lines where you are doing sconfig->direction = foo;

Well, the prep_* should assign the value due to changes of check in the
dwc_descriptor_complete. Otherwise we will potentially skip some
important piece of code.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
