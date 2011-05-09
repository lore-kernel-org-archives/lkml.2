Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab1EIFfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:35:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:4745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab1EIFfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:35:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,338,1301900400"; 
   d="scan'208";a="744280583"
Subject: Re: [PATCH V4 1/5] dmaengine/dw_dmac: don't call callback routine
 in case dmaengine_terminate_all() is called
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com,
        linux-arm-kernel@lists.infradead.org, viresh.linux@gmail.com,
        linux@arm.linux.org.uk
In-Reply-To: <8d1b15be425a70cdbd30725b88bd303cc74e706d.1304596524.git.viresh.kumar@st.com>
References: <cover.1304596524.git.viresh.kumar@st.com>
	 <8d1b15be425a70cdbd30725b88bd303cc74e706d.1304596524.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 10:32:51 +0530
Message-ID: <1304917371.32447.10.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 17:30 +0530, Viresh Kumar wrote:
> If dmaengine_terminate_all() is called for dma channel, then it doesn't make
> much sense to call registered callback routine. While in case of success or
> failure it must be called.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |   31 ++++++++++++++++---------------
>  1 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 1bd4803..d28cd84 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -195,18 +195,21 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
>  /*----------------------------------------------------------------------*/
>  

> -	/*
> -	 * The API requires that no submissions are done from a
> -	 * callback, so we don't need to drop the lock here
> -	 */
> -	if (callback)
> -		callback(param);
> +	if (callback_required) {
> +		if (callback)
> +			callback(param);
> +	}
How about changing this to:
	if (callback_required && callback)
		callback(param)
This will make it look cleaner ...


-- 
~Vinod

