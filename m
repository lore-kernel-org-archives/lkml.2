Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab2JLAmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 20:42:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab2JLAmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 20:42:00 -0400
Date: Fri, 12 Oct 2012 02:41:33 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hillf Danton <dhillf@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Dan Smith <danms@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Christoph Lameter <cl@linux.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/33] AutoNUMA27
Message-ID: <20121012004133.GZ1818@redhat.com>
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com>
 <20121011101930.GM3317@csn.ul.ie>
 <20121011145611.GI1818@redhat.com>
 <20121011153503.GX3317@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011153503.GX3317@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 04:35:03PM +0100, Mel Gorman wrote:
> If System CPU time really does go down as this converges then that
> should be obvious from monitoring vmstat over time for a test. Early on
> - high usage with that dropping as it converges. If that doesn't happen
>   then the tasks are not converging, the phases change constantly or
> something unexpected happened that needs to be identified.

Yes, all measurable kernel cost should be in the memory copies
(migration and khugepaged, the latter is going to be optimized away).

The migrations must stop after the workload converges. Either
migrations are used to reach convergence or they shouldn't happen in
the first place (not in any measurable amount).

> Ok. Are they separate STREAM instances or threads running on the same
> arrays? 

My understanding is separate instances. I think it's a single threaded
benchmark and you run many copies. It was modified to run for 5min
(otherwise upstream has not enough time to get it wrong, as result of
background scheduling jitters).

Thanks!
