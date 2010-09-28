Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023Ab0I1AM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:12:28 -0400
Received: from sh.osrg.net ([192.16.179.4]:40873 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab0I1AM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:12:27 -0400
Date: Tue, 28 Sep 2010 09:12:17 +0900
To: ddaney@caviumnetworks.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-mips@linux-mips.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] MIPS: Convert DMA to use dma-mapping-common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4CA0D5D3.3040700@caviumnetworks.com>
References: <1285281496-24696-6-git-send-email-ddaney@caviumnetworks.com>
	<20100927142628X.fujita.tomonori@lab.ntt.co.jp>
	<4CA0D5D3.3040700@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100928090805M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 28 Sep 2010 09:12:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 10:35:15 -0700
David Daney <ddaney@caviumnetworks.com> wrote:

> >> diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
> >> index 18fbf7a..9a4c307 100644
> >> --- a/arch/mips/include/asm/dma-mapping.h
> >> +++ b/arch/mips/include/asm/dma-mapping.h
> >> @@ -5,51 +5,67 @@
> >>   #include<asm/cache.h>
> >>   #include<asm-generic/dma-coherent.h>
> >>
> >> -void *dma_alloc_noncoherent(struct device *dev, size_t size,
> >> -			   dma_addr_t *dma_handle, gfp_t flag);
> >> +struct mips_dma_map_ops {
> >> +	struct dma_map_ops dma_map_ops;
> >> +	dma_addr_t (*phys_to_dma)(struct device *dev, phys_addr_t paddr);
> >> +	phys_addr_t (*dma_to_phys)(struct device *dev, dma_addr_t daddr);
> >> +};
> >
> > The above code doesn't look great but we don't want to add phys_to_dma
> > and dma_to_phys to dma_map_ops struct, and these functions on MIPS
> > looks too complicated for ifdef. So I guess that we need to live with
> > the above code.
> >
> 
> I think you have a point here.  I will attempt to move these two into a 
> chip specific operations vector, and leave the more generic MIPS version 
> with the simplified static definition.

Yeah, that sounds a better (cleaner) approach.
