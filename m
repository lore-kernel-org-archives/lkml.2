Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2KUJej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:34:39 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64092 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab2KUJeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:34:37 -0500
Date: Wed, 21 Nov 2012 10:34:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH, v2] mm, numa: Turn 4K pte NUMA faults into effective
 hugepage ones
Message-ID: <20121121093431.GA25519@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <20121119191339.GA11701@gmail.com>
 <20121119211804.GM8218@suse.de>
 <20121119223604.GA13470@gmail.com>
 <CA+55aFzQYH4qW_Cw3aHPT0bxsiC_Q_ggy4YtfvapiMG7bR=FsA@mail.gmail.com>
 <20121120071704.GA14199@gmail.com>
 <20121120152933.GA17996@gmail.com>
 <20121120160918.GA18167@gmail.com>
 <alpine.DEB.2.00.1211201833080.2278@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211201833080.2278@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> Ok, this is significantly better, it almost cut the regression 
> in half on my system. [...]

The other half still seems to be related to the emulation faults 
that I fixed in the other patch:

>      0.49%  [kernel]          [k] page_fault                                               
>      0.06%  [kernel]          [k] emulate_vsyscall                                         

Plus TLB flush costs:

>      0.13%  [kernel]          [k] generic_smp_call_function_interrupt
>      0.08%  [kernel]          [k] flush_tlb_func

for which you should try the third patch I sent.

So please try all my fixes - the easiest way to do that would be 
to try the latest tip:master that has all related fixes 
integrated and send me a new perf top output - most page fault 
and TLB flush overhead should be gone from the profile.

Thanks,

	Ingo
