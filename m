Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2IQKm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:42:56 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3770 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2IQKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:42:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] media: davinci: vpif: add check for NULL handler
Date: Mon, 17 Sep 2012 12:41:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc5-tschai; KDE/4.8.4; x86_64; ; )
Cc: Prabhakar Lad <prabhakar.lad@ti.com>, LMML <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1345125720-24059-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1345125720-24059-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171241.41203.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu August 16 2012 16:02:00 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

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
> 
