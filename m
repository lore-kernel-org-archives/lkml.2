Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2FCM0E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 08:26:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61162 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2FCM0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 08:26:01 -0400
MIME-Version: 1.0
In-Reply-To: <1338720077-14936-1-git-send-email-corone.il.han@gmail.com>
References: <1338720077-14936-1-git-send-email-corone.il.han@gmail.com>
Date: Sun, 3 Jun 2012 20:26:00 +0800
Message-ID: <CAO6yer+0zUNFVGW8wO2mdSQodzzaw2WsRQHVmUAs1Xr_FHXx3Q@mail.gmail.com>
Subject: Re: [PATCH] drm: An uninitialized return value is returned.
From: bing deng <deng8bing@gmail.com>
To: Il Han <corone.il.han@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 6:41 PM, Il Han <corone.il.han@gmail.com> wrote:
> An uninitialized return value is returned.
> If the value is not necessary,
> it would be better to return the constant 0.
>
> Signed-off-by: Il Han <corone.il.han@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/nv04_fence.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nv04_fence.c b/drivers/gpu/drm/nouveau/nv04_fence.c
> index abe89db..d4091eb 100644
> --- a/drivers/gpu/drm/nouveau/nv04_fence.c
> +++ b/drivers/gpu/drm/nouveau/nv04_fence.c
> @@ -121,7 +121,6 @@ nv04_fence_create(struct drm_device *dev)
>  {
>        struct drm_nouveau_private *dev_priv = dev->dev_private;
>        struct nv04_fence_priv *priv;
> -       int ret;
>
>        priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>        if (!priv)
> @@ -136,5 +135,5 @@ nv04_fence_create(struct drm_device *dev)
>        priv->base.sync = nv04_fence_sync;
>        priv->base.read = nv04_fence_read;
>        dev_priv->eng[NVOBJ_ENGINE_FENCE] = &priv->base.engine;
> -       return ret;
> +       return 0;
>  }
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Hi All,

    Why not modify "int ret;" to "int ret = 0;"? Below is the benefit:
    1. return the constant 0 as wish.
    2. The variable ret can be used if we want.
-- 
Best Regards,
Bing
