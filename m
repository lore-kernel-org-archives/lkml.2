Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161031Ab1FAC3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:29:04 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:46852 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933152Ab1FAC3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:29:02 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 1 Jun 2011 10:33:57 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dan.j.williams@intel.com>, <patches@linaro.org>
Subject: Re: [PATCH 1/3] dmaengine: add new dma API for max_segment_number
Message-ID: <20110601023356.GA1501@S2100-06.ap.freescale.net>
References: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

Thoughts?

-- 
Regards,
Shawn

On Thu, May 26, 2011 at 02:31:31PM +0800, Shawn Guo wrote:
> Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
> max_segment_number into device_dma_parameters and creates the
> corresponding dmaengine API dma_set(get)_max_seg_number for it.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  include/linux/device.h      |    1 +
>  include/linux/dma-mapping.h |   15 +++++++++++++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
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
> -- 
> 1.7.4.1

