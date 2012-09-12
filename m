Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab2ILXt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:49:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:59909 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958Ab2ILXon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,413,1344236400"; 
   d="scan'208";a="202569365"
Subject: Re: [PATCH 0/3 v2] mm: Batch page reclamation under shink_page_list
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alex Shi <alex.shi@intel.com>, Fengguang Wu <fengguang.wu@intel.com>
In-Reply-To: <20120912122758.ad15e10f.akpm@linux-foundation.org>
References: <1347293960.9977.70.camel@schen9-DESK>
	 <20120912122758.ad15e10f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Sep 2012 16:44:42 -0700
Message-ID: <1347493482.9977.94.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 12:27 -0700, Andrew Morton wrote:

> 
> That sounds good, although more details on the performance changes
> would be appreciated - after all, that's the entire point of the
> patchset.
> 
> And we shouldn't only test for improvements - we should also test for
> degradation.  What workloads might be harmed by this change?  I'd suggest
> 
> - a single process which opens N files and reads one page from each
>   one, then repeats.  So there are no contiguous LRU pages which share
>   the same ->mapping.  Get some page reclaim happening, measure the
>   impact.
> 
> - The batching means that we now do multiple passes over pageframes
>   where we used to do things in a single pass.  Walking all those new
>   page lists will be expensive if they are lengthy enough to cause L1
>   cache evictions.

I need to address both your concerns and Mel's concerns about the
downside of prolonging the holding page locks for the pages to be
unmmaped for patch 1 in the series.  I'll try to do some testing to see
what kind of benefit I get by only batching operations under the
i_mmap_mutex (i.e. patch 2 and 3 only) and not do batch unmap. Those
other changes don't have the downsides of prolonged page locking and we
can incorporate them with less risks.

> 
>   What would be a test for this?  A simple, single-threaded walk
>   through a file, I guess?

Thanks for your test suggestions.  I will do tests along your
suggestions when I generate the next iterations of the patch. 

I've been playing with these patches for a while and they are based on
3.4 kernel.  I'll move them to 3.6 kernel in my next iteration.

> 
> Mel's review comments were useful, thanks.

Very much appreciate comments from you, Mel and Minchan. I'll try to
incorporate them in my changes. 

Tim

