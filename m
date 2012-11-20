Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2KTMcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:32:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47744 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2KTMcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:32:02 -0500
Date: Tue, 20 Nov 2012 13:31:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] x86/mm: Don't flush the TLB on #WP pmd fixups
Message-ID: <20121120123156.GA15798@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <alpine.DEB.2.00.1211191644340.24618@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1211191703270.24618@chino.kir.corp.google.com>
 <20121120060014.GA14065@gmail.com>
 <alpine.DEB.2.00.1211192213420.5498@chino.kir.corp.google.com>
 <20121120074445.GA14539@gmail.com>
 <alpine.DEB.2.00.1211200001420.16449@chino.kir.corp.google.com>
 <20121120090637.GA14873@gmail.com>
 <20121120120251.GA15742@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120120251.GA15742@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > numa/core profile:
> > 
> >     95.66%  perf-1201.map     [.] 0x00007fe4ad1c8fc7                 
> >      1.70%  libjvm.so         [.] 0x0000000000381581                 
> >      0.59%  [vdso]            [.] 0x0000000000000607                 
> >      0.19%  [kernel]          [k] do_raw_spin_lock                   
> >      0.11%  [kernel]          [k] generic_smp_call_function_interrupt
> >      0.11%  [kernel]          [k] timekeeping_get_ns.constprop.7     
> >      0.08%  [kernel]          [k] ktime_get                          
> >      0.06%  [kernel]          [k] get_cycles                         
> >      0.05%  [kernel]          [k] __native_flush_tlb                 
> >      0.05%  [kernel]          [k] rep_nop                            
> >      0.04%  perf              [.] add_hist_entry.isra.9              
> >      0.04%  [kernel]          [k] rcu_check_callbacks                
> >      0.04%  [kernel]          [k] ktime_get_update_offsets           
> >      0.04%  libc-2.15.so      [.] __strcmp_sse2                      
> > 
> > No page fault overhead (see the page fault rate further below) 
> > - the NUMA scanning overhead shows up only through some mild 
> > TLB flush activity (which I'll fix btw).
> 
> The patch attached below should get rid of that mild TLB 
> flushing activity as well.

This has further increased SPECjbb from 203k/sec to 207k/sec, 
i.e. it's now 5% faster than mainline - THP enabled.

The profile is now totally flat even during a full 32-WH SPECjbb 
run, with the highest overhead entries left all related to timer 
IRQ processing or profiling. That is on a system that should be 
very close to yours.

Thanks,

	Ingo
