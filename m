Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0ESWHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:07:45 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:58034 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0ESWHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:07:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 16/37] drivers/media/video/uvc: Use kmemdup
Date: Thu, 20 May 2010 00:09:18 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33; KDE/4.4.3; x86_64; ; )
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1005152317410.21345@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005152317410.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005200009.19916.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

Thanks for the patch.

On Saturday 15 May 2010 23:17:59 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use kmemdup when some other buffer is immediately copied into the
> allocated region.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression from,to,size,flag;
> statement S;
> @@
> 
> -  to = \(kmalloc\|kzalloc\)(size,flag);
> +  to = kmemdup(from,size,flag);
>    if (to==NULL || ...) S
> -  memcpy(to, from, size);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/media/video/uvc/uvc_driver.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff -u -p a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c ---
> a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -637,14 +637,13 @@ static int uvc_parse_streaming(struct uv
>  	}
>  	streaming->header.bControlSize = n;
> 
> -	streaming->header.bmaControls = kmalloc(p*n, GFP_KERNEL);
> +	streaming->header.bmaControls = kmemdup(&buffer[size], p * n,

I'm puzzled, how did the above semantic patch transform 'p*n' into 'p * n' ? 
As a side note, keeping 'p*n' would have allowed the statement to fit in one 
line :-)

> +						GFP_KERNEL);
>  	if (streaming->header.bmaControls == NULL) {
>  		ret = -ENOMEM;
>  		goto error;
>  	}
> 
> -	memcpy(streaming->header.bmaControls, &buffer[size], p*n);
> -
>  	buflen -= buffer[0];
>  	buffer += buffer[0];

-- 
Regards,

Laurent Pinchart
