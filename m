Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1GGQtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:49:18 -0400
Received: from cnc.isely.net ([75.149.91.89]:47969 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab1GGQtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:49:17 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jul 2011 12:49:17 EDT
Date: Thu, 7 Jul 2011 11:44:14 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFCv3 17/17] [media] return -ENOTTY for unsupported
 ioctl's at legacy drivers
In-Reply-To: <20110706150349.44795968@pedra>
Message-ID: <alpine.DEB.1.10.1107071143210.967@cnc.isely.net>
References: <cover.1309974026.git.mchehab@redhat.com> <20110706150349.44795968@pedra>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For the pvrusb2 portion of this patch:

Acked-By: Mike Isely <isely@pobox.com>

  -Mike

On Wed, 6 Jul 2011, Mauro Carvalho Chehab wrote:

> Those drivers are not relying at the V4L2 core to handle the ioctl's.
> So, we need to manually patch them every time a change goes to the
> core.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
> index d7efb33..9a1e80a 100644
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
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> index 573749a..e27f8ab 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> @@ -369,11 +369,6 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		break;
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
> @@ -850,7 +845,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  #endif
>  
>  	default :
> -		ret = -EINVAL;
> +		ret = -ENOTTY;
>  		break;
>  	}
>  
> diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
> index d8eece8..16cb07c 100644
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
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
> index cdd967b..7afb97b 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -83,7 +83,7 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
>  	default:
>  		uvc_trace(UVC_TRACE_CONTROL, "Unsupported V4L2 control type "
>  			  "%u.\n", xmap->v4l2_type);
> -		ret = -EINVAL;
> +		ret = -ENOTTY;
>  		goto done;
>  	}
>  
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
