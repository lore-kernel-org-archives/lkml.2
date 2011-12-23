Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1LWQHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:07:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:37815 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab1LWQG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:06:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="50125717"
Subject: Re: [PATCH 5/5] ASoC: mxs: correct 'direction' of
 device_prep_dma_cyclic
From: Vinod Koul <vinod.koul@intel.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Dong Aisheng <dong.aisheng@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
	 <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 21:37:00 +0530
Message-ID: <1324656420.1633.15.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 15:47 +0800, Shawn Guo wrote:
> The commit 49920bc (dmaengine: add new enum dma_transfer_direction)
> changes the type of parameter 'direction' of device_prep_dma_cyclic
> from dma_data_direction to dma_transfer_direction.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  sound/soc/mxs/mxs-pcm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/mxs/mxs-pcm.c b/sound/soc/mxs/mxs-pcm.c
> index 0e12f4e..105f42a 100644
> --- a/sound/soc/mxs/mxs-pcm.c
> +++ b/sound/soc/mxs/mxs-pcm.c
> @@ -136,7 +136,7 @@ static int snd_mxs_pcm_hw_params(struct snd_pcm_substream *substream,
>  			iprtd->period_bytes * iprtd->periods,
>  			iprtd->period_bytes,
>  			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
> -			DMA_TO_DEVICE : DMA_FROM_DEVICE);
> +			DMA_MEM_TO_DEV : DMA_DEV_TO_MEM);
>  	if (!iprtd->desc) {
>  		dev_err(&chan->dev->device, "cannot prepare slave dma\n");
>  		return -EINVAL;

Has this been applied in soc tree? I don't see it in linux-next or do
you want this to go thru slave-dma?

-- 
~Vinod

