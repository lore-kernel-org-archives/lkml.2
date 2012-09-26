Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab2IZUHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:07:47 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33395
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493Ab2IZUHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:07:46 -0400
Date: Wed, 26 Sep 2012 17:07:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] media: davinci: vpif: add check for NULL handler
Message-ID: <20120926170737.5979b1e8@infradead.org>
In-Reply-To: <1345125720-24059-1-git-send-email-prabhakar.lad@ti.com>
References: <1345125720-24059-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 16 Aug 2012 19:32:00 +0530
Prabhakar Lad <prabhakar.lad@ti.com> escreveu:

It is amazing how many SOB's/acks are in this patch and nobody
asked you to provide a patch description... the subject just
tells what the code is also telling. Could you please provide
a better patch description?

Thanks!
Mauro

> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/davinci/vpif_capture.c |   12 +++++++-----
>  drivers/media/video/davinci/vpif_display.c |   14 ++++++++------
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
> index 266025e..a87b7a5 100644
> --- a/drivers/media/video/davinci/vpif_capture.c
> +++ b/drivers/media/video/davinci/vpif_capture.c
> @@ -311,12 +311,14 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	}
>  
>  	/* configure 1 or 2 channel mode */
> -	ret = vpif_config_data->setup_input_channel_mode
> -					(vpif->std_info.ycmux_mode);
> +	if (vpif_config_data->setup_input_channel_mode) {
> +		ret = vpif_config_data->setup_input_channel_mode
> +						(vpif->std_info.ycmux_mode);
>  
> -	if (ret < 0) {
> -		vpif_dbg(1, debug, "can't set vpif channel mode\n");
> -		return ret;
> +		if (ret < 0) {
> +			vpif_dbg(1, debug, "can't set vpif channel mode\n");
> +			return ret;
> +		}
>  	}
>  
>  	/* Call vpif_set_params function to set the parameters and addresses */
> diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
> index e129c98..1e35f92 100644
> --- a/drivers/media/video/davinci/vpif_display.c
> +++ b/drivers/media/video/davinci/vpif_display.c
> @@ -280,12 +280,14 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	}
>  
>  	/* clock settings */
> -	ret =
> -	    vpif_config_data->set_clock(ch->vpifparams.std_info.ycmux_mode,
> -					ch->vpifparams.std_info.hd_sd);
> -	if (ret < 0) {
> -		vpif_err("can't set clock\n");
> -		return ret;
> +	if (vpif_config_data->set_clock) {
> +		ret =
> +		vpif_config_data->set_clock(ch->vpifparams.std_info.ycmux_mode,
> +						ch->vpifparams.std_info.hd_sd);
> +		if (ret < 0) {
> +			vpif_err("can't set clock\n");
> +			return ret;
> +		}
>  	}
>  
>  	/* set the parameters and addresses */




Cheers,
Mauro
