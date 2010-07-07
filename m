Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0GGMwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:52:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0GGMwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:52:43 -0400
Message-ID: <4C347862.4020404@redhat.com>
Date: Wed, 07 Jul 2010 08:51:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Christoph Hellwig <hch@infradead.org>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
References: <20100702125155.69c02f85.akpm@linux-foundation.org> <20100705134949.GC13780@csn.ul.ie> <20100706093529.CCD1.A69D9226@jp.fujitsu.com> <20100706101235.GE13780@csn.ul.ie> <AANLkTin8FotAC1GvjuoYU9XA2eiSr6FWWh6bwypTdhq3@mail.gmail.com> <20100706152539.GG13780@csn.ul.ie> <20100706202758.GC18210@cmpxchg.org> <AANLkTimOkI95ZkJecE3jxRDDGbHvP9tRUluIoJuhqqMz@mail.gmail.com> <20100707002458.GI13780@csn.ul.ie> <20100707011533.GB3630@infradead.org> <20100707094310.GJ13780@csn.ul.ie>
In-Reply-To: <20100707094310.GJ13780@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2010 05:43 AM, Mel Gorman wrote:

> How do you suggest tuning this? The modification I tried was "if N dirty
> pages are found during a SWAP_CLUSTER_MAX scan of pages, assume an average
> dirtying density of at least that during the time those pages were inserted on
> the LRU. In response, ask the flushers to flush 1.5X". This roughly responds
> to the conditions it finds as they are encountered and is based on scanning
> rates instead of time. It seemed like a reasonable option.

Your idea sounds like something we need to have, regardless
of whether or not we fix the flusher to flush older inodes
first (we probably should do that, too).

I believe this for the simple reason that we could have too
many dirty pages in one memory zone, while the flusher's
dirty threshold is system wide.

If we both fix the flusher to flush old inodes first and
kick the flusher from the reclaim code, we should be
golden.

-- 
All rights reversed
