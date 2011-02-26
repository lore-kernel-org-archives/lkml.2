Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1BZPTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 10:19:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:10169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab1BZPTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 10:19:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,232,1297065600"; 
   d="scan'208";a="891537143"
Subject: Re: [PATCH 2/2] pch_dma: set the number of array correctly
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>
In-Reply-To: <BD1B47087D5E7D44AE5A1EFDFBF0023B086D6C222B@bgsmsx502.gar.corp.intel.com>
References: <BD1B47087D5E7D44AE5A1EFDFBF0023B086D6C222B@bgsmsx502.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Feb 2011 20:23:49 +0530
Message-ID: <1298732029.6974.13.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 22:44 +0530, Koul, Vinod wrote:
> > On Fri, 2011-02-18 at 10:01 +0530, Tomoya MORINAGA wrote:
> > set the number of array correctly.
> > 
> > Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> > ---
> >  drivers/dma/pch_dma.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> > index bf2ddd6..b1dfba7 100644
> > --- a/drivers/dma/pch_dma.c
> > +++ b/drivers/dma/pch_dma.c
> > @@ -82,7 +82,7 @@ struct pch_dma_regs {
> >  	u32	dma_sts1;
> >  	u32	reserved2;
> >  	u32	reserved3;
> > -	struct pch_dma_desc_regs desc[0];
> > +	struct pch_dma_desc_regs desc[MAX_CHAN_NR];
> >  };
> >  
> >  struct pch_dma_desc {
> > @@ -124,7 +124,7 @@ struct pch_dma {
> >  	struct pci_pool		*pool;
> >  	struct pch_dma_regs	regs;
> >  	struct pch_dma_desc_regs ch_regs[MAX_CHAN_NR];
> > -	struct pch_dma_chan	channels[0];
> > +	struct pch_dma_chan	channels[MAX_CHAN_NR];
> >  };
> >  
> >  #define PCH_DMA_CTL0	0x00
> 
> Both
> Acked-by: Vinod Koul <vinod.koul@intel.com>
Applied both @git://git.infradead.org/users/vkoul/slave-dma.git

Fixed one minor style error in 2nd patch but from next time please
ensure you run checkpatch before sending

-- 
~Vinod

