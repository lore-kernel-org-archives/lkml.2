Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab1IMUfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:35:50 -0400
Received: from shutemov.name ([188.40.19.243]:38167 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab1IMUft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:35:49 -0400
Date: Tue, 13 Sep 2011 23:35:48 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/11] mm: memcg naturalization -rc3
Message-ID: <20110913203548.GA2894@shutemov.name>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 12:57:17PM +0200, Johannes Weiner wrote:
> Hi everyone,
> 
> this is the third revision of the memcg naturalization patch set.  Due
> to controversy, I dropped the reclaim statistics and the soft limit
> reclaim rewrite.  What's left is mostly making the per-memcg LRU lists
> exclusive.
> 
> Christoph suggested making struct mem_cgroup part of the core and have
> reclaim always operate on at least a skeleton root_mem_cgroup with
> basic LRU info even on !CONFIG_MEMCG kernels.  I agree that we should
> go there, but in its current form this would drag a lot of ugly memcg
> internals out into the public and I'd prefer another struct mem_cgroup
> shakedown and the soft limit stuff to be done before this step.  But
> we are getting there.
> 
> Changelog since -rc2
> - consolidated all memcg hierarchy iteration constructs
> - pass struct mem_cgroup_zone down the reclaim stack
> - fix concurrent full hierarchy round-trip detection
> - split out moving memcg reclaim from hierarchical global reclaim
> - drop reclaim statistics
> - rename do_shrink_zone to shrink_mem_cgroup_zone
> - fix anon pre-aging to operate on per-memcg lrus
> - revert to traditional limit reclaim hierarchy iteration
> - split out lruvec introduction
> - kill __add_page_to_lru_list
> - fix LRU-accounting during swapcache/pagecache charging
> - fix LRU-accounting of uncharged swapcache
> - split out removing array id from pc->flags
> - drop soft limit rework
> 
> More introduction and test results are included in the changelog of
> the first patch.
> 
>  include/linux/memcontrol.h  |   74 +++--
>  include/linux/mm_inline.h   |   21 +-
>  include/linux/mmzone.h      |   10 +-
>  include/linux/page_cgroup.h |   34 ---
>  mm/memcontrol.c             |  688 ++++++++++++++++++++-----------------------
>  mm/page_alloc.c             |    2 +-
>  mm/page_cgroup.c            |   59 +----
>  mm/swap.c                   |   24 +-
>  mm/vmscan.c                 |  447 +++++++++++++++++-----------
>  9 files changed, 674 insertions(+), 685 deletions(-)

Nice patchset. Thank you.

Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
