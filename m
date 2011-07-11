Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1GKLCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:02:23 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42250 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab1GKLCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:02:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFCv3 17/17] [media] return -ENOTTY for unsupported ioctl's at legacy drivers
Date: Mon, 11 Jul 2011 13:03:06 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
References: <cover.1309974026.git.mchehab@redhat.com> <20110706150349.44795968@pedra>
In-Reply-To: <20110706150349.44795968@pedra>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111303.06969.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 July 2011 20:03:49 Mauro Carvalho Chehab wrote:
> Those drivers are not relying at the V4L2 core to handle the ioctl's.
> So, we need to manually patch them every time a change goes to the
> core.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

For the uvcvide portion of this patch:

Acked-By: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> 
> diff --git a/drivers/media/video/et61x251/et61x251_core.c
> b/drivers/media/video/et61x251/et61x251_core.c index d7efb33..9a1e80a
> 100644
> --- a/drivers/media/video/et61x251/et61x251_core.c
> +++ b/drivers/media/video/et61x251/et61x251_core.c
> @@ -2480,16 +2480,8 @@ static long et61x251_ioctl_v4l2(struct file *filp,
>  	case VIDIOC_S_PARM:
>  		return et61x251_vidioc_s_parm(cam, arg);
> 
> -	case VIDIOC_G_STD:
> -	case VIDIOC_S_STD:
> -	case VIDIOC_QUERYSTD:
> -	case VIDIOC_ENUMSTD:
> -	case VIDIOC_QUERYMENU:
> -	case VIDIOC_ENUM_FRAMEINTERVALS:
> -		return -EINVAL;
> -
>  	default:
> -		return -EINVAL;
> +		return -ENOTTY;
> 
>  	}
>  }
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c index 573749a..e27f8ab 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> @@ -369,11 +369,6 @@ static long pvr2_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) break;
>  	}
> 
> -	case VIDIOC_S_AUDIO:
> -	{
> -		ret = -EINVAL;
> -		break;
> -	}
>  	case VIDIOC_G_TUNER:
>  	{
>  		struct v4l2_tuner *vt = (struct v4l2_tuner *)arg;
> @@ -850,7 +845,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) #endif
> 
>  	default :
> -		ret = -EINVAL;
> +		ret = -ENOTTY;
>  		break;
>  	}
> 
> diff --git a/drivers/media/video/sn9c102/sn9c102_core.c
> b/drivers/media/video/sn9c102/sn9c102_core.c index d8eece8..16cb07c 100644
> --- a/drivers/media/video/sn9c102/sn9c102_core.c
> +++ b/drivers/media/video/sn9c102/sn9c102_core.c
> @@ -3187,16 +3187,8 @@ static long sn9c102_ioctl_v4l2(struct file *filp,
>  	case VIDIOC_S_AUDIO:
>  		return sn9c102_vidioc_s_audio(cam, arg);
> 
> -	case VIDIOC_G_STD:
> -	case VIDIOC_S_STD:
> -	case VIDIOC_QUERYSTD:
> -	case VIDIOC_ENUMSTD:
> -	case VIDIOC_QUERYMENU:
> -	case VIDIOC_ENUM_FRAMEINTERVALS:
> -		return -EINVAL;
> -
>  	default:
> -		return -EINVAL;
> +		return -ENOTTY;
> 
>  	}
>  }
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index cdd967b..7afb97b 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -83,7 +83,7 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain
> *chain, default:
>  		uvc_trace(UVC_TRACE_CONTROL, "Unsupported V4L2 control type "
>  			  "%u.\n", xmap->v4l2_type);
> -		ret = -EINVAL;
> +		ret = -ENOTTY;
>  		goto done;
>  	}

-- 
Regards,

Laurent Pinchart
