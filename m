Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1DSIes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:34:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46252 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1DSIeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:34:46 -0400
Date: Tue, 19 Apr 2011 09:30:59 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        Dave Chinner <david@fromorbit.com>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm/vmalloc: remove guard page from between vmap blocks
Message-ID: <20110419083059.GA23041@csn.ul.ie>
References: <20110414211441.GA1700@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110414211441.GA1700@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 05:14:41PM -0400, Johannes Weiner wrote:
> The vmap allocator is used to, among other things, allocate per-cpu
> vmap blocks, where each vmap block is naturally aligned to its own
> size.  Obviously, leaving a guard page after each vmap area forbids
> packing vmap blocks efficiently and can make the kernel run out of
> possible vmap blocks long before overall vmap space is exhausted.
> 
> The new interface to map a user-supplied page array into linear
> vmalloc space (vm_map_ram) insists on allocating from a vmap block
> (instead of falling back to a custom area) when the area size is below
> a certain threshold.  With heavy users of this interface (e.g. XFS)
> and limited vmalloc space on 32-bit, vmap block exhaustion is a real
> problem.
> 
> Remove the guard page from the core vmap allocator.  vmalloc and the
> old vmap interface enforce a guard page on their own at a higher
> level.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Christoph Hellwig <hch@infradead.org>

If necessary, the guard page could be reintroduced as a debugging-only
option (CONFIG_DEBUG_PAGEALLOC?). Otherwise it seems reasonable.

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
