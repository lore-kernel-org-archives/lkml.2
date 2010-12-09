Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0LIPAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:00:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38420 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab0LIPAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:00:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mLHkN66XSDuNZIqJMUEEVw5pMBKJKHtkN0YD99gDrMfpxZKvytm66LLHkYCthT9CXT
         oiIPzACRtNq88wVigWTTn+R4WjYJXkJAOrgDedTCWknd3kLFMUBZeRgRTnq8zLg0PXW6
         2uysowhhi6/9ke17WP8nU8pS/wQcMjJIonHlk=
Date: Thu, 9 Dec 2010 23:59:59 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] compaction: Remove mem_cgroup_del_lru
Message-ID: <20101209145959.GA1740@barrios-desktop>
References: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 12:01:26AM +0900, Minchan Kim wrote:
> del_page_from_lru_list alreay called mem_cgroup_del_lru.
> So we need to call it again. It makes wrong stat of memcg and
> even happen VM_BUG_ON hit.
> 
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/compaction.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 50b0a90..b0fbfdf 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -302,7 +302,6 @@ static unsigned long isolate_migratepages(struct zone *zone,
>  		/* Successfully isolated */
>  		del_page_from_lru_list(zone, page, page_lru(page));
>  		list_add(&page->lru, migratelist);
> -		mem_cgroup_del_lru(page);
>  		cc->nr_migratepages++;
>  		nr_isolated++;
>  
> -- 
> 1.7.0.4
> 

Hi Andrew, 
Please drop above(mm-compactionc-avoid-double-mem_cgroup_del_lru.patch)
This is a new version with modified description and added Acked-by.

>From 64b3a2c1205d3ffc55878ab8f00f4d450318bb91 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan.kim@gmail.com>
Date: Thu, 9 Dec 2010 23:49:27 +0900
Subject: [PATCH] mm/compaction.c: avoid double mem_cgroup_del_lru()

del_page_from_lru_list() already called mem_cgroup_del_lru().  So we must
not call it again. It adds unnecessary overhead.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 50b0a90..b0fbfdf 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -302,7 +302,6 @@ static unsigned long isolate_migratepages(struct zone *zone,
 		/* Successfully isolated */
 		del_page_from_lru_list(zone, page, page_lru(page));
 		list_add(&page->lru, migratelist);
-		mem_cgroup_del_lru(page);
 		cc->nr_migratepages++;
 		nr_isolated++;
 
-- 
1.7.0.4


-- 
Kind regards,
Minchan Kim
