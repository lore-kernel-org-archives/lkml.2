Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2HWUJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:09:03 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:44829 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479Ab2HWUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:09:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120822234944.GS19212@google.com>
References: <20120822234944.GS19212@google.com>
Date: Thu, 23 Aug 2012 15:08:59 -0500
Message-ID: <CAO8GWqmBakf9gLmFh7q3DWWkAzSiUoa09F2dP8MJ2B5E_66fRA@mail.gmail.com>
Subject: Re: [PATCH] omapdrm: use alloc_ordered_workqueue() instead of UNBOUND
 w/ max_active = 1
From: "Clark, Rob" <rob@ti.com>
To: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 6:49 PM, Tejun Heo <tj@kernel.org> wrote:
> This is an equivalent conversion and will ease scheduled removal of
> WQ_NON_REENTRANT.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

I've tested it

Signed-off-by: Rob Clark <rob@ti.com>

> ---
>  drivers/staging/omapdrm/omap_drv.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/omapdrm/omap_drv.c b/drivers/staging/omapdrm/omap_drv.c
> index 4beab94..672cb3a 100644
> --- a/drivers/staging/omapdrm/omap_drv.c
> +++ b/drivers/staging/omapdrm/omap_drv.c
> @@ -571,8 +571,7 @@ static int dev_load(struct drm_device *dev, unsigned long flags)
>
>         dev->dev_private = priv;
>
> -       priv->wq = alloc_workqueue("omapdrm",
> -                       WQ_UNBOUND | WQ_NON_REENTRANT, 1);
> +       priv->wq = alloc_ordered_workqueue("omapdrm", 0);
>
>         INIT_LIST_HEAD(&priv->obj_list);
>
