Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab0IIF1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 01:27:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:6319 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab0IIF1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 01:27:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,337,1280732400"; 
   d="scan'208";a="322557329"
Date: Thu, 9 Sep 2010 13:08:58 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Feng Tang <feng.tang@intel.com>, George Shore <george@georgeshore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dw_spi: Allow interrupt sharing
Message-ID: <20100909050858.GA8003@ywang-moblin2.bj.intel.com>
References: <20100907072727.GA2152@ywang-moblin2.bj.intel.com> <20100908165341.GJ3686@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908165341.GJ3686@angua.secretlab.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 10:53:41AM -0600, Grant Likely wrote:
> On Tue, Sep 07, 2010 at 03:27:27PM +0800, Yong Wang wrote:
> > Allow interrupt sharing since exclusive interrupt line for
> > DW SPI controller is not provided on every platform.
> > 
> > Signed-off-by: Yong Wang <yong.y.wang@intel.com>
> > ---
> >  drivers/spi/dw_spi.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/spi/dw_spi.c b/drivers/spi/dw_spi.c
> > index d256cb0..11fbbf6 100644
> > --- a/drivers/spi/dw_spi.c
> > +++ b/drivers/spi/dw_spi.c
> > @@ -396,6 +396,11 @@ static irqreturn_t interrupt_transfer(struct dw_spi *dws)
> >  static irqreturn_t dw_spi_irq(int irq, void *dev_id)
> >  {
> >  	struct dw_spi *dws = dev_id;
> > +	u16 irq_status, irq_mask = 0x3f;
> > +
> > +	irq_status = dw_readw(dws, isr) & irq_mask;
> > +	if (!irq_status)
> > +		return IRQ_NONE;
> 
> To be more concise, this could have simply been:
> 
> if (!dw_readw(dws, isr) & 0x3f)
> 	return IRQ_NONE;
> 
> ... but I'm nitpicking here.  If I don't get an updated version of
> this patch from you in the next few days then I'll apply this one.
> 

Thanks for your comments, Grant. Could you please apply the patch as is?
I think it is more readable. In addition, it is consistent with other
parts of the driver in terms of how isr register is manipulated.

Thanks
-Yong

