Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab2JXDZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:25:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:54332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934238Ab2JXDZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:25:44 -0400
Subject: Re: [RFC PATCH 1/3] dmaengine: add dma_get_channel_caps()
From: Vinod Koul <vkoul@infradead.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: vinod.koul@intel.com, Matt Porter <mporter@ti.com>,
        Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
In-Reply-To: <CACxGe6sUrXPc2wtLfOy8_LvRMM+e=9=sSDNLkeszfe=JX_ipbw@mail.gmail.com>
References: <1350615088-14562-1-git-send-email-mporter@ti.com>
	 <1350615088-14562-2-git-send-email-mporter@ti.com>
	 <CACxGe6sUrXPc2wtLfOy8_LvRMM+e=9=sSDNLkeszfe=JX_ipbw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 08:43:27 +0530
Message-ID: <1351048407.5263.10.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 23:49 +0100, Grant Likely wrote:
> > +enum dmaengine_apis {
> > +       DMAENGINE_MEMCPY        = 0x0001,
> > +       DMAENGINE_XOR           = 0x0002,
> > +       DMAENGINE_XOR_VAL       = 0x0004,
> > +       DMAENGINE_PQ            = 0x0008,
> > +       DMAENGINE_PQ_VAL        = 0x0010,
> > +       DMAENGINE_MEMSET        = 0x0020,
> > +       DMAENGINE_SLAVE         = 0x0040,
> > +       DMAENGINE_CYCLIC        = 0x0080,
> > +       DMAENGINE_INTERLEAVED   = 0x0100,
> > +       DMAENGINE_SG            = 0x0200,
> > +};
> 
> Actually, one more comment. Why the new enum? Why can't the
> dma_transaction_type enum be used directly along with dma_cap_mask_t? 
Some of the capabilities above are not there in dma_caps_t like DMA_SG.
Also DMA_INTERRUPT and DMA_PRIVATE would not make much sense here.

BUT would help to keep things simpler if have one definition which
includes all.
 
-- 
Vinod Koul
Intel Corp.

