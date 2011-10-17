Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1JQMxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:53:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1JQMxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:53:10 -0400
Date: Mon, 17 Oct 2011 14:52:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 04/10] media-video: move to dma_transfer_direction
In-Reply-To: <1318570705-17595-5-git-send-email-vinod.koul@intel.com>
Message-ID: <Pine.LNX.4.64.1110171019470.18438@axis700.grange>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318570705-17595-5-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:pGtFhgDwTNOJOy04O4DSrAFnH4LTtrpEmXjuJUiMgA9
 2Fp3hjwqrNGMmjxfqSxUcLpptBb2G5nM66W4Y40Ojoga9hhF57
 TZkZClSQBvnWo5Y8J8lHs12XRu+yHB8D+xlCZeZSpw5jJ+WE/Y
 QY+xNwvz6gPqmRFCX+Jdz+yPfNzJ//+T+hXfv579ufDzD9oHFN
 Mb8q56ce1U+He52vyN2RT/e5glPwrwl4GpBliTnguIW6ljRKfK
 yZ3UUsqzFOg2oxo+Q7QXMNPMuIK+hiGpU9eVG0uDqiWh7+8sM8
 esq4Ds9cq2LAT2cHfudOpdM3QxSwLEMzDoofVcBauzal/CiBcn
 WqHc1NvcBo9JTBO1ezE3nlEV2d4N5BlO5zMdh1LQQ1H9YyFSaS
 Ja+L8jTACDvQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is not purely media/video:

On Fri, 14 Oct 2011, Vinod Koul wrote:

> From: Vinod Koul <vinod.koul@linux.intel.com>
> 
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/video/mx3_camera.c |    2 +-
>  drivers/media/video/timblogiw.c  |    2 +-
>  drivers/video/mx3fb.c            |    4 ++--

This is a framebuffer driver, as such it has nothing to do with the media 
/ v4l subsystem, it just happens to use the same dmaengine driver, as 
mx3_camera. Not sure if you want to split this patch, or at least adjust 
its description.

As for the contents: for mx3_camera and mx3fb:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index c045b47..b6ac932 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -251,7 +251,7 @@ static int mx3_videobuf_prepare(struct vb2_buffer *vb)
>  		sg_dma_len(sg)		= new_size;
>  
>  		buf->txd = ichan->dma_chan.device->device_prep_slave_sg(
> -			&ichan->dma_chan, sg, 1, DMA_FROM_DEVICE,
> +			&ichan->dma_chan, sg, 1, DEV_TO_MEM,
>  			DMA_PREP_INTERRUPT);
>  		if (!buf->txd)
>  			return -EIO;
> diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
> index 84cd1b6..1940d47 100644
> --- a/drivers/media/video/timblogiw.c
> +++ b/drivers/media/video/timblogiw.c
> @@ -564,7 +564,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
>  	spin_unlock_irq(&fh->queue_lock);
>  
>  	desc = fh->chan->device->device_prep_slave_sg(fh->chan,
> -		buf->sg, sg_elems, DMA_FROM_DEVICE,
> +		buf->sg, sg_elems, DEV_TO_MEM,
>  		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
>  	if (!desc) {
>  		spin_lock_irq(&fh->queue_lock);
> diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
> index 7e3a490..7b0232f 100644
> --- a/drivers/video/mx3fb.c
> +++ b/drivers/video/mx3fb.c
> @@ -334,7 +334,7 @@ static void sdc_enable_channel(struct mx3fb_info *mx3_fbi)
>  	/* This enables the channel */
>  	if (mx3_fbi->cookie < 0) {
>  		mx3_fbi->txd = dma_chan->device->device_prep_slave_sg(dma_chan,
> -		      &mx3_fbi->sg[0], 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
> +		      &mx3_fbi->sg[0], 1, MEM_TO_DEV, DMA_PREP_INTERRUPT);
>  		if (!mx3_fbi->txd) {
>  			dev_err(mx3fb->dev, "Cannot allocate descriptor on %d\n",
>  				dma_chan->chan_id);
> @@ -1104,7 +1104,7 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
>  		async_tx_ack(mx3_fbi->txd);
>  
>  	txd = dma_chan->device->device_prep_slave_sg(dma_chan, sg +
> -		mx3_fbi->cur_ipu_buf, 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
> +		mx3_fbi->cur_ipu_buf, 1, MEM_TO_DEV, DMA_PREP_INTERRUPT);
>  	if (!txd) {
>  		dev_err(fbi->device,
>  			"Error preparing a DMA transaction descriptor.\n");
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
