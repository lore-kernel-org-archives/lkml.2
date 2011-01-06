Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1AFKbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:31:38 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35118 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab1AFKbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:31:37 -0500
Date: Thu, 6 Jan 2011 10:31:16 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/7] Change page reference handling semantic of page
	cache
Message-ID: <20110106103116.GD29257@csn.ul.ie>
References: <cover.1293031046.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:32:42AM +0900, Minchan Kim wrote:
> Now we increases page reference on add_to_page_cache but doesn't decrease it
> in remove_from_page_cache. Such asymmetric makes confusing about
> page reference so that caller should notice it and comment why they
> release page reference. It's not good API.
> 
> Long time ago, Hugh tried it[1] but gave up of reason which
> reiser4's drop_page had to unlock the page between removing it from
> page cache and doing the page_cache_release. But now the situation is
> changed. I think at least things in current mainline doesn't have any
> obstacles. The problem is fs or somethings out of mainline.
> If it has done such thing like reiser4, this patch could be a problem but
> they found it when compile time since we remove remove_from_page_cache.
> 
> [1] http://lkml.org/lkml/2004/10/24/140
> 
> The series configuration is following as. 
> 
> [1/7] : This patch introduces new API delete_from_page_cache.
> [2,3,4,5/7] : Change remove_from_page_cache with delete_from_page_cache.
> Intentionally I divide patch per file since someone might have a concern 
> about releasing page reference of delete_from_page_cache in 
> somecase (ex, truncate.c)
> [6/7] : Remove old API so out of fs can meet compile error when build time
> and can notice it.
> [7/7] : Change __remove_from_page_cache with __delete_from_page_cache, too.
> In this time, I made all-in-one patch because it doesn't change old behavior
> so it has no concern. Just clean up patch.
> 

Other than hugetlbfs being called tlbfs in patch 3/7;

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
