Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2KVTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:25:28 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:44763 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab2KVTZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:25:24 -0500
Message-ID: <50ADDDD5.1080709@bfs.de>
Date: Thu, 22 Nov 2012 09:09:57 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Cyril Roelandt <tipecaml@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com,
        laurent.pinchart@ideasonboard.com, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] UVC: use GFP_ATOMIC under spin lock.
References: <1353360842-18384-1-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1353360842-18384-1-git-send-email-tipecaml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 19.11.2012 22:34, schrieb Cyril Roelandt:
> Found using the following semantic patch:
> <spml>
> @@
> @@
> spin_lock_irqsave(...);
> ... when != spin_unlock_irqrestore(...);
> * GFP_KERNEL
> </spml>
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/usb/gadget/uvc_video.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/uvc_video.c b/drivers/usb/gadget/uvc_video.c
> index b0e53a8..79b4132 100644
> --- a/drivers/usb/gadget/uvc_video.c
> +++ b/drivers/usb/gadget/uvc_video.c
> @@ -309,7 +309,7 @@ uvc_video_pump(struct uvc_video *video)
>  		video->encode(req, video, buf);
>  
>  		/* Queue the USB request */
> -		if ((ret = usb_ep_queue(video->ep, req, GFP_KERNEL)) < 0) {
> +		if ((ret = usb_ep_queue(video->ep, req, GFP_ATOMIC)) < 0) {
>  			printk(KERN_INFO "Failed to queue request (%d)\n", ret);
>  			usb_ep_set_halt(video->ep);
>  			spin_unlock_irqrestore(&video->queue.irqlock, flags);


IMHO, this should be two lines, aka:

ret = usb_ep_queue(video->ep, req, GFP_KERNEL);
if (ret<0)

just my two cents,

re,
 wh
