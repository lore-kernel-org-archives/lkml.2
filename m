Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2F2KDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:03:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37544 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab2F2KDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:03:07 -0400
Date: Fri, 29 Jun 2012 11:02:58 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, jaschut@sandia.gov,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH -mm v2] mm: have order > 0 compaction start off where it
 left
Message-ID: <20120629100258.GA13141@csn.ul.ie>
References: <20120628135520.0c48b066@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120628135520.0c48b066@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 01:55:20PM -0400, Rik van Riel wrote:
> Order > 0 compaction stops when enough free pages of the correct
> page order have been coalesced. When doing subsequent higher order
> allocations, it is possible for compaction to be invoked many times.
> 
> However, the compaction code always starts out looking for things to
> compact at the start of the zone, and for free pages to compact things
> to at the end of the zone.
> 
> This can cause quadratic behaviour, with isolate_freepages starting
> at the end of the zone each time, even though previous invocations
> of the compaction code already filled up all free memory on that end
> of the zone.
> 
> This can cause isolate_freepages to take enormous amounts of CPU
> with certain workloads on larger memory systems.
> 
> The obvious solution is to have isolate_freepages remember where
> it left off last time, and continue at that point the next time
> it gets invoked for an order > 0 compaction. This could cause
> compaction to fail if cc->free_pfn and cc->migrate_pfn are close
> together initially, in that case we restart from the end of the
> zone and try once more.
> 
> Forced full (order == -1) compactions are left alone.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Reported-by: Jim Schutt <jaschut@sandia.gov>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> v2: implement Mel's suggestions, handling wrap-around etc
> 

I have not tested it myself but it looks correct! Thanks very much.

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
