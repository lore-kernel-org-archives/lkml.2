Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1AKLR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:17:59 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:45231 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755583Ab1AKLR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:17:56 -0500
Date: Tue, 11 Jan 2011 13:17:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: manjunatha_halli@ti.com
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC V10 1/7] drivers:media:radio: wl128x: FM Driver common
 header file
Message-ID: <20110111111751.GC2385@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 11, 2011 at 06:31:21AM -0500, manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <manjunatha_halli@ti.com>
> 
> These are common headers used in FM submodules (FM V4L2,
> FM common, FM Rx,and FM TX).
> 
> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

snip

> diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
> new file mode 100644
> index 0000000..392b62d
> --- /dev/null
> +++ b/drivers/media/radio/wl128x/fmdrv.h
> @@ -0,0 +1,244 @@
> +/*
> + *  FM Driver for Connectivity chip of Texas Instruments.
> + *
> + *  Common header for all FM driver sub-modules.
> + *
> + *  Copyright (C) 2011 Texas Instruments
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
> +#define FM_DRV_VERSION            "0.09"
> +/* Should match with FM_DRV_VERSION */
> +#define FM_DRV_RADIO_VERSION      KERNEL_VERSION(0, 0, 1)
> +#define FM_DRV_NAME               "ti_fmdrv"
> +#define FM_DRV_CARD_SHORT_NAME    "TI FM Radio"
> +#define FM_DRV_CARD_LONG_NAME     "Texas Instruments FM Radio"
> +
> +/* Flag info */
> +#define FM_INTTASK_RUNNING            0
> +#define FM_INTTASK_SCHEDULE_PENDING   1
> +#define FM_FW_DW_INPROGRESS     2
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

this is called ARRAY_SIZE(), just use it.

> +
> +#define fmerr(format, ...) \
> +	printk(KERN_ERR "fmdrv: " format, ## __VA_ARGS__)
> +#define fmwarn(format, ...) \
> +	printk(KERN_WARNING "fmdrv: " format, ##__VA_ARGS__)
> +#ifdef DEBUG
> +#define fmdbg(format, ...) \
> +	printk(KERN_DEBUG "fmdrv: " format, ## __VA_ARGS__)
> +#else /* DEBUG */
> +#define fmdbg(format, ...)
> +#endif

why don't you use dev_dbg(), dev_err() and dev_warn() ??

-- 
balbi
