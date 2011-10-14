Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab1JNOTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:19:25 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46208 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754632Ab1JNOTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:19:23 -0400
Date: Fri, 14 Oct 2011 09:19:21 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
Message-ID: <20111014141921.GC28592@sgi.com>
References: <20111012120118.e948f40a.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1110121452220.31218@router.home>
 <20111013152355.GB6966@sgi.com>
 <alpine.DEB.2.00.1110131052300.18473@router.home>
 <20111013135032.7c2c54cd.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1110131602020.26553@router.home>
 <20111013142434.4d05cbdc.akpm@linux-foundation.org>
 <20111014122506.GB26737@sgi.com>
 <20111014135055.GA28592@sgi.com>
 <alpine.DEB.2.00.1110140856420.6411@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110140856420.6411@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 08:57:16AM -0500, Christoph Lameter wrote:
> On Fri, 14 Oct 2011, Dimitri Sivanich wrote:
> 
> > Testing on a smaller machine with 46 writer threads in parallel (my original
> > test used 120).
> >
> > Looks as though cache-aligning and padding the end of the vm_stat array
> > results in a ~150 MB/sec speedup.  This is a nice improvement for only 46
> > writer threads, though it's not the full ~250 MB/sec speedup I get from
> > setting OVERCOMMIT_NEVER.
> 
> Add to this the increase in the deltas for the ZVCs and change the stat
> interval to 10 sec?

Increasing the ZVC deltas (threshold value in calculate*threshold == 125)
does -seem- to give a small speedup in this case (maybe as much as 50 MB/sec?).

Changing the stat interval to 10 seconds still has no effect, with or without
the ZVC delta change.

