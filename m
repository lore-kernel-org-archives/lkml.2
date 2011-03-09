Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1CICPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:15:49 -0500
Received: from mout.perfora.net ([74.208.4.195]:58515 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1CICPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:15:47 -0500
Date: Tue, 8 Mar 2011 21:15:25 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] enable writing to /proc/pid/mem
Message-ID: <20110309021524.GA4838@fibrous.localdomain>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca> <20110309013017.GY22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309013017.GY22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:T1oZiK2W04O7QGauYbM2xRlUJL9tZ150fODH9vA9nHA
 D+SBJb++/mEpnIxXvmSkQrWw9eqTGzuKwsU3EaG4rrzcyDZ+rr
 RM2U2Oku/14MgeL3xE5kofH1BGOq/MuHBEc6q5K2NLWduJh3Pn
 jPBpIXYml2zs2d2RNEaQWamweX/eQLTSSlWyI3Vofq48vxpB/e
 jZXj8kFY2knn6MpviE7IxfjmcdqdzwKfCIR0imm0MA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 01:30:17AM +0000, Al Viro wrote:
> On Tue, Mar 08, 2011 at 07:42:17PM -0500, Stephen Wilson wrote:
> > This patch series enables safe writes to /proc/pid/mem.  The principle strategy
> > is to get a reference to the target task's mm before the permission check, and
> > to hold that reference until after the write completes.
> 
> One note: I'd rather prefer approach similar to mm_for_maps().  IOW, instead
> of "check, then get mm, then check _again_ to decide if we are allowed to
> use it", just turn check_mm_permissions() into a function that returns
> you a safe mm or gives you NULL (or, better yet, ERR_PTR(...)).  With all
> checks done within that sucker.

OK.  That certainly makes a lot of sense.  That can easily be added as
an additional patch to the series so that it is perfectly clear as to
what has been changed and how.

I think we could also remove the intermediate copy in both mem_read() and
mem_write() as well, but I think such optimizations could be left for
follow on patches.

> Then mem_read() and mem_write() wouldn't need to recheck anything again
> and the same helper would be usable for other things as well.  I mean
> something like this: (*WARNING* - completely untested)

Will work this into the series, test it, etc.


Thanks!


-- 
steve

