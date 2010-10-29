Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab0J2CXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 22:23:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60522 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0J2CXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 22:23:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 4/7] vmscan: narrowing synchrounous lumply reclaim condition
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20101028151201.GN29304@random.random>
References: <20101028162522.B0B5.A69D9226@jp.fujitsu.com> <20101028151201.GN29304@random.random>
Message-Id: <20101029104314.B0C0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 29 Oct 2010 11:23:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Oct 28, 2010 at 05:00:57PM +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > My tree uses compaction in a fine way inside kswapd too and tons of
> > > systems are running without lumpy and floods of order 9 allocations
> > > with only compaction (in direct reclaim and kswapd) without the
> > > slighest problem. Furthermore I extended compaction for all
> > > allocations not just that PAGE_ALLOC_COSTLY_ORDER (maybe I already
> > > removed all PAGE_ALLOC_COSTLY_ORDER checks?). There's no good reason
> > > not to use compaction for every allocation including 1,2,3, and things
> > > works fine this way.
> > 
> > Interesting. I parsed this you have compaction improvement. If so,
> > can you please post them? Generically, 1) improve the feature 2) remove
> > unused one is safety order. In the other hand, reverse order seems to has
> > regression risk.
> 
> THP is way higher priority than the compaction improvements, so the
> compaction improvements are not at the top of the queue:
> 
> http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=shortlog
> 
> http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commitdiff;h=d8f02410d718725a7daaf192af33abc41dcfae16;hp=39c4a61fedc5f5bf0c95a60483ac0acea1a9a757
> 
> At the top of the queue there is the lumpy_reclaim removal as that's
> higher priority than THP.

Umm... 

If THP vs lumpy confliction is most big matter, I'd prefer automatical 
lumpy disabling when THP enabled rather than completely removing. It is lower risk.
And, After finish to improve compaction, I expect we will be able to discuss
remove thing. 

If my parse is correct, You have tested "improved-compaction + no-lumpy + THP"
combination, but nobody have tested "current-compaction + no-lumpy". 
IOW, I only say I dislike a regression.





