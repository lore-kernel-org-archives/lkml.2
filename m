Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2HMM3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:29:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab2HMM3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:29:54 -0400
Date: Mon, 13 Aug 2012 13:29:48 +0100
From: Mel Gorman <mgorman@suse.de>
To: Alex Shi <alex.shi@intel.com>
Cc: cl@linux.com, davem@davemloft.net, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: correct page->pfmemalloc to fix deactivate_slab
 regression
Message-ID: <20120813122948.GF4177@suse.de>
References: <1344860075-31752-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1344860075-31752-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 08:14:35PM +0800, Alex Shi wrote:
> commit cfd19c5a9ec (mm: only set page->pfmemalloc when
> ALLOC_NO_WATERMARKS was used) try to narrow down page->pfmemalloc
> setting, but it missed some places the pfmemalloc should be set.
> 
> So, in __slab_alloc, the unalignment pfmemalloc and ALLOC_NO_WATERMARKS
> cause incorrect deactivate_slab() on our core2 server:
> 
>     64.73%           fio  [kernel.kallsyms]     [k] _raw_spin_lock
>                      |
>                      --- _raw_spin_lock
>                         |
>                         |---0.34%-- deactivate_slab
>                         |          __slab_alloc
>                         |          kmem_cache_alloc
>                         |          |
> 
> That causes our fio sync write performance has 40% regression.
> 
> This patch move the checking in get_page_from_freelist, that resolved
> this issue.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
