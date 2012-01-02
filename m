Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2ABLNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:13:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:42193 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2ABLNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:13:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="93550618"
Subject: Re: [PATCH] dmaengine/ste_dma40: clear LNK on channel startup
From: Vinod Koul <vinod.koul@intel.com>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Rabin Vincent <rabin.vincent@stericsson.com>
In-Reply-To: <1325051860-12372-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
References: <1325051860-12372-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 16:43:57 +0530
Message-ID: <1325502837.1540.14.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-28 at 11:27 +0530, Narayanan G wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> Otherwise if a previously physical channel is used as a logical channel, the
> LNK may have old values which affect the operation of the logical channel since
> the LNK register has different semantics between physical and logical channels.
> 
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
> ---
>  drivers/dma/ste_dma40.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 972dc35..cc5ecbc
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -1104,6 +1104,10 @@ static void d40_config_write(struct d40_chan *d40c)
>  		/* Set LIDX for lcla */
>  		writel(lidx, chanbase + D40_CHAN_REG_SSELT);
>  		writel(lidx, chanbase + D40_CHAN_REG_SDELT);
> +
> +		/* Clear LNK which will be used by d40_chan_has_events() */
> +		writel(0, chanbase + D40_CHAN_REG_SSLNK);
> +		writel(0, chanbase + D40_CHAN_REG_SDLNK);
>  	}
>  }
>  
Applied, Thanks

-- 
~Vinod

