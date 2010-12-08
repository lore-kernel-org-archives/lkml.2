Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab0LHCC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:02:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48200 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab0LHCCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 21:02:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 8 Dec 2010 10:56:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v4 2/7] deactivate invalidated pages
Message-Id: <20101208105637.5103de75.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTimtkb7Nczhads4u3r21RJauZvviLFkXjaL1ErDb@mail.gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<d57730effe4b48012d31ceca07938ed3eb401aba.1291568905.git.minchan.kim@gmail.com>
	<20101207144923.GB2356@cmpxchg.org>
	<20101207150710.GA26613@barrios-desktop>
	<20101207151939.GF2356@cmpxchg.org>
	<20101207152625.GB608@barrios-desktop>
	<20101207155645.GG2356@cmpxchg.org>
	<AANLkTi=iNGT_p_VfW9GxdaKXLt2xBHM2jdwmCbF_u8uh@mail.gmail.com>
	<20101208095642.8128ab33.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTimtkb7Nczhads4u3r21RJauZvviLFkXjaL1ErDb@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010 10:43:08 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi Kame,
> 
Hi,

> > I wonder ...how about adding "victim" list for "Reclaim" pages ? Then, we don't need
> > extra LRU rotation.
> 
> It can make the code clean.
> As far as I think, victim list does following as.
> 
> 1. select victim pages by strong hint
> 2. move the page from LRU to victim
> 3. reclaimer always peeks victim list before diving into LRU list.
> 4-1. If the victim pages is used by others or dirty, it can be moved
> into LRU, again or remain the page in victim list.
> If the page is remained victim, when do we move it into LRU again if
> the reclaimer continues to fail the page?
When sometone touches it.

> We have to put the new rule.
> 4-2. If the victim pages isn't used by others and clean, we can
> reclaim the page asap.
> 
> AFAIK, strong hints are just two(invalidation, readahead max window heuristic).
> I am not sure it's valuable to add new hierarchy(ie, LRU, victim,
> unevictable) for cleaning the minor codes.
> In addition, we have to put the new rule so it would make the LRU code
> complicated.
> I remember how unevictable feature merge is hard.
> 
yes, it was hard.

> But I am not against if we have more usecases. In this case, it's
> valuable to implement it although it's not easy.
> 

I wonder "victim list" can be used for something like Cleancache, when
we have very-low-latency backend devices.
And we may able to have page-cache-limit, which Balbir proposed as.

  - kvictimed? will move unmappedd page caches to victim list
This may work like a InactiveClean list which we had before and make
sizing easy.

Thanks,
-Kame



