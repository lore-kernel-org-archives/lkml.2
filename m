Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab1D1JCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:02:47 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:42510 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab1D1JCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:02:45 -0400
Date: Thu, 28 Apr 2011 11:02:38 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 5/8] compaction: remove active list counting
Message-ID: <20110428090238.GK12437@cmpxchg.org>
References: <cover.1303833415.git.minchan.kim@gmail.com>
 <2b79bbf9ddceb73624f49bbe9477126147d875fd.1303833417.git.minchan.kim@gmail.com>
 <20110427171505.5d7bf485.kamezawa.hiroyu@jp.fujitsu.com>
 <BANLkTim8B7R_9jtBOLS6F_OYJJMwgcG-0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim8B7R_9jtBOLS6F_OYJJMwgcG-0Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 08:42:28AM +0900, Minchan Kim wrote:
> On Wed, Apr 27, 2011 at 5:15 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Wed, 27 Apr 2011 01:25:22 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> acct_isolated of compaction uses page_lru_base_type which returns only
> >> base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
> >> So it's pointless to add lru[LRU_ACTIVE_[ANON|FILE]] to get sum.
> >>
> >> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >> Cc: Mel Gorman <mgorman@suse.de>
> >> Cc: Rik van Riel <riel@redhat.com>
> >> Cc: Andrea Arcangeli <aarcange@redhat.com>
> >> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> >
> > I think some comments are necessary to explain why INACTIVE only.
> 
> As alternative, I can change page_lru_base_type with page_lru.
> It's not hot path so I will do.

We immediately use those numbers to account
NR_ISOLATED_ANON/NR_ISOLATED_FILE - i.e. 'lru base types', so I think
using page_lru_base_type() makes perfect sense.
