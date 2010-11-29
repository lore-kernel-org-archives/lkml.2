Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0K2LVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:21:43 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49649 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab0K2LVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:21:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [BUGFIX] vmstat: fix dirty threshold ordering
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101129103845.GA1195@localhost>
References: <20101129103845.GA1195@localhost>
Message-Id: <20101129202124.82CC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 29 Nov 2010 20:21:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The nr_dirty_[background_]threshold fields are misplaced before the
> numa_* fields, and users will read strange values.
> 
> This is the right order. Before patch, nr_dirty_background_threshold
> will read as 0 (the value from numa_miss).
> 
> 	numa_hit 128501
> 	numa_miss 0
> 	numa_foreign 0
> 	numa_interleave 7388
> 	numa_local 128501
> 	numa_other 0
> 	nr_dirty_threshold 144291
> 	nr_dirty_background_threshold 72145
> 
> Cc: Michael Rubin <mrubin@google.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Obviously. :-/

Thanks, Wu.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
>  mm/vmstat.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next.orig/mm/vmstat.c	2010-11-28 16:02:12.000000000 +0800
> +++ linux-next/mm/vmstat.c	2010-11-28 16:02:24.000000000 +0800
> @@ -750,8 +750,6 @@ static const char * const vmstat_text[] 
>  	"nr_shmem",
>  	"nr_dirtied",
>  	"nr_written",
> -	"nr_dirty_threshold",
> -	"nr_dirty_background_threshold",
>  
>  #ifdef CONFIG_NUMA
>  	"numa_hit",
> @@ -761,6 +759,8 @@ static const char * const vmstat_text[] 
>  	"numa_local",
>  	"numa_other",
>  #endif
> +	"nr_dirty_threshold",
> +	"nr_dirty_background_threshold",
>  
>  #ifdef CONFIG_VM_EVENT_COUNTERS
>  	"pgpgin",
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



