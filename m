Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1EVIGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 04:06:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39906 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1EVIGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 04:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bk3LilcF/dFgXwk40ExN+XRyFQqpwkDVJwXUuVcxKpFJiW+H/shVqXG3nHgXEa06he
         lWuftMkB8WJV56nT69ot9Txk6Bff3UYZVQNgBI697DG20iRIsAYfeAB8F6j+/uAfNMoV
         +VhPO6Xs2gi3zrfAYBvc5ohdB9tSEoZWQrEfs=
MIME-Version: 1.0
In-Reply-To: <20110519182702.GA3337@maxin>
References: <20110519182702.GA3337@maxin>
Date: Sun, 22 May 2011 11:06:12 +0300
Message-ID: <BANLkTikQayxQ5HYyqFwgVSDZgzBmwVO_hA@mail.gmail.com>
Subject: Re: [PATCH] drivers: video: Remove useless checks
From: Maxin B John <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tim.gardner@canonical.com, airlied@redhat.com,
        lethal@linux-sh.org, james@albanarts.com, error27@gmail.com,
        randy.dunlap@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Please let me know your comments on this patch.

Best Regards,
Maxin

On Thu, May 19, 2011 at 9:27 PM, Maxin B John <maxin.john@gmail.com> wrote:
> Comparing unsigned less than zero will never be true.
> Removing similar checks from 'fbmem.c' and 'fbcmap.c'.
>
> Please let me know your comments.
>
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> ---
> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> index 5c3960d..15cf8fc 100644
> --- a/drivers/video/fbcmap.c
> +++ b/drivers/video/fbcmap.c
> @@ -285,8 +285,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>                rc = -ENODEV;
>                goto out;
>        }
> -       if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
> -                               !info->fbops->fb_setcmap)) {
> +       if (!info->fbops->fb_setcolreg && !info->fbops->fb_setcmap) {
>                rc = -EINVAL;
>                goto out1;
>        }
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 5aac00e..9edca4d 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1143,7 +1143,7 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>                        return -EFAULT;
>                if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
>                        return -EINVAL;
> -               if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
> +               if (con2fb.framebuffer >= FB_MAX)
>                        return -EINVAL;
>                if (!registered_fb[con2fb.framebuffer])
>                        request_module("fb%d", con2fb.framebuffer);
>
