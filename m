Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1AYSco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:32:44 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:52655 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1AYScn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:32:43 -0500
Date: Tue, 25 Jan 2011 19:32:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 00/25] mm: Preemptibility -v7
Message-ID: <20110125183240.GA31346@merkur.ravnborg.org>
References: <20110125173111.720927511@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125173111.720927511@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 06:31:11PM +0100, Peter Zijlstra wrote:
> 
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
> This patch-set is build and boot-tested on x86_64 (a previous version was
> also tested on Dave's Niagra2 machines, and I suppose s390 was too when
> Martin provided the conversion patch for his arch).
> 
> There are no known architectures left unconverted.

Hi Peter.

Foregive me my ignorance..
Why is this relevant for sparc64 but not for sparc32?

A quick grep showed up only this in sparc32 specific files:

mm/init_32.c:DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);

Maybe this is just something sparc32 does not support?

	Sam
