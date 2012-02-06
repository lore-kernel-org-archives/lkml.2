Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2BFCcE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 21:32:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:45264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab2BFCcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 21:32:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="106717803"
Subject: Re: [PATCH 6/7 v2] ASoC: SIU: prepare for conversion to simple DMA
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1327589784-4287-7-git-send-email-g.liakhovetski@gmx.de>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
	 <1327589784-4287-7-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 08:03:45 +0530
Message-ID: <1328495625.26182.55.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 15:56 +0100, Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  sound/soc/sh/siu_pcm.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
> index 0193e59..414bb35 100644
> --- a/sound/soc/sh/siu_pcm.c
> +++ b/sound/soc/sh/siu_pcm.c
> @@ -330,12 +330,12 @@ static bool filter(struct dma_chan *chan, void *slave)
>  {
>  	struct sh_dmae_slave *param = slave;
>  
> -	pr_debug("%s: slave ID %d\n", __func__, param->slave_id);
> +	pr_debug("%s: slave ID %d\n", __func__, param->simple_slave.slave_id);
>  
>  	if (unlikely(param->dma_dev != chan->device->dev))
>  		return false;
>  
> -	chan->private = param;
> +	chan->private = &param->simple_slave;
While at it, Can you fix the sh-mobile driver to NOT use chan->private?
>  	return true;
>  }
>  
> @@ -360,12 +360,12 @@ static int siu_pcm_open(struct snd_pcm_substream *ss)
>  	if (ss->stream == SNDRV_PCM_STREAM_PLAYBACK) {
>  		siu_stream = &port_info->playback;
>  		param = &siu_stream->param;
> -		param->slave_id = port ? pdata->dma_slave_tx_b :
> +		param->simple_slave.slave_id = port ? pdata->dma_slave_tx_b :
>  			pdata->dma_slave_tx_a;
>  	} else {
>  		siu_stream = &port_info->capture;
>  		param = &siu_stream->param;
> -		param->slave_id = port ? pdata->dma_slave_rx_b :
> +		param->simple_slave.slave_id = port ? pdata->dma_slave_rx_b :
>  			pdata->dma_slave_rx_a;
>  	}
>  


-- 
~Vinod

