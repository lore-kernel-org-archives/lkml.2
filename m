Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0H1Oci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 10:32:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0H1Ocf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 10:32:35 -0400
Subject: Re: [PATCH 00/20] mm: Preemptibility -v4
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20100828141637.421594670@chello.nl>
References: <20100828141637.421594670@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 28 Aug 2010 16:32:08 +0200
Message-ID: <1283005928.1975.3548.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry folks, got Nick's old email in there (changed for this reply).

On Sat, 2010-08-28 at 16:16 +0200, Peter Zijlstra wrote:
> This patch-set makes part of the mm a lot more preemptible. It converts
> i_mmap_lock and anon_vma->lock to mutexes and makes mmu_gather fully
> preemptible.
> 
> The main motivation was making mm_take_all_locks() preemptible, since it
> appears people are nesting hundreds of spinlocks there.
> 
> The side-effects are that can finally make mmu_gather preemptible,
> something which lots of people have wanted to do for a long time.
> 
> It also gets us anon_vma refcounting, which seems to result in a nice
> cleanup of the anon_vma lifetime rules wrt KSM and compaction.
> 
> This patch-set it build and boot-tested on x86_64 (a previous version was
> also tested on Dave's Niagra2 machines, and I suppose s390 did too when
> Martin provided the conversion patch for his arch).
> 
> There are no known architectures left unconverted, although some arch code
> never did see a compiler (superh and ia64 come to mind, I'll try and 
> update my toolchains next week).
> 
> Yanmin ran the last posting through the comprehensive Intel test farm
> and didn't find any regressions.
> 
> ( Not included in this posting are the 4 Sparc64 patches that implement
>   gup_fast, those can be applied separately after this series gets 
>   anywhere. )
> 
> Full series (including the Sparc64 gup_fast bits) also available in -git
> form from (against Linus' tree as of about an hour ago):
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git mmu_preempt
> 
> Do people feel its ready to get added to -next?

