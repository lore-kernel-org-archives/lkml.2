Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2EaGoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:44:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37072 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2EaGoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:44:21 -0400
Message-ID: <4FC7130B.6040506@kernel.dk>
Date: Thu, 31 May 2012 08:43:23 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 05/11] mtip32xx: Set block queue boundary variables
References: <4FC57B1B.5010901@micron.com>
In-Reply-To: <4FC57B1B.5010901@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 03:42 AM, Asai Thambi S P wrote:
> 
> Set the following block queue boundary variables
> 	* max_hw_sectors
> 	* max_segment_size
> 	* nr_requests
> 
> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
> ---
>  drivers/block/mtip32xx/mtip32xx.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
> index 9fe897d..801e70c 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -3631,7 +3631,11 @@ skip_create_disk:
>  	set_bit(QUEUE_FLAG_NONROT, &dd->queue->queue_flags);
>  	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
>  	blk_queue_physical_block_size(dd->queue, 4096);
> +	blk_queue_max_hw_sectors(dd->queue, 0xffff);
> +	blk_queue_max_segment_size(dd->queue, 0x400000);
>  	blk_queue_io_min(dd->queue, 4096);
> +	dd->queue->nr_requests = 255;

->nr_requests isn't a boundary variable you set for the queue. It's set
by the core bits, or by the user via the sysfs interface.

So you should not touch that from the driver.

-- 
Jens Axboe

