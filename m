Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2ENGaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 02:30:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:50507 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2ENGaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 02:30:16 -0400
Message-ID: <4FB0A668.40501@kernel.dk>
Date: Mon, 14 May 2012 08:30:00 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix blkdev.h build errors when BLOCK=n
References: <20120430081834.GS24211@n2100.arm.linux.org.uk>
In-Reply-To: <20120430081834.GS24211@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 10:18 AM, Russell King - ARM Linux wrote:
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

Thanks Russell, applied.

-- 
Jens Axboe

