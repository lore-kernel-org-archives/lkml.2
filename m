Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab1CBR7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:59:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:48675 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab1CBR7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:59:06 -0500
Message-Id: <20110302175458.726109015@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:54:58 +0100
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
Subject: [PATCH 0/8] mm: Preemptibility -v9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series depends on the previous two series:
  - mm: Simplify anon_vma lifetime rules (merged by akpm)
  - mm: mmu_gather rework

These patches make part of the mm a lot more preemptible. It converts
i_mmap_lock and anon_vma->lock to mutexes which together with the mmu_gather
rework makes mmu_gather preemptible as well.

Making i_mmap_lock a mutex also enables a clean-up of the truncate code.

This also allows for preemptible mmu_notifiers, something that XPMEM I think
wants.

Furthermore, it removes the new and universially detested unmap_mutex.

