Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0LGVxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:53:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189Ab0LGVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:53:44 -0500
Date: Tue, 7 Dec 2010 13:53:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] compaction: Remove mem_cgroup_del_lru
Message-Id: <20101207135301.49898964.akpm@linux-foundation.org>
In-Reply-To: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
References: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Dec 2010 00:01:26 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

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

err, yes, that looks bad.

This bug is present in 2.6.35 and 2.6.36 afaict, so I tagged the fix
for -stable backporting.

