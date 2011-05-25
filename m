Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1EYMrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:47:55 -0400
Received: from mail.tpi.com ([70.99.223.143]:2816 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab1EYMrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:47:53 -0400
Message-ID: <4DDCFA6F.2020801@canonical.com>
Date: Wed, 25 May 2011 06:47:43 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Maxin B John <maxin.john@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        airlied@redhat.com, lethal@linux-sh.org, james@albanarts.com,
        error27@gmail.com, randy.dunlap@oracle.com
Subject: Re: [PATCH] drivers: video: Remove useless checks
References: <20110519182702.GA3337@maxin>
In-Reply-To: <20110519182702.GA3337@maxin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 12:27 PM, Maxin B John wrote:
> Comparing unsigned less than zero will never be true.
> Removing similar checks from 'fbmem.c' and 'fbcmap.c'.
>
> Please let me know your comments.
>
> Signed-off-by: Maxin B. John<maxin.john@gmail.com>
> ---
> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> index 5c3960d..15cf8fc 100644
> --- a/drivers/video/fbcmap.c
> +++ b/drivers/video/fbcmap.c
> @@ -285,8 +285,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>   		rc = -ENODEV;
>   		goto out;
>   	}
> -	if (cmap->start<  0 || (!info->fbops->fb_setcolreg&&
> -				!info->fbops->fb_setcmap)) {
> +	if (!info->fbops->fb_setcolreg&&  !info->fbops->fb_setcmap) {
>   		rc = -EINVAL;
>   		goto out1;
>   	}
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 5aac00e..9edca4d 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1143,7 +1143,7 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>   			return -EFAULT;
>   		if (con2fb.console<  1 || con2fb.console>  MAX_NR_CONSOLES)
>   			return -EINVAL;
> -		if (con2fb.framebuffer<  0 || con2fb.framebuffer>= FB_MAX)
> +		if (con2fb.framebuffer>= FB_MAX)
>   			return -EINVAL;
>   		if (!registered_fb[con2fb.framebuffer])
>   			request_module("fb%d", con2fb.framebuffer);
>

Looks right to me, though there are other places that suffer from the 
same issue. See fb_set_cmap() and its use of 'int start' and cmap->start.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
