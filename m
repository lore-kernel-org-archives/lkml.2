Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1HNQia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:38:30 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:38470 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753669Ab1HNQi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:38:29 -0400
Subject: Re: [PATCH 2/3] Staging: cx25821: fix style issues in
 cx25821-video-upstream-ch2
From: Joe Perches <joe@perches.com>
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
In-Reply-To: <1313322144-9309-3-git-send-email-leonidsbox@gmail.com>
References: <1313322144-9309-1-git-send-email-leonidsbox@gmail.com>
	 <1313322144-9309-3-git-send-email-leonidsbox@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Aug 2011 09:38:26 -0700
Message-ID: <1313339906.1698.17.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-14 at 19:42 +0800, Leonid V. Fedorenchik wrote:
> Fix long lines in files cx25821-video-upstream-ch2.{c,h}
> Change obscure line endings to less obscure ones.
> Delete whitespace characters before labels.
[]
> diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
> index 655357d..b578e46 100644
> --- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
> +++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
> @@ -151,9 +151,8 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
[]
> -		frame_size =
> -		    (bpl ==
> -		     Y411_LINE_SZ) ? FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
> +		frame_size = (bpl == Y411_LINE_SZ) ? FRAME_SIZE_PAL_Y411 :
> +						FRAME_SIZE_PAL_Y422;

I think this becomes more readable without the ?: as:

		if (bpl == Y411_LINE_SZ)
			frame_size = FRAME_SIZE_PAL_Y411;
		else
			frame_size = FRAME_SIZE_PAL_Y422;

> @@ -565,23 +556,18 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
>  			}
>  
>  			if (dev->_dma_virt_start_addr_ch2 != NULL) {
> -				line_size_in_bytes =
> -				    (dev->_pixel_format_ch2 ==
> -				     PIXEL_FRMT_411) ? Y411_LINE_SZ :
> -				    Y422_LINE_SZ;
> +				line_size_in_bytes = (dev->_pixel_format_ch2 ==
> +						PIXEL_FRMT_411) ? Y411_LINE_SZ :
> +						Y422_LINE_SZ;

no ?: here too.

> diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h b/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
[]
> @@ -65,37 +65,61 @@
>  #define USE_RISC_NOOP_VIDEO   1
>  
>  #ifdef USE_RISC_NOOP_VIDEO
> -#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +   \
> -				    RISC_SYNC_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
> +#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + \
> +	RISC_WRITECR_INSTRUCTION_SIZE + RISC_SYNC_INSTRUCTION_SIZE + \
> +	NUM_NO_OPS*DWORD_SIZE)

These multi line macros might be more readable and consistent
if indented identically.

#define PAL_US_VID_PROG_SIZE						\
	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
	 RISC_WRITECR_INSTRUCTION_SIZE + RISC_SYNC_INSTRUCTION_SIZE +	\
	 NUM_NO_OPS * DWORD_SIZE)

PAL_FIELD_HEIGHT does not needs parentheses here.

[]
> +#define PAL_VID_PROG_SIZE         ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + \
> +	2*RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
> +	JUMP_INSTRUCTION_SIZE + 2*NUM_NO_OPS*DWORD_SIZE)

#define PAL_VID_PROG_SIZE						\
	((PAL_FIELD_HEIGHT * 2) * 3 * DWORD_SIZE +			\
	 2 * RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
	 JUMP_INSTRUCTION_SIZE + 2 * NUM_NO_OPS * DWORD_SIZE)
 
> +#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + \
> +	RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
> +	NUM_NO_OPS*DWORD_SIZE)

etc...


