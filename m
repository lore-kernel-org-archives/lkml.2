Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2ASIDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:03:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33622 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab2ASIDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:03:01 -0500
Date: Thu, 19 Jan 2012 16:14:29 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH resent v2 1/2] ioport : add DEFINE_RES_DMA_SIZE_NAMED
 macro
Message-ID: <20120119081427.GF2247@S2101-09.ap.freescale.net>
References: <1326959620-25920-1-git-send-email-b32955@freescale.com>
 <1326959620-25920-2-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326959620-25920-2-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 03:53:39PM +0800, Huang Shijie wrote:
> Some DMA resource does have the range more then ones.
> 
I'm not sure the patch is welcomed.  You may want to just use
DEFINE_RES_NAMED for such cases.

Regards,
Shawn

> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  include/linux/ioport.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 9d57a71..9ea5de4 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -134,8 +134,10 @@ struct resource_list {
>  #define DEFINE_RES_IRQ(_irq)						\
>  	DEFINE_RES_IRQ_NAMED((_irq), NULL)
>  
> +#define DEFINE_RES_DMA_SIZE_NAMED(_dma, _size, _name)			\
> +	DEFINE_RES_NAMED((_dma), (_size), (_name), IORESOURCE_DMA)
>  #define DEFINE_RES_DMA_NAMED(_dma, _name)				\
> -	DEFINE_RES_NAMED((_dma), 1, (_name), IORESOURCE_DMA)
> +	DEFINE_RES_DMA_SIZE_NAMED((_dma), 1, (_name))
>  #define DEFINE_RES_DMA(_dma)						\
>  	DEFINE_RES_DMA_NAMED((_dma), NULL)
>  
> -- 
> 1.7.0.4
