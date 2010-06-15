Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab0FOOQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:16:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50668 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0FOOQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:16:20 -0400
Date: Tue, 15 Jun 2010 15:16:01 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100615141601.GL26788@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-13-git-send-email-mel@csn.ul.ie> <4C16A567.4080000@redhat.com> <20100615114510.GE26788@csn.ul.ie> <4C17815A.8080402@redhat.com> <20100615135928.GK26788@csn.ul.ie> <4C178868.2010002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4C178868.2010002@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:04:24AM -0400, Rik van Riel wrote:
> On 06/15/2010 09:59 AM, Mel Gorman wrote:
>> On Tue, Jun 15, 2010 at 09:34:18AM -0400, Rik van Riel wrote:
>>> On 06/15/2010 07:45 AM, Mel Gorman wrote:
>
>>>>>>
>>>>>> +/* kswapd and memcg can writeback as they are unlikely to overflow stack */
>>>>>> +static inline bool reclaim_can_writeback(struct scan_control *sc)
>>>>>> +{
>>>>>> +	return current_is_kswapd() || sc->mem_cgroup != NULL;
>>>>>> +}
>
>>> If direct reclaim can overflow the stack, so can direct
>>> memcg reclaim.  That means this patch does not solve the
>>> stack overflow, while admitting that we do need the
>>> ability to get specific pages flushed to disk from the
>>> pageout code.
>>>
>>
>> What path is taken with memcg != NULL that could overflow the stack? I
>> couldn't spot one but mm/memcontrol.c is a bit tangled so finding all
>> its use cases is tricky. The critical path I had in mind though was
>> direct reclaim and for that path, memcg == NULL or did I miss something?
>
> mem_cgroup_hierarchical_reclaim -> try_to_free_mem_cgroup_pages
>

But in turn, where is mem_cgroup_hierarchical_reclaim called from direct
reclaim? It appears to be only called from the fault path or as a result
of the memcg changing size.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
