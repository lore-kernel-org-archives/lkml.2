Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab0KQBZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:25:03 -0500
Received: from [120.204.251.227] ([120.204.251.227]:34817 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933571Ab0KQBZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:25:00 -0500
Message-ID: <4CE32EB1.7090002@leadcoretech.com>
Date: Wed, 17 Nov 2010 09:24:01 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; zh-CN; rv:1.9.2.12) Gecko/20101028 Lightning/1.0b2 Lanikai/3.1.6
MIME-Version: 1.0
To: manjunatha_halli@ti.com
CC: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v4 2/6] drivers:staging: ti-st: fmdrv_v4l2 sources
References: <1289913494-21590-1-git-send-email-manjunatha_halli@ti.com> <1289913494-21590-2-git-send-email-manjunatha_halli@ti.com> <1289913494-21590-3-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1289913494-21590-3-git-send-email-manjunatha_halli@ti.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Nov 2010 01:24:57.0652 (UTC) FILETIME=[3F0DF740:01CB85F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ÓÚ 11/16/2010 09:18 PM, manjunatha_halli@ti.com Ð´µÀ:
> From: Manjunatha Halli<manjunatha_halli@ti.com>
> 
> This module interfaces V4L2 subsystem and FM common
> module. It registers itself with V4L2 as Radio module.
> 
> Signed-off-by: Manjunatha Halli<manjunatha_halli@ti.com>
> ---
>   drivers/staging/ti-st/fmdrv_v4l2.c |  757 ++++++++++++++++++++++++++++++++++++
>   drivers/staging/ti-st/fmdrv_v4l2.h |   32 ++
>   2 files changed, 789 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.c
>   create mode 100644 drivers/staging/ti-st/fmdrv_v4l2.h
> 
> diff --git a/drivers/staging/ti-st/fmdrv_v4l2.c b/drivers/staging/ti-st/fmdrv_v4l2.c
> new file mode 100644
> index 0000000..687d10f
> --- /dev/null
> +++ b/drivers/staging/ti-st/fmdrv_v4l2.c
> @@ -0,0 +1,757 @@
> +/*
> + *  FM Driver for Connectivity chip of Texas Instruments.
> + *  This file provides interfaces to V4L2 subsystem.
> + *
> + *  This module registers with V4L2 subsystem as Radio
> + *  data system interface (/dev/radio). During the registration,
> + *  it will expose two set of function pointers.
> + *
> + *    1) File operation related API (open, close, read, write, poll...etc).
> + *    2) Set of V4L2 IOCTL complaint API.
> + *
> + *  Copyright (C) 2010 Texas Instruments
> + *  Author: Raja Mani<raja_mani@ti.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#include "fmdrv.h"
> +#include "fmdrv_v4l2.h"
> +#include "fmdrv_common.h"
> +#include "fmdrv_rx.h"
> +#include "fmdrv_tx.h"
> +
> +static struct video_device *gradio_dev;

why are you using global variable here?

