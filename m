Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0JaXw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 19:52:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61375 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab0JaXwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 19:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=M2I6XKdTn/mHcnyPXThtXIh+q8Ve63sbLNHxM9nUSSVN7desrhGYGqv4l8tj+TfFVR
         ki9U+Fy7c4NvPmmcNK4UzRTDQypA6nfSxDnDByGRU2NTY7MoRhyzkFoWwe7Z9TZQMF4q
         laubUGWwVre83uVqlhl7B4BpuDehWiMwPfgy4=
MIME-Version: 1.0
In-Reply-To: <1bb253bedd9345e3457ce699f9fbc6f65844738f.1288555098.git.joe@perches.com>
References: <cover.1288555098.git.joe@perches.com> <1bb253bedd9345e3457ce699f9fbc6f65844738f.1288555098.git.joe@perches.com>
From: Matt Turner <mattst88@gmail.com>
Date: Sun, 31 Oct 2010 19:52:02 -0400
Message-ID: <AANLkTinYZ=ZpkRiL2eMtcO_fAAFhBBCoT2fLH0tKaNn9@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers/gpu/drm/vmwgfx: Fix k.alloc switched arguments
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 6:33 PM, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c     |    2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
> index a01c47d..29113c9 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
> @@ -557,7 +557,7 @@ int vmw_kms_init_legacy_display_system(struct vmw_private *dev_priv)
>                return -EINVAL;
>        }
>
> -       dev_priv->ldu_priv = kmalloc(GFP_KERNEL, sizeof(*dev_priv->ldu_priv));
> +       dev_priv->ldu_priv = kmalloc(sizeof(*dev_priv->ldu_priv), GFP_KERNEL);
>
>        if (!dev_priv->ldu_priv)
>                return -ENOMEM;
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
> index df2036e..f1a52f9 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
> @@ -585,7 +585,7 @@ int vmw_overlay_init(struct vmw_private *dev_priv)
>                return -ENOSYS;
>        }
>
> -       overlay = kmalloc(GFP_KERNEL, sizeof(*overlay));
> +       overlay = kmalloc(sizeof(*overlay), GFP_KERNEL);
>        if (!overlay)
>                return -ENOMEM;
>
> --
> 1.7.3.1.g432b3.dirty

Oh! That's a bad one.

Reviewed-by: Matt Turner <mattst88@gmail.com>
