Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0L3LB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 06:01:56 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2491 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab0L3LBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 06:01:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: manjunatha_halli@ti.com
Subject: Re: [RFC V8 1/7] drivers:media:radio: wl128x: fmdrv common header file
Date: Thu, 30 Dec 2010 12:01:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7-durdane; KDE/4.4.5; x86_64; ; )
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1293707507-3376-1-git-send-email-manjunatha_halli@ti.com> <1293707507-3376-2-git-send-email-manjunatha_halli@ti.com>
In-Reply-To: <1293707507-3376-2-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301201.46449.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 30, 2010 12:11:41 manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <manjunatha_halli@ti.com>
> 
> These are common headers used in FM submodules (FM V4L2,
> FM common, FM Rx,and FM TX).
> 
> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> ---
>  drivers/media/radio/wl128x/fmdrv.h |  248 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 248 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/wl128x/fmdrv.h
> 
> diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
> new file mode 100644
> index 0000000..3d73f76
> --- /dev/null
> +++ b/drivers/media/radio/wl128x/fmdrv.h
> @@ -0,0 +1,248 @@
> +/*
> + *  FM Driver for Connectivity chip of Texas Instruments.
> + *
> + *  Common header for all FM driver sub-modules.
> + *
> + *  Copyright (C) 2009 Texas Instruments
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
> +#ifndef _FM_DRV_H
> +#define _FM_DRV_H
> +
> +#include <linux/skbuff.h>
> +#include <linux/interrupt.h>
> +#include <sound/core.h>
> +#include <sound/initval.h>
> +#include <linux/timer.h>
> +#include <linux/version.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ctrls.h>
> +
> +#define FM_DRV_VERSION            "0.01"
> +/* Should match with FM_DRV_VERSION */
> +#define FM_DRV_RADIO_VERSION      KERNEL_VERSION(0, 0, 1)
> +#define FM_DRV_NAME               "ti_fmdrv"
> +#define FM_DRV_CARD_SHORT_NAME    "TI FM Radio"
> +#define FM_DRV_CARD_LONG_NAME     "Texas Instruments FM Radio"
> +
> +/* Flag info */
> +#define FM_INTTASK_RUNNING            0
> +#define FM_INTTASK_SCHEDULE_PENDING   1
> +#define FM_FIRMWARE_DW_INPROGRESS     2
> +#define FM_CORE_READY                 3
> +#define FM_CORE_TRANSPORT_READY       4
> +#define FM_AF_SWITCH_INPROGRESS	      5
> +#define FM_CORE_TX_XMITING	      6
> +
> +#define FM_TUNE_COMPLETE	      0x1
> +#define FM_BAND_LIMIT		      0x2
> +
> +#define FM_DRV_TX_TIMEOUT      (5*HZ)	/* 5 seconds */
> +#define FM_DRV_RX_SEEK_TIMEOUT (20*HZ)	/* 20 seconds */
> +
> +#define NO_OF_ENTRIES_IN_ARRAY(array) (sizeof(array) / sizeof(array[0]))
> +
> +enum {
> +	FM_MODE_OFF,
> +	FM_MODE_TX,
> +	FM_MODE_RX,
> +	FM_MODE_ENTRY_MAX
> +};
> +
> +#define FM_RX_RDS_INFO_FIELD_MAX	8	/* 4 Group * 2 Bytes */
> +
> +/*
> + * define private CIDs for V4L2
> + */
> +#define V4L2_CID_CHANNEL_SPACING (V4L2_CID_PRIVATE_BASE + 0)

This define seems to be a leftover from previous versions and should be removed.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
