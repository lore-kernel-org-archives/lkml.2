Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0FPBpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 21:45:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38505 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0FPBpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 21:45:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Jun 2010 10:40:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
Message-Id: <20100616104036.b45d352b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C182097.2070603@redhat.com>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	<1276514273-27693-13-git-send-email-mel@csn.ul.ie>
	<4C16A567.4080000@redhat.com>
	<20100615114510.GE26788@csn.ul.ie>
	<4C17815A.8080402@redhat.com>
	<20100615135928.GK26788@csn.ul.ie>
	<4C178868.2010002@redhat.com>
	<20100615141601.GL26788@csn.ul.ie>
	<20100616091755.7121c7d3.kamezawa.hiroyu@jp.fujitsu.com>
	<4C181AFD.5060503@redhat.com>
	<20100616093958.00673123.kamezawa.hiroyu@jp.fujitsu.com>
	<4C182097.2070603@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 20:53:43 -0400
Rik van Riel <riel@redhat.com> wrote:

> On 06/15/2010 08:39 PM, KAMEZAWA Hiroyuki wrote:
> 
> > Hmm, or do you recommend no-dirty-page-writeback when a memcg hits limit ?
> > Maybe we'll see much swaps.
> >
> > I want to go with this for a while, changing memcg's behavior will took
> > some amounts of time, there are only a few developpers.
> 
> One thing we can do, for kswapd, memcg and direct reclaim alike,
> is to tell the flusher threads to flush pages related to a pageout
> candidate page to disk.
> 
> That way the reclaiming processes can wait on some disk IO to
> finish, while the flusher thread takes care of the actual flushing.
> 
> That should also fix the "kswapd filesystem IO has really poor IO
> patterns" issue.
> 
> There's no reason not to fix this issue the right way.
> 
yes. but this patch just stops writeback. I think it's sane to ask
not to change behavior until there are some useful changes in flusher
threads.

IMO, until flusher threads can work with I/O cgroup, memcg shoudln't
depend on it because writeback allows stealing resource without it.

Thanks,
-Kame

