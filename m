Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab0FPAcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 20:32:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970Ab0FPAc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 20:32:28 -0400
Message-ID: <4C181AFD.5060503@redhat.com>
Date: Tue, 15 Jun 2010 20:29:49 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>	<1276514273-27693-13-git-send-email-mel@csn.ul.ie>	<4C16A567.4080000@redhat.com>	<20100615114510.GE26788@csn.ul.ie>	<4C17815A.8080402@redhat.com>	<20100615135928.GK26788@csn.ul.ie>	<4C178868.2010002@redhat.com>	<20100615141601.GL26788@csn.ul.ie> <20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 08:17 PM, KAMEZAWA Hiroyuki wrote:
> On Tue, 15 Jun 2010 15:16:01 +0100
> Mel Gorman<mel@csn.ul.ie>  wrote:

>> But in turn, where is mem_cgroup_hierarchical_reclaim called from direct
>> reclaim? It appears to be only called from the fault path or as a result
>> of the memcg changing size.
>>
> yes. It's only called from
> 	- page fault
> 	- add_to_page_cache()
>
> I think we'll see no stack problem. Now, memcg doesn't wakeup kswapd for
> reclaiming memory, it needs direct writeback.

Of course, a memcg page fault could still be triggered
from copy_to_user or copy_from_user, with a fairly
arbitrary stack frame above...

-- 
All rights reversed
