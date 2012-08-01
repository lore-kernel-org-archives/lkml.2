Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab2HAR0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:26:04 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:36105 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2HAR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:26:00 -0400
Date: Wed, 1 Aug 2012 10:25:57 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: qiang.liu@freescale.com
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, dan.j.williams@gmail.com,
        Vinod Koul <vinod.koul@intel.com>, herbert@gondor.hengli.com.au,
        Dan Williams <dan.j.williams@intel.com>, davem@davemloft.net
Subject: Re: [PATCH v5 6/6] fsl-dma: fix a warning of unitialized cookie
Message-ID: <20120801172557.GE11359@ovro.caltech.edu>
References: <1343811027-25516-1-git-send-email-qiang.liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343811027-25516-1-git-send-email-qiang.liu@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (ovro.ovro.caltech.edu); Wed, 01 Aug 2012 10:25:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 04:50:27PM +0800, qiang.liu@freescale.com wrote:
> From: Qiang Liu <qiang.liu@freescale.com>
> 
> Fix a warning of unitialized value when compile with -Wuninitialized.
> 

Looks good to me.

Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>

> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Li Yang <leoli@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> Reported-by: Kim Phillips <kim.phillips@freescale.com>
> ---
>  drivers/dma/fsldma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index e3814aa..6fc22eb 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -645,7 +645,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>  	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
>  	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
>  	struct fsl_desc_sw *child;
> -	dma_cookie_t cookie;
> +	dma_cookie_t cookie = 0;
> 
>  	spin_lock_bh(&chan->desc_lock);
> 
> --
> 1.7.5.1
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
