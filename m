Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1JKRJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:09:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:23418 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1JKRJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:09:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="62191776"
Subject: Re: [PATCH 1/2 v2] pch_dma: Fix suspend issue
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
In-Reply-To: <1318337002-10041-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1318337002-10041-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 22:31:16 +0530
Message-ID: <1318352476.1546.360.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 21:43 +0900, Tomoya MORINAGA wrote:
> Currently, executing suspend/hibernation,
> memory access violation occurs.
> 
> In pch_dma_save_regs() called by suspend(),
> you can see the following code.
> 
> static void pch_dma_save_regs(struct pch_dma *pd)
> {
> snip...
>         list_for_each_entry_safe(chan, _c, &pd->dma.channels, device_node) {
>                 pd_chan = to_pd_chan(chan);
> 
>                 pd->ch_regs[i].dev_addr = channel_readl(pd_chan, DEV_ADDR);
>                 pd->ch_regs[i].mem_addr = channel_readl(pd_chan, MEM_ADDR);
>                 pd->ch_regs[i].size = channel_readl(pd_chan, SIZE);
>                 pd->ch_regs[i].next = channel_readl(pd_chan, NEXT);
> 
>                 i++;
>         }
> }
> 
> Max loop count is 12 defined at pci_table.
> So, this caused memory access violation.
> 
> This patch fixes the issue
>  - Modify array size (MAX_CHAN_NR)
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> ---
>  drivers/dma/pch_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index ff5b38f..e72bfeb 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -59,7 +59,7 @@
>  #define DMA_DESC_FOLLOW_WITHOUT_IRQ	0x2
>  #define DMA_DESC_FOLLOW_WITH_IRQ	0x3
>  
> -#define MAX_CHAN_NR			8
> +#define MAX_CHAN_NR			12
>  
>  static unsigned int init_nr_desc_per_channel = 64;
>  module_param(init_nr_desc_per_channel, uint, 0644);
Applied only 1/2. 2/2 needs modifications

Thanks

-- 
~Vinod

