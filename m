Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2ELTyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:54:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53777 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2ELTyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:54:38 -0400
Date: Sat, 12 May 2012 20:54:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix blkdev.h build errors when BLOCK=n
Message-ID: <20120512195430.GA23863@n2100.arm.linux.org.uk>
References: <20120430081834.GS24211@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430081834.GS24211@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

On Mon, Apr 30, 2012 at 09:18:34AM +0100, Russell King - ARM Linux wrote:
> I see builds failing with:
> 
>   CC [M]  drivers/mmc/host/dw_mmc.o
> In file included from drivers/mmc/host/dw_mmc.c:15:
> include/linux/blkdev.h:1404: warning: 'struct task_struct' declared inside parameter list
> include/linux/blkdev.h:1404: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/blkdev.h:1408: warning: 'struct task_struct' declared inside parameter list
> include/linux/blkdev.h:1413: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'blk_needs_flush_plug'
> make[4]: *** [drivers/mmc/host/dw_mmc.o] Error 1
> 
> This is because dw_mmc.c includes linux/blkdev.h as the very first file,
> and when CONFIG_BLOCK=n, blkdev.h omits all includes.
> 
> As it requires linux/sched.h even when CONFIG_BLOCK=n, move this out of
> the #ifdef.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  include/linux/blkdev.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2aa2466..4d4ac24 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1,9 +1,10 @@
>  #ifndef _LINUX_BLKDEV_H
>  #define _LINUX_BLKDEV_H
>  
> +#include <linux/sched.h>
> +
>  #ifdef CONFIG_BLOCK
>  
> -#include <linux/sched.h>
>  #include <linux/major.h>
>  #include <linux/genhd.h>
>  #include <linux/list.h>
> 
