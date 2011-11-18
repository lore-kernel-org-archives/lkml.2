Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1KRR1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:27:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab1KRR1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:27:44 -0500
Date: Fri, 18 Nov 2011 18:27:09 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm: compaction: Use synchronous compaction for
 /proc/sys/vm/compact_memory
Message-ID: <20111118172709.GA3579@redhat.com>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
 <1321635524-8586-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321635524-8586-3-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 04:58:41PM +0000, Mel Gorman wrote:
> When asynchronous compaction was introduced, the
> /proc/sys/vm/compact_memory handler should have been updated to always
> use synchronous compaction. This did not happen so this patch addresses
> it. The assumption is if a user writes to /proc/sys/vm/compact_memory,
> they are willing for that process to stall.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/compaction.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 237560e..615502b 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -666,6 +666,7 @@ static int compact_node(int nid)
>  			.nr_freepages = 0,
>  			.nr_migratepages = 0,
>  			.order = -1,
> +			.sync = true,
>  		};
>  
>  		zone = &pgdat->node_zones[zoneid];

Yep I noticed that yesterday too.

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
