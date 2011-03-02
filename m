Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab1CBTBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:01:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:24080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab1CBTBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:01:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,254,1297065600"; 
   d="scan'208";a="396498363"
Subject: Re: [PATCH 6/8 resend] dw_dmac: Mark all tx_descriptors with
 DMA_CRTL_ACK after xfer finish
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linus.walleij@stericsson.com, amit.goel@st.com,
        linux-kernel@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <82027aa0c6446df3f7fb8e3c5fbdc28f60ea33b7.1298889267.git.viresh.kumar@st.com>
References: <cover.1298889267.git.viresh.kumar@st.com>
	 <82027aa0c6446df3f7fb8e3c5fbdc28f60ea33b7.1298889267.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 00:04:15 +0530
Message-ID: <1299090855.6974.94.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 16:11 +0530, Viresh Kumar wrote:
> dwc_desc_get checks all descriptors for DMA_CTRL_ACK before allocating them for
> transfers. And descriptors are not marked with DMA_CRTL_ACK after transfer
> finishes. Thus descriptor once used is not usable again. This patch marks
> descriptors with DMA_CRTL_ACK after dma xfer finishes
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index c40b89f..01f783d 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -196,6 +196,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
>  	dma_async_tx_callback		callback;
>  	void				*param;
>  	struct dma_async_tx_descriptor	*txd = &desc->txd;
> +	struct dw_desc	*child;
Please align this with previous ones....

-- 
~Vinod

