Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2J0K3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 06:29:50 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63497 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2J0K3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 06:29:47 -0400
Date: Sat, 27 Oct 2012 12:29:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] x86,mm: drop TLB flush from ptep_set_access_flags
Message-ID: <20121027102941.GA27049@gmail.com>
References: <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
 <508A0A0D.4090001@redhat.com>
 <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
 <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
 <m2pq45qu0s.fsf@firstfloor.org>
 <508A8D31.9000106@redhat.com>
 <20121026132601.GC9886@gmail.com>
 <20121026144502.6e94643e@dull>
 <20121026221254.7d32c8bf@pyramind.ukuu.org.uk>
 <508B59B0.5010503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508B59B0.5010503@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> On 10/26/2012 05:12 PM, Alan Cox wrote:
> >On Fri, 26 Oct 2012 14:45:02 -0400
> >Rik van Riel <riel@redhat.com> wrote:
> >
> >>Intel has an architectural guarantee that the TLB entry causing
> >>a page fault gets invalidated automatically. This means
> >>we should be able to drop the local TLB invalidation.
> >>
> >>Because of the way other areas of the page fault code work,
> >>chances are good that all x86 CPUs do this.  However, if
> >>someone somewhere has an x86 CPU that does not invalidate
> >>the TLB entry causing a page fault, this one-liner should
> >>be easy to revert.
> >
> >This does not strike me as a good standard of validation for such a change
> >
> >At the very least we should have an ACK from AMD and from VIA, and
> >preferably ping RDC and some of the other embedded folks. Given an AMD
> >and VIA ACK I'd be fine. I doubt anyone knows any more what Cyrix CPUs
> >did or cared about and I imagine H Peter or Linus can answer for
> >Transmeta ;-)
> 
> Fair enough.
> 
> If it turns out any of those CPUs need an explicit flush, then 
> we can also adjust flush_tlb_fix_spurious_fault to actually do 
> a local flush on x86 (or at least on those CPUs).

Yes. And even if we have 'confirmation' from documentation and 
elsewhere, testing has to be done to see actual real behavior of 
CPUs, so this is going to be a separate, bisectable commit put 
under surveillance ;-)

Thanks,

	Ingo
