Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1FXIwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 04:52:07 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46441 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1FXIwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 04:52:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH 12/37] Remove unneeded version.h includes (and add where needed) for drivers/media/video/
Date: Fri, 24 Jun 2011 10:52:00 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        ivtv-devel@ivtvdriver.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Luca Risolia <luca.risolia@studio.unibo.it>,
        Olivier Lorin <o.lorin@laposte.net>,
        "Jean-Francois Moine" <moinejf@free.fr>,
        Huang Shijie <shijie8@gmail.com>, Kang Yong <kangyong@telegent.com>,
        Zhang Xiaobing <xbzhang@telegent.com>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <alpine.LNX.2.00.1106240014220.17688@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1106240014220.17688@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106241052.02244.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Friday 24 June 2011 00:17:01 Jesper Juhl wrote:
> It was pointed out by 'make versioncheck' that linux/version.h was not
> always being included where needed and sometimes included needlessly
> in drivers/media/video/.
> This patch fixes up the includes.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

[snip]

> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 543a803..7fbd389 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -12,7 +12,6 @@
>   */
> 
>  #include <linux/kernel.h>
> -#include <linux/version.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>

uvc_v4l2.c uses KERNEL_VERSION explicitly. It includes linux/version.h through 
linux/media.h, but I'd rather keep the explicit include.

> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index 20107fd..1c0fe5e 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -101,6 +101,7 @@ struct uvc_xu_control {
>  #include <linux/usb.h>
>  #include <linux/usb/video.h>
>  #include <linux/uvcvideo.h>
> +#include <linux/version.h>
>  #include <media/media-device.h>
>  #include <media/v4l2-device.h>

This file doesn't include linux/version.h anymore in 3.0-rc4.

-- 
Regards,

Laurent Pinchart
