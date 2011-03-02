Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab1CBR7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:59:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:48739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab1CBR7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:59:32 -0500
Message-Id: <20110302175004.222724818@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:50:04 +0100
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
Subject: [PATCH 00/13] mm: mmu_gather rework -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the existing mmu_gather infrastructure.

The direct purpose of these patches was to allow preemptible mmu_gather,
but even without that I think these patches provide an improvement to the
status quo.

The first 10 patches rework the mmu_gather infrastructure. For review purpose
I've split them into generic and per-arch patches with the last of those a
generic cleanup.

For the final commit I would provide a roll-up of these patches so as not
to wreck bisectability of non generic archs.

The next patch provides generic RCU page-table freeing, and the follow up
is a patch converting s390 to use this. I've also got 4 patches from
DaveM lined up (not included in this series) that uses this to implement
gup_fast() for sparc64.

Then there is one patch that extends the generic mmu_gather batching.


