Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162529Ab1FAJGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:06:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:17735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161981Ab1FAIQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:16:39 -0400
X-ExtLoop1: 1
Subject: Re: [PATCH 1/3] dmaengine: add new dma API for max_segment_number
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Shawn Guo <shawn.guo@linaro.org>, dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
In-Reply-To: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
References: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 13:12:24 +0530
Message-ID: <1306914144.10976.4.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 14:31 +0800, Shawn Guo wrote:
> Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
> max_segment_number into device_dma_parameters and creates the
> corresponding dmaengine API dma_set(get)_max_seg_number for it.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  include/linux/device.h      |    1 +
>  include/linux/dma-mapping.h |   15 +++++++++++++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
Can you explain me why this change is required, the patch description
isn't helping for this.

If you satisfy me with above then I am okay with it, but I need ACK from
Dan before applying...

~Vinod

> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index c66111a..44cb2528 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -487,6 +487,7 @@ struct device_dma_parameters {
>  	 * sg limitations.
>  	 */
>  	unsigned int max_segment_size;
> +	unsigned int max_segment_number;
>  	unsigned long segment_boundary_mask;
>  };
>  
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index ba8319a..fd314f4 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -131,6 +131,21 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
>  		return -EIO;
>  }
>  
> +static inline unsigned int dma_get_max_seg_number(struct device *dev)
> +{
> +	return dev->dma_parms ? dev->dma_parms->max_segment_number : 1;
> +}
> +
> +static inline unsigned int dma_set_max_seg_number(struct device *dev,
> +						  unsigned int number)
> +{
> +	if (dev->dma_parms) {
> +		dev->dma_parms->max_segment_number = number;
> +		return 0;
> +	} else
> +		return -EIO;
> +}
> +
>  static inline unsigned long dma_get_seg_boundary(struct device *dev)
>  {
>  	return dev->dma_parms ?



