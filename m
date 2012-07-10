Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab2GJNBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:01:47 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53758 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab2GJNBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:01:46 -0400
Date: Tue, 10 Jul 2012 15:01:33 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] shmem: cleanup shmem_add_to_page_cache
Message-ID: <20120710130133.GF1779@cmpxchg.org>
References: <alpine.LSU.2.00.1207091533001.2051@eggly.anvils>
 <alpine.LSU.2.00.1207091544290.2051@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207091544290.2051@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 03:46:53PM -0700, Hugh Dickins wrote:
> shmem_add_to_page_cache() has three callsites, but only one of them
> wants the radix_tree_preload() (an exceptional entry guarantees that
> the radix tree node is present in the other cases), and only that site
> can achieve mem_cgroup_uncharge_cache_page() (PageSwapCache makes it a
> no-op in the other cases).  We did it this way originally to reflect
> add_to_page_cache_locked(); but it's confusing now, so move the
> radix_tree preloading and mem_cgroup uncharging to that one caller.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

I'm rebasing my (un)charge series on top of these, thanks.  It only
annihilates 3/11 and leaves the rest alone--line numbers aside--since
the rules did not change.
