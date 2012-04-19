Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab2DSFL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 01:11:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52884 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2DSFLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 01:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <1334765203-31844-3-git-send-email-manjunatha_halli@ti.com>
References: <1334765203-31844-1-git-send-email-manjunatha_halli@ti.com>
	<1334765203-31844-3-git-send-email-manjunatha_halli@ti.com>
Date: Thu, 19 Apr 2012 14:11:23 +0900
X-Google-Sender-Auth: -M8ytGvcM3R8e8oggbWETGKAgnY
Message-ID: <CAH9JG2XcMcS1gf_HN_M8=aMhn6EBwU6Ka7Vzr+Q2ZG9EYJL3=A@mail.gmail.com>
Subject: Re: [PATCH V2 2/5] [Media] New control class and features for FM RX
From: Kyungmin Park <kmpark@infradead.org>
To: manjunatha_halli@ti.com
Cc: linux-media@vger.kernel.org, benzyg@ti.com, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're using similar one internally.

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On 4/19/12, manjunatha_halli@ti.com <manjunatha_halli@ti.com> wrote:
> From: Manjunatha Halli <x0130808@ti.com>
>
> This patch creates new ctrl class for FM RX and adds new CID's for
> below FM features,
>         1) De-Emphasis filter mode
> 	2) RDS AF switch
>
> Also this patch adds a field for band selection in struct v4l2_hw_freq_seek
>
> Signed-off-by: Manjunatha Halli <x0130808@ti.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |   17 +++++++++++++++++
>  include/linux/videodev2.h        |   16 +++++++++++++++-
>  2 files changed, 32 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c
> index 18015c0..e1bba7d 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -372,6 +372,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		NULL,
>  	};
>
> +	static const char * const tune_deemphasis[] = {
> +		"No deemphasis",
> +		"50 useconds",
> +		"75 useconds",
> +		NULL,
> +	};
>  	switch (id) {
>  	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
>  		return mpeg_audio_sampling_freq;
> @@ -414,6 +420,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return colorfx;
>  	case V4L2_CID_TUNE_PREEMPHASIS:
>  		return tune_preemphasis;
> +	case V4L2_CID_TUNE_DEEMPHASIS:
> +		return tune_deemphasis;
>  	case V4L2_CID_FLASH_LED_MODE:
>  		return flash_led_mode;
>  	case V4L2_CID_FLASH_STROBE_SOURCE:
> @@ -644,6 +652,12 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
>  	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
>
> +	/* FM Radio Receiver control */
> +	/* Keep the order of the 'case's the same as in videodev2.h! */
> +	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
> +	case V4L2_CID_RDS_AF_SWITCH:		return "FM RX RDS AF switch";
> +	case V4L2_CID_TUNE_DEEMPHASIS:		return "FM RX De-emphasis settings";
> +
>  	default:
>  		return NULL;
>  	}
> @@ -688,6 +702,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type,
>  	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
>  	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
> +	case V4L2_CID_RDS_AF_SWITCH:
>  		*type = V4L2_CTRL_TYPE_BOOLEAN;
>  		*min = 0;
>  		*max = *step = 1;
> @@ -733,6 +748,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type,
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>  	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
> +	case V4L2_CID_TUNE_DEEMPHASIS:
>  		*type = V4L2_CTRL_TYPE_MENU;
>  		break;
>  	case V4L2_CID_RDS_TX_PS_NAME:
> @@ -745,6 +761,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type,
>  	case V4L2_CID_FM_TX_CLASS:
>  	case V4L2_CID_FLASH_CLASS:
>  	case V4L2_CID_JPEG_CLASS:
> +	case V4L2_CID_FM_RX_CLASS:
>  		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
>  		/* You can neither read not write these */
>  		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index c9c9a46..00ac1b7 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1137,6 +1137,7 @@ struct v4l2_ext_controls {
>  #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
>  #define V4L2_CTRL_CLASS_FLASH 0x009c0000	/* Camera flash controls */
>  #define V4L2_CTRL_CLASS_JPEG 0x009d0000		/* JPEG-compression controls */
> +#define V4L2_CTRL_CLASS_FM_RX 0x009e0000	/* FM Receiver control class */
>
>  #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
>  #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
> @@ -1782,6 +1783,18 @@ enum v4l2_jpeg_chroma_subsampling {
>  #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
>  #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
>
> +/* FM Receiver class control IDs */
> +#define V4L2_CID_FM_RX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_RX | 0x900)
> +#define V4L2_CID_FM_RX_CLASS			(V4L2_CTRL_CLASS_FM_RX | 1)
> +
> +#define V4L2_CID_RDS_AF_SWITCH			(V4L2_CID_FM_RX_CLASS_BASE + 1)
> +#define V4L2_CID_TUNE_DEEMPHASIS		(V4L2_CID_FM_RX_CLASS_BASE + 2)
> +enum v4l2_deemphasis {
> +	V4L2_DEEMPHASIS_DISABLED	= 0,
> +	V4L2_DEEMPHASIS_50_uS		= 1,
> +	V4L2_DEEMPHASIS_75_uS		= 2,
> +};
> +
>  /*
>   *	T U N I N G
>   */
> @@ -1849,7 +1862,8 @@ struct v4l2_hw_freq_seek {
>  	__u32		      seek_upward;
>  	__u32		      wrap_around;
>  	__u32		      spacing;
> -	__u32		      reserved[7];
> +	__u32		      fm_band;
> +	__u32		      reserved[6];
>  };
>
>  /*
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
