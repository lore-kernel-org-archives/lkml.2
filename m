Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2DTKM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:12:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:6696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab2DTKM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:12:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="132030537"
Subject: Re: [PATCH] spi/spi-ep93xx.c: use dma_transfer_direction instead
 of dma_data_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca
In-Reply-To: <20120419061020.GB18520@mwesterb-mobl.lan>
References: <201204171846.37245.hartleys@visionengravers.com>
	 <20120419061020.GB18520@mwesterb-mobl.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 15:39:51 +0530
Message-ID: <1334916592.31825.35.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 09:10 +0300, Mika Westerberg wrote:
> On Tue, Apr 17, 2012 at 06:46:36PM -0700, H Hartley Sweeten wrote:
> > A new enum indicating the dma channel direction was introduced by:
> > 
> > commit 49920bc66984a512f4bcc7735a61642cd0e4d6f2
> >     dmaengine: add new enum dma_transfer_direction
> > 
> > The following commit changed spi-ep93xx to use the new enum:
> > 
> > commit a485df4b4404379786c4bdd258bc528b2617449d
> >     spi, serial: move to dma_transfer_direction
> > 
> > In doing so a sparse warning was introduced: 
> > 
> > warning: mixing different enum types
> >    int enum dma_data_direction  versus
> >    int enum dma_transfer_direction
> > 
> > This is produced because the 'dir' passed in ep93xx_spi_dma_prepare
> > is an enum dma_data_direction and is being used to set the
> > dma_slave_config 'direction' which is now an enum dma_transfer_direction.
> > 
> > Fix this by converting spi-ep93xx to use the new enum type in all
> > places.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Vinod Koul <vinod.koul@linux.intel.com>
> 
> Acked-by: Mika Westerberg <mika.westerberg@iki.fi>
Acked-by: Vinod Koul <vinod.koul@intel.com>

-- 
~Vinod

