Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1DZE4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:56:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:47311 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1DZE4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="425450850"
Subject: Re: [PATCH v2 1/5] dmaengine: at_hdmac: modify way to use
 interrupts
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20110426043408.GG12904@game.jcrosoft.org>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
	 <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
	 <1303790574.896.11.camel@vkoul-udesk3>
	 <20110426043408.GG12904@game.jcrosoft.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 09:54:41 +0530
Message-ID: <1303791881.896.18.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 10:04 +0530, Jean-Christophe PLAGNIOL-VILLARD
wrote:
> On 09:32 Tue 26 Apr     , Koul, Vinod wrote:
> > On Fri, 2011-04-22 at 19:41 +0200, Nicolas Ferre wrote:
> > > Now we use Buffer Transfer Completed interrupts. If we
> > > want a chained buffer completed information, we setup the
> > > ATC_IEN bit in CTRLB register in the lli.
> > > This is done by set_desc_eol() function and used by
> > > memcpy/slave_sg functions.
> > > 
> > > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > ---
> > >  drivers/dma/at_hdmac.c      |    4 ++--
> > >  drivers/dma/at_hdmac_regs.h |   11 ++++++++---
> > >  2 files changed, 10 insertions(+), 5 deletions(-)
> > > 
> > >  
> > Looks like your forgot to run checkpatch
> > WARNING: line over 80 characters
> > #401: FILE: drivers/dma/at_hdmac_regs.h:106:
> > +#define MEM_IF			0		/* specify AHB interface 0 as memory interface */
> > 
> > WARNING: line over 80 characters
> > #402: FILE: drivers/dma/at_hdmac_regs.h:107:
> > +#define PER_IF			1		/* specify AHB interface 1 as peripheral interface
> > */
> > 
> > WARNING: line over 80 characters
> > #689: FILE: drivers/dma/at_hdmac.c:899:
> > +			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
> > 
> > total: 0 errors, 3 warnings, 465 lines checked
> > 
> > While I am okay with 3rd one, you can easily reformat code for first two
> > and avoid these two warnings...
> It's comments it make it more readable
And that's why it can be easily reformatted without sacrificing code
readability and also avoid the warnings.
These warnings should be removed wherever its possible without
sacrificing code readability, something like:
+/* AHB interface defines */
+#define MEM_IF 0 /* 0 as memory interface */
+#define PER_IF 1 /* 1 as peripheral interface

and while at it, you need to fix these for namespace

-- 
~Vinod

