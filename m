Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab1BQRhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:37:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53544 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab1BQRhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:37:00 -0500
Subject: Re: [PATCH 0/8] mm: Preemptibility -v8
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <20110217170520.229881980@chello.nl>
References: <20110217170520.229881980@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Feb 2011 18:36:24 +0100
Message-ID: <1297964184.2413.2029.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 18:05 +0100, Peter Zijlstra wrote:
> This series depends on the previous two series:
>   - mm: Simplify anon_vma lifetime rules
>   - mm: mmu_gather rework
> 
> These patches make part of the mm a lot more preemptible. It converts
> i_mmap_lock and anon_vma->lock to mutexes which together with the mmu_gather
> rework makes mmu_gather preemptible as well.
> 
> Making i_mmap_lock a mutex also enables a clean-up of the truncate code.
> 
> This also allows for preemptible mmu_notifiers, something that XPMEM I think
> wants.

---
 Documentation/lockstat.txt   |    2 
 Documentation/vm/locking     |    2 
 arch/x86/mm/hugetlbpage.c    |    4 
 fs/gfs2/main.c               |    2 
 fs/hugetlbfs/inode.c         |    4 
 fs/inode.c                   |    2 
 fs/nilfs2/page.c             |    2 
 include/linux/fs.h           |    3 
 include/linux/huge_mm.h      |    8 -
 include/linux/lockdep.h      |    3 
 include/linux/mm.h           |    2 
 include/linux/mm_types.h     |    1 
 include/linux/mmu_notifier.h |    2 
 include/linux/mutex.h        |    9 +
 include/linux/rmap.h         |   29 +-----
 kernel/fork.c                |    5 -
 kernel/mutex.c               |   25 +++--
 mm/filemap.c                 |   10 +-
 mm/filemap_xip.c             |    4 
 mm/fremap.c                  |    4 
 mm/huge_memory.c             |    4 
 mm/hugetlb.c                 |   14 +--
 mm/memory-failure.c          |    4 
 mm/memory.c                  |  197 ++++++-------------------------------------
 mm/migrate.c                 |   17 ---
 mm/mmap.c                    |   43 +++------
 mm/mremap.c                  |    7 -
 mm/rmap.c                    |  171 +++++++++++++++++++++++++++++--------
 28 files changed, 258 insertions(+), 322 deletions(-)

