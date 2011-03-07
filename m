Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1CGRvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:51:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1CGRto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:49:44 -0500
Message-Id: <20110307171350.989666626@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 07 Mar 2011 18:13:50 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King <rmk@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][PATCH 00/15] Unify TLB gather implementations -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series that attempts to unify and fix the current tlb gather
implementations. Only s390 is left unconverted and most aren't event compiled
but other than that its mostly complete (ia64, arm, sh are compile tested).

This second installment doesn't try to change flush_tlb_range() for all
architectures but simply uses a fake vma and fills in VM_EXEC and VM_HUGETLB.

This series depends on the mmu_gather rework -v2 series send last week:
  https://lkml.org/lkml/2011/3/2/323

which is also available (including the anon_vma refcount simplification,
mm preemtibilidy and davem's sparc64 gup_fast implementation) as a git tree
based on next-20110307:
  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_gather.git mmu_gather

The whole series, including the depending patches is available through:
  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_gather.git mmu_unify

