Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977Ab1LPWh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:37:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804Ab1LPWhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:37:54 -0500
Date: Fri, 16 Dec 2011 14:37:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3] vmscan/trace: Add 'file' info to
 trace_mm_vmscan_lru_isolate.
Message-Id: <20111216143753.07588b01.akpm@linux-foundation.org>
In-Reply-To: <1323875693-3504-1-git-send-email-tm@tao.ma>
References: <20111213164507.fbee477c.akpm@linux-foundation.org>
	<1323875693-3504-1-git-send-email-tm@tao.ma>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011 23:14:53 +0800
Tao Ma <tm@tao.ma> wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> In trace_mm_vmscan_lru_isolate, we don't output 'file'
> information to the trace event and it is a bit inconvenient for the
> user to get the real information(like pasted below).
> mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
> nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
> 
> 'active' can be gotten by analyzing mode(Thanks go to Minchan and Mel),
> So this patch adds 'file' to the trace event and it now looks like:
> mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
> nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0 file=0
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1249,7 +1249,7 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>  	*scanned = scan;
>  
>  	trace_mm_vmscan_memcg_isolate(0, nr_to_scan, scan, nr_taken,
> -				      0, 0, 0, mode);
> +				      0, 0, 0, mode, file);
>  
>  	return nr_taken;
>  }

This tracepoint was removed by Johannes's "mm: make per-memcg LRU lists
exclusive".

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f54a05b..a444dc0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1221,7 +1221,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>  			nr_to_scan, scan,
>  			nr_taken,
>  			nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed,
> -			mode);
> +			mode, file);
>  	return nr_taken;
>  }

So this is the only remaining site for that tracepoint.
