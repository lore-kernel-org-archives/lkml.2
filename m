Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1IGQWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:22:33 -0400
Received: from frankvm.xs4all.nl ([83.163.148.79]:38974 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756387Ab1IGQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:22:31 -0400
Date: Wed, 7 Sep 2011 12:24:25 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.0.3 kernel BUG at kernel/timer.c:1035
Message-ID: <20110907102425.GA3423@janus>
References: <20110824130238.GA24543@janus>
 <20110902011058.c5bad476.akpm@linux-foundation.org>
 <20110905123813.GA29763@janus>
 <CAF1ivSYui_=tHbxHiy15a9wfiphHcpoY+J1MmAJ=dMQsAfEVLw@mail.gmail.com>
 <1315320518.4235.3.camel@hp6530s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315320518.4235.3.camel@hp6530s>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 10:48:38PM +0800, Lin Ming wrote:
> Does below patch help?
> 
> >From a98b874437f871d5ecc3f6fe409b2b474b1f2731 Mon Sep 17 00:00:00 2001
> From: Lin Ming <ming.m.lin@intel.com>
> Date: Tue, 6 Sep 2011 22:45:43 +0800
> Subject: [PATCH] block: delete bdi writeback wakup_timer in blk_cleanup_queue()
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  block/blk-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 90e1ffd..22529a3 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -363,6 +363,7 @@ void blk_cleanup_queue(struct request_queue *q)
>  	blk_sync_queue(q);
>  
>  	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
> +	del_timer_sync(&q->backing_dev_info.wb.wakeup_timer);
>  	mutex_lock(&q->sysfs_lock);
>  	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
>  	mutex_unlock(&q->sysfs_lock);
> -- 
> 1.7.2.3
> 

No, bug still present. Stack trace is the same and I double checked that
it was the new kernel (this time with a lot more debug enabled).

-- 
Frank
