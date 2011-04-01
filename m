Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab1DANms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:42:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab1DANjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:39:09 -0400
Message-Id: <20110401121258.211963744@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 01 Apr 2011 14:12:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: [PATCH 00/20] mm: Preemptibility -v10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another -rc1, another posting.

Rework the existing mmu_gather infrastructure.

The direct purpose of these patches was to allow preemptible mmu_gather,
but even without that I think these patches provide an improvement to the
status quo.

The first 9 patches rework the mmu_gather infrastructure. For review purpose
I've split them into generic and per-arch patches with the last of those a
generic cleanup.

Also provided is a rollup of these patches, which is used as a commit in the
git tree referenced below.

The next patch provides generic RCU page-table freeing, and the follow up
is a patch converting s390 to use this. I've also got 4 patches from
DaveM lined up (not included in this series) that uses this to implement
gup_fast() for sparc64.

Then there is one patch that extends the generic mmu_gather batching.

After that follow the mm preemptibility patches, these make part of the mm a
lot more preemptible. It converts i_mmap_lock and anon_vma->lock to mutexes
which together with the mmu_gather rework makes mmu_gather preemptible as well.

Making i_mmap_lock a mutex also enables a clean-up of the truncate code.

This also allows for preemptible mmu_notifiers, something that XPMEM I think
wants.

Furthermore, it removes the new and universially detested unmap_mutex.

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_gather.git

