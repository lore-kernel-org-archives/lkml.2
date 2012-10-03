Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab2JCGlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:41:49 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3317 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2JCGls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:41:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: davinci: vpbe: fix build warning
Date: Wed, 3 Oct 2012 08:40:53 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc5-tschai; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1349245658-7125-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1349245658-7125-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210030840.53813.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed October 3 2012 08:27:38 Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> recent patch with commit id 4f996594ceaf6c3f9bc42b40c40b0f7f87b79c86
> which makes vidioc_s_crop const, was causing a following build warning,
> 
> vpbe_display.c: In function 'vpbe_display_s_crop':
> vpbe_display.c:640: warning: initialization discards qualifiers from pointer target type
> 
> This patch fixes the above build warning.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Prabhaker, can you make a pull request for this patch, the "CUSTOM_TIMINGS"
rename patch and the earlier "vpfe: fix build error" patch? These things
should be fast-tracked.

Regards,

	Hans

> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/platform/davinci/vpbe_display.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 1b238fe..161c776 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -637,7 +637,7 @@ static int vpbe_display_s_crop(struct file *file, void *priv,
>  	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
>  	struct osd_layer_config *cfg = &layer->layer_info.config;
>  	struct osd_state *osd_device = disp_dev->osd_device;
> -	struct v4l2_rect *rect = &crop->c;
> +	struct v4l2_rect rect = crop->c;
>  	int ret;
>  
>  	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> @@ -648,21 +648,21 @@ static int vpbe_display_s_crop(struct file *file, void *priv,
>  		return -EINVAL;
>  	}
>  
> -	if (rect->top < 0)
> -		rect->top = 0;
> -	if (rect->left < 0)
> -		rect->left = 0;
> +	if (rect.top < 0)
> +		rect.top = 0;
> +	if (rect.left < 0)
> +		rect.left = 0;
>  
> -	vpbe_disp_check_window_params(disp_dev, rect);
> +	vpbe_disp_check_window_params(disp_dev, &rect);
>  
>  	osd_device->ops.get_layer_config(osd_device,
>  			layer->layer_info.id, cfg);
>  
>  	vpbe_disp_calculate_scale_factor(disp_dev, layer,
> -					rect->width,
> -					rect->height);
> -	vpbe_disp_adj_position(disp_dev, layer, rect->top,
> -					rect->left);
> +					rect.width,
> +					rect.height);
> +	vpbe_disp_adj_position(disp_dev, layer, rect.top,
> +					rect.left);
>  	ret = osd_device->ops.set_layer_config(osd_device,
>  				layer->layer_info.id, cfg);
>  	if (ret < 0) {
> 
