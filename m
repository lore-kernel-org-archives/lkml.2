Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2ITJrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:47:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:25790 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab2ITJrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:47:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,453,1344236400"; 
   d="scan'208";a="208557995"
Message-ID: <1348134206.13371.40.camel@smile>
Subject: Re: [PATCH 6/7] dw_dmac: check if controller supports LLP
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Date: Thu, 20 Sep 2012 12:43:26 +0300
In-Reply-To: <CAOh2x=mav-8hkKEpOw0H5vQ=uPx+7sxBPsa_eDpTpEqgXuzXSQ@mail.gmail.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1347867577-13170-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=mav-8hkKEpOw0H5vQ=uPx+7sxBPsa_eDpTpEqgXuzXSQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 12:43 +0530, viresh kumar wrote: 
> On Mon, Sep 17, 2012 at 1:09 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Some controllers have the reduced functionality where the LLP multi block
> > transfers are not supported. This patch introduces a check and refuses to deal
> > with such devices.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw_dmac.c      |   35 ++++++++++++++++++++++++++++++++++-
> >  drivers/dma/dw_dmac_regs.h |    4 ++++
> >  2 files changed, 38 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index fdb7d5a..00958ad 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -647,6 +647,12 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
> >         unsigned int            dst_width;
> >         u32                     ctllo;
> >
> > +       if (dwc->nollp) {
> > +               dev_dbg(chan2dev(&dwc->chan),
> > +                               "channel doesn't support LLP transfers\n");
> > +               return NULL;
> > +       }
> 
> But this could have been a single block request. Isn't it?
I think we could discard this comment in regard to comments on next
patch.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
