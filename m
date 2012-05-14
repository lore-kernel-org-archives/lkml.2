Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab2ENToo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:44:44 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2347 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab2ENTom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:44:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [PATCH V5 2/5] New control class and features for FM RX
Date: Mon, 14 May 2012 21:44:36 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc3-durdane; KDE/4.7.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>
References: <1337023469-24990-1-git-send-email-manjunatha_halli@ti.com> <1337023469-24990-3-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1337023469-24990-3-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205142144.36771.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manjunatha,

I wish I could ack this series, but there is one thing that really needs
to change:

On Mon May 14 2012 21:24:26 manjunatha_halli@ti.com wrote:
> @@ -1843,13 +1857,22 @@ struct v4l2_frequency {
>  	__u32		      reserved[8];
>  };
>  
> +
> +#define FM_BAND_TYPE_DEFAULT	0	/* All Bands 65.8 MHz till 108 Mhz
> +					   or 162.55 MHz if weather band */
> +#define FM_BAND_TYPE_EUROPE_US	1	/* 87.5 Mhz - 108 MHz*/
> +#define FM_BAND_TYPE_JAPAN	2	/* 76 MHz - 90 MHz*/
> +#define FM_BAND_TYPE_RUSSIAN	3	/* 65.8 MHz - 74 MHz*/
> +#define FM_BAND_TYPE_WEATHER	4	/* 162.4 MHz - 162.55 MHz*/

This needs a V4L2_ prefix. And in my opinion the _TYPE part can be dropped.

So it becomes:

#define V4L2_FM_BAND_DEFAULT	0
#define V4L2_FM_BAND_EUROPE_US	1	/* 87.5 Mhz - 108 MHz */
#define V4L2_FM_BAND_JAPAN	2	/* 76 MHz - 90 MHz */
#define V4L2_FM_BAND_RUSSIAN	3	/* 65.8 MHz - 74 MHz */
#define V4L2_FM_BAND_WEATHER	4	/* 162.4 MHz - 162.55 MHz */

BTW, also put a space before '*/'.

If you can make this change quickly (i.e. today) and post the fixed version
(don't forget to update the documentation as well!) then I'll ack it and
there is a change you can get it merged for 3.5.

Regards,

	Hans

> +
>  struct v4l2_hw_freq_seek {
>  	__u32		      tuner;
>  	enum v4l2_tuner_type  type;
>  	__u32		      seek_upward;
>  	__u32		      wrap_around;
>  	__u32		      spacing;
> -	__u32		      reserved[7];
> +	__u32		      band;
> +	__u32		      reserved[6];
>  };
>  
>  /*
> 
