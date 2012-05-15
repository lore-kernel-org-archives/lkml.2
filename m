Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab2EOEbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 00:31:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:57758 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab2EOEbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 00:31:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153014615"
Subject: Re: [PATCH 2/9 v3] dma: shdma: prepare for conversion to the shdma
 base library
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
In-Reply-To: <1336576161-27082-3-git-send-email-g.liakhovetski@gmx.de>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
	 <1336576161-27082-3-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 09:53:52 +0530
Message-ID: <1337055832.16185.5362.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 17:09 +0200, Guennadi Liakhovetski wrote:
> By placing an anonymous union at the top of struct sh_dmae_slave we can
> transparently prepare all device and client drivers for the upcoming
> shdma-base conversion.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/linux/sh_dma.h |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
> index 425450b..e081e8e 100644
> --- a/include/linux/sh_dma.h
> +++ b/include/linux/sh_dma.h
> @@ -10,12 +10,16 @@
>  #ifndef SH_DMA_H
>  #define SH_DMA_H
>  
> -#include <linux/list.h>
>  #include <linux/dmaengine.h>
> +#include <linux/list.h>
> +#include <linux/shdma-base.h>
>  
>  /* Used by slave DMA clients to request DMA to/from a specific peripheral */
>  struct sh_dmae_slave {
> -	unsigned int			slave_id; /* Set by the platform */
> +	union {
> +		unsigned int		slave_id; /* Set by the platform */
> +		struct shdma_slave	shdma_slave;
again, this should be move to dma_slave_config
> +	};
>  	struct device			*dma_dev; /* Set by the platform */
>  	const struct sh_dmae_slave_config	*config;  /* Set by the driver */
>  };


-- 
~Vinod

