Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2FYBWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 21:22:09 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:44109 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908Ab2FYBWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 21:22:06 -0400
Subject: Re: linux-next: build failure after merge of the slave-dma tree
From: Zhangfei Gao <zgao6@marvell.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leo Yan <leoy@marvell.com>, Qiao Zhou <zhouqiao@marvell.com>
In-Reply-To: <1340341305.1562.2.camel@vkoul-udesk3>
References: <20120622130049.05d18e86de1256aa980566b0@canb.auug.org.au>
	 <1340341305.1562.2.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jun 2012 09:21:20 +0800
Message-ID: <1340587280.14586.9.camel@apse>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 22:01 -0700, Vinod Koul wrote:
> On Fri, 2012-06-22 at 13:00 +1000, Stephen Rothwell wrote:
> > Hi Vinod,
> > 
> > After merging the slave-dma tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/dma/mmp_tdma.c:21:27: fatal error: mach/regs-icu.h: No such file or directory
> > 
> > Caused by commit c6da0ba8dfc8 ("dmaengine: mmp_tdma: add mmp tdma
> > support").
> > 
> > I have used the slave-dma tree from next-20120621 for today.
> Thanks Stephen,
> 
> It should not build for this target!. I will added the below patch to
> fix the failure
> 
> >From 0efc8562577cd6a022b8b42d58fcf58ffc2a91d3 Mon Sep 17 00:00:00 2001
> From: Vinod Koul <vinod.koul@linux.intel.com>
> Date: Fri, 22 Jun 2012 10:29:53 +0530
> Subject: [PATCH] dmaengine: mmp_tdma: fix the arch dependency
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> ---
>  drivers/dma/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 90fec0e..d45cf1b 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -276,7 +276,7 @@ config DMA_SA11X0
>  
>  config MMP_TDMA
>  	bool "MMP Two-Channel DMA support"
> -	default ARCH_MMP
> +	depends on ARCH_MMP
>  	select DMA_ENGINE
>  	help
>  	  Support the MMP Two-Channel DMA engine.
> -- 
> 1.7.0.4
> 

Thanks Vinod and Stephen, sorry for the trouble.
> 


