Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1JNQVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:21:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:30423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1JNQVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:21:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,347,1315206000"; 
   d="scan'208";a="62656592"
Subject: Re: [PATCH 09/10] USB: move to dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org, 21cnbao@gmail.com,
        rmk@arm.linux.org.uk, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <CAJe_Zhdy6gs1xqomhpGH9wrTHq5DhZsSDpzeNFRr84e9VPQEig@mail.gmail.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318570705-17595-10-git-send-email-vinod.koul@intel.com>
	 <CAJe_Zhdy6gs1xqomhpGH9wrTHq5DhZsSDpzeNFRr84e9VPQEig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 21:43:31 +0530
Message-ID: <1318608811.1546.438.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 16:31 +0530, Jassi Brar wrote:
> On 14 October 2011 11:08, Vinod Koul <vinod.koul@intel.com> wrote:
> >
> > diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
> > index ef4333f..9587bdd 100644
> > --- a/drivers/usb/musb/ux500_dma.c
> > +++ b/drivers/usb/musb/ux500_dma.c
> > @@ -112,7 +112,7 @@ static bool ux500_configure_channel(struct dma_channel *channel,
> >        struct musb_hw_ep *hw_ep = ux500_channel->hw_ep;
> >        struct dma_chan *dma_chan = ux500_channel->dma_chan;
> >        struct dma_async_tx_descriptor *dma_desc;
> > -       enum dma_data_direction direction;
> > +       enum dma_transfer_direction direction;
> >        struct scatterlist sg;
> >        struct dma_slave_config slave_conf;
> >        enum dma_slave_buswidth addr_width;
> > @@ -132,7 +132,7 @@ static bool ux500_configure_channel(struct dma_channel *channel,
> >        sg_dma_address(&sg) = dma_addr;
> >        sg_dma_len(&sg) = len;
> >
> > -       direction = ux500_channel->is_tx ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> > +       slave_dirn = ux500_channel->is_tx ? MEM_TO_DEV : DEV_TO_MEM;
> >        addr_width = (len & 0x3) ? DMA_SLAVE_BUSWIDTH_1_BYTE :
> >                                        DMA_SLAVE_BUSWIDTH_4_BYTES;
> >
> s/slave_dirn/direction ?
Oops, some how much scripts seems to have failed to build usb, hence
didnt find. Thanks for pointing out.

I will revise this and split into two as requested by Filipe


-- 
~Vinod

