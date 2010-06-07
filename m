Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab0FGLVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:21:35 -0400
Received: from [18.85.46.34] ([18.85.46.34]:37754 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab0FGLUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:20:38 -0400
Message-Id: <20100607110654.606530953@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Jun 2010 13:06:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 00/28] mm: preemptibility -v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set makes part of the mm a lot more preemptible. It converts
i_mmap_lock and anon_vma->lock to mutexes and makes mmu_gather fully
preemptible.

The main motivation was making mm_take_all_locks() preemptible, since it
appears people are nesting hundreds of spinlocks there.

The side-effects are that can finally make mmu_gather preemptible,
something which lots of people have wanted to do for a long time.

It also gets us anon_vma refcounting, which seems to result in a nice
cleanup of the anon_vma lifetime rules wrt KSM and compaction.

This patch-set it build and boot-tested on x86_64 (a previous version was
also tested on Dave's Niagra2 machines, and I suppose s390 did too when
Martin provided the conversion patch for his arch).

There are no known architectures left unconverted, although some arch code
never did see a compiler (superh and um come to mind).

Can we move this work forwards, or is there anything people would want to
see done?

[ The series includes Rik's latest patches to the same area for
convenience ]


