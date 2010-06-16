Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0FPBjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 21:39:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab0FPBjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 21:39:52 -0400
Message-ID: <4C182097.2070603@redhat.com>
Date: Tue, 15 Jun 2010 20:53:43 -0400
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
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>	<1276514273-27693-13-git-send-email-mel@csn.ul.ie>	<4C16A567.4080000@redhat.com>	<20100615114510.GE26788@csn.ul.ie>	<4C17815A.8080402@redhat.com>	<20100615135928.GK26788@csn.ul.ie>	<4C178868.2010002@redhat.com>	<20100615141601.GL26788@csn.ul.ie>	<20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com>	<4C181AFD.5060503@redhat.com> <20100616093958.00673123.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100616093958.00673123.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 08:39 PM, KAMEZAWA Hiroyuki wrote:

> Hmm, or do you recommend no-dirty-page-writeback when a memcg hits limit ?
> Maybe we'll see much swaps.
>
> I want to go with this for a while, changing memcg's behavior will took
> some amounts of time, there are only a few developpers.

One thing we can do, for kswapd, memcg and direct reclaim alike,
is to tell the flusher threads to flush pages related to a pageout
candidate page to disk.

That way the reclaiming processes can wait on some disk IO to
finish, while the flusher thread takes care of the actual flushing.

That should also fix the "kswapd filesystem IO has really poor IO
patterns" issue.

There's no reason not to fix this issue the right way.

-- 
All rights reversed
