Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab1CBSkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:40:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:61127 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1CBSko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:40:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,254,1297065600"; 
   d="scan'208";a="893070742"
Subject: Re: [PATCH 4/8 resend] dw_dmac: calling dwc_scan_descriptors from
 dwc_tx_status() after taking lock
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shiraz.hashim@st.com, amit.goel@st.com, armando.visconti@st.com
In-Reply-To: <725d9e629bce9f79d87bdab4596a5088b70ea416.1298889267.git.viresh.kumar@st.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
	 <725d9e629bce9f79d87bdab4596a5088b70ea416.1298889267.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 23:43:53 +0530
Message-ID: <1299089633.6974.93.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 16:11 +0530, Viresh Kumar wrote:
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 3bf4772..5cc5abf 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -830,7 +830,9 @@ dwc_tx_status(struct dma_chan *chan,
>  
>  	ret = dma_async_is_complete(cookie, last_complete, last_used);
>  	if (ret != DMA_SUCCESS) {
> +		spin_lock_bh(&dwc->lock);
>  		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
> +		spin_unlock_bh(&dwc->lock);
>  
>  		last_complete = dwc->completed;
>  		last_used = chan->cookie;

Please always add a short description in the patch, helps in long run

Shouldnt you be doing this for dwc_handle_error() as well? I see thats
called without taking the lock....

-- 
~Vinod

