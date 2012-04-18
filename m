Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2DRACM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:02:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14809 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2DRACK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:02:10 -0400
X-AuditID: cbfee61b-b7bd8ae000003eff-fe-4f8e04806d83
Message-id: <4F8E0483.4010501@samsung.com>
Date: Wed, 18 Apr 2012 09:02:11 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: manjunatha_halli@ti.com
Cc: linux-media@vger.kernel.org, benzyg@ti.com, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>
Subject: Re: [PATCH 2/4] [Media] Create new control class for FM RX.
References: <1334701027-19159-1-git-send-email-manjunatha_halli@ti.com>
 <1334701027-19159-3-git-send-email-manjunatha_halli@ti.com>
In-reply-to: <1334701027-19159-3-git-send-email-manjunatha_halli@ti.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 07:17 AM, manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli<x0130808@ti.com>
>
> Also this patch adds CID's for below new FM features,
>          1) FM RX - De-Emphasis filter mode and RDS AF switch
> 	2) FM TX - RDS Alternate frequency set.

The subject of this patch is about FM RX, but it includes also adding
CID for FM TX.

Can you split this patch?

> Signed-off-by: Manjunatha Halli<x0130808@ti.com>
> ---
>   drivers/media/video/v4l2-ctrls.c |   18 ++++++++++++++++++
>   include/linux/videodev2.h        |   17 ++++++++++++++++-
>   2 files changed, 34 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 18015c0..b4ddd6b 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -372,6 +372,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>   		NULL,
>   	};
>
> +	static const char * const tune_deemphasis[] = {
> +		"No deemphasis",
> +		"50 useconds",
> +		"75 useconds",
> +		NULL,
> +	};
>   	switch (id) {
>   	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
>   		return mpeg_audio_sampling_freq;
> @@ -414,6 +420,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>   		return colorfx;
>   	case V4L2_CID_TUNE_PREEMPHASIS:
>   		return tune_preemphasis;
> +	case V4L2_CID_TUNE_DEEMPHASIS:
> +		return tune_deemphasis;
>   	case V4L2_CID_FLASH_LED_MODE:
>   		return flash_led_mode;
>   	case V4L2_CID_FLASH_STROBE_SOURCE:
> @@ -606,6 +614,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>   	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
>   	case V4L2_CID_RDS_TX_PS_NAME:		return "RDS PS Name";
>   	case V4L2_CID_RDS_TX_RADIO_TEXT:	return "RDS Radio Text";
> +	case V4L2_CID_RDS_TX_AF_FREQ:		return "RDS Alternate Frequency";
>   	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
>   	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
>   	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
> @@ -644,6 +653,12 @@ const char *v4l2_ctrl_get_name(u32 id)
>   	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
>   	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
>
> +	/* FM Radio Receiver control */
> +	/* Keep the order of the 'case's the same as in videodev2.h! */
> +	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
> +	case V4L2_CID_RDS_AF_SWITCH:		return "FM RX RDS AF switch";
> +	case V4L2_CID_TUNE_DEEMPHASIS:		return "FM RX De-emphasis settings";
> +
>   	default:
>   		return NULL;
>   	}
> @@ -688,6 +703,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>   	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
>   	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
>   	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
> +	case V4L2_CID_RDS_AF_SWITCH:
>   		*type = V4L2_CTRL_TYPE_BOOLEAN;
>   		*min = 0;
>   		*max = *step = 1;
> @@ -733,6 +749,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>   	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
>   	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>   	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
> +	case V4L2_CID_TUNE_DEEMPHASIS:
>   		*type = V4L2_CTRL_TYPE_MENU;
>   		break;
>   	case V4L2_CID_RDS_TX_PS_NAME:
> @@ -745,6 +762,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>   	case V4L2_CID_FM_TX_CLASS:
>   	case V4L2_CID_FLASH_CLASS:
>   	case V4L2_CID_JPEG_CLASS:
> +	case V4L2_CID_FM_RX_CLASS:
>   		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
>   		/* You can neither read not write these */
>   		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index c9c9a46..d1c8c1b 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1137,6 +1137,7 @@ struct v4l2_ext_controls {
>   #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
>   #define V4L2_CTRL_CLASS_FLASH 0x009c0000	/* Camera flash controls */
>   #define V4L2_CTRL_CLASS_JPEG 0x009d0000		/* JPEG-compression controls */
> +#define V4L2_CTRL_CLASS_FM_RX 0x009e0000	/* FM Receiver control class */
>
>   #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
>   #define V4L2_CTRL_ID2CLASS(id)    ((id)&  0x0fff0000UL)
> @@ -1698,6 +1699,7 @@ enum  v4l2_exposure_auto_type {
>   #define V4L2_CID_RDS_TX_PTY			(V4L2_CID_FM_TX_CLASS_BASE + 3)
>   #define V4L2_CID_RDS_TX_PS_NAME			(V4L2_CID_FM_TX_CLASS_BASE + 5)
>   #define V4L2_CID_RDS_TX_RADIO_TEXT		(V4L2_CID_FM_TX_CLASS_BASE + 6)
> +#define V4L2_CID_RDS_TX_AF_FREQ			(V4L2_CID_FM_TX_CLASS_BASE + 7)
>
>   #define V4L2_CID_AUDIO_LIMITER_ENABLED		(V4L2_CID_FM_TX_CLASS_BASE + 64)
>   #define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 65)
> @@ -1782,6 +1784,18 @@ enum v4l2_jpeg_chroma_subsampling {
>   #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1<<  17)
>   #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1<<  18)
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
>   /*
>    *	T U N I N G
>    */
> @@ -1849,7 +1863,8 @@ struct v4l2_hw_freq_seek {
>   	__u32		      seek_upward;
>   	__u32		      wrap_around;
>   	__u32		      spacing;
> -	__u32		      reserved[7];
> +	__u32		      fm_band;
> +	__u32		      reserved[6];
>   };
>
>   /*

