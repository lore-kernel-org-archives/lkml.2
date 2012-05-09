Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2EII4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:56:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:34088 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758796Ab2EII4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:56:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98012850"
Subject: Re: [PATCH V2 1/2] dma: dmaengine: add slave req id in slave_config
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: dan.j.williams@intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org
In-Reply-To: <1336030889-32269-2-git-send-email-ldewangan@nvidia.com>
References: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>
	 <1336030889-32269-2-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 May 2012 14:19:18 +0530
Message-ID: <1336553358.1540.169.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 13:11 +0530, Laxman Dewangan wrote:
> The dma controller like Nvidia's Tegra Dma controller
> supports the different slave requestor id from different slave.
> This need to be configure in dma controller to handle the request
> properly.
> 
> Adding the slave-id in the slave configuration so that information
> can be passed from client when configuring for slave.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> 
> This change is require to get rid of tegra_dma header to pass the
> slave requestor id.
> 
>  include/linux/dmaengine.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 1082698..b0b275f 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -338,6 +338,9 @@ enum dma_slave_buswidth {
>   * @device_fc: Flow Controller Settings. Only valid for slave channels. Fill
>   * with 'true' if peripheral should be flow controller. Direction will be
>   * selected at Runtime.
> + * @slave_id: Slave requester id. Only valid for slave channels. The dma
> + * slave peripheral will have unique id as dma requester which need to be
> + * pass as slave config.
>   *
>   * This struct is passed in as configuration data to a DMA engine
>   * in order to set up a certain channel for DMA transport at runtime.
> @@ -365,6 +368,7 @@ struct dma_slave_config {
>  	u32 src_maxburst;
>  	u32 dst_maxburst;
>  	bool device_fc;
> +	int slave_id;
This wont be negative, so perhaps an unsigned value?
>  };
>  
>  static inline const char *dma_chan_name(struct dma_chan *chan)


-- 
~Vinod

