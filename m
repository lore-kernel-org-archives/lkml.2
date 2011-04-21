Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1DUQOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:14:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1DUQOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:14:20 -0400
Date: Thu, 21 Apr 2011 18:14:02 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>, akpm@linux-foundation.org,
        raz ben yehuda <raziebe@gmail.com>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: Check if PTE is already allocated during page fault
Message-ID: <20110421161402.GS5611@random.random>
References: <20110415101248.GB22688@suse.de>
 <BANLkTik7H+cmA8iToV4j1ncbQqeraCaeTg@mail.gmail.com>
 <20110421110841.GA612@suse.de>
 <20110421142636.GA1835@barrios-desktop>
 <20110421160057.GA28712@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421160057.GA28712@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 05:00:57PM +0100, Mel Gorman wrote:
> If you want to create a new patch with either your comment or mine
> (whichever you prefer) I'll add my ack. I'm about to drop offline
> for a few days but if it's still there Tuesday, I'll put together an
> appropriate patch and submit. I'd keep it separate from the other patch
> because it's a performance fix (which I'd like to see in -stable) where
> as this is more of a cleanup IMO.

I think the older patch should have more priority agreed. This one may
actually waste cpu cycles overall, rather than saving them, it
shouldn't be a common occurrence.

>From a code consistency point of view maybe we should just implement a
pte_alloc macro (to put after pte_alloc_map) and use it in both
places, and hide the glory details of the unlikely in the macro. When
implementing pte_alloc, I suggest also adding unlikely to both, I mean
we added unlikely to the fast path ok, but __pte_alloc is orders of
magnitude less likely to fail than pte_none, and it still runs 1 every
512 4k page faults, so I think __pte_alloc deserves an unlikely too.

Minchan, you suggested this cleanup, so I suggest you to send a patch,
but if you're busy we can help.

Thanks!
Andrea
