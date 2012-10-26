Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab2JZMsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:48:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:65209 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740Ab2JZMsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:48:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208";a="232902316"
From: Andi Kleen <andi@firstfloor.org>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 05/31] x86/mm: Reduce tlb flushes from ptep_set_access_flags()
References: <20121025121617.617683848@chello.nl>
	<20121025124832.840241082@chello.nl>
	<CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com>
	<5089F5B5.1050206@redhat.com>
	<CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
	<508A0A0D.4090001@redhat.com>
	<CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
	<CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
Date: Fri, 26 Oct 2012 05:48:03 -0700
In-Reply-To: <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
	(Michel Lespinasse's message of "Fri, 26 Oct 2012 05:34:02 -0700")
Message-ID: <m2pq45qu0s.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> writes:

> On Thu, Oct 25, 2012 at 9:23 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Oct 25, 2012 at 8:57 PM, Rik van Riel <riel@redhat.com> wrote:
>>>
>>> That may not even be needed.  Apparently Intel chips
>>> automatically flush an entry from the TLB when it
>>> causes a page fault.  I assume AMD chips do the same,
>>> because flush_tlb_fix_spurious_fault evaluates to
>>> nothing on x86.
>>
>> Yes. It's not architected as far as I know, though. But I agree, it's
>> possible - even likely - we could avoid TLB flushing entirely on x86.
>
> Actually, it is architected on x86. This was first described in the
> intel appnote 317080 "TLBs, Paging-Structure Caches, and Their
> Invalidation", last paragraph of section 5.1. Nowadays, the same
> contents are buried somewhere in Volume 3 of the architecture manual
> (in my copy: 4.10.4.1 Operations that Invalidate TLBs and
> Paging-Structure Caches)

This unfortunately would only work for processes with no threads
because it only works on the current logical CPU.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
