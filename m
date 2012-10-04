Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273Ab2JDIyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:54:53 -0400
Received: from ams-iport-4.cisco.com ([144.254.224.147]:28324 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030257Ab2JDIyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:54:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,533,1344211200"; 
   d="scan'208";a="8520506"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] media: davinci: vpif: set device capabilities
Date: Thu, 4 Oct 2012 10:54:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.5-0.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <1348582915-22878-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1348582915-22878-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210041054.35565.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 25 September 2012 16:21:55 Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> set device_caps and also change the driver and
> bus_info to proper values as per standard.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Changes for v2:
>  1: Change the bus_info and driver to proper values,
>     pointed by Hans.
> 
>  drivers/media/platform/davinci/vpif_capture.c |    9 ++++++---
>  drivers/media/platform/davinci/vpif_display.c |    9 ++++++---
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 4828888..cb70e98 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1630,9 +1630,12 @@ static int vpif_querycap(struct file *file, void  *priv,
>  {
>  	struct vpif_capture_config *config = vpif_dev->platform_data;
>  
> -	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> -	strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));
> -	strlcpy(cap->bus_info, "VPIF Platform", sizeof(cap->bus_info));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +			V4L2_CAP_READWRITE;

Why add READWRITE? There is no read/write support in these drivers.

> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	snprintf(cap->driver, sizeof(cap->driver), "%s", dev_name(vpif_dev));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(vpif_dev));
>  	strlcpy(cap->card, config->card_name, sizeof(cap->card));
>  
>  	return 0;
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index d94b8a2..411b547 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -827,9 +827,12 @@ static int vpif_querycap(struct file *file, void  *priv,
>  {
>  	struct vpif_display_config *config = vpif_dev->platform_data;
>  
> -	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> -	strlcpy(cap->driver, "vpif display", sizeof(cap->driver));
> -	strlcpy(cap->bus_info, "Platform", sizeof(cap->bus_info));
> +	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
> +			    V4L2_CAP_READWRITE;

Ditto.

> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	snprintf(cap->driver, sizeof(cap->driver), "%s", dev_name(vpif_dev));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 dev_name(vpif_dev));
>  	strlcpy(cap->card, config->card_name, sizeof(cap->card));
>  
>  	return 0;
> 

Regards,

	Hans
