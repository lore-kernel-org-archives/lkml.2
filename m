Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1LKXln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 18:41:43 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:54652 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1LKXlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 18:41:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH] [media] uvcvideo: Use kcalloc instead of kzalloc to allocate array
Date: Mon, 12 Dec 2011 00:41:54 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.3; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1322600880.1534.315.camel@localhost.localdomain>
In-Reply-To: <1322600880.1534.315.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112120041.54884.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for the patch.

On Tuesday 29 November 2011 22:08:00 Thomas Meyer wrote:
> The advantage of kcalloc is, that will prevent integer overflows which
> could result from the multiplication of number of elements and size and it
> is also a bit nicer to read.
> 
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Should I take the patch in my tree, or do you plan to push several similar 
patches directly in one go ?

> ---
> 
> diff -u -p a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c ---
> a/drivers/media/video/uvc/uvc_ctrl.c 2011-11-28 19:36:47.613437745 +0100
> +++ b/drivers/media/video/uvc/uvc_ctrl.c 2011-11-28 19:58:26.309317018
> +0100 @@ -1861,7 +1861,7 @@ int uvc_ctrl_init_device(struct uvc_devi
>  		if (ncontrols == 0)
>  			continue;
> 
> -		entity->controls = kzalloc(ncontrols * sizeof(*ctrl),
> +		entity->controls = kcalloc(ncontrols, sizeof(*ctrl),
>  					   GFP_KERNEL);
>  		if (entity->controls == NULL)
>  			return -ENOMEM;

-- 
Regards,

Laurent Pinchart
