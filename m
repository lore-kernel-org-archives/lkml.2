Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2ECHJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:09:06 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4052 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2ECHJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:09:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [PATCH V3 2/5] [Media] New control class and features for FM RX
Date: Thu, 3 May 2012 09:08:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc3-tschai; KDE/4.7.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>
References: <1335994951-15842-1-git-send-email-manjunatha_halli@ti.com> <1335994951-15842-3-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1335994951-15842-3-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205030908.57369.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a few more minor notes:

On Wed May 2 2012 23:42:28 manjunatha_halli@ti.com wrote:
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
>  include/linux/videodev2.h        |   11 ++++++++++-
>  2 files changed, 27 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
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

I suggest that we re-use tune_preemphasis[] here. Just replace the first
entry from "No Preemphasis" to "None" to make it generic.

Rename tune_preemphasis[] to tune_emphasis[] as well.

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

I would call this "RDS AF Switch" or perhaps even better: "RDS Auto-Frequency Switch"

> +	case V4L2_CID_TUNE_DEEMPHASIS:		return "FM RX De-emphasis settings";

Rename to "De-Emphasis" to be consistent with the existing "Pre-Emphasis" string.

Regards,

	Hans
