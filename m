Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0DBO2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 10:28:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:39615 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208Ab0DBO1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:27:22 -0400
Message-Id: <20100402141601.435955404@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 02 Apr 2010 16:16:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/7] mm: preemptibility
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This (incomplete) patch-set makes part of the mm a lot more preemptible.
It converts i_mmap_lock and anon_vma->lock to mutexes.
On the way there it also makes mmu_gather preemptible.

The main motivation was making mm_take_all_locks() preemptible, since
it appears people are nesting hundreds of spinlocks there.

The side-effects are that we can finally make mmu_gather preemptible,
something which lots of people have wanted to do for a long time.

It also gets us anon_vma refcounting which seems to be wanted by
KSM as well as Mel's compaction work.

This patch set seems to build and boot on my x86_64 machine and even
builds a kernel. I'll work on getting PPC working again and audit other
architectures their mmu_gather implementation.

