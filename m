Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0GFKMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:12:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44921 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab0GFKMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:12:53 -0400
Date: Tue, 6 Jul 2010 11:12:35 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100706101235.GE13780@csn.ul.ie>
References: <20100702125155.69c02f85.akpm@linux-foundation.org> <20100705134949.GC13780@csn.ul.ie> <20100706093529.CCD1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100706093529.CCD1.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 09:36:41AM +0900, KOSAKI Motohiro wrote:
> Hello,
> 
> > Ok, that's reasonable as I'm still working on that patch. For example, the
> > patch disabled anonymous page writeback which is unnecessary as the stack
> > usage for anon writeback is less than file writeback. 
> 
> How do we examine swap-on-file?
> 

Anything in particular wrong with the following?

/*
 * For now, only kswapd can writeback filesystem pages as otherwise
 * there is a stack overflow risk
 */
static inline bool reclaim_can_writeback(struct scan_control *sc,
                                        struct page *page)
{
        return !page_is_file_cache(page) || current_is_kswapd();
}

Even if it is a swapfile, I didn't spot a case where the filesystems
writepage would be called. Did I miss something?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
