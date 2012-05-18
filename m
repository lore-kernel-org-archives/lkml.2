Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412Ab2ERAjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:39:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54674 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761734Ab2ERAjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:39:51 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-f4-4fb59a545d4e
Message-ID: <4FB59A82.2050705@kernel.org>
Date: Fri, 18 May 2012 09:40:34 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: consider all swapped back pages in used-once logic
References: <1337246033-13719-1-git-send-email-mhocko@suse.cz>
In-Reply-To: <1337246033-13719-1-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 06:13 PM, Michal Hocko wrote:

> [64574746 vmscan: detect mapped file pages used only once] made mapped pages
> have another round in inactive list because they might be just short
> lived and so we could consider them again next time. This heuristic
> helps to reduce pressure on the active list with a streaming IO
> worklods.
> This patch fixes a regression introduced by this commit for heavy shmem
> based workloads because unlike Anon pages, which are excluded from this
> heuristic because they are usually long lived, shmem pages are handled
> as a regular page cache.
> This doesn't work quite well, unfortunately, if the workload is mostly
> backed by shmem (in memory database sitting on 80% of memory) with a
> streaming IO in the background (backup - up to 20% of memory). Anon
> inactive list is full of (dirty) shmem pages when watermarks are
> hit. Shmem pages are kept in the inactive list (they are referenced)
> in the first round and it is hard to reclaim anything else so we reach
> lower scanning priorities very quickly which leads to an excessive swap
> out.
> 
> Let's fix this by excluding all swap backed pages (they tend to be long
> lived wrt. the regular page cache anyway) from used-once heuristic and
> rather activate them if they are referenced.
> 
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Mel Gorman <mel@csn.ul.ie>
> CC: Minchan Kim <minchan@kernel.org>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: stable [2.6.34+]
> Signed-off-by: Michal Hocko <mhocko@suse.cz>


Reviewed-by: Minchan Kim <minchan@kernel.org>

Good spot!
-- 
Kind regards,
Minchan Kim
