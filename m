Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab1CCSJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:09:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44334 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab1CCSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:09:51 -0500
Date: Thu, 3 Mar 2011 19:09:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110303180946.GK32215@one.firstfloor.org>
References: <1299113128-11349-1-git-send-email-andi@firstfloor.org> <1299113128-11349-9-git-send-email-andi@firstfloor.org> <20110303091827.GC2245@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303091827.GC2245@cmpxchg.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:18:27AM +0100, Johannes Weiner wrote:
> On Wed, Mar 02, 2011 at 04:45:28PM -0800, Andi Kleen wrote:
> > --- a/include/linux/vmstat.h
> > +++ b/include/linux/vmstat.h
> > @@ -58,6 +58,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
> >  		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
> >  		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
> >  		UNEVICTABLE_MLOCKFREED,
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	        THP_FAULT_ALLOC,
> > +		THP_COLLAPSE_ALLOC,	
> > +		THP_FAULT_FALLBACK,	
> 
> Wouldn't this better be named THP_FAULT_ALLOC_FAIL?  After all, it
> counts allocation failures, not what results from them.

It doesn't really fail anything for the user, so I thought fallback
was better.

> 
> Secondly, the order does not match the strings, it will report the
> THP_COLLAPSE_ALLOC item as "thp_fault_fallback" and vice versa.


Oops, I broke that while merging Andrea's change. Will resend.

> Can you make this "_failed" instead, to match the enum symbol?  Andrea
> wasn't sure which was better, "failure" or "failed".  Right now, we
> have two instances of "fail" and two instances of "failed" in
> /proc/vmstat, it's probably best not to introduce a third one.

Okay.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
