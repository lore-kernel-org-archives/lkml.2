Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2ASXAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 18:00:06 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:34616 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827Ab2ASXAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 18:00:03 -0500
From: Kevin Hilman <khilman@ti.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 2/2] OMAP : serial : Check for error in get_context_loss_count
Organization: Texas Instruments, Inc.
References: <1326377019-23688-1-git-send-email-shubhrajyoti@ti.com>
	<1326377019-23688-2-git-send-email-shubhrajyoti@ti.com>
Date: Thu, 19 Jan 2012 14:59:59 -0800
In-Reply-To: <1326377019-23688-2-git-send-email-shubhrajyoti@ti.com>
	(Shubhrajyoti D.'s message of "Thu, 12 Jan 2012 19:33:39 +0530")
Message-ID: <87hazrti1c.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shubhrajyoti D <shubhrajyoti@ti.com> writes:

> In serial_omap_runtime_resume in case of errors returned by
> get_context_loss_count print a warning and do a restore.
>
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

These two patches should be combined into a single patch.

Also, please Cc Govindraj since he's the maintainer of this driver and
should Ack.

Thanks,

Kevin

> ---
> applies on Tony's uart branch
>
>  drivers/tty/serial/omap-serial.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 29fe6fd..6008612 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -1602,10 +1602,16 @@ static int serial_omap_runtime_resume(struct device *dev)
>  
>  	if (up) {
>  		if (pdata->get_context_loss_count) {
> -			u32 loss_cnt = pdata->get_context_loss_count(dev);
> +			int loss_cnt = pdata->get_context_loss_count(dev);
>  
> -			if (up->context_loss_cnt != loss_cnt)
> +			if (loss_cnt < 0) {
> +				dev_err(dev,
> +					"get_context_loss_count failed : %d\n",
> +					loss_cnt);
>  				serial_omap_restore_context(up);
> +			} else if (up->context_loss_cnt != loss_cnt) {
> +				serial_omap_restore_context(up);
> +			}
>  		}
>  
>  		/* Errata i291 */
