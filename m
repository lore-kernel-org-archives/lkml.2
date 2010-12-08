Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0LHQnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:43:40 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41593 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0LHQnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:43:39 -0500
Date: Wed, 8 Dec 2010 17:43:27 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] compaction: Remove mem_cgroup_del_lru
Message-ID: <20101208164327.GL2356@cmpxchg.org>
References: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
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

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

But regarding the severity of this: shouldn't the second deletion
attempt be caught by the TestClearPageCgroupAcctLRU() early in
mem_cgroup_del_lru_list()?
