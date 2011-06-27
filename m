Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1F0BOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 21:14:11 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35101 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab1F0BOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 21:14:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 11/14] [media] uvcvideo: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
Date: Mon, 27 Jun 2011 03:14:10 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.4; x86_64; ; )
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <cover.1309103285.git.mchehab@redhat.com> <20110626130616.0d91dca7@pedra>
In-Reply-To: <20110626130616.0d91dca7@pedra>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106270314.11202.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Sunday 26 June 2011 18:06:16 Mauro Carvalho Chehab wrote:
> uvcvideo doesn't use vidioc_ioctl2. As the API is changing to use
> a common version for all drivers, we need to expliticly fix this
> driver.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index b6eae48..749c722 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -31,6 +31,7 @@
>  #include <linux/videodev2.h>
>  #include <linux/vmalloc.h>
>  #include <linux/wait.h>
> +#include <linux/version.h>
>  #include <asm/atomic.h>
>  #include <asm/unaligned.h>
> 
> @@ -1857,7 +1858,7 @@ static int uvc_probe(struct usb_interface *intf,
>  			sizeof(dev->mdev.serial));
>  	strcpy(dev->mdev.bus_info, udev->devpath);
>  	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
> -	dev->mdev.driver_version = DRIVER_VERSION_NUMBER;
> +	dev->mdev.driver_version = LINUX_VERSION_CODE;

If we report the kernel version number through the media controller API as 
well, this needs to be documented. In that case media_version should report 
the kernel version as well, and driver_version would become deprecated.

>  	if (media_device_register(&dev->mdev) < 0)
>  		goto error;
> 
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 1fe2c8f..7f77528 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -571,7 +571,7 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) strlcpy(cap->card, vdev->name, sizeof
> cap->card);
>  		usb_make_path(stream->dev->udev,
>  			      cap->bus_info, sizeof(cap->bus_info));
> -		cap->version = DRIVER_VERSION_NUMBER;
> +		cap->version = LINUX_VERSION_CODE;
>  		if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  			cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
> 
>  					  | V4L2_CAP_STREAMING;
> 
> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index 20107fd..df32a43 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -183,8 +183,7 @@ struct uvc_xu_control {
>   * Driver specific constants.
>   */
> 
> -#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(1, 1, 0)
> -#define DRIVER_VERSION		"v1.1.0"
> +#define DRIVER_VERSION		"1.1.1"

Why do you remove the 'v' ?

>  /* Number of isochronous URBs. */
>  #define UVC_URBS		5

-- 
Regards,

Laurent Pinchart
