Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2KEQpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:45:07 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:14147 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2KEQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:45:05 -0500
Message-ID: <1352133897.2606.16.camel@lorien2>
Subject: Re: [PATCH] wireless: iwlwifi - add dma_mapping_error() checks to
 avoid warnings
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wey-yi.w.guy@intel.com, linville@tuxdriver.com, ilw@linux.intel.com,
        emmanuel.grumbach@intel.com, donald.h.fry@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Mon, 05 Nov 2012 09:44:57 -0700
In-Reply-To: <1352132992.9466.27.camel@jlt4.sipsolutions.net>
References: <1351993233.4369.2.camel@lorien2>
	 (sfid-20121104_024119_271188_5372C13E) <1352020617.10072.0.camel@jlt4.sipsolutions.net>
	 <1352132785.2606.14.camel@lorien2>
	 <1352132992.9466.27.camel@jlt4.sipsolutions.net>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 17:29 +0100, Johannes Berg wrote:
> On Mon, 2012-11-05 at 09:26 -0700, Shuah Khan wrote:
> 
> > > Thanks for the report. Since I think doing BUG_ON() in such a scenario
> > > is a really bad idea, I've applied a different patch with your
> > > Reported-by.
> > 
> > Yeah. I wasn't sure about BUS() either. Did you notice the other cases
> > of BUG_ON() in this path in iwl_rx_allocate()? I would think those need
> > fixing as well.
> > 
> >               rxb->page_dma =
> >                         dma_map_page(trans->dev, page, 0,
> >                                      PAGE_SIZE <<
> > trans_pcie->rx_page_order,
> >                                      DMA_FROM_DEVICE);
> >                 /* dma address must be no more than 36 bits */
> >                 BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
> >                 /* and also 256 byte aligned! */
> >                 BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
> 
> Well, yes, we could convert them, but we can leave them as they are
> because these are assertions that the DMA mapping API guarantees. If
> this breaks, it's a bug in the DMA mapping code.
> 
> In contrast, if it fails to map, it's not a bug in the code, it's just
> running out of memory or IO space or whatever.

Right.
> 
> > Could you please send me commitID for the patch you did. I am interested
> > in seeing the failure handling in your patch?
> 
> It's here:
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-fixes.git;a=commit;h=7c34158231b2eda8dcbd297be2bb1559e69cb433
> 


Thanks. 


