Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab2G2F4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 01:56:53 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:48552 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2G2F4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 01:56:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stefan Muenzel <stefanmuenzel@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [media] uvcvideo: Add 10,12bit and alternate 8bit greyscale
Date: Sun, 29 Jul 2012 07:56:56 +0200
Message-ID: <1537901.D4de3zSszL@avalon>
User-Agent: KMail/4.8.3 (Linux/3.3.8-gentoo; KDE/4.8.3; x86_64; ; )
In-Reply-To: <1343515754-1043-1-git-send-email-stefanmuenzel@googlemail.com>
References: <1343515754-1043-1-git-send-email-stefanmuenzel@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Thanks for the patch.

On Saturday 28 July 2012 18:49:14 Stefan Muenzel wrote:
> Some cameras support 10bit and 12bit greyscale, or use the alternate "Y8
> " FOURCC for 8bit greyscale. Add support for these.

Could you please tell me which camera(s) use those formats ?

> Tested on a 12bit camera.
> 
> Signed-off-by: Stefan Muenzel <stefanmuenzel@googlemail.com>
> ---
>  drivers/media/video/uvc/uvc_driver.c |   19 +++++++++++++++++--
>  drivers/media/video/uvc/uvcvideo.h   |    9 +++++++++
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index 1d13172..11db262 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -95,12 +95,27 @@ static struct uvc_format_desc uvc_fmts[] = {
>  		.fcc		= V4L2_PIX_FMT_UYVY,
>  	},
>  	{
> -		.name		= "Greyscale (8-bit)",
> +		.name		= "Greyscale 8-bit (Y800)",
>  		.guid		= UVC_GUID_FORMAT_Y800,
>  		.fcc		= V4L2_PIX_FMT_GREY,
>  	},
>  	{
> -		.name		= "Greyscale (16-bit)",
> +		.name		= "Greyscale 8-bit (Y8  )",
> +		.guid		= UVC_GUID_FORMAT_Y8,
> +		.fcc		= V4L2_PIX_FMT_GREY,
> +	},
> +	{
> +		.name		= "Greyscale 10-bit (Y10 )",
> +		.guid		= UVC_GUID_FORMAT_Y10,
> +		.fcc		= V4L2_PIX_FMT_Y10,
> +	},
> +	{
> +		.name		= "Greyscale 12-bit (Y12 )",
> +		.guid		= UVC_GUID_FORMAT_Y12,
> +		.fcc		= V4L2_PIX_FMT_Y12,
> +	},
> +	{
> +		.name		= "Greyscale 16-bit (Y16 )",
>  		.guid		= UVC_GUID_FORMAT_Y16,
>  		.fcc		= V4L2_PIX_FMT_Y16,
>  	},
> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index 7c3d082..3764040 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -79,6 +79,15 @@
>  #define UVC_GUID_FORMAT_Y800 \
>  	{ 'Y',  '8',  '0',  '0', 0x00, 0x00, 0x10, 0x00, \
>  	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_Y8 \
> +	{ 'Y',  '8',  ' ',  ' ', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_Y10 \
> +	{ 'Y',  '1',  '0',  ' ', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> +#define UVC_GUID_FORMAT_Y12 \
> +	{ 'Y',  '1',  '2',  ' ', 0x00, 0x00, 0x10, 0x00, \
> +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
>  #define UVC_GUID_FORMAT_Y16 \
>  	{ 'Y',  '1',  '6',  ' ', 0x00, 0x00, 0x10, 0x00, \
>  	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}

-- 
Regards,

Laurent Pinchart

