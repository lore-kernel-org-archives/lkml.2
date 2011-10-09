Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1JIIDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 04:03:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61457 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1JIIDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 04:03:05 -0400
Date: Sun, 9 Oct 2011 17:02:55 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        akpm@linux-foundation.org, Josh Boyer <jwboyer@redhat.com>,
        aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmscan: Limit direct reclaim for higher order
 allocations
Message-ID: <20111009080255.GC23003@barrios-desktop>
References: <1318000643-27996-1-git-send-email-mgorman@suse.de>
 <1318000643-27996-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318000643-27996-2-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 04:17:22PM +0100, Mel Gorman wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> When suffering from memory fragmentation due to unfreeable pages,
> THP page faults will repeatedly try to compact memory.  Due to the
> unfreeable pages, compaction fails.
> 
> Needless to say, at that point page reclaim also fails to create
> free contiguous 2MB areas.  However, that doesn't stop the current
> code from trying, over and over again, and freeing a minimum of 4MB
> (2UL << sc->order pages) at every single invocation.
> 
> This resulted in my 12GB system having 2-3GB free memory, a
> corresponding amount of used swap and very sluggish response times.
> 
> This can be avoided by having the direct reclaim code not reclaim from
> zones that already have plenty of free memory available for compaction.
> 
> If compaction still fails due to unmovable memory, doing additional
> reclaim will only hurt the system, not help.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kinds regards,
Minchan Kim
