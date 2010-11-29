Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0K2CN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:13:58 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54040 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab0K2CN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:13:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [PATCH v2 1/3] deactivate invalidated pages
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <87pqto3n77.fsf@gmail.com>
References: <20101129090514.829C.A69D9226@jp.fujitsu.com> <87pqto3n77.fsf@gmail.com>
Message-Id: <20101129110848.82A8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 29 Nov 2010 11:13:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't like this change because fadvise(DONT_NEED) is rarely used
> > function and this PG_reclaim trick doesn't improve so much. In the
> > other hand, It increase VM state mess.
> > 
> 
> Can we please stop appealing to this argument? The reason that
> fadvise(DONT_NEED) is currently rarely employed is that the interface as
> implemented now is extremely kludgey to use.
> 
> Are you proposing that this particular implementation is not worth the
> mess (as opposed to putting the pages at the head of the inactive list
> as done earlier) or would you rather that we simply leave DONT_NEED in
> its current state? Even if today's gains aren't as great as we would
> like them to be, we should still make an effort to make fadvise()
> usable, if for no other reason than to encourage use in user-space so
> that applications can benefit when we finally do figure out how to
> properly account for the user's hints.

Hi

I'm not againt DONT_NEED feature. I only said PG_reclaim trick is not
so effective. Every feature has their own pros/cons. I think the cons
is too big. Also, nobody have mesured PG_reclaim performance gain. Did you?



