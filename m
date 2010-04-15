Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0DOFwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:52:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63094 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab0DOFwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:52:12 -0400
Message-ID: <4BC6A965.4080402@cn.fujitsu.com>
Date: Thu, 15 Apr 2010 13:51:33 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Divyesh Shah <dpshah@google.com>
CC: jens.axboe@oracle.com, sfr@canb.auug.org.au, vgoyal@redhat.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkio: Fix linux-next build failure after merge of block
 tree
References: <20100415053543.15190.98919.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100415053543.15190.98919.stgit@austin.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divyesh Shah wrote:
> After merging the block tree, 20100414's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "get_gendisk" [block/blk-cgroup.ko] undefined!
> ERROR: "sched_clock" [block/blk-cgroup.ko] undefined!
> 
> This happens because the two symbols aren't exported and hence not available
> when blk-cgroup code is built as a module. I've tried to stay consistent with
> the use of EXPORT_SYMBOL or EXPORT_SYMBOL_GPL with the other symbols in the
> respective files.
> 
> Signed-off-by: Divyesh Shah <dpshah@google.com>

I was just about to post a same patch. :)

Acked-by: Gui Jianfeng <guijianfeng@cn.fujitsu.cn>

> ---
> 
>  block/genhd.c        |    1 +
>  kernel/sched_clock.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index d13ba76..154b5f8 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -596,6 +596,7 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
>  
>  	return disk;
>  }
> +EXPORT_SYMBOL(get_gendisk);
>  
>  /**
>   * bdget_disk - do bdget() by gendisk and partition number
> diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
> index 5b49613..906a0f7 100644
> --- a/kernel/sched_clock.c
> +++ b/kernel/sched_clock.c
> @@ -41,6 +41,7 @@ unsigned long long __attribute__((weak)) sched_clock(void)
>  	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
>  					* (NSEC_PER_SEC / HZ);
>  }
> +EXPORT_SYMBOL_GPL(sched_clock);
>  
>  static __read_mostly int sched_clock_running;
>  
> 
> 
> 
> 


