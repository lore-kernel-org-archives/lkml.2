Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1G0Dyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:54:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:23899 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab1G0Dyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:54:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,273,1309762800"; 
   d="scan'208";a="31888338"
Subject: Re: linux-next: manual merge of the slave-dma tree with Linus' tree
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linus.walleij@linaro.org
In-Reply-To: <20110727120826.ea1227276707790e162dee18@canb.auug.org.au>
References: <20110727120826.ea1227276707790e162dee18@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 08:42:11 +0530
Message-ID: <1311736331.1536.45.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 12:08 +1000, Stephen Rothwell wrote:
> Hi Vinod,
> 
> Today's linux-next merge of the slave-dma tree got a conflict in
> drivers/spi/spi-pl022.c (called drivers/spi/amba-pl022.c in the sleav-dma
> tree) between commit 083be3f05371 ("spi/pl022: initialize burstsize from
> FIFO trigger level") from Linus' tree and commit 001b0585ff16 ("Improve
> slave/cyclic DMA engine documentation") from the slave-dma tree.
> 
> I fixed it up (see below) anc acn carry the fix as necessary.

The correct fix would be:

diff --cc drivers/spi/spi-pl022.c
index eba88c7,99e7880..0000000
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@@ -910,11 -908,11 +910,9 @@@ static int configure_dma(struct pl022 *
  {
        struct dma_slave_config rx_conf = {
                .src_addr = SSP_DR(pl022->phybase),
+		.direction = DMA_TO_DEVICE,
        };
        struct dma_slave_config tx_conf = {
                .dst_addr = SSP_DR(pl022->phybase),
                .direction = DMA_TO_DEVICE,
 -              .dst_maxburst = pl022->vendor->fifodepth >> 1,
        };
        unsigned int pages;
        int ret;

For now the direction flags remains to be set and checked is in both
tree so should not cause conflict.
I will rebase my tree tonight to 3.0, that should resolve conflict as
well

-- 
~Vinod

